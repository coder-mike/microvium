import { decodeSnapshot, stringifySnapshotMapping as stringifySnapshotDisassembly } from "../../lib/decode-snapshot";
import { decodeSnapshotTestFilenames } from "./filenames";
import { TestResults } from "../common";
import { encodeSnapshot } from "../../lib/encode-snapshot";
import { VirtualMachineFriendly } from "../../lib/virtual-machine-friendly";
import { defaultHostEnvironment, HostImportTable } from "../../lib";
import { addBuiltinGlobals } from "../../lib/builtin-globals";
import { stringifySnapshotInfo } from "../../lib/snapshot-info";

suite('decodeSnapshot', function () {
  test('decodeSnapshot', () => {
    const importMap: HostImportTable = {
      1: () => {}
    };
    const vm = new VirtualMachineFriendly(undefined, importMap);
    vm.globalThis.print = vm.importHostFunction(1);
    vm.globalThis.vmExport = vm.exportValue;

    const sourceText = `
      const o = { x: 'Hello, World!', y: { z: 'Hello, World!' } };
      const a = [];
      vmExport(0, run);
      function run() {
        print(o.x);
        print(a[0]);
      }
    `;
    vm.evaluateModule({ sourceText });

    const testResults = new TestResults();

    const snapshot = vm.createSnapshot();
    const decoded = decodeSnapshot(snapshot);
    const il = stringifySnapshotInfo(decoded.snapshotInfo);
    const disassemblyString = stringifySnapshotDisassembly(decoded.disassembly);

    testResults.push(il, decodeSnapshotTestFilenames["decode-snapshot"].il);
    testResults.push(disassemblyString, decodeSnapshotTestFilenames["decode-snapshot"].disassembly);
    testResults.checkAll();
  });
});