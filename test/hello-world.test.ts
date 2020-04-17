import { MicroVM, HostFunctionID, persistentHostFunction, ExportID, ResolveImport } from "../lib";
import { assert } from "chai";

suite('hello-world', function () {
  test('create', () => {
    const logs: string[] = [];
    const vm = MicroVM.create({
      print: (s: string) => logs.push(s)
    });
    vm.importSourceText('print("Hello, World!");');
    assert.deepEqual(logs, ['Hello, World!']);
  });

  test('restore', () => {
    // These IDs are shared knowledge between the two epochs
    const PRINT_ID: HostFunctionID = 1;
    const SAY_HELLO_ID: ExportID = 42;

    const logs: string[] = [];
    const print = (s: string) => void logs.push(s);
    const globals = {
      // The print function is persistent across epochs (restoring from snapshot)
      // TODO: A thought: what if the script itself creates this global by calling some kind of "import" function?
      'print': persistentHostFunction(PRINT_ID, print),
      'vmExport': (exportID: ExportID, v: any) => vm1.exportValue(exportID, v)
    };

    const vm1 = MicroVM.create(globals);
    vm1.importSourceText(`
      vmExport(${SAY_HELLO_ID}, sayHello);
      function sayHello() {
        print('Hello, World!');
      }
    `);

    const snapshot = vm1.createSnapshot();

    // When the snapshot is restored, it need to reconnect with the print function, by identifier
    const resolveImport: ResolveImport = (id: HostFunctionID) => {
      if (id == PRINT_ID) return print;
      else throw new Error('Invalid import');
    };

    const vm2 = MicroVM.restore(snapshot, resolveImport);
    const sayHello = vm2.resolveExport(SAY_HELLO_ID);
    assert.deepEqual(logs, []);
    sayHello();
    assert.deepEqual(logs, ['Hello, World!']);
  });
});
