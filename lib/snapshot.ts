import * as VM from './virtual-machine-types';
import * as IL from './il';
import { crc16ccitt } from 'crc';
import { notImplemented, assertUnreachable, assert, notUndefined, unexpected, invalidOperation, entries, stringifyIdentifier, todo } from './utils';
import * as _ from 'lodash';
import { vm_Reference, vm_Value, vm_TeMetaType, vm_TeWellKnownValues, vm_TeTypeCode, vm_TeValueTag, vm_TeOpcode, vm_TeOpcodeEx1, UInt8, UInt4, isUInt12, isSInt14, isSInt32, isUInt16, isUInt4, isSInt8, vm_TeOpcodeEx2, isUInt8, SInt8, isSInt16, vm_TeOpcodeEx3, UInt16, SInt16, isUInt14, vm_TeOpcodeEx4 } from './runtime-types';
import { stringifyFunction, stringifyVMValue, stringifyAllocation } from './stringify-il';
import { BinaryRegion, Future, FutureLike, Labelled } from './binary-region';
import { HTML, Format } from './visual-buffer';
import * as formats from './snapshot-binary-html-formats';

const bytecodeVersion = 1;
const requiredFeatureFlags = 0;
const requiredEngineVersion = 0;

/**
 * A snapshot represents the state of the machine captured at a specific moment
 * in time.
 *
 * Note: Anchors are not part of the snapshot. Anchors represent references from
 * the host into the VM. These references are severed at the time that VM is
 * snapshotted.
 */
export interface Snapshot {
  globalSlots: Map<VM.GlobalSlotID, VM.GlobalSlot>;
  functions: Map<IL.FunctionID, VM.Function>;
  exports: Map<VM.ExportID, VM.Value>;
  allocations: Map<VM.AllocationID, VM.Allocation>;
  metaTable: Map<VM.MetaID, VM.Meta>;
}

export function bytecodeToSnapshot(bytecode: Buffer): Snapshot {
  return notImplemented();
}

