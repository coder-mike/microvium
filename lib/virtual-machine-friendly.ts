import * as VM from './virtual-machine';
import * as IL from './il';
import { mapObject, notImplemented, assertUnreachable, hardAssert, invalidOperation, notUndefined, todo, unexpected, stringifyIdentifier, writeTextFile } from './utils';
import { SnapshotIL } from './snapshot-il';
import { Microvium, ModuleObject, HostImportFunction, HostImportTable, SnapshottingOptions, defaultHostEnvironment, ModuleSource, ImportHook, MemoryStats } from '../lib';
import { SnapshotClass } from './snapshot';
import { EventEmitter } from 'events';
import { SynchronousWebSocketServer } from './synchronous-ws-server';
import * as fs from 'fs';
import colors from 'colors';
import { addBuiltinGlobals } from './builtin-globals';
import { encodeSnapshot } from './encode-snapshot';

export interface Globals {
  [name: string]: any;
}

/**
 * A wrapper for VirtualMachine that automatically marshalls data between the
 * host and the VM (something like a membrane to interface to the VM)
 */
export class VirtualMachineFriendly implements Microvium {
  private vm: VM.VirtualMachine;
  private _global: any;
  private moduleCache = new WeakMap<ModuleSource, VM.ModuleSource>();

  // TODO This constructor is changed to public for Microvium-debug to use
  // (temporarily)
  public constructor(
    resumeFromSnapshot: SnapshotIL | undefined,
    hostImportMap: HostImportFunction | HostImportTable = {},
    opts: VM.VirtualMachineOptions = {}
  ) {
    let innerResolve: VM.ResolveFFIImport;
    if (typeof hostImportMap !== 'function') {
      if (typeof hostImportMap !== 'object' || hostImportMap === null)  {
        return invalidOperation('`importMap` must be a resolution function or an import table');
      }
      const importTable = hostImportMap;

      innerResolve = (hostFunctionID): VM.HostFunctionHandler => {
        if (!importTable.hasOwnProperty(hostFunctionID)) {
          return invalidOperation('Unresolved import: ' + hostFunctionID);
        }
        return hostFunctionToVMHandler(this.vm, importTable[hostFunctionID]);
      }
    } else {
      const resolve = hostImportMap;
      innerResolve = (hostFunctionID): VM.HostFunctionHandler => {
        return hostFunctionToVMHandler(this.vm, resolve(hostFunctionID));
      }
    }
    let debugServer: SynchronousWebSocketServer | undefined;
    if (opts.debugConfiguration) {
      debugServer = new SynchronousWebSocketServer(opts.debugConfiguration.port, {
        verboseLogging: false
      });
      console.log(colors.yellow(`Microvium-debug is waiting for a client to connect on ws://127.0.0.1:${opts.debugConfiguration.port}`))
      debugServer.waitForConnection();
      console.log('Microvium-debug client connected');
    }
    this.vm = new VM.VirtualMachine(resumeFromSnapshot, innerResolve, opts, debugServer);
    this._global = new Proxy<any>({}, new GlobalWrapper(this.vm));
    addBuiltinGlobals(this);
  }

  getMemoryStats(): MemoryStats {
    throw new Error('getMemoryStats is only available at runtime');
  }

  public static create(
    hostImportMap: HostImportFunction | HostImportTable = defaultHostEnvironment,
    opts: VM.VirtualMachineOptions = {}
  ): VirtualMachineFriendly {
    return new VirtualMachineFriendly(undefined, hostImportMap, opts);
  }

  public importHostFunction(hostFunctionID: IL.HostFunctionID): Function {
    const result = this.vm.importHostFunction(hostFunctionID);
    return vmValueToHost(this.vm, result, `<host function ${hostFunctionID}>`);
  }

  public evaluateModule(moduleSource: ModuleSource): ModuleObject {
    const self = this;

    if (this.moduleCache.has(moduleSource)) {
      const innerModuleObject = this.vm.evaluateModule(this.moduleCache.get(moduleSource)!);
      const outerModuleObject = vmValueToHost(self.vm, innerModuleObject, undefined);
      return outerModuleObject;
    }
    const innerModuleSource: VM.ModuleSource = {
      sourceText: moduleSource.sourceText,
      debugFilename: moduleSource.debugFilename,
      importDependency: moduleSource.importDependency && wrapImportHook(moduleSource.importDependency)
    };
    this.moduleCache.set(moduleSource, innerModuleSource);
    const innerModuleObject = this.vm.evaluateModule(innerModuleSource);

    const outerModuleObject = vmValueToHost(self.vm, innerModuleObject, undefined);

    return outerModuleObject;

    function wrapImportHook(fetch: ImportHook): VM.ImportHook {
      return (specifier: VM.ModuleSpecifier): VM.ModuleObject | undefined => {
        const innerFetchResult = fetch(specifier);
        if (!innerFetchResult) {
          return undefined;
        }
        return hostValueToVM(self.vm, innerFetchResult) as VM.ModuleObject
      }
    }
  }

  public createSnapshotIL(): SnapshotIL {
    return this.vm.createSnapshotIL();
  }

