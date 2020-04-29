import { VirtualMachineFriendly } from "./lib/virtual-machine-friendly";
import { NativeVMFriendly } from "./lib/native-vm-friendly";
import { ExportID } from "./lib/il";
import { invalidOperation, Todo } from "./lib/utils";
import * as fs from 'fs';
import { Snapshot as SnapshotImplementation } from './lib/snapshot';
import { SnapshotInfo } from "./lib/snapshot-info";
import * as IL from './lib/il';
import { makeFetcher, fetchEntryModule } from "./lib/fetcher";

export { ExportID, HostFunctionID } from './lib/il';
export { SnapshotInfo } from './lib/snapshot-info';
export { ModuleOptions } from './lib/fetcher';
export * as IL from './lib/il';

export type ModuleSpecifier = string; // The string passed to `require` or `import`
export type ModuleSourceText = string; // Source code for a module
export type ModuleObject = Record<string, any>;
export type Snapshot = { readonly data: Buffer };
export type HostImportFunction = (hostFunctionID: IL.HostFunctionID) => Function;
export type HostImportTable = Record<IL.HostFunctionID, Function>;
export type HostImportMap = HostImportTable | HostImportFunction;

export type FetchDependency = (specifier: ModuleSpecifier) =>
  | { moduleSource: ModuleSource }
  | { moduleObject: ModuleObject }

export function create(
  hostImportMap: HostImportMap = defaultHostEnvironment
): Microvium {
  return VirtualMachineFriendly.create(hostImportMap);
}

export function restore(snapshot: Snapshot, importMap: HostImportMap = defaultHostEnvironment): MicroviumNativeSubset {
  return new NativeVMFriendly(snapshot, importMap);
}

export const Snapshot = {
  fromFileSync(filename: string): Snapshot {
    const data = fs.readFileSync(filename, null);
    return new SnapshotImplementation(data);
  }
}

export interface Microvium extends MicroviumNativeSubset {
  /**
   * Imports the given source text as a module.
   *
   * Returns the module namespace object for the imported module: an objects
   * whose properties are the exports of the module.
   *
   * A call to `module` with the exact same `ModuleSource` will return the exact
   * same `ModuleObject` (by reference equality). Microvium maintains an
   * internal "cache" of module objects by their corresponding source object. If
   * the module has not yet finished being imported (e.g. in the case of a
   * circular dependency), this function will return the incomplete module
   * object.
   */
  module(moduleSource: ModuleSource): ModuleObject;

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

export interface ModuleSource {
  /** Microvium source text for the module */
  readonly sourceText: ModuleSourceText;

  /** If specified, the debugFilename will appear in stack traces and facilitate
  * breakpoints in the source text. */
  readonly debugFilename?: string;

  /** If specified, this allows the module to have its own nested imports */
  readonly fetchDependency?: FetchDependency;
}

export { fetchEntryModule };

export const Microvium = {
  create,
  restore,
  fetchEntryModule,
  defaultHostEnvironment,
  Snapshot
};

export default Microvium;

// TODO This might have to be removed. Only here for now for microvium-debug to use
export { VirtualMachineFriendly } from './lib/virtual-machine-friendly';