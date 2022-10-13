/*---
description: >
  Tests various object operations
runExportedFunction: 0
assertionCount: 16
---*/
// TODO: Computed properties
const objBeforeSnapshot = {
  x: 5,
  y: 10,
  f: foo
};

function run() {
  assertEqual(objBeforeSnapshot.x, 5);
  assertEqual(objBeforeSnapshot.y, 10);
  assertEqual(objBeforeSnapshot.z, undefined);

  // Method call
  assertEqual(objBeforeSnapshot.f(17), 18);

  // Set existing property on snapshotted object
  objBeforeSnapshot.x = 12;
  assertEqual(objBeforeSnapshot.x, 12);
  // Create new property on snapshotted object
  objBeforeSnapshot.z = 13;
  assertEqual(objBeforeSnapshot.z, 13);

  // New empty object
  const obj = { a: 14, b: 15, f: foo2 };
  obj.c = 16;
  assertEqual(obj.a, 14);
  assertEqual(obj.b, 15);
  assertEqual(obj.c, 16);
  assertEqual(obj.d, undefined);

  // Method call
  assertEqual(obj.f(19), 20);

  obj['n' + 'ame'] = 'obj';
  assertEqual(obj.name, 'obj');

  // The string "name1" (and "name2") doesn't occur in the source text, so it's
  // not in the intern table in the bytecode, but it still needs to be in the
  // runtime intern table.
  obj['n' + 'ame1'] = 'obj1';
  obj['n' + 'ame2'] = 'obj2';
  assertEqual(obj['n' + 'ame1'], 'obj1');
  assertEqual(obj['n' + 'ame2'], 'obj2');

}

function foo(a) {
  assertEqual(a, 17);
  return 18;
}

function foo2(a) {
  assertEqual(a, 19);
  return 20;
}

vmExport(0, run);
