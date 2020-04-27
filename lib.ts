import { VirtualMachineFriendly } from "./lib/virtual-machine-friendly";
import { NativeVMFriendly } from "./lib/native-vm-friendly";
import { ExportID } from "./lib/il";
import { invalidOperation, Todo } from "./lib/utils";
import * as fs from 'fs';
import { Snapshot as SnapshotImplementation } from './lib/snapshot';
import { SnapshotInfo } from "./lib/snapshot-info";
import * as IL from './lib/il';

export { ExportID, HostFunctionID } from './lib/il';
export { SnapshotInfo } from './lib/snapshot-info';
export * as IL from './lib/il';

export type ModuleSpecifier = string; // The string passed to `require` or `import`
export type ModuleSourceText = string; // Source code text for a module
export type ModuleObject = Todo; // TODO(feature): Record<string, any>;
export type ModuleImportFunction = (moduleSpecifier: ModuleSpecifier) => ModuleObject;
export type ModuleImportTable = { [moduleSpecifier: string]: ModuleObject };
export type ModuleImportMap = ModuleImportTable | ModuleImportFunction;
export type Snapshot = { readonly data: Buffer };
export type HostImportFunction = (hostFunctionID: IL.HostFunctionID) => Function;
export type HostImportTable = Record<IL.HostFunctionID, Function>;
export type HostImportMap = HostImportTable | HostImportFunction;

export const microvium = {
  create, restore
}

export function create(
  hostImportMap: HostImportMap = defaultHostEnvironment,
  moduleImportMap: ModuleImportFunction | ModuleImportTable = {},
): Microvium {
  return VirtualMachineFriendly.create(hostImportMap, moduleImportMap);
}

export function restore(snapshot: Snapshot, importMap: HostImportMap = defaultHostEnvironment): MicroviumNativeSubset {
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
  /**
   * Imports the source text as a module.
   *
   * Does not consult the module cache (and no module identifier provided)
   *
   * @param sourceText The microvium module source code to import
   * @param sourceFilenameHint A filename to associate the imported items with,
   * for the purposes of debugging.
   */
  importModuleSourceText(sourceText: ModuleSourceText, sourceFilenameHint?: string): ModuleObject;

  readonly globalThis: any;

  createSnapshot(opts?: SnapshottingOptions): Snapshot;
  importHostFunction(hostFunctionID: IL.HostFunctionID): Function;
  exportValue(exportID: ExportID, value: any): void;
  garbageCollect(): void;
  newObject(): any;
}

/**
 * The subset of functionality from microvium which is supported on microcontrollers
 */
export interface MicroviumNativeSubset {
  resolveExport(exportID: ExportID): any;
}

export const defaultHostEnvironment: HostImportTable = {
  [0xFFFE]: (...args: any[]) => console.log(...args)
}

export interface SnapshottingOptions {
  optimizationHook?: (snapshot: SnapshotInfo) => SnapshotInfo;
}

export interface ModuleStaticRecord {

}