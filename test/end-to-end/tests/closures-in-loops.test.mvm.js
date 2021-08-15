/*---
runExportedFunction: 0
expectedPrintout: |
  0, 0
  1, 1
  2, 2
  3, 3
  4, 4
  5, 5
  6, 6
  7, 7
  8, 8
  9, 9
  1, 0
  3, 2
  5, 4
  7, 6
  9, 8
---*/

vmExport(0, run);

function run() {
  test1();
  test2();
}

function test1() {
  const arr = [];
  for (let x = 0; x < 10; x++) {
    const y = x;
    arr.push(() => print(`${x}, ${y}`));
  }
  for (let i = 0; i < arr.length; i++) {
    arr[i]();
  }
}

function test2() {
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
