import * as VM from './virtual-machine-types';
import { SmartBuffer } from 'smart-buffer';
import { crc16ccitt } from 'crc';
import { notImplemented } from './utils';

const bytecodeVersion = 1;
const requiredFeatureFlags = 0;
const requiredEngineVersion = 0;

/**
 * A snapshot represents the state of the machine captured at a specific moment
 * in time.
 */
export interface Snapshot {
  globalVariables: { [name: string]: SnapshotVariable };

}

export interface SnapshotVariable {
  region: VariableRegion;
  value: VM.Value;
}

export function loadSnapshotFromBytecode(bytecode: Buffer): Snapshot {
  return notImplemented();
}

export function saveSnapshotToBytecode(snapshot: Snapshot): Buffer {
  const buffer = new SmartBuffer();
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

  // Initial data
  const initialDataStart = buffer.writeOffset;
  const initialDataEnd = buffer.writeOffset;
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

  // Finalize
  const bytecodeEnd = buffer.writeOffset;
  bytecodeSize.finalize(bytecodeEnd - bytecodeStart);
  const crcEnd = buffer.writeOffset;
  crc.finalize(crc16ccitt(buffer.toBuffer().slice(crcStart, crcEnd)));

  return buffer.toBuffer();
}

export type VariableRegion =
  | 'ShortSpace' // Up to 16 variables in data space
  | 'MediumSpace' // Up to 64 variables in data space
  | 'LongSpace' // Full 14-bit address range

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