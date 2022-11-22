/*---
description: https://github.com/coder-mike/microvium/issues/48
runExportedFunction: 0
assertionCount: 5
---*/

let log = [];
console.log = msg => log.push(msg)

function run() {
  sayHello();

  assertEqual(log.length, 6);
  assertEqual(log[0], 1);
  assertEqual(log[2], 3);
  assertEqual(log[3], 1);
  assertEqual(log[5], 3);

  log = [];
}

function sayHello() {
  var arr = [1, 2, 3];
  for (var i = 0; i < 3; ++i) {
    console.log(arr[i]);
  }
  for (var i = 0; i < 3; ++i) {
    console.log(arr[i]);
  }
}


vmExport(0,run);