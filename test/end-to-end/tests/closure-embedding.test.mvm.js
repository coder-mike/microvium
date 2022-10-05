/*---
runExportedFunction: 0
assertionCount: 4
---*/

vmExport(0, run);

function run() {
  test_basicClosureEmbedding();
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