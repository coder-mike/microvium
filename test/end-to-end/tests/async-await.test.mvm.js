/*---
runExportedFunction: 0
description: Tests async-await functionality
assertionCount: 39
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
    await test_asyncInExpression();
    await test_asyncFunctionArguments();
    await test_asyncThisArgument();
    await test_asyncArrowFunctions();
    await test_implicitReturn();
    await test_asyncClosure();
    await test_syncClosureInAsync();
    await test_exceptionsBasic();
    await test_exceptionsNested();
    await test_multipleJobs();
    await test_nestedClosure();
    await test_awaitInsideCatch();

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

async function test_asyncInExpression() {
  // Here the array literal is a temporary pushed to the stack and then each
  // element is awaited in turn. This tests that the temporary is correctly
  // restored after each await point.
  const x = [
    3,
    await nestedFunc(),
    await nestedFunc2(),
    11,
  ];

  assertEqual(x.length, 4);
  assertEqual(x[0], 3);
  assertEqual(x[1], 5);
  assertEqual(x[2], 7);
  assertEqual(x[3], 11);

  // Similarly here the function call involves pushing the arguments to the
  // stack as temporaries, so this tests that the stack is correctly restored
  // after each await point.
  const y = await nestedFunc3(3, await nestedFunc(), await nestedFunc2(), 11);
  assertEqual(y, 26);

  async function nestedFunc() {
    return 5;
  }

  async function nestedFunc2() {
    return 7;
  }

  async function nestedFunc3(a, b, c, d) {
    return a + b + c + d;
  }
}

async function test_asyncFunctionArguments() {
  // This function tests that function arguments are correctly captured by
  // async functions.
  await nestedFunc(3, 5, 7);

  async function nestedFunc(a, b, c) {
    assertEqual(a, 3);
    assertEqual(b, 5);
    assertEqual(c, 7);
    await nestedFunc2();
    assertEqual(a, 3);
    assertEqual(b, 5);
    assertEqual(c, 7);
  }

  async function nestedFunc2() {
  }
}

async function test_asyncThisArgument() {
  const obj = {
    a: 3,
    b: 5,
    nestedFunc,
  }
  // This function tests that function arguments are correctly captured by
  // async functions.
  await obj.nestedFunc(7);

  async function nestedFunc(c) {
    assertEqual(this.a, 3);
    assertEqual(this.b, 5);
    assertEqual(c, 7);
    await nestedFunc2();
    assertEqual(this.a, 3);
    assertEqual(this.b, 5);
    assertEqual(c, 7);
  }

  async function nestedFunc2() {
  }
}

async function test_asyncArrowFunctions() {
  let c = 4;
  const func = async (a, b) => {
    await nestedFunc();
    return a + b + c;
  }

  const result = await func(1, 2);
  assertEqual(result, 7);

  async function nestedFunc() {
  }
}

async function test_implicitReturn() {
  const result1 = await implicitReturn1();
  const result2 = await explicitReturn1();
  const result3 = await implicitReturn2();
  const result4 = await explicitReturn2();
  assertEqual(result1, undefined);
  assertEqual(result2, 1);
  assertEqual(result3, undefined);
  assertEqual(result4, 2);

  async function implicitReturn1() {
  }

  async function explicitReturn1() {
    return 1;
  }

  async function implicitReturn2() {
    await nestedFunc();
  }

  async function explicitReturn2() {
    await nestedFunc();
    return 2;
  }

  async function nestedFunc() {
  }
}

async function test_asyncClosure() {
  let c = 4;
  const obj = {
    d: 5,
    method,
  }

  function method() {
    // captures c and `this`.
    return async (a, b) => {
      let e = 6;
      await nestedFunc();
      return a + b + c + this.d + e;
    }
  }

  const result = await obj.method()(1, 2);
  assertEqual(result, 18);

  async function nestedFunc() {
  }
}

async function test_syncClosureInAsync() {
  // Among other things, this tests that the `return` statement in the closure
  // isn't picked up as an async-return, even though it's lexically inside an
  // async function.

  let c = 4;
  const obj = {
    d: 5,
    method,
  }

  function method() {
    // captures c and `this`.
    return (a, b) => {
      let e = 6;
      return a + b + c + this.d + e;
    }
  }

  assertEqual(obj.method()(1, 2), 18);
  const f = obj.method();
  await nestedFunc();
  assertEqual(obj.method()(1, 2), 18);
  assertEqual(f(1, 3), 19);

  async function nestedFunc() {
  }
}

async function test_exceptionsBasic() {
  try {
    await nestedFunc();
    assert(false);
  } catch (e) {
    assertEqual(e, 5);
  }

  async function nestedFunc() {
    throw 5;
  }
}

async function test_exceptionsNested() {
  let x = 2;
  try {
    let y = 3;
    try {
      x *= y;
      x *= await nestedFunc();
    } catch (e) {
      x *= e;
      x *= y; // Check that y is intact on the stack between the 2 catch blocks.
      // This throw should be caught by the outer catch block if the catch stack
      // is correctly restored.
      throw 7;
    }
  } catch (e) {
    x *= e;
  }
  assertEqual(x, 630);

  async function nestedFunc() {
    try {
      await nestedFunc2();
      // This time trying throw after await
      throw 5;
    } catch (e) {
      throw e;
    }
  }

  async function nestedFunc2() {
  }
}

async function test_multipleJobs() {
  // This function tests the engine can handle multiple jobs in the job queue
  // simultaneously.

  // nestedFunc completes immediately which should schedule the caller to
  // continue in the job queue. So `task1` will put one job in the queue, and
  // `task2` will put another. Then the parent waits for the job queue to flush
  // and checks the result.

  let s = 'Start';

  task1();
  task2();

  s += ';End';

  await nestedFunc(); // Wait for job queue

  assertEqual(s, 'Start;End;Job1;Job2');

  async function task1() {
    await nestedFunc();
    s += ';Job1';
  }
  async function task2() {
    await nestedFunc();
    s += ';Job2';
  }
  async function nestedFunc() {
  }
}

async function test_nestedClosure() {
  // This tests that the parent references in async closures are correct, and
  // the static analysis properly indexes the variables.

  let x = 0;
  await func1();
  assertEqual(x, 8);

  async function func1() {
    await func2();
    await nestedFunc();
    await func2();
    async function func2() {
      await func3();
      await nestedFunc();
      await func3();

      async function func3() {
        x++;
        await nestedFunc();
        x++;
      }
    }
  }

  async function nestedFunc() {
  }
}

async function test_awaitInsideCatch() {
  try {
    try {
      await nestedFunc();
      assert(false); // Should not get here
    } catch (e) {
      assertEqual(e, 5);
      // Await fail
      await nestedFunc2();
    }
  } catch (e) {
    assertEqual(e, 6);
    // Await success
    await nestedFunc3();
    assertEqual(e, 6);
  }

  async function nestedFunc() {
    throw 5;
  }

  async function nestedFunc2() {
    throw 6;
  }

  async function nestedFunc3() {
  }
}




// TODO: await inside catch block

// TODO: Top-level await -- what happens?

// TODO: Check all the code coverage points for async are hit in the tests.

// TODO: await over snapshot (requires promise support because CTVM doesn't have `vm.startAsync`)

// TODO: test encoding and decoding of an async function where the entry point
// is only reachable through the continuation (i.e. a partially executed async
// function where the original function is not reachable anymore but the
// continuation is). This can probably be achieved by using `vmExport` on the
// result of `mvm_asyncStart`.
