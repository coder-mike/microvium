unit ['./test/end-to-end/tests/async-await-promise.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external asyncTestComplete from free-variable 'asyncTestComplete';
external undefined from free-variable 'undefined';
external assert from free-variable 'assert';
external Promise from free-variable 'Promise';
external Reflect from free-variable 'Reflect';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global Error;
global runAsync;
global test_asyncReturnsPromise;
global myAsyncFunc;
global test_promiseKeys;
global test_promiseAwait;
global test_promiseAwaitReject;
global myAsyncFuncReject;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function runAsync);     // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'runAsync');        // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_asyncReturnsPromise); // 2     ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_asyncReturnsPromise'); // 1        ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function myAsyncFunc);  // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'myAsyncFunc');     // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_promiseKeys); // 2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_promiseKeys'); // 1                ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_promiseAwait); // 2            ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_promiseAwait'); // 1               ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_promiseAwaitReject); // 2      ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_promiseAwaitReject'); // 1         ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function myAsyncFuncReject); // 2            ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'myAsyncFuncReject'); // 1               ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality with promises
    // assertionCount: 6
    // isAsync: true
    // # testOnly: true
    // # skip: true
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:13
    Literal(lit &function Error);        // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:1
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:1
    ClassCreate();                       // 2  Error          ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:1
    StoreGlobal(name 'Error');           // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:1
    LoadGlobal(name 'Error');            // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:1
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:1
    ObjectNew();                         // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:1
    ObjectSet();                         // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:1
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:1
}

function Error() {
  entry:
    LoadArg(index 1);                    // 1  message        ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:53
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:38
    Literal(lit 'message');              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:38
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:38
    ObjectSet();                         // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:38
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:38
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:63
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:11:63
}

function run() {
  entry:
    // Void-call async function
    LoadGlobal(name 'runAsync');         // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:15:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:15:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:16:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:16:2
}

function runAsync() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:18:1
    StartTry(@block1);                   // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:19:7
    LoadGlobal(name 'test_asyncReturnsPromise'); // 6         ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:5
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:5
    LoadGlobal(name 'test_promiseKeys'); // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:21:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:21:5
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:21:5
    LoadGlobal(name 'test_promiseAwait'); // 6                ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:5
    LoadGlobal(name 'test_promiseAwaitReject'); // 6          ./test/end-to-end/tests/async-await-promise.test.mvm.js:23:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:23:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:23:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:23:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:23:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:23:5
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:2
}

function test_asyncReturnsPromise() {
  entry:
    Literal(lit deleted);                // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:37
    LoadGlobal(name 'myAsyncFunc');      // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:19
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:19
    Call(count 1, flag false);           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:19
    StoreVar(index 0);                   // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:19
    LoadGlobal(name 'assert');           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:3
    LoadVar(index 0);                    // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:10
    Literal(lit '__proto__');            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:10
    LoadGlobal(name 'Promise');          // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:32
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:32
    ObjectGet();                         // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:32
    BinOp(op '===');                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:32
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:1
    Literal(lit 42);                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:37:10
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:37:3
}

function test_promiseKeys() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:35
    Literal(lit deleted);                // 5  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:35
    Literal(lit deleted);                // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:35
    LoadGlobal(name 'myAsyncFunc');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:19
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:19
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:19
    StoreVar(index 3);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:16
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:16
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:16
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:16
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:16
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:16
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:32
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:32
    StoreVar(index 4);                   // 6  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:32
    // Even though the promise has 2 internal slots, which occupy the first
    // key-value pair slot, it should still have no own properties since the
    // the key used for internal slots is not a valid property key.
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:3
    LoadVar(index 4);                    // 9  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:28
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:28
    // Reflect.ownKeys is ignoring the internal slots but should not ignore the
    // properties that follow the internal slots
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:18
    LoadVar(index 3);                    // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:3
    Literal(lit 'prop');                 // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:3
    LoadVar(index 6);                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:3
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:17
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:17
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:17
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:17
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:17
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:17
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:33
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:33
    StoreVar(index 5);                   // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:33
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:15
    Literal(lit 1);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:29
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:29
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:21
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:21
    Literal(lit 'prop');                 // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:25
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:25
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:2
}

function test_promiseAwait() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:36
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:36
    LoadGlobal(name 'myAsyncFunc');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:19
    StoreVar(index 3);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:19
    LoadVar(index 3);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:15
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:2
}

function test_promiseAwaitReject() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:42
    LoadGlobal(name 'myAsyncFuncReject'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:19
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:19
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:19
    StoreVar(index 3);                   // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:19
    StartTry(@block3);                   // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:64:7
    LoadVar(index 3);                    // 7  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:11
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:5
    AsyncResume(count 3, count 2);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:5
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:5
    LoadGlobal(name 'assert');           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:5
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:5
    Literal(lit false);                  // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:12
    Literal(lit 'promise should have rejected'); // 10        ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:19
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:19
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:4
  block3:
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:5
    LoadVar(index 4);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:17
    Literal(lit 'message');              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:17
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:17
    Literal(lit '42');                   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:28
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:4
  block4:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:2
}

function myAsyncFuncReject() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:1
    LoadGlobal(name 'Error');            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:13
    Literal(lit '42');                   // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:19
    New(count 2);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:19
    Throw();                             // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:19
}