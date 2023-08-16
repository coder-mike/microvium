import { NativeVMFriendly } from "../../lib/native-vm-friendly";
import { compileJs } from "../common"
import { assert } from 'chai'
import fs from 'fs'
import { decodeSnapshot } from "../../lib";

suite('async-host-func', function () {
  /*
  An asynchronous host function can be called in one of 3 ways:

    - void-call: it's called but the resulting "promise" is elided because it's
      not accessed
    - await-call: it's called using CPS-style, so the resulting promise is
      elided because the callback is used instead.
    - expression call: it's called as part of a normal expression and so the
      resulting promise is synthesized by `mvm_asyncStart` (not implemented at
      the time of this writing).
  */

  test('void-call', () => {
    const snapshot = compileJs`
      const asyncHostFunc = vmImport(0);
      vmExport(0, () => {
        // This is a void-call (promise result not used and so is elided)
        asyncHostFunc();
      })
      vmExport(1, Microvium.noOpFunction);
      vmExport(2, (a, b) => a === b);
    `

    let callback: any;
    const asyncHostFunc = () => {
      callback = vm.asyncStart();
    }

    const vm = new NativeVMFriendly(snapshot, { 0: asyncHostFunc });
    const entry = vm.resolveExport(0);
    const noOpFunction = vm.resolveExport(1);
    const vmIsEqual = vm.resolveExport(2);
    entry();
    // Because the async host function is being void-called, we expect the
    // callback to actually be the no-op function since nothing needs to be
    // called back. Note that I'm using an exported isEqual function because
    // identity is not preserved across the membrane at this stage.
    assert(vmIsEqual(callback, noOpFunction));

    // Just for completeness - the async host function is "required" to call the
    // callback exactly once, so I'm doing it here, even though this should be a
    // no-op call. Among other things, this tests that the host can safely call
    // the noOpFunction directly.
    callback();
  })

  test('await-call', () => {
    const snapshot = compileJs`
      const asyncHostFunc = vmImport(0);
      const print = vmImport(1);
      vmExport(0, run)
      function run() {
        print('Begin run');
        asyncFunc();
        print('End run');
      }

      async function asyncFunc() {
        print('Before await');
        // This is an await-call (promise result is elided in place of a continuation)
        await asyncHostFunc();
        print('After await');
      }
    `
    fs.writeFileSync('test/async-host-func/output.await-call.disassembly', decodeSnapshot(snapshot).disassembly);

    let callback: any;
    const printout: string[] = [];

    function asyncHostFunc() {
      callback = vm.asyncStart();
    }

    function print(s: string) {
      printout.push(s);
    }

    const vm = new NativeVMFriendly(snapshot, { 0: asyncHostFunc, 1: print });
    const run = vm.resolveExport(0);

    run();
    // Continuation has not yet executed
    assert.equal(printout.join(), 'Begin run,Before await,End run');
    // Call the continuation
    callback(true, undefined);
    assert.equal(printout.join(), 'Begin run,Before await,End run,After await');
  })

  test('async-result', () => {
    const snapshot = compileJs`
      const asyncHostFunc = vmImport(0);
      const print = vmImport(1);
      vmExport(0, () => { asyncFunc(); } );

      async function asyncFunc() {
        // The stack is still empty at the time that we make the async call, but
        // this time we discriminate on the result.
        if (await asyncHostFunc() === 42) {
          print('Result is 42');
        } else {
          print('Result is not 42');
        }
      }
    `
    fs.writeFileSync('test/async-host-func/output.async-result.disassembly', decodeSnapshot(snapshot).disassembly);

    let callback: any;
    const printout: string[] = [];

    function asyncHostFunc() {
      callback = vm.asyncStart();
    }

    function print(s: string) {
      printout.push(s);
    }

    const vm = new NativeVMFriendly(snapshot, { 0: asyncHostFunc, 1: print });
    const run = vm.resolveExport(0);

    run();
    // Continuation has not yet executed
    assert.equal(printout.join(), '');
    // Call the continuation
    callback(true, 42);
    assert.equal(printout.join(), 'Result is 42');
  })

  test('immediate-callback', () => {
    // This function tests that if the host calls the async callback
    // immediately, the continuation is not called until the next tick.

    const snapshot = compileJs`
      const asyncHostFunc = vmImport(0);
      const print = vmImport(1);
      vmExport(0, run);

      function run() {
        print('Begin run');
        asyncFunc(); // No await
        print('End run');
      }

      async function asyncFunc() {
        print('Before await');
        await asyncHostFunc();
        print('After await');
      }
    `
    fs.writeFileSync('test/async-host-func/output.immediate-callback.disassembly', decodeSnapshot(snapshot).disassembly);

    const printout: string[] = [];

    function asyncHostFunc() {
      const callback = vm.asyncStart();
      // Call immediately
      callback(true, undefined);
      // Call again (should be ignored)
      callback(true, undefined);
      // Call with error (should be ignored)
      callback(false, undefined);
    }

    function print(s: string) {
      printout.push(s);
    }

    const vm = new NativeVMFriendly(snapshot, { 0: asyncHostFunc, 1: print });

    const run = vm.resolveExport(0);

    run();

    // The key thing here is that End run is printed before After await
    assert.equal(printout.join('; '), 'Begin run; Before await; End run; After await');
  })

  test('fail-callback', () => {
    // This function tests that if the host calls the async callback
    // immediately, the continuation is not called until the next tick.

    const snapshot = compileJs`
      const asyncHostFunc = vmImport(0);
      const print = vmImport(1);
      vmExport(0, run);

      function run() {
        print('Begin run');
        asyncFunc(); // No await
        print('End run');
      }

      async function asyncFunc() {
        print('Before await');
        try {
          await asyncHostFunc();
          print('After await');
        } catch (e) {
          print('Caught error: ' + e);
        }
      }
    `
    fs.writeFileSync('test/async-host-func/output.fail-callback.disassembly', decodeSnapshot(snapshot).disassembly);

    const printout: string[] = [];

    function asyncHostFunc() {
      const callback = vm.asyncStart();
      // Call with failure
      callback(false, 'dummy error');
      // Call again (should be ignored)
      callback(true, undefined);
    }

    function print(s: string) {
      printout.push(s);
    }

    const vm = new NativeVMFriendly(snapshot, { 0: asyncHostFunc, 1: print });

    const run = vm.resolveExport(0);

    run();

    assert.equal(printout.join('; '), 'Begin run; Before await; End run; Caught error: dummy error');
  })

  test('host-async-returning-promise', () => {
    // This function tests that if the VM calls a host async function then the
    // return value is a promise that resolves when the host calls the callback.

    const snapshot = compileJs`
      const asyncHostFunc = vmImport(0);
      const assert = vmImport(1);
      vmExport(0, run);

      function run() {
        myAsyncFunc();
      }

      async function myAsyncFunc() {
        const promise = asyncHostFunc();
        assert(promise.__proto__ === Promise.prototype);
        await dummy(); // Program needs at least one await point in order to compile async.
      }

      async function dummy() {
      }
    `
    fs.writeFileSync('test/async-host-func/output.host-async-returning-promise.disassembly', decodeSnapshot(snapshot).disassembly);

    function asyncHostFunc() {
      const callback = vm.asyncStart();
      callback(true, undefined);
    }

    let assertCount = 0;
    const vm = new NativeVMFriendly(snapshot, { 0: asyncHostFunc, 1: (x: any) => { assertCount++; assert(x) } });

    const run = vm.resolveExport(0);

    run();

    assert.equal(assertCount, 1);
  });

  test('resolving-host-promise', () => {
    // This tests the case where the host promise is not immediately resolved.

    const snapshot = compileJs`
      const asyncHostFunc = vmImport(0);
      const print = vmImport(1);
      vmExport(0, run);

      function run(useSecondAwaiter) {
        print('Start of run');
        myAsyncFunc(useSecondAwaiter);
        print('End of run');
      }

      async function myAsyncFunc(useSecondAwaiter) {
        const promise = asyncHostFunc();
        if (useSecondAwaiter) {
          anotherFunc(promise);
        }
        try {
          const value = await promise;
          print('Promise resolved');
          print(value);
        } catch (e) {
          print('Promise rejected');
          print(e);
        }
      }

      async function anotherFunc(promise) {
        try {
          const value = await promise;
          print('Promise resolved 2');
          print(value);
        } catch (e) {
          print('Promise rejected 2');
          print(e);
        }
      }
    `
    fs.writeFileSync('test/async-host-func/resolving-host-promise.disassembly', decodeSnapshot(snapshot).disassembly);

    let callback: any;
    let mode: 'immediate-resolve' | 'immediate-reject' | 'later-resolve' | 'later-reject';
    function asyncHostFunc() {
      callback = vm.asyncStart();
      if (mode === 'immediate-resolve') {
        callback(true, 42);
      } else if (mode === 'immediate-reject') {
        callback(false, 43);
      }
    }

    let printout: string[] = [];
    const vm = new NativeVMFriendly(snapshot, { 0: asyncHostFunc, 1: (msg: string) => printout.push(msg) });

    const run = vm.resolveExport(0);

    function subTest(mode_: typeof mode, exec: () => void) {
      mode = mode_;
      printout = [];
      callback = undefined;
      exec();
    }

    subTest('immediate-resolve', () => {
      run(false);
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
        'Promise resolved', 42
      ]);
    });

    subTest('immediate-reject', () => {
      run(false);
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
        'Promise rejected', 43
      ]);
    });

    subTest('later-resolve', () => {
      run(false);
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
      ]);
      callback(true, 142);
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
        'Promise resolved', 142
      ]);
    });

    subTest('later-reject', () => {
      run(false);
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
      ]);
      callback(false, 'error');
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
        'Promise rejected', 'error'
      ]);
    });

    // Resolve with 2 awaiters
    subTest('later-resolve', () => {
      run(true);
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
      ]);
      callback(true, 142);
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
        'Promise resolved 2', 142,
        'Promise resolved', 142,
      ]);
    });

    // Reject with 2 awaiters
    subTest('later-reject', () => {
      run(true);
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
      ]);
      callback(false, 'error');
      assert.deepEqual(printout, [
        'Start of run',
        'End of run',
        'Promise rejected 2', 'error',
        'Promise rejected', 'error',
      ]);
    });
  });

  test('top-level-await-not-supported', () => {
    assert.throws(() => {
      compileJs`
        await myAsyncFunc();

        async function myAsyncFunc() {
        }
      `
    }, 'Await expressions are not supported at the top level')
  });

  test('export-async-function', () => {
    // This function tests that if the VM calls a host async function then the
    // return value is a promise that resolves when the host calls the callback.

    const snapshot = compileJs`
      const asyncHostFunc = vmImport(0);
      const print = vmImport(1);
      vmExport(0, run);
      vmExport(1, isPromise);

      async function run() {
        print('before await');
        await asyncHostFunc();
        print('after await');
      }

      function isPromise(x) {
        return x.__proto__ === Promise.prototype;
      }
    `
    fs.writeFileSync('test/async-host-func/output.host-async-returning-promise.disassembly', decodeSnapshot(snapshot).disassembly);

    let callback: any;
    function asyncHostFunc() {
      callback = vm.asyncStart();
    }

    let printout: string[] = [];

    function print(s: string) {
      printout.push(s);
    }

    const vm = new NativeVMFriendly(snapshot, { 0: asyncHostFunc, 1: print });

    const run = vm.resolveExport(0);
    const isPromise = vm.resolveExport(1);

    const result = run();

    assert(isPromise(result));
    assert.deepEqual(printout, ['before await']);

    callback(true, undefined);

    assert.deepEqual(printout, ['before await', 'after await']);

    // We can't actually await the promise. There is no way to do this in
    // Microvium from the host at present.
  });
})