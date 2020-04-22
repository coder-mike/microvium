import { VirtualMachineFriendly } from "./lib/virtual-machine-friendly";
import { NativeVMFriendly } from "./lib/native-vm-friendly";
import { ExportID, HostFunctionID } from "./lib/virtual-machine";
import { invalidOperation, Todo } from "./lib/utils";
import * as fs from 'fs';
import { Snapshot as SnapshotImplementation } from './lib/snapshot';
import { SnapshotInfo } from "./lib/snapshot-info";

export { HostFunctionID, ExportID } from './lib/virtual-machine';
export { SnapshotInfo } from './lib/snapshot-info';

export type Globals = Record<string, any>;
export type ModuleSpecifier = string; // The string passed to `require` or `import`
export type ModuleSourceText = string; // Source code text for a module
export type ModuleObject = Todo; // TODO(feature): Record<string, any>;
export type Resolver = (moduleSpecifier: ModuleSpecifier) => ModuleObject; // TODO(feature)
export type Snapshot = { readonly data: Buffer };
export type ResolveImport = (hostFunctionID: HostFunctionID) => Function;
export type ImportTable = Record<HostFunctionID, Function>;

// There's not a lot of reason not to just have have this as the default export
export const microvium = {
  create, restore
}

export function create(importMap: ResolveImport | ImportTable = defaultEnvironment): Microvium {
  return VirtualMachineFriendly.create(importMap);
}

export function restore(snapshot: Snapshot, importMap: ResolveImport | ImportTable = defaultEnvironment): MicroviumNativeSubset {
  if (typeof importMap !== 'function') {
    if (typeof importMap !== 'object' || importMap === null)  {
      return invalidOperation('`importMap` must be a resolution function or an import table');
    }
    const importTable = importMap;
    importMap = (hostFunctionID: HostFunctionID): Function => {
      if (!importTable.hasOwnProperty(hostFunctionID)) {
        return invalidOperation('Unresolved import: ' + hostFunctionID);
      }
      return importTable[hostFunctionID];
    };
  }
  return new NativeVMFriendly(snapshot, importMap);
}

export default microvium;

export const Snapshot = {
  fromFileSync(filename: string): Snapshot {
    const data = fs.readFileSync(filename, null);
    return new SnapshotImplementation(data);
  }
}

export interface Microvium extends MicroviumNativeSubset {
  importSourceText(sourceText: ModuleSourceText, sourceFilename?: string): ModuleObject;
  createSnapshot(opts?: SnapshottingOptions): Snapshot;
  importHostFunction(hostFunctionID: HostFunctionID): Function;
  exportValue(exportID: ExportID, value: any): void;
  garbageCollect(): void;

  newObject(): any;
  readonly global: any;
}

/**
 * The subset of functionality from microvium which is supported on microcontrollers
 */
export interface MicroviumNativeSubset {
  resolveExport(exportID: ExportID): any;
}

export const defaultEnvironment: ImportTable = {
  [0xFFFE]: (...args: any[]) => console.log(...args)
}

export interface SnapshottingOptions {
  optimizationHook?: (snapshot: SnapshotInfo) => SnapshotInfo;
}