import * as VM from './virtual-machine-types';
import { SmartBuffer } from 'smart-buffer';
import { crc16ccitt } from 'crc';
import { notImplemented, assertUnreachable, assert } from './utils';
import * as _ from 'lodash';

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
};

/**
 * A snapshot represents the state of the machine captured at a specific moment
 * in time.
 */
export interface Snapshot {
  globalVariables: { [name: string]: VM.Value };
  exports: { [name: string]: VM.Value };
}

export function loadSnapshotFromBytecode(bytecode: Buffer): Snapshot {
  return notImplemented();
}

export function saveSnapshotToBytecode(snapshot: Snapshot): Buffer {
  const buffer = new SmartBuffer();
  const heapData = new SmartBuffer;

  //
  const structureMemoizationTable = new Array<{ data: Buffer, reference: vm_Value }>();

  const bytecodeStart = buffer.writeOffset;

  // Header
  const headerStart = buffer.writeOffset;
  buffer.writeUInt8(bytecodeVersion);
  const headerSize = writeLazyUInt8(buffer);
  const bytecodeSize = writeLazyUInt16LE(buffer);
  const crc = writeLazyUInt16LE(buffer);
  const crcStart = buffer.writeOffset;
  buffer.writeUInt32LE(requiredFeatureFlags);
  buffer.writeUInt16LE(requiredEngineVersion);
  const dataMemorySize = writeLazyUInt16LE(buffer);
  const initialDataOffset = writeLazyUInt16LE(buffer);
  const initialDataSize = writeLazyUInt16LE(buffer);
  const initialHeapOffset = writeLazyUInt16LE(buffer);
  const initialHeapSize = writeLazyUInt16LE(buffer);
  const importTableOffset = writeLazyUInt16LE(buffer);
  const importTableSize = writeLazyUInt16LE(buffer);
  const exportTableOffset = writeLazyUInt16LE(buffer);
  const exportTableSize = writeLazyUInt16LE(buffer);
  const shortCallTableOffset = writeLazyUInt16LE(buffer);
  const shortCallTableSize = writeLazyUInt16LE(buffer);
  headerSize.finalize(buffer.writeOffset - headerStart);

  // Global variables
  const initialDataStart = buffer.writeOffset;
  const initialDataEnd = buffer.writeOffset;
  const globalVariableSlots = Object.keys(snapshot.globalVariables)
    .map(() => writeLazyUInt16LE(buffer));
  initialDataOffset.finalize(initialDataStart - bytecodeStart);
  initialDataSize.finalize(initialDataEnd - initialDataStart);

  // Initial heap
  const initialHeapStart = buffer.writeOffset;
  const initialHeapEnd = buffer.writeOffset;
  initialHeapOffset.finalize(initialHeapStart - bytecodeStart);
  initialHeapSize.finalize(initialHeapEnd - initialHeapStart);

  // Import table
  const importTableStart = buffer.writeOffset;
  const importTableEnd = buffer.writeOffset;
  importTableOffset.finalize(importTableStart - bytecodeStart);
  importTableSize.finalize(importTableEnd - importTableStart);

  // Export table
  const exportTableStart = buffer.writeOffset;
  const exportTableEnd = buffer.writeOffset;
  exportTableOffset.finalize(exportTableStart - bytecodeStart);
  exportTableSize.finalize(exportTableEnd - exportTableStart);

  // Short call table
  const shortCallTableStart = buffer.writeOffset;
  const shortCallTableEnd = buffer.writeOffset;
  shortCallTableOffset.finalize(shortCallTableStart - bytecodeStart);
  shortCallTableSize.finalize(shortCallTableEnd - shortCallTableStart);

  finalizeGlobalVariables();

  // Finalize
  const bytecodeEnd = buffer.writeOffset;
  bytecodeSize.finalize(bytecodeEnd - bytecodeStart);
  const crcEnd = buffer.writeOffset;
  crc.finalize(crc16ccitt(buffer.toBuffer().slice(crcStart, crcEnd)));

  return buffer.toBuffer();

  function finalizeGlobalVariables() {
    const globalVariables = snapshot.globalVariables;
    const globalVariableNames = Object.keys(globalVariables);
    const globalVariableCount = globalVariableNames.length;
    dataMemorySize.finalize(globalVariableCount * 2);

    const globalVariableAddressMapping = new Map<string, number>();
    const globalVariableIsUndefined = (k: string) => globalVariables[k].type === 'UndefinedValue';
    const globalsNeedingInitialization = globalVariableNames.filter(k => !globalVariableIsUndefined(k));
    const globalsNotNeedingInitialization = globalVariableNames.filter(globalVariableIsUndefined);
    let globalVariableIndex = 0;

    for (const k of globalsNeedingInitialization) {
      const i = globalVariableIndex++;
      globalVariableAddressMapping.set(k, i);
      const encoded = encodeValue(globalVariables[k]);
      globalVariableSlots[i].finalize(encoded);
    }

    for (const k of globalsNotNeedingInitialization) {
      const i = globalVariableIndex++;
      globalVariableAddressMapping.set(k, i);
    }
  }

  function encodeValue(value: VM.Value): number {
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
        if (isInt32(value.value)) return heapAllocateImmutable(vm_TeTypeCode.VM_TC_INT32, b => b.writeInt32LE(value.value));
        return heapAllocateImmutable(vm_TeTypeCode.VM_TC_DOUBLE, b => b.writeDoubleLE(value.value));
      };
      case 'StringValue': {
        if (value.value === '') return vm_TeWellKnownValues.VM_VALUE_EMPTY_STRING;
        return heapAllocateImmutable(vm_TeTypeCode.VM_TC_STRING, w => w.writeStringNT(value.value, 'utf8'));
      }
      case 'FunctionValue': {

      }
      default: return assertUnreachable(value);
    }
  }

  function heapAllocateImmutable(typeCode: vm_TeTypeCode, writer: (buffer: SmartBuffer) => void): vm_Value {
    // Encode as heap allocation
    const buffer = new SmartBuffer();
    const headerWord = writeLazyUInt16LE(buffer);
    writer(buffer);
    const size = buffer.writeOffset;
    assert(size <= 0xFFF);
    headerWord.finalize(size | (typeCode << 12));
    const newAllocationData = buffer.toBuffer();
    const existingAllocation = structureMemoizationTable.find(a => a.data.equals(newAllocationData));
    if (existingAllocation) {
      return existingAllocation.reference;
    } else {
      const address = heapData.writeOffset;
      heapData.writeBuffer(newAllocationData);
      assert(address <= 0x3FFF);
      return address | vm_TeValueTags.VM_TAG_GC_P;
    }
  }
}

function writeLazyUInt16LE(buffer: SmartBuffer) {
  return writeLazy(buffer, 'writeUInt16LE', 0);
}

function writeLazyUInt8(buffer: SmartBuffer) {
  return writeLazy(buffer, 'writeUInt8', 0);
}

function writeLazy<T>(buffer: SmartBuffer, method: keyof SmartBuffer, placeholder: T) {
  const offset = buffer.writeOffset;
  // Placeholder
  (buffer[method] as any)(placeholder);
  return {
    finalize(value: T) {
      (buffer[method] as any)(value as any, offset);
    }
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