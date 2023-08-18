unit ['./test/end-to-end/tests/async-await-basic.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external asyncTestComplete from free-variable 'asyncTestComplete';
external undefined from free-variable 'undefined';
external print from free-variable 'print';
external assertEqual from free-variable 'assertEqual';
external assert from free-variable 'assert';

global thisModule;
global runAsync;
global test_minimal;
global test_awaitReturnValue;
global test_asyncVariablesFromNested;
global test_asyncInExpression;
global test_asyncFunctionArguments;
global test_asyncThisArgument;
global test_asyncArrowFunctions;
global test_implicitReturn;
global test_asyncClosure;
global test_syncClosureInAsync;
global test_exceptionsBasic;
global test_exceptionsNested;
global test_multipleJobs;
global test_nestedClosure;
global test_awaitInsideCatch;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function runAsync);     // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'runAsync');        // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_minimal); // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_minimal');    // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_awaitReturnValue); // 2        ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_awaitReturnValue'); // 1           ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_asyncVariablesFromNested); // 2  ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncVariablesFromNested'); // 1   ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_asyncInExpression); // 2       ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncInExpression'); // 1          ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_asyncFunctionArguments); // 2  ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncFunctionArguments'); // 1     ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_asyncThisArgument); // 2       ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncThisArgument'); // 1          ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_asyncArrowFunctions); // 2     ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncArrowFunctions'); // 1        ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_implicitReturn); // 2          ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_implicitReturn'); // 1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_asyncClosure); // 2            ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncClosure'); // 1               ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_syncClosureInAsync); // 2      ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_syncClosureInAsync'); // 1         ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_exceptionsBasic); // 2         ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_exceptionsBasic'); // 1            ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_exceptionsNested); // 2        ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_exceptionsNested'); // 1           ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_multipleJobs); // 2            ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_multipleJobs'); // 1               ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_nestedClosure); // 2           ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_nestedClosure'); // 1              ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    Literal(lit &function test_awaitInsideCatch); // 2        ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    StoreGlobal(name 'test_awaitInsideCatch'); // 1           ./test/end-to-end/tests/async-await-basic.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality
    // assertionCount: 39
    // isAsync: true
    // testOnly: false
    // expectedPrintout: |
    // Before async function
    // Inside async function
    // After async synchronous return
    // 
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:13:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:13:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:13:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/async-await-basic.test.mvm.js:13:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:13:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:394:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:394:1
}

function run() {
  entry:
    // Void-call async function
    LoadGlobal(name 'runAsync');         // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:17:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:17:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:18:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:18:2
}

function runAsync() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:20:1
    StartTry(@block1);                   // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:21:7
    LoadGlobal(name 'test_minimal');     // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:22:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:22:5
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:22:5
    LoadGlobal(name 'test_awaitReturnValue'); // 6            ./test/end-to-end/tests/async-await-basic.test.mvm.js:23:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:23:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:23:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:23:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:23:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:23:5
    LoadGlobal(name 'test_asyncVariablesFromNested'); // 6    ./test/end-to-end/tests/async-await-basic.test.mvm.js:24:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:24:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:24:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:24:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:24:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:24:5
    LoadGlobal(name 'test_asyncInExpression'); // 6           ./test/end-to-end/tests/async-await-basic.test.mvm.js:25:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:25:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:25:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:25:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:25:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:25:5
    LoadGlobal(name 'test_asyncFunctionArguments'); // 6      ./test/end-to-end/tests/async-await-basic.test.mvm.js:26:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:26:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:26:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:26:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:26:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:26:5
    LoadGlobal(name 'test_asyncThisArgument'); // 6           ./test/end-to-end/tests/async-await-basic.test.mvm.js:27:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:27:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:27:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:27:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:27:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:27:5
    LoadGlobal(name 'test_asyncArrowFunctions'); // 6         ./test/end-to-end/tests/async-await-basic.test.mvm.js:28:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:28:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:28:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:28:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:28:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:28:5
    LoadGlobal(name 'test_implicitReturn'); // 6              ./test/end-to-end/tests/async-await-basic.test.mvm.js:29:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:29:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:29:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:29:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:29:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:29:5
    LoadGlobal(name 'test_asyncClosure'); // 6                ./test/end-to-end/tests/async-await-basic.test.mvm.js:30:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:30:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:30:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:30:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:30:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:30:5
    LoadGlobal(name 'test_syncClosureInAsync'); // 6          ./test/end-to-end/tests/async-await-basic.test.mvm.js:31:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:31:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:31:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:31:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:31:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:31:5
    LoadGlobal(name 'test_exceptionsBasic'); // 6             ./test/end-to-end/tests/async-await-basic.test.mvm.js:32:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:32:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:32:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:32:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:32:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:32:5
    LoadGlobal(name 'test_exceptionsNested'); // 6            ./test/end-to-end/tests/async-await-basic.test.mvm.js:33:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:33:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:33:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:33:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:33:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:33:5
    LoadGlobal(name 'test_multipleJobs'); // 6                ./test/end-to-end/tests/async-await-basic.test.mvm.js:34:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:34:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:34:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:34:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:34:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:34:5
    LoadGlobal(name 'test_nestedClosure'); // 6               ./test/end-to-end/tests/async-await-basic.test.mvm.js:35:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:35:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:35:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:35:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:35:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:35:5
    LoadGlobal(name 'test_awaitInsideCatch'); // 6            ./test/end-to-end/tests/async-await-basic.test.mvm.js:36:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:36:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:36:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:36:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:36:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:36:5
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await-basic.test.mvm.js:38:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:38:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:38:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:38:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:38:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:39:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:39:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await-basic.test.mvm.js:40:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:40:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:40:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:40:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:40:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:41:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:41:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:42:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:42:2
}

