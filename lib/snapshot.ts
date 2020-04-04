import * as VM from './virtual-machine-types';
import * as IL from './il';
import { crc16ccitt } from 'crc';
import { notImplemented, assertUnreachable, assert, notUndefined } from './utils';
import * as _ from 'lodash';
import { BufferWriter as BinaryRegion, Delayed, DelayedLike } from './binary';

const bytecodeVersion = 1;
const requiredFeatureFlags = 0;
const requiredEngineVersion = 0;

const VM_TAG_MASK       = 0xC000 // The tag is the top 2 bits
const VM_VALUE_MASK     = 0x3FFF // The value is the remaining 14 bits
const VM_VALUE_SIGN_BIT = 0x2000 // Sign bit used for signed numbers

type vm_Value = number;
type vm_Reference = vm_Value;

// Tag values
enum vm_TeValueTag {
  VM_TAG_INT    =  0x0000,
  VM_TAG_GC_P   =  0x4000,
  VM_TAG_DATA_P =  0x8000,
  VM_TAG_PGM_P  =  0xC000,
};

enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED    = vm_TeValueTag.VM_TAG_PGM_P | 0,
  VM_VALUE_NULL         = vm_TeValueTag.VM_TAG_PGM_P | 1,
  VM_VALUE_TRUE         = vm_TeValueTag.VM_TAG_PGM_P | 2,
  VM_VALUE_FALSE        = vm_TeValueTag.VM_TAG_PGM_P | 3,
  VM_VALUE_EMPTY_STRING = vm_TeValueTag.VM_TAG_PGM_P | 4,
  VM_VALUE_NAN          = vm_TeValueTag.VM_TAG_PGM_P | 5,
  VM_VALUE_INF          = vm_TeValueTag.VM_TAG_PGM_P | 6,
  VM_VALUE_NEG_INF      = vm_TeValueTag.VM_TAG_PGM_P | 7,
  VM_VALUE_NEG_ZERO     = vm_TeValueTag.VM_TAG_PGM_P | 8,
};

enum vm_TeTypeCode {
  // Value types
  VM_TC_WELL_KNOWN    = 0x0,
  VM_TC_INT14         = 0x1,

  // Reference types
  VM_TC_INT32          = 0x2,
  VM_TC_DOUBLE         = 0x3,
  VM_TC_STRING         = 0x4, // UTF8-encoded string
  VM_TC_UNIQUED_STRING = 0x5, // UTF8-encoded string
  VM_TC_PROPERTY_LIST  = 0x6, // Object represented as linked list of properties
  VM_TC_STRUCT         = 0x7, // Object represented as flat structure without explicit keys
  VM_TC_LIST           = 0x8, // Array represented as linked list
  VM_TC_ARRAY          = 0x9, // Array represented as contiguous array in memory
  VM_TC_FUNCTION       = 0xA, // Local function
  VM_TC_EXT_FUNC_ID    = 0xB, // External function by 16-bit ID
};

/**
 * A snapshot represents the state of the machine captured at a specific moment
 * in time.
 */
export interface Snapshot {
  globalVariables: { [name: string]: VM.Value };
  exports: { [name: string]: VM.Value };
  functions: { [name: string]: IL.Function };
  allocations: Map<number, VM.Allocation>;
}

export function loadSnapshotFromBytecode(bytecode: Buffer): Snapshot {
  return notImplemented();
}

