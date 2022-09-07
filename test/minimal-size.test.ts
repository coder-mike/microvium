import { Microvium } from "../lib";
import { assert } from "chai";

suite('minimal-size', function () {
  test('empty-size', () => {
    const vm = Microvium.create({}, { });
    vm.evaluateModule({ sourceText: '' });
    const snapshot = vm.createSnapshot();
    assert.equal(snapshot.data.length, 80);

    // Note: because we're not running this on an emulator, this is the size as
    // running on a 64-bit machine.
    const vm2 = Microvium.restore(snapshot, {});
    const stats = vm2.getMemoryStats();
    assert.equal(stats.totalSize, 130);
    assert.equal(stats.fragmentCount, 2);
    assert.equal(stats.virtualHeapAllocatedCapacity, 10);
    assert.equal(stats.virtualHeapUsed, 10);
    assert.equal(stats.virtualHeapHighWaterMark, 10);

    assert.equal(stats.stackHighWaterMark, 0);
    assert.equal(stats.stackHeight, 0);
    assert.equal(stats.stackAllocatedCapacity, 0);
    assert.equal(stats.registersSize, 0);
    assert.equal(stats.importTableSize, 0);
    assert.equal(stats.globalVariablesSize, 0);
  })
})