// TODO: Honestly, I think this whole unit needs a clean rewrite. What started
// out as the best approach turned out to just get more complicated over time.

import * as IL from './il';
import * as VM from './virtual-machine-types';
import { notImplemented, assertUnreachable, hardAssert, notUndefined, unexpected, invalidOperation, entries, stringifyIdentifier, todo, stringifyStringLiteral } from './utils';
import * as _ from 'lodash';
import { vm_Reference, mvm_Value, vm_TeWellKnownValues, TeTypeCode, UInt8, UInt4, isUInt12, isSInt14, isSInt32, isUInt16, isUInt4, isSInt8, isUInt8, SInt8, isSInt16, UInt16, SInt16, isUInt14, mvm_TeError, mvm_TeBytecodeSection, mvm_TeBuiltins  } from './runtime-types';
import { stringifyOperation } from './stringify-il';
import { BinaryRegion, Future, FutureLike, Labelled } from './binary-region';
import { HTML, Format, BinaryData } from './visual-buffer';
import * as formats from './snapshot-binary-html-formats';
import escapeHTML from 'escape-html';
import { SnapshotClass } from './snapshot';
import { vm_TeOpcode, vm_TeOpcodeEx1, vm_TeOpcodeEx2, vm_TeOpcodeEx3, vm_TeSmallLiteralValue, vm_TeNumberOp, vm_TeBitwiseOp } from './bytecode-opcodes';
import { SnapshotIL, validateSnapshotBinary, BYTECODE_VERSION, ENGINE_VERSION } from './snapshot-il';
import { crc16ccitt } from 'crc';
import { SnapshotReconstructionInfo } from './decode-snapshot';

type MemoryRegionID = 'bytecode' | 'gc' | 'globals';

// A referenceable is something that can produce a reference pointer, if you
// tell it where it's pointing from
type Referenceable = {
  getPointer: (sourceRegion: MemoryRegionID) => Future<mvm_Value>;
  // Offset in bytecode
  offset: Future<number>;
}

