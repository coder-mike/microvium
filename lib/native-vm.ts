import { mvm_TeError, mvm_TeType, vm_VMExportID, vm_HostFunctionID } from "./runtime-types";
import * as path from 'path';
import { MemoryStats } from "../lib";

// const addon = require('../build/Release/native-vm');
// const addon = require('bindings')('native-vm');
const rootPath = __filename.endsWith('.ts') // Depends if this is pre-built or not
  ? path.join(__dirname, '/..')
  : path.join(__dirname, '/../..')
const addon = require('node-gyp-build')(rootPath); // https://github.com/prebuild/node-gyp-build

export enum CoverageCaseMode {
  NORMAL = 1,
  UNTESTED = 2,
  UNIMPLEMENTED = 3,
  TABLE = 4,
};

export type HostFunction = (args: Value[]) => Value;
export type ResolveImport = (hostFunctionID: vm_HostFunctionID) => HostFunction;
export type CoverageCallback = (id: number, mode: CoverageCaseMode, indexInTable: number, tableSize: number, line: number) => void;

export const NativeVM = addon.NativeVM as NativeVMClass;

export interface NativeVMClass {
  new (snapshotBytecode: Buffer, resolveImport: ResolveImport): NativeVM;
  // Used for code coverage analysis
  setCoverageCallback(callback: CoverageCallback | undefined): void;
  readonly MVM_PORT_INT32_OVERFLOW_CHECKS: boolean;
  readonly MVM_TEXT_SUPPORT: number;
}

export interface NativeVM {
  resolveExport(exportID: vm_VMExportID): Value;
  call(func: Value, args: Value[]): Value;
  uint8ArrayFromBytes(data: Buffer): Value;
  typeOf(value: Value): mvm_TeType;
  newBoolean(value: boolean): Value;
  newNumber(value: number): Value;
  newString(value: string): Value;
  runGC(squeeze: boolean): void;
  createSnapshot(): Buffer;
  getMemoryStats(): MemoryStats;
  asyncStart(): Value;
  stopAfterNInstructions(n: number): void;
  getInstructionCountRemaining(): number;
  readonly undefined: Value;
}

export class VMError extends Error {
  errorCode: mvm_TeError;

  constructor (errorCode: mvm_TeError, message?: string | undefined) {
    super(message);
    this.errorCode = errorCode;
  }
}

export interface Value {
  readonly raw: number;
  readonly type: mvm_TeType;
  toString(): string;
  toNumber(): number;
  toBoolean(): boolean;
  uint8ArrayToBytes(): Buffer;
}
