import * as VM from './virtual-machine-types';
import * as IL from './il';
import * as IM from 'immutable';
import { notImplemented, assertUnreachable, assert, notUndefined, unexpected, invalidOperation, entries, stringifyIdentifier, todo, stringifyStringLiteral } from './utils';
import * as _ from 'lodash';
import { vm_Reference, mvm_Value, vm_TeWellKnownValues, TeTypeCode, vm_TeValueTag, UInt8, UInt4, isUInt12, isSInt14, isSInt32, isUInt16, isUInt4, isSInt8, isUInt8, SInt8, isSInt16, UInt16, SInt16, isUInt14, mvm_TeError  } from './runtime-types';
import { stringifyOperation } from './stringify-il';
import { BinaryRegion, Future, FutureLike, Labelled } from './binary-region';
import { HTML, Format, BinaryData } from './visual-buffer';
import * as formats from './snapshot-binary-html-formats';
import escapeHTML from 'escape-html';
import { SnapshotClass } from './snapshot';
import { vm_TeOpcode, vm_TeOpcodeEx1, vm_TeOpcodeEx2, vm_TeOpcodeEx3, vm_TeSmallLiteralValue, VM_RETURN_FLAG_POP_FUNCTION, VM_RETURN_FLAG_UNDEFINED, vm_TeNumberOp, vm_TeBitwiseOp } from './bytecode-opcodes';
import { SnapshotInfo, validateSnapshotBinary, BYTECODE_VERSION, ENGINE_VERSION } from './snapshot-info';
import { crc16ccitt } from 'crc';
import { SnapshotReconstructionInfo } from './decode-snapshot';

