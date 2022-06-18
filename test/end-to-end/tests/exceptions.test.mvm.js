/*---
description: >
  Testing exceptions
runExportedFunction: 0
expectException: "My uncaught exception"
testOnly: true
expectedPrintout: |
  foo
assertionCount: 3
---*/

vmExport(0, run);

function run() {
  test_minimalTryCatch();
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
    a.push(44);
  }

  assertEqual(a.length, 2);
  assertEqual(a[0], 42);
  assertEqual(a[1], 44);
}

// TODO: Throw across function frames
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


