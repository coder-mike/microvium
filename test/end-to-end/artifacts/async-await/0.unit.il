unit ['./test/end-to-end/tests/async-await.test.mvm.js'];

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
    Literal(lit &function test_asyncVariablesFromNested); // 2  ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncVariablesFromNested'); // 1   ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_asyncInExpression); // 2       ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncInExpression'); // 1          ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_asyncFunctionArguments); // 2  ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncFunctionArguments'); // 1     ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_asyncThisArgument); // 2       ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncThisArgument'); // 1          ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_asyncArrowFunctions); // 2     ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncArrowFunctions'); // 1        ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_implicitReturn); // 2          ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_implicitReturn'); // 1             ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_asyncClosure); // 2            ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncClosure'); // 1               ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_syncClosureInAsync); // 2      ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_syncClosureInAsync'); // 1         ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_exceptionsBasic); // 2         ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_exceptionsBasic'); // 1            ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_exceptionsNested); // 2        ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_exceptionsNested'); // 1           ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_multipleJobs); // 2            ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_multipleJobs'); // 1               ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_nestedClosure); // 2           ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_nestedClosure'); // 1              ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality
    // assertionCount: 36
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
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:364:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:364:1
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
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:20:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:20:1
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:20:1
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
    LoadGlobal(name 'test_asyncVariablesFromNested'); // 6    ./test/end-to-end/tests/async-await.test.mvm.js:24:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:24:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:24:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:24:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:24:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:24:5
    LoadGlobal(name 'test_asyncInExpression'); // 6           ./test/end-to-end/tests/async-await.test.mvm.js:25:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:25:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:25:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:25:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:25:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:25:5
    LoadGlobal(name 'test_asyncFunctionArguments'); // 6      ./test/end-to-end/tests/async-await.test.mvm.js:26:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:26:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:26:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:26:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:26:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:26:5
    LoadGlobal(name 'test_asyncThisArgument'); // 6           ./test/end-to-end/tests/async-await.test.mvm.js:27:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:27:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:27:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:27:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:27:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:27:5
    LoadGlobal(name 'test_asyncArrowFunctions'); // 6         ./test/end-to-end/tests/async-await.test.mvm.js:28:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:28:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:28:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:28:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:28:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:28:5
    LoadGlobal(name 'test_implicitReturn'); // 6              ./test/end-to-end/tests/async-await.test.mvm.js:29:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:29:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:29:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:29:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:29:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:29:5
    LoadGlobal(name 'test_asyncClosure'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:30:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:30:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:30:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:30:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:30:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:30:5
    LoadGlobal(name 'test_syncClosureInAsync'); // 6          ./test/end-to-end/tests/async-await.test.mvm.js:31:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:31:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:31:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:31:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:31:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:31:5
    LoadGlobal(name 'test_exceptionsBasic'); // 6             ./test/end-to-end/tests/async-await.test.mvm.js:32:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:32:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:32:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:32:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:32:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:32:5
    LoadGlobal(name 'test_exceptionsNested'); // 6            ./test/end-to-end/tests/async-await.test.mvm.js:33:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:33:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:33:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:33:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:33:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:33:5
    LoadGlobal(name 'test_multipleJobs'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:34:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:34:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:34:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:34:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:34:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:34:5
    LoadGlobal(name 'test_nestedClosure'); // 6               ./test/end-to-end/tests/async-await.test.mvm.js:35:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:35:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:35:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:35:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:35:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:35:5
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:37:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:37:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:37:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:37:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:37:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:38:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:38:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await.test.mvm.js:39:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:39:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:39:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await.test.mvm.js:39:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:39:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:40:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:40:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:41:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:41:2
}

// Void-calling async function with no await points or variable bindings.
function test_minimal() {
  entry:
    Literal(lit &function myAsyncFunc);  // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:44:25
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:45:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:45:3
    Literal(lit 'Before async function'); // 4                ./test/end-to-end/tests/async-await.test.mvm.js:45:9
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:45:9
    // Void-calling async func. It will complete synchronously and the promise
    // will be elided because it's not used.
    LoadVar(index 0);                    // 2  myAsyncFunc    ./test/end-to-end/tests/async-await.test.mvm.js:48:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:48:3
    Call(count 1, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:48:3
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:49:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:49:3
    Literal(lit 'After async synchronous return'); // 4       ./test/end-to-end/tests/async-await.test.mvm.js:49:9
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:49:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:54:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:54:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:54:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:51:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:51:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:51:3
    LoadGlobal(name 'print');            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:52:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:52:5
    Literal(lit 'Inside async function'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:52:11
    Call(count 2, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:52:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:53:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:53:4
}

// Tests awaiting a JS async function which completes immediately with a return
// value. This tests basic await-call and that the return value is used
// correctly. Also the result is scheduled on the job queue.
function test_awaitReturnValue() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:60:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:60:1
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:60:1
    Literal(lit &function asyncFunction); // 4                ./test/end-to-end/tests/async-await.test.mvm.js:60:40
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:60:40
    LoadVar(index 3);                    // 6  asyncFunction  ./test/end-to-end/tests/async-await.test.mvm.js:61:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:61:24
    Literal(lit 22);                     // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:61:38
    AwaitCall(count 2);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:61:38
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:61:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:61:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:61:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:62:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:62:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await.test.mvm.js:62:15
    Literal(lit 23);                     // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:62:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:62:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:67:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:67:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:67:2
}

function asyncFunction() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:64:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:64:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:64:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:64:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:64:3
    LoadScoped(index 3);                 // 4  arg            ./test/end-to-end/tests/async-await.test.mvm.js:65:12
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:65:18
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:65:18
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:65:5
}

function test_asyncVariablesFromNested() {
  entry:
    AsyncStart(count 11, flag false);    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:69:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:69:1
    StoreScoped(index 7);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:69:1
    Literal(lit &function nested2);      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:69:48
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:69:48
    StoreScoped(index 8);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:69:48
    Literal(lit deleted);                // 4  x2             ./test/end-to-end/tests/async-await.test.mvm.js:69:48
    // This function tests that variables in an async function can be accessed
    // correctly from a nested closure.
    // Variable in root
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:74:12
    StoreScoped(index 9);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:74:12
    // closure-accessed
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:75:12
    StoreVar(index 3);                   // 4  x2             ./test/end-to-end/tests/async-await.test.mvm.js:75:12
    // local-accessed
    StartTry(@block3);                   // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:76:7
    Literal(lit &function nestedFunc);   // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:76:7
    ClosureNew();                        // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:76:7
    Literal(lit deleted);                // 8  y2             ./test/end-to-end/tests/async-await.test.mvm.js:76:7
    // Variable nested in try block.
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:78:14
    StoreScoped(index 10);               // 8  y1             ./test/end-to-end/tests/async-await.test.mvm.js:78:14
    // closure-accessed
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:79:14
    StoreVar(index 7);                   // 8  y2             ./test/end-to-end/tests/async-await.test.mvm.js:79:14
    // local accessed
    LoadVar(index 6);                    // 9  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:81:11
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:81:11
    AwaitCall(count 1);                  // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:81:11
    Await();                             // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:81:5
    AsyncResume(count 5, count 4);       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:81:5
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:81:5
    LoadScoped(index 9);                 // 9  x1             ./test/end-to-end/tests/async-await.test.mvm.js:83:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:83:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:83:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:83:11
    StoreScoped(index 9);                // 9  x1             ./test/end-to-end/tests/async-await.test.mvm.js:83:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:83:11
    LoadScoped(index 10);                // 9  y1             ./test/end-to-end/tests/async-await.test.mvm.js:84:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:84:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:84:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:84:11
    StoreScoped(index 10);               // 9  y1             ./test/end-to-end/tests/async-await.test.mvm.js:84:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:84:11
    LoadVar(index 3);                    // 9  x2             ./test/end-to-end/tests/async-await.test.mvm.js:85:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:85:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:85:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:85:11
    StoreVar(index 3);                   // 9  x2             ./test/end-to-end/tests/async-await.test.mvm.js:85:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:85:11
    LoadVar(index 7);                    // 9  y2             ./test/end-to-end/tests/async-await.test.mvm.js:86:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:86:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:86:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:86:11
    StoreVar(index 7);                   // 9  y2             ./test/end-to-end/tests/async-await.test.mvm.js:86:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:86:11
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:88:5
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:88:5
    LoadScoped(index 10);                // 11 y1             ./test/end-to-end/tests/async-await.test.mvm.js:88:17
    Literal(lit 12155);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:88:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:88:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:89:5
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:89:5
    LoadVar(index 7);                    // 11 y2             ./test/end-to-end/tests/async-await.test.mvm.js:89:17
    Literal(lit 77);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:89:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:89:21
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:98:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:98:4
  block3:
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:98:11
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:99:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:99:10
    StoreScoped(index 9);                // 5  x1             ./test/end-to-end/tests/async-await.test.mvm.js:99:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:99:10
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:100:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:100:10
    StoreVar(index 3);                   // 5  x2             ./test/end-to-end/tests/async-await.test.mvm.js:100:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:100:10
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:101:4
  block4:
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:103:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:103:3
    LoadScoped(index 9);                 // 7  x1             ./test/end-to-end/tests/async-await.test.mvm.js:103:15
    Literal(lit 92378);                  // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:103:19
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:103:19
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:104:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:104:3
    LoadVar(index 3);                    // 7  x2             ./test/end-to-end/tests/async-await.test.mvm.js:104:15
    Literal(lit 33);                     // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:104:19
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:104:19
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:109:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:109:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:109:2
}

function nested2() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:106:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:106:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:106:3
    LoadScoped(index 15);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:107:5
    Literal(lit 19);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:107:11
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:107:11
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:107:11
    StoreScoped(index 15);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:107:11
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:107:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:108:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:108:4
}

function nestedFunc() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:91:5
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:91:5
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:91:5
    LoadScoped(index 15);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:92:7
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:92:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:92:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:92:13
    StoreScoped(index 15);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:92:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:92:13
    LoadScoped(index 16);                // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:93:7
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:93:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:93:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:93:13
    StoreScoped(index 16);               // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:93:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:93:13
    LoadScoped(index 14);                // 4  nested2        ./test/end-to-end/tests/async-await.test.mvm.js:94:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:94:13
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:94:13
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:94:7
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:94:7
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:94:7
    LoadScoped(index 15);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:95:7
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:95:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:95:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:95:13
    StoreScoped(index 15);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:95:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:95:13
    LoadScoped(index 16);                // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:96:7
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:96:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:96:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:96:13
    StoreScoped(index 16);               // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:96:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:96:13
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:97:6
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:97:6
}

