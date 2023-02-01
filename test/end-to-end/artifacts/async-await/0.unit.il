unit ['./test/end-to-end/tests/async-await.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external asyncTestComplete from free-variable 'asyncTestComplete';
external undefined from free-variable 'undefined';
external assertEqual from free-variable 'assertEqual';
external hostAsyncFunction from free-variable 'hostAsyncFunction';

global thisModule;
global runAsync;
global test_minimal;
global test_await;
global test_awaitHost;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    AsyncStart(count 2, true);           // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function run);          // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function runAsync);     // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'runAsync');        // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_minimal); // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_minimal');    // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_await);   // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_await');      // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    Literal(lit &function test_awaitHost); // 5               ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    StoreGlobal(name 'test_awaitHost');  // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality
    // assertionCount: 3
    // isAsync: true
    // ---
    LoadGlobal(name 'vmExport');         // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:7:1
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:7:1
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:7:10
    LoadVar(index 3);                    // 8  run            ./test/end-to-end/tests/async-await.test.mvm.js:7:13
    Call(count 3, true);                 // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:7:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:53:1
    Return();                            // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:53:1
}

function run() {
  entry:
    // Void-call async function
    LoadGlobal(name 'runAsync');         // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:11:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:11:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:12:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:12:2
}

function runAsync() {
  entry:
    AsyncStart(count 2, true);           // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:14:1
    StartTry(@block1);                   // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:15:7
    LoadGlobal(name 'test_minimal');     // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:16:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:16:5
    Call(count 1, true);                 // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:16:5
    LoadGlobal(name 'test_await');       // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:17:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:17:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:17:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:17:11
    AsyncResume(count 2);                // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:17:11
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:17:11
    LoadGlobal(name 'test_awaitHost');   // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:18:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:18:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:18:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:18:11
    AsyncResume(count 2);                // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:18:11
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:18:11
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await.test.mvm.js:19:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:19:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:19:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:19:29
    Call(count 3, true);                 // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:19:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:20:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:20:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await.test.mvm.js:21:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:21:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:21:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await.test.mvm.js:21:30
    Call(count 3, true);                 // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:21:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:22:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:22:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:23:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:23:2
}

// *
 * Void-calling async function with no await points or variable bindings
function test_minimal() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:28:1
    Literal(lit &function myAsyncFunc);  // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:28:25
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:28:25
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:28:25
    Literal(lit '');                     // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:29:11
    StoreScoped(index 1);                // 1  s              ./test/end-to-end/tests/async-await.test.mvm.js:29:11
    // Void-calling async func (does not require promise support or job queue support)
    LoadScoped(index 1);                 // 2  s              ./test/end-to-end/tests/async-await.test.mvm.js:31:3
    Literal(lit 'Before async function'); // 3                ./test/end-to-end/tests/async-await.test.mvm.js:31:8
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:31:8
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:31:8
    StoreScoped(index 1);                // 2  s              ./test/end-to-end/tests/async-await.test.mvm.js:31:8
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:31:8
    LoadVar(index 0);                    // 2  myAsyncFunc    ./test/end-to-end/tests/async-await.test.mvm.js:32:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:32:3
    Call(count 1, true);                 // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:32:3
    LoadScoped(index 1);                 // 2  s              ./test/end-to-end/tests/async-await.test.mvm.js:33:3
    Literal(lit '\nAfter async synchronous return'); // 3     ./test/end-to-end/tests/async-await.test.mvm.js:33:8
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:33:8
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:33:8
    StoreScoped(index 1);                // 2  s              ./test/end-to-end/tests/async-await.test.mvm.js:33:8
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:33:8
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/async-await.test.mvm.js:34:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:34:3
    LoadScoped(index 1);                 // 4  s              ./test/end-to-end/tests/async-await.test.mvm.js:34:15
    Literal(lit 'Before async function\nInside async function\nAfter async synchronous return'); // 5  ./test/end-to-end/tests/async-await.test.mvm.js:34:18
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:34:18
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:39:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await.test.mvm.js:39:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await.test.mvm.js:39:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 3, true);           // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:36:3
    LoadScoped(index 4);                 // 4  s              ./test/end-to-end/tests/async-await.test.mvm.js:37:5
    Literal(lit '\nInside async function'); // 5              ./test/end-to-end/tests/async-await.test.mvm.js:37:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:37:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:37:10
    StoreScoped(index 4);                // 4  s              ./test/end-to-end/tests/async-await.test.mvm.js:37:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:37:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:38:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:38:4
}

// Tests awaiting a JS async function which completes immediately
function test_await() {
  entry:
    AsyncStart(count 2, true);           // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:43:1
    Literal(lit &function asyncFunction); // 4                ./test/end-to-end/tests/async-await.test.mvm.js:43:29
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:43:29
    LoadVar(index 3);                    // 6  asyncFunction  ./test/end-to-end/tests/async-await.test.mvm.js:44:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:44:24
    Literal(lit 22);                     // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:44:38
    AwaitCall(count 2);                  // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:44:38
    Await();                             // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:44:38
    AsyncResume(count 2);                // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:44:38
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await.test.mvm.js:44:38
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:45:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:45:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await.test.mvm.js:45:15
    Literal(lit 23);                     // 9                 ./test/end-to-end/tests/async-await.test.mvm.js:45:23
    Call(count 3, true);                 // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:45:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:50:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:50:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:50:2
}

function asyncFunction() {
  entry:
    AsyncStart(count 2, true);           // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:47:3
    LoadArg(index 1);                    // 4  arg            ./test/end-to-end/tests/async-await.test.mvm.js:48:12
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:48:18
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:48:18
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:48:18
}

// Tests awaiting a host async function
function test_awaitHost() {
  entry:
    AsyncStart(count 2, true);           // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:53:1
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await.test.mvm.js:53:33
    LoadGlobal(name 'hostAsyncFunction'); // 5                ./test/end-to-end/tests/async-await.test.mvm.js:54:24
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:54:24
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await.test.mvm.js:54:42
    AwaitCall(count 2);                  // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:54:42
    Await();                             // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:54:42
    AsyncResume(count 1);                // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:54:42
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await.test.mvm.js:54:42
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/async-await.test.mvm.js:55:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await.test.mvm.js:55:3
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await.test.mvm.js:55:15
    Literal(lit 6);                      // 8                 ./test/end-to-end/tests/async-await.test.mvm.js:55:23
    Call(count 3, true);                 // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:55:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:56:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await.test.mvm.js:56:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await.test.mvm.js:56:2
}