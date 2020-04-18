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

    const vm = VirtualMachineFriendly.create({});
    vm.importSourceText(src, filename);
    const snapshotInfo = vm.createSnapshotInfo();

    const { snapshot, html } = encodeSnapshot(snapshotInfo, true);
    const outputHTML = htmlPageTemplate(html!);

    testResults.push(stringifySnapshotInfo(snapshotInfo), outputFilenames.snapshot);
    testResults.push(snapshot.data, outputFilenames.bytecode);
    testResults.push(outputHTML, outputFilenames.html);

    testResults.checkAll();
  });
});