function test_asyncInExpression() {
  entry:
    AsyncStart(count 12, flag false);    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:111:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:111:1
    StoreScoped(index 11);               // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:111:1
    Literal(lit &function nestedFunc1);  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:111:41
    Literal(lit &function nestedFunc2);  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:111:41
    Literal(lit &function nestedFunc3);  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:111:41
    Literal(lit deleted);                // 7  x              ./test/end-to-end/tests/async-await.test.mvm.js:111:41
    Literal(lit deleted);                // 8  y              ./test/end-to-end/tests/async-await.test.mvm.js:111:41
    // Here the array literal is a temporary pushed to the stack and then each
    // element is awaited in turn. This tests that the temporary is correctly
    // restored after each await point.
    ArrayNew();                          // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:115:13
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:115:13
    Literal(lit 0);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:115:13
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:116:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:116:5
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:116:5
    Literal(lit 1);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:116:5
    LoadVar(index 3);                    // 12 nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:117:11
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:117:11
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:117:11
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:117:5
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:117:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:117:5
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:117:5
    Literal(lit 2);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:117:5
    LoadVar(index 4);                    // 12 nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:118:11
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:118:11
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:118:11
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:118:5
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:118:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:118:5
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:118:5
    Literal(lit 3);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:118:5
    Literal(lit 11);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:119:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:119:5
    StoreVar(index 6);                   // 8  x              ./test/end-to-end/tests/async-await.test.mvm.js:119:5
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:122:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:122:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:122:15
    Literal(lit 'length');               // 12                ./test/end-to-end/tests/async-await.test.mvm.js:122:15
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:122:15
    Literal(lit 4);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:122:25
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:122:25
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:123:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:123:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:123:15
    Literal(lit 0);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:123:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:123:17
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:123:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:123:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:124:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:124:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:124:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:124:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:124:17
    Literal(lit 5);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:124:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:124:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:125:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:125:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:125:15
    Literal(lit 2);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:125:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:125:17
    Literal(lit 7);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:125:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:125:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:126:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:126:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:126:15
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:126:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:126:17
    Literal(lit 11);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:126:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:126:21
    // Similarly here the function call involves pushing the arguments to the
    // stack as temporaries, so this tests that the stack is correctly restored
    // after each await point.
    LoadVar(index 5);                    // 9  nestedFunc3    ./test/end-to-end/tests/async-await.test.mvm.js:131:19
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:131:19
    Literal(lit 3);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:131:31
    LoadVar(index 3);                    // 12 nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:131:40
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:131:40
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:131:40
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:131:34
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:131:34
    LoadVar(index 4);                    // 13 nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:131:60
    Literal(lit undefined);              // 14                ./test/end-to-end/tests/async-await.test.mvm.js:131:60
    AwaitCall(count 1);                  // 13                ./test/end-to-end/tests/async-await.test.mvm.js:131:60
    Await();                             // 12                ./test/end-to-end/tests/async-await.test.mvm.js:131:54
    AsyncResume(count 9, count 11);      // 13                ./test/end-to-end/tests/async-await.test.mvm.js:131:54
    Literal(lit 11);                     // 14                ./test/end-to-end/tests/async-await.test.mvm.js:131:75
    AwaitCall(count 5);                  // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:131:75
    Await();                             // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:131:13
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:131:13
    StoreVar(index 7);                   // 8  y              ./test/end-to-end/tests/async-await.test.mvm.js:131:13
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:132:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:132:3
    LoadVar(index 7);                    // 11 y              ./test/end-to-end/tests/async-await.test.mvm.js:132:15
    Literal(lit 26);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:132:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:132:18
    Pop(count 5);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:145:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:145:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:145:2
}

