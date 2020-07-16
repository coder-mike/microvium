import { decodeSnapshot } from "../../lib/decode-snapshot";
import { decodeSnapshotTestFilenames } from "./filenames";
import { TestResults, assertSameCode } from "../common";
import { encodeSnapshot } from "../../lib/encode-snapshot";
import { VirtualMachineFriendly } from "../../lib/virtual-machine-friendly";
import { defaultHostEnvironment, HostImportTable } from "../../lib";
import { addBuiltinGlobals } from "../../lib/builtin-globals";
import { stringifySnapshotIL } from "../../lib/snapshot-il";

suite('decodeSnapshot', function () {
  test.skip('decodeSnapshot', () => {
    const filenames = decodeSnapshotTestFilenames["decode-snapshot"];

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

    const snapshotToSave = vm.createSnapshotIL();
    const snapshotToSaveStr = stringifySnapshotIL(snapshotToSave);
    const snapshot = encodeSnapshot(snapshotToSave, false).snapshot;
    const decoded = decodeSnapshot(snapshot);
    const snapshotLoaded = stringifySnapshotIL(decoded.snapshotInfo);
    const disassemblyString = decoded.disassembly;

    testResults.push(snapshotToSaveStr, filenames.snapshotToSave);
    testResults.push(snapshotLoaded, filenames.snapshotLoaded);
    testResults.push(disassemblyString, filenames.disassembly);
    testResults.checkAll();

    assertSameCode(snapshotToSaveStr, snapshotLoaded);
  });
});