export function encodeSnapshot(snapshot: SnapshotIL, generateDebugHTML: boolean): {
  snapshot: SnapshotClass,
  html?: HTML
} {
  /*
   * # A note about the implementation here
   *
   * I found it was easiest to write this imperatively. This function has a
   * variable `bytecode` which is like a buffer, and then calls
   * `bytecode.append` to add things into the bytecode, in order.
   *
   * To make forward-references easy in this scheme, the `bytecode` is not
   * actually a buffer but rather a lazy representation of a buffer (I've called
   * this a `BinaryRegion`). It is something that you can call `toBuffer` on at
   * the end to get the buffer, but until that point, you can do interesting
   * things like:
   *
   *   1. Append `Future` values, which are values of a known size but unknown
   *      content, like a forward-reference. You can then use `Future.assign` to
   *      give the future a value when you have it.
   *
   *   2. You can append other BinaryRegions to a BinaryRegion (with
   *      `.addBuffer`), recursively, to create subregions. These BinaryRegions
   *      can expand with more content even after they've been inserted into
   *      their parent.
   *
   *   3. BinaryRegion.currentOffset gives you a lazy (Future) representation of
   *      what the offset will be at the current append cursor (since it may
   *      move as BinaryRegions below it expand, so its final value is not known
   *      until the end).
   *
   * These make this function almost declarative: in general, the order of
   * `append`s in the code "declares" the order of the corresponding fields in
   * bytecode. Forward references are declared as Futures ahead of time.
   *
   * The BinaryRegion generates both the binary output and a corresponding HTML
   * representation. This is done by having the `.append` method accept a format
   * that specifies both the binary encoding and HTML encoding of the
   * corresponding element. See `formats` for the formats listed here.
   *
   * The actual implementation here is not very clean. I assumed it would be
   * less complicated than it turned out to be, so it's grown organically and is
   * a little hard to follow.
   */

  const bytecode = new BinaryRegion(formats.tableContainer);

  const names: SnapshotReconstructionInfo['names'] = {};
  const romAllocations = new BinaryRegion();
  const gcAllocations = new BinaryRegion();
  const importTable = new BinaryRegion();
  const largePrimitives = new BinaryRegion();
  const handlesRegion = new BinaryRegion();

  const largePrimitivesMemoizationTable = new Array<{ data: Buffer, reference: Future<mvm_Value> }>();
  const importLookup = new Map<IL.HostFunctionID, number>();
  const strings = new Map<string, Future<vm_Reference>>();
  const globalSlotIndexMapping = new Map<VM.GlobalSlotID, number>();

  let importCount = 0;

  const headerSize = new Future();
  const bytecodeSize = new Future();
  const crcRangeStart = new Future();
  const crcRangeEnd = new Future();

  const sectionOffsets: Future[] = [];
  for (let i = 0; i < mvm_TeBytecodeSection.BCS_SECTION_COUNT; i++)  {
    sectionOffsets[i] = new Future();
  }

  type SectionWriter = () => void;
  const sectionWriters: Record<mvm_TeBytecodeSection, SectionWriter> = {
    [mvm_TeBytecodeSection.BCS_IMPORT_TABLE]: writeImportTable,
    [mvm_TeBytecodeSection.BCS_EXPORT_TABLE]: writeExportTable,
    [mvm_TeBytecodeSection.BCS_SHORT_CALL_TABLE]: writeShortCallTable,
    [mvm_TeBytecodeSection.BCS_BUILTINS]: writeBuiltins,
    [mvm_TeBytecodeSection.BCS_STRING_TABLE]: writeStringTable,
    [mvm_TeBytecodeSection.BCS_ROM]: writeRom,
    [mvm_TeBytecodeSection.BCS_GLOBALS]: writeGlobals,
    [mvm_TeBytecodeSection.BCS_HEAP]: writeHeap,
    [mvm_TeBytecodeSection.BCS_SECTION_COUNT]: unexpected,
  };

  // This represents a stub function that will be used in place of ephemeral
  // functions that might be accessed in the snapshot. It's created lazily
  // because it consumes space and there aren't necessarily any reachable
  // references to ephemeral functions
  let detachedEphemeralFunctionOffset: Future<mvm_Value> | undefined;
  const detachedEphemeralFunctionBytecode = new BinaryRegion();

  const detachedEphemeralObjects = new Map<IL.EphemeralObjectID, Referenceable>();
  const detachedEphemeralObjectBytecode = new BinaryRegion();

  const functionReferences = new Map([...snapshot.functions.keys()]
    .map(k => [k, new Future<Referenceable>()]));

  const functionOffsets = new Map([...snapshot.functions.keys()]
    .map(k => [k, new Future()]));

  const allocationReferenceables = new Map([...snapshot.allocations.keys()]
    .map(k => [k, new Future<Referenceable>()]));

  const shortCallTable = new Array<CallInfo>();

  let requiredFeatureFlags = 0;
  for (const flag of snapshot.flags) {
    hardAssert(flag >=0 && flag < 32);
    requiredFeatureFlags |= 1 << flag;
  }

  assignIndexesToGlobalSlots();

  processAllocations();

  // -------------------------- Header --------------------

  bytecode.append(BYTECODE_VERSION, 'bytecodeVersion', formats.uInt8Row);
  bytecode.append(headerSize, 'headerSize', formats.uInt8Row);
  bytecode.append(ENGINE_VERSION, 'requiredEngineVersion', formats.uInt8Row);
  bytecode.append(0, 'reserved', formats.uInt8Row);

  bytecode.append(bytecodeSize, 'bytecodeSize', formats.uInt16LERow);
  bytecode.append(bytecode.postProcess(crcRangeStart, crcRangeEnd, crc16ccitt), 'crc', formats.uHex16LERow);
  crcRangeStart.assign(bytecode.currentOffset);

  bytecode.append(requiredFeatureFlags, 'requiredFeatureFlags', formats.uHex32LERow);

  // Section Offsets
  for (const [index, offset] of sectionOffsets.entries()) {
    const sectionName = mvm_TeBytecodeSection[index];
    bytecode.append(offset, `sectionOffsets[${sectionName}]`, formats.uHex16LERow);
  }

  headerSize.assign(bytecode.currentOffset);

  // -------------------------- End of Header --------------------

  // -------------------------- Sections --------------------

  // Note: the order of these sections is important
  for (const [index, offset] of sectionOffsets.entries()) {
    bytecode.padToEven(formats.paddingRow);
    offset.assign(bytecode.currentOffset);
    const sectionID = index as mvm_TeBytecodeSection;
    const writer = sectionWriters[sectionID];
    writer();
  }

  // Finalize
  const bytecodeEnd = bytecode.currentOffset;
  bytecodeSize.assign(bytecodeEnd);
  crcRangeEnd.assign(bytecodeEnd);

  const snapshotBuffer = bytecode.toBuffer(false);
  const errInfo = validateSnapshotBinary(snapshotBuffer);
  if (errInfo) {
    return unexpected('Failed to create snapshot binary: ' + errInfo.err);
  }
  return {
    snapshot: new SnapshotClass(snapshotBuffer, { names }),
    html: generateDebugHTML ? bytecode.toHTML() : undefined
  };

  function addName(offset: Future, name: string) {
    // The names are associations between a bytecode offset and the original
    // name/ID of the thing at that offset. The name table is mainly used for
    // testing purposes, since it allows us to reconstruct the snapshot IL with
    // the correct names from a bytecode image.
    offset.once('resolve', offset => names[offset] = name);
  }

  function writeBuiltins() {
    const builtinValues: Record<mvm_TeBuiltins, IL.Value> = {
      [mvm_TeBuiltins.BIN_ARRAY_PROTO]: snapshot.builtins.arrayPrototype,
      // This is just for the runtime-interned strings, so it starts off as null
      // but may not be null in successive snapshots.
      [mvm_TeBuiltins.BIN_INTERNED_STRINGS]: IL.nullValue,
      [mvm_TeBuiltins.BIN_BUILTIN_COUNT]: undefined as any
    };

    // Builtins are all stored in immutable bytecode memory
    const region: MemoryRegionID = 'bytecode';

    for (let builtinID = 0 as mvm_TeBuiltins; builtinID < mvm_TeBuiltins.BIN_BUILTIN_COUNT; builtinID++) {
      const label = `builtin[${mvm_TeBuiltins[builtinID]}]`;
      const value = builtinValues[builtinID];
      writeValue(bytecode, value, region, label);
    }
  }

  function writeImportTable() {
    bytecode.appendBuffer(importTable);
  }

  function writeGlobals() {
    const globalSlots = snapshot.globalSlots;
    const variablesInOrderOfIndex = _.sortBy([...globalSlotIndexMapping], ([_name, index]) => index);
    for (const [slotID] of variablesInOrderOfIndex) {
      addName(bytecode.currentOffset, slotID);
      writeValue(bytecode, notUndefined(globalSlots.get(slotID)).value, 'globals', slotID);
    }
    // The handles are part of globals section. These are RAM slots that can be
    // referenced by ROM values.
    bytecode.appendBuffer(handlesRegion, 'handles');
  }

  function writeValue(region: BinaryRegion, value: IL.Value, memoryRegion: MemoryRegionID, label: string) {
    const vEncoded = encodeValue(value, memoryRegion);
    region.append(vEncoded, label, formats.uHex16LERow);
  }

  function writeRom() {
    // Large or dynamically-sized primitives
    bytecode.appendBuffer(largePrimitives);

    // Functions
    bytecode.padToEven(formats.paddingRow);
    writeFunctions(bytecode);

    bytecode.padToEven(formats.paddingRow);
    bytecode.appendBuffer(detachedEphemeralFunctionBytecode);

    bytecode.padToEven(formats.paddingRow);
    bytecode.appendBuffer(detachedEphemeralObjectBytecode);

    // Allocations
    bytecode.padToEven(formats.paddingRow);
    bytecode.appendBuffer(romAllocations);
  }

  function encodeValue(value: IL.Value, slotRegion: MemoryRegionID): FutureLike<mvm_Value> {
    switch (value.type) {
      case 'UndefinedValue': return vm_TeWellKnownValues.VM_VALUE_UNDEFINED;
      case 'BooleanValue': return value.value ? vm_TeWellKnownValues.VM_VALUE_TRUE : vm_TeWellKnownValues.VM_VALUE_FALSE;
      case 'NullValue': return vm_TeWellKnownValues.VM_VALUE_NULL;
      case 'NumberValue': {
        if (isNaN(value.value)) return vm_TeWellKnownValues.VM_VALUE_NAN;
        if (Object.is(value.value, -0)) return vm_TeWellKnownValues.VM_VALUE_NEG_ZERO;
        if (isSInt14(value.value)) return encodeVirtualInt14(value.value);
        if (isSInt32(value.value)) return allocateLargePrimitive(TeTypeCode.TC_REF_INT32, b => b.append(value.value, 'Int32', formats.sInt32LERow));
        return allocateLargePrimitive(TeTypeCode.TC_REF_FLOAT64, b => b.append(value.value, 'Double', formats.doubleLERow));
      };
      case 'StringValue': {
        if (value.value === 'length') return vm_TeWellKnownValues.VM_VALUE_STR_LENGTH;
        if (value.value === '__proto__') return vm_TeWellKnownValues.VM_VALUE_STR_PROTO;
        return getString(value.value);
      }
      case 'FunctionValue': {
        const ref = functionReferences.get(value.value) ?? unexpected();
        return resolveReferenceable(ref, slotRegion);
      }
      case 'ClosureValue': {
        return allocateLargePrimitive(TeTypeCode.TC_REF_CLOSURE, b => {
          b.append(encodeValue(value.scope, slotRegion), 'Closure.scope', formats.uHex16LERow);
          b.append(encodeValue(value.target, slotRegion), 'Closure.target', formats.uHex16LERow);
          b.append(encodeValue(value.props, slotRegion), 'Closure.props', formats.uHex16LERow);
        });
      }
      case 'ReferenceValue': {
        const allocationID = value.value;
        const referenceable = allocationReferenceables.get(allocationID) ?? unexpected();
        const reference = resolveReferenceable(referenceable, slotRegion);
        return reference;
      }
      case 'HostFunctionValue': {
        const hostFunctionID = value.value;
        let importIndex = getImportIndexOfHostFunctionID(hostFunctionID);
        return allocateLargePrimitive(TeTypeCode.TC_REF_HOST_FUNC, w => w.append(importIndex, 'Host func', formats.uInt16LERow));
      }
      case 'EphemeralFunctionValue': {
        return getDetachedEphemeralFunction(slotRegion);
      }
      case 'EphemeralObjectValue': {
        const referenceable = getDetachedEphemeralObject(value);
        return resolveReferenceable(referenceable, slotRegion);
      }
      default: return assertUnreachable(value);
    }
  }

  function getDetachedEphemeralFunction(sourceSlotRegion: MemoryRegionID): Future<mvm_Value> {
    // Create lazily
    if (detachedEphemeralFunctionOffset === undefined) {
      detachedEphemeralFunctionBytecode.padToEven(formats.paddingRow);
      detachedEphemeralFunctionOffset = writeDetachedEphemeralFunction(detachedEphemeralFunctionBytecode);
    }
    const ref = offsetToDynamicPtr(detachedEphemeralFunctionOffset, sourceSlotRegion, 'bytecode', 'detachedEphemeralFunctionBytecode');
    return ref;
  }

  /*
   * Ephemeral objects in Microvium are transient references to a value in the
   * host that will not be captured into the snapshot. If these are found in the
   * snapshot, they are replace with references to "detached ephemeral object"
   * which has no properties and is stored in ROM.
   */
  function getDetachedEphemeralObject(original: IL.EphemeralObjectValue): Referenceable {
    const ephemeralObjectID = original.value;
    // A separate empty object is created for each ephemeral, so that they have
    // distinct identities, like the original objects.
    let target = detachedEphemeralObjects.get(ephemeralObjectID);
    if (!target) {
      detachedEphemeralObjectBytecode.padToEven(formats.paddingRow);
      // Create an empty object representing the detached ephemeral
      const referenceable = writeObject(detachedEphemeralObjectBytecode, {}, 'bytecode');
      target = referenceable;
      addName(referenceable.offset, ephemeralObjectID.toString());
      detachedEphemeralObjects.set(ephemeralObjectID, target);
    }
    return target;
  }

  function writeDetachedEphemeralFunction(output: BinaryRegion) {
    output.padToEven(formats.paddingRow);
    // This is a stub function that just throws an MVM_E_DETACHED_EPHEMERAL
    // error when called
    const maxStackDepth = 0;
    const startAddress = new Future();
    const endAddress = new Future();
    writeFunctionHeader(output, maxStackDepth, startAddress, endAddress, 'Detached func');
    output.append({
      binary: BinaryData([
        (vm_TeOpcode.VM_OP_EXTENDED_2 << 4) | (vm_TeOpcodeEx2.VM_OP2_RETURN_ERROR),
        mvm_TeError.MVM_E_DETACHED_EPHEMERAL
      ]),
      html: 'VM_OP4_CALL_DETACHED_EPHEMERAL'
    }, 'Detached ephemeral stub', formats.preformatted2);
    output.append({
      binary: BinaryData([
        (vm_TeOpcode.VM_OP_EXTENDED_1 << 4) | (vm_TeOpcodeEx1.VM_OP1_RETURN_UNDEFINED)
      ]),
      html: 'return undefined'
    }, undefined, formats.preformatted1);
    endAddress.assign(output.currentOffset);
    return startAddress;
  }

  function getString(s: string): Future<mvm_Value> {
    if (s === 'length') return Future.create(vm_TeWellKnownValues.VM_VALUE_STR_LENGTH);
    if (s === '__proto__') return Future.create(vm_TeWellKnownValues.VM_VALUE_STR_PROTO);

    let ref = strings.get(s);
    if (ref) return ref;

    /*
     * Microvium does not allow the use of strings that are all digits as
     * property names, so they must be encoded as TC_REF_STRING. All others can be
     * used as property names and so will be encoded as TC_REF_INTERNED_STRING.
     */
    const stringType = (/^\d+$/.test(s))
      ? TeTypeCode.TC_REF_STRING
      : TeTypeCode.TC_REF_INTERNED_STRING;

   // Note: Padding is not required because these are allocations in bytecode
    // which is assumed to only be byte-aligned, unlike the GC memory.
    const r = allocateLargePrimitive(stringType, w => w.append(s, 'String', formats.stringUtf8NTRow));
    strings.set(s, r);
    return r;
  }

  function getImportIndexOfHostFunctionID(hostFunctionID: IL.HostFunctionID): number {
    let importIndex = importLookup.get(hostFunctionID);
    if (importIndex !== undefined) {
      return importIndex;
    }
    importIndex = importCount++;
    importLookup.set(hostFunctionID, importIndex);
    hardAssert(isUInt16(hostFunctionID));
    importTable.append(hostFunctionID, undefined, formats.uInt16LERow);
    return importIndex;
  }

  /*
  For want of a better word, "large primitives" here refer to primitive values
  that don't fit directly in a 16-bit value. For example a 32-bit integer. These
  are different to traditional allocations because their immutability means they
  can be memoized.
  */
  function allocateLargePrimitive(typeCode: TeTypeCode, writer: (buffer: BinaryRegion) => void): Future<mvm_Value> {
    largePrimitives.padToEven(formats.paddingRow);
    // Encode as heap allocation
    const buffer = new BinaryRegion();
    const headerWord = new Future();
    buffer.append(headerWord, 'Allocation header', formats.uHex16LERow);
    const startAddress = buffer.currentOffset;
    writer(buffer);
    const size = buffer.currentOffset.subtract(startAddress);
    size.map(size => hardAssert(size <= 0xFFF));
    headerWord.assign(size.map(size => makeHeaderWord(size, typeCode)));
    const newAllocationData = buffer.toBuffer();
    const existingAllocation = largePrimitivesMemoizationTable.find(a => a.data.equals(newAllocationData));
    if (existingAllocation) {
      return existingAllocation.reference;
    } else {
      largePrimitives.appendBuffer(buffer, 'Buffer');
      const reference = offsetToDynamicPtr(startAddress, undefined, 'bytecode', 'large-primitive');
      largePrimitivesMemoizationTable.push({ data: newAllocationData, reference });
      return reference;
    }
  }

  /**
   * Takes an offset into the bytecode image and returns the equivalent
   * DynamicPtr value. The offset can reference any region.
   *
   * If the source region is ROM and target region is GC memory, this function
   * will create an indirection handle, since the target is subject to
   * relocation by the garbage collector.
   *
   * If the target is GC memory and the source is mutable (globals or GC), then
   * the value is encoded as a ShortPtr, to maintain the invariant that
   * references into the GC will use short pointers.
   *
   * The sourceSlotRegion is allowed to be undefined only if the target region
   * is not relocatable (typically meaning it's in ROM), since a value in ROM is
   * referenced the same way from ROM and RAM, so it is independent of the
   * source region.
   */
  function offsetToDynamicPtr(
    targetOffsetInBytecode: Future,
    sourceSlotRegion: MemoryRegionID | undefined,
    targetRegion: MemoryRegionID,
    debugName: string
  ): Future {
    // TODO I think we need some unit tests that cover these different cases.
    const targetIsInGC = targetRegion === 'gc';

    if (targetIsInGC) {
      // For convenience
      if (sourceSlotRegion === undefined) {
        return unexpected();
      }

      const slotIsInRAM: boolean = sourceSlotRegion === 'globals' || sourceSlotRegion === 'gc';

      if (slotIsInRAM === true) {
        // We encode as a short pointer if the slot is one that the GC can visit
        // (i.e. not a slot in ROM) and it points to some GC-collectable
        return makeShortPtr(targetOffsetInBytecode);
      } else {
        // An immutable pointer can't point directly to GC because allocations
        // in GC memory move during compaction. For these cases, we need to
        // create a handle that points to the GC allocation. A handle is just a
        // new global variable, so the pointer returned from this function
        // points to the global variable, and the global variable points to the
        // allocation.
        return makeHandle(targetOffsetInBytecode, sourceSlotRegion, targetRegion);
      }
    } else {
      return makeBytecodeMappedPtr(targetOffsetInBytecode, debugName);
    }
  }

  function makeBytecodeMappedPtr(targetOffsetInBytecode: Future, debugName: string) {
    return targetOffsetInBytecode.map(targetOffsetInBytecode => {
      // References to bytecode space must be to even boundaries
      hardAssert(targetOffsetInBytecode % 2 === 0, debugName);
      // Only 32kB is addressable because we use the upper 15-bits for the address
      hardAssert((targetOffsetInBytecode & 0x7FFF) === targetOffsetInBytecode, debugName);
      // BytecodeMappedPtr is a Value with the lowest bits `01`. The zero comes
      // from the address being even, so only a shift-by-one is required.
      return (targetOffsetInBytecode << 1) | 1;
    });
  }

  function makeShortPtr(targetOffsetInBytecode: Future) {
    const heapOffsetInBytecode = sectionOffsets[mvm_TeBytecodeSection.BCS_HEAP];
    const offsetInHeap = targetOffsetInBytecode.subtract(heapOffsetInBytecode);
    assertIsEven(offsetInHeap);
    assertUInt16(offsetInHeap);
    return offsetInHeap;
  }

  // Returns a Value that references a new handle (global variable)
  function makeHandle(offsetInBytecode: Future, sourceSlotRegion: MemoryRegionID, targetRegion: MemoryRegionID): Future {
    hardAssert(sourceSlotRegion === 'bytecode');
    hardAssert(targetRegion === 'gc');
    const handleOffset = handlesRegion.currentOffset;
    const handleValue = offsetToDynamicPtr(offsetInBytecode, 'globals', targetRegion, 'handle-slot');
    handlesRegion.append(handleValue, 'Handle', formats.uHex16LERow);
    // Handles are pointers to global variables
    return offsetToDynamicPtr(handleOffset, sourceSlotRegion, 'globals', 'handle-ptr');
  }

  function writeHeap() {
    bytecode.appendBuffer(gcAllocations)
  }

  // Write allocations into either romAllocations or gcAllocations
  function processAllocations() {
    for (const [allocationID, allocation] of snapshot.allocations.entries()) {
      hardAssert(allocation.allocationID === allocationID);
      const reference = notUndefined(allocationReferenceables.get(allocationID));
      const targetRegion = allocation.memoryRegion || 'gc';
      const targetRegionCode: MemoryRegionID =
        targetRegion === 'rom' ? 'bytecode' :
        targetRegion === 'gc' ? 'gc' :
        assertUnreachable(targetRegion);
      const binaryRegion =
        targetRegion === 'rom' ? romAllocations :
        targetRegion === 'gc' ? gcAllocations :
        assertUnreachable(targetRegion);

      const referenceable = writeAllocation(binaryRegion, allocation, targetRegionCode);
      addName(referenceable.offset, allocation.allocationID.toString());
      reference.assign(referenceable);
    }
  }

  function writeAllocation(
    region: BinaryRegion,
    allocation: IL.Allocation,
    memoryRegion: MemoryRegionID
  ): Referenceable {
    region.padToEven(formats.paddingRow);
    switch (allocation.type) {
      case 'ArrayAllocation': return writeArray(region, allocation, memoryRegion);
      case 'ObjectAllocation': return writeObject(region, allocation.properties, memoryRegion);
      default: return assertUnreachable(allocation);
    }
  }

  function makeHeaderWord(size: number, typeCode: TeTypeCode) {
    hardAssert(isUInt12(size));
    hardAssert(isUInt4(typeCode));
    return size | (typeCode << 12);
  }

  function writeObject(region: BinaryRegion, properties: IL.ObjectProperties, memoryRegion: MemoryRegionID): Referenceable {
    // See TsPropertyList2
    const typeCode = TeTypeCode.TC_REF_PROPERTY_LIST;
    const keys = Object.keys(properties);
    const size = 4 + keys.length * 4; // Each key-value pair is 4 bytes
    const headerWord = makeHeaderWord(size, typeCode);
    region.append(headerWord, 'TsPropertyList.[header]', formats.uHex16LERow);
    const objectOffset = region.currentOffset;
    region.append(vm_TeWellKnownValues.VM_VALUE_NULL, 'TsPropertyList.dpNext', formats.uHex16LERow);
    region.append(vm_TeWellKnownValues.VM_VALUE_NULL, 'TsPropertyList.dpProto', formats.uHex16LERow);

    for (const [i, k] of keys.entries()) {
      writeValue(region, { type: 'StringValue' , value: k }, memoryRegion, `TsPropertyList.keys[${i}]`);
      writeValue(region, properties[k], memoryRegion, `TsPropertyList.values[${k}]`);
    }

    return offsetToReferenceable(objectOffset, memoryRegion, 'object');
  }

  // The exact value of a reference (pointer) depend on where the value is being
  // referenced from
  function offsetToReferenceable(targetOffsetInBytecode: Future, targetRegion: MemoryRegionID, debugName: string): Referenceable {
    return {
      getPointer: sourceSlotRegion => offsetToDynamicPtr(targetOffsetInBytecode, sourceSlotRegion, targetRegion, debugName),
      offset: targetOffsetInBytecode
    }
  }

  // Get a reference to a referenceable entity
  function resolveReferenceable(referenceable: FutureLike<Referenceable>, sourceSlotRegion: MemoryRegionID): Future<mvm_Value> {
    return Future.create(referenceable).bind(referenceable => referenceable.getPointer(sourceSlotRegion));
  }

  function encodeVirtualInt14(value: number): UInt16 {
    hardAssert(isSInt14(value));
    return ((value << 2) | 3) & 0xFFFF;
  }

  function writeArray(region: BinaryRegion, allocation: IL.ArrayAllocation, memoryRegion: MemoryRegionID): Referenceable {
    // See TsFixedLengthArray and TsArray
    /*
     * Arrays can be represented as dynamic or fixed-length arrays. Fixed length
     * arrays just list the elements directly, while dynamic arrays have a
     * header allocation that references the corresponding fixed-length array,
     * so that the identity of the dynamic array doesn't change when the
     * fixed-length part is resized.
     */

    // This region is for the TsFixedLengthArray
    const arrayDataRegion = new BinaryRegion();
    const contents = allocation.items;
    const len = contents.length;
    const size = len * 2;
    const headerWord = makeHeaderWord(size, TeTypeCode.TC_REF_FIXED_LENGTH_ARRAY)
    arrayDataRegion.append(headerWord, `array.[header]`, formats.uHex16LERow);
    const arrayDataOffset = arrayDataRegion.currentOffset;
    for (const [i, item] of contents.entries()) {
      if (item) {
        writeValue(arrayDataRegion, item, memoryRegion, `array[${i}]`);
      } else {
        arrayDataRegion.append(vm_TeWellKnownValues.VM_VALUE_DELETED, `array[${i}]`, formats.uInt16LERow);
      }
    }
    if (len === 0) {
      // The minimum allocation size in GC memory is 2 bytes, because it needs a
      // forwarding pointer
      if (memoryRegion === 'gc') {
        // TODO: Test this
        arrayDataRegion.append(0, `<padding>`, formats.uInt16LERow);
      }
    }

    if (allocation.lengthIsFixed) {
      region.appendBuffer(arrayDataRegion);
      return offsetToReferenceable(arrayDataOffset, memoryRegion, 'array');
    } else {
      // Here, the length is not fixed, so we wrap the TsFixedLengthArray in a TsArray

      const typeCode = TeTypeCode.TC_REF_ARRAY;
      const headerWord = makeHeaderWord(4, typeCode);
      const dataPtr = new Future();
      region.append(headerWord, `array.[header]`, formats.uHex16LERow);
      const arrayOffset = region.currentOffset;
      region.append(dataPtr, `array.dpData`, formats.uHex16LERow);

      region.append(encodeVirtualInt14(len), `array.viLength=${len}`, formats.uInt16LERow);

      if (len > 0) {
        region.appendBuffer(arrayDataRegion);
        dataPtr.assign(offsetToDynamicPtr(arrayDataOffset, memoryRegion, memoryRegion, 'array-data'));
      } else {
        dataPtr.assign(encodeValue(IL.nullValue, memoryRegion));
      }

      return offsetToReferenceable(arrayOffset, memoryRegion, 'array');
    }
  }

  function writeExportTable() {
    for (const [exportID, value] of snapshot.exports) {
      hardAssert(isUInt16(exportID));
      bytecode.append(exportID, `Exports[${exportID}].ID`, formats.uInt16LERow);
      writeValue(bytecode, value, 'bytecode', `Exports[${exportID}].value`);
    }
  }

  function writeShortCallTable() {
    for (const entry of shortCallTable) {
      switch (entry.type) {
        case 'InternalFunction': {
          const functionOffset = notUndefined(functionOffsets.get(entry.functionID));
          // The high bit must be zero to indicate it's an internal function
          assertUInt14(functionOffset);
          assertIsEven(functionOffset);
          bytecode.append(functionOffset, undefined, formats.uInt16LERow);
          bytecode.append(entry.argCount, undefined, formats.uInt8Row);
          break;
        }
        case 'HostFunction': {
          const functionIndex = entry.hostFunctionIndex;
          hardAssert(isSInt14(functionIndex));
          // The low bit must be 1 to indicate it's an host function
          bytecode.append((functionIndex << 1) | 1, undefined, formats.uInt16LERow);
          bytecode.append(entry.argCount, undefined, formats.uInt8Row);
          break;
        }
        default: return assertUnreachable(entry);
      }
    }
    bytecode.padToEven(formats.paddingRow);
  }

  function writeStringTable() {
    const stringsInAlphabeticalOrder = _.sortBy([...strings.entries()], ([s, _ref]) => s);
    for (const [s, ref] of stringsInAlphabeticalOrder) {
      bytecode.append(ref, '&' + s, formats.uHex16LERow);
    }
  }

  function assignIndexesToGlobalSlots() {
    const globalSlots = snapshot.globalSlots;
    // Sort ascending by the index hint
    const globalSlotsSorted = _.sortBy([...globalSlots], ([_slotID, slot]) => slot.indexHint === undefined ? Infinity : slot.indexHint);
    let globalSlotIndex = 0;
    for (const [slotID] of globalSlotsSorted) {
      const i = globalSlotIndex++;
      globalSlotIndexMapping.set(slotID, i);
    }
  }

  function writeFunctions(output: BinaryRegion) {
    const ctx: InstructionEmitContext = {
      offsetOfFunction,
      getImportIndexOfHostFunctionID,
      encodeValue: v => encodeValue(v, 'bytecode'),
      indexOfGlobalSlot(globalSlotID: VM.GlobalSlotID): number {
        return notUndefined(globalSlotIndexMapping.get(globalSlotID));
      },
      getShortCallIndex(callInfo: CallInfo) {
        let index = shortCallTable.findIndex(s =>
          s.argCount === callInfo.argCount &&
          ((callInfo.type === 'InternalFunction' && s.type === 'InternalFunction' && s.functionID === callInfo.functionID) ||
            ((callInfo.type === 'HostFunction' && s.type === 'HostFunction' && s.hostFunctionIndex === callInfo.hostFunctionIndex))));
        if (index !== undefined) {
          return index;
        }
        if (shortCallTable.length >= 16) {
          return invalidOperation('Maximum number of short calls exceeded');
        }
        index = shortCallTable.length;
        shortCallTable.push(Object.freeze(callInfo));
        return index;
      },
      addName,
    };

    for (const [name, func] of snapshot.functions.entries()) {
      const { functionOffset } = writeFunction(output, func, ctx);
      const offset = notUndefined(functionOffsets.get(name));
      offset.assign(functionOffset);
      const ref = notUndefined(functionReferences.get(name));
      ref.assign(offsetToReferenceable(functionOffset, 'bytecode', 'function:' + name));
    }
  }

  function offsetOfFunction(id: IL.FunctionID): Future {
    return notUndefined(functionOffsets.get(id));
  }
}

