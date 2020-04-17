import { VirtualMachineFriendly } from "./lib/virtual-machine-friendly";
import { NativeVMFriendly } from "./lib/native-vm-friendly";
import { ExportID } from "./lib/virtual-machine";
import { notImplemented } from "./lib/utils";

export type Endowments = Record<string, any>;
export type ModuleSpecifier = string; // The string passed to `require` or `import`
export type ModuleSourceText = string; // Source code text for a module
export type ModuleObject = Record<string, any>;
export type Resolver = (moduleSpecifier: ModuleSpecifier) => ModuleObject;
export type Snapshot = { readonly data: Buffer };

export const MicroVM = {
  create(endowments: Endowments = {}, resolver?: Resolver): MicroVM {
    return notImplemented();
    // return new VirtualMachineFriendly(endowments);
  },

  resume(snapshot: Snapshot): MicroVMNativeSubset {
    return new NativeVMFriendly(snapshot);
  }
}

export interface MicroVM extends MicroVMNativeSubset {
  import(sourceText: ModuleSourceText): ModuleObject;
  createSnapshot(): Snapshot;
  exportValue(exportID: ExportID, value: any): void;
  garbageCollect(): void;
}

/**
 * The subset of functionality from MicroVM which is supported on microcontrollers
 */
export interface MicroVMNativeSubset {
}

