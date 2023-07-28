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
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality
    // assertionCount: 5
    // isAsync: true
    // testOnly: true
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
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:57:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:57:1
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
    LoadGlobal(name 'test_asyncVariablesFromNested'); // 6    ./test/end-to-end/tests/async-await.test.mvm.js:24:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:24:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:24:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:24:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:24:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:24:5
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

function test_asyncVariablesFromNested() {
  entry:
    AsyncStart(count 10, flag false);    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:57:1
    Literal(lit &function nested2);      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:57:48
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:57:48
    StoreScoped(index 7);                // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:57:48
    Literal(lit deleted);                // 4  x2             ./test/end-to-end/tests/async-await.test.mvm.js:57:48
    // This function tests that variables in an async function can be accessed
    // correctly from a nested closure.
    // Variable in root
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:62:12
    StoreScoped(index 8);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:62:12
    // closure-accessed
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:63:12
    StoreVar(index 3);                   // 4  x2             ./test/end-to-end/tests/async-await.test.mvm.js:63:12
    // local-accessed
    StartTry(@block3);                   // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:64:7
    Literal(lit &function nestedFunc);   // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:64:7
    ClosureNew();                        // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:64:7
    Literal(lit deleted);                // 8  y2             ./test/end-to-end/tests/async-await.test.mvm.js:64:7
    // Variable nested in try block.
    Literal(lit 5);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:66:14
    StoreScoped(index 9);                // 8  y1             ./test/end-to-end/tests/async-await.test.mvm.js:66:14
    // closure-accessed
    Literal(lit 7);                      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:67:14
    StoreVar(index 7);                   // 8  y2             ./test/end-to-end/tests/async-await.test.mvm.js:67:14
    // local accessed
    LoadVar(index 6);                    // 9  nestedFunc     ./test/end-to-end/tests/async-await.test.mvm.js:69:11
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:69:11
    AwaitCall(count 1);                  // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:69:11
    Await();                             // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:69:5
    AsyncResume(count 5, count 4);       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:69:5
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:69:5
    LoadScoped(index 8);                 // 9  x1             ./test/end-to-end/tests/async-await.test.mvm.js:71:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:71:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:71:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:71:11
    StoreScoped(index 8);                // 9  x1             ./test/end-to-end/tests/async-await.test.mvm.js:71:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:71:11
    LoadScoped(index 9);                 // 9  y1             ./test/end-to-end/tests/async-await.test.mvm.js:72:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:72:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:72:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:72:11
    StoreScoped(index 9);                // 9  y1             ./test/end-to-end/tests/async-await.test.mvm.js:72:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:72:11
    LoadVar(index 3);                    // 9  x2             ./test/end-to-end/tests/async-await.test.mvm.js:73:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:73:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:73:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:73:11
    StoreVar(index 3);                   // 9  x2             ./test/end-to-end/tests/async-await.test.mvm.js:73:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:73:11
    LoadVar(index 7);                    // 9  y2             ./test/end-to-end/tests/async-await.test.mvm.js:74:5
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/async-await.test.mvm.js:74:11
    BinOp(op '*');                       // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:74:11
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/async-await.test.mvm.js:74:11
    StoreVar(index 7);                   // 9  y2             ./test/end-to-end/tests/async-await.test.mvm.js:74:11
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:74:11
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:76:5
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:76:5
    LoadScoped(index 9);                 // 11 y1             ./test/end-to-end/tests/async-await.test.mvm.js:76:17
    Literal(lit 12155);                  // 12                ./test/end-to-end/tests/async-await.test.mvm.js:76:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:76:21
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:77:5
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await.test.mvm.js:77:5
    LoadVar(index 7);                    // 11 y2             ./test/end-to-end/tests/async-await.test.mvm.js:77:17
    Literal(lit 77);                     // 12                ./test/end-to-end/tests/async-await.test.mvm.js:77:21
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:77:21
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:86:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:86:4
  block3:
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:86:11
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:87:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:87:10
    StoreScoped(index 8);                // 5  x1             ./test/end-to-end/tests/async-await.test.mvm.js:87:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:87:10
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:88:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:88:10
    StoreVar(index 3);                   // 5  x2             ./test/end-to-end/tests/async-await.test.mvm.js:88:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:88:10
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:89:4
  block4:
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:91:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:91:3
    LoadScoped(index 8);                 // 7  x1             ./test/end-to-end/tests/async-await.test.mvm.js:91:15
    Literal(lit 92378);                  // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:91:19
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:91:19
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:92:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:92:3
    LoadVar(index 3);                    // 7  x2             ./test/end-to-end/tests/async-await.test.mvm.js:92:15
    Literal(lit 33);                     // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:92:19
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:92:19
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:97:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:97:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:97:2
}

function nested2() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:94:3
    LoadScoped(index 13);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:95:5
    Literal(lit 19);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:95:11
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:95:11
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:95:11
    StoreScoped(index 13);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:95:11
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:95:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:96:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:96:4
}

function nestedFunc() {
  entry:
    AsyncStart(count 3, flag true);      // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:79:5
    LoadScoped(index 13);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:80:7
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:80:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:80:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:80:13
    StoreScoped(index 13);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:80:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:80:13
    LoadScoped(index 14);                // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:81:7
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:81:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:81:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:81:13
    StoreScoped(index 14);               // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:81:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:81:13
    LoadScoped(index 12);                // 4  nested2        ./test/end-to-end/tests/async-await.test.mvm.js:82:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:82:13
    AwaitCall(count 1);                  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:82:13
    Await();                             // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:82:7
    AsyncResume(count 0, count 2);       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:82:7
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:82:7
    LoadScoped(index 13);                // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:83:7
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:83:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:83:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:83:13
    StoreScoped(index 13);               // 4  x1             ./test/end-to-end/tests/async-await.test.mvm.js:83:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:83:13
    LoadScoped(index 14);                // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:84:7
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    BinOp(op '*');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    StoreScoped(index 14);               // 4  y1             ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:84:13
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:85:6
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:85:6
}