function nestedFunc1() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:135:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:135:5
}

function nestedFunc2() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:138:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:138:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:138:3
    Literal(lit 7);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:139:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:139:5
}

function nestedFunc3() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    LoadArg(index 3);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    StoreScoped(index 5);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    LoadArg(index 4);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    StoreScoped(index 6);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    LoadScoped(index 3);                 // 4  a              ./test/end-to-end/tests/async-await.test.mvm.js:143:12
    LoadScoped(index 4);                 // 5  b              ./test/end-to-end/tests/async-await.test.mvm.js:143:16
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:143:16
    LoadScoped(index 5);                 // 5  c              ./test/end-to-end/tests/async-await.test.mvm.js:143:20
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:143:20
    LoadScoped(index 6);                 // 5  d              ./test/end-to-end/tests/async-await.test.mvm.js:143:24
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:143:24
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:143:5
}

function test_asyncFunctionArguments() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:147:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:147:1
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:147:1
    Literal(lit &function nestedFunc4);  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:147:46
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:147:46
    Literal(lit &function nestedFunc5);  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:147:46
    StoreScoped(index 4);                // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:147:46
    // This function tests that function arguments are correctly captured by
    // async functions.
    LoadVar(index 3);                    // 5  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:150:9
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:150:9
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:150:20
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:150:23
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:150:26
    AwaitCall(count 4);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:150:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:150:3
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:150:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:150:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:164:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:164:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:164:2
}

function nestedFunc4() {
  entry:
    AsyncStart(count 7, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    LoadArg(index 3);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    StoreScoped(index 5);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:152:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:153:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:153:5
    LoadScoped(index 3);                 // 6  a              ./test/end-to-end/tests/async-await.test.mvm.js:153:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:153:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:153:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:154:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:154:5
    LoadScoped(index 4);                 // 6  b              ./test/end-to-end/tests/async-await.test.mvm.js:154:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:154:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:154:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:155:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:155:5
    LoadScoped(index 5);                 // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:155:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:155:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:155:20
    LoadScoped(index 13);                // 4  nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:156:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:156:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:156:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:156:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:156:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:156:5
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:157:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:157:5
    LoadScoped(index 3);                 // 6  a              ./test/end-to-end/tests/async-await.test.mvm.js:157:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:157:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:157:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:158:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:158:5
    LoadScoped(index 4);                 // 6  b              ./test/end-to-end/tests/async-await.test.mvm.js:158:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:158:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:158:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:159:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:159:5
    LoadScoped(index 5);                 // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:159:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:159:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:159:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:160:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:160:4
}

function nestedFunc5() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:162:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:162:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:162:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:163:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:163:4
}

