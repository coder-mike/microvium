import * as VM from "../../lib/virtual-machine";
import { VirtualMachine, GlobalDefinitions } from "../../lib/virtual-machine";
import { assert } from 'chai';
import fs from 'fs-extra';
import { assertSameCode } from "../../lib/utils";
import { stringifySnapshot, saveSnapshotToBytecode as snapshotToBytecode } from "../../lib/snapshot";
import { createVirtualMachine, Globals } from "../../lib/virtual-machine-proxy";

suite(VirtualMachine.name, function () {
  test('hello-world', () => {
    const src = `print('Hello, World!');`;
    const filename = 'dummy.mvms';
    const printLog: string[] = [];

    const globals: Globals = {
      print: (v: any) => printLog.push(typeof v === 'string' ? v : JSON.stringify(v))
    }

    const vm = createVirtualMachine(globals);
    vm.importModuleSourceText(src, filename);
    const snapshot = vm.createSnapshot();

    assert.deepEqual(printLog, ['Hello, World!']);
    assertSameCode(stringifySnapshot(snapshot), `
      slot ['dummy.mvms:#entry'] = &function ['dummy.mvms:#entry'];
      slot ['dummy.mvms:exports'] = &allocation 1;
      slot ['global:print'] = &ephemeral print;

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

    const bytecode = snapshotToBytecode(snapshot);
    // assert.deepEqual(bytecode, Buffer.from([]));
  });

  test('addition', () => {
    const src = `1 + 2;`;
    const filename = 'dummy.mvms';

    const vm = VirtualMachine.create({});
    vm.importModuleSourceText(src, filename);
    const snapshot = vm.createSnapshot();

    assertSameCode(stringifySnapshot(snapshot), `
      slot ['dummy.mvms:#entry'] = &function ['dummy.mvms:#entry'];
      slot ['dummy.mvms:exports'] = &allocation 1;

      function ['dummy.mvms:#entry']() {
        entry:
          LoadArg(index 0);
          StoreGlobal(name 'dummy.mvms:exports');
          Literal(lit 1);
          Literal(lit 2);
          BinOp(op '+');
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
