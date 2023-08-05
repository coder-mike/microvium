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
global runAsync;
global test_asyncReturnsPromise;
global myAsyncFunc;
global test_promiseKeys;
global test_promiseAwait;

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
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality with promises
    // assertionCount: 5
    // isAsync: true
    // # testOnly: true
    // # skip: true
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:9:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:1
}

function run() {
  entry:
    // Void-call async function
    LoadGlobal(name 'runAsync');         // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:13:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:13:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:14:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:14:2
}

function runAsync() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:16:1
    StartTry(@block1);                   // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:17:7
    LoadGlobal(name 'test_asyncReturnsPromise'); // 6         ./test/end-to-end/tests/async-await-promise.test.mvm.js:18:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:18:5
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:18:5
    LoadGlobal(name 'test_promiseKeys'); // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:19:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:19:5
    Call(count 1, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:19:5
    LoadGlobal(name 'test_promiseAwait'); // 6                ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:20:5
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:22:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:23:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:23:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:24:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:25:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:2
}

function test_asyncReturnsPromise() {
  entry:
    Literal(lit deleted);                // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:37
    LoadGlobal(name 'myAsyncFunc');      // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:19
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:19
    Call(count 1, flag false);           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:19
    StoreVar(index 0);                   // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:19
    LoadGlobal(name 'assert');           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:3
    LoadVar(index 0);                    // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:10
    Literal(lit '__proto__');            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:10
    LoadGlobal(name 'Promise');          // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:32
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:32
    ObjectGet();                         // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:32
    BinOp(op '===');                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:32
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:1
    Literal(lit 42);                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:10
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:3
}

function test_promiseKeys() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:37:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:37:35
    Literal(lit deleted);                // 5  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:37:35
    Literal(lit deleted);                // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:37:35
    LoadGlobal(name 'myAsyncFunc');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:38:19
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:38:19
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:38:19
    StoreVar(index 3);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:38:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:16
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:16
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:16
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:16
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:16
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:16
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:32
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:32
    StoreVar(index 4);                   // 6  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:32
    // Even though the promise has 2 internal slots, which occupy the first
    // key-value pair slot, it should still have no own properties since the
    // the key used for internal slots is not a valid property key.
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:3
    LoadVar(index 4);                    // 9  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:28
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:28
    // Reflect.ownKeys is ignoring the internal slots but should not ignore the
    // properties that follow the internal slots
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:18
    LoadVar(index 3);                    // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:3
    Literal(lit 'prop');                 // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:3
    LoadVar(index 6);                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:3
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:17
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:17
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:17
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:17
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:17
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:17
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:33
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:33
    StoreVar(index 5);                   // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:33
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:15
    Literal(lit 1);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:29
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:29
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:21
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:21
    Literal(lit 'prop');                 // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:25
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:25
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:2
}

function test_promiseAwait() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:36
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:36
    LoadGlobal(name 'myAsyncFunc');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:19
    StoreVar(index 3);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:54:19
    LoadVar(index 3);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:15
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:56:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:2
}