// Void-calling async function with no await points or variable bindings.
function test_minimal() {
  entry:
    Literal(lit &function myAsyncFunc);  // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:45:25
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:46:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:46:3
    Literal(lit 'Before async function'); // 4                ./test/end-to-end/tests/async-await-basic.test.mvm.js:46:9
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:46:9
    // Void-calling async func. It will complete synchronously and the promise
    // will be elided because it's not used.
    LoadVar(index 0);                    // 2  myAsyncFunc    ./test/end-to-end/tests/async-await-basic.test.mvm.js:49:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:49:3
    Call(count 1, flag true);            // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:49:3
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:50:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:50:3
    Literal(lit 'After async synchronous return'); // 4       ./test/end-to-end/tests/async-await-basic.test.mvm.js:50:9
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:50:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:55:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:55:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:55:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:52:3
    LoadGlobal(name 'print');            // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:53:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:53:5
    Literal(lit 'Inside async function'); // 6                ./test/end-to-end/tests/async-await-basic.test.mvm.js:53:11
    Call(count 2, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:53:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:54:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:54:4
}

// Tests awaiting a JS async function which completes immediately with a return
// value. This tests basic await-call and that the return value is used
// correctly. Also the result is scheduled on the job queue.
function test_awaitReturnValue() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:61:1
    Literal(lit &function asyncFunction); // 4                ./test/end-to-end/tests/async-await-basic.test.mvm.js:61:40
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:61:40
    LoadVar(index 3);                    // 6  asyncFunction  ./test/end-to-end/tests/async-await-basic.test.mvm.js:62:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:62:24
    Literal(lit 22);                     // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:62:38
    AwaitCall(count 2);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:62:38
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:62:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:62:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:62:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:63:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:63:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:63:15
    Literal(lit 23);                     // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:63:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:63:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:68:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:68:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:68:2
}

function asyncFunction() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:65:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:65:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:65:3
    LoadScoped(index 2);                 // 4  arg            ./test/end-to-end/tests/async-await-basic.test.mvm.js:66:12
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:66:18
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:66:18
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:66:5
}

function test_asyncVariablesFromNested() {
  entry:
    AsyncStart(count 10, flag false);    // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:70:1
    Literal(lit &function nested2);      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:70:48
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:70:48
    StoreScoped(index 7);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:70:48
    Literal(lit deleted);                // 4  x2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:70:48
    // This function tests that variables in an async function can be accessed
    // correctly from a nested closure.
    // Variable in root
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:75:12
    StoreScoped(index 8);                // 4  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:75:12
    // closure-accessed
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:76:12
    StoreVar(index 3);                   // 4  x2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:76:12
    // local-accessed
    StartTry(@block3);                   // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:77:7
    Literal(lit &function nestedFunc);   // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:77:7
    ClosureNew();                        // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:77:7
    Literal(lit deleted);                // 8  y2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:77:7
    // Variable nested in try block.
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:79:14
    StoreScoped(index 9);                // 8  y1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:79:14
    // closure-accessed
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:80:14
    StoreVar(index 7);                   // 8  y2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:80:14
    // local accessed
    LoadVar(index 6);                    // 9  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:82:11
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:82:11
    AwaitCall(count 1);                  // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:82:11
    Await();                             // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:82:5
    AsyncResume(count 5, count 4);       // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:82:5
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:82:5
    LoadScoped(index 8);                 // 9  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:84:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:84:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:84:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:84:11
    StoreScoped(index 8);                // 9  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:84:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:84:11
    LoadScoped(index 9);                 // 9  y1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:85:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:85:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:85:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:85:11
    StoreScoped(index 9);                // 9  y1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:85:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:85:11
    LoadVar(index 3);                    // 9  x2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:86:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:86:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:86:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:86:11
    StoreVar(index 3);                   // 9  x2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:86:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:86:11
    LoadVar(index 7);                    // 9  y2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:87:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:87:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:87:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:87:11
    StoreVar(index 7);                   // 9  y2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:87:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:87:11
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:89:5
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:89:5
    LoadScoped(index 9);                 // 11 y1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:89:17
    Literal(lit 12155);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:89:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:89:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:90:5
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:90:5
    LoadVar(index 7);                    // 11 y2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:90:17
    Literal(lit 77);                     // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:90:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:90:21
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:99:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:99:4
  block3:
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:99:11
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:100:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:100:10
    StoreScoped(index 8);                // 5  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:100:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:100:10
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:101:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:101:10
    StoreVar(index 3);                   // 5  x2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:101:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:101:10
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:102:4
  block4:
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:104:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:104:3
    LoadScoped(index 8);                 // 7  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:104:15
    Literal(lit 92378);                  // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:104:19
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:104:19
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:105:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:105:3
    LoadVar(index 3);                    // 7  x2             ./test/end-to-end/tests/async-await-basic.test.mvm.js:105:15
    Literal(lit 33);                     // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:105:19
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:105:19
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:110:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:110:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:110:2
}

function nested2() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:107:3
    LoadScoped(index 13);                // 4  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:108:5
    Literal(lit 19);                     // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:108:11
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:108:11
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:108:11
    StoreScoped(index 13);               // 4  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:108:11
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:108:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:109:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:109:4
}

