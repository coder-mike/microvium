import * as VM from "../../lib/virtual-machine";
import { VirtualMachine, GlobalDefinitions } from "../../lib/virtual-machine";
import { assert } from 'chai';
import fs from 'fs-extra';
import { stringifySnapshotInfo, encodeSnapshot } from "../../lib/snapshot-info";
import { Globals, VirtualMachineFriendly } from "../../lib/virtual-machine-friendly";
import { TestResults } from "../common";
import { htmlPageTemplate } from "../../lib/general";
import { virtualMachineTestFilenames as virtualMachineTestFilenames } from "./filenames";

suite(VirtualMachine.name, function () {
  test('hello-world', () => {
    const testResults = new TestResults();
    const outputFilenames = virtualMachineTestFilenames['hello-world'];

    const src = `print('Hello, World!');`;
    const filename = 'dummy.mvms';
    const printLog: string[] = [];

    const vm = VirtualMachineFriendly.create();
    vm.global.print = (v: any) => printLog.push(typeof v === 'string' ? v : JSON.stringify(v));
    vm.importSourceText(src, filename);
    const snapshotInfo = vm.createSnapshotInfo();

    assert.deepEqual(printLog, ['Hello, World!']);

    const { snapshot, html } = encodeSnapshot(snapshotInfo, true);
    const outputHTML = htmlPageTemplate(html!);

    testResults.push(stringifySnapshotInfo(snapshotInfo), outputFilenames.snapshot);
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
    vm.importSourceText(src, filename);
    const snapshotInfo = vm.createSnapshotInfo();

    const { snapshot, html } = encodeSnapshot(snapshotInfo, true);
    const outputHTML = htmlPageTemplate(html!);

    testResults.push(stringifySnapshotInfo(snapshotInfo), outputFilenames.snapshot);
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
    vm.importSourceText(src, filename);
    const snapshotInfo = vm.createSnapshotInfo();

    const { snapshot, html } = encodeSnapshot(snapshotInfo, true);
    const outputHTML = htmlPageTemplate(html!);

    testResults.push(stringifySnapshotInfo(snapshotInfo), outputFilenames.snapshot);
    testResults.push(snapshot.data, outputFilenames.bytecode);
    testResults.push(outputHTML, outputFilenames.html);

    testResults.checkAll();
  });

  test('ephemeral-objects', () => {
    const vm = VirtualMachineFriendly.create();
    const printLog: any[] = [];
    const obj = {
      x: 10,
      y: 20,
    };
    vm.global.print = (s: any) => printLog.push(s);
    vm.global.obj = obj;
    vm.global.vmExport = vm.exportValue;
    const src = `
      vmExport(0, foo);
      function foo() {
        print(obj.x);
      }`
    vm.importSourceText(src);
    const foo = vm.resolveExport(0);
    foo(); // Should print 10
    // Mutate the object
    obj.x = 50;
    foo(); // Should print 50

    assert.deepEqual(printLog, [10, 50]);
  });
});
