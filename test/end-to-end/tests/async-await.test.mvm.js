/*---
runExportedFunction: 0
description: Tests that an empty function can be exported and run
assertionCount: 0
expectedPrintout: |
  Before async function
  Inside async function
  After async synchronous return
---*/
vmExport(0, run);

function run() {
  test_minimal();
}

/**
 * Void-calling async function with no await points or variable bindings
 */
function test_minimal() {
  // Void-calling async func (does not require promise support or job queue support)
  print('Before async function');
  myAsyncFunc();
  print('After async synchronous return');
}

async function myAsyncFunc() {
  print('Inside async function');
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