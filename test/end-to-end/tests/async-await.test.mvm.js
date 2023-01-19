/*---
runExportedFunction: 0
description: Tests async-await functionality
assertionCount: 3
isAsync: true
---*/
vmExport(0, run);

function run() {
  // Void-call async function
  runAsync();
}

async function runAsync() {
  try {
    test_minimal();
    await test_await();
    await test_awaitHost();
    asyncTestComplete(true, undefined);
  } catch (e) {
    asyncTestComplete(false, e);
  }
}

/**
 * Void-calling async function with no await points or variable bindings
 */
function test_minimal() {
  let s = '';
  // Void-calling async func (does not require promise support or job queue support)
  s += 'Before async function';
  myAsyncFunc();
  s += '\nAfter async synchronous return';
  assertEqual(s, 'Before async function\nInside async function\nAfter async synchronous return')

  async function myAsyncFunc() {
    s += '\nInside async function';
  }
}


// Tests awaiting a JS async function which completes immediately
async function test_await() {
  const result = await asyncFunction(22);
  assertEqual(result, 23);

  async function asyncFunction(arg) {
    return arg + 1;
  }
}

// Tests awaiting a host async function
async function test_awaitHost() {
  const result = await hostAsyncFunction(5);
  assertEqual(result, 6);
}

// TODO: implicit and explicit return statements
// TODO: async function expression (and look at return statement)

// TODO: variables in async function

// TODO: async functions use the same slot number as closure embedding, so need
// to make sure that closures that would otherwise be embedded in an async
// function still work correctly.

// TODO: Test parent capturing (async function that is itself a closure)

// TODO: Top-level await

// TODO: Test that normal functions inside an async function still behave as
// expected. In particular, need to check that `return` inside a normal function
// still behaves as expected even when the normal func is inside an async func.

// TODO: exceptions

// TODO: suspending during expression

// TODO: test encoding and decoding of an async function where the entry point
// is only reachable through the continuation (i.e. a partially executed async
// function where the original function is not reachable anymore but the
// continuation is). This can probably be achieved by using `vmExport` on the
// result of `mvm_asyncStart`.

// TODO: check that catch blocks are restored properly after an await point

// TODO: Test multiple jobs in the job queue

// TODO: async function expressions
// TODO: async methods
// TODO: this bindings