export function encodeSnapshot(snapshot: SnapshotInfo, generateDebugHTML: boolean): {
  snapshot: SnapshotClass,
  html?: HTML
} {
  const names: SnapshotReconstructionInfo['names'] = {};
  const bytecode = new BinaryRegion(formats.tableContainer);
  const largePrimitives = new BinaryRegion();
  const romAllocations = new BinaryRegion();
  const dataAllocations = new BinaryRegion();
  const importTable = new BinaryRegion();

  const largePrimitivesMemoizationTable = new Array<{ data: Buffer, reference: Future<mvm_Value> }>();
  const importLookup = new Map<IL.HostFunctionID, number>();
  const strings = new Map<string, Future<vm_Reference>>();
  const globalSlotIndexMapping = new Map<VM.GlobalSlotID, number>();

  // The GC roots are the offsets in data memory of values that can point to GC,
  // not including the global variables
  const gcRoots = new Array<Future>();

  let importCount = 0;

  const headerSize = new Future();
  const bytecodeSize = new Future();
  const crcRangeStart = new Future();
  const crcRangeEnd = new Future();
  const initialDataOffset = new Future();
  const initialDataSize = new Future();
  const initialHeapOffset = new Future();
  const initialHeapSize = new Future();
  const gcRootsOffset = new Future();
  const gcRootsCount = new Future();
  const importTableOffset = new Future();
  const importTableSize = new Future();
  const exportTableOffset = new Future();
  const exportTableSize = new Future();
  const shortCallTableOffset = new Future();
  const shortCallTableSize = new Future();
  const stringTableOffset = new Future();
  const stringTableSize = new Future();

  // This represents a stub function that will be used in place of ephemeral
  // functions that might be accessed in the snapshot. It's created lazily
  // because it consumes space and there aren't necessarily any reachable
  // references to ephemeral functions
  let detachedEphemeralFunction: Future<mvm_Value> | undefined;
  const detachedEphemeralFunctionBytecode = new BinaryRegion();

  const detachedEphemeralObjects = new Map<IL.EphemeralObjectID, Future<mvm_Value>>();
  const detachedEphemeralObjectBytecode = new BinaryRegion();

  const functionReferences = new Map([...snapshot.functions.keys()]
    .map(k => [k, new Future<mvm_Value>()]));

  const functionOffsets = new Map([...snapshot.functions.keys()]
    .map(k => [k, new Future()]));

  const allocationReferences = new Map([...snapshot.allocations.keys()]
    .map(k => [k, new Future<mvm_Value>()]));

  // Using immutable-js type because we can key on a Set
  type StructMeta = { offset: Future, props: Array<VM.PropertyKey> };
  let structLayouts = IM.Map<IM.Set<VM.PropertyKey>, StructMeta>();
  const storeObjectAsStruct = new Map<IL.AllocationID, StructMeta>();

  const globalVariableCount = snapshot.globalSlots.size;

  const shortCallTable = new Array<CallInfo>();

  let requiredFeatureFlags = 0;
  for (const flag of snapshot.flags) {
    assert(flag >=0 && flag < 32);
    requiredFeatureFlags |= 1 << flag;
  }

  assignIndexesToGlobalSlots();

  // Header
  bytecode.append(BYTECODE_VERSION, 'bytecodeVersion', formats.uInt8Row);
  bytecode.append(headerSize, 'headerSize', formats.uInt8Row);
  bytecode.append(bytecodeSize, 'bytecodeSize', formats.uInt16LERow);
  bytecode.append(bytecode.postProcess(crcRangeStart, crcRangeEnd, crc16ccitt), 'crc', formats.uHex16LERow);
  crcRangeStart.assign(bytecode.currentOffset);
  bytecode.append(ENGINE_VERSION, 'requiredEngineVersion', formats.uInt16LERow);
  bytecode.append(requiredFeatureFlags, 'requiredFeatureFlags', formats.uHex32LERow);
  bytecode.append(globalVariableCount, 'globalVariableCount', formats.uInt16LERow);
  bytecode.append(initialDataOffset, 'initialDataOffset', formats.uHex16LERow);
  bytecode.append(initialDataSize, 'initialDataSize', formats.uInt16LERow);
  bytecode.append(initialHeapOffset, 'initialHeapOffset', formats.uHex16LERow);
  bytecode.append(initialHeapSize, 'initialHeapSize', formats.uInt16LERow);
  bytecode.append(gcRootsOffset, 'gcRootsOffset', formats.uHex16LERow);
  bytecode.append(gcRootsCount, 'gcRootsCount', formats.uInt16LERow);
  bytecode.append(importTableOffset, 'importTableOffset', formats.uHex16LERow);
  bytecode.append(importTableSize, 'importTableSize', formats.uInt16LERow);
  bytecode.append(exportTableOffset, 'exportTableOffset', formats.uHex16LERow);
  bytecode.append(exportTableSize, 'exportTableSize', formats.uInt16LERow);
  bytecode.append(shortCallTableOffset, 'shortCallTableOffset', formats.uHex16LERow);
  bytecode.append(shortCallTableSize, 'shortCallTableSize', formats.uInt16LERow);
  bytecode.append(stringTableOffset, 'stringTableOffset', formats.uHex16LERow);
  bytecode.append(stringTableSize, 'stringTableSize', formats.uInt16LERow);
  bytecode.append(0, 'reserved', formats.uInt16LERow);
  headerSize.assign(bytecode.currentOffset);

  // Metatable (occurs early in bytecode because meta-table references are only 12-bit)
  writeMetaTable(bytecode);

  // Initial data memory
  initialDataOffset.assign(bytecode.currentOffset);
  writeGlobalSlots();
  bytecode.appendBuffer(dataAllocations);
  const initialDataEnd = bytecode.currentOffset;
  // For the moment, all the data is initialized
  initialDataSize.assign(initialDataEnd.subtract(initialDataOffset));

  // Initial heap
  initialHeapOffset.assign(bytecode.currentOffset);
  writeInitialHeap(bytecode);
  const initialHeapEnd = bytecode.currentOffset;
  initialHeapSize.assign(initialHeapEnd.subtract(initialHeapOffset));

  // GC Roots
  gcRootsOffset.assign(bytecode.currentOffset);
  gcRootsCount.assign(gcRoots.length);
  for (const gcRoot of gcRoots) {
    bytecode.append(gcRoot.subtract(initialDataOffset), undefined, formats.uInt16LERow);
  }

  // Import table
  const importTableStart = bytecode.currentOffset;
  importTableOffset.assign(importTableStart);
  bytecode.appendBuffer(importTable);
  const importTableEnd = bytecode.currentOffset;
  importTableSize.assign(importTableEnd.subtract(importTableStart));

  // Export table
  const exportTableStart = bytecode.currentOffset;
  exportTableOffset.assign(exportTableStart);
  writeExportTable();
  const exportTableEnd = bytecode.currentOffset;
  exportTableSize.assign(exportTableEnd.subtract(exportTableStart));

  // Short call table
  const shortCallTableStart = bytecode.currentOffset;
  shortCallTableOffset.assign(shortCallTableStart);
  writeShortCallTable();
  const shortCallTableEnd = bytecode.currentOffset;
  shortCallTableSize.assign(shortCallTableEnd.subtract(shortCallTableStart));

  // String table
  const stringTableStart = bytecode.currentOffset;
  stringTableOffset.assign(stringTableStart);
  writeStringTable(bytecode);
  const stringTableEnd = bytecode.currentOffset;
  stringTableSize.assign(stringTableEnd.subtract(stringTableStart));

  // Dynamically-sized primitives
  bytecode.appendBuffer(largePrimitives);

  // Functions
  writeFunctions(bytecode);
  bytecode.appendBuffer(detachedEphemeralFunctionBytecode);
  bytecode.appendBuffer(detachedEphemeralObjectBytecode);

  // ROM allocations
  bytecode.appendBuffer(romAllocations);

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
    offset.once('resolve', offset => names[offset] = name);
  }

  function writeMetaTable(region: BinaryRegion) {
    // Generate struct layouts
    for (const [allocationID, allocation] of snapshot.allocations) {
      if (allocation.type === 'ObjectAllocation') {
        const canBeStoredAsStruct = Boolean(allocation.keysAreFixed);
        if (canBeStoredAsStruct) {
          const keys = IM.Set(Object.keys(allocation.properties));
          // See if there's an existing layout with this set of keys.
          let layout = structLayouts.get(keys);
          // Otherwise create one
          if (!layout) {
            region.append(TeTypeCode.TC_REF_STRUCT, 'VM_TC_REF_STRUCT', formats.uInt16LERow);
            const offset = region.currentOffset;
            // Metadata addresses can only be within the 12 bit range
            offset.map(a => assert(isUInt12(a)));

            const props = [...keys]; // Keys but with a defined ordering
            region.append(props.length, 'Struct len', formats.uInt16LERow);
            for (const p of props) {
              region.append(getString(p), 'Prop' + p, formats.uInt16LERow);
            }
            layout = { offset, props };
            structLayouts = structLayouts.set(keys, layout);
          }
          storeObjectAsStruct.set(allocationID, layout);
        }
      }
    }
  }

  function writeGlobalSlots() {
    const globalSlots = snapshot.globalSlots;
    const variablesInOrderOfIndex = _.sortBy([...globalSlotIndexMapping], ([_name, index]) => index);
    for (const [slotID] of variablesInOrderOfIndex) {
      addName(bytecode.currentOffset, slotID);
      writeValue(bytecode, notUndefined(globalSlots.get(slotID)).value, false, slotID);
    }
  }

  function writeValue(region: BinaryRegion, value: IL.Value, inDataAllocation: boolean, label: string) {
    if (inDataAllocation) {
      gcRoots.push(region.currentOffset);
    }
    region.append(encodeValue(value), label, formats.uHex16LERow);
  }

  function encodeValue(value: IL.Value): FutureLike<mvm_Value> {
    switch (value.type) {
      case 'UndefinedValue': return vm_TeWellKnownValues.VM_VALUE_UNDEFINED;
      case 'BooleanValue': return value.value ? vm_TeWellKnownValues.VM_VALUE_TRUE : vm_TeWellKnownValues.VM_VALUE_FALSE;
      case 'NullValue': return vm_TeWellKnownValues.VM_VALUE_NULL;
      case 'NumberValue': {
        if (isNaN(value.value)) return vm_TeWellKnownValues.VM_VALUE_NAN;
        if (Object.is(value.value, -0)) return vm_TeWellKnownValues.VM_VALUE_NEG_ZERO;
        if (isSInt14(value.value)) return value.value & 0x3FFF;
        if (isSInt32(value.value)) return allocateLargePrimitive(TeTypeCode.TC_REF_INT32, b => b.append(value.value, 'Int32', formats.sInt32LERow));
        return allocateLargePrimitive(TeTypeCode.TC_REF_FLOAT64, b => b.append(value.value, 'Double', formats.doubleLERow));
      };
      case 'StringValue': return getString(value.value);
      case 'FunctionValue': {
        return notUndefined(functionReferences.get(value.value));
      }
      case 'ReferenceValue': {
        const allocationID = value.value;
        return notUndefined(allocationReferences.get(allocationID));
      }
      case 'HostFunctionValue': {
        const hostFunctionID = value.value;
        let importIndex = getImportIndexOfHostFunctionID(hostFunctionID);
        return allocateLargePrimitive(TeTypeCode.TC_REF_HOST_FUNC, w => w.append(importIndex, 'Host func', formats.uInt16LERow));
      }
      case 'EphemeralFunctionValue': {
        return getDetachedEphemeralFunction();
      }
      case 'EphemeralObjectValue': {
        return getDetachedEphemeralObject(value);
      }
      default: return assertUnreachable(value);
    }
  }

  function getDetachedEphemeralFunction(): Future<mvm_Value> {
    // Create lazily
    if (detachedEphemeralFunction === undefined) {
      detachedEphemeralFunction = writeDetachedEphemeralFunction(detachedEphemeralFunctionBytecode);
    }
    return detachedEphemeralFunction;
  }

  function getDetachedEphemeralObject(original: IL.EphemeralObjectValue): Future<mvm_Value> {
    const ephemeralObjectID = original.value;
    let target = detachedEphemeralObjects.get(ephemeralObjectID);
    if (!target) {
      // Create an empty object representing the detached ephemeral
      const { reference, offset } = writeObject(detachedEphemeralObjectBytecode, {}, vm_TeValueTag.VM_TAG_PGM_P);
      target = reference;
      addName(offset, ephemeralObjectID.toString());
      detachedEphemeralObjects.set(ephemeralObjectID, target);
    }
    return target;
  }

  function writeDetachedEphemeralFunction(output: BinaryRegion) {
    // This is a stub function that just throws an MVM_E_DETACHED_EPHEMERAL
    // error when called
    const maxStackDepth = 0;
    const startAddress = output.currentOffset;
    const endAddress = new Future;
    writeFunctionHeader(output, maxStackDepth, startAddress, endAddress);
    output.append({
      binary: BinaryData([
        (vm_TeOpcode.VM_OP_EXTENDED_2 << 4) | (vm_TeOpcodeEx2.VM_OP2_RETURN_ERROR),
        mvm_TeError.MVM_E_DETACHED_EPHEMERAL
      ]),
      html: 'VM_OP4_CALL_DETACHED_EPHEMERAL'
    }, 'Detached ephemeral stub', formats.preformatted2);
    output.append({
      binary: BinaryData([
        (vm_TeOpcode.VM_OP_EXTENDED_1 << 4) | (vm_TeOpcodeEx1.VM_OP1_RETURN_3)
      ]),
      html: 'return undefined'
    }, undefined, formats.preformatted1);
    endAddress.assign(output.currentOffset);
    const ref = addressToReference(startAddress, vm_TeValueTag.VM_TAG_PGM_P);
    return ref;
  }

  function getString(s: string): Future<mvm_Value> {
    let ref = strings.get(s);
    if (ref) return ref;

    /*
     * Microvium does not allow the use of strings that are all digits as
     * property names, so they must be encoded as TC_REF_STRING. All others can be
     * used as property names and so will be encoded as TC_REF_UNIQUE_STRING.
     */
    const stringType = (/^\d+$/.test(s))
      ? TeTypeCode.TC_REF_STRING
      : TeTypeCode.TC_REF_UNIQUE_STRING;

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
    assert(isUInt16(hostFunctionID));
    importTable.append(hostFunctionID, undefined, formats.uInt16LERow);
    return importIndex;
  }

  // Note: These are memoized
  function allocateLargePrimitive(typeCode: TeTypeCode, writer: (buffer: BinaryRegion) => void): Future<mvm_Value> {
    // Encode as heap allocation
    const buffer = new BinaryRegion();
    const headerWord = new Future();
    buffer.append(headerWord, 'Allocation header', formats.uHex16LERow);
    const startAddress = buffer.currentOffset;
    writer(buffer);
    const size = buffer.currentOffset.subtract(startAddress);
    size.map(size => assert(size <= 0xFFF));
    headerWord.assign(size.map(size => size | (typeCode << 12)));
    const newAllocationData = buffer.toBuffer();
    const existingAllocation = largePrimitivesMemoizationTable.find(a => a.data.equals(newAllocationData));
    if (existingAllocation) {
      return existingAllocation.reference;
    } else {
      const address = largePrimitives.currentOffset.map(a => a + 2); // Add 2 to skip the headerWord
      largePrimitives.appendBuffer(buffer, 'Buffer');
      const reference = addressToReference(address, vm_TeValueTag.VM_TAG_PGM_P);
      largePrimitivesMemoizationTable.push({ data: newAllocationData, reference });
      return reference;
    }
  }

  function addressToReference(addressInBytecode: Future<number>, region: vm_TeValueTag) {
    let startOfMemoryRegion: Future<number>;
    switch (region) {
      case vm_TeValueTag.VM_TAG_DATA_P: startOfMemoryRegion = initialDataOffset; break;
      case vm_TeValueTag.VM_TAG_GC_P: startOfMemoryRegion = initialHeapOffset; break;
      case vm_TeValueTag.VM_TAG_PGM_P: startOfMemoryRegion = Future.create(0); break;
      default: return unexpected();
    }
    const relativeAddress = addressInBytecode.subtract(startOfMemoryRegion);
    return relativeAddress.map(relativeAddress => {
      assert(relativeAddress <= 0x3FFF);
      return relativeAddress | region;
    });
  }

  function writeInitialHeap(initialHeap: BinaryRegion): BinaryRegion {
    for (const [allocationID, allocation] of snapshot.allocations.entries()) {
      assert(allocation.allocationID === allocationID);
      const reference = notUndefined(allocationReferences.get(allocationID));
      const targetRegion = allocation.memoryRegion || 'gc';
      const targetRegionCode =
        targetRegion === 'rom' ? vm_TeValueTag.VM_TAG_PGM_P :
        targetRegion === 'data' ? vm_TeValueTag.VM_TAG_DATA_P :
        targetRegion === 'gc' ? vm_TeValueTag.VM_TAG_GC_P :
        assertUnreachable(targetRegion);
      const binaryRegion =
        targetRegion === 'rom' ? romAllocations :
        targetRegion === 'data' ? dataAllocations :
        targetRegion === 'gc' ? initialHeap :
        assertUnreachable(targetRegion);

      const { reference: r, offset } = writeAllocation(binaryRegion, allocation, targetRegionCode);
      addName(offset, allocation.allocationID.toString());
      reference.assign(r);
    }
    return initialHeap;
  }

  function writeAllocation(
    region: BinaryRegion,
    allocation: IL.Allocation,
    memoryRegion: vm_TeValueTag
  ): {
    reference: Future<vm_Reference>,
    offset: Future<number>
  } {
    switch (allocation.type) {
      case 'ArrayAllocation': return writeArray(region, allocation, memoryRegion);
      case 'ObjectAllocation': {
        const structLayout = storeObjectAsStruct.get(allocation.allocationID);
        if (structLayout) {
          return writeStruct(region, allocation, structLayout, memoryRegion);
        } else {
          return writeObject(region, allocation.properties, memoryRegion);
        }
      }
      default: return assertUnreachable(allocation);
    }
  }

  function writeObject(region: BinaryRegion, properties: IL.ObjectProperties, memoryRegion: vm_TeValueTag): {
    reference: Future<vm_Reference>,
    offset: Future<number>
  } {
    const typeCode = TeTypeCode.TC_REF_PROPERTY_LIST;
    const keys = Object.keys(properties);
    const size = 2;
    assert(isUInt12(size));
    assert(isUInt4(typeCode));
    const headerWord = size | (typeCode << 12);
    region.append(headerWord, 'TsPropertyList.[header]', formats.uHex16LERow);
    const objectOffset = region.currentOffset;

    // A "VM_TC_PROPERTY_LIST" is a linked list of property cells
    let pNext = new Future();
    // TsPropertyList
    region.append(pNext, 'TsPropertyList.[first]', formats.uHex16LERow); // Address of first cell
    for (const k of Object.keys(properties)) {
      pNext.assign(addressToReference(region.currentOffset, memoryRegion));
      pNext = new Future(); // Address of next cell
      // TsPropertyCell
      region.append(pNext, 'TsPropertyCell.[next]', formats.uHex16LERow);
      const inDataAllocation = memoryRegion === vm_TeValueTag.VM_TAG_DATA_P;
      writeValue(region, { type: 'StringValue' , value: k }, inDataAllocation, 'TsPropertyCell.[key]');
      writeValue(region, properties[k], inDataAllocation, 'Object.' + k);
    }
    // The last cell has no next pointer
    pNext.assign(0);

    return {
      reference: addressToReference(objectOffset, memoryRegion),
      offset: objectOffset
    }
  }

  function writeStruct(region: BinaryRegion, allocation: IL.ObjectAllocation, layout: StructMeta, memoryRegion: vm_TeValueTag): {
    reference: Future<vm_Reference>,
    offset: Future<number>
  } {
    const typeCode = TeTypeCode.TC_REF_STRUCT;

    region.append(layout.offset, 'struct layout ptr', formats.uHex16LERow);

    const propCount = layout.props.length;
    const allocationSize = propCount * 2;
    assert(isUInt12(allocationSize));
    assert(isUInt4(typeCode));
    const headerWord = allocationSize | (typeCode << 12);
    region.append(headerWord, 'struct header', formats.uHex16LERow);

    const structOffset = region.currentOffset;

    assert(Object.keys(allocation.properties).length === layout.props.length);

    // A struct has the fields stored contiguously
    for (const k of layout.props) {
      assert(k in allocation.properties);
      const v = allocation.properties[k];
      const isInDataAllocation = (memoryRegion === vm_TeValueTag.VM_TAG_DATA_P);
      writeValue(region, v, isInDataAllocation, `struct[${k}]`);
    }

    return {
      reference: addressToReference(structOffset, memoryRegion),
      offset: structOffset
    }
  }

  function writeArray(region: BinaryRegion, allocation: IL.ArrayAllocation, memoryRegion: vm_TeValueTag): {
    reference: Future<vm_Reference>,
    offset: Future<number>
  } {
    const inDataAllocation = memoryRegion === vm_TeValueTag.VM_TAG_DATA_P;
    const typeCode = TeTypeCode.TC_REF_ARRAY;
    const contents = allocation.items;
    const len = contents.length;

    region.append(len, `array: len=${len}`, formats.uInt16LERow);

    const allocationSize = len * 2;
    assert(isUInt12(allocationSize));
    assert(isUInt4(typeCode));
    const headerWord = allocationSize | (typeCode << 12);
    region.append(headerWord, 'array header', formats.uHex16LERow);

    // Address comes after the header word
    const arrayOffset = region.currentOffset;

    for (const [i, item] of contents.entries()) {
      writeValue(region, item, inDataAllocation, `array[${i}]`);
    }

    return {
      reference: addressToReference(arrayOffset, memoryRegion),
      offset: arrayOffset
    }
  }

  function writeExportTable() {
    for (const [exportID, value] of snapshot.exports) {
      assert(isUInt16(exportID));
      bytecode.append(exportID, undefined, formats.uInt16LERow);
      writeValue(bytecode, value, false, `Export ${exportID}`);
    }
  }

  function writeShortCallTable() {
    for (const entry of shortCallTable) {
      switch (entry.type) {
        case 'InternalFunction': {
          const functionOffset = notUndefined(functionOffsets.get(entry.functionID));
          // The high bit must be zero to indicate it's an internal function
          assertUInt14(functionOffset);
          bytecode.append(functionOffset, undefined, formats.uInt16LERow);
          bytecode.append(entry.argCount, undefined, formats.uInt8Row);
          break;
        }
        case 'HostFunction': {
          const functionIndex = entry.hostFunctionIndex;
          assert(isSInt14(functionIndex));
          // The high bit must be 1 to indicate it's an host function
          bytecode.append(functionIndex | 0x8000, undefined, formats.uInt16LERow);
          bytecode.append(entry.argCount, undefined, formats.uInt8Row);
          break;
        }
        default: return assertUnreachable(entry);
      }
    }
  }

  function writeStringTable(region: BinaryRegion) {
    const stringsInAlphabeticalOrder = _.sortBy([...strings.entries()], ([s, _ref]) => s);
    for (const [s, ref] of stringsInAlphabeticalOrder) {
      region.append(ref, '&' + s, formats.uHex16LERow);
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
      encodeValue,
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
      ref.assign(addressToReference(functionOffset, vm_TeValueTag.VM_TAG_PGM_P));
    }
  }

  function offsetOfFunction(id: IL.FunctionID): Future {
    return notUndefined(functionOffsets.get(id));
  }
}

