import * as VM from './virtual-machine';
import { mapObject, notImplemented, assertUnreachable, assert, invalidOperation, notUndefined, todo } from './utils';
import { SnapshotInfo, encodeSnapshot } from './snapshot-info';
import { Microvium, ModuleObject, ModuleSpecifier, Resolver, ResolveImport, ImportTable, HostFunctionID } from '../lib';
import { Snapshot } from './snapshot';
import { WeakRef, FinalizationRegistry } from './weak-ref';

export interface Globals {
  [name: string]: any;
}

export class VirtualMachineFriendly implements Microvium {
  private vm: VM.VirtualMachine;
  private _global: any;

  private constructor (
    resumeFromSnapshot: SnapshotInfo | undefined,
    importMap: ResolveImport | ImportTable = {},
    opts: VM.VirtualMachineOptions = {}
  ) {
    let innerResolve: VM.ResolveImport;
    if (typeof importMap !== 'function') {
      if (typeof importMap !== 'object' || importMap === null)  {
        return invalidOperation('`importMap` must be a resolution function or an import table');
      }
      const importTable = importMap;

      innerResolve = (hostFunctionID): VM.HostFunctionHandler => {
        if (!importTable.hasOwnProperty(hostFunctionID)) {
          return invalidOperation('Unresolved import: ' + hostFunctionID);
        }
        return hostFunctionToVM(this.vm, importTable[hostFunctionID]);
      }
    } else {
      const resolve = importMap;
      innerResolve = (hostFunctionID): VM.HostFunctionHandler => {
        return hostFunctionToVM(this.vm, resolve(hostFunctionID));
      }
    }
    this.vm = new VM.VirtualMachine(resumeFromSnapshot, innerResolve, opts);
    this._global = new Proxy<any>({}, new GlobalWrapper(this.vm));
  }

  public static create(importMap: ResolveImport | ImportTable = {}, opts: VM.VirtualMachineOptions = {}): VirtualMachineFriendly {
    return new VirtualMachineFriendly(undefined, importMap, opts);
  }

  public importHostFunction(hostFunctionID: HostFunctionID): Function {
    const result = this.vm.importHostFunction(hostFunctionID);
    return vmValueToHost(this.vm, result);
  }

  public importSourceText(sourceText: string, sourceFilename: string): ModuleObject {
    // TODO(feature): wrap result and return it
    // TODO(feature): modules shouldn't create their own module object, since this doesn't work for cyclic dependencies
    const result = this.vm.importModuleSourceText(sourceText, sourceFilename);
    return undefined;
  }

  public createSnapshotInfo(): SnapshotInfo {
    return this.vm.createSnapshotInfo();
  }

  public createSnapshot(): Snapshot {
    const snapshotInfo = this.createSnapshotInfo();
    const { snapshot } = encodeSnapshot(snapshotInfo, false);
    return snapshot;
  }

  public exportValue = (exportID: VM.ExportID, value: any) => {
    const vmValue = hostValueToVM(this.vm, value);
    this.vm.exportValue(exportID, vmValue);
  }

  public resolveExport(exportID: VM.ExportID): any {
    return vmValueToHost(this.vm, this.vm.resolveExport(exportID));
  }

  public garbageCollect() {
    this.vm.garbageCollect();
  }

  public get global(): any { return this._global; }
}

function hostFunctionToVM(vm: VM.VirtualMachine, func: Function): VM.HostFunctionHandler {
  return (object, args) => {
    const result = func.apply(vmValueToHost(vm, object), args.map(a => vmValueToHost(vm, a)));
    return hostValueToVM(vm, result);
  }
}

function vmValueToHost(vm: VM.VirtualMachine, value: VM.Value): any {
  switch (value.type) {
    case 'BooleanValue':
    case 'NumberValue':
    case 'UndefinedValue':
    case 'StringValue':
    case 'NullValue':
      return value.value;
    case 'FunctionValue':
    case 'HostFunctionValue':
      return ValueWrapper.wrap(vm, value);
    case 'EphemeralFunctionValue': {
      const unwrapped = vm.unwrapEphemeral(value);
      if (unwrapped === undefined) {
        // (Could come from another VM)
        // TODO(high): We have no way of checking that it comes from another VM other than the IDs not matching, which is fragile
        return ValueWrapper.wrap(vm, value);
      } else {
        return unwrapped;
      }
    }
    case 'ReferenceValue': return notImplemented();
    default: return assertUnreachable(value);
  }
}

