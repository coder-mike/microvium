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


// TODO: Basic catch block
// TODO: Throw across function frames
// TODO: Binding the exception to a variable
// TODO: Variables in catch block
// TODO: Rethrowing to nested catch
// TODO: Closure variables in catch block
// TODO: Break inside try
// TODO: Break inside catch
// TODO: Break inside double catch
// TODO: return inside try
// TODO: return inside nested try
// TODO: return inside catch
// TODO: return inside nested catch


