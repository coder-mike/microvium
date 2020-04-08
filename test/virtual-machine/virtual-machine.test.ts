import * as VM from "../../lib/virtual-machine";
import { VirtualMachine } from "../../lib/virtual-machine";
import { assert } from 'chai';
import fs from 'fs-extra';
import { assertSameCode } from "../../lib/utils";
import { stringifySnapshot, saveSnapshotToBytecode as snapshotToBytecode } from "../../lib/snapshot";

const EXTERNAL_FUNCTION_PRINT_TO = 1;

suite('virtual-machine', function () {
  test('hello-world', () => {
    const src = `print('Hello, World!');`;
    const filename = 'dummy.mvms';
    const printLog: string[] = [];

    const vm = new VirtualMachine();
    vm.defineGlobal('print', vmPrintTo(vm, printLog));
    vm.importModuleSourceText(src, filename);
    const snapshot = vm.createSnapshot();

    assert.deepEqual(printLog, ['Hello, World!']);
    assertSameCode(stringifySnapshot(snapshot), `
      slot ['dummy.mvms:#entry'] = &function ['dummy.mvms:#entry'];
      slot ['dummy.mvms:exports'] = &allocation 1;
      slot ['global:print'] = external function 1;

      function ['dummy.mvms:#entry']() {
        entry:
          LoadArg(index 0);
          StoreGlobal(name 'dummy.mvms:exports');
          LoadGlobal(name 'global:print');
          Literal(lit 'Hello, World!');
          Call(count 1);
          Pop(count 1);
          Literal(lit undefined);
          Return();
      }

      allocation 1 = {
      };
    `);

    // const bytecode = snapshotToBytecode(snapshot);
    // assert.deepEqual(bytecode, Buffer.from([]));
  });
});

function vmPrintTo(vm: VirtualMachine, printLog: string[], traceLog?: string[]): VM.Anchor<VM.ExternalFunctionValue> {
  return vm.registerExternalFunction(EXTERNAL_FUNCTION_PRINT_TO, (_object: VM.Value | undefined, _func: VM.Value, args: VM.Value[]): VM.Anchor<VM.Value> => {
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