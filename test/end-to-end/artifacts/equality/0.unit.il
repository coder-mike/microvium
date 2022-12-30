unit ['./test/end-to-end/tests/equality.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assert from free-variable 'assert';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/equality.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/equality.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/equality.test.mvm.js:1:1
    // ---
    // description: >
    // Testing equality and inequality operators
    // runExportedFunction: 0
    // assertionCount: 2
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/equality.test.mvm.js:8:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/equality.test.mvm.js:8:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/equality.test.mvm.js:8:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/equality.test.mvm.js:8:13
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/equality.test.mvm.js:8:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/equality.test.mvm.js:10:1
    Return();                            // 1                 ./test/end-to-end/tests/equality.test.mvm.js:10:1
}

function run() {
  entry:
    // TODO: Flesh out these tests
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/equality.test.mvm.js:12:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/equality.test.mvm.js:12:3
    Literal(lit 'ab');                   // 3                 ./test/end-to-end/tests/equality.test.mvm.js:12:10
    Literal(lit 'a');                    // 4                 ./test/end-to-end/tests/equality.test.mvm.js:12:19
    Literal(lit 'b');                    // 5                 ./test/end-to-end/tests/equality.test.mvm.js:12:25
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/equality.test.mvm.js:12:25
    BinOp(op '===');                     // 3                 ./test/end-to-end/tests/equality.test.mvm.js:12:25
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/equality.test.mvm.js:12:25
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/equality.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/equality.test.mvm.js:13:3
    Literal(lit 'ab');                   // 3                 ./test/end-to-end/tests/equality.test.mvm.js:13:10
    Literal(lit 'a');                    // 4                 ./test/end-to-end/tests/equality.test.mvm.js:13:19
    Literal(lit 'c');                    // 5                 ./test/end-to-end/tests/equality.test.mvm.js:13:25
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/equality.test.mvm.js:13:25
    BinOp(op '!==');                     // 3                 ./test/end-to-end/tests/equality.test.mvm.js:13:25
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/equality.test.mvm.js:13:25
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/equality.test.mvm.js:14:2
    Return();                            // 0                 ./test/end-to-end/tests/equality.test.mvm.js:14:2
}