import { MicroVM, HostFunctionID, ExportID, ResolveImport, ImportTable } from "../lib";
import { assert } from "chai";

suite('hello-world', function () {
  test('create', () => {
    const logs: string[] = [];
    const vm = MicroVM.create();
    vm.global.print = (s: string) => logs.push(s);
    vm.importSourceText('print("Hello, World!");');
    assert.deepEqual(logs, ['Hello, World!']);
  });

  test('restore', () => {
    // These IDs are shared knowledge between the two epochs
    const PRINT_ID: HostFunctionID = 1;
    const SAY_HELLO_ID: ExportID = 42;

    const logs: string[] = [];
    const print = (s: string) => void logs.push(s);

    const importMap: ImportTable = {
      [PRINT_ID]: print
    };

    const vm1 = MicroVM.create(importMap);
    vm1.global.print = vm1.importHostFunction(PRINT_ID);
    vm1.global.vmExport = vm1.exportValue;

    vm1.importSourceText(`
      vmExport(${SAY_HELLO_ID}, sayHello);
      function sayHello() {
        print('Hello, World!');
      }
    `);

    const snapshot = vm1.createSnapshot();

    // When the snapshot is restored, it need to reconnect with the print function, by identifier
    const importTable: ImportTable = {
      [PRINT_ID]: print
    };

    const vm2 = MicroVM.restore(snapshot, importTable);
    const sayHello = vm2.resolveExport(SAY_HELLO_ID);
    assert.deepEqual(logs, []);
    sayHello();
    assert.deepEqual(logs, ['Hello, World!']);
  });
});
