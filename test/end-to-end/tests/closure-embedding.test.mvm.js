/*---
runExportedFunction: 0
assertionCount: 15
---*/

vmExport(0, run);

function run() {
  test_basicClosureEmbedding();
  test_declarationClosureEmbedding();
  test_loop1();
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

function test_loop1() {
  let x = 0;
  const arr = [];
  for (let i = 0; i < 10; i++) {
    // Will be embedded into the loop
    arr.push(() => ++x);
    // Will not be embedded
    arr.push(() => x + 3);
  }
  // Will be embedded into the outer scope
  const other = () => --x;
  // Will not be embedded
  const other2 = () => --x;
  assertEqual(arr.length, 20);
  assertEqual(arr[0](), 1);
  assertEqual(arr[0](), 2);
  assertEqual(arr[1](), 5);
  assertEqual(other(), 1);
  assertEqual(other2(), 0);
  assertEqual(x, 0);
}

// WIP: do we have a test case somewhere for unwinding the closure stack when an exception is thrown?