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
      100: () => {}
    };
    const vm = new VirtualMachineFriendly(undefined, importMap);
    vm.globalThis.print = vm.importHostFunction(100);
    vm.globalThis.vmExport = vm.exportValue;

    const sourceText = `
      const o = { x: 'Hello, World!', y: { z: 'Hello, World!' } };
      const a = [];
      vmExport(42, run);
      function run() {
        print(o.x);
        print(a[0]);
      }
    `;
    vm.evaluateModule({ sourceText });
    vm.garbageCollect();

    const testResults = new TestResults();

    const snapshotToSave = vm.createSnapshotInfo();
    const snapshot = vm.createSnapshot();
    const decoded = decodeSnapshot(snapshot);
    const snapshotLoaded = decoded.snapshotInfo;
    const disassemblyString = decoded.disassembly;

    testResults.push(stringifySnapshotInfo(snapshotToSave), decodeSnapshotTestFilenames["decode-snapshot"].snapshotToSave);
    testResults.push(stringifySnapshotInfo(snapshotLoaded), decodeSnapshotTestFilenames["decode-snapshot"].snapshotLoaded);
    testResults.push(stringifySnapshotDisassembly(disassemblyString), decodeSnapshotTestFilenames["decode-snapshot"].disassembly);
    testResults.checkAll();
  });
});