function writeFunction(output: BinaryRegion, func: IL.Function, ctx: InstructionEmitContext) {
  const startAddress = output.currentOffset;
  const endAddress = new Future();
  const functionOffset = writeFunctionHeader(output, func.maxStackDepth, startAddress, endAddress);
  ctx.addName(functionOffset, func.id);
  writeFunctionBody(output, func, ctx);
  endAddress.assign(output.currentOffset);
  return { functionOffset };
}

function writeFunctionHeader(output: BinaryRegion, maxStackDepth: number, startAddress: Future<number>, endAddress: Future<number>) {
  const size = endAddress.subtract(startAddress);
  const typeCode = TeTypeCode.TC_REF_FUNCTION;
  const headerWord = size.map(size => {
    assert(isUInt12(size));
    return size | (typeCode << 12);
  });
  output.append(headerWord, 'Func alloc header', formats.uHex16LERow);
  // Pointers to the function will point to the address after the header word but before the stack depth
  const functionAddress = output.currentOffset;
  output.append(maxStackDepth, 'maxStackDepth', formats.uInt8Row);
  return functionAddress;
}

function writeFunctionBody(output: BinaryRegion, func: IL.Function, ctx: InstructionEmitContext): void {
  const emitter = new InstructionEmitter();

  interface OperationMeta {
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
        measuredSize.map(m => assert(m === opMeta.size));
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

  operationCall(ctx: InstructionEmitContext, op: IL.CallOperation, argCount: number) {
    const staticInfo = op.staticInfo;
    if (staticInfo && staticInfo.target.type === 'StaticEncoding') {
      const target = staticInfo.target.value;
      if (target.type === 'FunctionValue') {
        const functionID = target.value;
        if (staticInfo.shortCall) {
          // Short calls are single-byte instructions that use a nibble to
          // reference into the short-call table, which provides the information
          // about the function target and argument count
          const shortCallIndex = ctx.getShortCallIndex({ type: 'InternalFunction', functionID: target.value, argCount });
          return instructionPrimary(vm_TeOpcode.VM_OP_CALL_1, shortCallIndex, op);
        } else {
          const targetOffset = ctx.offsetOfFunction(functionID);
          return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_CALL_2, targetOffset, op, BinaryData([argCount]));
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
    } else {
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_CALL_3, argCount, op);
    }
  }

  operationJump(ctx: InstructionEmitContext, op: IL.Operation, targetBlockID: string): InstructionWriter {
    ctx.preferBlockToBeNext!(targetBlockID);
    return {
      maxSize: 3,
      emitPass2: ctx => {
        const tentativeOffset = ctx.tentativeOffsetOfBlock(targetBlockID);
        const distance = getJumpDistance(tentativeOffset);
        return {
          size:
            distance === 'zero' ? 0 :
            distance === 'close' ? 2 :
            distance === 'far' ? 3 :
            unexpected(),
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
      assert(isUInt8(index));
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_LOAD_ARG_2, index, op);
    }
  }

  operationLoadGlobal(ctx: InstructionEmitContext, op: IL.Operation, globalSlotID: VM.GlobalSlotID) {
    const slotIndex = ctx.indexOfGlobalSlot(globalSlotID);
    if (isUInt4(slotIndex)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_LOAD_GLOBAL_1, slotIndex, op);
    } else if (isUInt8(slotIndex)) {
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_LOAD_GLOBAL_2, slotIndex, op);
    } else if (isUInt16(slotIndex)) {
      return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_LOAD_GLOBAL_3, slotIndex, op);
    } else {
      return unexpected();
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
      assert(isSInt16(offset));
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
    return instructionPrimary(vm_TeOpcode.VM_OP_POP, count - 1, op);
  }

  operationReturn(_ctx: InstructionEmitContext, op: IL.Operation) {
    if (op.opcode !== 'Return') return unexpected();
    let popFunction: boolean;
    let returnUndefined: boolean;
    if (op.staticInfo) {
      popFunction = op.staticInfo.targetIsOnTheStack;
      returnUndefined = op.staticInfo.returnUndefined;
    } else {
      popFunction = true;
      returnUndefined = false;
    }
    return instructionEx1(vm_TeOpcodeEx1.VM_OP1_RETURN_1
      | (popFunction ? VM_RETURN_FLAG_POP_FUNCTION: 0)
      | (returnUndefined ? VM_RETURN_FLAG_UNDEFINED: 0), op);
  }

  operationStoreGlobal(ctx: InstructionEmitContext, op: IL.Operation, globalSlotID: VM.GlobalSlotID) {
    const index = ctx.indexOfGlobalSlot(globalSlotID);
    if (isUInt4(index)) {
      return instructionPrimary(vm_TeOpcode.VM_OP_STORE_GLOBAL_1, index, op);
    } else if (isUInt8(index)) {
      return instructionEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_STORE_GLOBAL_2, index, op);
    } else {
      assert(isUInt16(index));
      return instructionEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_STORE_GLOBAL_3, index, op);
    }
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
  assert(isUInt4(opcode));
  assert(isUInt4(param));
  const label = `${vm_TeOpcode[opcode]}(0x${param.toString(16)})`;
  const html = escapeHTML(stringifyOperation(op));
  const binary = BinaryData([(opcode << 4) | param]);
  return fixedSizeInstruction(1, r => r.append({ binary, html }, label, formats.preformatted1));
}

