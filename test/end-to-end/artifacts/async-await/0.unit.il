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
global test_asyncVariablesFromNested;
global test_asyncInExpression;
global test_asyncFunctionArguments;
global test_asyncThisArgument;

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
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality
    // assertionCount: 23
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
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:158:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:158:1
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
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:29:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:29:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:29:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:29:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:29:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:30:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:30:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await.test.mvm.js:31:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:31:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:31:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await.test.mvm.js:31:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:31:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:32:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:32:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:33:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:33:2
}

// Void-calling async function with no await points or variable bindings.
function test_minimal() {
  entry:
    Literal(lit &function myAsyncFunc);  // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:36:25
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:37:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:37:3
    Literal(lit 'Before async function'); // 4                ./test/end-to-end/tests/async-await.test.mvm.js:37:9
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:37:9
    // Void-calling async func. It will complete synchronously and the promise
    // will be elided because it's not used.
    LoadVar(index 0);                    // 2  myAsyncFunc    ./test/end-to-end/tests/async-await.test.mvm.js:40:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:40:3
    Call(count 1, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:40:3
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:41:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:41:3
    Literal(lit 'After async synchronous return'); // 4       ./test/end-to-end/tests/async-await.test.mvm.js:41:9
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:41:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:46:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:46:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:46:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:43:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:43:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:43:3
    LoadGlobal(name 'print');            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:44:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:44:5
    Literal(lit 'Inside async function'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:44:11
    Call(count 2, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:44:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:45:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:45:4
}

// Tests awaiting a JS async function which completes immediately with a return
// value. This tests basic await-call and that the return value is used
// correctly. Also the result is scheduled on the job queue.
function test_awaitReturnValue() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:52:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:52:1
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:52:1
    Literal(lit &function asyncFunction); // 4                ./test/end-to-end/tests/async-await.test.mvm.js:52:40
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:52:40
    LoadVar(index 3);                    // 6  asyncFunction  ./test/end-to-end/tests/async-await.test.mvm.js:53:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:53:24
    Literal(lit 22);                     // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:53:38
    AwaitCall(count 2);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:53:38
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:53:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:53:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:53:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:54:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:54:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await.test.mvm.js:54:15
    Literal(lit 23);                     // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:54:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:54:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:59:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:59:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:59:2
}

function asyncFunction() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:56:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:56:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:56:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:56:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:56:3
    LoadScoped(index 3);                 // 4  arg            ./test/end-to-end/tests/async-await.test.mvm.js:57:12
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:57:18
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:57:18
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:57:5
}

function test_asyncVariablesFromNested() {
  entry:
    AsyncStart(count 11, flag false);    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:61:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:61:1
    StoreScoped(index 7);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:61:1
    Literal(lit &function nested2);      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:61:48
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:61:48
    StoreScoped(index 8);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:61:48
    Literal(lit deleted);                // 4  x2             ./test/end-to-end/tests/async-await.test.mvm.js:61:48
    // This function tests that variables in an async function can be accessed
    // correctly from a nested closure.
    // Variable in root
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:66:12
    StoreScoped(index 9);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:66:12
    // closure-accessed
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:67:12
    StoreVar(index 3);                   // 4  x2             ./test/end-to-end/tests/async-await.test.mvm.js:67:12
    // local-accessed
    StartTry(@block3);                   // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:68:7
    Literal(lit &function nestedFunc);   // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:68:7
    ClosureNew();                        // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:68:7
    Literal(lit deleted);                // 8  y2             ./test/end-to-end/tests/async-await.test.mvm.js:68:7
    // Variable nested in try block.
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:70:14
    StoreScoped(index 10);               // 8  y1             ./test/end-to-end/tests/async-await.test.mvm.js:70:14
    // closure-accessed
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:71:14
    StoreVar(index 7);                   // 8  y2             ./test/end-to-end/tests/async-await.test.mvm.js:71:14
    // local accessed
    LoadVar(index 6);                    // 9  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:73:11
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:73:11
    AwaitCall(count 1);                  // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:73:11
    Await();                             // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:73:5
    AsyncResume(count 5, count 4);       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:73:5
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:73:5
    LoadScoped(index 9);                 // 9  x1             ./test/end-to-end/tests/async-await.test.mvm.js:75:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:75:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:75:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:75:11
    StoreScoped(index 9);                // 9  x1             ./test/end-to-end/tests/async-await.test.mvm.js:75:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:75:11
    LoadScoped(index 10);                // 9  y1             ./test/end-to-end/tests/async-await.test.mvm.js:76:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:76:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:76:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:76:11
    StoreScoped(index 10);               // 9  y1             ./test/end-to-end/tests/async-await.test.mvm.js:76:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:76:11
    LoadVar(index 3);                    // 9  x2             ./test/end-to-end/tests/async-await.test.mvm.js:77:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:77:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:77:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:77:11
    StoreVar(index 3);                   // 9  x2             ./test/end-to-end/tests/async-await.test.mvm.js:77:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:77:11
    LoadVar(index 7);                    // 9  y2             ./test/end-to-end/tests/async-await.test.mvm.js:78:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:78:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:78:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:78:11
    StoreVar(index 7);                   // 9  y2             ./test/end-to-end/tests/async-await.test.mvm.js:78:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:78:11
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:80:5
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:80:5
    LoadScoped(index 10);                // 11 y1             ./test/end-to-end/tests/async-await.test.mvm.js:80:17
    Literal(lit 12155);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:80:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:80:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:81:5
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:81:5
    LoadVar(index 7);                    // 11 y2             ./test/end-to-end/tests/async-await.test.mvm.js:81:17
    Literal(lit 77);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:81:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:81:21
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:90:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:90:4
  block3:
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:90:11
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:91:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:91:10
    StoreScoped(index 9);                // 5  x1             ./test/end-to-end/tests/async-await.test.mvm.js:91:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:91:10
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:92:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:92:10
    StoreVar(index 3);                   // 5  x2             ./test/end-to-end/tests/async-await.test.mvm.js:92:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:92:10
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:93:4
  block4:
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:95:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:95:3
    LoadScoped(index 9);                 // 7  x1             ./test/end-to-end/tests/async-await.test.mvm.js:95:15
    Literal(lit 92378);                  // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:95:19
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:95:19
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:96:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:96:3
    LoadVar(index 3);                    // 7  x2             ./test/end-to-end/tests/async-await.test.mvm.js:96:15
    Literal(lit 33);                     // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:96:19
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:96:19
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:101:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:101:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:101:2
}

function nested2() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:98:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:98:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:98:3
    LoadScoped(index 15);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:99:5
    Literal(lit 19);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:99:11
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:99:11
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:99:11
    StoreScoped(index 15);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:99:11
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:99:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:100:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:100:4
}

