import { MicroVM } from "../lib";
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
});