  public createSnapshot(opts: SnapshottingOptions = {}): SnapshotClass {
    let snapshotInfo = this.createSnapshotIL();
    if (opts.optimizationHook) {
      snapshotInfo = opts.optimizationHook(snapshotInfo);
    }
    const generateHTML = false; // For debugging
    const { snapshot, html } = encodeSnapshot(snapshotInfo, generateHTML);
    if (html) writeTextFile('snapshot.html', html);
    return snapshot;
  }

  public stringifyState() {
    return this.vm.stringifyState();
  }

  public vmExport = (exportID: IL.ExportID, value: any) => {
    if (typeof exportID !== 'number' || (exportID | 0) !== exportID || exportID < 0 || exportID > 65535)
      throw new Error(`ID for \`vmExport\` must be an integer in the range 0 to 65535. Received ${exportID}`);

    const vmValue = hostValueToVM(this.vm, value);
    this.vm.vmExport(exportID, vmValue);
  }

  public vmImport = (...args: [IL.HostFunctionID, Function]) => {
    if (args.length < 1) throw new Error('vmImport expects 1 argument');
    const [id, compileTimeHostFunction] = args;
    if (typeof id !== 'number' || (id | 0) !== id || id < 0 || id > 65535)
      throw new Error(`ID for \`vmImport\` must be an integer in the range 0 to 65535. Received ${id}`);

    const hostImplementation = hostFunctionToVMHandler(this.vm, compileTimeHostFunction);
    const result = this.vm.vmImport(id, hostImplementation);
    return vmValueToHost(this.vm, result, undefined);
  }

  public resolveExport(exportID: IL.ExportID): any {
    return vmValueToHost(this.vm, this.vm.resolveExport(exportID), `<export ${exportID}>`);
  }

  public garbageCollect() {
    this.vm.garbageCollect();
  }

  public newObject(): any {
    return vmValueToHost(this.vm, this.vm.newObject(), undefined);
  }

  public newArray(): any {
    return vmValueToHost(this.vm, this.vm.newArray(), undefined);
  }

  public setArrayPrototype(value: any) {
    this.vm.setArrayPrototype(hostValueToVM(this.vm, value));
  }

  public get globalThis(): any { return this._global; }
}

function hostFunctionToVMHandler(vm: VM.VirtualMachine, func: Function): VM.HostFunctionHandler {
  return {
    call(args) {
      const [object, ...innerArgs] = args.map(a => vmValueToHost(vm, a, undefined));
      const result = func.apply(object, innerArgs);
      return hostValueToVM(vm, result);
    },
    unwrap() { return func; }
  }
}

function vmValueToHost(vm: VM.VirtualMachine, value: IL.Value, nameHint: string | undefined): any {
  switch (value.type) {
    case 'BooleanValue':
    case 'NumberValue':
    case 'UndefinedValue':
    case 'StringValue':
    case 'NullValue':
      return value.value;
    case 'FunctionValue':
    case 'HostFunctionValue':
    case 'ClosureValue':
      return ValueWrapper.wrap(vm, value, nameHint);
    case 'ClassValue':
      return ValueWrapper.wrap(vm, value, nameHint);
    case 'EphemeralFunctionValue': {
      const unwrapped = vm.unwrapEphemeralFunction(value);
      if (unwrapped === undefined) {
        // vmValueToHost can only be called with a value that actually corresponds
        // to the VM passed in. If unwrapping it does not give us anything, then
        // it's a bug.
        return unexpected();
      } else {
        // Ephemeral functions always refer to functions in the host anyway, so
        // there's no wrapping required.
        return unwrapped;
      }
    }
    case 'EphemeralObjectValue': {
      const unwrapped = vm.unwrapEphemeralObject(value);
      if (unwrapped === undefined) {
        // vmValueToHost can only be called with a value that actually corresponds
        // to the VM passed in. If unwrapping it does not give us anything, then
        // it's a bug.
        return unexpected();
      } else {
        // Ephemeral objects always refer to functions in the host anyway, so
        // there's no wrapping required.
        return unwrapped;
      }
    }
    case 'ReferenceValue': {
      return ValueWrapper.wrap(vm, value, nameHint);
    }
    case 'DeletedValue': {
      // I think that deleted values should not appear here, since they should
      // be converted to undefined or throw a TDZ error upon reading them out of
      // the source slot.
      return unexpected();
    }
    case 'StackDepthValue':
    case 'ProgramAddressValue': {
      // These are internal values and should never cross the boundary
      return unexpected();
    }
    default: return assertUnreachable(value);
  }
}


