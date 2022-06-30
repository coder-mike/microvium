/*---
description: >
  Tests Reflect.ownKeys
runExportedFunction: 0
assertionCount: 9
---*/

const objBeforeSnapshot = {
  x: 5,
  y: 10,
};

const keysBeforeSnapshot = Reflect.ownKeys(objBeforeSnapshot)


function run() {
  assertEqual(keysBeforeSnapshot.length, 2);
  assertEqual(keysBeforeSnapshot[0], 'x');
  assertEqual(keysBeforeSnapshot[1], 'y');

  const keysAfterSnapshot = Reflect.ownKeys(objBeforeSnapshot)
  assertEqual(keysAfterSnapshot.length, 2);
  assertEqual(keysAfterSnapshot[0], 'x');
  assertEqual(keysAfterSnapshot[1], 'y');

  const objAfterSnapshot = {
    a: 5,
    b: 10,
  };

  const keysAfterSnapshot2 = Reflect.ownKeys(objAfterSnapshot)
  assertEqual(keysAfterSnapshot2.length, 2);
  assertEqual(keysAfterSnapshot2[0], 'a');
  assertEqual(keysAfterSnapshot2[1], 'b');
}

vmExport(0, run);