function test_asyncThisArgument() {
  entry:
    AsyncStart(count 6, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:166:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:166:1
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:166:1
    Literal(lit &function nestedFunc6);  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:166:41
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:166:41
    Literal(lit &function nestedFunc7);  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:166:41
    StoreScoped(index 5);                // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:166:41
    Literal(lit deleted);                // 5  obj            ./test/end-to-end/tests/async-await.test.mvm.js:166:41
    ObjectNew();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:167:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:167:15
    Literal(lit 'a');                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:167:15
    Literal(lit 3);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:168:8
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:168:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:168:8
    Literal(lit 'b');                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:168:8
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:169:8
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:169:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:169:8
    Literal(lit 'nestedFunc');           // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:169:8
    LoadVar(index 3);                    // 9  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:170:5
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:170:5
    StoreVar(index 4);                   // 5  obj            ./test/end-to-end/tests/async-await.test.mvm.js:170:5
    // This function tests that function arguments are correctly captured by
    // async functions.
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:174:3
    LoadVar(index 4);                    // 7  obj            ./test/end-to-end/tests/async-await.test.mvm.js:174:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:174:9
    Literal(lit 'nestedFunc');           // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:174:9
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:174:9
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:174:9
    Literal(lit 7);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:174:24
    AwaitCall(count 2);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:174:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:174:3
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:174:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:174:3
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:188:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:188:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:188:2
}

function nestedFunc6() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:176:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:176:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:176:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:176:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:176:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:177:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:177:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:177:17
    Literal(lit 'a');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:177:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:177:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:177:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:177:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:178:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:178:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:178:17
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:178:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:178:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:178:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:178:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:179:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:179:5
    LoadScoped(index 3);                 // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:179:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:179:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:179:20
    LoadScoped(index 12);                // 4  nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:180:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:180:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:180:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:180:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:180:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:180:5
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:181:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:181:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:181:17
    Literal(lit 'a');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:181:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:181:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:181:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:181:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:182:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:182:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:182:17
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:182:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:182:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:182:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:182:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:183:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:183:5
    LoadScoped(index 3);                 // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:183:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:183:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:183:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:184:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:184:4
}

function nestedFunc7() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:186:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:186:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:186:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:187:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:187:4
}

function test_asyncArrowFunctions() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:190:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:190:1
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:190:1
    Literal(lit &function nestedFunc8);  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:190:43
    StoreScoped(index 5);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:190:43
    Literal(lit deleted);                // 4  func           ./test/end-to-end/tests/async-await.test.mvm.js:190:43
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:190:43
    Literal(lit 4);                      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:191:11
    StoreScoped(index 6);                // 5  c              ./test/end-to-end/tests/async-await.test.mvm.js:191:11
    Literal(lit &function anonymous);    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:192:16
    ClosureNew();                        // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:192:16
    StoreVar(index 3);                   // 5  func           ./test/end-to-end/tests/async-await.test.mvm.js:192:16
    LoadVar(index 3);                    // 6  func           ./test/end-to-end/tests/async-await.test.mvm.js:197:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:197:24
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:197:29
    Literal(lit 2);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:197:32
    AwaitCall(count 3);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:197:32
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:197:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:197:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:197:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:198:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:198:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await.test.mvm.js:198:15
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:198:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:198:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:202:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:202:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:202:2
}

function nestedFunc8() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:200:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:200:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:200:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:201:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:201:4
}

function anonymous() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:192:16
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:192:16
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:192:16
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:192:16
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:192:16
    LoadScoped(index 12);                // 4  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:193:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:193:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:193:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:193:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:193:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:193:5
    LoadScoped(index 2);                 // 4  a              ./test/end-to-end/tests/async-await.test.mvm.js:194:12
    LoadScoped(index 3);                 // 5  b              ./test/end-to-end/tests/async-await.test.mvm.js:194:16
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:194:16
    LoadScoped(index 13);                // 5  c              ./test/end-to-end/tests/async-await.test.mvm.js:194:20
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:194:20
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:194:5
}

function test_implicitReturn() {
  entry:
    AsyncStart(count 12, flag false);    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:204:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:204:1
    StoreScoped(index 10);               // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:204:1
    Literal(lit &function implicitReturn1); // 4              ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    Literal(lit &function explicitReturn1); // 5              ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    Literal(lit &function implicitReturn2); // 6              ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    ClosureNew();                        // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    Literal(lit &function explicitReturn2); // 7              ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    ClosureNew();                        // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    Literal(lit &function nestedFunc9);  // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    StoreScoped(index 11);               // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    Literal(lit deleted);                // 8  result1        ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    Literal(lit deleted);                // 9  result2        ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    Literal(lit deleted);                // 10 result3        ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    Literal(lit deleted);                // 11 result4        ./test/end-to-end/tests/async-await.test.mvm.js:204:38
    LoadVar(index 3);                    // 12 implicitReturn1 ./test/end-to-end/tests/async-await.test.mvm.js:205:25
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:205:25
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:205:25
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:205:19
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:205:19
    StoreVar(index 7);                   // 11 result1        ./test/end-to-end/tests/async-await.test.mvm.js:205:19
    LoadVar(index 4);                    // 12 explicitReturn1 ./test/end-to-end/tests/async-await.test.mvm.js:206:25
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:206:25
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:206:25
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:206:19
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:206:19
    StoreVar(index 8);                   // 11 result2        ./test/end-to-end/tests/async-await.test.mvm.js:206:19
    LoadVar(index 5);                    // 12 implicitReturn2 ./test/end-to-end/tests/async-await.test.mvm.js:207:25
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:207:25
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:207:25
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:207:19
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:207:19
    StoreVar(index 9);                   // 11 result3        ./test/end-to-end/tests/async-await.test.mvm.js:207:19
    LoadVar(index 6);                    // 12 explicitReturn2 ./test/end-to-end/tests/async-await.test.mvm.js:208:25
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:208:25
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:208:25
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:208:19
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:208:19
    StoreVar(index 10);                  // 11 result4        ./test/end-to-end/tests/async-await.test.mvm.js:208:19
    LoadGlobal(name 'assertEqual');      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:209:3
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:209:3
    LoadVar(index 7);                    // 14 result1        ./test/end-to-end/tests/async-await.test.mvm.js:209:15
    Literal(lit undefined);              // 15                ./test/end-to-end/tests/async-await.test.mvm.js:209:24
    Call(count 3, flag true);            // 11                ./test/end-to-end/tests/async-await.test.mvm.js:209:24
    LoadGlobal(name 'assertEqual');      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:210:3
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:210:3
    LoadVar(index 8);                    // 14 result2        ./test/end-to-end/tests/async-await.test.mvm.js:210:15
    Literal(lit 1);                      // 15                ./test/end-to-end/tests/async-await.test.mvm.js:210:24
    Call(count 3, flag true);            // 11                ./test/end-to-end/tests/async-await.test.mvm.js:210:24
    LoadGlobal(name 'assertEqual');      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:211:3
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:211:3
    LoadVar(index 9);                    // 14 result3        ./test/end-to-end/tests/async-await.test.mvm.js:211:15
    Literal(lit undefined);              // 15                ./test/end-to-end/tests/async-await.test.mvm.js:211:24
    Call(count 3, flag true);            // 11                ./test/end-to-end/tests/async-await.test.mvm.js:211:24
    LoadGlobal(name 'assertEqual');      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:212:3
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:212:3
    LoadVar(index 10);                   // 14 result4        ./test/end-to-end/tests/async-await.test.mvm.js:212:15
    Literal(lit 2);                      // 15                ./test/end-to-end/tests/async-await.test.mvm.js:212:24
    Call(count 3, flag true);            // 11                ./test/end-to-end/tests/async-await.test.mvm.js:212:24
    Pop(count 8);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:232:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:232:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:232:2
}

