/*---
runExportedFunction: 0
description: Tests async-await functionality
assertionCount: 1
isAsync: true
testOnly: true
expectedPrintout: |
  Before async function
  Inside async function
  After async synchronous return

---*/
vmExport(0, run);

function run() {
  // Void-call async function
  runAsync();
}

async function runAsync() {
  // WIP: // The static analysis doesn't reserve closure slots for the try block.
  // WIP: // The exception stack is not yet position-independent
  // WIP: // Variables should be directly accessed in the closure
  // WIP: // Test test access of async variables from a nested function
  try {
    test_minimal();
    test_awaitReturnValue(); // WIP: Add await
    //await test_awaitHost();
    asyncTestComplete(true, undefined);
  } catch (e) {
    asyncTestComplete(false, e);
  }
}

// Void-calling async function with no await points or variable bindings.
function test_minimal() {
  print('Before async function');
  // Void-calling async func. It will complete synchronously and the promise
  // will be elided because it's not used.
  myAsyncFunc();
  print('After async synchronous return');

  async function myAsyncFunc() {
    print('Inside async function');
  }
}


// Tests awaiting a JS async function which completes immediately with a return
// value. This tests basic await-call and that the return value is used
// correctly. Also the result is scheduled on the job queue.
async function test_awaitReturnValue() {
  const result = await asyncFunction(22);
  assertEqual(result, 23);

  async function asyncFunction(arg) {
    return arg + 1;
  }
}

// Tests awaiting a host async function
// async function test_awaitHost() {
//   const result = await hostAsyncFunction(5);
//   assertEqual(result, 6);
// }

// TODO: Really the API-accessible startAsync should return a wrapper that
// checks the arguments and schedules the job on the queue. It can re-use the
// async completion function to schedule the job.


// TODO: Async return value

// TODO: accessing function arguments after await

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
// TODO: test catch blocks restored correctly. including no try-catch, basic try-catch, and a variable between root and try-catch.

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

// TODO: Test closure variable access - async functions accessing parent closure, and nested functions accessing async and parent of async.


// TODO: await over snapshot

// TODO: Test with extra memory checks enabled