function nestedFunc() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:83:5
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:83:5
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:83:5
    LoadScoped(index 15);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:84:7
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    StoreScoped(index 15);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    LoadScoped(index 16);                // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:85:7
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:85:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:85:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:85:13
    StoreScoped(index 16);               // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:85:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:85:13
    LoadScoped(index 14);                // 4  nested2        ./test/end-to-end/tests/async-await.test.mvm.js:86:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:86:13
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:86:13
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:86:7
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:86:7
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:86:7
    LoadScoped(index 15);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:87:7
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:87:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:87:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:87:13
    StoreScoped(index 15);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:87:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:87:13
    LoadScoped(index 16);                // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:88:7
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:88:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:88:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:88:13
    StoreScoped(index 16);               // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:88:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:88:13
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:89:6
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:89:6
}

function test_asyncInExpression() {
  entry:
    AsyncStart(count 12, flag false);    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:103:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:103:1
    StoreScoped(index 11);               // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:103:1
    Literal(lit &function nestedFunc1);  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:103:41
    Literal(lit &function nestedFunc2);  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:103:41
    Literal(lit &function nestedFunc3);  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:103:41
    Literal(lit deleted);                // 7  x              ./test/end-to-end/tests/async-await.test.mvm.js:103:41
    Literal(lit deleted);                // 8  y              ./test/end-to-end/tests/async-await.test.mvm.js:103:41
    // Here the array literal is a temporary pushed to the stack and then each
    // element is awaited in turn. This tests that the temporary is correctly
    // restored after each await point.
    ArrayNew();                          // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:107:13
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:107:13
    Literal(lit 0);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:107:13
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:108:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:108:5
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:108:5
    Literal(lit 1);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:108:5
    LoadVar(index 3);                    // 12 nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:109:11
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:109:11
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:109:11
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:109:5
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:109:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:109:5
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:109:5
    Literal(lit 2);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:109:5
    LoadVar(index 4);                    // 12 nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:110:11
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:110:11
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:110:11
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:110:5
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:110:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:110:5
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:110:5
    Literal(lit 3);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:110:5
    Literal(lit 11);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:111:5
    ObjectSet();                         // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:111:5
    StoreVar(index 6);                   // 8  x              ./test/end-to-end/tests/async-await.test.mvm.js:111:5
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:114:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:114:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:114:15
    Literal(lit 'length');               // 12                ./test/end-to-end/tests/async-await.test.mvm.js:114:15
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:114:15
    Literal(lit 4);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:114:25
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:114:25
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:115:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:115:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:115:15
    Literal(lit 0);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:115:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:115:17
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:115:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:115:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:116:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:116:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:116:15
    Literal(lit 1);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:116:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:116:17
    Literal(lit 5);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:116:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:116:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:117:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:117:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:117:15
    Literal(lit 2);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:117:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:117:17
    Literal(lit 7);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:117:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:117:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:118:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:118:3
    LoadVar(index 6);                    // 11 x              ./test/end-to-end/tests/async-await.test.mvm.js:118:15
    Literal(lit 3);                      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:118:17
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await.test.mvm.js:118:17
    Literal(lit 11);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:118:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:118:21
    // Similarly here the function call involves pushing the arguments to the
    // stack as temporaries, so this tests that the stack is correctly restored
    // after each await point.
    LoadVar(index 5);                    // 9  nestedFunc3    ./test/end-to-end/tests/async-await.test.mvm.js:123:19
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:123:19
    Literal(lit 3);                      // 11                ./test/end-to-end/tests/async-await.test.mvm.js:123:31
    LoadVar(index 3);                    // 12 nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:123:40
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/async-await.test.mvm.js:123:40
    AwaitCall(count 1);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:123:40
    Await();                             // 11                ./test/end-to-end/tests/async-await.test.mvm.js:123:34
    AsyncResume(count 8, count 10);      // 12                ./test/end-to-end/tests/async-await.test.mvm.js:123:34
    LoadVar(index 4);                    // 13 nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:123:60
    Literal(lit undefined);              // 14                ./test/end-to-end/tests/async-await.test.mvm.js:123:60
    AwaitCall(count 1);                  // 13                ./test/end-to-end/tests/async-await.test.mvm.js:123:60
    Await();                             // 12                ./test/end-to-end/tests/async-await.test.mvm.js:123:54
    AsyncResume(count 9, count 11);      // 13                ./test/end-to-end/tests/async-await.test.mvm.js:123:54
    Literal(lit 11);                     // 14                ./test/end-to-end/tests/async-await.test.mvm.js:123:75
    AwaitCall(count 5);                  // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:123:75
    Await();                             // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:123:13
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:123:13
    StoreVar(index 7);                   // 8  y              ./test/end-to-end/tests/async-await.test.mvm.js:123:13
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:124:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:124:3
    LoadVar(index 7);                    // 11 y              ./test/end-to-end/tests/async-await.test.mvm.js:124:15
    Literal(lit 26);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:124:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:124:18
    Pop(count 5);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:137:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:137:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:137:2
}