function instructionEx1(opcode: vm_TeOpcodeEx1, op: IL.Operation): InstructionWriter {
  assert(isUInt4(opcode));
  const label = vm_TeOpcodeEx1[opcode];
  const html = escapeHTML(stringifyOperation(op));
  const binary = BinaryData([(vm_TeOpcode.VM_OP_EXTENDED_1 << 4) | opcode]);
  return fixedSizeInstruction(1, r => r.append({ binary, html }, label, formats.preformatted1));
}

function instructionEx2Unsigned(opcode: vm_TeOpcodeEx2, param: UInt8, op: IL.Operation): InstructionWriter {
  assert(isUInt4(opcode));
  assert(isUInt8(param));
  const label = `${vm_TeOpcodeEx2[opcode]}(0x${param.toString(16)})`;
  const html = escapeHTML(stringifyOperation(op));
  const binary = BinaryData([
    (vm_TeOpcode.VM_OP_EXTENDED_2 << 4) | opcode,
    param
  ]);
  return fixedSizeInstruction(2, r => r.append({ binary, html }, label, formats.preformatted2));
}

function appendInstructionEx2Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: SInt8, op: IL.Operation) {
  assert(isUInt4(opcode));
  const label = `${vm_TeOpcodeEx2[opcode]}(0x${param.toString(16)})`;
  const html = escapeHTML(stringifyOperation(op));
  const binary = BinaryData([
    (vm_TeOpcode.VM_OP_EXTENDED_2 << 4) | opcode,
    param & 0xFF
  ]);
  region.append({ binary, html }, label, formats.preformatted2);
}

