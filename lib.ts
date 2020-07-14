import { VirtualMachineFriendly } from "./lib/virtual-machine-friendly";
import { NativeVMFriendly } from "./lib/native-vm-friendly";
import { ExportID } from "./lib/il";
import { invalidOperation, Todo } from "./lib/utils";
import * as fs from 'fs';
import { SnapshotClass as SnapshotImplementation } from './lib/snapshot';
import { SnapshotIL } from "./lib/snapshot-il";
import * as IL from './lib/il';
import { nodeStyleImporter } from "./lib/node-style-importer";
import path from 'path';
import { microviumDir } from "./lib/microvium-dir";
import { decodeSnapshot } from './lib/decode-snapshot';


export { ExportID, HostFunctionID } from './lib/il';
export { SnapshotIL } from './lib/snapshot-il';
export { ModuleOptions } from './lib/node-style-importer';
export * as IL from './lib/il';
export { decodeSnapshot };

export type ModuleSpecifier = string; // The string passed to `require` or `import`
export type ModuleSourceText = string; // Source code for a module
export type ModuleObject = Record<string, any>;
export type Snapshot = { readonly data: Buffer };
export type HostImportFunction = (hostFunctionID: IL.HostFunctionID) => Function;
export type HostImportTable = Record<IL.HostFunctionID, Function>;
export type HostImportMap = HostImportTable | HostImportFunction;

export type ImportHook = (specifier: ModuleSpecifier) => ModuleObject | undefined;

export interface MicroviumCreateOpts {
  debugConfiguration?: { port: number };
}

export function create(
  hostImportMap: HostImportMap = defaultHostEnvironment,
  opts: MicroviumCreateOpts = {}
): Microvium {
  return VirtualMachineFriendly.create(hostImportMap, opts);
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
   * Evaluates the given source text as a module.
   *
   * Returns the module namespace object for the imported module: an object
   * whose properties are the exports of the imported module.
   *
   * A call to `evaluateModule` with the exact same `ModuleSource` will return the
   * exact same `ModuleObject` (by reference equality). Microvium maintains an
   * internal "cache" of module objects by their corresponding source object. If
   * the module has not yet finished being imported (e.g. in the case of a
   * circular dependency), this function will return the incomplete module
   * object.
   */
  evaluateModule(moduleSource: ModuleSource): ModuleObject;

  readonly globalThis: any;

  createSnapshot(opts?: SnapshottingOptions): Snapshot;
  importHostFunction(hostFunctionID: IL.HostFunctionID): Function;
  exportValue(exportID: ExportID, value: any): void;
  newObject(): any;
  createSnapshotIL(): SnapshotIL;
}

/**
 * The subset of functionality from Microvium which is supported on microcontrollers
 */
export interface MicroviumNativeSubset {
  resolveExport(exportID: ExportID): any;
  garbageCollect(squeeze?: boolean): void;
  createSnapshot(): Snapshot;
}

export const defaultHostEnvironment: HostImportTable = {
  [0xFFFE]: (...args: any[]) => console.log(...args)
}

export interface SnapshottingOptions {
  optimizationHook?: (snapshot: SnapshotIL) => SnapshotIL;
}

export interface ModuleSource {
  /** Microvium source text for the module */
  readonly sourceText: ModuleSourceText;

  /** If specified, the debugFilename will appear in stack traces and facilitate
  * breakpoints in the source text. */
  readonly debugFilename?: string;

  /** If specified, this allows the module to have its own nested imports */
  readonly importDependency?: ImportHook;
}

// Include path for C
export const include = path.resolve(microviumDir, './dist-c');

// Src path for C
export const src = path.resolve(include, 'microvium.c');

export { nodeStyleImporter };

export const Microvium = {
  create,
  restore,
  nodeStyleImporter,
  defaultHostEnvironment,
  Snapshot,
  include,
  src,
  decodeSnapshot
};

export default Microvium;

// TODO This might have to be removed. Only here for now for microvium-debug to use
export { VirtualMachineFriendly } from './lib/virtual-machine-friendly';