function implicitReturn1() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:214:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:214:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:214:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:215:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:215:4
}

function explicitReturn1() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:217:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:217:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:217:3
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:218:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:218:5
}

function implicitReturn2() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:221:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:221:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:221:3
    LoadScoped(index 17);                // 4  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:222:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:222:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:222:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:222:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:222:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:222:5
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:223:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:223:4
}

function explicitReturn2() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:225:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:225:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:225:3
    LoadScoped(index 17);                // 4  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:226:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:226:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:226:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:226:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:226:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:226:5
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:227:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:227:5
}

function nestedFunc9() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:230:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:230:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:230:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:231:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:231:4
}

function test_asyncClosure() {
  entry:
    AsyncStart(count 8, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:234:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:234:1
    StoreScoped(index 5);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:234:1
    Literal(lit &function method);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:234:36
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:234:36
    Literal(lit &function nestedFunc10); // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:234:36
    StoreScoped(index 6);                // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:234:36
    Literal(lit deleted);                // 5  obj            ./test/end-to-end/tests/async-await.test.mvm.js:234:36
    Literal(lit deleted);                // 6  result         ./test/end-to-end/tests/async-await.test.mvm.js:234:36
    Literal(lit 4);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:235:11
    StoreScoped(index 7);                // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:235:11
    ObjectNew();                         // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:236:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:236:15
    Literal(lit 'd');                    // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:236:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await.test.mvm.js:237:8
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:237:8
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:237:8
    Literal(lit 'method');               // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:237:8
    LoadVar(index 3);                    // 10 method         ./test/end-to-end/tests/async-await.test.mvm.js:238:5
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:238:5
    StoreVar(index 4);                   // 6  obj            ./test/end-to-end/tests/async-await.test.mvm.js:238:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:250:24
    LoadVar(index 4);                    // 8  obj            ./test/end-to-end/tests/async-await.test.mvm.js:250:24
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:250:24
    Literal(lit 'method');               // 10                ./test/end-to-end/tests/async-await.test.mvm.js:250:24
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:250:24
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:250:24
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:250:24
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:250:24
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:250:37
    Literal(lit 2);                      // 10                ./test/end-to-end/tests/async-await.test.mvm.js:250:40
    AwaitCall(count 3);                  // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:250:40
    Await();                             // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:250:18
    AsyncResume(count 3, count 5);       // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:250:18
    StoreVar(index 5);                   // 6  result         ./test/end-to-end/tests/async-await.test.mvm.js:250:18
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:251:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:251:3
    LoadVar(index 5);                    // 9  result         ./test/end-to-end/tests/async-await.test.mvm.js:251:15
    Literal(lit 18);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:251:23
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:251:23
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:255:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:255:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:255:2
}

function method() {
  entry:
    ScopePush(count 3);                  // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:241:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:241:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:241:3
    // captures c and `this`.
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:243:12
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:243:12
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:243:12
    // captures c and `this`.
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:243:5
}

function anonymous1() {
  entry:
    AsyncStart(count 6, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:243:12
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:243:12
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:243:12
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:243:12
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:243:12
    Literal(lit deleted);                // 4  e              ./test/end-to-end/tests/async-await.test.mvm.js:243:28
    Literal(lit 6);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:244:15
    StoreVar(index 3);                   // 4  e              ./test/end-to-end/tests/async-await.test.mvm.js:244:15
    LoadScoped(index 17);                // 5  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:245:13
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:245:13
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:245:13
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:245:7
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:245:7
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:245:7
    LoadScoped(index 3);                 // 5  a              ./test/end-to-end/tests/async-await.test.mvm.js:246:14
    LoadScoped(index 4);                 // 6  b              ./test/end-to-end/tests/async-await.test.mvm.js:246:18
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:246:18
    LoadScoped(index 18);                // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:246:22
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:246:22
    LoadScoped(index 7);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:246:26
    Literal(lit 'd');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:246:26
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:246:26
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:246:26
    LoadVar(index 3);                    // 6  e              ./test/end-to-end/tests/async-await.test.mvm.js:246:35
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:246:35
    AsyncReturn();                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:246:7
}

function nestedFunc10() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:253:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:253:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:253:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:254:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:254:4
}

function test_syncClosureInAsync() {
  entry:
    AsyncStart(count 8, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:257:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:257:1
    StoreScoped(index 6);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:257:1
    Literal(lit &function method1);      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:257:42
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:257:42
    Literal(lit &function nestedFunc11); // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:257:42
    Literal(lit deleted);                // 6  obj            ./test/end-to-end/tests/async-await.test.mvm.js:257:42
    Literal(lit deleted);                // 7  f              ./test/end-to-end/tests/async-await.test.mvm.js:257:42
    // Among other things, this tests that the `return` statement in the closure
    // isn't picked up as an async-return, even though it's lexically inside an
    // async function.
    Literal(lit 4);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:262:11
    StoreScoped(index 7);                // 7  c              ./test/end-to-end/tests/async-await.test.mvm.js:262:11
    ObjectNew();                         // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:263:15
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:263:15
    Literal(lit 'd');                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:263:15
    Literal(lit 5);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:264:8
    ObjectSet();                         // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:264:8
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:264:8
    Literal(lit 'method');               // 10                ./test/end-to-end/tests/async-await.test.mvm.js:264:8
    LoadVar(index 3);                    // 11 method         ./test/end-to-end/tests/async-await.test.mvm.js:265:5
    ObjectSet();                         // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:265:5
    StoreVar(index 5);                   // 7  obj            ./test/end-to-end/tests/async-await.test.mvm.js:265:5
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:276:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:276:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:276:15
    LoadVar(index 5);                    // 11 obj            ./test/end-to-end/tests/async-await.test.mvm.js:276:15
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await.test.mvm.js:276:15
    Literal(lit 'method');               // 13                ./test/end-to-end/tests/async-await.test.mvm.js:276:15
    ObjectGet();                         // 12                ./test/end-to-end/tests/async-await.test.mvm.js:276:15
    StoreVar(index 9);                   // 11                ./test/end-to-end/tests/async-await.test.mvm.js:276:15
    Call(count 1, flag false);           // 10                ./test/end-to-end/tests/async-await.test.mvm.js:276:15
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await.test.mvm.js:276:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:276:28
    Literal(lit 2);                      // 13                ./test/end-to-end/tests/async-await.test.mvm.js:276:31
    Call(count 3, flag false);           // 10                ./test/end-to-end/tests/async-await.test.mvm.js:276:31
    Literal(lit 18);                     // 11                ./test/end-to-end/tests/async-await.test.mvm.js:276:35
    Call(count 3, flag true);            // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:276:35
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:277:13
    LoadVar(index 5);                    // 9  obj            ./test/end-to-end/tests/async-await.test.mvm.js:277:13
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:277:13
    Literal(lit 'method');               // 11                ./test/end-to-end/tests/async-await.test.mvm.js:277:13
    ObjectGet();                         // 10                ./test/end-to-end/tests/async-await.test.mvm.js:277:13
    StoreVar(index 7);                   // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:277:13
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:277:13
    StoreVar(index 6);                   // 7  f              ./test/end-to-end/tests/async-await.test.mvm.js:277:13
    LoadVar(index 4);                    // 8  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:278:9
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:278:9
    AwaitCall(count 1);                  // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:278:9
    Await();                             // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:278:3
    AsyncResume(count 4, count 6);       // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:278:3
    Pop(count 1);                        // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:278:3
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:279:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:279:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:279:15
    LoadVar(index 5);                    // 11 obj            ./test/end-to-end/tests/async-await.test.mvm.js:279:15
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await.test.mvm.js:279:15
    Literal(lit 'method');               // 13                ./test/end-to-end/tests/async-await.test.mvm.js:279:15
    ObjectGet();                         // 12                ./test/end-to-end/tests/async-await.test.mvm.js:279:15
    StoreVar(index 9);                   // 11                ./test/end-to-end/tests/async-await.test.mvm.js:279:15
    Call(count 1, flag false);           // 10                ./test/end-to-end/tests/async-await.test.mvm.js:279:15
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await.test.mvm.js:279:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:279:28
    Literal(lit 2);                      // 13                ./test/end-to-end/tests/async-await.test.mvm.js:279:31
    Call(count 3, flag false);           // 10                ./test/end-to-end/tests/async-await.test.mvm.js:279:31
    Literal(lit 18);                     // 11                ./test/end-to-end/tests/async-await.test.mvm.js:279:35
    Call(count 3, flag true);            // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:279:35
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:280:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:280:3
    LoadVar(index 6);                    // 10 f              ./test/end-to-end/tests/async-await.test.mvm.js:280:15
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await.test.mvm.js:280:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:280:17
    Literal(lit 3);                      // 13                ./test/end-to-end/tests/async-await.test.mvm.js:280:20
    Call(count 3, flag false);           // 10                ./test/end-to-end/tests/async-await.test.mvm.js:280:20
    Literal(lit 19);                     // 11                ./test/end-to-end/tests/async-await.test.mvm.js:280:24
    Call(count 3, flag true);            // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:280:24
    Pop(count 4);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:284:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:284:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:284:2
}

function method1() {
  entry:
    ScopePush(count 3);                  // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:268:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:268:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:268:3
    // captures c and `this`.
    Literal(lit &function anonymous2);   // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:270:12
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:270:12
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:270:12
    // captures c and `this`.
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:270:5
}

function anonymous2() {
  entry:
    Literal(lit deleted);                // 1  e              ./test/end-to-end/tests/async-await.test.mvm.js:270:22
    Literal(lit 6);                      // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:271:15
    StoreVar(index 0);                   // 1  e              ./test/end-to-end/tests/async-await.test.mvm.js:271:15
    LoadArg(index 1);                    // 2  a              ./test/end-to-end/tests/async-await.test.mvm.js:272:14
    LoadArg(index 2);                    // 3  b              ./test/end-to-end/tests/async-await.test.mvm.js:272:18
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:272:18
    LoadScoped(index 12);                // 3  c              ./test/end-to-end/tests/async-await.test.mvm.js:272:22
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:272:22
    LoadScoped(index 1);                 // 3  this           ./test/end-to-end/tests/async-await.test.mvm.js:272:26
    Literal(lit 'd');                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:272:26
    ObjectGet();                         // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:272:26
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:272:26
    LoadVar(index 0);                    // 3  e              ./test/end-to-end/tests/async-await.test.mvm.js:272:35
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:272:35
    Return();                            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:272:7
}

function nestedFunc11() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:282:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:282:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:282:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:283:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:283:4
}

function test_exceptionsBasic() {
  entry:
    AsyncStart(count 6, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:286:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:286:1
    StoreScoped(index 5);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:286:1
    Literal(lit &function nestedFunc12); // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:286:39
    StartTry(@block5);                   // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:287:7
    LoadVar(index 3);                    // 7  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:288:11
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:288:11
    AwaitCall(count 1);                  // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:288:11
    Await();                             // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:288:5
    AsyncResume(count 3, count 2);       // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:288:5
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:288:5
    LoadGlobal(name 'assert');           // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:289:5
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:289:5
    Literal(lit false);                  // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:289:12
    Call(count 2, flag true);            // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:289:12
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:290:4
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:290:4
  block5:
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:291:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:291:5
    LoadVar(index 4);                    // 8  e              ./test/end-to-end/tests/async-await.test.mvm.js:291:17
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:291:20
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:291:20
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:292:4
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:292:4
  block6:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:297:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:297:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:297:2
}

function nestedFunc12() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:294:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:294:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:294:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:295:11
    Throw();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:295:11
}

function test_exceptionsNested() {
  entry:
    AsyncStart(count 12, flag false);    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:299:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:299:1
    StoreScoped(index 10);               // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:299:1
    Literal(lit &function nestedFunc13); // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:299:40
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:299:40
    Literal(lit &function nestedFunc14); // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:299:40
    StoreScoped(index 11);               // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:299:40
    Literal(lit deleted);                // 5  x              ./test/end-to-end/tests/async-await.test.mvm.js:299:40
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:300:11
    StoreVar(index 4);                   // 5  x              ./test/end-to-end/tests/async-await.test.mvm.js:300:11
    StartTry(@block11);                  // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:301:7
    Literal(lit deleted);                // 8  y              ./test/end-to-end/tests/async-await.test.mvm.js:301:7
    Literal(lit 3);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:302:13
    StoreVar(index 7);                   // 8  y              ./test/end-to-end/tests/async-await.test.mvm.js:302:13
    StartTry(@block9);                   // 10                ./test/end-to-end/tests/async-await.test.mvm.js:303:9
    LoadVar(index 4);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:304:7
    LoadVar(index 7);                    // 12 y              ./test/end-to-end/tests/async-await.test.mvm.js:304:12
    BinOp(op '*');                       // 11                ./test/end-to-end/tests/async-await.test.mvm.js:304:12
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await.test.mvm.js:304:12
    StoreVar(index 4);                   // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:304:12
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await.test.mvm.js:304:12
    LoadVar(index 4);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:305:7
    LoadVar(index 3);                    // 12 nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:305:18
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:305:18
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:305:18
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:305:12
    AsyncResume(count 8, count 3);       // 12                ./test/end-to-end/tests/async-await.test.mvm.js:305:12
    BinOp(op '*');                       // 11                ./test/end-to-end/tests/async-await.test.mvm.js:305:12
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await.test.mvm.js:305:12
    StoreVar(index 4);                   // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:305:12
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await.test.mvm.js:305:12
    EndTry();                            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:306:6
    Jump(@block10);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:306:6
  block9:
    LoadVar(index 4);                    // 10 x              ./test/end-to-end/tests/async-await.test.mvm.js:307:7
    LoadVar(index 8);                    // 11 e              ./test/end-to-end/tests/async-await.test.mvm.js:307:12
    BinOp(op '*');                       // 10                ./test/end-to-end/tests/async-await.test.mvm.js:307:12
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/async-await.test.mvm.js:307:12
    StoreVar(index 4);                   // 10 x              ./test/end-to-end/tests/async-await.test.mvm.js:307:12
    Pop(count 1);                        // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:307:12
    LoadVar(index 4);                    // 10 x              ./test/end-to-end/tests/async-await.test.mvm.js:308:7
    LoadVar(index 7);                    // 11 y              ./test/end-to-end/tests/async-await.test.mvm.js:308:12
    BinOp(op '*');                       // 10                ./test/end-to-end/tests/async-await.test.mvm.js:308:12
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/async-await.test.mvm.js:308:12
    StoreVar(index 4);                   // 10 x              ./test/end-to-end/tests/async-await.test.mvm.js:308:12
    Pop(count 1);                        // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:308:12
    // Check that y is intact on the stack between the 2 catch blocks.
    // This throw should be caught by the outer catch block if the catch stack
    // is correctly restored.
    Literal(lit 7);                      // 10                ./test/end-to-end/tests/async-await.test.mvm.js:311:13
    Throw();                             // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:311:13
  block10:
    EndTry();                            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:313:4
    Jump(@block12);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:313:4
  block11:
    LoadVar(index 4);                    // 7  x              ./test/end-to-end/tests/async-await.test.mvm.js:314:5
    LoadVar(index 5);                    // 8  e              ./test/end-to-end/tests/async-await.test.mvm.js:314:10
    BinOp(op '*');                       // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:314:10
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:314:10
    StoreVar(index 4);                   // 7  x              ./test/end-to-end/tests/async-await.test.mvm.js:314:10
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:314:10
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:315:4
    Jump(@block12);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:315:4
  block12:
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:316:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:316:3
    LoadVar(index 4);                    // 8  x              ./test/end-to-end/tests/async-await.test.mvm.js:316:15
    Literal(lit 630);                    // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:316:18
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:316:18
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:330:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:330:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:330:2
}

function nestedFunc13() {
  entry:
    AsyncStart(count 6, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:318:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:318:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:318:3
    StartTry(@block7);                   // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:319:9
    LoadScoped(index 19);                // 6  nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:320:13
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:320:13
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:320:13
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:320:7
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:320:7
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:320:7
    // This time trying throw after await
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:322:13
    Throw();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:322:13
  block7:
    LoadVar(index 3);                    // 5  e              ./test/end-to-end/tests/async-await.test.mvm.js:324:13
    Throw();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:324:13
  block8:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:326:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:326:4
}

function nestedFunc14() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:328:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:328:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:328:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:329:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:329:4
}

function test_multipleJobs() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:332:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:332:1
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:332:1
    Literal(lit &function task1);        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:332:36
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:332:36
    Literal(lit &function task2);        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:332:36
    ClosureNew();                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:332:36
    Literal(lit &function nestedFunc15); // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:332:36
    StoreScoped(index 5);                // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:332:36
    // This function tests the engine can handle multiple jobs in the job queue
    // simultaneously.
    // nestedFunc completes immediately which should schedule the caller to
    // continue in the job queue. So `task1` will put one job in the queue, and
    // `task2` will put another. Then the parent waits for the job queue to flush
    // and checks the result.
    Literal(lit 'Start');                // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:341:11
    StoreScoped(index 6);                // 5  s              ./test/end-to-end/tests/async-await.test.mvm.js:341:11
    LoadVar(index 3);                    // 6  task1          ./test/end-to-end/tests/async-await.test.mvm.js:343:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:343:3
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:343:3
    LoadVar(index 4);                    // 6  task2          ./test/end-to-end/tests/async-await.test.mvm.js:344:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:344:3
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:344:3
    LoadScoped(index 6);                 // 6  s              ./test/end-to-end/tests/async-await.test.mvm.js:346:3
    Literal(lit ';End');                 // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:346:8
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:346:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:346:8
    StoreScoped(index 6);                // 6  s              ./test/end-to-end/tests/async-await.test.mvm.js:346:8
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:346:8
    LoadScoped(index 5);                 // 6  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:348:9
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:348:9
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:348:9
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:348:3
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:348:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:348:3
    // Wait for job queue
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:350:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:350:3
    LoadScoped(index 6);                 // 8  s              ./test/end-to-end/tests/async-await.test.mvm.js:350:15
    Literal(lit 'Start;End;Job1;Job2');  // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:350:18
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:350:18
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:362:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:362:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:362:2
}

