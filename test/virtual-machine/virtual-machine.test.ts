import * as VM from "../../lib/virtual-machine";
import { VirtualMachine, GlobalDefinitions } from "../../lib/virtual-machine";
import { assert } from 'chai';
import fs from 'fs-extra';
import { stringifySnapshotIL } from "../../lib/snapshot-il";
import { Globals, VirtualMachineFriendly } from "../../lib/virtual-machine-friendly";
import { TestResults } from "../common";
import { htmlPageTemplate } from "../../lib/general";
import { virtualMachineTestFilenames as virtualMachineTestFilenames } from "./filenames";
import Microvium from "../../lib";
import { encodeSnapshot } from "../../lib/encode-snapshot";

suite(VirtualMachine.name, function () {
  test('hello-world', () => {
    const testResults = new TestResults();
    const outputFilenames = virtualMachineTestFilenames['hello-world'];

    const src = `print('Hello, World!');`;
    const filename = 'dummy.mvms';
    const printLog: string[] = [];

    const vm = VirtualMachineFriendly.create();
    vm.globalThis.print = (v: any) => printLog.push(typeof v === 'string' ? v : JSON.stringify(v));
    vm.evaluateModule({ sourceText: src, debugFilename: filename });
    const snapshotInfo = vm.createSnapshotIL();

    assert.deepEqual(printLog, ['Hello, World!']);

    const { snapshot, html } = encodeSnapshot(snapshotInfo, true);
    const outputHTML = htmlPageTemplate(html!);

    testResults.push(stringifySnapshotIL(snapshotInfo), outputFilenames.snapshot);
    testResults.push(snapshot.data, outputFilenames.bytecode);
    testResults.push(outputHTML, outputFilenames.html);

    testResults.checkAll();

  });

  test('addition', () => {
    const testResults = new TestResults();
    const outputFilenames = virtualMachineTestFilenames['addition'];

    const src = `1 + 2;`;
    const filename = 'dummy.mvms';

    const vm = VirtualMachineFriendly.create();
    vm.evaluateModule({ sourceText: src, debugFilename: filename });
    const snapshotInfo = vm.createSnapshotIL();

    const { snapshot, html } = encodeSnapshot(snapshotInfo, true);
    const outputHTML = htmlPageTemplate(html!);

    testResults.push(stringifySnapshotIL(snapshotInfo), outputFilenames.snapshot);
    testResults.push(snapshot.data, outputFilenames.bytecode);
    testResults.push(outputHTML, outputFilenames.html);

    testResults.checkAll();
  });

  test('simple-branching', () => {
    const testResults = new TestResults();
    const outputFilenames = virtualMachineTestFilenames['simple-branching'];

    const src = `
      if (5 > 4) {
        1;
      } else {
        0;
      }
    `;
    const filename = 'dummy.mvms';

    const vm = VirtualMachineFriendly.create();
    vm.evaluateModule({ sourceText: src, debugFilename: filename });
    const snapshotInfo = vm.createSnapshotIL();

    const { snapshot, html } = encodeSnapshot(snapshotInfo, true);
    const outputHTML = htmlPageTemplate(html!);

    testResults.push(stringifySnapshotIL(snapshotInfo), outputFilenames.snapshot);
    testResults.push(snapshot.data, outputFilenames.bytecode);
    testResults.push(outputHTML, outputFilenames.html);

    testResults.checkAll();
  });

  test('ephemeral-objects', () => {
    let printLog: any[] = [];
    const print = (s: any) => printLog.push(s);
    const importMap = {
      1: print
    };

    /*
    Ephemeral objects in Microvium are objects that are not captured in the
    snapshot, and refer directly to values in the host. These are analogous to
    proxy values whose target goes missing when the snapshot is captured.
    */
    const vm = VirtualMachineFriendly.create(importMap);
    const obj = {
      x: 10,
      y: 20,
    };
    vm.globalThis.print = vm.importHostFunction(1);
    vm.globalThis.obj = obj;
    vm.globalThis.vmExport = vm.exportValue;
    const src = `
      vmExport(0, foo);
      function foo() {
        print(obj.x);
      }`
    vm.evaluateModule({ sourceText: src });
    const foo = vm.resolveExport(0);
    foo(); // Should print 10
    // Mutate the object
    obj.x = 50;
    foo(); // Should print 50

    assert.deepEqual(printLog, [10, 50]);

    // Cut off the proxy by creating a save/restore point
    printLog = [];
    const vm2 = Microvium.restore(vm.createSnapshot(), importMap);
    const foo2 = vm2.resolveExport(0);
    foo2(); // Should print undefined
    assert.deepEqual(printLog, [undefined]);
  });
});
