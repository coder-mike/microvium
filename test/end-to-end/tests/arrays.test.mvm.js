/*---
description: >
  Testing basic array operations
runExportedFunction: 0
assertionCount: 104
---*/

let a;
let b;
let c;
let d;

init();
vmExport(0, run);

function run() {
  // Run the test twice. Particularly, when running after a snapshot
  // restoration, the first time will be running against the arrays in the
  // snapshot, while the second time will be running against newly-allocated
  // arrays.
  testArrays();
  testArrays();
}

function init() {
  a = [];
  b = [1, 2, 3];
  c = [1, , 3, ,];
  d = [
    [
      [
        1,
        2,
      ],
      [
        3,
        4,
      ],
      5,
    ],
    6,
  ];
}

function testArrays() {
  assertEqual(a.length, 0);
  assertEqual(a[0], undefined);

  assertEqual(b.length, 3);
  assertEqual(b[0], 1);
  assertEqual(b[1], 2);
  assertEqual(b[2], 3);
  assertEqual(b[3], undefined);

  // Mutation
  b[1] = 24;
  assertEqual(b[1], 24);

  // Extend the array
  b[4] = 5;
  assertEqual(b.length, 5);
  assertEqual(b[0], 1);
  assertEqual(b[3], undefined);
  assertEqual(b[4], 5);
  assertEqual(b[5], undefined);

  // Write to a hole
  b[3] = 4;
  assertEqual(b[0], 1);
  assertEqual(b[3], 4);
  assertEqual(b[4], 5);

  // Shorten the array
  b.length = 3;
  assertEqual(b.length, 3);
  assertEqual(b[0], 1);
  assertEqual(b[2], 3);
  assertEqual(b[3], undefined);

  // Make the array longer by setting the length (this is likely not to increase
  // the _capacity_ of the array, since the capacity is probably still large
  // from earlier, so this tests that making the array shorter and then longer
  // does not expose stale values)
  b.length = 5;
  assertEqual(b[0], 1);
  assertEqual(b[2], 3);
  assertEqual(b[3], undefined);
  assertEqual(b[4], undefined);

  // Make the array longer by setting the length, but to a value that exceeds the original capacity
  b.length = 8;
  b[7] = 8;
  assertEqual(b[0], 1);
  assertEqual(b[2], 3);
  assertEqual(b[4], undefined);
  assertEqual(b[7], 8);
  assertEqual(b[8], undefined);

  // Grow an empty array (`a` is an empty array so far)
  a[0] = 10;
  a[1] = 20;
  assertEqual(a.length, 2);
  assertEqual(a[0], 10);
  assertEqual(a[1], 20);
  assertEqual(a[2], undefined);

  // Test elision
  assertEqual(c.length, 4); // Length is 4, even though it ends in a hole
  assertEqual(c[0], 1);
  assertEqual(c[1], undefined);
  assertEqual(c[2], 3);
  assertEqual(c[3], undefined);

  // Test Array.push
  assert(a.__proto__ !== null);
  assert(a.__proto__.push !== undefined);
  assert(a.push !== undefined);
  a.push(30);
  assertEqual(a.length, 3);
  assertEqual(a[2], 30);

  // See that the nested arrays are correct
  assertEqual(d.length, 2);
  assertEqual(d[0].length, 3);
  assertEqual(d[0][0].length, 2);
  assertEqual(d[0][0][0], 1);
  assertEqual(d[0][0][1], 2);
  assertEqual(d[0][1][0], 3);
  assertEqual(d[0][1][1], 4);
  assertEqual(d[0][2], 5);
  assertEqual(d[1], 6);

  // Reset the arrays to their initial state, because this test runs multiple
  // times (before and after the snapshot)
  init();
}