function task1() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:352:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:352:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:352:3
    LoadScoped(index 11);                // 4  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:353:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:353:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:353:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:353:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:353:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:353:5
    LoadScoped(index 12);                // 4  s              ./test/end-to-end/tests/async-await.test.mvm.js:354:5
    Literal(lit ';Job1');                // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:354:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:354:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:354:10
    StoreScoped(index 12);               // 4  s              ./test/end-to-end/tests/async-await.test.mvm.js:354:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:354:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:355:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:355:4
}

function task2() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:356:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:356:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:356:3
    LoadScoped(index 11);                // 4  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:357:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:357:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:357:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:357:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:357:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:357:5
    LoadScoped(index 12);                // 4  s              ./test/end-to-end/tests/async-await.test.mvm.js:358:5
    Literal(lit ';Job2');                // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:358:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:358:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:358:10
    StoreScoped(index 12);               // 4  s              ./test/end-to-end/tests/async-await.test.mvm.js:358:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:358:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:359:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:359:4
}

function nestedFunc15() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:360:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:360:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:360:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:361:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:361:4
}

function test_nestedClosure() {
  entry:
    AsyncStart(count 6, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:364:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:364:1
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:364:1
    Literal(lit &function func1);        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:364:37
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:364:37
    Literal(lit &function nestedFunc16); // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:364:37
    StoreScoped(index 4);                // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:364:37
    // This tests that the parent references in async closures are correct, and
    // the static analysis properly indexes the variables.
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:368:11
    StoreScoped(index 5);                // 4  x              ./test/end-to-end/tests/async-await.test.mvm.js:368:11
    LoadVar(index 3);                    // 5  func1          ./test/end-to-end/tests/async-await.test.mvm.js:369:9
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:369:9
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:369:9
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:369:3
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:369:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:369:3
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:370:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:370:3
    LoadScoped(index 5);                 // 7  x              ./test/end-to-end/tests/async-await.test.mvm.js:370:15
    Literal(lit 8);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:370:18
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:370:18
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:391:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:391:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:391:2
}

function func1() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:372:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:372:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:372:3
    Literal(lit &function func2);        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:372:26
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:372:26
    LoadVar(index 3);                    // 5  func2          ./test/end-to-end/tests/async-await.test.mvm.js:373:11
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:373:11
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:373:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:373:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:373:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:373:5
    LoadScoped(index 11);                // 5  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:374:11
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:374:11
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:374:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:374:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:374:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:374:5
    LoadVar(index 3);                    // 5  func2          ./test/end-to-end/tests/async-await.test.mvm.js:375:11
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:375:11
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:375:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:375:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:375:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:375:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:387:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:387:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:387:4
}

