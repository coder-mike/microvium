import { Microvium, HostFunctionID, ExportID, HostImportFunction, HostImportTable } from "../lib";
import { assert } from "chai";

suite('hello-world', function () {
  test('create', () => {
    const logs: string[] = [];
    const vm = Microvium.create();
    vm.globalThis.print = (s: string) => logs.push(s);
    vm.evaluateModule({ sourceText: 'print("Hello, World!");' });
    assert.deepEqual(logs, ['Hello, World!']);
  });

  test('restore', () => {
    // These IDs are shared knowledge between the two epochs
    const PRINT: HostFunctionID = 1;
    const SAY_HELLO: ExportID = 42;

    const logs: string[] = [];
    const print = (s: string) => void logs.push(s);

    const importMap: HostImportTable = {
      [PRINT]: print
    };

    const vm1 = Microvium.create(importMap);
    vm1.globalThis.print = vm1.importHostFunction(PRINT);
    vm1.globalThis.vmExport = vm1.vmExport;

    vm1.evaluateModule({ sourceText: `
      vmExport(${SAY_HELLO}, sayHello);
      function sayHello() {
        print('Hello, World!');
      }
    `});

    const snapshot = vm1.createSnapshot();

    // Restore the VM with access to the same set of imports by ID
    const vm2 = Microvium.restore(snapshot, importMap);
    const sayHello = vm2.resolveExport(SAY_HELLO);

    assert.deepEqual(logs, []);
    sayHello();
    assert.deepEqual(logs, ['Hello, World!']);
  });
});
