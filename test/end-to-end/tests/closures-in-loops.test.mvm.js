/*---
runExportedFunction: 0
skip: true
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
#  # Test break
#  outer, z
#  0, 0, z
#  1, 1, z
#  2, 2, z
---*/

vmExport(0, run);

function run() {
  test1();
  mutationOfLoopVar();
  popScope();
  // testBreak();
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

// // Similar to popScope but tests that the scope is popped when the loop breaks early
// function testBreak() {
//   print('# Test testBreak');
//   let x = 'outer';
//   let z = 'z';
//   const arr = [];
//   for (let x = 0; x < 5; x++) {
//     const y = x;
//     // Break early
//     if (x === 3) break;
//     arr.push(() => print(`${x}, ${y}, ${z}`));
//   }
//   const foo = () => console.log(`${x}, ${z}`);
//   foo();

//   for (let i = 0; i < arr.length; i++) {
//     arr[i]();
//   }
// }

// WIP break and continue
// WIP break and continue where inner variables are also closed over. And various combinations of these.
// WIP block nested in loop
// WIP test that closure scopes are popped properly