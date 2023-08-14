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
global test_awaitMustBeAsynchronous;
global test_promiseConstructor;

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
    Literal(lit &function test_awaitMustBeAsynchronous); // 2  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_awaitMustBeAsynchronous'); // 1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_promiseConstructor); // 2      ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_promiseConstructor'); // 1         ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality with promises
    // assertionCount: 8
    // isAsync: true
    // testOnly: false
    // skip: false
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
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:1
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
    LoadGlobal(name 'test_awaitMustBeAsynchronous'); // 6     ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:5
    LoadGlobal(name 'test_promiseConstructor'); // 6          ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:5
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:2
}

function test_asyncReturnsPromise() {
  entry:
    Literal(lit deleted);                // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:37
    LoadGlobal(name 'myAsyncFunc');      // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:19
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:19
    Call(count 1, flag false);           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:19
    StoreVar(index 0);                   // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:19
    LoadGlobal(name 'assert');           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:3
    LoadVar(index 0);                    // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:10
    Literal(lit '__proto__');            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:10
    LoadGlobal(name 'Promise');          // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:32
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:32
    ObjectGet();                         // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:32
    BinOp(op '===');                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:32
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:38:1
    Literal(lit 42);                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:10
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:3
}

function test_promiseKeys() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:35
    Literal(lit deleted);                // 5  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:35
    Literal(lit deleted);                // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:35
    LoadGlobal(name 'myAsyncFunc');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:19
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:19
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:19
    StoreVar(index 3);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:16
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:16
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:16
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:16
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:16
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:16
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:32
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:32
    StoreVar(index 4);                   // 6  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:32
    // Even though the promise has 2 internal slots, which occupy the first
    // key-value pair slot, it should still have no own properties since the
    // the key used for internal slots is not a valid property key.
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:3
    LoadVar(index 4);                    // 9  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:28
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:28
    // Reflect.ownKeys is ignoring the internal slots but should not ignore the
    // properties that follow the internal slots
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:18
    LoadVar(index 3);                    // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:3
    Literal(lit 'prop');                 // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:3
    LoadVar(index 6);                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:3
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:52:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:17
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:17
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:17
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:17
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:17
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:17
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:33
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:33
    StoreVar(index 5);                   // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:33
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:15
    Literal(lit 1);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:29
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:29
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:21
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:21
    Literal(lit 'prop');                 // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:25
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:25
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:2
}

function test_promiseAwait() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:36
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:36
    LoadGlobal(name 'myAsyncFunc');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:19
    StoreVar(index 3);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:19
    LoadVar(index 3);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:15
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:2
}

function test_promiseAwaitReject() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:64:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:64:42
    LoadGlobal(name 'myAsyncFuncReject'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:19
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:19
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:19
    StoreVar(index 3);                   // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:19
    StartTry(@block3);                   // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:7
    LoadVar(index 3);                    // 7  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:11
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:5
    AsyncResume(count 3, count 2);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:5
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:5
    LoadGlobal(name 'assert');           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:5
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:5
    Literal(lit false);                  // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:12
    Literal(lit 'promise should have rejected'); // 10        ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:19
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:19
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:4
  block3:
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:5
    LoadVar(index 4);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:17
    Literal(lit 'message');              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:17
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:17
    Literal(lit '42');                   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:28
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:71:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:71:4
  block4:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:2
}

function myAsyncFuncReject() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:74:1
    LoadGlobal(name 'Error');            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:13
    Literal(lit '42');                   // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:19
    New(count 2);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:19
    Throw();                             // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:19
}

function test_awaitMustBeAsynchronous() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:78:1
    Literal(lit &function inner);        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:78:47
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:78:47
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:78:47
    Literal(lit 'Start');                // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:79:11
    StoreScoped(index 4);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:79:11
    LoadVar(index 3);                    // 6  inner          ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:19
    StoreVar(index 4);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:19
    // No await - should not block
    LoadScoped(index 4);                 // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:81:3
    Literal(lit '; After inner()');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:81:8
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:81:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:81:8
    StoreScoped(index 4);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:81:8
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:81:8
    LoadVar(index 4);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:9
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:3
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:3
    // The key here is that "After inner" should come before "After await",
    // because even though myAsyncFunc resolves immediately, the continuation
    // should be scheduled asynchronously.
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:3
    LoadScoped(index 4);                 // 8  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:15
    Literal(lit 'Start; Before await; After inner(); After await'); // 9  ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:18
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:18
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:94:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:94:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:94:2
}

function inner() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:88:3
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:88:26
    LoadGlobal(name 'myAsyncFunc');      // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:89:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:89:21
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:89:21
    StoreVar(index 3);                   // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:89:21
    LoadScoped(index 10);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:90:5
    Literal(lit '; Before await');       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:90:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:90:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:90:10
    StoreScoped(index 10);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:90:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:90:10
    LoadVar(index 3);                    // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:5
    LoadScoped(index 10);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:92:5
    Literal(lit '; After await');        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:92:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:92:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:92:10
    StoreScoped(index 10);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:92:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:92:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:4
}

function test_promiseConstructor() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:42
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:42
    LoadGlobal(name 'Promise');          // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:23
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:23
    Literal(lit &function anonymous);    // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:31
    New(count 2);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:31
    StoreVar(index 3);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:31
    LoadVar(index 3);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:100:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:100:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:100:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:100:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:15
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:102:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:102:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:102:2
}

function anonymous() {
  entry:
    LoadArg(index 1);                    // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:13
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:13
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:4
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:4
}