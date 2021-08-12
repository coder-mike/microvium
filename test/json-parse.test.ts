import { Microvium } from "../lib";
import { assert } from "chai";
import { jsonParse } from "../lib/run-app";

const inputJSON = JSON.stringify({
  x: 10,
  y: [5, 6]
});

const sourceText = `
  const config = JSON.parse(getConfig());
  vmExport(0, run);
  const assertEqual = vmImport(0);

  function run() {
    assertEqual(config.x, 10);
    assertEqual(config.y.length, 2);
    assertEqual(config.y[0], 5);
    assertEqual(config.y[1], 6);
  }
`;

suite.skip('json-parse', function () {
  test('general', () => {
    const snapshot = build();
    const vm = Microvium.restore(snapshot, {
      0: assertEqual
    });
    const run = vm.resolveExport(0);
    run();

    function assertEqual(a: any, b: any) {
      assert.deepEqual(a, b);
    }

    function build() {
      const vm = Microvium.create();
      const global = vm.globalThis;
      global.parse = jsonParse(vm);
      global.vmExport = vm.vmExport;
      global.vmImport = vm.vmImport;
      global.JSON = vm.newObject();
      global.JSON.parse = jsonParse(vm);
      global.getConfig = () => inputJSON;
      vm.evaluateModule({ sourceText });
      return vm.createSnapshot();
    }
  });
});