function func2() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:376:5
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:376:5
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:376:5
    Literal(lit &function func3);        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:376:28
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:376:28
    LoadVar(index 3);                    // 5  func3          ./test/end-to-end/tests/async-await.test.mvm.js:377:13
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:377:13
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:377:13
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:377:7
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:377:7
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:377:7
    LoadScoped(index 18);                // 5  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:378:13
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:378:13
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:378:13
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:378:7
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:378:7
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:378:7
    LoadVar(index 3);                    // 5  func3          ./test/end-to-end/tests/async-await.test.mvm.js:379:13
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:379:13
    AwaitCall(count 1);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:379:13
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:379:7
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:379:7
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:379:7
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:386:6
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:386:6
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:386:6
}

function func3() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:381:7
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:381:7
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:381:7
    LoadScoped(index 25);                // 4  x              ./test/end-to-end/tests/async-await.test.mvm.js:382:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:382:9
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:382:9
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:382:9
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:382:9
    StoreScoped(index 25);               // 5  x              ./test/end-to-end/tests/async-await.test.mvm.js:382:9
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:382:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:382:9
    LoadScoped(index 24);                // 4  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:383:15
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:383:15
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:383:15
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:383:9
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:383:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:383:9
    LoadScoped(index 25);                // 4  x              ./test/end-to-end/tests/async-await.test.mvm.js:384:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:384:9
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:384:9
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:384:9
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:384:9
    StoreScoped(index 25);               // 5  x              ./test/end-to-end/tests/async-await.test.mvm.js:384:9
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:384:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:384:9
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:385:8
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:385:8
}

function nestedFunc16() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:389:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:389:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:389:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:390:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:390:4
}