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

// Tag values
enum vm_TeValueTags {
  VM_TAG_INT    =  0x0000,
  VM_TAG_GC_P   =  0x4000,
  VM_TAG_DATA_P =  0x8000,
  VM_TAG_PGM_P  =  0xC000,
};

enum vm_TeWellKnownValues {
  VM_VALUE_UNDEFINED    = vm_TeValueTags.VM_TAG_PGM_P | 0,
  VM_VALUE_NULL         = vm_TeValueTags.VM_TAG_PGM_P | 1,
  VM_VALUE_TRUE         = vm_TeValueTags.VM_TAG_PGM_P | 2,
  VM_VALUE_FALSE        = vm_TeValueTags.VM_TAG_PGM_P | 3,
  VM_VALUE_EMPTY_STRING = vm_TeValueTags.VM_TAG_PGM_P | 4,
  VM_VALUE_NAN          = vm_TeValueTags.VM_TAG_PGM_P | 5,
  VM_VALUE_INF          = vm_TeValueTags.VM_TAG_PGM_P | 6,
  VM_VALUE_NEG_INF      = vm_TeValueTags.VM_TAG_PGM_P | 7,
  VM_VALUE_NEG_ZERO     = vm_TeValueTags.VM_TAG_PGM_P | 8,
};

enum vm_TeTypeCode {
  // Value types
  VM_TC_WELL_KNOWN    = 0x0,
  VM_TC_INT14         = 0x1,

  // Reference types
  VM_TC_INT32         = 0x2,
  VM_TC_DOUBLE        = 0x3,
  VM_TC_STRING        = 0x4, // UTF8-encoded string
  VM_TC_PROPERTY_LIST = 0x5, // Object represented as linked list of properties
  VM_TC_STRUCT        = 0x6, // Object represented as flat structure
  VM_TC_LIST          = 0x7, // Array represented as linked list
  VM_TC_ARRAY         = 0x8, // Array represented as contiguous array in memory
  VM_TC_FUNCTION      = 0x9, // Local function
  VM_TC_EXT_FUNC_ID   = 0xA, // External function by 16-bit ID
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
  const importTable = new BinaryRegion();

  const largePrimitivesMemoizationTable = new Array<{ data: Buffer, reference: Delayed<vm_Value> }>();
  const importLookup = new Map<VM.ExternalFunctionID, number>();
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
  writeHeap();
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

  // Dynamically-sized primitives
  bytecode.writeBuffer(largePrimitives);

  // Functions
  writeFunctions();

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

  function encodeValue(value: VM.Value): DelayedLike<number> {
    switch (value.type) {
      case 'UndefinedValue': return vm_TeWellKnownValues.VM_VALUE_UNDEFINED;
      case 'BooleanValue': return value.value ? vm_TeWellKnownValues.VM_VALUE_TRUE : vm_TeWellKnownValues.VM_VALUE_FALSE;
      case 'NullValue': return vm_TeWellKnownValues.VM_VALUE_NULL;
      case 'NumberValue': {
        if (isNaN(value.value)) return vm_TeWellKnownValues.VM_VALUE_NAN;
        if (value.value === Infinity) return vm_TeWellKnownValues.VM_VALUE_INF;
        if (value.value === -Infinity) return vm_TeWellKnownValues.VM_VALUE_NEG_INF;
        if (Object.is(value.value, -0)) return vm_TeWellKnownValues.VM_VALUE_NEG_ZERO;
        if (isInt14(value.value)) return value.value;
        if (isInt32(value.value)) return allocateLargePrimitive(vm_TeTypeCode.VM_TC_INT32, b => b.writeInt32LE(value.value));
        return allocateLargePrimitive(vm_TeTypeCode.VM_TC_DOUBLE, b => b.writeDoubleLE(value.value));
      };
      case 'StringValue': {
        if (value.value === '') return vm_TeWellKnownValues.VM_VALUE_EMPTY_STRING;
        return allocateLargePrimitive(vm_TeTypeCode.VM_TC_STRING, w => w.writeStringNT(value.value, 'utf8'));
      }
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
      const reference = address.map(address => {
        assert(address <= 0x3FFF);
        return address| vm_TeValueTags.VM_TAG_GC_P
      });
      largePrimitivesMemoizationTable.push({ data: newAllocationData, reference });
      return reference;
    }
  }

  function writeHeap() {
    return notImplemented();
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

  function writeFunctions() {
    return notImplemented();
  }

}

function isInt14(value: number): boolean {
  return (value | 0) === value
    && value >= -0x2000
    && value <= 0x1FFF;
}

function isInt32(value: number): boolean {
  return (value | 0) === value;
}

function isUInt16(value: number): boolean {
  return (value | 0) === value
    && value >= 0
    && value <= 0xFFFF;
}