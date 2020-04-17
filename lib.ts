import { VirtualMachineFriendly, PersistentHostFunction } from "./lib/virtual-machine-friendly";
import { NativeVMFriendly } from "./lib/native-vm-friendly";
import { ExportID, HostFunctionID } from "./lib/virtual-machine";
import { invalidOperation } from "./lib/utils";

export { PersistentHostFunction, persistentHostFunction } from './lib/virtual-machine-friendly';
export { HostFunctionID, ExportID } from './lib/virtual-machine';

export type Globals = Record<string, any>;
export type ModuleSpecifier = string; // The string passed to `require` or `import`
export type ModuleSourceText = string; // Source code text for a module
export type ModuleObject = Record<string, any>;
export type Resolver = (moduleSpecifier: ModuleSpecifier) => ModuleObject;
export type Snapshot = { readonly data: Buffer };
export type ResolveImport = (hostFunctionID: HostFunctionID) => Function;
export type ImportTable = Record<HostFunctionID, Function>;

export const MicroVM = {
  create(globals: Globals = {}, resolver?: Resolver): MicroVM {
    return new VirtualMachineFriendly(globals);
  },

  restore(snapshot: Snapshot, resolveImport: ResolveImport | ImportTable): MicroVMNativeSubset {
    if (typeof resolveImport !== 'function') {
      if (typeof resolveImport !== 'object' || resolveImport === null)  {
        return invalidOperation('`resolveImport` must be a resolution function or an import table');
      }
      const importTable = resolveImport;
      resolveImport = (hostFunctionID: HostFunctionID): Function => {
        if (!importTable.hasOwnProperty(hostFunctionID)) {
          return invalidOperation('Unresolved import: ' + hostFunctionID);
        }
        return importTable[hostFunctionID];
      };
    }
    return new NativeVMFriendly(snapshot, resolveImport);
  }
}

export interface MicroVM extends MicroVMNativeSubset {
  importSourceText(sourceText: ModuleSourceText, sourceFilename?: string): ModuleObject;
  createSnapshot(): Snapshot;
  exportValue(exportID: ExportID, value: any): void;
  garbageCollect(): void;
}

/**
 * The subset of functionality from MicroVM which is supported on microcontrollers
 */
export interface MicroVMNativeSubset {
  resolveExport(exportID: ExportID): any;
}