function nestedFunc1() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:126:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:126:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:126:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:127:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:127:5
}

function nestedFunc2() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:130:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:130:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:130:3
    Literal(lit 7);                      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:131:12
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:131:5
}

function nestedFunc3() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    LoadArg(index 3);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    StoreScoped(index 5);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    LoadArg(index 4);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    StoreScoped(index 6);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:134:3
    LoadScoped(index 3);                 // 4  a              ./test/end-to-end/tests/async-await.test.mvm.js:135:12
    LoadScoped(index 4);                 // 5  b              ./test/end-to-end/tests/async-await.test.mvm.js:135:16
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:135:16
    LoadScoped(index 5);                 // 5  c              ./test/end-to-end/tests/async-await.test.mvm.js:135:20
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:135:20
    LoadScoped(index 6);                 // 5  d              ./test/end-to-end/tests/async-await.test.mvm.js:135:24
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:135:24
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:135:5
}

function test_asyncFunctionArguments() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:139:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:139:1
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:139:1
    Literal(lit &function nestedFunc4);  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:139:46
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:139:46
    Literal(lit &function nestedFunc5);  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:139:46
    StoreScoped(index 4);                // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:139:46
    // This function tests that function arguments are correctly captured by
    // async functions.
    LoadVar(index 3);                    // 5  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:142:9
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:142:9
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:142:20
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:142:23
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:142:26
    AwaitCall(count 4);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:142:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:142:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:156:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:156:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:156:2
}

