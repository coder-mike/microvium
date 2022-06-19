/*---
description: >
  Testing exceptions
runExportedFunction: 0
expectException: "My uncaught exception"
testOnly: false
expectedPrintout: foo
assertionCount: 5
---*/

vmExport(0, run);

function run() {
  test_minimalTryCatch();
  test_catchWithoutThrow();
  test_throwUnwinding();
  test_normalUnwinding();
  test_throwAcrossFrames();

  test_uncaughtException(); // Last test because it throws without catching
}

function test_uncaughtException() {
  print('foo'); // Should print
  throw "My uncaught exception"
  print('bar'); // Should not print
}

function test_minimalTryCatch() {
  let s = '';
  // The try will emit the instruction `StartTry` to push to the exception stack
  try {
    s += 'a';
    // The throw will emit the `Throw` instruction which should unwind the stack
    // and jump to the catch block.
    throw 'boo!'
    s += 'b';
  } catch {
    // (Entry into the catch should pop the exception since it's unused)
    s += 'c';
  }

  assertEqual(s, 'ac');
}

function test_catchWithoutThrow() {
  /*
  When an exception isn't thrown, the try block epilog needs to correctly unwind
  with `EndTry`
  */

  let s = '';
  try {
    s += 'a';
    s += 'b';
  } catch {
    s += 'c';
  }

  assertEqual(s, 'ab');
}

function test_throwUnwinding() {
  let s = '';
  try {
    s += 'a';
    try {
      s += 'b';
      throw 1;
      s += 'c';
    } catch {
      s += 'd';
    }
    s += 'e';
    // The above `try` and corresponding `throw 1` should push and pop the
    // exception stack respectively. The following `throw` then checks that
    // we're using the popped catch target (g) and not the original (d).
    throw 2;
    s += 'f';
  } catch {
    s += 'g';
  }

  assertEqual(s, 'abdeg');
}

function test_normalUnwinding() {
  let s = '';
  try {
    s += 'a';
    try {
      s += 'b';
      s += 'c';
    } catch {
      s += 'd';
    }
    s += 'e';
    // The above `try` ends with an `EndTry` operation rather than `Throw`,
    // because it doesn't throw. The `EndTry` should pop the exception stack.
    // The following `throw` then checks that we're using the popped catch
    // target (g) and not the original (d).
    throw 2;
    s += 'f';
  } catch {
    s += 'g';
  }

  assertEqual(s, 'abceg');
}

function test_throwAcrossFrames() {
  let s = '';
  try {
    s += 'a'
    functionThatThrows()
    s += 'b'
  } catch {
    s += 'c'
  }

  assertEqual(s, 'adc');

  function functionThatThrows() {
    s += 'd'
    // The throw here should unwind the stack to get to the catch block
    throw 1;
    s += 'e'
  }
}


// TODO: Across frames with variables and closure variables
// TODO: Check arg count is restored
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
// TODO: garbage collection