function writeFunction(output: BinaryRegion, func: IL.Function, ctx: InstructionEmitContext) {
  output.padToEven(formats.paddingRow);
  const startAddress = new Future();
  const endAddress = new Future();
  const functionOffset = writeFunctionHeader(output, func.maxStackDepth, startAddress, endAddress, func.id);
  ctx.addName(functionOffset, func.id);
  writeFunctionBody(output, func, ctx);
  endAddress.assign(output.currentOffset);
  return { functionOffset };
}

function writeFunctionHeader(output: BinaryRegion, maxStackDepth: number, startAddress: Future<number>, endAddress: Future<number>, funcId: string) {
  const size = endAddress.subtract(startAddress);
  const typeCode = TeTypeCode.TC_REF_FUNCTION;
  const headerWord = size.map(size => {
    hardAssert(isUInt12(size));
    return size | (typeCode << 12);
  });
  output.append(headerWord, `Func alloc header (${funcId})`, formats.uHex16LERow);
  startAddress.assign(output.currentOffset);
  // Pointers to the function will point to the address after the header word but before the stack depth
  const functionAddress = output.currentOffset;
  output.append(maxStackDepth, 'maxStackDepth', formats.uInt8Row);
  return functionAddress;
}

function writeFunctionBody(output: BinaryRegion, func: IL.Function, ctx: InstructionEmitContext): void {
  const emitter = new InstructionEmitter();

  interface OperationMeta {
    op: IL.Operation; // For debug purposes
    addressEstimate: number;
    address: number;
    sizeEstimate: number;
    size: number;
    emitPass2: EmitPass2;
    emitPass3: EmitPass3;
  };

  interface BlockMeta {
    addressEstimate: number;
    address: number;
  }

  const metaByOperation = new Map<IL.Operation, OperationMeta>();
  const metaByBlock = new Map<IL.BlockID, BlockMeta>();
  const blockOutputOrder: string[] = []; // Will be filled in the first pass

  pass1();

  // Run a second pass to refine the estimates
  pass2();

  // Run the second pass again to refine the layout further. This is
  // particularly for the case of forward jumps, which were previously estimated
  // based on the maximum size of future operations but can now be based on a
  // better estimate of future operations
  for (const m of metaByOperation.values()) {
    m.addressEstimate = m.address;
    m.sizeEstimate = m.size;
  }
  for (const m of metaByBlock.values()) {
    m.addressEstimate = m.address;
  }
  pass2();

  // Output pass to generate bytecode
  outputPass();

  function pass1() {
    const blockQueue = Object.keys(func.blocks);
    ctx.preferBlockToBeNext = nextBlockID => {
      const originalIndex = blockQueue.indexOf(nextBlockID);
      if (originalIndex === - 1) {
        // The block position has already been secured, and can't be changed
        return;
      }
      // Move it to the beginning of the queue
      blockQueue.splice(originalIndex, 1);
      blockQueue.unshift(nextBlockID);
    };
    // The entry must be first
    ctx.preferBlockToBeNext(func.entryBlockID);

    // In a first pass, we estimate the layout based on the maximum possible size
    // of each instruction. Instructions such as JUMP can take different forms
    // depending on the distance of the jump, and the distance of the JUMP in turn
    // depends on size of other instructions in between the jump origin and
    // target, which may include other jumps etc.
    let addressEstimate = 0;

    while (blockQueue.length) {
      const blockID = blockQueue.shift()!;
      const block = func.blocks[blockID];
      blockOutputOrder.push(blockID); // The same order will be used for subsequent passes

      // Within the context of this block, operations can request that certain other blocks should be next
      metaByBlock.set(blockID, {
        addressEstimate,
        address: undefined as any
      });
      for (const op of block.operations) {
        const { maxSize, emitPass2 } = emitPass1(emitter, ctx, op);
        const operationMeta: OperationMeta = {
          op,
          addressEstimate,
          address: undefined as any,
          sizeEstimate: maxSize,
          size: undefined as any,
          emitPass2,
          emitPass3: undefined as any
        };
        metaByOperation.set(op, operationMeta);
        addressEstimate += maxSize;
      }
    }
    // After this pass, the order is fixed
    ctx.preferBlockToBeNext = undefined;
  }

  function pass2() {
    let currentOperationMeta: OperationMeta;
    const ctx: Pass2Context = {
      tentativeOffsetOfBlock: (blockID: IL.BlockID) => {
        const targetBlock = notUndefined(metaByBlock.get(blockID));
        const blockAddress = targetBlock.addressEstimate;
        const operationAddress = currentOperationMeta.addressEstimate;
        const operationSize = currentOperationMeta.sizeEstimate;
        const jumpFrom = operationAddress + operationSize;
        // The jump offset is measured from the end of the current operation, but
        // we don't know exactly how big it is so we take the worst case distance
        let maxOffset = (blockAddress >= jumpFrom
          ? blockAddress - jumpFrom
          : blockAddress - (jumpFrom - operationSize));
        return maxOffset;
      }
    };

    let addressEstimate = 0;
    for (const blockID  of blockOutputOrder) {
      const block = func.blocks[blockID];
      const blockMeta = notUndefined(metaByBlock.get(blockID));
      blockMeta.address = addressEstimate;
      for (const op of block.operations) {
        const opMeta = notUndefined(metaByOperation.get(op));
        currentOperationMeta = opMeta;
        const pass2Output = opMeta.emitPass2(ctx);
        opMeta.emitPass3 = pass2Output.emitPass3;
        opMeta.size = pass2Output.size;
        opMeta.address = addressEstimate;
        addressEstimate += pass2Output.size;
      }
    }
  }

  function outputPass() {
    let currentOperationMeta: OperationMeta;
    const innerCtx: Pass3Context = {
      region: output,
      offsetOfBlock(blockID: string): number {
        const targetBlock = notUndefined(metaByBlock.get(blockID));
        const blockAddress = targetBlock.address;
        const operationAddress = currentOperationMeta.address;
        const operationSize = currentOperationMeta.size;
        const jumpFrom = operationAddress + operationSize;
        const offset = blockAddress - jumpFrom;
        return offset;
      }
    };

    for (const blockID of blockOutputOrder) {
      const block = func.blocks[blockID];
      ctx.addName(output.currentOffset, blockID);
      for (const op of block.operations) {
        const opMeta = notUndefined(metaByOperation.get(op));
        currentOperationMeta = opMeta;
        const offsetBefore = output.currentOffset;
        opMeta.emitPass3(innerCtx);
        const offsetAfter = output.currentOffset;
        const measuredSize = offsetAfter.subtract(offsetBefore);
        measuredSize.map(m => hardAssert(m === opMeta.size));
      }
    }
  }
}