function nestedFunc4() {
  entry:
    AsyncStart(count 7, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    LoadArg(index 2);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    LoadArg(index 3);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    StoreScoped(index 5);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:144:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:145:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:145:5
    LoadScoped(index 3);                 // 6  a              ./test/end-to-end/tests/async-await.test.mvm.js:145:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:145:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:145:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:146:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:146:5
    LoadScoped(index 4);                 // 6  b              ./test/end-to-end/tests/async-await.test.mvm.js:146:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:146:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:146:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:147:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:147:5
    LoadScoped(index 5);                 // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:147:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:147:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:147:20
    LoadScoped(index 13);                // 4  nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:148:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:148:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:148:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:148:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:148:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:148:5
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:149:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:149:5
    LoadScoped(index 3);                 // 6  a              ./test/end-to-end/tests/async-await.test.mvm.js:149:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:149:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:149:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:150:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:150:5
    LoadScoped(index 4);                 // 6  b              ./test/end-to-end/tests/async-await.test.mvm.js:150:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:150:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:150:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:151:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:151:5
    LoadScoped(index 5);                 // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:151:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:151:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:151:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:152:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:152:4
}

function nestedFunc5() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:154:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:154:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:154:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:155:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:155:4
}

function test_asyncThisArgument() {
  entry:
    AsyncStart(count 6, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:158:1
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:158:1
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:158:1
    Literal(lit &function nestedFunc6);  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:158:41
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:158:41
    Literal(lit &function nestedFunc7);  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:158:41
    StoreScoped(index 5);                // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:158:41
    Literal(lit deleted);                // 5  obj            ./test/end-to-end/tests/async-await.test.mvm.js:158:41
    ObjectNew();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:159:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:159:15
    Literal(lit 'a');                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:159:15
    Literal(lit 3);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:160:8
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:160:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:160:8
    Literal(lit 'b');                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:160:8
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:161:8
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:161:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:161:8
    Literal(lit 'nestedFunc');           // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:161:8
    LoadVar(index 3);                    // 9  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:162:5
    ObjectSet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:162:5
    StoreVar(index 4);                   // 5  obj            ./test/end-to-end/tests/async-await.test.mvm.js:162:5
    // This function tests that function arguments are correctly captured by
    // async functions.
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:166:3
    LoadVar(index 4);                    // 7  obj            ./test/end-to-end/tests/async-await.test.mvm.js:166:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:166:9
    Literal(lit 'nestedFunc');           // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:166:9
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:166:9
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:166:9
    Literal(lit 7);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:166:24
    AwaitCall(count 2);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:166:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:166:3
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:166:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:166:3
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:180:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:180:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:180:2
}

function nestedFunc6() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:168:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:168:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:168:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:168:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:168:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:169:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:169:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:169:17
    Literal(lit 'a');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:169:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:169:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:169:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:169:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:170:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:170:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:170:17
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:170:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:170:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:170:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:170:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:171:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:171:5
    LoadScoped(index 3);                 // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:171:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:171:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:171:20
    LoadScoped(index 12);                // 4  nestedFunc2    ./test/end-to-end/tests/async-await.test.mvm.js:172:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:172:11
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:172:11
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:172:5
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:172:5
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:172:5
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:173:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:173:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:173:17
    Literal(lit 'a');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:173:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:173:17
    Literal(lit 3);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:173:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:173:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:174:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:174:5
    LoadScoped(index 2);                 // 6  this           ./test/end-to-end/tests/async-await.test.mvm.js:174:17
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:174:17
    ObjectGet();                         // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:174:17
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:174:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:174:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:175:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:175:5
    LoadScoped(index 3);                 // 6  c              ./test/end-to-end/tests/async-await.test.mvm.js:175:17
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:175:20
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:175:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:176:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:176:4
}

function nestedFunc7() {
  entry:
    AsyncStart(count 3, flag false);     // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:178:3
    LoadArg(index 0);                    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:178:3
    StoreScoped(index 2);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:178:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:179:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:179:4
}