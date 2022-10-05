/*---
runExportedFunction: 0
assertionCount: 8
---*/

vmExport(0, run);

function run() {
  test_basicClosureEmbedding();
  test_declarationClosureEmbedding();
}

function test_basicClosureEmbedding() {
  let x = 0;
  // increment will be embedded
  const increment = () => ++x;
  // decrement will not be embedded
  const decrement = () => --x;
  assertEqual(increment(), 1);
  assertEqual(increment(), 2);
  assertEqual(decrement(), 1);
  assertEqual(x, 1);
}

function test_declarationClosureEmbedding() {
  let x = 0;
  // increment will be embedded
  function increment() { return ++x; }
  // decrement will not be embedded
  function decrement() { return --x; }
  assertEqual(increment(), 1);
  assertEqual(increment(), 2);
  assertEqual(decrement(), 1);
  assertEqual(x, 1);
}