function emitPass1(emitter: InstructionEmitter, ctx: InstructionEmitContext, op: IL.Operation): InstructionWriter {
  const operationMeta = IL.opcodes[op.opcode];
  if (!operationMeta) {
    return invalidOperation(`Unknown opcode "${op.opcode}".`);
  }
  const operands = op.operands.map((o, i) =>
    resolveOperand(o, operationMeta.operands[i] as IL.OperandType));

  const method = (emitter as any)[`operation${op.opcode}`] as globalThis.Function;
  if (!method) {
    return notImplemented(`Opcode not implemented in bytecode emitter: "${op.opcode}"`)
  }
  if (method.length === 0) {
    return notImplemented('Implement opcode emitter: ' + op.opcode);
  }
  if (operands.length !== method.length - 2) {
    return unexpected();
  }

  return method.call(emitter, ctx, op, ...operands);
}

function resolveOperand(operand: IL.Operand, expectedType: IL.OperandType) {
  switch (expectedType) {
    case 'LabelOperand':
      if (operand.type !== 'LabelOperand') {
        return invalidOperation('Expected label operand');
      }
      return operand.targetBlockID;
    case 'CountOperand':
      if (operand.type !== 'CountOperand') {
        return invalidOperation('Expected count operand');
      }
      return operand.count;
    case 'IndexOperand':
      if (operand.type !== 'IndexOperand') {
        return invalidOperation('Expected index operand');
      }
      return operand.index;
    case 'NameOperand':
      if (operand.type !== 'NameOperand') {
        return invalidOperation('Expected name operand');
      }
      return operand.name;
    case 'LiteralOperand':
      if (operand.type !== 'LiteralOperand') {
        return invalidOperation('Expected literal operand');
      }
      return operand.literal;
    case 'OpOperand':
      if (operand.type !== 'OpOperand') {
        return invalidOperation('Expected sub-operation operand');
      }
      return operand.subOperation;
    default: assertUnreachable(expectedType);
  }
}

