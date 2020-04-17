import { VirtualMachineFriendly } from "./lib/virtual-machine-friendly";
import { NativeVMFriendly } from "./lib/native-vm-friendly";
import { ExportID, HostFunctionID } from "./lib/virtual-machine";
import { invalidOperation } from "./lib/utils";

export { HostFunctionID, ExportID } from './lib/virtual-machine';

export type Globals = Record<string, any>;
export type ModuleSpecifier = string; // The string passed to `require` or `import`
export type ModuleSourceText = string; // Source code text for a module
export type ModuleObject = Record<string, any>;
export type Resolver = (moduleSpecifier: ModuleSpecifier) => ModuleObject; // TODO
export type Snapshot = { readonly data: Buffer };
export type ResolveImport = (hostFunctionID: HostFunctionID) => Function;
export type ImportTable = Record<HostFunctionID, Function>;

export const MicroVM = {
  create(importMap: ResolveImport | ImportTable = {}): MicroVM {
    return VirtualMachineFriendly.create(importMap);
  },

  restore(snapshot: Snapshot, importMap: ResolveImport | ImportTable = {}): MicroVMNativeSubset {
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
}

export interface MicroVM extends MicroVMNativeSubset {
  importSourceText(sourceText: ModuleSourceText, sourceFilename?: string): ModuleObject;
  createSnapshot(): Snapshot;
  importHostFunction(hostFunctionID: HostFunctionID): Function;
  exportValue(exportID: ExportID, value: any): void;
  garbageCollect(): void;
  readonly global: any;
}

/**
 * The subset of functionality from MicroVM which is supported on microcontrollers
 */
export interface MicroVMNativeSubset {
  resolveExport(exportID: ExportID): any;
}
