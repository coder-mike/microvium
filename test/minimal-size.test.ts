import { MemoryStats, Microvium } from "../lib";
import { assert } from "chai";

suite('minimal-size', function () {
  const corePointerCount = 6;
  const coreLongPointerCount = 1;
  const coreOptionalInt32Count = 1;
  const coreWordCount = 4; // includes 2 single-byte fields
  const coreOptionalPointerCount = 2;

  // In the following, "optional features" refers to debug capability and gas counter

  // The expected size on a 64-bit machine with optional features enabled
  const coreSize64BitMax = roundUpTo8Bytes(
    (corePointerCount + coreLongPointerCount + coreOptionalPointerCount) * 8 +
    coreOptionalInt32Count * 4 +
    coreWordCount * 2
  );

  // The core size on a 32-bit embedded device, with optional features
  const coreSize32BitMax =
    (corePointerCount + coreLongPointerCount + coreOptionalPointerCount) * 4 +
    coreOptionalInt32Count * 4 +
    coreWordCount * 2;

  // The core size on a 32-bit embedded device, without optional features
  const coreSize32BitMin =
    (corePointerCount + coreLongPointerCount) * 4 +
    coreWordCount * 2;

  // The core size on a 16-bit embedded device, without optional features
  const coreSize16BitMin =
    corePointerCount * 2 + coreLongPointerCount * 4 + coreWordCount * 2;

  test('no-lib', () => {
    /*
    This tests the smallest theoretical size for Microvium (see the assertions
    at the end of this function):

      - No builtins
      - No debugger support
      - 32-bit or 16-bit device

    The tests are run on this machine, which is a 64-bit machine (please run
    these tests with the 64-bit version of node.js, so these results are
    consistent). This is inferring the 16-bit and 32-bit by calculating the
    expected size on a 16-, 32-, and 64-bit platforms and then asserting the
    64-bit size and assuming then that the 16-bit and 32-bit sizes are also
    correct.
    */

    const vm = Microvium.create({}, { noLib: true });
    vm.evaluateModule({ sourceText: '' });
    const snapshot = vm.createSnapshot();
    assert.equal(snapshot.data.length, 46);

    // Note: because we're not running this on an emulator, this is the size as
    // running on a 64-bit machine. Also, debug mode is enabled
    const vm2 = Microvium.restore(snapshot, {});
    const stats = vm2.getMemoryStats();
    assert.equal(stats.totalSize, coreSize64BitMax);
    assert.equal(stats.coreSize, coreSize64BitMax);
    assert.equal(stats.fragmentCount, 1);
    assert.equal(stats.virtualHeapAllocatedCapacity, 0);
    assert.equal(stats.virtualHeapUsed, 0);
    assert.equal(stats.virtualHeapHighWaterMark, 0);
    assert.equal(stats.stackHighWaterMark, 0);
    assert.equal(stats.stackHeight, 0);
    assert.equal(stats.stackAllocatedCapacity, 0);
    assert.equal(stats.registersSize, 0);
    assert.equal(stats.importTableSize, 0);
    assert.equal(stats.globalVariablesSize, 0);

    assert.equal(coreSize64BitMax, 88);
    assert.equal(coreSize32BitMax, 48);

    // Smallest theoretical size:
    assert.equal(coreSize32BitMin, 36);
    assert.equal(coreSize16BitMin, 24);
  })

  test('empty-size', () => {
    const vm = Microvium.create({}, {});
    vm.evaluateModule({ sourceText: '' });
    const snapshot = vm.createSnapshot();
    assert.equal(snapshot.data.length, 46);

    const vm2 = Microvium.restore(snapshot, {});
    const stats = vm2.getMemoryStats();
    assert.equal(stats.totalSize, 80);
    assert.equal(stats.coreSize, 80);
    assert.equal(stats.fragmentCount, 1);
    assert.equal(stats.virtualHeapAllocatedCapacity, 0);
    assert.equal(stats.virtualHeapUsed, 0);
    assert.equal(stats.virtualHeapHighWaterMark, 0);

    assert.equal(stats.stackHighWaterMark, 0);
    assert.equal(stats.stackHeight, 0);
    assert.equal(stats.stackAllocatedCapacity, 0);
    assert.equal(stats.registersSize, 0);
    assert.equal(stats.importTableSize, 0);
    assert.equal(stats.globalVariablesSize, 0);
  })

  test('running-size', () => { const vm = Microvium.create({}, { });
    /*
    This tests the size of the VM when actually running. Like with the no-lib
    test, I calculate what the size should be on different platforms and then
    assert the size for this platform to test the assumptions.

    This one is not compiled with noLib. The idea here is that this a "typical"
    usage of the engine rather than completely minimal. This amount of space is
    what you'd reasonably expect for a roughly-empty program.

    */

    const pointerRegisterCount = 4;
    const longPointerRegisterCount = 1;
    const wordRegisterCount = 4;
    const optionalWordRegisterCount = 1; // Includes single-byte `usingCachedRegisters`

    const registersSize64BitMax = padTo64Bit(
      pointerRegisterCount * 8 +
      longPointerRegisterCount * 8 +
      wordRegisterCount * 2 +
      optionalWordRegisterCount * 2
    );

    const registersSize32BitMax = padTo32Bit(
      pointerRegisterCount * 4 +
      longPointerRegisterCount * 4 +
      wordRegisterCount * 2 +
      optionalWordRegisterCount * 2
    );

    const registersSize32BitMin = padTo32Bit(
      pointerRegisterCount * 4 +
      longPointerRegisterCount * 4 +
      wordRegisterCount * 2
    )

    const registersSize16BitMin =
      pointerRegisterCount * 2 +
      longPointerRegisterCount * 4 +
      wordRegisterCount * 2;

    const importTableCount = 1; // This example imports one function
    const importTableSize64Bit = importTableCount * 8;
    const importTableSize32Bit = importTableCount * 4;
    const importTableSize16Bit = importTableCount * 4; // Using 4 bytes here because flash pointer
    const globalVariablesSize = 2; // 1 global variable at 2 bytes each

    const virtualHeapSize = 0; // Now that builtins are GC'd, the virtual heap can be empty

    const defaultStackCapacity = 256;

    const heapOverheadSize64Bit = 4 * 8;
    const heapOverheadSize32Bit = 4 * 4;
    const heapOverheadSize16Bit = 4 * 2;

    const totalSize64BitMax =
      coreSize64BitMax +
      importTableSize64Bit +
      globalVariablesSize +
      registersSize64BitMax +
      defaultStackCapacity +
      virtualHeapSize +
      (virtualHeapSize ? heapOverheadSize64Bit : 0);

    const totalSize32BitMin =
      coreSize32BitMin +
      importTableSize32Bit +
      globalVariablesSize +
      registersSize32BitMin +
      defaultStackCapacity +
      virtualHeapSize +
      (virtualHeapSize ? heapOverheadSize32Bit : 0);

    const totalSize32BitMax =
      coreSize32BitMax +
      importTableSize32Bit +
      globalVariablesSize +
      registersSize32BitMax +
      defaultStackCapacity +
      virtualHeapSize +
      (virtualHeapSize ? heapOverheadSize32Bit : 0);

    const totalSize16BitMin =
      coreSize16BitMin +
      importTableSize16Bit +
      globalVariablesSize +
      registersSize16BitMin +
      defaultStackCapacity +
      virtualHeapSize +
      (virtualHeapSize ? heapOverheadSize16Bit : 0);

    vm.globalThis.vmImport = vm.vmImport;
    vm.globalThis.vmExport = vm.vmExport;
    vm.evaluateModule({ sourceText: `
      const checkSize = vmImport(0);
      vmExport(0, () => checkSize());
    `});
    const snapshot = vm.createSnapshot();
    assert.equal(snapshot.data.length, 70);

    const vm2 = Microvium.restore(snapshot, { 0: checkSize });

    let stats: MemoryStats = undefined as any;

    const run = vm2.resolveExport(0);
    run();

    function checkSize() {
      stats = vm2.getMemoryStats();
    }

    assert.equal(stats.totalSize, totalSize64BitMax);
    assert.equal(stats.coreSize, coreSize64BitMax);
    assert.equal(stats.fragmentCount, 2);
    assert.equal(stats.virtualHeapAllocatedCapacity, virtualHeapSize);
    assert.equal(stats.virtualHeapUsed, virtualHeapSize);
    assert.equal(stats.virtualHeapHighWaterMark, virtualHeapSize);
    assert.equal(stats.stackHighWaterMark, 24);
    assert.equal(stats.stackHeight, 16);
    assert.equal(stats.stackAllocatedCapacity, defaultStackCapacity);
    assert.equal(stats.registersSize, registersSize64BitMax);
    assert.equal(stats.importTableSize, importTableSize64Bit);
    assert.equal(stats.globalVariablesSize, 2);

    // The following is the final figures. Just update them manually when they change

    assert.equal(registersSize64BitMax, 56);
    assert.equal(registersSize32BitMax, 32);
    assert.equal(registersSize32BitMin, 28);
    assert.equal(registersSize16BitMin, 20);

    assert.equal(totalSize64BitMax, 402);
    assert.equal(totalSize32BitMax, 338);
    assert.equal(totalSize32BitMin, 326);
    assert.equal(totalSize16BitMin, 306);
  })
})

function padTo64Bit(n: number) {
  return Math.ceil(n / 8) * 8;
}

function padTo32Bit(n: number) {
  return Math.ceil(n / 4) * 4;
}

function roundUpTo8Bytes(n: number) {
  return Math.ceil(n / 8) * 8;
}