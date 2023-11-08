// TODO: Honestly, I think this whole unit needs a clean rewrite. What started
// out as the best approach turned out to just get more complicated over time.

import * as IL from './il';
import * as VM from './virtual-machine-types';
import { assertUnreachable, hardAssert, notUndefined, unexpected, invalidOperation } from './utils';
import * as _ from 'lodash';
import { vm_Reference, mvm_Value, vm_TeWellKnownValues, TeTypeCode, UInt8, isUInt12, isSInt14, isSInt32, isUInt16, isUInt4, UInt16, isUInt14, mvm_TeBytecodeSection, mvm_TeBuiltins  } from './runtime-types';
import { BinaryRegion, Future, FutureLike } from './binary-region';
import { HTML, BinaryData } from './visual-buffer';
import * as formats from './snapshot-binary-html-formats';
import { SnapshotClass } from './snapshot';
import { SnapshotIL, validateSnapshotBinary, ENGINE_MAJOR_VERSION, ENGINE_MINOR_VERSION } from './snapshot-il';
import { vm_TeOpcode, vm_TeOpcodeEx1, vm_TeOpcodeEx3 } from './bytecode-opcodes';
import { crc16ccitt } from 'crc';
import { SnapshotReconstructionInfo } from './decode-snapshot';
import { stringifyValue } from './stringify-il';
import { CallInfo, InstructionEmitContext, FutureInstructionSourceMapping, writeFunctionBody } from './encode-snapshot-function-body';
import { SourceMap } from './source-map';

