/*---
runExportedFunction: 0
assertionCount: 4
testOnly: true
---*/
function run() {
  const incrementor1 = makeIncrementor();
  const incrementor2 = makeIncrementor();
  assertEqual(incrementor1(), 1);
  assertEqual(incrementor1(), 2);
  assertEqual(incrementor2(), 1);
  assertEqual(incrementor2(), 2);
}

function makeIncrementor() {
  let x = 0;
  return () => x++;
}

// TODO: Nested function declarations
// TODO: Double-nested functions
// TODO: Nested lexical scopes
// TODO: Nested closure scopes
// TODO: Capturing parameters
// TODO: Scope elision
// TODO: Closure equality and conversions
// TODO: This-capturing (including with non-closures)

vmExport(0, run);