export function saveSnapshotToBytecode(snapshot: Snapshot, generateDebugHTML: boolean): {
  bytecode: Buffer,
  html?: HTML
} {
  const bytecode = new BinaryRegion(formats.tableContainer, 'trace.snapshot.bytecode.html');
  const largePrimitives = new BinaryRegion();
  const romAllocations = new BinaryRegion();
  const dataAllocations = new BinaryRegion();
  const importTable = new BinaryRegion();

  const largePrimitivesMemoizationTable = new Array<{ data: Buffer, reference: Future<vm_Value> }>();
  const importLookup = new Map<VM.ExternalFunctionID, number>();
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
  const dataMemorySize = new Future();
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
  let detachedEphemeralFunction: Future<vm_Value> | undefined;
  let detachedEphemeralFunctionCode: undefined | BinaryRegion;

  const functionReferences = new Map([...snapshot.functions.keys()]
    .map(k => [k, new Future<vm_Value>()]));

  const functionOffsets = new Map([...snapshot.functions.keys()]
    .map(k => [k, new Future()]));

  const allocationReferences = new Map([...snapshot.allocations.keys()]
    .map(k => [k, new Future<vm_Value>()]));

  const metaAddresses = new Map([...snapshot.metaTable.keys()]
    .map(k => [k, new Future()]));

  const globalVariableCount = snapshot.globalSlots.size;

  const shortCallTable = new Array<CallInfo>();

  assignIndexesToGlobalSlots();

  // Header
  bytecode.append(bytecodeVersion, 'bytecodeVersion', formats.uInt8Row);
  bytecode.append(headerSize, 'headerSize', formats.uInt8Row);
  bytecode.append(bytecodeSize, 'bytecodeSize', formats.uInt16LERow);
  bytecode.append(bytecode.postProcess(crcRangeStart, crcRangeEnd, crc16ccitt), 'crc', formats.uHex16LERow);
  crcRangeStart.assign(bytecode.currentAddress);
  bytecode.append(requiredFeatureFlags, 'requiredFeatureFlags', formats.uHex32LERow);
  bytecode.append(requiredEngineVersion, 'requiredEngineVersion', formats.uInt16LERow);
  bytecode.append(globalVariableCount, 'globalVariableCount', formats.uInt16LERow);
  bytecode.append(dataMemorySize, 'dataMemorySize', formats.uInt16LERow);
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
  headerSize.assign(bytecode.currentAddress);

  // VTables (occurs early in bytecode because VTable references are only 12-bit)
  writeMetaTable();

  // Initial data memory
  initialDataOffset.assign(bytecode.currentAddress);
  writeGlobalSlots();
  bytecode.appendBuffer(dataAllocations);
  const initialDataEnd = bytecode.currentAddress;
  dataMemorySize.assign(initialDataEnd.subtract(initialDataOffset));
  // For the moment, all the data is initialized
  initialDataSize.assign(dataMemorySize);

  // Initial heap
  initialHeapOffset.assign(bytecode.currentAddress);
  writeInitialHeap(bytecode);
  const initialHeapEnd = bytecode.currentAddress;
  initialHeapSize.assign(initialHeapEnd.subtract(initialHeapOffset));

  // GC Roots
  gcRootsOffset.assign(bytecode.currentAddress);
  gcRootsCount.assign(gcRoots.length);
  for (const gcRoot of gcRoots) {
    bytecode.append(gcRoot.subtract(initialDataOffset), undefined, formats.uInt16LERow);
  }

  // Import table
  const importTableStart = bytecode.currentAddress;
  importTableOffset.assign(importTableStart);
  bytecode.appendBuffer(importTable);
  const importTableEnd = bytecode.currentAddress;
  importTableSize.assign(importTableEnd.subtract(importTableStart));

  // Export table
  const exportTableStart = bytecode.currentAddress;
  exportTableOffset.assign(exportTableStart);
  writeExportTable();
  const exportTableEnd = bytecode.currentAddress;
  exportTableSize.assign(exportTableEnd.subtract(exportTableStart));

  // Short call table
  const shortCallTableStart = bytecode.currentAddress;
  shortCallTableOffset.assign(shortCallTableStart);
  writeShortCallTable();
  const shortCallTableEnd = bytecode.currentAddress;
  shortCallTableSize.assign(shortCallTableEnd.subtract(shortCallTableStart));

  // String table
  const stringTableStart = bytecode.currentAddress;
  stringTableOffset.assign(stringTableStart);
  writeStringTable(bytecode);
  const stringTableEnd = bytecode.currentAddress;
  stringTableSize.assign(stringTableEnd.subtract(stringTableStart));

  // Dynamically-sized primitives
  bytecode.appendBuffer(largePrimitives);

  // Functions
  writeFunctions(bytecode);
  detachedEphemeralFunctionCode && bytecode.appendBuffer(detachedEphemeralFunctionCode);

  // ROM allocations
  bytecode.appendBuffer(romAllocations);

  // Finalize
  const bytecodeEnd = bytecode.currentAddress;
  bytecodeSize.assign(bytecodeEnd);
  crcRangeEnd.assign(bytecodeEnd);

  return {
    bytecode: bytecode.toBuffer(false),
    html: generateDebugHTML ? bytecode.toHTML() : undefined
  };

  function writeMetaTable() {
    for (const [k, v] of snapshot.metaTable) {
      const address = notUndefined(metaAddresses.get(k));
      address.map(a => assert(isUInt12(a)));
      address.assign(bytecode.currentAddress);
      switch (v.type) {
        case 'StructKeysMeta': {
          bytecode.append(vm_TeMetaType.VM_MT_STRUCT, undefined, formats.uInt16LERow);
          bytecode.append(v.propertyKeys.length, undefined, formats.uInt16LERow);
          for (const p of v.propertyKeys) {
            bytecode.append(getString(p), undefined, formats.uInt16LERow);
          }
          break;
        }
        default: return assertUnreachable(v.type);
      }
    }
  }

  function writeGlobalSlots() {
    const globalSlots = snapshot.globalSlots;
    const variablesInOrderOfIndex = _.sortBy([...globalSlotIndexMapping], ([_name, index]) => index);
    for (const [slotID] of variablesInOrderOfIndex) {
      writeValue(bytecode, notUndefined(globalSlots.get(slotID)).value, false, slotID);
    }
  }

  function writeValue(region: BinaryRegion, value: VM.Value, inDataAllocation: boolean, label: string) {
    if (inDataAllocation) {
      gcRoots.push(region.currentAddress);
    }
    region.append(encodeValue(value), label, formats.uHex16LERow);
  }

  function encodeValue(value: VM.Value): FutureLike<vm_Value> {
    switch (value.type) {
      case 'UndefinedValue': return vm_TeWellKnownValues.VM_VALUE_UNDEFINED;
      case 'BooleanValue': return value.value ? vm_TeWellKnownValues.VM_VALUE_TRUE : vm_TeWellKnownValues.VM_VALUE_FALSE;
      case 'NullValue': return vm_TeWellKnownValues.VM_VALUE_NULL;
      case 'NumberValue': {
        if (isNaN(value.value)) return vm_TeWellKnownValues.VM_VALUE_NAN;
        if (value.value === Infinity) return vm_TeWellKnownValues.VM_VALUE_INF;
        if (value.value === -Infinity) return vm_TeWellKnownValues.VM_VALUE_NEG_INF;
        if (Object.is(value.value, -0)) return vm_TeWellKnownValues.VM_VALUE_NEG_ZERO;
        if (isSInt14(value.value)) return value.value & 0x3FFF;
        if (isSInt32(value.value)) return allocateLargePrimitive(vm_TeTypeCode.VM_TC_INT32, b => b.append(value.value, 'Int32', formats.sInt32LERow));
        return allocateLargePrimitive(vm_TeTypeCode.VM_TC_DOUBLE, b => b.append(value.value, 'Double', formats.doubleLERow));
      };
      case 'StringValue': return getString(value.value);
      case 'FunctionValue': {
        return notUndefined(functionReferences.get(value.value));
      }
      case 'ReferenceValue': {
        const allocationID = value.value;
        return notUndefined(allocationReferences.get(allocationID));
      }
      case 'ExternalFunctionValue': {
        const externalFunctionID = value.value;
        let importIndex = getImportIndexOfExternalFunctionID(externalFunctionID);
        return allocateLargePrimitive(vm_TeTypeCode.VM_TC_EXT_FUNC, w => w.append(importIndex, 'Ext func', formats.sInt16LERow));
      }
      case 'EphemeralFunctionValue': {
        return getDetachedEphemeralFunction();
      }
      default: return assertUnreachable(value);
    }
  }

  function getDetachedEphemeralFunction(): Future<vm_Value> {
    // Create lazily
    if (detachedEphemeralFunction === undefined) {
      detachedEphemeralFunctionCode = new BinaryRegion();
      detachedEphemeralFunction = writeDetachedEphemeralFunction(detachedEphemeralFunctionCode);
    }
    return detachedEphemeralFunction;
  }

  function writeDetachedEphemeralFunction(output: BinaryRegion) {
    const maxStackDepth = 0;
    const startAddress = output.currentAddress;
    const endAddress = new Future;
    writeFunctionHeader(output, maxStackDepth, startAddress, endAddress);
    output.append((vm_TeOpcode.VM_OP_EXTENDED_1 << 4) | (vm_TeOpcodeEx1.VM_OP1_EXTENDED_4), undefined, formats.uInt8Row);
    output.append(vm_TeOpcodeEx4.VM_OP4_CALL_DETACHED_EPHEMERAL, undefined, formats.uInt8Row);
    output.append((vm_TeOpcode.VM_OP_EXTENDED_1 << 4) | (vm_TeOpcodeEx1.VM_OP1_RETURN_3), undefined, formats.uInt8Row);
    endAddress.assign(output.currentAddress);
    const ref = addressToReference(startAddress, vm_TeValueTag.VM_TAG_PGM_P);
    return ref;
  }

  function getString(s: string): Future<vm_Value> {
    if (s === '') return Future.create(vm_TeWellKnownValues.VM_VALUE_EMPTY_STRING);

    let ref = strings.get(s);
    if (ref) return ref;

    // Note: for simplicity, all strings in the bytecode are uniqued, rather
    // than figuring out which strings are used as property keys and which aren't
    const r = allocateLargePrimitive(vm_TeTypeCode.VM_TC_UNIQUED_STRING, w => w.append(s, 'String', formats.stringUtf8NTRow));
    strings.set(s, r);
    return r;
  }

  function getImportIndexOfExternalFunctionID(externalFunctionID: VM.ExternalFunctionID): number {
    let importIndex = importLookup.get(externalFunctionID);
    if (importIndex !== undefined) {
      return importIndex;
    }
    importIndex = importCount++;
    importLookup.set(externalFunctionID, importIndex);
    assert(isUInt16(externalFunctionID));
    importTable.append(externalFunctionID, undefined, formats.uInt16LERow);
    return importIndex;
  }

  function allocateLargePrimitive(typeCode: vm_TeTypeCode, writer: (buffer: BinaryRegion) => void): Future<vm_Value> {
    // Encode as heap allocation
    const buffer = new BinaryRegion();
    const headerWord = new Future();
    buffer.append(headerWord, undefined, formats.uInt16LERow);
    writer(buffer);
    const size = buffer.currentAddress;
    size.map(size => assert(size <= 0xFFF));
    headerWord.assign(size.map(size => size | (typeCode << 12)));
    const newAllocationData = buffer.toBuffer();
    const existingAllocation = largePrimitivesMemoizationTable.find(a => a.data.equals(newAllocationData));
    if (existingAllocation) {
      return existingAllocation.reference;
    } else {
      const address = largePrimitives.currentAddress;
      largePrimitives.append(newAllocationData, 'Buffer', formats.bufferRow);
      const reference = addressToReference(address, vm_TeValueTag.VM_TAG_GC_P);
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
      const reference = notUndefined(allocationReferences.get(allocationID));
      const writeToROM = allocation.readonly;
      if (writeToROM) {
        const r = writeAllocation(romAllocations, allocation, vm_TeValueTag.VM_TAG_PGM_P);
        reference.assign(r);
      } else if (allocation.structureReadonly) {
        const r = writeAllocation(dataAllocations, allocation, vm_TeValueTag.VM_TAG_DATA_P);
        reference.assign(r);
      } else {
        const r = writeAllocation(initialHeap, allocation, vm_TeValueTag.VM_TAG_GC_P);
        reference.assign(r);
      }
    }
    return initialHeap;
  }

  function writeAllocation(region: BinaryRegion, allocation: VM.Allocation, memoryRegion: vm_TeValueTag): Future<vm_Reference> {
    switch (allocation.type) {
      case 'ArrayAllocation': return writeArray(region, allocation, memoryRegion);
      case 'ObjectAllocation': return writeObject(region, allocation, memoryRegion);
      case 'StructAllocation': return writeStruct(region, allocation, memoryRegion);
      default: return assertUnreachable(allocation);
    }
  }

  function writeObject(region: BinaryRegion, allocation: VM.ObjectAllocation, memoryRegion: vm_TeValueTag): Future<vm_Reference> {
    const contents = allocation.properties;
    const typeCode = vm_TeTypeCode.VM_TC_PROPERTY_LIST;
    const keys = Object.keys(contents);
    const keyCount = keys.length;
    assert(isUInt12(keyCount));
    assert(isUInt4(typeCode));
    const headerWord = keyCount | (typeCode << 12);
    region.append(headerWord, undefined, formats.uInt16LERow);
    const objectAddress = region.currentAddress;

    // A "VM_TC_PROPERTY_LIST" is a linked list of property cells
    let pNext = new Future();
    region.append(pNext, undefined, formats.uInt16LERow); // Address of first cell
    for (const k of Object.keys(contents)) {
      pNext.assign(region.currentAddress);
      pNext = new Future(); // Address of next cell
      region.append(pNext, undefined, formats.uInt16LERow);
      region.append(encodePropertyKey(k), undefined, formats.uInt16LERow);
      const inDataAllocation = memoryRegion === vm_TeValueTag.VM_TAG_DATA_P;
      writeValue(region, contents[k], inDataAllocation, k);
    }
    // The last cell has no next pointer
    pNext.assign(vm_TeWellKnownValues.VM_VALUE_UNDEFINED);

    return addressToReference(objectAddress, memoryRegion);
  }

  function writeStruct(region: BinaryRegion, allocation: VM.StructAllocation, memoryRegion: vm_TeValueTag): Future<vm_Reference> {
    const propertyValues = allocation.propertyValues;
    const typeCode = vm_TeTypeCode.VM_TC_VIRTUAL;
    const vTableAddress = notUndefined(metaAddresses.get(allocation.layoutMetaID));
    const headerWord = vTableAddress.map(vTableAddress => {
      assert(isUInt12(vTableAddress));
      assert(typeCode === vm_TeTypeCode.VM_TC_VIRTUAL);
      return vTableAddress | (typeCode << 12);
    });
    region.append(headerWord, undefined, formats.uInt16LERow);
    const structAddress = region.currentAddress;

    const layout = notUndefined(snapshot.metaTable.get(allocation.layoutMetaID));
    assert(allocation.propertyValues.length === layout.propertyKeys.length);

    // A struct has the fields stored contiguously
    for (const [k, v] of _.zip(layout.propertyKeys, propertyValues)) {
      if (v === undefined) return unexpected();
      if (k === undefined) return unexpected();
      const inDataAllocation = memoryRegion === vm_TeValueTag.VM_TAG_DATA_P;
      writeValue(region, v, inDataAllocation, k);
    }

    return addressToReference(structAddress, memoryRegion);
  }

  function encodePropertyKey(k: string): Future<vm_Reference> {
    return getString(k);
  }

  function writeArray(region: BinaryRegion, allocation: VM.ArrayAllocation, memoryRegion: vm_TeValueTag): Future<vm_Reference> {
    const inDataAllocation = memoryRegion === vm_TeValueTag.VM_TAG_DATA_P;
    const typeCode = allocation.structureReadonly ? vm_TeTypeCode.VM_TC_ARRAY : vm_TeTypeCode.VM_TC_LIST;
    const contents = allocation.items;
    const len = contents.length;
    assert(isUInt12(len));
    assert(isUInt4(typeCode));
    const headerWord = len | (typeCode << 12);
    region.append(headerWord, undefined, formats.uInt16LERow);

    // Address comes after the header word
    const arrayAddress = region.currentAddress;

    if (typeCode === vm_TeTypeCode.VM_TC_ARRAY) {
      for (const [i, item] of contents.entries()) {
        writeValue(region, item, inDataAllocation, i.toString());
      }
    } else if (typeCode === vm_TeTypeCode.VM_TC_LIST) {
      let pNext = new Future();
      let index = 0;
      region.append(pNext, undefined, formats.uInt16LERow); // Address of first cell
      for (const item of contents) {
        pNext.assign(region.currentAddress);
        pNext = new Future(); // Address of next cell
        region.append(pNext, undefined, formats.uInt16LERow);
        const label = (index++).toString();
        writeValue(region, item, inDataAllocation, label);
      }
      // The last cell has no next pointer
      pNext.assign(0);
    } else assertUnreachable(typeCode);

    return addressToReference(arrayAddress, memoryRegion);
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
        case 'ExternalFunction': {
          const functionIndex = notUndefined(importLookup.get(entry.externalFunctionID));
          assert(isSInt14(functionIndex));
          // The high bit must be 1 to indicate it's an external function
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
      const refValue = addressToReference(bytecode.currentAddress, vm_TeValueTag.VM_TAG_PGM_P);
      ref.assign(refValue);
      region.append(s, undefined, formats.stringUtf8NTRow);
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
      getShortCallIndex(callInfo: CallInfo) {
        let index = shortCallTable.findIndex(s =>
          s.argCount === callInfo.argCount &&
          ((callInfo.type === 'InternalFunction' && s.type === 'InternalFunction' && s.functionID === callInfo.functionID) ||
          ((callInfo.type === 'ExternalFunction' && s.type === 'ExternalFunction' && s.externalFunctionID === callInfo.externalFunctionID))));
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
      offsetOfFunction,
      indexOfGlobalSlot(id: VM.GlobalSlotID): number {
        return notUndefined(globalSlotIndexMapping.get(id));
      }
    };

    for (const [name, func] of snapshot.functions.entries()) {
      const { startAddress } = writeFunction(output, func, ctx);

      const offset = notUndefined(functionOffsets.get(name));
      offset.assign(startAddress);
      const ref = notUndefined(functionReferences.get(name));
      ref.assign(addressToReference(startAddress, vm_TeValueTag.VM_TAG_PGM_P));
    }
  }

  function offsetOfFunction(id: IL.FunctionID): Future {
    return notUndefined(functionOffsets.get(id));
  }
}

function writeFunction(output: BinaryRegion, func: VM.Function, ctx: InstructionEmitContext) {
  const startAddress = output.currentAddress;
  const endAddress = new Future();
  writeFunctionHeader(output, func.maxStackDepth, startAddress, endAddress);
  writeFunctionBody(output, func, ctx);
  endAddress.assign(output.currentAddress);
  return { startAddress };
}

function writeFunctionHeader(output: BinaryRegion, maxStackDepth: number, startAddress: Future<number>, endAddress: Future<number>) {
  const size = endAddress.subtract(startAddress);
  const typeCode = vm_TeTypeCode.VM_TC_FUNCTION;
  const headerWord = size.map(size => {
    assert(isUInt12(size));
    return size | (typeCode << 12);
  });
  output.append(maxStackDepth, undefined, formats.uInt8Row);
  output.append(headerWord, undefined, formats.uInt16LERow);
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
    // In a first pass, we estimate the layout based on the maximum possible size
    // of each instruction. Instructions such as JUMP can take different forms
    // depending on the distance of the jump, and the distance of the JUMP in turn
    // depends on size of other instructions in between the jump origin and
    // target, which may include other jumps etc.
    let addressEstimate = 0;
    for (const [blockID, block] of Object.entries(func.blocks)) {
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
  }

  function pass2() {
    let currentOperationMeta: OperationMeta;
    const ctx: Pass2Context = {
      tentativeOffsetOfBlock: (blockID: IL.BlockID) => {
        const targetBlock = notUndefined(metaByBlock.get(blockID));
        const blockAddress = targetBlock.addressEstimate;
        const operationAddress = currentOperationMeta.addressEstimate;
        const operationSize = currentOperationMeta.sizeEstimate;
        // The jump offset is measured from the end of the current operation, but
        // we don't know exactly how big it is so we take the worst case distance
        let maxOffset = (blockAddress > operationAddress
          ? blockAddress - operationAddress
          : blockAddress - (operationAddress + operationSize));
        return maxOffset;
      }
    };

    let addressEstimate = 0;
    for (const [blockID, block] of Object.entries(func.blocks)) {
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
    const ctx: Pass3Context = {
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

    for (const [, block] of Object.entries(func.blocks)) {
      for (const op of block.operations) {
        const opMeta = notUndefined(metaByOperation.get(op));
        currentOperationMeta = opMeta;
        const offsetBefore = output.currentAddress;
        opMeta.emitPass3(ctx);
        const offsetAfter = output.currentAddress;
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
    todo('Implement opcode emitter: ' + op.opcode);
    return instructionNotImplemented;
  }
  if (operands.length !== method.length - 2) {
    return unexpected();
  }

  return method(ctx, op, ...operands);
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
  type: 'ExternalFunction'
  externalFunctionID: VM.ExternalFunctionID,
  argCount: UInt8
};

interface InstructionEmitContext {
  getShortCallIndex(callInfo: CallInfo): number;
  offsetOfFunction: (id: IL.FunctionID) => Future<number>;
  indexOfGlobalSlot: (id: VM.GlobalSlotID) => number;
}

class InstructionEmitter {
  operationArrayGet() {
    return notImplemented();
  }

  operationArrayNew() {
    return notImplemented();
  }

  operationArraySet() {
    return notImplemented();
  }

  operationBinOp() {
    return notImplemented();
  }

  operationBranch() {
    return notImplemented();
  }

  operationCall(ctx: InstructionEmitContext, op: IL.CallOperation, argCount: number) {
    const staticInfo = op.staticInfo;
    if (staticInfo && staticInfo.target.type === 'StaticEncoding') {
      const target = staticInfo.target.value;
      // TODO: External functions are also valid here
      if (target.type !== 'FunctionValue') return invalidOperation('Static call target can only be a function');
      const functionID = target.value;
      if (staticInfo.shortCall) {
        // Short calls are single-byte instructions that use a nibble to
        // reference into the short-call table, which provides the information
        // about the function target and argument count
        // TODO: External functions are also valid here
        const shortCallIndex = ctx.getShortCallIndex({ type: 'InternalFunction', functionID: target.value, argCount });
        return fixedSizeInstruction(1, region => {
          assert(isUInt4(shortCallIndex));
          writeOpcode(region, vm_TeOpcode.VM_OP_CALL_1, shortCallIndex);
        });
      } else {
        const targetOffset = ctx.offsetOfFunction(functionID);
        return fixedSizeInstruction(4, region => {
          writeOpcodeEx3Unsigned(region, vm_TeOpcodeEx3.VM_OP3_CALL_2, targetOffset);
          assert(isUInt8(argCount));
          region.append(argCount, undefined, formats.uInt8Row);
        });
      }
    } else {
      return fixedSizeInstruction(2, region => {
        assert(isUInt8(argCount));
        writeOpcodeEx2Unsigned(region, vm_TeOpcodeEx2.VM_OP2_CALL_3, argCount);
      });
    }
  }

  operationCallMethod() {
    return notImplemented();
  }

  operationDecr() {
    return notImplemented();
  }

  operationDup() {
    return notImplemented();
  }

  operationIncr() {
    return notImplemented();
  }

  operationJump(_ctx: InstructionEmitContext, _op: IL.Operation, targetBlockID: string): InstructionWriter {
    return {
      maxSize: 3,
      emitPass2: ctx => {
        const tentativeOffset = ctx.tentativeOffsetOfBlock(targetBlockID);
        const isFar = !isSInt8(tentativeOffset);
        return {
          size: isFar ? 3 : 2,
          emitPass3: ctx => {
            const offset = ctx.offsetOfBlock(targetBlockID);
            // Stick to our committed shape
            if (isFar) {
              writeOpcodeEx3Signed(ctx.region, vm_TeOpcodeEx3.VM_OP3_JUMP_2, offset);
            } else {
              writeOpcodeEx2Signed(ctx.region, vm_TeOpcodeEx2.VM_OP2_JUMP_1, offset);
            }
          }
        }
      }
    }
  }

  operationLiteral() {
    return notImplemented();
  }

  operationLoadArg(_ctx: InstructionEmitContext, _op: IL.Operation, index: number) {
    if (isUInt4(index)) {
      return opcode(vm_TeOpcode.VM_OP_LOAD_ARG_1, index);
    } else {
      assert(isUInt8(index));
      return opcodeEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_LOAD_ARG_2, index);
    }
  }

  operationLoadGlobal() {
    return notImplemented();
  }

  operationLoadVar() {
    return notImplemented();
  }

  operationObjectGet() {
    return notImplemented();
  }

  operationObjectNew() {
    return notImplemented();
  }

  operationObjectSet() {
    return notImplemented();
  }

  operationPop() {
    return notImplemented();
  }

  operationReturn() {
    return notImplemented();
  }

  operationStoreGlobal(ctx: InstructionEmitContext, _op: IL.Operation, name: VM.GlobalSlotID) {
    const index = ctx.indexOfGlobalSlot(name);
    if (isUInt4(index)) {
      return opcode(vm_TeOpcode.VM_OP_STORE_GLOBAL_1, index);
    } else if (isUInt8(index)) {
      return opcodeEx2Unsigned(vm_TeOpcodeEx2.VM_OP2_STORE_GLOBAL_2, index);
    } else {
      assert(isUInt16(index));
      return opcodeEx3Unsigned(vm_TeOpcodeEx3.VM_OP3_STORE_GLOBAL_3, index);
    }
  }

  operationStoreVar() {
    return notImplemented();
  }

  operationUnOp() {
    return notImplemented();
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

function writeOpcode(region: BinaryRegion, opcode: vm_TeOpcode, param: UInt4) {
  assert(isUInt4(opcode));
  assert(isUInt4(param));
  region.append((opcode << 4) | param, undefined, formats.uInt8Row);
}

function opcode(opcode: vm_TeOpcode, param: UInt4): InstructionWriter {
  return fixedSizeInstruction(1, r => writeOpcode(r, opcode, param));
}

function writeOpcodeEx1(region: BinaryRegion, opcode: vm_TeOpcodeEx1) {
  assert(isUInt4(opcode));
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_1, opcode);
}

function writeOpcodeEx2Unsigned(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: UInt8) {
  assert(isUInt4(opcode));
  assert(isUInt8(param));
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_2, opcode);
  region.append(param, undefined, formats.uInt8Row);
}

function opcodeEx2Unsigned(opcode: vm_TeOpcodeEx2, param: UInt8): InstructionWriter {
  return fixedSizeInstruction(2, r => writeOpcodeEx2Unsigned(r, opcode, param));
}

function writeOpcodeEx2Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx2, param: SInt8) {
  assert(isUInt4(opcode));
  assert(isSInt8(param));
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_2, opcode);
  region.append(param, undefined, formats.uInt8Row);
}

function writeOpcodeEx3Unsigned(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: FutureLike<UInt16>) {
  assert(isUInt4(opcode));
  assertUInt16(param);
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_3, opcode);
  region.append(param, undefined, formats.uInt16LERow);
}

function opcodeEx3Unsigned(opcode: vm_TeOpcodeEx3, param: FutureLike<UInt16>): InstructionWriter {
  return fixedSizeInstruction(3, r => writeOpcodeEx3Unsigned(r, opcode, param));
}

function writeOpcodeEx3Signed(region: BinaryRegion, opcode: vm_TeOpcodeEx3, param: SInt16) {
  assert(isUInt4(opcode));
  assert(isSInt16(param));
  writeOpcode(region, vm_TeOpcode.VM_OP_EXTENDED_3, opcode);
  region.append(param, undefined, formats.uInt16LERow);
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

export function stringifySnapshot(snapshot: Snapshot): string {
  return `${
    entries(snapshot.exports)
      .map(([k, v]) => `export ${k} = ${stringifyVMValue(v)};`)
      .join('\n')
  }\n\n${
    entries(snapshot.globalSlots)
      .map(([k, v]) => `slot ${stringifyIdentifier(k)} = ${stringifyVMValue(v.value)};`)
      .join('\n')
  }\n\n${
    entries(snapshot.functions)
      .map(([, v]) => stringifyFunction(v, ''))
      .join('\n\n')
  }\n\n${
    entries(snapshot.allocations)
      .map(([k, v]) => `allocation ${k} = ${stringifyAllocation(v, snapshot.metaTable)};`)
      .join('\n\n')
  }`;
}

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