type CallInfo = {
  type: 'InternalFunction'
  functionID: IL.FunctionID,
  argCount: UInt8
} | {
  type: 'HostFunction'
  hostFunctionIndex: HostFunctionIndex,
  argCount: UInt8
};

type HostFunctionIndex = number;

interface InstructionEmitContext {
  getShortCallIndex(callInfo: CallInfo): number;
  offsetOfFunction: (id: IL.FunctionID) => Future<number>;
  indexOfGlobalSlot: (globalSlotID: VM.GlobalSlotID) => number;
  getImportIndexOfHostFunctionID: (hostFunctionID: IL.HostFunctionID) => HostFunctionIndex;
  encodeValue: (value: IL.Value) => FutureLike<mvm_Value>;
  preferBlockToBeNext?: (blockID: IL.BlockID) => void;
  addName(offset: Future, name: string): void;
}

class InstructionEmitter {
  operationArrayNew(_ctx: InstructionEmitContext, op: IL.ArrayNewOperation) {
    return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_ARRAY_NEW, (op.staticInfo && op.staticInfo.minCapacity) || 0, op);
  }

  operationBinOp(_ctx: InstructionEmitContext, op: IL.OtherOperation, param: IL.BinOpCode) {
    const [opcode1, opcode2] = ilBinOpCodeToVm[param];
    return instructionPrimary(opcode1, opcode2, op);
  }

  operationBranch(
    ctx: InstructionEmitContext,
    op: IL.Operation,
    consequentTargetBlockID: string,
    alternateTargetBlockID: string
  ): InstructionWriter {
    ctx.preferBlockToBeNext!(alternateTargetBlockID);
    // Note: branch IL instructions are a bit more complicated than most because
    // they consist of two bytecode instructions
    return {
      maxSize: 6,
      emitPass2: ctx => {
        let tentativeConseqOffset = ctx.tentativeOffsetOfBlock(consequentTargetBlockID);
        /* 😨😨😨 The offset is measured from the end of the bytecode
         * instruction, but since this is a composite instruction, we need to
         * compensate for the fact that we're branching from halfway through the
         * composite instruction.
         */
        if (tentativeConseqOffset < 0) {
          tentativeConseqOffset += 3; // 3 is the max size of the jump part of the composite instruction
        }

        const tentativeConseqOffsetIsFar = !isSInt8(tentativeConseqOffset);
        const sizeOfBranchInstr = tentativeConseqOffsetIsFar ? 3 : 2;

        const tentativeAltOffset = ctx.tentativeOffsetOfBlock(alternateTargetBlockID);
        const tentativeAltOffsetDistance = getJumpDistance(tentativeAltOffset);
        const sizeOfJumpInstr =
          tentativeAltOffsetDistance === 'far' ? 3 :
          tentativeAltOffsetDistance === 'close' ? 2 :
          tentativeAltOffsetDistance === 'zero' ? 0 :
          unexpected();

        const size = sizeOfBranchInstr + sizeOfJumpInstr;

        return {
          size,
          emitPass3: ctx => {
            let label = '';
            let binary: UInt8[] = [];
            const finalOffsetOfConseq = ctx.offsetOfBlock(consequentTargetBlockID) + sizeOfJumpInstr;
            const finalOffsetOfAlt = ctx.offsetOfBlock(alternateTargetBlockID);

            // Stick to our committed shape for the BRANCH instruction
            if (tentativeConseqOffsetIsFar) {
              label += `VM_OP3_BRANCH_2(0x${finalOffsetOfConseq.toString(16)})`;
              binary.push(
                (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | vm_TeOpcodeEx3.VM_OP3_BRANCH_2,
                finalOffsetOfConseq & 0xFF,
                (finalOffsetOfConseq >> 8) & 0xFF
              )
            } else {
              label += `VM_OP2_BRANCH_1(0x${finalOffsetOfConseq.toString(16)})`;
              binary.push(
                (vm_TeOpcode.VM_OP_EXTENDED_2 << 4) | vm_TeOpcodeEx2.VM_OP2_BRANCH_1,
                finalOffsetOfConseq & 0xFF
              )
            }

            // Stick to our committed shape for the JUMP instruction
            switch (tentativeAltOffsetDistance) {
              case 'zero': break; // No instruction at all
              case 'close': {
                label += `, VM_OP2_JUMP_1(0x${finalOffsetOfAlt.toString(16)})`;
                binary.push(
                  (vm_TeOpcode.VM_OP_EXTENDED_2 << 4) | vm_TeOpcodeEx2.VM_OP2_JUMP_1,
                  finalOffsetOfAlt & 0xFF
                )
                break;
              }
              case 'far': {
                label += `, VM_OP3_JUMP_2(0x${finalOffsetOfAlt.toString(16)})`;
                binary.push(
                  (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | vm_TeOpcodeEx3.VM_OP3_JUMP_2,
                  finalOffsetOfAlt & 0xFF,
                  (finalOffsetOfAlt >> 8) & 0xFF
                )
                break;
              }
              default: assertUnreachable(tentativeAltOffsetDistance);
            }

            const html = escapeHTML(stringifyOperation(op));
            ctx.region.append({ binary: BinaryData(binary), html }, label, formats.preformatted2);
          }
        }
      }
    }
  }

  operationClosureNew(ctx: InstructionEmitContext, op: IL.Operation, count: number) {
    switch (count) {
      case 1: return instructionEx1(vm_TeOpcodeEx1.VM_OP1_CLOSURE_NEW_1, op);
      case 2: return instructionEx1(vm_TeOpcodeEx1.VM_OP1_CLOSURE_NEW_2, op);
      case 3: return instructionEx1(vm_TeOpcodeEx1.VM_OP1_CLOSURE_NEW_3, op);
      default: return unexpected();
    }
  }

  operationCall(ctx: InstructionEmitContext, op: IL.CallOperation, argCount: number) {
    const staticInfo = op.staticInfo;
    if (staticInfo?.target) {
      const target = staticInfo.target;
      if (target.type === 'FunctionValue') {
        const functionID = target.value;
        if (staticInfo.shortCall) {
          // Short calls are single-byte instructions that use a nibble to
          // reference into the short-call table, which provides the information
          // about the function target and argument count
          const shortCallIndex = ctx.getShortCallIndex({ type: 'InternalFunction', functionID: target.value, argCount });
          return instructionPrimary(vm_TeOpcode.VM_OP_CALL_1, shortCallIndex, op);
        } else {
          if (argCount <= 15) {
            const targetOffset = ctx.offsetOfFunction(functionID);
            return customInstruction(op, vm_TeOpcode.VM_OP_CALL_5, argCount, {
              type: 'UInt16',
              value: targetOffset
            });
          } else {
            /* Fall back to dynamic call */
          }
        }
      } else if (target.type === 'HostFunctionValue') {
        const hostFunctionID = target.value;
        const hostFunctionIndex = ctx.getImportIndexOfHostFunctionID(hostFunctionID);
        if (staticInfo.shortCall) {
          // Short calls are single-byte instructions that use a nibble to
          // reference into the short-call table, which provides the information
          // about the function target and argument count
          const shortCallIndex = ctx.getShortCallIndex({ type: 'HostFunction', hostFunctionIndex, argCount });
          return instructionPrimary(vm_TeOpcode.VM_OP_CALL_1, shortCallIndex, op);
        } else {
          return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_CALL_HOST, hostFunctionIndex, op);
        }
      } else {
        return invalidOperation('Static call target can only be a function');
      }
    }

    return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_CALL_3, argCount, op);
  }

  operationJump(ctx: InstructionEmitContext, op: IL.Operation, targetBlockID: string): InstructionWriter {
    ctx.preferBlockToBeNext!(targetBlockID);
    return {
      maxSize: 3,
      emitPass2: ctx => {
        const tentativeOffset = ctx.tentativeOffsetOfBlock(targetBlockID);
        const distance = getJumpDistance(tentativeOffset);
        const size = distance === 'zero' ? 0 :
          distance === 'close' ? 2 :
          distance === 'far' ? 3 :
          unexpected();
        return {
          size,
          emitPass3: ctx => {
            const offset = ctx.offsetOfBlock(targetBlockID);
            // Stick to our committed shape
            switch (distance) {
              case 'zero': return; // Jumping to where we are already, so no instruction required
              case 'close': appendInstructionEx2Signed(ctx.region, vm_TeOpcodeEx2.VM_OP2_JUMP_1, offset, op); break;
              case 'far': appendInstructionEx3Signed(ctx.region, vm_TeOpcodeEx3.VM_OP3_JUMP_2, offset, op); break;
              default: return assertUnreachable(distance);
            }
          }
        }
      }
    }
  }

  operationLiteral(ctx: InstructionEmitContext, op: IL.Operation, param: IL.Value) {
    const smallLiteralCode = getSmallLiteralCode(param);
    if (smallLiteralCode !== undefined) {
      return instructionPrimary(vm_TeOpcode.VM_OP_LOAD_SMALL_LITERAL, smallLiteralCode, op);
    } else {
      return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_LOAD_LITERAL, ctx.encodeValue(param), op);
    }

    function getSmallLiteralCode(param: IL.Value): vm_TeSmallLiteralValue | undefined {
      switch (param.type) {
        case 'NullValue': return vm_TeSmallLiteralValue.VM_SLV_NULL;
        case 'UndefinedValue': return vm_TeSmallLiteralValue.VM_SLV_UNDEFINED;
        case 'NumberValue':
          if (Object.is(param.value, -0)) return undefined;
          switch (param.value) {
            case -1: return vm_TeSmallLiteralValue.VM_SLV_INT_MINUS_1;
            case 0: return vm_TeSmallLiteralValue.VM_SLV_INT_0;
            case 1: return vm_TeSmallLiteralValue.VM_SLV_INT_1;
            case 2: return vm_TeSmallLiteralValue.VM_SLV_INT_2;
            case 3: return vm_TeSmallLiteralValue.VM_SLV_INT_3;
            case 4: return vm_TeSmallLiteralValue.VM_SLV_INT_4;
            case 5: return vm_TeSmallLiteralValue.VM_SLV_INT_5;
            default: return undefined;
          }
        case 'StringValue':
          return undefined;
        case 'BooleanValue':
          return param.value
            ? vm_TeSmallLiteralValue.VM_SLV_TRUE
            : vm_TeSmallLiteralValue.VM_SLV_FALSE;
        case 'EphemeralFunctionValue':
        case 'EphemeralObjectValue':
        case 'ClosureValue':
        case 'FunctionValue':
        case 'HostFunctionValue':
        case 'ReferenceValue':
          return undefined;
        default:
          return assertUnreachable(param);
      }
    }
  }

  operationLoadArg(_ctx: InstructionEmitContext, op: IL.Operation, index: number) {
    if (isUInt4(index)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_LOAD_ARG_1, index, op);
    } else {
      hardAssert(isUInt8(index));
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_LOAD_ARG_2, index, op);
    }
  }

  operationLoadGlobal(ctx: InstructionEmitContext, op: IL.Operation, globalSlotID: VM.GlobalSlotID) {
    const slotIndex = ctx.indexOfGlobalSlot(globalSlotID);
    return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_LOAD_GLOBAL_3, slotIndex, op);
  }

  operationLoadReg(ctx: InstructionEmitContext, op: IL.Operation, name: IL.RegName) {
    switch (name) {
      case 'ArgCount': return instructionEx1(vm_TeOpcodeEx1.VM_OP1_LOAD_ARG_COUNT, op);
      default: return assertUnreachable(name);
    }
  }

  operationLoadVar(ctx: InstructionEmitContext, op: IL.Operation, index: number) {
    // In the IL, the index is relative to the stack base, while in the
    // bytecode, it's relative to the stack pointer
    const positionRelativeToSP = op.stackDepthBefore - index - 1;
    if (isUInt4(positionRelativeToSP)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_LOAD_VAR_1, positionRelativeToSP, op);
    } if (isUInt8(positionRelativeToSP)) {
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_LOAD_VAR_2, positionRelativeToSP, op);
    } else {
      return invalidOperation('Variable index out of bounds: ' + index);
    }
  }

  operationNop(_ctx: InstructionEmitContext, op: IL.Operation, nopSize: number) {
    if (nopSize < 2) return invalidOperation('Cannot have less than 2-byte NOP instruction');
    return fixedSizeInstruction(nopSize, region => {
      if (nopSize === 2) {
        // JUMP (0)
        appendInstructionEx2Signed(region, vm_TeOpcodeEx2.VM_OP2_JUMP_1, 0, op);
        return;
      }
      // JUMP
      const offset = nopSize - 3; // The nop size less the size of the jump
      hardAssert(isSInt16(offset));
      const label = `VM_OP3_JUMP_2(${offset})`;
      const value = Future.map(offset, offset => {
        const html = escapeHTML(stringifyOperation(op));
        const binary = [
          (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | vm_TeOpcodeEx3.VM_OP3_JUMP_2,
          offset & 0xFF,
          (offset >> 8) & 0xFF
        ];
        while (binary.length < nopSize) binary.push(0);
        return { html, binary };
      });
      region.append(value, label, formats.preformatted3);
    });
  }

  operationObjectGet(_ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_OBJECT_GET_1, op);
  }

  operationObjectNew(_ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_OBJECT_NEW, op);
  }

  operationObjectSet(_ctx: InstructionEmitContext, op: IL.Operation) {
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_OBJECT_SET_1, op);
  }

  operationPop(_ctx: InstructionEmitContext, op: IL.Operation, count: number) {
    if (count > 1) {
      return customInstruction(op, vm_TeOpcode.VM_OP_EXTENDED_3, vm_TeOpcodeEx3.VM_OP3_POP_N, { type: 'UInt8', value: count })
    } else {
      return instructionEx1(vm_TeOpcodeEx1.VM_OP1_POP, op);
    }
  }

  operationReturn(_ctx: InstructionEmitContext, op: IL.Operation) {
    if (op.opcode !== 'Return') return unexpected();
    let returnUndefined: boolean;
    if (op.staticInfo) {
      returnUndefined = op.staticInfo.returnUndefined;
    } else {
      returnUndefined = false;
    }
    return instructionEx1(returnUndefined ? vm_TeOpcodeEx1.VM_OP1_RETURN_UNDEFINED : vm_TeOpcodeEx1.VM_OP1_RETURN, op);
  }

  operationStoreGlobal(ctx: InstructionEmitContext, op: IL.Operation, globalSlotID: VM.GlobalSlotID) {
    const index = ctx.indexOfGlobalSlot(globalSlotID);
    hardAssert(isUInt16(index));
    return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_STORE_GLOBAL_3, index, op);
  }

  operationStoreVar(_ctx: InstructionEmitContext, op: IL.OtherOperation, index: number) {
    // Note: the index is relative to the stack depth _after_ popping
    const indexRelativeToSP = op.stackDepthBefore - 2 - index;
    if (isUInt4(indexRelativeToSP)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_STORE_VAR_1, indexRelativeToSP, op)
    }
    if (!isUInt8(indexRelativeToSP)) {
      return invalidOperation('Too many stack variables');
    }
    return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_STORE_VAR_2, indexRelativeToSP, op)
  }

  operationUnOp(_ctx: InstructionEmitContext, op: IL.OtherOperation, param: IL.UnOpCode) {
    const [opcode1, opcode2] = ilUnOpCodeToVm[param];
    return instructionPrimary(opcode1, opcode2, op);
  }
}

