unit ['./test/end-to-end/tests/async-await.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external print from free-variable 'print';

global thisModule;
global test_minimal;
global myAsyncFunc;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_minimal); // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_minimal');    // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function myAsyncFunc);  // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'myAsyncFunc');     // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests that an empty function can be exported and run
    // assertionCount: 0
    // expectedPrintout: |
    // Before async function
    // Inside async function
    // After async synchronous return
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:10:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:10:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:10:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/async-await.test.mvm.js:10:13
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:10:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:26:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:26:1
}

function run() {
  entry:
    LoadGlobal(name 'test_minimal');     // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:13:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:13:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:14:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:14:2
}

// *
 * Void-calling async function with no await points or variable bindings
function test_minimal() {
  entry:
    // Void-calling async func (does not require promise support or job queue support)
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:21:3
    Literal(lit 'Before async function'); // 3                ./test/end-to-end/tests/async-await.test.mvm.js:21:9
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:21:9
    LoadGlobal(name 'myAsyncFunc');      // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:22:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:22:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:22:3
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:23:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:23:3
    Literal(lit 'After async synchronous return'); // 3       ./test/end-to-end/tests/async-await.test.mvm.js:23:9
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:23:9
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:24:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:24:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 2, true);           // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:26:1
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:27:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:27:3
    Literal(lit 'Inside async function'); // 4                ./test/end-to-end/tests/async-await.test.mvm.js:27:9
    Call(count 2, true);                 // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:27:9
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:28:2
    AsyncReturn();                       // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:28:2
}