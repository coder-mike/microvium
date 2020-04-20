import { vm_TeError, vm_TeType, vm_VMExportID, vm_HostFunctionID } from "./runtime-types";
import * as path from 'path';

// const addon = require('../build/Release/native-vm');
// const addon = require('bindings')('native-vm');
const rootPath = __filename.endsWith('.ts') // Depends if this is pre-built or not
  ? path.join(__dirname, '/..')
  : path.join(__dirname, '/../..')
const addon = require('node-gyp-build')(rootPath); // https://github.com/prebuild/node-gyp-build

export type HostFunction = (object: Value, args: Value[]) => Value;
export type ResolveImport = (hostFunctionID: vm_HostFunctionID) => HostFunction;

export const NativeVM = addon.MicroVM as NativeVMClass;

export interface NativeVMClass {
  new (snapshotBytecode: Buffer, resolveImport: ResolveImport): NativeVM;
}

export interface NativeVM {
  resolveExport(exportID: vm_VMExportID): Value;
  call(func: Value, args: Value[]): Value;
  readonly undefined: Value;
}

export class VMError extends Error {
  errorCode: vm_TeError;

  constructor (errorCode: vm_TeError, message?: string | undefined) {
    super(message);
    this.errorCode = errorCode;
  }
}

export interface Value {
  readonly type: vm_TeType;
  toString(): string;
}
