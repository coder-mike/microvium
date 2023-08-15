/*---
runExportedFunction: 0
description: Tests async-await functionality with promises
assertionCount: 31
isAsync: true
testOnly: false
skip: false
---*/
vmExport(0, run);

class Error { constructor(message) { this.message = message; } }

function run() {
  // Void-call async function
  runAsync();
}

async function runAsync() {
  try {
    test_asyncReturnsPromise();
    test_promiseKeys();
    await test_promiseAwait();
    await test_promiseAwaitReject();
    await test_awaitMustBeAsynchronous();
    await test_promiseConstructor();
    await test_unresolvedPromise1Subscriber();
    await test_unresolvedPromise2Subscribers();
    await test_unresolvedPromise3Subscribers();
    await test_awaitBeforeAndAfterResolved();
    await test_awaitUnrejected();
    await test_immediatelyRejectedPromise();
    await test_augmentingPromisePrototype();

    asyncTestComplete(true, undefined);
  } catch (e) {
    asyncTestComplete(false, e);
  }
}

function test_asyncReturnsPromise() {
  const promise = myAsyncFunc();
  assert(promise.__proto__ === Promise.prototype);
}

async function myAsyncFunc() {
  return 42;
}

async function test_promiseKeys() {
  const promise = myAsyncFunc();
  const keys = Reflect.ownKeys(promise);
  // Even though the promise has 2 internal slots, which occupy the first
  // key-value pair slot, it should still have no own properties since the
  // the key used for internal slots is not a valid property key.
  assertEqual(keys.length, 0);

  // Reflect.ownKeys is ignoring the internal slots but should not ignore the
  // properties that follow the internal slots
  promise.prop = 5;
  const keys2 = Reflect.ownKeys(promise);
  assertEqual(keys2.length, 1);
  assertEqual(keys2[0], 'prop');
}

async function test_promiseAwait() {
  const promise = myAsyncFunc();
  const result = await promise;
  assertEqual(result, 42);
}

async function test_promiseAwaitReject() {
  const promise = myAsyncFuncReject();
  try {
    await promise;
    assert(false, 'promise should have rejected');
  } catch (e) {
    assertEqual(e.message, '42');
  }
}

async function myAsyncFuncReject() {
  throw new Error('42');
}

async function test_awaitMustBeAsynchronous() {
  let s = 'Start';
  const promise = inner(); // No await - should not block
  s += '; After inner()';
  await promise;
  // The key here is that "After inner" should come before "After await",
  // because even though myAsyncFunc resolves immediately, the continuation
  // should be scheduled asynchronously.
  assertEqual(s, 'Start; Before await; After inner(); After await');

  async function inner() {
    const promise = myAsyncFunc();
    s += '; Before await';
    await promise;
    s += '; After await';
  }
}

async function test_promiseConstructor() {
  const promise = new Promise((resolve, reject) => {
    resolve(42);
  });
  const result = await promise;
  assertEqual(result, 42);
}

async function test_unresolvedPromise1Subscriber() {
  let s = 'Start';
  let resolve;
  const promise = new Promise(r => resolve = r);
  const p1 = subscriber1(promise);

  assertEqual(s, 'Start; Subscriber 1 started');
  resolve(42);
  await p1;
  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 1 finished with 42');

  async function subscriber1(promise) {
    s += '; Subscriber 1 started';
    const result = await promise;
    s += '; Subscriber 1 finished with ' + result;
  }
}


async function test_unresolvedPromise2Subscribers() {
  // The second subscriber triggers a code path where the subscriber list is
  // promoted from a closure to a list.

  let s = 'Start';
  let resolve;
  const promise = new Promise(r => resolve = r);
  const p1 = subscriber1(promise);
  const p2 = subscriber2(promise);

  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 2 started');
  resolve(42);
  await p1;
  await p2;
  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 1 finished with 42; Subscriber 2 finished with 42');

  async function subscriber1(promise) {
    s += '; Subscriber 1 started';
    const result = await promise;
    s += '; Subscriber 1 finished with ' + result;
  }

  async function subscriber2(promise) {
    s += '; Subscriber 2 started';
    const result = await promise;
    s += '; Subscriber 2 finished with ' + result;
  }
}

