/*---
runExportedFunction: 0
expectedPrintout: |
  # Test 1
  0, 0
  1, 1
  2, 2
  3, 3
  4, 4
  # Test mutationOfLoopVar
  1, 0
  3, 2
  5, 4
  7, 6
  9, 8
  # Test popScope
  outer, z
  0, 0, z
  1, 1, z
  2, 2, z
  3, 3, z
  4, 4, z
  # Test testBreak
  outer, z
  0, 0, z
  1, 1, z
  2, 2, z
  # Test testNestedBreak
  outer, c
  0, 0, c, 0, 0
  0, 0, c, 1, 1
  0, 0, c
  1, 1, c, 0, 0
  1, 1, c, 1, 1
  1, 1, c
  2, 2, c, 0, 0
  2, 2, c, 1, 1
  2, 2, c
---*/

vmExport(0, run);

function run() {
  test1();
  mutationOfLoopVar();
  popScope();
  testBreak();
  testNestedBreak();
}

function test1() {
  print('# Test 1')
  const arr = [];
  for (let x = 0; x < 5; x++) {
    const y = x;
    arr.push(() => print(`${x}, ${y}`));
  }
  for (let i = 0; i < arr.length; i++) {
    arr[i]();
  }
}

function mutationOfLoopVar() {
  print('# Test mutationOfLoopVar')
  const arr = [];
  for (let x = 0; x < 10; x++) {
    const y = x;
    arr.push(() => print(`${x}, ${y}`));
    x++;
  }
  for (let i = 0; i < arr.length; i++) {
    arr[i]();
  }
}

function popScope() {
  print('# Test popScope');
  let x = 'outer';
  let z = 'z';
  const arr = [];
  for (let x = 0; x < 5; x++) {
    const y = x;
    arr.push(() => print(`${x}, ${y}, ${z}`));
  }
  // foo will be doing LoadScoped[0], so this checks that the scope after the
  // loop is correctly back to the original function scope.
  const foo = () => console.log(`${x}, ${z}`);
  foo();

  for (let i = 0; i < arr.length; i++) {
    arr[i]();
  }
}

// Similar to popScope but tests that the scope is popped when the loop breaks early
function testBreak() {
  print('# Test testBreak');
  let x = 'outer';
  let z = 'z';
  const arr = [];
  for (let x = 0; x < 5; x++) {
    const y = x;
    if (x === 3) {
      // Break early
      break;
    }
    arr.push(() => print(`${x}, ${y}, ${z}`));
  }
  // If the scope popping worked, the closure here should refer to the outer `x`
  // and `z`. If the scope popping didn't work then variables [1] and [2] here
  // will be point to the wrong place.
  const foo = () => console.log(`${x}, ${z}`);
  foo();

  for (let i = 0; i < arr.length; i++) {
    arr[i]();
  }
}

function testNestedBreak() {
  print('# Test testNestedBreak');
  let a = 'outer';
  let c = 'c';
  const arr = [];
  for (let a = 0; a < 5; a++) {
    const b = a;
    for (let d = 0; d < 5; d++) {
      const e = d;
      arr.push(() => print(`${a}, ${b}, ${c}, ${d}, ${e}`));
      if (d === 1) break;
    }
    arr.push(() => print(`${a}, ${b}, ${c}`));
    if (a === 2) break;
  }
  // If the scope popping worked, the closure here should refer to the outer `x`
  // and `z`. If the scope popping didn't work then variables [1] and [2] here
  // will be point to the wrong place.
  const foo = () => console.log(`${a}, ${c}`);
  foo();

  for (let i = 0; i < arr.length; i++) {
    arr[i]();
  }
}

// TODO: when we support `continue`, we need to make sure that it correctly pops
// and clones scopes, and deals with nesting. I haven't thought through all the
// details.

// WIP: We need a test case for a nested function under a loop, where the nested function is not a closure.

// WIP: A test case for a nested function under a loop, where the nested
// function is a closure but the loop scope is not otherwise a closure scope.
