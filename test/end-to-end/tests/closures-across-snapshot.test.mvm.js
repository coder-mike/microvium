/*---
runExportedFunction: 0
---*/

init();

function init() {
  let x = 1;
  vmExport(0, run);
  function run() {
    assertEqual(x, 1);
  }
}
