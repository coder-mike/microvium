/*---
runExportedFunction: 0
assertionCount: 4
---*/
function run() {
  const incrementor1 = makeIncrementorA();
  const incrementor2 = makeIncrementorA();
  assertEqual(incrementor1(), 1);
  assertEqual(incrementor1(), 2);
  assertEqual(incrementor2(), 1);
  assertEqual(incrementor2(), 2);

  const incrementor3 = makeIncrementorB();
  assertEqual(incrementor3(), 1);
  assertEqual(incrementor3(), 2);
}

function makeIncrementorA() {
  let x = 0;
  // Arrow function
  return () => ++x;
}

function makeIncrementorB() {
  let x = 0;
  return increment;
  // Function declaration
  function increment() {
    return ++x;
  }
}

// TODO: Nested function declarations
// TODO: Double-nested functions
// TODO: Nested lexical scopes
// TODO: Nested closure scopes
// TODO: Capturing parameters
// TODO: Scope elision
// TODO: Closure equality and conversions
// TODO: This-capturing (including with non-closures)
// TODO: TDZ

vmExport(0, run);