function nestedFunc() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:92:5
    LoadScoped(index 13);                // 4  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:93:7
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:93:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:93:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:93:13
    StoreScoped(index 13);               // 4  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:93:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:93:13
    LoadScoped(index 14);                // 4  y1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:94:7
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:94:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:94:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:94:13
    StoreScoped(index 14);               // 4  y1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:94:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:94:13
    LoadScoped(index 12);                // 4  nested2        ./test/end-to-end/tests/async-await-basic.test.mvm.js:95:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:95:13
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:95:13
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:95:7
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:95:7
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:95:7
    LoadScoped(index 13);                // 4  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:96:7
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:96:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:96:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:96:13
    StoreScoped(index 13);               // 4  x1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:96:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:96:13
    LoadScoped(index 14);                // 4  y1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:97:7
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:97:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:97:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:97:13
    StoreScoped(index 14);               // 4  y1             ./test/end-to-end/tests/async-await-basic.test.mvm.js:97:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:97:13
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:98:6
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:98:6
}

function test_asyncInExpression() {
  entry:
    AsyncStart(count 11, flag false);    // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:112:1
    Literal(lit &function nestedFunc1);  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:112:41
    Literal(lit &function nestedFunc2);  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:112:41
    Literal(lit &function nestedFunc3);  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:112:41
    Literal(lit deleted);                // 7  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:112:41
    Literal(lit deleted);                // 8  y              ./test/end-to-end/tests/async-await-basic.test.mvm.js:112:41
    // Here the array literal is a temporary pushed to the stack and then each
    // element is awaited in turn. This tests that the temporary is correctly
    // restored after each await point.
    ArrayNew();                          // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    Literal(lit 0);                      // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:117:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    Literal(lit 1);                      // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    LoadVar(index 3);                    // 12 nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:118:11
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:118:11
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:118:11
    Await();                             // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:118:5
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:118:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    Literal(lit 2);                      // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    LoadVar(index 4);                    // 12 nestedFunc2    ./test/end-to-end/tests/async-await-basic.test.mvm.js:119:11
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:119:11
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:119:11
    Await();                             // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:119:5
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:119:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    Literal(lit 3);                      // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    Literal(lit 11);                     // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:120:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    StoreVar(index 6);                   // 8  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:116:13
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:123:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:123:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:123:15
    Literal(lit 'length');               // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:123:15
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:123:15
    Literal(lit 4);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:123:25
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:123:25
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:124:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:124:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:124:15
    Literal(lit 0);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:124:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:124:17
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:124:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:124:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:125:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:125:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:125:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:125:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:125:17
    Literal(lit 5);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:125:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:125:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:126:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:126:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:126:15
    Literal(lit 2);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:126:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:126:17
    Literal(lit 7);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:126:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:126:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:127:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:127:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:127:15
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:127:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:127:17
    Literal(lit 11);                     // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:127:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:127:21
    // Similarly here the function call involves pushing the arguments to the
    // stack as temporaries, so this tests that the stack is correctly restored
    // after each await point.
    LoadVar(index 5);                    // 9  nestedFunc3    ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:19
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:19
    Literal(lit 3);                      // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:31
    LoadVar(index 3);                    // 12 nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:40
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:40
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:40
    Await();                             // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:34
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:34
    LoadVar(index 4);                    // 13 nestedFunc2    ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:60
    Literal(lit undefined);              // 14                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:60
    AwaitCall(count 1);                  // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:60
    Await();                             // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:54
    AsyncResume(count 9, count 11);      // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:54
    Literal(lit 11);                     // 14                ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:75
    AwaitCall(count 5);                  // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:75
    Await();                             // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:13
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:13
    StoreVar(index 7);                   // 8  y              ./test/end-to-end/tests/async-await-basic.test.mvm.js:132:13
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:133:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:133:3
    LoadVar(index 7);                    // 11 y              ./test/end-to-end/tests/async-await-basic.test.mvm.js:133:15
    Literal(lit 26);                     // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:133:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:133:18
    Pop(count 5);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:146:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:146:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:146:2
}

function nestedFunc1() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:135:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:136:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:136:5
}

function nestedFunc2() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:139:3
    Literal(lit 7);                      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:140:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:140:5
}

function nestedFunc3() {
  entry:
    AsyncStart(count 6, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    LoadArg(index 3);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    LoadArg(index 4);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    StoreScoped(index 5);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:143:3
    LoadScoped(index 2);                 // 4  a              ./test/end-to-end/tests/async-await-basic.test.mvm.js:144:12
    LoadScoped(index 3);                 // 5  b              ./test/end-to-end/tests/async-await-basic.test.mvm.js:144:16
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:144:16
    LoadScoped(index 4);                 // 5  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:144:20
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:144:20
    LoadScoped(index 5);                 // 5  d              ./test/end-to-end/tests/async-await-basic.test.mvm.js:144:24
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:144:24
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:144:5
}

function test_asyncFunctionArguments() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:148:1
    Literal(lit &function nestedFunc4);  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:148:46
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:148:46
    Literal(lit &function nestedFunc5);  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:148:46
    StoreScoped(index 3);                // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:148:46
    // This function tests that function arguments are correctly captured by
    // async functions.
    LoadVar(index 3);                    // 5  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:9
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:9
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:20
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:23
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:26
    AwaitCall(count 4);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:3
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:151:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:165:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:165:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:165:2
}

function nestedFunc4() {
  entry:
    AsyncStart(count 6, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:153:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:153:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:153:3
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:153:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:153:3
    LoadArg(index 3);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:153:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:153:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:154:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:154:5
    LoadScoped(index 2);                 // 6  a              ./test/end-to-end/tests/async-await-basic.test.mvm.js:154:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:154:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:154:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:155:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:155:5
    LoadScoped(index 3);                 // 6  b              ./test/end-to-end/tests/async-await-basic.test.mvm.js:155:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:155:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:155:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:156:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:156:5
    LoadScoped(index 4);                 // 6  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:156:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:156:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:156:20
    LoadScoped(index 11);                // 4  nestedFunc2    ./test/end-to-end/tests/async-await-basic.test.mvm.js:157:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:157:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:157:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:157:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:157:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:157:5
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:158:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:158:5
    LoadScoped(index 2);                 // 6  a              ./test/end-to-end/tests/async-await-basic.test.mvm.js:158:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:158:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:158:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:159:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:159:5
    LoadScoped(index 3);                 // 6  b              ./test/end-to-end/tests/async-await-basic.test.mvm.js:159:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:159:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:159:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:160:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:160:5
    LoadScoped(index 4);                 // 6  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:160:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:160:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:160:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:161:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:161:4
}

function nestedFunc5() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:163:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:164:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:164:4
}