export function saveSnapshotToBytecode(snapshot: Snapshot): Buffer {
  const bytecode = new BinaryRegion();
  const largePrimitives = new BinaryRegion();
  const romAllocations = new BinaryRegion();
  const importTable = new BinaryRegion();

  const largePrimitivesMemoizationTable = new Array<{ data: Buffer, reference: Delayed<vm_Value> }>();
  const importLookup = new Map<VM.ExternalFunctionID, number>();
  const strings = new Map<string, Delayed<vm_Reference>>();
  const uniquedStrings = new Map<string, Delayed<vm_Reference>>();

  let importCount = 0;

  const headerSize = new Delayed();
  const bytecodeSize = new Delayed();
  const crcRangeStart = new Delayed();
  const crcRangeEnd = new Delayed();
  const dataMemorySize = new Delayed();
  const initialDataOffset = new Delayed();
  const initialDataSize = new Delayed();
  const initialHeapOffset = new Delayed();
  const initialHeapSize = new Delayed();
  const importTableOffset = new Delayed();
  const importTableSize = new Delayed();
  const exportTableOffset = new Delayed();
  const exportTableSize = new Delayed();
  const shortCallTableOffset = new Delayed();
  const shortCallTableSize = new Delayed();
  const uniquedStringTableOffset = new Delayed();
  const uniquedStringTableSize = new Delayed();

  const functionReferences = new Map(Object.keys(snapshot.functions)
    .map(k => [k, new Delayed<vm_Value>()]));

  const allocationReferences = new Map([...snapshot.allocations.keys()]
    .map(k => [k, new Delayed<vm_Value>()]));

  // Header
  bytecode.writeUInt8(bytecodeVersion);
  bytecode.writeUInt8(headerSize);
  bytecode.writeUInt16LE(bytecodeSize);
  bytecode.writeUInt16LE(bytecode.postProcess(crcRangeStart, crcRangeEnd, crc16ccitt));
  crcRangeStart.assign(bytecode.currentAddress);
  bytecode.writeUInt32LE(requiredFeatureFlags);
  bytecode.writeUInt16LE(requiredEngineVersion);
  bytecode.writeUInt16LE(dataMemorySize);
  bytecode.writeUInt16LE(initialDataOffset);
  bytecode.writeUInt16LE(initialDataSize);
  bytecode.writeUInt16LE(initialHeapOffset);
  bytecode.writeUInt16LE(initialHeapSize);
  bytecode.writeUInt16LE(importTableOffset);
  bytecode.writeUInt16LE(importTableSize);
  bytecode.writeUInt16LE(exportTableOffset);
  bytecode.writeUInt16LE(exportTableSize);
  bytecode.writeUInt16LE(shortCallTableOffset);
  bytecode.writeUInt16LE(shortCallTableSize);
  bytecode.writeUInt16LE(uniquedStringTableOffset);
  bytecode.writeUInt16LE(uniquedStringTableSize);
  headerSize.assign(bytecode.currentAddress);

  // Global variables
  const initialDataStart = bytecode.currentAddress;
  initialDataOffset.assign(initialDataStart);
  writeGlobalVariables();
  const initialDataEnd = bytecode.currentAddress;
  initialDataSize.assign(initialDataEnd.subtract(initialDataStart));

  // Initial heap
  const initialHeapStart = bytecode.currentAddress;
  initialHeapOffset.assign(initialHeapStart);
  const initialHeap = createInitialHeap();
  // Note: the initial heap has it's own memory space, so we need to use `toBuffer` so that its addresses start at zero
  bytecode.writeBuffer(initialHeap.toBuffer());
  const initialHeapEnd = bytecode.currentAddress;
  initialHeapSize.assign(initialHeapEnd.subtract(initialHeapStart));

  // Import table
  const importTableStart = bytecode.currentAddress;
  importTableOffset.assign(importTableStart);
  writeImportTable();
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
  const uniquedStringTableStart = bytecode.currentAddress;
  uniquedStringTableOffset.assign(uniquedStringTableStart);
  writeUniquedStringTable();
  const uniquedStringTableEnd = bytecode.currentAddress;
  uniquedStringTableSize.assign(uniquedStringTableEnd.subtract(uniquedStringTableStart));

  // Dynamically-sized primitives
  bytecode.writeBuffer(largePrimitives);

  // Functions
  writeFunctions();

  // ROM allocations
  bytecode.writeBuffer(romAllocations);

  // Finalize
  const bytecodeEnd = bytecode.currentAddress;
  bytecodeSize.assign(bytecodeEnd);
  crcRangeEnd.assign(bytecodeEnd);

  return bytecode.toBuffer();

  function writeGlobalVariables() {
    const globalVariables = snapshot.globalVariables;
    const globalVariableNames = Object.keys(globalVariables);
    const globalVariableCount = globalVariableNames.length;
    dataMemorySize.resolve(globalVariableCount * 2);

    const globalVariableIndexMapping = new Map<string, number>();
    const globalVariableIsUndefined = (k: string) => globalVariables[k].type === 'UndefinedValue';
    const globalsNeedingInitialization = globalVariableNames.filter(k => !globalVariableIsUndefined(k));
    const globalsNotNeedingInitialization = globalVariableNames.filter(globalVariableIsUndefined);

    let globalVariableIndex = 0;
    for (const k of globalsNeedingInitialization) {
      const i = globalVariableIndex++;
      globalVariableIndexMapping.set(k, i);
      const encoded = encodeValue(globalVariables[k]);
      bytecode.writeUInt16LE(encoded);
    }

    for (const k of globalsNotNeedingInitialization) {
      const i = globalVariableIndex++;
      globalVariableIndexMapping.set(k, i);
    }
  }

  function encodeValue(value: VM.Value): DelayedLike<vm_Value> {
    switch (value.type) {
      case 'UndefinedValue': return vm_TeWellKnownValues.VM_VALUE_UNDEFINED;
      case 'BooleanValue': return value.value ? vm_TeWellKnownValues.VM_VALUE_TRUE : vm_TeWellKnownValues.VM_VALUE_FALSE;
      case 'NullValue': return vm_TeWellKnownValues.VM_VALUE_NULL;
      case 'NumberValue': {
        if (isNaN(value.value)) return vm_TeWellKnownValues.VM_VALUE_NAN;
        if (value.value === Infinity) return vm_TeWellKnownValues.VM_VALUE_INF;
        if (value.value === -Infinity) return vm_TeWellKnownValues.VM_VALUE_NEG_INF;
        if (Object.is(value.value, -0)) return vm_TeWellKnownValues.VM_VALUE_NEG_ZERO;
        if (isInt14(value.value)) return value.value & 0x3FFF;
        if (isInt32(value.value)) return allocateLargePrimitive(vm_TeTypeCode.VM_TC_INT32, b => b.writeInt32LE(value.value));
        return allocateLargePrimitive(vm_TeTypeCode.VM_TC_DOUBLE, b => b.writeDoubleLE(value.value));
      };
      case 'StringValue': return encodeString(value.value);
      case 'FunctionValue': {
        return notUndefined(functionReferences.get(value.functionID));
      }
      case 'ReferenceValue': {
        const allocationID = value.value;
        return notUndefined(allocationReferences.get(allocationID));
      }
      case 'ExternalFunctionValue': {
        const externalFunctionID = value.value;
        let importIndex = getImportIndexOfExternalFunctionID(externalFunctionID);
        return allocateLargePrimitive(vm_TeTypeCode.VM_TC_EXT_FUNC_ID, w => w.writeInt16LE(importIndex));
      }
      default: return assertUnreachable(value);
    }
  }

  function encodeString(s: string): Delayed<vm_Value> {
    if (s === '') return Delayed.create(vm_TeWellKnownValues.VM_VALUE_EMPTY_STRING);
    if (strings.has(s)) {
      return notUndefined(strings.get(s));
    }
    const r = allocateLargePrimitive(vm_TeTypeCode.VM_TC_STRING, w => w.writeStringNT(s, 'utf8'));
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
    importTable.writeUInt16LE(externalFunctionID);
    return importIndex;
  }

  function allocateLargePrimitive(typeCode: vm_TeTypeCode, writer: (buffer: BinaryRegion) => void): Delayed<vm_Value> {
    // Encode as heap allocation
    const buffer = new BinaryRegion();
    const headerWord = new Delayed();
    buffer.writeUInt16LE(headerWord);
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
      largePrimitives.writeBuffer(newAllocationData);
      const reference = addressToReference(address, vm_TeValueTag.VM_TAG_GC_P);
      largePrimitivesMemoizationTable.push({ data: newAllocationData, reference });
      return reference;
    }
  }

  function addressToReference(address: Delayed<number>, region: vm_TeValueTag) {
    return address.map(address => {
      assert(address <= 0x3FFF);
      return address | region
    });
  }

  function createInitialHeap(): BinaryRegion {
    const initialHeap = new BinaryRegion();
    for (const [allocationID, allocation] of snapshot.allocations.entries()) {
      const reference = notUndefined(allocationReferences.get(allocationID));
      const writeToROM = allocation.readonly;
      if (writeToROM) {
        const r = writeAllocation(romAllocations, allocation, vm_TeValueTag.VM_TAG_PGM_P);
        reference.assign(r);
      } else {
        const r = writeAllocation(initialHeap, allocation, vm_TeValueTag.VM_TAG_GC_P);
        reference.assign(r);
      }
    }
    return initialHeap;
  }

  function writeAllocation(region: BinaryRegion, allocation: VM.Allocation, memoryRegion: vm_TeValueTag): Delayed<vm_Reference> {
    switch (allocation.type) {
      case 'ArrayAllocation': return writeArray(region, allocation, memoryRegion);
      case 'ObjectAllocation': return writeObject(region, allocation, memoryRegion);
      default: return assertUnreachable(allocation);
    }
  }

  function writeObject(region: BinaryRegion, allocation: VM.ObjectAllocation, memoryRegion: vm_TeValueTag): Delayed<vm_Reference> {
    const contents = allocation.value;
    const typeCode = allocation.structLayout ? vm_TeTypeCode.VM_TC_STRUCT : vm_TeTypeCode.VM_TC_PROPERTY_LIST;
    const keys = Object.keys(contents);
    const keyCount = keys.length;
    assert(isUInt12(keyCount));
    assert(isUInt4(typeCode));
    const headerWord = keyCount | (typeCode << 12);
    region.writeUInt16LE(headerWord);
    const objectAddress = region.currentAddress;

    if (allocation.structLayout) {
      assert(allocation.structLayout.length === keyCount);
      assert(allocation.structLayout.every(k => k in contents));
      // A struct has the fields stored contiguously
      for (const k of allocation.structLayout) {
        const encoded = encodeValue(contents[k]);
        region.writeUInt16LE(encoded);
      }
    } else {
      // A "VM_TC_PROPERTY_LIST" is a linked list of property cells
      let pNext = new Delayed();
      region.writeUInt16LE(pNext); // Address of first cell
      for (const k of Object.keys(contents)) {
        pNext.assign(region.currentAddress);
        pNext = new Delayed(); // Address of next cell
        region.writeUInt16LE(pNext);
        region.writeUInt16LE(encodePropertyKey(k));
        region.writeUInt16LE(encodeValue(contents[k]));
      }
      // The last cell has no next pointer
      pNext.assign(0);
    }
    return addressToReference(objectAddress, memoryRegion);
  }

  function encodePropertyKey(k: string): Delayed<vm_Reference> {
    // Property keys are always uniqued
    let ref = uniquedStrings.get(k);
    if (!ref) {
      ref = encodeString(k);
      uniquedStrings.set(k, ref);
    }
    return ref;
  }

  function writeArray(region: BinaryRegion, allocation: VM.ArrayAllocation, memoryRegion: vm_TeValueTag): Delayed<vm_Reference> {
    const typeCode = allocation.lengthIsFixed ? vm_TeTypeCode.VM_TC_ARRAY : vm_TeTypeCode.VM_TC_LIST;
    const contents = allocation.value;
    const len = contents.length;
    assert(isUInt12(len));
    assert(isUInt4(typeCode));
    const headerWord = len | (typeCode << 12);
    region.writeUInt16LE(headerWord);

    // Address comes after the header word
    const arrayAddress = region.currentAddress;

    if (typeCode === vm_TeTypeCode.VM_TC_ARRAY) {
      for (const item of contents) {
        const value = encodeValue(item);
        region.writeUInt16LE(value);
      }
    } else if (typeCode === vm_TeTypeCode.VM_TC_LIST) {
      let pNext = new Delayed();
      region.writeUInt16LE(pNext); // Address of first cell
      for (const item of contents) {
        pNext.assign(region.currentAddress);
        pNext = new Delayed(); // Address of next cell
        region.writeUInt16LE(pNext);
        region.writeUInt16LE(encodeValue(item));
      }
      // The last cell has no next pointer
      pNext.assign(0);
    } else assertUnreachable(typeCode);

    return addressToReference(arrayAddress, memoryRegion);
  }

  function writeImportTable() {
    return notImplemented();
  }

  function writeExportTable() {
    return notImplemented();
  }

  function writeShortCallTable() {
    return notImplemented();
  }

  function writeUniquedStringTable() {
    return notImplemented();
  }

  function writeFunctions() {
    return notImplemented();
  }

}

function isInt14(value: number): boolean {
  return (value | 0) === value
    && value >= -0x2000
    && value <= 0x1FFF;
}

function isUInt12(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xFFF;
}

function isUInt4(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xF;
}

function isInt32(value: number): boolean {
  return (value | 0) === value;
}

function isUInt16(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xFFFF;
}