import * as VM from "../../lib/virtual-machine";
import { VirtualMachine, GlobalDefinitions } from "../../lib/virtual-machine";
import { assert } from 'chai';
import fs from 'fs-extra';
import { assertSameCode } from "../../lib/utils";
import { stringifySnapshot, saveSnapshotToBytecode as snapshotToBytecode } from "../../lib/snapshot";
import { createVirtualMachine, Globals } from "../../lib/virtual-machine-proxy";
import { TestResults } from "../common";
import { htmlTemplate } from "../../lib/general";
import { virtualMachineFilenames as virtualMachineTestFilenames } from "./filenames";

suite(VirtualMachine.name, function () {
  test('hello-world', () => {
    const testResults = new TestResults();
    const outputFilenames = virtualMachineTestFilenames['hello-world'];

    const src = `print('Hello, World!');`;
    const filename = 'dummy.mvms';
    const printLog: string[] = [];

    const globals: Globals = {
      print: (v: any) => printLog.push(typeof v === 'string' ? v : JSON.stringify(v))
    };

    const vm = createVirtualMachine(globals);
    vm.importModuleSourceText(src, filename);
    const snapshot = vm.createSnapshot();

    assert.deepEqual(printLog, ['Hello, World!']);

    const { bytecode, html } = snapshotToBytecode(snapshot, true);
    const outputHTML = htmlTemplate(html!);

    testResults.push(stringifySnapshot(snapshot), outputFilenames.snapshot);
    testResults.push(bytecode, outputFilenames.bytecode);
    testResults.push(outputHTML, outputFilenames.html);

    testResults.checkAll();

  });

  test('addition', () => {
    const testResults = new TestResults();
    const outputFilenames = virtualMachineTestFilenames['addition'];

    const src = `1 + 2;`;
    const filename = 'dummy.mvms';

    const vm = VirtualMachine.create({});
    vm.importModuleSourceText(src, filename);
    const snapshot = vm.createSnapshot();

    const { bytecode, html } = snapshotToBytecode(snapshot, true);
    const outputHTML = htmlTemplate(html!);

    testResults.push(stringifySnapshot(snapshot), outputFilenames.snapshot);
    testResults.push(bytecode, outputFilenames.bytecode);
    testResults.push(outputHTML, outputFilenames.html);

    testResults.checkAll();
  });
});
