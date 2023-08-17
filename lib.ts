import { VirtualMachineFriendly } from "./lib/virtual-machine-friendly";
import { NativeVMFriendly } from "./lib/native-vm-friendly";
import { ExportID } from "./lib/il";
import { jsonParse } from "./lib/utils";
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
  noLib?: boolean;
  // For debug purposes: output IL generated for each input file
  outputIL?: boolean;
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
  vmExport(exportID: ExportID, value: any): void;
  vmImport(importID: ExportID, defaultImplementation?: any): void;
  newObject(): any;
  newArray(): any;
  createSnapshotIL(): SnapshotIL;
}

/**
 * The subset of functionality from Microvium which is supported on microcontrollers
 */
export interface MicroviumNativeSubset {
  resolveExport(exportID: ExportID): any;
  garbageCollect(squeeze?: boolean): void;
  createSnapshot(): Snapshot;
  getMemoryStats(): MemoryStats;
}

export interface MemoryStats {
  /** Total RAM currently allocated by the VM from the host */
  totalSize: number;

  /** Number of distinct, currently-allocated memory allocations (mallocs) from the host */
  fragmentCount: number;

  /** RAM size of VM core state */
  coreSize: number;

  /** RAM allocated to the VM import table (table of functions resolved from the host) */
  importTableSize: number;

  /** RAM allocated to global variables in RAM */
  globalVariablesSize: number;

  /** If the machine registers are allocated (if a call is active), this says
  how much RAM these consume. Otherwise zero if there is no active stack. */
  registersSize: number;

  /** Virtual stack size (bytes) currently allocated (if a call is active), or
  zero if there is no active stack. Note that virtual stack space is malloc'd,
  not allocated on the C stack. */
  stackHeight: number;

  /** Virtual stack space capacity if a call is active, otherwise zero. */
  stackAllocatedCapacity: number;

  /** Maximum stack size over the lifetime of the VM. This value can be used to
  tune the MVM_STACK_SIZE port definition */
  stackHighWaterMark: number;

  /** Amount of virtual heap that the VM is currently using */
  virtualHeapUsed: number;

  /** Maximum amount of virtual heap space ever used by this VM */
  virtualHeapHighWaterMark: number;

  /** Current total size of virtual heap (will expand as needed up to a max of MVM_MAX_HEAP_SIZE) */
  virtualHeapAllocatedCapacity: number;
}

export const defaultHostEnvironment: HostImportTable = {
  // TODO: Probably the default environment shouldn't reserve any IDs
  // [0xFFFE]: (...args: any[]) => console.log(...args)
}

export function addDefaultGlobals(vm: Microvium) {
  const vmGlobal = vm.globalThis;
  const vmConsole = vmGlobal.console = vm.newObject();
  vmConsole.log = (...args: any[]) => console.log(...args);
  vmGlobal.vmImport = vm.vmImport;
  vmGlobal.vmExport = vm.vmExport;
  vmGlobal.JSON = vm.newObject();
  vmGlobal.JSON.parse = jsonParse(vm);
}

export interface SnapshottingOptions {
  optimizationHook?: (snapshot: SnapshotIL) => SnapshotIL;
  // If outputSnapshotIL is true and snapshotILFilename contains a filename then
  // the snapshotting will also output an IL file
  outputSnapshotIL?: boolean;
  snapshotILFilename?: string;
  generateSourceMap?: boolean;
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