export function encodeSnapshot(snapshot: SnapshotIL, generateDebugHTML: boolean, generateSourceMap: boolean): {
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
  const futureSourceMap: FutureInstructionSourceMapping[] = [];

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

  // This isn't the most elegant, but it echos what we're doing with function
  // references, where we build up the map of futures and the populate them
  // later.
  const addressableReferences = new Map([...enumerateAddressableReferences(snapshot)]
    .map(address => [programAddressToKey(address), new Future<Referenceable>()] as const));

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

  findStrings();

  // -------------------------- Header --------------------

  bytecode.append(ENGINE_MAJOR_VERSION, 'bytecodeVersion', formats.uInt8Row);
  bytecode.append(headerSize, 'headerSize', formats.uInt8Row);
  bytecode.append(ENGINE_MINOR_VERSION, 'requiredEngineVersion', formats.uInt8Row);
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

  // Note: this final padding is because the heap region needs to end on an even
  // boundary because that's where the next allocation will be at runtime.
  bytecode.padToEven(formats.paddingRow);

  // Finalize
  const bytecodeEnd = bytecode.currentOffset;
  bytecodeSize.assign(bytecodeEnd);
  crcRangeEnd.assign(bytecodeEnd);

  const snapshotBuffer = bytecode.toBuffer(false);
  const errInfo = validateSnapshotBinary(snapshotBuffer);
  if (errInfo) {
    return unexpected('Failed to create snapshot binary: ' + errInfo.err);
  }

  // Emit source map
  let sourceMap: SourceMap | undefined;
  if (generateSourceMap) {
    sourceMap = {
      operations: futureSourceMap.map(m => ({
        start: m.start.lastValue ?? unexpected(),
        end: m.end.lastValue ?? unexpected(),
        source: m.source,
        op: m.op,
      }))
    };
  }

  return {
    snapshot: new SnapshotClass(snapshotBuffer, { names }, sourceMap),
    html: generateDebugHTML ? bytecode.toHTML() : undefined
  };

  function addName(offset: Future, type: string, name: string) {
    // The names are associations between a bytecode offset and the original
    // name/ID of the thing at that offset. The name table is mainly used for
    // testing purposes, since it allows us to reconstruct the snapshot IL with
    // the correct names from a bytecode image.
    offset.once('resolve', offset => {
      names[type] ??= {};
      names[type][offset] = name
    });
  }

  function findStrings() {
    // The string intern table is written before we've had a chance to explore
    // the code for strings, so we don't see those strings. There's probably a
    // better way to do this, but for the moment I'm just iterating the IL to
    // find the strings. By this point, we've already traversed the heap
    // allocations.

    for (const func of snapshot.functions.values()) {
      for (const block of Object.values(func.blocks)) {
        for (const operation of block.operations) {
          for (const operand of operation.operands) {
            if (operand.type === 'LiteralOperand' && operand.literal.type === 'StringValue') {
              getString(operand.literal.value);
            }
          }
        }
      }
    }

    for (const global of snapshot.globalSlots.values()) {
      if (global.value.type === 'StringValue') {
        getString(global.value.value);
      }
    }

    for (const builtin of Object.values(snapshot.builtins)) {
      if (builtin.type === 'StringValue') {
        getString(builtin.value);
      }
    }
  }

  function writeBuiltins() {
    const builtinValues: Record<mvm_TeBuiltins, FutureLike<mvm_Value>> = {
      [mvm_TeBuiltins.BIN_ARRAY_PROTO]: encodeValue(snapshot.builtins.arrayPrototype, 'bytecode'),
      [mvm_TeBuiltins.BIN_ASYNC_CATCH_BLOCK]: encodeValue(snapshot.builtins.asyncCatchBlock, 'bytecode'),
      [mvm_TeBuiltins.BIN_ASYNC_CONTINUE]: encodeValue(snapshot.builtins.asyncContinue, 'bytecode'),
      [mvm_TeBuiltins.BIN_ASYNC_HOST_CALLBACK]: encodeValue(snapshot.builtins.asyncHostCallback, 'bytecode'),
      [mvm_TeBuiltins.BIN_PROMISE_PROTOTYPE]: encodeValue(snapshot.builtins.promisePrototype, 'bytecode'),
      [mvm_TeBuiltins.BIN_STR_PROTOTYPE]: getPrototypeStringBuiltin(),
      // This is just for the runtime-interned strings, so it starts off as null
      // but may not be null in successive snapshots.
      [mvm_TeBuiltins.BIN_INTERNED_STRINGS]: makeHandle(encodeValue(IL.undefinedValue, 'bytecode'), 'bytecode', 'gc', 'interned-strings'),
      [mvm_TeBuiltins.BIN_STRING_PROTOTYPE]: encodeValue(snapshot.builtins.stringPrototype, 'bytecode'),


      // Not a real builtin
      [mvm_TeBuiltins.BIN_BUILTIN_COUNT]: undefined as any
    };

    // Builtins are all stored in immutable bytecode memory
    const region: MemoryRegionID = 'bytecode';

    for (let builtinID = 0 as mvm_TeBuiltins; builtinID < mvm_TeBuiltins.BIN_BUILTIN_COUNT; builtinID++) {
      const label = `builtin[${mvm_TeBuiltins[builtinID]}]`;
      const value = builtinValues[builtinID];
      bytecode.append(value, label, formats.uHex16LERow);
    }
  }

  function getPrototypeStringBuiltin() {
    // This is a bit of a hack just to delay the encoding until we've had a
    // chance to visit all the strings, because we need to know if the bytecode
    // contains a "prototype" string.
    return bytecode.currentOffset.bind(() => {
      const result = new Future<number>(true);
      if (strings.has('prototype')) {
        result.assign(encodeValue({ type: 'StringValue', value: 'prototype' }, 'bytecode'))
      } else {
        result.assign(encodeValue({ type: 'UndefinedValue', value: undefined }, 'bytecode'))
      }
      return result;
    })
  }

  function writeImportTable() {
    bytecode.appendBuffer(importTable);
  }

  function writeGlobals() {
    const globalSlots = snapshot.globalSlots;
    const variablesInOrderOfIndex = _.sortBy([...globalSlotIndexMapping], ([_name, index]) => index);
    for (const [slotID] of variablesInOrderOfIndex) {
      addName(bytecode.currentOffset, 'global', slotID);
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
      case 'DeletedValue': return vm_TeWellKnownValues.VM_VALUE_DELETED;
      case 'UndefinedValue': return vm_TeWellKnownValues.VM_VALUE_UNDEFINED;
      case 'BooleanValue': return value.value ? vm_TeWellKnownValues.VM_VALUE_TRUE : vm_TeWellKnownValues.VM_VALUE_FALSE;
      case 'NullValue': return vm_TeWellKnownValues.VM_VALUE_NULL;
      case 'NoOpFunction': return vm_TeWellKnownValues.VM_VALUE_NO_OP_FUNC;
      case 'NumberValue': {
        if (isNaN(value.value)) return vm_TeWellKnownValues.VM_VALUE_NAN;
        if (Object.is(value.value, -0)) return vm_TeWellKnownValues.VM_VALUE_NEG_ZERO;
        if (isSInt14(value.value)) return encodeVirtualInt14(value.value);
        if (isSInt32(value.value)) return allocateLargePrimitive(TeTypeCode.TC_REF_INT32, b => b.append(value.value, 'Int32', formats.sInt32LERow), {
          debugName: `NumberValue(${stringifyValue(value)})`
        });
        return allocateLargePrimitive(TeTypeCode.TC_REF_FLOAT64, b => b.append(value.value, 'Double', formats.doubleLERow), {
          debugName: `NumberValue(${stringifyValue(value)})`
        });
      };
      case 'StringValue': {
        if (value.value === 'length') return vm_TeWellKnownValues.VM_VALUE_STR_LENGTH;
        if (value.value === '__proto__') return vm_TeWellKnownValues.VM_VALUE_STR_PROTO;
        return getString(value.value);
      }
      case 'FunctionValue': {
        const ref = functionReferences.get(value.value) ?? unexpected();
        return resolveReferenceable(ref, slotRegion, `FunctionValue(${value.value})`);
      }
      case 'ResumePoint': {
        return encodeProgramAddress(value.address, slotRegion, 'ResumePoint');
      }
      case 'ClassValue': {
        // Note: closure values are not interned because their final bytecode
        // form depends on the location of the referenced scope and target, so
        // we can't cache the bytecode value.
        const intern = false;
        return allocateLargePrimitive(TeTypeCode.TC_REF_CLASS, b => {
          b.append(encodeValue(value.constructorFunc, 'bytecode'), 'Class.ctor', formats.uHex16LERow);
          b.append(encodeValue(value.staticProps, 'bytecode'), 'Class.props', formats.uHex16LERow);
        }, {
          intern,
          debugName: `ClosureValue(${stringifyValue(value)})`
        });
      }
      case 'ReferenceValue': {
        const allocationID = value.value;
        const referenceable = allocationReferenceables.get(allocationID) ?? unexpected();
        const reference = resolveReferenceable(referenceable, slotRegion, `ref${allocationID}`);
        return reference;
      }
      case 'HostFunctionValue': {
        const hostFunctionID = value.value;
        let importIndex = getImportIndexOfHostFunctionID(hostFunctionID);
        return allocateLargePrimitive(TeTypeCode.TC_REF_HOST_FUNC, w => w.append(importIndex, 'Host func', formats.uInt16LERow), {
          debugName: `HostFunctionValue(${stringifyValue(value)})`
        });
      }
      case 'EphemeralFunctionValue': {
        return getDetachedEphemeralFunction(slotRegion);
      }
      case 'EphemeralObjectValue': {
        const debugName = `EphemeralObjectValue(${value.value})`
        const referenceable = getDetachedEphemeralObject(value, debugName);
        return resolveReferenceable(referenceable, slotRegion, debugName);
      }
      case 'ProgramAddressValue': {
        // ProgramAddressValue is only used for exceptions when we push the
        // catch target to the stack. These can land up encoded in the case of
        // async functions which preserve the stack to the closure when they
        // suspend.
        return encodeProgramAddress(value, slotRegion, 'ProgramAddress');
      }
      default: return assertUnreachable(value);
    }
  }

  function encodeProgramAddress(address: IL.ProgramAddressValue, slotRegion: MemoryRegionID, debugType: string): Future<mvm_Value> {
    const { funcId, blockId, operationIndex } = address;
    const key = programAddressToKey(address);
    const ref = addressableReferences.get(key) ?? unexpected();
    return resolveReferenceable(ref, slotRegion, `${debugType}(${funcId}, ${blockId}, ${operationIndex})`);
  }

  function getDetachedEphemeralFunction(sourceSlotRegion: MemoryRegionID): Future<mvm_Value> {
    // Create lazily
    if (detachedEphemeralFunctionOffset === undefined) {
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
  function getDetachedEphemeralObject(original: IL.EphemeralObjectValue, debugName: string): Referenceable {
    const ephemeralObjectID = original.value;
    // A separate empty object is created for each ephemeral, so that they have
    // distinct identities, like the original objects.
    let target = detachedEphemeralObjects.get(ephemeralObjectID);
    if (!target) {
      // Create an empty object representing the detached ephemeral
      const referenceable = writeObject(detachedEphemeralObjectBytecode, IL.nullValue, {}, [IL.deletedValue, IL.deletedValue], 'bytecode', debugName);
      target = referenceable;
      addName(referenceable.offset, 'allocation', ephemeralObjectID.toString());
      detachedEphemeralObjects.set(ephemeralObjectID, target);
    }
    return target;
  }

  function writeDetachedEphemeralFunction(output: BinaryRegion) {
    const errorMessage = getString('Not available on this host (detached)')

    // This is a stub function that just throws an MVM_E_DETACHED_EPHEMERAL
    // error when called
    const maxStackDepth = 0;

    const name = 'Detached func';
    writeFunctionHeader(output, maxStackDepth, name);
    const startAddress = output.currentOffset;
    addName(startAddress, 'allocation', name);

    addName(startAddress, 'block', name + '-entry');

    // TODO: Test this
    output.append(errorMessage.map(errorMessage => ({
      binary: BinaryData([
        (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | (vm_TeOpcodeEx3.VM_OP3_LOAD_LITERAL),
        errorMessage & 0xff,
        (errorMessage >> 8) & 0xff,
        (vm_TeOpcode.VM_OP_EXTENDED_1 << 4) | (vm_TeOpcodeEx1.VM_OP1_THROW),
      ]),
      html: 'return undefined'
    })), undefined, formats.preformatted1);

    return startAddress;
  }

  function getString(s: string): Future<mvm_Value> {
    if (s === 'length') return Future.create(vm_TeWellKnownValues.VM_VALUE_STR_LENGTH);
    if (s === '__proto__') return Future.create(vm_TeWellKnownValues.VM_VALUE_STR_PROTO);

    let ref = strings.get(s);
    if (ref) return ref;

    /*
     * Microvium does not allow the use of strings that are all digits as
     * property names, so they must be encoded as TC_REF_STRING. All others can
     * be used as property names and so will be encoded as
     * TC_REF_INTERNED_STRING.
     */
    const stringType = (/^\d+$/.test(s))
      ? TeTypeCode.TC_REF_STRING
      : TeTypeCode.TC_REF_INTERNED_STRING;

    const r = allocateLargePrimitive(stringType, w => w.append(s, 'String', formats.stringUtf8NTRow), {
      debugName: `const string(${JSON.stringify(s)})`
    });
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
  function allocateLargePrimitive(
    typeCode: TeTypeCode,
    writer: (buffer: BinaryRegion) => void,
    opts: {
      intern?: boolean,
      targetRegion?: BinaryRegion,
      targetRegionId?: MemoryRegionID,
      debugName: string,
    }
  ): Future<mvm_Value> {
    const {
      intern,
      targetRegion,
      targetRegionId,
      debugName: debugName_,
    } = {
      intern: true,
      targetRegion: largePrimitives,
      targetRegionId: 'bytecode' as MemoryRegionID,
      ...opts,
    }
    const debugName = `large-primitive${debugName_ ? `(${debugName_})` : ''}`;

    padToNextAddressable(targetRegion, { headerSize: 2 });

    // Encode as heap allocation
    const buffer = new BinaryRegion();
    const headerWord = new Future();
    buffer.append(headerWord, 'Allocation header', formats.uHex16LERow);
    const startAddress = buffer.currentOffset;
    writer(buffer);
    const size = buffer.currentOffset.subtract(startAddress);
    size.map(size => hardAssert(size <= 0xFFF));
    headerWord.assign(size.map(size => makeHeaderWord(size, typeCode)));

    if (!intern) {
      targetRegion.appendBuffer(buffer, 'Buffer');
      return offsetToDynamicPtr(startAddress, undefined, targetRegionId, debugName);
    }

    const newAllocationData = buffer.toBuffer();
    const existingAllocation = largePrimitivesMemoizationTable.find(a => a.data.equals(newAllocationData));
    if (existingAllocation) {
      return existingAllocation.reference;
    } else {
      targetRegion.appendBuffer(buffer, 'Buffer');
      const reference = offsetToDynamicPtr(startAddress, undefined, targetRegionId, debugName);
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

      const slotIsInRAM = sourceSlotRegion === 'globals' || sourceSlotRegion === 'gc';

      if (slotIsInRAM) {
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
        return makeHandleToBytecodeAddress(targetOffsetInBytecode, sourceSlotRegion, targetRegion, debugName);
      }
    } else {
      return makeBytecodeMappedPtr(targetOffsetInBytecode, debugName);
    }
  }

  function makeBytecodeMappedPtr(targetOffsetInBytecode: Future, debugName: string) {
    return targetOffsetInBytecode.map(targetOffsetInBytecode => {
      // References to bytecode space must be to 4 bytes
      hardAssert(targetOffsetInBytecode % 4 === 0, debugName);
      // Only 64kB is addressable because we use the upper 14-bits for the address
      hardAssert((targetOffsetInBytecode & 0xFFFC) === targetOffsetInBytecode, debugName);
      // BytecodeMappedPtr is a Value with the lowest bits `01`. The zero comes
      // from the address being quad-aligned.
      return targetOffsetInBytecode | 1;
    });
  }

  function makeShortPtr(targetOffsetInBytecode: Future) {
    const heapOffsetInBytecode = sectionOffsets[mvm_TeBytecodeSection.BCS_HEAP];
    const offsetInHeap = targetOffsetInBytecode.subtract(heapOffsetInBytecode);
    assertIsEven(offsetInHeap, 'makeShortPtr');
    assertUInt16(offsetInHeap);
    return offsetInHeap;
  }

  // Returns a Value that references a new handle (global variable)
  function makeHandleToBytecodeAddress(offsetInBytecode: Future, sourceSlotRegion: MemoryRegionID, targetRegion: MemoryRegionID, debugName: string): Future {
    const handleValue = offsetToDynamicPtr(offsetInBytecode, 'globals', targetRegion, `handle-slot(${debugName})`);
    return makeHandle(handleValue, sourceSlotRegion, targetRegion, debugName);
  }

  function makeHandle(handleValue: FutureLike<mvm_Value>, sourceSlotRegion: MemoryRegionID, targetRegion: MemoryRegionID, debugName: string) {
    hardAssert(sourceSlotRegion === 'bytecode');
    hardAssert(targetRegion === 'gc');
    // Pad with deleted because the globals are visible to the GC
    handlesRegion.padToQuad(formats.paddingWithDeletedRow, 0);
    const handleOffset = handlesRegion.currentOffset;
    // The value to put inside the handle slot
    handlesRegion.append(handleValue, 'Handle', formats.uHex16LERow);
    // Handles are pointers to global variables
    return offsetToDynamicPtr(handleOffset, sourceSlotRegion, 'globals', `handle(${debugName})`);
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
      addName(referenceable.offset, 'allocation', allocation.allocationID.toString());
      reference.assign(referenceable);
    }
  }

  function writeAllocation(
    region: BinaryRegion,
    allocation: IL.Allocation,
    memoryRegion: MemoryRegionID
  ): Referenceable {
    const debugName = allocation.allocationID.toString();
    switch (allocation.type) {
      case 'ArrayAllocation': return writeArray(region, allocation, memoryRegion, debugName);
      case 'ObjectAllocation': return writeObject(region, allocation.prototype, allocation.properties, allocation.internalSlots, memoryRegion, debugName);
      case 'Uint8ArrayAllocation': return writeUint8Array(region, allocation, memoryRegion, debugName);
      case 'ClosureAllocation': return writeClosure(region, allocation, memoryRegion, debugName);
      default: return assertUnreachable(allocation);
    }
  }

  function makeHeaderWord(size: number, typeCode: TeTypeCode) {
    if (size > 4095) {
      throw new Error('Maximum allocation size exceeded. Allocations in Microvium are limited to 4kB each. If you have arrays of larger than 2047 items then you may need to refactor them into multiple smaller arrays.')
    }
    hardAssert(isUInt12(size));
    hardAssert(isUInt4(typeCode));
    return size | (typeCode << 12);
  }

  function writeObject(region: BinaryRegion, prototype: IL.Value, properties: IL.ObjectProperties, internalSlots: IL.Value[], memoryRegion: MemoryRegionID, debugName: string): Referenceable {
    // See TsPropertyList2
    const typeCode = TeTypeCode.TC_REF_PROPERTY_LIST;
    const keys = Object.keys(properties);

    hardAssert(internalSlots.length >= 2); // The first two internal slots are reserved
    hardAssert(internalSlots[0].type === 'DeletedValue');
    hardAssert(internalSlots[1].type === 'DeletedValue');

    const size = (internalSlots.length * 2 - 4) + 4 + keys.length * 4; // Each key-value pair is 4 bytes
    const headerWord = makeHeaderWord(size, typeCode);
    padToNextAddressable(region, { headerSize: 2 });
    region.append(headerWord, 'TsPropertyList.[header]', formats.uHex16LERow);
    const objectOffset = region.currentOffset;
    region.append(vm_TeWellKnownValues.VM_VALUE_NULL, 'TsPropertyList.dpNext', formats.uHex16LERow);
    writeValue(region, prototype, memoryRegion, `TsPropertyList.dpProto`);

    for (const [i, slot] of internalSlots.entries()) {
      if (i < 2) continue; // Skip the first two internal slots which represent the dpNext and dpProto
      // Even-valued internal slots must be negative int14 because these
      // overload the property key positions.
      if (i % 2 === 0) hardAssert(slot.type === 'NumberValue' && isSInt14(slot.value) && slot.value < 0);
      writeValue(region, slot, memoryRegion, `TsPropertyList.internalSlots[${i}]`);
    }

    for (const [i, k] of keys.entries()) {
      writeValue(region, { type: 'StringValue' , value: k }, memoryRegion, `TsPropertyList.keys[${i}]`);
      writeValue(region, properties[k], memoryRegion, `TsPropertyList.values[${k}]`);
    }

    return offsetToReferenceable(objectOffset, memoryRegion, `object(${debugName})`);
  }

  // The exact encoding of a reference (pointer) depend on where the value is
  // being referenced from. For example, a pointer in ROM referencing an
  // allocation in GC memory will actually be a pointer to a handle. See
  // `offsetToDynamicPtr`.
  function offsetToReferenceable(targetOffsetInBytecode: Future, targetRegion: MemoryRegionID, debugName: string): Referenceable {
    return {
      debugName,
      getPointer: sourceSlotRegion => offsetToDynamicPtr(targetOffsetInBytecode, sourceSlotRegion, targetRegion, debugName),
      offset: targetOffsetInBytecode
    }
  }

  // Get a reference to a referenceable entity
  function resolveReferenceable(referenceable: FutureLike<Referenceable>, sourceSlotRegion: MemoryRegionID, debugName: string): Future<mvm_Value> {
    return Future.create(referenceable).bind(referenceable =>
      referenceable.getPointer(sourceSlotRegion, debugName)
    );
  }

  function encodeVirtualInt14(value: number): UInt16 {
    hardAssert(isSInt14(value));
    return ((value << 2) | 3) & 0xFFFF;
  }

  function writeArray(region: BinaryRegion, allocation: IL.ArrayAllocation, memoryRegion: MemoryRegionID, debugName: string): Referenceable {
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
    padToNextAddressable(arrayDataRegion, { headerSize: 2 });
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
      return offsetToReferenceable(arrayDataOffset, memoryRegion, `array(${debugName})`);
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
        dataPtr.assign(offsetToDynamicPtr(arrayDataOffset, memoryRegion, memoryRegion, `array-data($${debugName})`));
      } else {
        dataPtr.assign(encodeValue(IL.nullValue, memoryRegion));
      }

      return offsetToReferenceable(arrayOffset, memoryRegion, `array($${debugName})`);
    }
  }

  function writeClosure(region: BinaryRegion, allocation: IL.ClosureAllocation, memoryRegion: MemoryRegionID, debugName: string): Referenceable {
    const closureRegion = new BinaryRegion();
    const contents = allocation.slots;
    const len = contents.length;
    if (len < 2) unexpected(); // Closures always have at least 2 slots
    const size = len * 2;
    padToNextAddressable(closureRegion, { headerSize: 2 });
    const headerWord = makeHeaderWord(size, TeTypeCode.TC_REF_CLOSURE)
    closureRegion.append(headerWord, `closure.[header]`, formats.uHex16LERow);
    const closureDataOffset = closureRegion.currentOffset;
    for (const [i, item] of contents.entries()) {
      writeValue(closureRegion, item, memoryRegion, `closure[${i}]`);
    }

    region.appendBuffer(closureRegion);
    return offsetToReferenceable(closureDataOffset, memoryRegion, `closure(${debugName})`);
  }

  function writeUint8Array(region: BinaryRegion, allocation: IL.Uint8ArrayAllocation, memoryRegion: MemoryRegionID, debugName: string): Referenceable {
    // This region is for the TsFixedLengthArray
    const subRegion = new BinaryRegion();
    const bytes = allocation.bytes;
    const len = bytes.length;
    padToNextAddressable(region, { headerSize: 2 });
    const headerWord = makeHeaderWord(len, TeTypeCode.TC_REF_UINT8_ARRAY);
    subRegion.append(headerWord, `Uint8Array.[header]`, formats.uHex16LERow);
    const startOffset = subRegion.currentOffset;
    subRegion.append(Buffer.from(allocation.bytes), `Uint8Array.[data]`, formats.bufferRow)
    region.appendBuffer(subRegion);

    return offsetToReferenceable(startOffset, memoryRegion, `Uint8Array(${debugName})`);
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
          assertIsEven(functionOffset, 'function-offset');
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
      addName,

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

      sourceMapAdd: !generateSourceMap ? undefined : (mapping: FutureInstructionSourceMapping) => {
        futureSourceMap.push(mapping);
      }
    };

    for (const [name, func] of snapshot.functions.entries()) {
      const { functionOffset } = writeFunction(output, func, ctx, addressableReferences);
      const offset = notUndefined(functionOffsets.get(name));
      offset.assign(functionOffset);
      const ref = notUndefined(functionReferences.get(name));
      ref.assign(offsetToReferenceable(functionOffset, 'bytecode', 'function:' + name));
    }
  }

  function offsetOfFunction(id: IL.FunctionID): Future {
    return notUndefined(functionOffsets.get(id));
  }

  function padToNextAddressable(region: BinaryRegion, { headerSize }: { headerSize: number }) {
    if (region === bytecode ||
      region === largePrimitives ||
      region === detachedEphemeralFunctionBytecode ||
      region === detachedEphemeralObjectBytecode ||
      region === romAllocations
    ) {
      region.padToQuad(formats.paddingRow, headerSize);
    } else {
      region.padToEven(formats.paddingRow)
    }
  }
}

