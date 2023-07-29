/*---
runExportedFunction: 0
description: Tests async-await functionality
assertionCount: 5
isAsync: true
# testOnly: true
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
  try {
    test_minimal();
    await test_awaitReturnValue();
    await test_asyncVariablesFromNested();
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

async function test_asyncVariablesFromNested() {
  // This function tests that variables in an async function can be accessed
  // correctly from a nested closure.

  // Variable in root
  let x1 = 2; // closure-accessed
  let x2 = 3; // local-accessed
  try {
    // Variable nested in try block.
    let y1 = 5; // closure-accessed
    let y2 = 7; // local accessed

    await nestedFunc();

    x1 *= 11;
    y1 *= 11;
    x2 *= 11;
    y2 *= 11;

    assertEqual(y1, 12155);
    assertEqual(y2, 77);

    async function nestedFunc() {
      x1 *= 13;
      y1 *= 13;
      await nested2();
      x1 *= 17;
      y1 *= 17;
    }
  } catch {
    x1 = 0;
    x2 = 0;
  }

  assertEqual(x1, 92378);
  assertEqual(x2, 33);

  async function nested2() {
    x1 *= 19;
  }
}



// TODO: Really the API-accessible startAsync should return a wrapper that
// checks the arguments and schedules the job on the queue. It can re-use the
// async completion function to schedule the job.

// TODO: Host calls callback multiple times

// TODO: await in expression

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


// TODO: await over snapshot (requires promise support because CTVM doesn't have `vm.startAsync`)

// TODO: Test with extra memory checks enabled

// TODO: Check that errors are thrown to the right catch block if a throw follows a resume.

// TODO: await inside catch block