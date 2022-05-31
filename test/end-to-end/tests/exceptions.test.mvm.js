/*---
description: >
  Testing exceptions
runExportedFunction: 0
expectException: "Dummy failure"
testOnly: false
expectedPrintout: |
  foo
---*/

vmExport(0, run);

function run() {
  print('foo'); // Should print
  throw "Dummy failure"
  print('bar'); // Should not print
}