function instructionEx2Signed(opcode: vm_TeOpcodeEx2, param: SInt8, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(2, r => appendInstructionEx2Signed(r, opcode, param, op));
}

function instructionEx3Unsigned(opcode: vm_TeOpcodeEx3, param: FutureLike<UInt16>, op: IL.Operation, payload?: BinaryData): InstructionWriter {
  assert(isUInt4(opcode));
  assertUInt16(param);
  const label = vm_TeOpcodeEx3[opcode];
  const value = Future.map(param, param => {
    const html = escapeHTML(stringifyOperation(op));
    const binary = BinaryData([
      (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | opcode,
      param & 0xFF,
      param >> 8,
      ...(payload || [])
    ]);
    return { html, binary };
  })
  const size = 3 + (payload ? payload.length : 0);
  return fixedSizeInstruction(size, r => r.append(value, label, formats.preformatted3));
}

function appendInstructionEx3Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: SInt16, op: IL.Operation) {
  assert(isUInt4(opcode));
  assert(isSInt16(param));
  const label = `${vm_TeOpcodeEx3[opcode]}(0x${param.toString(16)})`;
  const value = Future.map(param, param => {
    const html = escapeHTML(stringifyOperation(op));
    const binary = BinaryData([
      (vm_TeOpcode.VM_OP_EXTENDED_3 << 4) | opcode,
      param & 0xFF,
      (param >> 8) & 0xFF
    ]);
    return { html, binary };
  })
  region.append(value, label, formats.preformatted3);
}

function instructionEx3Signed(opcode: vm_TeOpcodeEx3, param: SInt16, op: IL.Operation): InstructionWriter {
  return fixedSizeInstruction(3, r => appendInstructionEx3Signed(r, opcode, param, op));
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

const assertUInt16 = Future.lift((v: number) => assert(isUInt16(v)));
const assertUInt14 = Future.lift((v: number) => assert(isUInt14(v)));


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

