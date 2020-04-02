import * as VM from "../../lib/virtual-machine";
import { VirtualMachine } from "../../lib/virtual-machine";
import { assert } from 'chai';

suite('compile-time-vm', function () {
  test('Hello world', () => {
    const src = `print('Hello, World!');`;
    const filename = 'dummy.mvms';
    const printLog: string[] = [];

    const machine = new VirtualMachine();
    machine.defineGlobal('print', vmPrintTo(machine, printLog));
    machine.importModuleSourceText(src, filename);

    assert.deepEqual(printLog, ['Hello, World!']);
  });
});

function vmPrintTo(vm: VirtualMachine, printLog: string[], traceLog?: string[]): VM.Anchor<VM.ExternalFunctionValue> {
  return vm.registerExternalFunction('printTo', (object: VM.Value | undefined, func: VM.Value, args: VM.Value[]): VM.Anchor<VM.Value> => {
    const s = vm.convertToNativePOD(args[0] || vm.undefinedValue);
    if (typeof s === 'string') {
      printLog.push(s);
      traceLog && traceLog.push('Print: ' + s);
    } else {
      const valueText = stringifyPOD(s);
      printLog.push(valueText);
      traceLog && traceLog.push('Print: ' + valueText);
    }
    return vm.createAnchor(vm.undefinedValue);
  });
}

function stringifyPOD(value: any): string {
  if (value === null) return 'null';
  if (value === undefined) return 'undefined';
  if (Array.isArray(value)) return `[${value.map(stringifyPOD).join(', ')}]`;
  if (typeof value === 'object') {
    return `{ ${[...Object.entries(value)].map(([k, v]) => `${stringifyKey(k)}: ${stringifyPOD(v)}`).join(', ')} }`;
  }
  return JSON.stringify(value);
}

function stringifyKey(k: string): string {
  if (/^[a-zA-Z_][a-zA-Z0-9_]*$/.test(k)) {
    return k;
  } else {
    return JSON.stringify(k);
  }
}