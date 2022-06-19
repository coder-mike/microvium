/*---
description: >
  Testing exceptions
runExportedFunction: 0
expectException: "My uncaught exception"
testOnly: false
expectedPrintout: foo
assertionCount: 3
---*/

vmExport(0, run);

function run() {
  test_minimalTryCatch();
  test_catchWithoutThrow();
  test_throwUnwinding();

  test_uncaughtException(); // Last test because it throws without catching
}

function test_uncaughtException() {
  print('foo'); // Should print
  throw "My uncaught exception"
  print('bar'); // Should not print
}

function test_minimalTryCatch() {
  let a = '';
  try {
    a += 'a';
    throw 'boo!'
    a += 'b';
  } catch {
    // (Entry into the catch should pop the exception since it's unused)
    a += 'c';
  }

  assertEqual(a, 'ac');
}

function test_catchWithoutThrow() {
  /*
  When an exception isn't thrown, the try block epilog needs to correctly unwind with `EndTry`
  */

  let a = '';
  try {
    a += 'a';
    a += 'b';
  } catch {
    a += 'c';
  }

  assertEqual(a, 'ab');
}

function test_throwUnwinding() {
  let a = '';
  try {
    a += 'a';
    try {
      a += 'b';
      throw 1;
      a += 'c';
    } catch {
      a += 'd';
    }
    a += 'e';
    // The above `try` and corresponding `throw 1` should push and pop the
    // exception stack respectively. The following `throw` then checks that
    // we're using the popped catch target (g) and not the original (d).
    throw 2;
    a += 'f';
  } catch {
    a += 'g';
  }

  assertEqual(a, 'abdeg');
}

// TODO: Throw across function frames
// TODO: Catch without throw
// TODO: Check block ordering
// TODO: Conditional throw
// TODO: Basic catch block
// TODO: Binding the exception to a variable
// TODO: Variables in catch block
// TODO: Rethrowing to nested catch
// TODO: Closure variables in catch block
// TODO: Break inside try
// TODO: Break inside catch
// TODO: Break inside double catch
// TODO: return inside try
// TODO: return inside nested try
// TODO: return inside catch
// TODO: return inside nested catch