function hostValueToVM(vm: VM.VirtualMachine, value: any, nameHint?: string): IL.Value {
  switch (typeof value) {
    case 'undefined': return IL.undefinedValue;
    case 'boolean': return vm.booleanValue(value);
    case 'number': return vm.numberValue(value);
    case 'string': return vm.stringValue(value);
    case 'function': {
      if (ValueWrapper.isWrapped(vm, value)) {
        return ValueWrapper.unwrap(vm, value);
      } else {
        return vm.ephemeralFunction(hostFunctionToVMHandler(vm, value), nameHint || value.name);
      }
    }
    case 'object': {
      if (value === null) {
        return IL.nullValue;
      }
      if (ValueWrapper.isWrapped(vm, value)) {
        return ValueWrapper.unwrap(vm, value);
      } else {
        const obj = value as any;
        return vm.ephemeralObject({
          get(_object, prop) {
            return hostValueToVM(vm, obj[prop]);
          },
          set(_object, prop, value) {
            obj[prop] = vmValueToHost(vm, value, nameHint ? nameHint + '.' + prop : undefined);
          },
          keys(_obj) {
            return Reflect.ownKeys(value).filter(k => typeof k === 'string') as string[]
          },
          unwrap() {
            return obj;
          }
        });
      }
    }
    default: return notImplemented();
  }
}

// Used as targets for proxies, so that `typeof` and `call` work as expected
const dummyFunctionTarget = Object.freeze(() => {});
const dummyObjectTarget = Object.freeze({});
const dummyArrayTarget = Object.freeze([]);
const dummyUint8ArrayTarget = Object.freeze(new Uint8Array());

const vmValueSymbol = Symbol('vmValue');
const vmSymbol = Symbol('vm');

// TODO: I can't get TypeScript to accept the existence of FinalizationRegistry
declare const FinalizationRegistry: any;

export class ValueWrapper implements ProxyHandler<any> {
  private static finalizationGroup = new FinalizationRegistry(releaseHandle);

  constructor (
    private vm: VM.VirtualMachine,
    private vmValue: IL.Value,
    private nameHint: string | undefined,
  ) {
    /* This wrapper uses weakrefs. The wrapper has a strong host-reference
     * (node.js reference) to the IL.Value, but is a weak VM-reference
     * (Microvium reference) (i.e. the VM implementation doesn't know that the
     * host has a reference). In order to protect the VM from collecting the
     * IL.Value, we create a VM.Handle that keeps the value reachable within the
     * VM.
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

  static wrap(
    vm: VM.VirtualMachine,
    value: IL.FunctionValue | IL.ReferenceValue | IL.HostFunctionValue | IL.ClosureValue | IL.ClassValue,
    nameHint: string | undefined
  ): any {
    // We need to choose the appropriate proxy target so that things like
    // `Array.isArray` and `typeof x === 'function'` work as expected on the
    // proxied value.
    let proxyTarget: any;
    switch (value.type) {
      case 'ReferenceValue': {
        const dereferenced = vm.dereference(value);
        switch (dereferenced.type) {
          case 'ObjectAllocation': proxyTarget = dummyObjectTarget; break;
          case 'ArrayAllocation': proxyTarget = dummyArrayTarget; break;
          case 'Uint8ArrayAllocation': proxyTarget = dummyUint8ArrayTarget; break;
          default: assertUnreachable(dereferenced);
        }
        break;
      }
      case 'HostFunctionValue':
      case 'ClosureValue':
      case 'ClassValue':
      case 'FunctionValue': proxyTarget = dummyFunctionTarget; break;
      default: assertUnreachable(value);
    }

    return new Proxy<any>(proxyTarget, new ValueWrapper(vm, value, nameHint));
  }

  static unwrap(vm: VM.VirtualMachine, value: any): IL.Value {
    hardAssert(ValueWrapper.isWrapped(vm, value));
    return value[vmValueSymbol];
  }

  get(_target: any, p: PropertyKey, receiver: any): any {
    if (p === vmValueSymbol) return this.vmValue;
    if (p === vmSymbol) return this.vm;
    if (typeof p !== 'string') return invalidOperation('Only string properties supported');
    if (/^\d+$/.test(p)) {
      p = parseInt(p);
    }
    const result = this.vm.getProperty(this.vmValue, hostValueToVM(this.vm, p));
    return vmValueToHost(this.vm, result, this.nameHint ? `${this.nameHint}.${p}` : undefined);
  }

  set(_target: any, p: PropertyKey, value: any, receiver: any): boolean {
    if (typeof p !== 'string') return invalidOperation('Only string properties supported');
    if (/^\d+$/.test(p)) {
      p = parseInt(p);
    }
    this.vm.setProperty(this.vmValue, hostValueToVM(this.vm, p), hostValueToVM(this.vm, value));
    return true;
  }

  apply(_target: any, thisArg: any, argArray: any[] = []): any {
    const args = [thisArg, ...argArray].map(a => hostValueToVM(this.vm, a));
    const func = this.vmValue;
    if (func.type !== 'FunctionValue' && func.type !== 'ClosureValue') {
      return invalidOperation('Target is not callable');
    }
    const result = this.vm.runFunction(func, args);
    if (result.type === 'Exception') {
      throw vmValueToHost(this.vm, result.exception, undefined);
    }
    return vmValueToHost(this.vm, result, undefined);
  }
}

class GlobalWrapper implements ProxyHandler<any> {
  constructor (
    private vm: VM.VirtualMachine
  ) {
  }

  get(_target: any, p: PropertyKey, receiver: any): any {
    if (typeof p !== 'string') return invalidOperation('Only string-valued global variables are supported');
    return vmValueToHost(this.vm, this.vm.globalGet(p), p);
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