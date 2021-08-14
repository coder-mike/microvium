/*---
runExportedFunction: 0
testOnly: true
---*/

init();

function init() {
  let x = 1;
  vmExport(0, run);
  function run() {
    assertEqual(x, 1);
  }
}
