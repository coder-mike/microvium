/*---
description: Testing `typeof` operator
runExportedFunction: 0
assertionCount: 12
---*/
vmExport(0, run);

function run() {
  assertEqual(typeof undefined, 'undefined')
  assertEqual(typeof 0, 'number')
  assertEqual(typeof false, 'boolean')
  assertEqual(typeof true, 'boolean')
  assertEqual(typeof "hello", 'string')
  assertEqual(typeof ('hello' + 'world'), 'string')
  assertEqual(typeof typeof 'x', 'string')
  assertEqual(typeof run, 'function')
  assertEqual(typeof null, 'object')
  assertEqual(typeof {}, 'object')
  assertEqual(typeof [], 'object')
  assertEqual(typeof (() => {}), 'function')
}