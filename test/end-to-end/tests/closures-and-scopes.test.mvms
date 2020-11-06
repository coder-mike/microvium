/*---
runExportedFunction: 0
expectedPrintout: |
  Hello, World!
skip: true
---*/
function run() {
  const increment = makeIncrementor(10);
  assertEqual(increment(20), 30);
}

function makeIncrementor(amount) {
  return x => x + amount;
}

// TODO: Double-nested functions
// TODO: Nested lexical scopes
// TODO: Nested closure scopes
// TODO: Closure equality and conversions
// TODO: This-capturing (including with non-closures)

vmExport(0, run);