function test_asyncThisArgument() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:167:1
    Literal(lit &function nestedFunc6);  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:167:41
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:167:41
    Literal(lit &function nestedFunc7);  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:167:41
    StoreScoped(index 4);                // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:167:41
    Literal(lit deleted);                // 5  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:167:41
    ObjectNew();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:168:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:168:15
    Literal(lit 'a');                    // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:168:15
    Literal(lit 3);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:169:8
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:169:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:169:8
    Literal(lit 'b');                    // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:169:8
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:170:8
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:170:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:170:8
    Literal(lit 'nestedFunc');           // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:170:8
    LoadVar(index 3);                    // 9  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:171:5
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:171:5
    StoreVar(index 4);                   // 5  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:171:5
    // This function tests that function arguments are correctly captured by
    // async functions.
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:3
    LoadVar(index 4);                    // 7  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:9
    Literal(lit 'nestedFunc');           // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:9
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:9
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:9
    Literal(lit 7);                      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:24
    AwaitCall(count 2);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:3
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:175:3
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:189:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:189:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:189:2
}

function nestedFunc6() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:177:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:177:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:177:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:177:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:177:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:178:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:178:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await-basic.test.mvm.js:178:17
    Literal(lit 'a');                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:178:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:178:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:178:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:178:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:179:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:179:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await-basic.test.mvm.js:179:17
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:179:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:179:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:179:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:179:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:180:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:180:5
    LoadScoped(index 3);                 // 6  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:180:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:180:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:180:20
    LoadScoped(index 11);                // 4  nestedFunc2    ./test/end-to-end/tests/async-await-basic.test.mvm.js:181:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:181:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:181:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:181:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:181:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:181:5
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:182:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:182:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await-basic.test.mvm.js:182:17
    Literal(lit 'a');                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:182:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:182:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:182:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:182:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:183:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:183:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await-basic.test.mvm.js:183:17
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:183:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:183:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:183:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:183:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:184:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:184:5
    LoadScoped(index 3);                 // 6  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:184:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:184:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:184:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:185:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:185:4
}

function nestedFunc7() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:187:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:188:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:188:4
}

function test_asyncArrowFunctions() {
  entry:
    AsyncStart(count 6, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:191:1
    Literal(lit &function nestedFunc8);  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:191:43
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:191:43
    Literal(lit deleted);                // 4  func           ./test/end-to-end/tests/async-await-basic.test.mvm.js:191:43
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:191:43
    Literal(lit 4);                      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:192:11
    StoreScoped(index 5);                // 5  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:192:11
    Literal(lit &function anonymous);    // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:193:16
    ClosureNew();                        // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:193:16
    StoreVar(index 3);                   // 5  func           ./test/end-to-end/tests/async-await-basic.test.mvm.js:193:16
    LoadVar(index 3);                    // 6  func           ./test/end-to-end/tests/async-await-basic.test.mvm.js:198:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:198:24
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:198:29
    Literal(lit 2);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:198:32
    AwaitCall(count 3);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:198:32
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:198:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:198:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:198:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:199:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:199:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:199:15
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:199:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:199:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:203:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:203:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:203:2
}

function nestedFunc8() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:201:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:202:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:202:4
}

function anonymous() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:193:16
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:193:16
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:193:16
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:193:16
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:193:16
    LoadScoped(index 11);                // 4  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:194:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:194:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:194:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:194:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:194:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:194:5
    LoadScoped(index 2);                 // 4  a              ./test/end-to-end/tests/async-await-basic.test.mvm.js:195:12
    LoadScoped(index 3);                 // 5  b              ./test/end-to-end/tests/async-await-basic.test.mvm.js:195:16
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:195:16
    LoadScoped(index 12);                // 5  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:195:20
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:195:20
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:195:5
}