function writeFunction(
  output: BinaryRegion,
  func: IL.Function,
  ctx: InstructionEmitContext,
  addressableReferences: Map<string, Future<Referenceable>>
) {
  writeFunctionHeader(output, func.maxStackDepth, func.id);
  const functionOffset = output.currentOffset;
  ctx.addName(functionOffset, 'allocation', func.id);
  writeFunctionBody(output, func, ctx, addressableReferences);
  return { functionOffset };
}

function writeFunctionHeader(output: BinaryRegion, maxStackDepth: number, funcId: string) {
  const typeCode = TeTypeCode.TC_REF_FUNCTION;
  const continuationFlag: 0 | 1 = 0;
  // Allocation headers on functions are different. Nothing needs the allocation
  // size specifically, so the 12 size bits are repurposed.
  const headerWord = UInt8(maxStackDepth) | (continuationFlag << 11) | (typeCode << 12);
  output.padToQuad(formats.paddingRow, 2);
  output.append(headerWord, `Func alloc header (${funcId})`, formats.uHex16LERow);
}

type MemoryRegionID = 'bytecode' | 'gc' | 'globals';

// A referenceable is something that can produce a reference pointer, if you
// tell it where it's pointing from
export type Referenceable = {
  debugName: string;
  getPointer: (sourceRegion: MemoryRegionID, debugName: string) => Future<mvm_Value>;
  // Offset in bytecode
  offset: Future<number>;
}


function* enumerateAddressableReferences(snapshot: SnapshotIL): IterableIterator<IL.ProgramAddressValue> {
  for (const [funcId, func] of snapshot.functions.entries()) {
    for (const [blockId, block] of Object.entries(func.blocks)) {
      for (const [operationIndex, op] of block.operations.entries()) {
        if (op.opcode === 'AsyncResume') {
          yield { type: 'ProgramAddressValue', funcId, blockId, operationIndex }
        }
        if (op.opcode === 'StartTry') {
          const target = op.operands[0] as IL.LabelOperand;
          yield {
            type: 'ProgramAddressValue',
            funcId,
            blockId: target.targetBlockId,
            operationIndex: 0
          }
        }
      }
    }
  }
}

export function programAddressToKey({ funcId, blockId, operationIndex }: IL.ProgramAddressValue): string {
  return JSON.stringify([funcId, blockId, operationIndex]);
}

const assertUInt16 = Future.lift((v: number) => hardAssert(isUInt16(v)));
const assertUInt14 = Future.lift((v: number) => hardAssert(isUInt14(v)));
const assertIsEven = (v: Future<number>, msg: string) => v.map(v => hardAssert(v % 2 === 0, msg));

