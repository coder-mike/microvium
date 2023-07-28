unit ['./test/end-to-end/tests/async-await.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external asyncTestComplete from free-variable 'asyncTestComplete';
external undefined from free-variable 'undefined';
external print from free-variable 'print';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global runAsync;
global test_minimal;
global test_awaitReturnValue;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function runAsync);     // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'runAsync');        // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_minimal); // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_minimal');    // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_awaitReturnValue); // 2        ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_awaitReturnValue'); // 1           ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality
    // assertionCount: 1
    // isAsync: true
    // # testOnly: true
    // expectedPrintout: |
    // Before async function
    // Inside async function
    // After async synchronous return
    // 
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:13:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:13:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:13:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/async-await.test.mvm.js:13:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:13:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:48:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:48:1
}

function run() {
  entry:
    // Void-call async function
    LoadGlobal(name 'runAsync');         // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:17:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:17:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:18:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:18:2
}

function runAsync() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:20:1
    StartTry(@block1);                   // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:21:7
    LoadGlobal(name 'test_minimal');     // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:22:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:22:5
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:22:5
    LoadGlobal(name 'test_awaitReturnValue'); // 6            ./test/end-to-end/tests/async-await.test.mvm.js:23:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:23:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:23:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:23:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:23:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:23:5
    // await test_awaitHost();
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:25:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:25:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:25:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:25:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:25:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:26:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:26:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await.test.mvm.js:27:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:27:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:27:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await.test.mvm.js:27:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:27:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:28:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:28:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:29:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:29:2
}

// Void-calling async function with no await points or variable bindings.
function test_minimal() {
  entry:
    Literal(lit &function myAsyncFunc);  // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:32:25
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:33:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:33:3
    Literal(lit 'Before async function'); // 4                ./test/end-to-end/tests/async-await.test.mvm.js:33:9
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:33:9
    // Void-calling async func. It will complete synchronously and the promise
    // will be elided because it's not used.
    LoadVar(index 0);                    // 2  myAsyncFunc    ./test/end-to-end/tests/async-await.test.mvm.js:36:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:36:3
    Call(count 1, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:36:3
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:37:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:37:3
    Literal(lit 'After async synchronous return'); // 4       ./test/end-to-end/tests/async-await.test.mvm.js:37:9
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:37:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:42:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:42:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:42:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:39:3
    LoadGlobal(name 'print');            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:40:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:40:5
    Literal(lit 'Inside async function'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:40:11
    Call(count 2, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:40:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:41:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:41:4
}

// Tests awaiting a JS async function which completes immediately with a return
// value. This tests basic await-call and that the return value is used
// correctly. Also the result is scheduled on the job queue.
function test_awaitReturnValue() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:48:1
    Literal(lit &function asyncFunction); // 4                ./test/end-to-end/tests/async-await.test.mvm.js:48:40
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:48:40
    LoadVar(index 3);                    // 6  asyncFunction  ./test/end-to-end/tests/async-await.test.mvm.js:49:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:49:24
    Literal(lit 22);                     // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:49:38
    AwaitCall(count 2);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:49:38
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:49:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:49:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:49:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:50:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:50:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await.test.mvm.js:50:15
    Literal(lit 23);                     // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:50:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:50:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:55:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:55:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:55:2
}

function asyncFunction() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:52:3
    LoadArg(index 1);                    // 4  arg            ./test/end-to-end/tests/async-await.test.mvm.js:53:12
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:53:18
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:53:18
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:53:5
}