import { Snapshot, HostImportFunction, ExportID, HostImportMap, HostFunctionID, MicroviumNativeSubset, MemoryStats } from "../lib";
import { notImplemented, hardAssert, invalidOperation, assertUnreachable, reserved } from "./utils";
import * as NativeVM from "./native-vm";
import { mvm_TeType } from "./runtime-types";
import { SnapshotClass } from "./snapshot";

export class NativeVMFriendly implements MicroviumNativeSubset {
  private vm: NativeVM.NativeVM;

  constructor (snapshot: Snapshot, hostImportMap: HostImportMap) {
    let hostImportFunction: HostImportFunction;
    if (typeof hostImportMap !== 'function') {
      hostImportFunction = (hostFunctionID: HostFunctionID): Function => {
        if (!hostImportMap.hasOwnProperty(hostFunctionID)) {
          return invalidOperation('Unresolved import: ' + hostFunctionID);
        }
        return hostImportMap[hostFunctionID];
      };
    } else {
      hostImportFunction = hostImportMap;
    }

    this.vm = new NativeVM.NativeVM(snapshot.data, hostFunctionID => {
      const inner = hostImportFunction(hostFunctionID);
      return this.hostFunctionToVM(inner);
    });
  }

  getMemoryStats(): MemoryStats {
    return this.vm.getMemoryStats();
  }

  resolveExport(exportID: ExportID): any {
    return vmValueToHost(this.vm, this.vm.resolveExport(exportID));
  }

  garbageCollect(squeeze: boolean = false) {
    this.vm.runGC(squeeze);
  }

  createSnapshot(): Snapshot {
    return new SnapshotClass(this.vm.createSnapshot());
  }

  private hostFunctionToVM(hostFunction: Function): NativeVM.HostFunction {
    return (args: NativeVM.Value[]): NativeVM.Value => {
      const result = hostFunction.apply(undefined, args.map(a => vmValueToHost(this.vm, a)));
      return hostValueToVM(this.vm, result);
    }
  }
}

function vmValueToHost(vm: NativeVM.NativeVM, value: NativeVM.Value): any {
  switch (value.type) {
    case mvm_TeType.VM_T_UNDEFINED: return undefined;
    case mvm_TeType.VM_T_NULL: return null;
    case mvm_TeType.VM_T_BOOLEAN: return value.toBoolean();
    case mvm_TeType.VM_T_NUMBER: return value.toNumber();
    case mvm_TeType.VM_T_STRING: return value.toString();
    case mvm_TeType.VM_T_BIG_INT: return reserved();
    case mvm_TeType.VM_T_SYMBOL: return reserved();
    case mvm_TeType.VM_T_FUNCTION: {
      return new Proxy<any>(dummyFunctionTarget, new ValueWrapper(vm, value));
    }
    case mvm_TeType.VM_T_OBJECT: return notImplemented();
    case mvm_TeType.VM_T_ARRAY: return notImplemented();
    default: return assertUnreachable(value.type);
  }
}

function hostValueToVM(vm: NativeVM.NativeVM, value: any): NativeVM.Value {
  switch (typeof value) {
    case 'undefined': return vm.undefined;
    case 'boolean': return vm.newBoolean(value);
    case 'number': return vm.newNumber(value);
    case 'string': return vm.newString(value);
    case 'function': {
      if (ValueWrapper.isWrapped(vm, value)) {
        return ValueWrapper.unwrap(vm, value);
      } else {
        return notImplemented('Ephemeral in native VM')
        // return vm.ephemeralFunction(hostFunctionToVM(vm, value), nameHint || value.name);
      }
    }
    case 'object': {
      if (value === null) {
        return notImplemented();
        // return vm.null;
      }
      if (ValueWrapper.isWrapped(vm, value)) {
        return ValueWrapper.unwrap(vm, value);
      } else {
        return notImplemented('Ephemeral object in native VM');
      }
    }
    default: return notImplemented();
  }
}

// Used as a target for function proxies, so that `typeof` and `call` work as expected
const dummyFunctionTarget = () => {};

const vmValueSymbol = Symbol('vmValue');
const vmSymbol = Symbol('vm');

export class ValueWrapper implements ProxyHandler<any> {
  constructor (
    private vm: NativeVM.NativeVM,
    private vmValue: NativeVM.Value
  ) {
  }

  static isWrapped(vm: NativeVM.NativeVM, value: any): boolean {
    return (typeof value === 'function' || typeof value === 'object') &&
      value !== null &&
      value[vmValueSymbol] &&
      value[vmSymbol] == vm // It needs to be a wrapped value in the context of the particular VM in question
  }

  static unwrap(vm: NativeVM.NativeVM, value: any): NativeVM.Value {
    hardAssert(ValueWrapper.isWrapped(vm, value));
    return value[vmValueSymbol];
  }

  get(_target: any, p: PropertyKey, receiver: any): any {
    return notImplemented();
  }

  set(_target: any, p: PropertyKey, value: any, receiver: any): boolean {
    return notImplemented();
  }

  apply(_target: any, _thisArg: any, argArray: any[] = []): any {
    const args = argArray.map(a => hostValueToVM(this.vm, a));
    const func = this.vmValue;
    if (func.type !== mvm_TeType.VM_T_FUNCTION) return invalidOperation('Target is not callable');
    const result = this.vm.call(func, args);
    return vmValueToHost(this.vm, result);
  }
}