function test_implicitReturn() {
  entry:
    AsyncStart(count 11, flag false);    // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:1
    Literal(lit &function implicitReturn1); // 4              ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    Literal(lit &function explicitReturn1); // 5              ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    Literal(lit &function implicitReturn2); // 6              ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    ClosureNew();                        // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    Literal(lit &function explicitReturn2); // 7              ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    ClosureNew();                        // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    Literal(lit &function nestedFunc9);  // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    StoreScoped(index 10);               // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    Literal(lit deleted);                // 8  result1        ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    Literal(lit deleted);                // 9  result2        ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    Literal(lit deleted);                // 10 result3        ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    Literal(lit deleted);                // 11 result4        ./test/end-to-end/tests/async-await-basic.test.mvm.js:205:38
    LoadVar(index 3);                    // 12 implicitReturn1 ./test/end-to-end/tests/async-await-basic.test.mvm.js:206:25
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:206:25
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:206:25
    Await();                             // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:206:19
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:206:19
    StoreVar(index 7);                   // 11 result1        ./test/end-to-end/tests/async-await-basic.test.mvm.js:206:19
    LoadVar(index 4);                    // 12 explicitReturn1 ./test/end-to-end/tests/async-await-basic.test.mvm.js:207:25
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:207:25
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:207:25
    Await();                             // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:207:19
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:207:19
    StoreVar(index 8);                   // 11 result2        ./test/end-to-end/tests/async-await-basic.test.mvm.js:207:19
    LoadVar(index 5);                    // 12 implicitReturn2 ./test/end-to-end/tests/async-await-basic.test.mvm.js:208:25
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:208:25
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:208:25
    Await();                             // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:208:19
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:208:19
    StoreVar(index 9);                   // 11 result3        ./test/end-to-end/tests/async-await-basic.test.mvm.js:208:19
    LoadVar(index 6);                    // 12 explicitReturn2 ./test/end-to-end/tests/async-await-basic.test.mvm.js:209:25
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:209:25
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:209:25
    Await();                             // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:209:19
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:209:19
    StoreVar(index 10);                  // 11 result4        ./test/end-to-end/tests/async-await-basic.test.mvm.js:209:19
    LoadGlobal(name 'assertEqual');      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:210:3
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:210:3
    LoadVar(index 7);                    // 14 result1        ./test/end-to-end/tests/async-await-basic.test.mvm.js:210:15
    Literal(lit undefined);              // 15                ./test/end-to-end/tests/async-await-basic.test.mvm.js:210:24
    Call(count 3, flag true);            // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:210:24
    LoadGlobal(name 'assertEqual');      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:211:3
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:211:3
    LoadVar(index 8);                    // 14 result2        ./test/end-to-end/tests/async-await-basic.test.mvm.js:211:15
    Literal(lit 1);                      // 15                ./test/end-to-end/tests/async-await-basic.test.mvm.js:211:24
    Call(count 3, flag true);            // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:211:24
    LoadGlobal(name 'assertEqual');      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:212:3
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:212:3
    LoadVar(index 9);                    // 14 result3        ./test/end-to-end/tests/async-await-basic.test.mvm.js:212:15
    Literal(lit undefined);              // 15                ./test/end-to-end/tests/async-await-basic.test.mvm.js:212:24
    Call(count 3, flag true);            // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:212:24
    LoadGlobal(name 'assertEqual');      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:213:3
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:213:3
    LoadVar(index 10);                   // 14 result4        ./test/end-to-end/tests/async-await-basic.test.mvm.js:213:15
    Literal(lit 2);                      // 15                ./test/end-to-end/tests/async-await-basic.test.mvm.js:213:24
    Call(count 3, flag true);            // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:213:24
    Pop(count 8);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:233:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:233:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:233:2
}

function implicitReturn1() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:215:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:216:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:216:4
}

function explicitReturn1() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:218:3
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:219:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:219:5
}

function implicitReturn2() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:222:3
    LoadScoped(index 15);                // 4  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:223:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:223:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:223:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:223:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:223:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:223:5
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:224:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:224:4
}

function explicitReturn2() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:226:3
    LoadScoped(index 15);                // 4  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:227:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:227:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:227:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:227:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:227:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:227:5
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:228:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:228:5
}

function nestedFunc9() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:231:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:232:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:232:4
}

function test_asyncClosure() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:235:1
    Literal(lit &function method);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:235:36
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:235:36
    Literal(lit &function nestedFunc10); // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:235:36
    StoreScoped(index 5);                // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:235:36
    Literal(lit deleted);                // 5  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:235:36
    Literal(lit deleted);                // 6  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:235:36
    Literal(lit 4);                      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:236:11
    StoreScoped(index 6);                // 6  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:236:11
    ObjectNew();                         // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:237:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:237:15
    Literal(lit 'd');                    // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:237:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:238:8
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:238:8
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:238:8
    Literal(lit 'method');               // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:238:8
    LoadVar(index 3);                    // 10 method         ./test/end-to-end/tests/async-await-basic.test.mvm.js:239:5
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:239:5
    StoreVar(index 4);                   // 6  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:239:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:24
    LoadVar(index 4);                    // 8  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:24
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:24
    Literal(lit 'method');               // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:24
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:24
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:24
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:24
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:24
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:37
    Literal(lit 2);                      // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:40
    AwaitCall(count 3);                  // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:40
    Await();                             // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:18
    AsyncResume(count 3, count 5);       // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:18
    StoreVar(index 5);                   // 6  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:251:18
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:252:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:252:3
    LoadVar(index 5);                    // 9  result         ./test/end-to-end/tests/async-await-basic.test.mvm.js:252:15
    Literal(lit 18);                     // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:252:23
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:252:23
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:256:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:256:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:256:2
}

function method() {
  entry:
    ScopePush(count 3);                  // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:242:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:242:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:242:3
    // captures c and `this`.
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:12
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:12
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:12
    // captures c and `this`.
    Return();                            // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:5
}

function anonymous1() {
  entry:
    AsyncStart(count 6, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:12
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:12
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:12
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:12
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:12
    Literal(lit deleted);                // 4  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:244:28
    Literal(lit 6);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:245:15
    StoreVar(index 3);                   // 4  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:245:15
    LoadScoped(index 16);                // 5  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:246:13
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:246:13
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:246:13
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:246:7
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:246:7
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:246:7
    LoadScoped(index 3);                 // 5  a              ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:14
    LoadScoped(index 4);                 // 6  b              ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:18
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:18
    LoadScoped(index 17);                // 6  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:22
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:22
    LoadScoped(index 7);                 // 6  this           ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:26
    Literal(lit 'd');                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:26
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:26
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:26
    LoadVar(index 3);                    // 6  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:35
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:35
    AsyncReturn();                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:247:7
}

function nestedFunc10() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:254:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:255:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:255:4
}

