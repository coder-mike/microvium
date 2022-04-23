/*---
description: >
  Testing equality and inequality operators
runExportedFunction: 0
assertionCount: 2
---*/

vmExport(0, run);

function run() {
  // TODO: Flesh out these tests
  assert('ab' === 'a' + 'b');
  assert('ab' !== 'a' + 'c');
}