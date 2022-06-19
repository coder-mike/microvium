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
  test_throwUnwinding();
  test_normalUnwinding();
  test_throwAcrossFrames();
  test_conditionalThrow();

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

function test_conditionalThrow() {
  /*
  This test is mainly to make sure that the static analysis does not think that
  the code after the if-statement is unreachable if one of the branches is
  unreachable.
  */
  let s = '';
  for (let i = 0; i < 4; i++) {
    s += i;
    try {
      s += 'a'
      // Check throwing in the consequent branch
      if (i % 3 === 0) {
        s += 'b'
        throw 1;
      }
      s += 'c'
      // Check throwing in the alternate branch
      if (i % 3 !== 1) {
        s += 'd'
      }
      else {
        s += 'e'
        throw 2;
      }
      // The static analysis needs to
      s += 'f'
    } catch {
      s += 'g';
    }
    s += 'h'
  }

  assertEqual(s, '0abgh1acegh2acdfh3abgh');
}


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