function hostValueToVM(vm: VM.VirtualMachine, value: any, nameHint?: string): VM.Value {
  switch (typeof value) {
    case 'undefined': return vm.undefinedValue;
    case 'boolean': return vm.booleanValue(value);
    case 'number': return vm.numberValue(value);
    case 'string': return vm.stringValue(value);
    case 'function': {
      if (ValueWrapper.isWrapped(vm, value)) {
        return ValueWrapper.unwrap(vm, value);
      } else {
        return vm.ephemeralFunction(hostFunctionToVM(vm, value), nameHint || value.name);
      }
    }
    case 'object': {
      if (value === null) {
        return vm.nullValue;
      }
      if (ValueWrapper.isWrapped(vm, value)) {
        return ValueWrapper.unwrap(vm, value);
      } else {
        return notImplemented();
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
  private static finalizationGroup = new FinalizationRegistry<VM.Handle>(releaseHandle);

  constructor (
    private vm: VM.VirtualMachine,
    private vmValue: VM.Value
  ) {
    /* This wrapper uses weakrefs, currently only implemented by a shim
     * https://www.npmjs.com/package/tc39-weakrefs-shim. The wrapper has a
     * strong host-reference (node.js reference) to the VM.Value, but is a weak
     * VM-reference (microvium reference) (i.e. the VM implementation doesn't
     * know that the host has a reference). In order to protect the VM from
     * collecting the VM.Value, we create a VM.Handle that keeps the value
     * reachable within the VM.
     *
     * We don't need a reference to the handle, since it's only used to "peg"
     * the value, but the handle is strongly referenced by the finalization
     * group, while this wrapper object is only weakly referenced by the
     * finalization group, allowing it to be collected when it's unreachable by
     * the rest of the application. When the wrapper is collected, the
     * finalization group will release the corresponding handle.
     */
    const handle = vm.createHandle(vmValue);
    ValueWrapper.finalizationGroup.register(this, handle);
  }

  static isWrapped(vm: VM.VirtualMachine, value: any): boolean {
    return (typeof value === 'function' || typeof value === 'object') &&
      value !== null &&
      value[vmValueSymbol] &&
      value[vmSymbol] == vm // It needs to be a wrapped value in the context of the particular VM in question
  }

  static wrap(vm: VM.VirtualMachine, value: any): any {
    return new Proxy<any>(dummyFunctionTarget, new ValueWrapper(vm, value));
  }

  static unwrap(vm: VM.VirtualMachine, value: any): VM.Value {
    assert(ValueWrapper.isWrapped(vm, value));
    return value[vmValueSymbol];
  }

  get(_target: any, p: PropertyKey, receiver: any): any {
    if (p === vmValueSymbol) return this.vmValue;
    if (p === vmSymbol) return this.vm;
    if (typeof p !== 'string') return invalidOperation('Only string properties supported');
    if (this.vmValue.type !== 'ReferenceValue') return invalidOperation('Accessing property or index on non-object/non-array')
    const allocation = this.vm.dereference(this.vmValue);
    if (allocation.type === 'ArrayAllocation' && p !== 'length') {
      const index = parseInt(p);
      if (isNaN(index)) return invalidOperation('Invalid array accessor');
      const value = this.vm.arrayGet(allocation, index);
      return vmValueToHost(this.vm, value);
    } else {
      const value = this.vm.objectGet(allocation, p);
      return vmValueToHost(this.vm, value);
    }
  }

  set(_target: any, p: PropertyKey, value: any, receiver: any): boolean {
    return notImplemented();
  }

  apply(_target: any, thisArg: any, argArray: any[] = []): any {
    const args = argArray.map(a => hostValueToVM(this.vm, a));
    const func = this.vmValue;
    if (func.type !== 'FunctionValue') return invalidOperation('Target is not callable');
    const result = this.vm.runFunction(func, ...args);
    return vmValueToHost(this.vm, result);
  }
}

class GlobalWrapper implements ProxyHandler<any> {
  constructor (
    private vm: VM.VirtualMachine
  ) {
  }

  get(_target: any, p: PropertyKey, receiver: any): any {
    if (typeof p !== 'string') return invalidOperation('Only string-valued global variables are supported');
    this.vm.globalGet(p)
  }

  set(_target: any, p: PropertyKey, value: any, receiver: any): boolean {
    if (typeof p !== 'string') return invalidOperation('Only string-valued global variables are supported');
    this.vm.globalSet(p, hostValueToVM(this.vm, value, p));
    return true;
  }

  apply(_target: any, thisArg: any, argArray: any[] = []): any {
    return invalidOperation('Target not callable')
  }
}

function releaseHandle(handle: VM.Handle) {
  handle.release();
}