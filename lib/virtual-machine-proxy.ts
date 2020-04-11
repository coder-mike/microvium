import * as VM from './virtual-machine';
import { mapObject, notImplemented, assertUnreachable } from './utils';

export interface Globals {
  [name: string]: any;
}

export function createVirtualMachine(globals: Globals, opts: VM.VirtualMachineOptions = {}): VM.VirtualMachine {
  const proxiedGlobals = mapObject(globals, createGlobal);
  return VM.VirtualMachine.create(proxiedGlobals, opts);
}

function createGlobal(value: any, name: string): VM.GlobalDefinition {
  return vm => hostValueToVM(vm, value, name);
}

function hostFunctionToVM(vm: VM.VirtualMachine, func: Function): VM.ExternalFunctionHandler {
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
    case 'FunctionValue': return notImplemented();
    case 'ExternalFunctionValue': return notImplemented();
    case 'EphemeralFunctionValue': return notImplemented();
    case 'ReferenceValue': return notImplemented();
    default: return assertUnreachable(value);
  }
}

function hostValueToVM(vm: VM.VirtualMachine, value: any, nameHint?: string): VM.Anchor<VM.Value> {
  switch (typeof value) {
    case 'undefined': return vm.createAnchor(vm.undefinedValue);
    case 'boolean': return vm.createAnchor(vm.booleanValue(value));
    case 'number': return vm.createAnchor(vm.numberValue(value));
    case 'string': return vm.createAnchor(vm.stringValue(value));
    case 'function': return vm.ephemeralFunction(hostFunctionToVM(vm, value), nameHint || value.name);
    case 'object': {
      if (value === null) {
        return vm.createAnchor(vm.undefinedValue);
      }
      return notImplemented();
    }
    default: return notImplemented();
  }
}
