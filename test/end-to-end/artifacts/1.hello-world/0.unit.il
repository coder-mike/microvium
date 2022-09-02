unit ['./test/end-to-end/tests/1.hello-world.test.mvm.js'];

entry ['#entry'];

external print from free-variable 'print';
external vmExport from free-variable 'vmExport';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:1:1
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:11:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:11:1
    Literal(lit 42);                     // 4                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:11:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/1.hello-world.test.mvm.js:11:14
    Call(count 3);                       // 2                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:11:14
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:11:14
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:11:14
    Return();                            // 1                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:11:14
}

// ---
description: >
  Exports a function with ID 42 that prints "hello-world".
runExportedFunction: 42
expectedPrintout: Hello, World!
---
function run() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:8:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:8:3
    Literal(lit 'Hello, World!');        // 3                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:8:9
    Call(count 2);                       // 1                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:8:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:8:9
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:9:2
    Return();                            // 0                 ./test/end-to-end/tests/1.hello-world.test.mvm.js:9:2
}