function test_syncClosureInAsync() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:258:1
    Literal(lit &function method1);      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:258:42
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:258:42
    Literal(lit &function nestedFunc11); // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:258:42
    Literal(lit deleted);                // 6  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:258:42
    Literal(lit deleted);                // 7  f              ./test/end-to-end/tests/async-await-basic.test.mvm.js:258:42
    // Among other things, this tests that the `return` statement in the closure
    // isn't picked up as an async-return, even though it's lexically inside an
    // async function.
    Literal(lit 4);                      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:263:11
    StoreScoped(index 6);                // 7  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:263:11
    ObjectNew();                         // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:264:15
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:264:15
    Literal(lit 'd');                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:264:15
    Literal(lit 5);                      // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:265:8
    ObjectSet();                         // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:265:8
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:265:8
    Literal(lit 'method');               // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:265:8
    LoadVar(index 3);                    // 11 method         ./test/end-to-end/tests/async-await-basic.test.mvm.js:266:5
    ObjectSet();                         // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:266:5
    StoreVar(index 5);                   // 7  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:266:5
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:15
    LoadVar(index 5);                    // 11 obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:15
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:15
    Literal(lit 'method');               // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:15
    ObjectGet();                         // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:15
    StoreVar(index 9);                   // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:15
    Call(count 1, flag false);           // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:15
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:28
    Literal(lit 2);                      // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:31
    Call(count 3, flag false);           // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:31
    Literal(lit 18);                     // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:35
    Call(count 3, flag true);            // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:277:35
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:278:13
    LoadVar(index 5);                    // 9  obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:278:13
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:278:13
    Literal(lit 'method');               // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:278:13
    ObjectGet();                         // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:278:13
    StoreVar(index 7);                   // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:278:13
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:278:13
    StoreVar(index 6);                   // 7  f              ./test/end-to-end/tests/async-await-basic.test.mvm.js:278:13
    LoadVar(index 4);                    // 8  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:279:9
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:279:9
    AwaitCall(count 1);                  // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:279:9
    Await();                             // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:279:3
    AsyncResume(count 4, count 6);       // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:279:3
    Pop(count 1);                        // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:279:3
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:15
    LoadVar(index 5);                    // 11 obj            ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:15
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:15
    Literal(lit 'method');               // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:15
    ObjectGet();                         // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:15
    StoreVar(index 9);                   // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:15
    Call(count 1, flag false);           // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:15
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:28
    Literal(lit 2);                      // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:31
    Call(count 3, flag false);           // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:31
    Literal(lit 18);                     // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:35
    Call(count 3, flag true);            // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:280:35
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:3
    LoadVar(index 6);                    // 10 f              ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:15
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:17
    Literal(lit 3);                      // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:20
    Call(count 3, flag false);           // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:20
    Literal(lit 19);                     // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:24
    Call(count 3, flag true);            // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:281:24
    Pop(count 4);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:285:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:285:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:285:2
}

function method1() {
  entry:
    ScopePush(count 3);                  // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:269:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:269:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:269:3
    // captures c and `this`.
    Literal(lit &function anonymous2);   // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:271:12
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:271:12
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:271:12
    // captures c and `this`.
    Return();                            // 0                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:271:5
}

function anonymous2() {
  entry:
    Literal(lit deleted);                // 1  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:271:22
    Literal(lit 6);                      // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:272:15
    StoreVar(index 0);                   // 1  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:272:15
    LoadArg(index 1);                    // 2  a              ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:14
    LoadArg(index 2);                    // 3  b              ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:18
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:18
    LoadScoped(index 11);                // 3  c              ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:22
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:22
    LoadScoped(index 1);                 // 3  this           ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:26
    Literal(lit 'd');                    // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:26
    ObjectGet();                         // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:26
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:26
    LoadVar(index 0);                    // 3  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:35
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:35
    Return();                            // 1                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:273:7
}

function nestedFunc11() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:283:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:284:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:284:4
}

function test_exceptionsBasic() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:287:1
    Literal(lit &function nestedFunc12); // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:287:39
    StartTry(@block5);                   // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:288:7
    LoadVar(index 3);                    // 7  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:289:11
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:289:11
    AwaitCall(count 1);                  // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:289:11
    Await();                             // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:289:5
    AsyncResume(count 3, count 2);       // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:289:5
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:289:5
    LoadGlobal(name 'assert');           // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:290:5
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:290:5
    Literal(lit false);                  // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:290:12
    Call(count 2, flag true);            // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:290:12
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:291:4
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:291:4
  block5:
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:292:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:292:5
    LoadVar(index 4);                    // 8  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:292:17
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:292:20
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:292:20
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:293:4
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:293:4
  block6:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:298:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:298:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:298:2
}

function nestedFunc12() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:295:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:296:11
    Throw();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:296:11
}