interface InstructionWriter {
  maxSize: number;
  emitPass2: EmitPass2;
}

type EmitPass2 = (ctx: Pass2Context) => EmitPass2Output;

interface EmitPass2Output {
  size: number;
  emitPass3: EmitPass3;
}

type EmitPass3 = (ctx: Pass3Context) => void;

interface Pass2Context {
  tentativeOffsetOfBlock(blockID: string): number;
}

interface Pass3Context {
  region: BinaryRegion;
  offsetOfBlock(blockID: string): number;
}

function instructionPrimary(opcode: vm_TeOpcode, param: UInt4, op: IL.Operation): InstructionWriter {
  hardAssert(isUInt4(opcode));
  hardAssert(isUInt4(param));
  const label = `${vm_TeOpcode[opcode]}(0x${param.toString(16)})`;
  const html = escapeHTML(stringifyOperation(op));
  const binary = BinaryData([(opcode << 4) | param]);
  return fixedSizeInstruction(1, r => r.append({ binary, html }, label, formats.preformatted1));
}

function instructionEx1(opcode: vm_TeOpcodeEx1, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(1, r => appendInstructionEx1(r, opcode, op));
}

function appendInstructionEx1(region: BinaryRegion, opcode: vm_TeOpcodeEx1, op: IL.Operation): void {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_1, opcode);
}