async function test_unresolvedPromise3Subscribers() {
  // Same as previous test but the subscriber list is already a list when
  // subscriber 3 is added.

  let s = 'Start';
  let resolve;
  const promise = new Promise(r => resolve = r);
  const p1 = subscriber1(promise);
  const p2 = subscriber2(promise);
  const p3 = subscriber3(promise);

  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 3 started');
  resolve({ message: 'Hi' });
  await p1;
  await p2;
  await p3;
  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 3 started; Subscriber 1 finished with Hi; Subscriber 2 finished with Hi; Subscriber 3 finished with Hi');

  async function subscriber1(promise) {
    s += '; Subscriber 1 started';
    const result = await promise;
    s += '; Subscriber 1 finished with ' + result.message;
  }

  async function subscriber2(promise) {
    s += '; Subscriber 2 started';
    const result = await promise;
    s += '; Subscriber 2 finished with ' + result.message;
  }

  async function subscriber3(promise) {
    s += '; Subscriber 3 started';
    const result = await promise;
    s += '; Subscriber 3 finished with ' + result.message;
  }
}

async function test_awaitBeforeAndAfterResolved() {
  // The second subscriber only subscribes after the first promise has already
  // transitioned to resolved.

  let s = 'Start';
  let resolve;
  const promise = new Promise(r => resolve = r);
  const p1 = subscriber1(promise);

  assertEqual(s, 'Start; Subscriber 1 started');
  resolve([42]);
  assertEqual(s, 'Start; Subscriber 1 started');

  await p1;
  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 1 finished with 42');

  const p2 = subscriber2(promise);
  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 1 finished with 42; Subscriber 2 started');
  await p2;
  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 1 finished with 42; Subscriber 2 started; Subscriber 2 finished with 42');

  async function subscriber1(promise) {
    s += '; Subscriber 1 started';
    const result = await promise;
    s += '; Subscriber 1 finished with ' + result[0];
  }

  async function subscriber2(promise) {
    s += '; Subscriber 2 started';
    const result = await promise;
    s += '; Subscriber 2 finished with ' + result[0];
  }
}

async function test_awaitUnrejected() {
  let s = 'Start';
  let reject;
  const promise = new Promise((_,r) => reject = r);
  const p1 = subscriber1(promise);

  assertEqual(s, 'Start; Subscriber 1 started');
  reject(new Error('dummy error'));
  await p1;
  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 1 rejected with dummy error');

  async function subscriber1(promise) {
    s += '; Subscriber 1 started';
    try {
      await promise;
      s += '; should not get here';
    } catch (e) {
      s += `; Subscriber 1 rejected with ${e.message}`;
    }
  }
}

async function test_immediatelyRejectedPromise() {
  let s = 'Start';
  const promise = new Promise((_, reject) => reject(new Error('dummy error')));
  const p1 = subscriber1(promise);

  assertEqual(s, 'Start; Subscriber 1 started');
  await p1;
  assertEqual(s, 'Start; Subscriber 1 started; Subscriber 1 rejected with dummy error');

  async function subscriber1(promise) {
    s += '; Subscriber 1 started';
    try {
      await promise;
      s += '; should not get here';
    } catch (e) {
      s += `; Subscriber 1 rejected with ${e.message}`;
    }
  }
}

async function test_augmentingPromisePrototype() {
  Promise.prototype.x = 5;
  Promise.prototype.f = function() { return this.x; }
  const promise = new Promise((_, reject) => reject(new Error('dummy error')));
  const p1 = myAsync();

  assertEqual(promise.x, 5);
  assertEqual(promise.f(), 5);
  assertEqual(p1.x, 5);
  assertEqual(p1.f(), 5);
  await p1;
  assertEqual(p1.x, 5);
  assertEqual(p1.f(), 5);
  p1.x = 10;
  assertEqual(promise.x, 5);
  assertEqual(p1.f(), 10);

  async function myAsync() {
  }
}

// TODO: Top-level await -- what happens?

// TODO: Export async function - I think it should just work but return a promise.

// TODO: Await over snapshot

// TODO: Test encoding and decoding of an async function where the entry point
// is only reachable through the continuation (i.e. a partially executed async
// function where the original function is not reachable anymore but the
// continuation is). This can probably be achieved by using `vmExport` on the
// result of `mvm_asyncStart`.

// TODO: Run tests without safe mode

// TODO: Update documentation with promise design and AsyncComplete

// TODO: Documentation on how to use async-await

// TODO: Bump the version numbers, since we have new builtins and operations