function test_exceptionsNested() {
  entry:
    AsyncStart(count 11, flag false);    // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:300:1
    Literal(lit &function nestedFunc13); // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:300:40
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:300:40
    Literal(lit &function nestedFunc14); // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:300:40
    StoreScoped(index 10);               // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:300:40
    Literal(lit deleted);                // 5  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:300:40
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:301:11
    StoreVar(index 4);                   // 5  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:301:11
    StartTry(@block11);                  // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:302:7
    Literal(lit deleted);                // 8  y              ./test/end-to-end/tests/async-await-basic.test.mvm.js:302:7
    Literal(lit 3);                      // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:303:13
    StoreVar(index 7);                   // 8  y              ./test/end-to-end/tests/async-await-basic.test.mvm.js:303:13
    StartTry(@block9);                   // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:304:9
    LoadVar(index 4);                    // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:305:7
    LoadVar(index 7);                    // 12 y              ./test/end-to-end/tests/async-await-basic.test.mvm.js:305:12
    BinOp(op '*');                       // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:305:12
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:305:12
    StoreVar(index 4);                   // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:305:12
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:305:12
    LoadVar(index 4);                    // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:7
    LoadVar(index 3);                    // 12 nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:18
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:18
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:18
    Await();                             // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:12
    AsyncResume(count 8, count 3);       // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:12
    BinOp(op '*');                       // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:12
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:12
    StoreVar(index 4);                   // 11 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:12
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:306:12
    EndTry();                            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:307:6
    Jump(@block10);                      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:307:6
  block9:
    LoadVar(index 4);                    // 10 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:308:7
    LoadVar(index 8);                    // 11 e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:308:12
    BinOp(op '*');                       // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:308:12
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:308:12
    StoreVar(index 4);                   // 10 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:308:12
    Pop(count 1);                        // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:308:12
    LoadVar(index 4);                    // 10 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:309:7
    LoadVar(index 7);                    // 11 y              ./test/end-to-end/tests/async-await-basic.test.mvm.js:309:12
    BinOp(op '*');                       // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:309:12
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:309:12
    StoreVar(index 4);                   // 10 x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:309:12
    Pop(count 1);                        // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:309:12
    // Check that y is intact on the stack between the 2 catch blocks.
    // This throw should be caught by the outer catch block if the catch stack
    // is correctly restored.
    Literal(lit 7);                      // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:312:13
    Throw();                             // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:312:13
  block10:
    EndTry();                            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:314:4
    Jump(@block12);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:314:4
  block11:
    LoadVar(index 4);                    // 7  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:315:5
    LoadVar(index 5);                    // 8  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:315:10
    BinOp(op '*');                       // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:315:10
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:315:10
    StoreVar(index 4);                   // 7  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:315:10
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:315:10
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:316:4
    Jump(@block12);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:316:4
  block12:
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:317:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:317:3
    LoadVar(index 4);                    // 8  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:317:15
    Literal(lit 630);                    // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:317:18
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:317:18
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:331:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:331:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:331:2
}

function nestedFunc13() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:319:3
    StartTry(@block7);                   // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:320:9
    LoadScoped(index 17);                // 6  nestedFunc2    ./test/end-to-end/tests/async-await-basic.test.mvm.js:321:13
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:321:13
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:321:13
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:321:7
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:321:7
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:321:7
    // This time trying throw after await
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:323:13
    Throw();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:323:13
  block7:
    LoadVar(index 3);                    // 5  e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:325:13
    Throw();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:325:13
  block8:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:327:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:327:4
}

function nestedFunc14() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:329:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:330:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:330:4
}

function test_multipleJobs() {
  entry:
    AsyncStart(count 6, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:333:1
    Literal(lit &function task1);        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:333:36
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:333:36
    Literal(lit &function task2);        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:333:36
    ClosureNew();                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:333:36
    Literal(lit &function nestedFunc15); // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:333:36
    StoreScoped(index 4);                // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:333:36
    // This function tests the engine can handle multiple jobs in the job queue
    // simultaneously.
    // nestedFunc completes immediately which should schedule the caller to
    // continue in the job queue. So `task1` will put one job in the queue, and
    // `task2` will put another. Then the parent waits for the job queue to flush
    // and checks the result.
    Literal(lit 'Start');                // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:342:11
    StoreScoped(index 5);                // 5  s              ./test/end-to-end/tests/async-await-basic.test.mvm.js:342:11
    LoadVar(index 3);                    // 6  task1          ./test/end-to-end/tests/async-await-basic.test.mvm.js:344:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:344:3
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:344:3
    LoadVar(index 4);                    // 6  task2          ./test/end-to-end/tests/async-await-basic.test.mvm.js:345:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:345:3
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:345:3
    LoadScoped(index 5);                 // 6  s              ./test/end-to-end/tests/async-await-basic.test.mvm.js:347:3
    Literal(lit ';End');                 // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:347:8
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:347:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:347:8
    StoreScoped(index 5);                // 6  s              ./test/end-to-end/tests/async-await-basic.test.mvm.js:347:8
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:347:8
    LoadScoped(index 4);                 // 6  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:349:9
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:349:9
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:349:9
    Await();                             // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:349:3
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:349:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:349:3
    // Wait for job queue
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:351:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:351:3
    LoadScoped(index 5);                 // 8  s              ./test/end-to-end/tests/async-await-basic.test.mvm.js:351:15
    Literal(lit 'Start;End;Job1;Job2');  // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:351:18
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:351:18
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:363:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:363:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:363:2
}

function task1() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:353:3
    LoadScoped(index 9);                 // 4  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:354:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:354:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:354:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:354:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:354:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:354:5
    LoadScoped(index 10);                // 4  s              ./test/end-to-end/tests/async-await-basic.test.mvm.js:355:5
    Literal(lit ';Job1');                // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:355:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:355:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:355:10
    StoreScoped(index 10);               // 4  s              ./test/end-to-end/tests/async-await-basic.test.mvm.js:355:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:355:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:356:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:356:4
}

function task2() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:357:3
    LoadScoped(index 9);                 // 4  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:358:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:358:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:358:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:358:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:358:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:358:5
    LoadScoped(index 10);                // 4  s              ./test/end-to-end/tests/async-await-basic.test.mvm.js:359:5
    Literal(lit ';Job2');                // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:359:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:359:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:359:10
    StoreScoped(index 10);               // 4  s              ./test/end-to-end/tests/async-await-basic.test.mvm.js:359:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:359:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:360:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:360:4
}

function nestedFunc15() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:361:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:362:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:362:4
}