function instructionEx2Unsigned(opcode: vm_TeOpcodeEx2, param: UInt8, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(2, r => appendInstructionEx2Unsigned(r, opcode, param, op));
}

function appendInstructionEx2Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: SInt8, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_2, opcode, { type: 'SInt8', value: param });
}

function appendInstructionEx2Unsigned(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: UInt8, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_2, opcode, { type: 'UInt8', value: param });
}

function instructionEx3Unsigned(opcode: vm_TeOpcodeEx3, param: FutureLike<UInt16>, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(3, r => appendInstructionEx3Unsigned(r, opcode, param, op));
}

function appendInstructionEx3Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: SInt16, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_3, opcode, { type: 'SInt16', value: param });
}

function appendInstructionEx3Unsigned(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: FutureLike<UInt16>, op: IL.Operation) {
  appendCustomInstruction(region, op, vm_TeOpcode.VM_OP_EXTENDED_3, opcode, { type: 'UInt16', value: param });
}

type InstructionPayloadPart =
  | { type: 'UInt8', value: FutureLike<number> }
  | { type: 'SInt8', value: FutureLike<number> }
  | { type: 'UInt16', value: FutureLike<number> }
  | { type: 'SInt16', value: FutureLike<number> }

export function customInstruction(op: IL.Operation, nibble1: vm_TeOpcode, nibble2: UInt4, ...payload: InstructionPayloadPart[]): InstructionWriter {
  let size: number = 1;
  for (const payloadPart of payload) {
    switch (payloadPart.type) {
      case 'UInt8': size += 1; break;
      case 'SInt8': size += 1; break;
      case 'UInt16': size += 2; break;
      case 'SInt16': size += 2; break;
      default: return assertUnreachable(payloadPart);
    }
  }
  return fixedSizeInstruction(size, r => appendCustomInstruction(r, op, nibble1, nibble2, ...payload));
}

