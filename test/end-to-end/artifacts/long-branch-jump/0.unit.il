unit ['./test/end-to-end/tests/long-branch-jump.test.mvm.js'];

entry ['#entry'];

external print from free-variable 'print';
external vmExport from free-variable 'vmExport';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:1:1
    Nop(count 200);                      // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:26:1
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:28:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:28:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:28:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/long-branch-jump.test.mvm.js:28:13
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:28:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:28:13
    Return();                            // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:28:13
}

// ---
description: >
  Tests various branching instructions
runExportedFunction: 0
expectedPrintout: |
  #1: This is the alternate
  #2: This is the consequent
---
function run() {
  entry:
    Literal(lit false);                  // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:10:7
    Branch(@block1, @block2);            // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:10:3
  block1:
    Nop(count 200);                      // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:11:5
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:12:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:12:5
    Literal(lit '#1: This is the consequent'); // 3           ./test/end-to-end/tests/long-branch-jump.test.mvm.js:12:11
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:12:11
    Jump(@block3);                       // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:13:4
  block2:
    Nop(count 200);                      // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:14:5
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:15:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:15:5
    Literal(lit '#1: This is the alternate'); // 3            ./test/end-to-end/tests/long-branch-jump.test.mvm.js:15:11
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:15:11
    Jump(@block3);                       // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:10:3
  block3:
    Literal(lit true);                   // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:18:7
    Branch(@block4, @block5);            // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:18:3
  block4:
    Nop(count 200);                      // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:19:5
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:20:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:20:5
    Literal(lit '#2: This is the consequent'); // 3           ./test/end-to-end/tests/long-branch-jump.test.mvm.js:20:11
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:20:11
    Jump(@block6);                       // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:21:4
  block5:
    Nop(count 200);                      // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:22:5
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:23:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:23:5
    Literal(lit '#2: This is the alternate'); // 3            ./test/end-to-end/tests/long-branch-jump.test.mvm.js:23:11
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:23:11
    Jump(@block6);                       // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:18:3
  block6:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:25:2
    Return();                            // 0                 ./test/end-to-end/tests/long-branch-jump.test.mvm.js:25:2
}