function test_nestedClosure() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:365:1
    Literal(lit &function func1);        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:365:37
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:365:37
    Literal(lit &function nestedFunc16); // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:365:37
    StoreScoped(index 3);                // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:365:37
    // This tests that the parent references in async closures are correct, and
    // the static analysis properly indexes the variables.
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:369:11
    StoreScoped(index 4);                // 4  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:369:11
    LoadVar(index 3);                    // 5  func1          ./test/end-to-end/tests/async-await-basic.test.mvm.js:370:9
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:370:9
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:370:9
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:370:3
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:370:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:370:3
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:371:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:371:3
    LoadScoped(index 4);                 // 7  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:371:15
    Literal(lit 8);                      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:371:18
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:371:18
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:392:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:392:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:392:2
}

function func1() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:373:3
    Literal(lit &function func2);        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:373:26
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:373:26
    LoadVar(index 3);                    // 5  func2          ./test/end-to-end/tests/async-await-basic.test.mvm.js:374:11
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:374:11
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:374:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:374:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:374:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:374:5
    LoadScoped(index 9);                 // 5  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:375:11
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:375:11
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:375:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:375:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:375:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:375:5
    LoadVar(index 3);                    // 5  func2          ./test/end-to-end/tests/async-await-basic.test.mvm.js:376:11
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:376:11
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:376:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:376:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:376:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:376:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:388:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:388:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:388:4
}

function func2() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:377:5
    Literal(lit &function func3);        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:377:28
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:377:28
    LoadVar(index 3);                    // 5  func3          ./test/end-to-end/tests/async-await-basic.test.mvm.js:378:13
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:378:13
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:378:13
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:378:7
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:378:7
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:378:7
    LoadScoped(index 15);                // 5  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:379:13
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:379:13
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:379:13
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:379:7
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:379:7
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:379:7
    LoadVar(index 3);                    // 5  func3          ./test/end-to-end/tests/async-await-basic.test.mvm.js:380:13
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:380:13
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:380:13
    Await();                             // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:380:7
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:380:7
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:380:7
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:387:6
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:387:6
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:387:6
}

function func3() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:382:7
    LoadScoped(index 21);                // 4  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:383:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:383:9
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:383:9
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:383:9
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:383:9
    StoreScoped(index 21);               // 5  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:383:9
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:383:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:383:9
    LoadScoped(index 20);                // 4  nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:384:15
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:384:15
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:384:15
    Await();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:384:9
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:384:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:384:9
    LoadScoped(index 21);                // 4  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:385:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:385:9
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:385:9
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:385:9
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:385:9
    StoreScoped(index 21);               // 5  x              ./test/end-to-end/tests/async-await-basic.test.mvm.js:385:9
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:385:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:385:9
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:386:8
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:386:8
}

function nestedFunc16() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:390:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:391:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:391:4
}

function test_awaitInsideCatch() {
  entry:
    AsyncStart(count 9, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:394:1
    Literal(lit &function nestedFunc17); // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:394:40
    Literal(lit &function nestedFunc18); // 5                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:394:40
    Literal(lit &function nestedFunc19); // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:394:40
    StartTry(@block15);                  // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:395:7
    StartTry(@block13);                  // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:396:9
    LoadVar(index 3);                    // 11 nestedFunc     ./test/end-to-end/tests/async-await-basic.test.mvm.js:397:13
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:397:13
    AwaitCall(count 1);                  // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:397:13
    Await();                             // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:397:7
    AsyncResume(count 7, count 2);       // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:397:7
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:397:7
    LoadGlobal(name 'assert');           // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:398:7
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-basic.test.mvm.js:398:7
    Literal(lit false);                  // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:398:14
    Call(count 2, flag true);            // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:398:14
    EndTry();                            // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:399:6
    Jump(@block14);                      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:399:6
  block13:
    LoadGlobal(name 'assertEqual');      // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:400:7
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:400:7
    LoadVar(index 8);                    // 12 e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:400:19
    Literal(lit 5);                      // 13                ./test/end-to-end/tests/async-await-basic.test.mvm.js:400:22
    Call(count 3, flag true);            // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:400:22
    // Await fail
    LoadVar(index 4);                    // 10 nestedFunc2    ./test/end-to-end/tests/async-await-basic.test.mvm.js:402:13
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:402:13
    AwaitCall(count 1);                  // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:402:13
    Await();                             // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:402:7
    AsyncResume(count 6, count 3);       // 10                ./test/end-to-end/tests/async-await-basic.test.mvm.js:402:7
    Pop(count 1);                        // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:402:7
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:403:6
    Jump(@block14);                      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:403:6
  block14:
    EndTry();                            // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:404:4
    Jump(@block16);                      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:404:4
  block15:
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:405:5
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:405:5
    LoadVar(index 6);                    // 10 e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:405:17
    Literal(lit 6);                      // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:405:20
    Call(count 3, flag true);            // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:405:20
    // Await success
    LoadVar(index 5);                    // 8  nestedFunc3    ./test/end-to-end/tests/async-await-basic.test.mvm.js:407:11
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:407:11
    AwaitCall(count 1);                  // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:407:11
    Await();                             // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:407:5
    AsyncResume(count 4, count 6);       // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:407:5
    Pop(count 1);                        // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:407:5
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:408:5
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:408:5
    LoadVar(index 6);                    // 10 e              ./test/end-to-end/tests/async-await-basic.test.mvm.js:408:17
    Literal(lit 6);                      // 11                ./test/end-to-end/tests/async-await-basic.test.mvm.js:408:20
    Call(count 3, flag true);            // 7                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:408:20
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:409:4
    Jump(@block16);                      // 6                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:409:4
  block16:
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:421:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:421:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:421:2
}

function nestedFunc17() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:411:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:412:11
    Throw();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:412:11
}

function nestedFunc18() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:415:3
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:416:9
    Throw();                             // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:416:9
}

function nestedFunc19() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:419:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:420:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-basic.test.mvm.js:420:4
}