/*---
runExportedFunction: 0
assertionCount: 8
---*/

vmExport(0, run);

function run() {
  const incrementor1 = makeIncrementorA();
  const incrementor2 = makeIncrementorA();
  assertEqual(incrementor1(), 1);
  assertEqual(incrementor1(), 2);
  assertEqual(incrementor2(), 1);
  assertEqual(incrementor2(), 2);

  const incrementor3 = makeIncrementorA2();
  assertEqual(incrementor3(), 1);
  assertEqual(incrementor3(), 2);

  const incrementor4 = makeIncrementorB();
  assertEqual(incrementor4(), 1);
  assertEqual(incrementor4(), 2);
}

function makeIncrementorA() {
  let x = 0;
  // Arrow function
  return () => ++x;
}

function makeIncrementorA2() {
  let x = 0;
  // Function expression (note that we do not support named function expressions, yet)
  return function() { return ++x; }
}

function makeIncrementorB() {
  let x = 0;
  return increment;
  // Function declaration
  function increment() {
    return ++x;
  }
}

// TODO: Function expression (not arrow)
// TODO: Nested function declarations
// TODO: Double-nested functions and marking intermediate functions
// TODO: Nested lexical scopes
// TODO: Nested closure scopes
// TODO: Capturing parameters
// TODO: Unused parameters
// TODO: Scope elision
// TODO: Closure equality and conversions
// TODO: This-capturing (arrow functions and normal declarations; used and unused; grandchild)
// TODO: TDZ
// TODO: Closures capturing block-scoped variables at the root level
// TODO: function declarations nested in blocks
// TODO: all the same "closure" tests but for module-scoped variables
// TODO: local variables in module entry function

// TODO: I'm thinking that it would be easy to lexically determine if a
// parameter is ever assigned to, and so whether it needs a local variable copy
// or not. When param bindings are first discovered, they can be marked as
// notWrittenTo, until an assignment operation is discovered that targets it.

// TODO: TDZ tests
