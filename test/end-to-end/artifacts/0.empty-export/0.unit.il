unit ['./test/end-to-end/tests/0.empty-export.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:1:1
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:8:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:8:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:8:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/0.empty-export.test.mvm.js:8:13
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:8:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:8:13
    Return();                            // 1                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:8:13
}

// ---
runExportedFunction: 0
description: Tests that an empty function can be exported and run
---
function run() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:6:2
    Return();                            // 0                 ./test/end-to-end/tests/0.empty-export.test.mvm.js:6:2
}