export function appendCustomInstruction(region: BinaryRegion, op: IL.Operation, nibble1: vm_TeOpcode, nibble2: UInt4, ...payload: InstructionPayloadPart[]) {
  hardAssert(isUInt4(nibble1));
  hardAssert(isUInt4(nibble2));
  let nibble1Label = vm_TeOpcode[nibble1];
  let nibble2Label: string;
  switch (nibble1) {
    case vm_TeOpcode.VM_OP_EXTENDED_1: nibble2Label = vm_TeOpcodeEx1[nibble2]; break;
    case vm_TeOpcode.VM_OP_EXTENDED_2: nibble2Label = vm_TeOpcodeEx2[nibble2]; break;
    case vm_TeOpcode.VM_OP_EXTENDED_3: nibble2Label = vm_TeOpcodeEx3[nibble2]; break;
    case vm_TeOpcode.VM_OP_BIT_OP: nibble2Label = vm_TeBitwiseOp[nibble2]; break;
    case vm_TeOpcode.VM_OP_NUM_OP: nibble2Label = vm_TeNumberOp[nibble2]; break;
    case vm_TeOpcode.VM_OP_LOAD_SMALL_LITERAL: nibble2Label = vm_TeSmallLiteralValue[nibble2]; break;
    default: nibble2Label = `0x${nibble2.toString(16)}`; break;
  }

  const label = `${nibble1Label}(${nibble2Label})`;
  let size: number = 1;
  for (const payloadPart of payload) {
    switch (payloadPart.type) {
      case 'UInt8': size += 1; break;
      case 'SInt8': size += 1; break;
      case 'UInt16': size += 2; break;
      case 'SInt16': size += 2; break;
      default: return assertUnreachable(payloadPart);
    }
  }

  const html = escapeHTML(stringifyOperation(op));
  let binary: FutureLike<BinaryData> = [(UInt4(nibble1) << 4) | UInt4(nibble2)];

  for (const payloadPart of payload) {
    binary = Future.bind(binary, binary => {
      const binaryPart = instructionPartToBinary(payloadPart);
      return Future.bind(binaryPart, binaryPart => [...binary, ...binaryPart])
    })
  }

  const value = Future.map(binary, binary => ({ html, binary }));

  region.append(value, label, formats.preformatted(size));

  function instructionPartToBinary(part: InstructionPayloadPart): FutureLike<BinaryData> {
    return Future.map(part.value, partValue => {
      switch (part.type) {
        case 'UInt8': return formats.binaryFormats.uInt8(partValue);
        case 'SInt8': return formats.binaryFormats.sInt8(partValue);
        case 'UInt16': return formats.binaryFormats.uInt16LE(partValue);
        case 'SInt16': return formats.binaryFormats.sInt16LE(partValue);
        default: return assertUnreachable(part);
      }
    })
  }
}

function fixedSizeInstruction(size: number, write: (region: BinaryRegion) => void): InstructionWriter {
  return {
    maxSize: size,
    emitPass2: () => ({
      size,
      emitPass3: ctx => write(ctx.region)
    })
  }
}

const assertUInt16 = Future.lift((v: number) => hardAssert(isUInt16(v)));
const assertUInt14 = Future.lift((v: number) => hardAssert(isUInt14(v)));
const assertIsEven = Future.lift((v: number) => hardAssert(v % 2 === 0));

const instructionNotImplemented: InstructionWriter = {
  maxSize: 1,
  emitPass2: () => ({
    size: 1,
    emitPass3: ctx => ctx.region.append(undefined, undefined, instructionNotImplementedFormat)
  })
}

const instructionNotImplementedFormat: Format<Labelled<undefined>> = {
  binaryFormat: () => [0],
  htmlFormat: formats.tableRow(() => 'Instruction not implemented')
}

const ilUnOpCodeToVm: Record<IL.UnOpCode, [vm_TeOpcode, vm_TeOpcodeEx1 | vm_TeNumberOp | vm_TeBitwiseOp]> = {
  ["-"]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_NEGATE    ],
  ["+"]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_UNARY_PLUS],
  ["!"]: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_LOGICAL_NOT ],
  ["~"]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_NOT      ],
}

const ilBinOpCodeToVm: Record<IL.BinOpCode, [vm_TeOpcode, vm_TeOpcodeEx1 | vm_TeNumberOp | vm_TeBitwiseOp]> = {
  // Polymorphic ops
  ['+'  ]: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_ADD              ],
  ['===']: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_EQUAL            ],
  ['!==']: [vm_TeOpcode.VM_OP_EXTENDED_1, vm_TeOpcodeEx1.VM_OP1_NOT_EQUAL        ],

  // Number ops
  ['-'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_SUBTRACT       ],
  ['/'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_DIVIDE         ],
  ['DIVIDE_AND_TRUNC']: [vm_TeOpcode.VM_OP_NUM_OP, vm_TeNumberOp.VM_NUM_OP_DIVIDE_AND_TRUNC],
  ['%'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_REMAINDER      ],
  ['*'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_MULTIPLY       ],
  ['**' ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_POWER          ],
  ['<'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_LESS_THAN      ],
  ['>'  ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_GREATER_THAN   ],
  ['<=' ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_LESS_EQUAL     ],
  ['>=' ]: [vm_TeOpcode.VM_OP_NUM_OP    , vm_TeNumberOp.VM_NUM_OP_GREATER_EQUAL  ],

  // Bitwise ops
  ['>>' ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_SHR_ARITHMETIC],
  ['>>>']: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_SHR_LOGICAL   ],
  ['<<' ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_SHL           ],
  ['&'  ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_AND           ],
  ['|'  ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_OR            ],
  ['^'  ]: [vm_TeOpcode.VM_OP_BIT_OP    , vm_TeBitwiseOp.VM_BIT_OP_XOR           ],

  // Note: Logical AND and OR are implemented via the BRANCH opcode
}

function getJumpDistance(offset: SInt16) {
  const distance: 'zero' | 'close' | 'far' =
    offset === 0 ? 'zero' :
    isSInt8(offset) ? 'close' :
    'far';
  return distance;
}

