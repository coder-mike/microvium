/*---
description: >
  Testing exceptions
runExportedFunction: 0
expectException: "My uncaught exception"
testOnly: false
expectedPrintout: foo
assertionCount: 6
---*/

vmExport(0, run);

function run() {
  test_minimalTryCatch();
  test_catchWithoutThrow();
  test_uncaughtException();
}

function test_uncaughtException() {
  print('foo'); // Should print
  throw "My uncaught exception"
  print('bar'); // Should not print
}

function test_minimalTryCatch() {
  const a = [];
  try {
    a.push(42);
    throw 'boo!'
    a.push(43);
  } catch {
    // (Entry into the catch should pop the exception since it's unused)
    a.push(44);
  }

  assertEqual(a.length, 2);
  assertEqual(a[0], 42);
  assertEqual(a[1], 44);
}

function test_catchWithoutThrow() {
  /*
  When an exception isn't thrown, the try block epilog needs to correctly unwind with `EndTry`
  */

  const a = [];
  try {
    a.push(42);
    a.push(43);
  } catch {
    a.push(44);
  }

  assertEqual(a.length, 2);
  assertEqual(a[0], 42);
  assertEqual(a[1], 43);
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


