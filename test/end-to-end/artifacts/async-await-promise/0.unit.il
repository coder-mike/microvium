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
global test_unresolvedPromise1Subscriber;
global test_unresolvedPromise2Subscribers;
global test_unresolvedPromise3Subscribers;
global test_awaitBeforeAndAfterResolved;
global test_awaitUnrejected;

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
    Literal(lit &function test_unresolvedPromise1Subscriber); // 2  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_unresolvedPromise1Subscriber'); // 1  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_unresolvedPromise2Subscribers); // 2  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_unresolvedPromise2Subscribers'); // 1  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_unresolvedPromise3Subscribers); // 2  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_unresolvedPromise3Subscribers'); // 1  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_awaitBeforeAndAfterResolved); // 2  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_awaitBeforeAndAfterResolved'); // 1  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_awaitUnrejected); // 2         ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_awaitUnrejected'); // 1            ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality with promises
    // assertionCount: 21
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
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:1
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
    LoadGlobal(name 'test_unresolvedPromise1Subscriber'); // 6  ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:26:5
    LoadGlobal(name 'test_unresolvedPromise2Subscribers'); // 6  ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:27:5
    LoadGlobal(name 'test_unresolvedPromise3Subscribers'); // 6  ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:28:5
    LoadGlobal(name 'test_awaitBeforeAndAfterResolved'); // 6  ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:29:5
    LoadGlobal(name 'test_awaitUnrejected'); // 6             ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:30:5
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:33:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:2
}

function test_asyncReturnsPromise() {
  entry:
    Literal(lit deleted);                // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:38:37
    LoadGlobal(name 'myAsyncFunc');      // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:19
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:19
    Call(count 1, flag false);           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:19
    StoreVar(index 0);                   // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:39:19
    LoadGlobal(name 'assert');           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:3
    LoadVar(index 0);                    // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:10
    Literal(lit '__proto__');            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:10
    LoadGlobal(name 'Promise');          // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:32
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:32
    ObjectGet();                         // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:32
    BinOp(op '===');                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:32
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:1
    Literal(lit 42);                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:10
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:44:3
}

function test_promiseKeys() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:35
    Literal(lit deleted);                // 5  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:35
    Literal(lit deleted);                // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:47:35
    LoadGlobal(name 'myAsyncFunc');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:19
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:19
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:19
    StoreVar(index 3);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:48:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:16
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:16
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:16
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:16
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:16
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:16
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:32
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:32
    StoreVar(index 4);                   // 6  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:32
    // Even though the promise has 2 internal slots, which occupy the first
    // key-value pair slot, it should still have no own properties since the
    // the key used for internal slots is not a valid property key.
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:3
    LoadVar(index 4);                    // 9  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:28
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:53:28
    // Reflect.ownKeys is ignoring the internal slots but should not ignore the
    // properties that follow the internal slots
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:18
    LoadVar(index 3);                    // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:3
    Literal(lit 'prop');                 // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:3
    LoadVar(index 6);                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:3
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:57:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:17
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:17
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:17
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:17
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:17
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:17
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:33
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:33
    StoreVar(index 5);                   // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:58:33
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:15
    Literal(lit 1);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:29
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:29
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:21
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:21
    Literal(lit 'prop');                 // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:25
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:25
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:2
}

function test_promiseAwait() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:36
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:36
    LoadGlobal(name 'myAsyncFunc');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:64:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:64:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:64:19
    StoreVar(index 3);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:64:19
    LoadVar(index 3);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:15
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:2
}

function test_promiseAwaitReject() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:42
    LoadGlobal(name 'myAsyncFuncReject'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:19
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:19
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:19
    StoreVar(index 3);                   // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:70:19
    StartTry(@block3);                   // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:71:7
    LoadVar(index 3);                    // 7  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:11
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:5
    AsyncResume(count 3, count 2);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:5
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:5
    LoadGlobal(name 'assert');           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:5
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:5
    Literal(lit false);                  // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:12
    Literal(lit 'promise should have rejected'); // 10        ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:19
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:19
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:74:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:74:4
  block3:
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:5
    LoadVar(index 4);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:17
    Literal(lit 'message');              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:17
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:17
    Literal(lit '42');                   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:28
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:76:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:76:4
  block4:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:2
}

function myAsyncFuncReject() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:79:1
    LoadGlobal(name 'Error');            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:13
    Literal(lit '42');                   // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:19
    New(count 2);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:19
    Throw();                             // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:80:19
}

function test_awaitMustBeAsynchronous() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:83:1
    Literal(lit &function inner);        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:83:47
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:83:47
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:83:47
    Literal(lit 'Start');                // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:84:11
    StoreScoped(index 4);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:84:11
    LoadVar(index 3);                    // 6  inner          ./test/end-to-end/tests/async-await-promise.test.mvm.js:85:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:85:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:85:19
    StoreVar(index 4);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:85:19
    // No await - should not block
    LoadScoped(index 4);                 // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:3
    Literal(lit '; After inner()');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:8
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:8
    StoreScoped(index 4);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:8
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:8
    LoadVar(index 4);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:87:9
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:87:3
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:87:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:87:3
    // The key here is that "After inner" should come before "After await",
    // because even though myAsyncFunc resolves immediately, the continuation
    // should be scheduled asynchronously.
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:3
    LoadScoped(index 4);                 // 8  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:15
    Literal(lit 'Start; Before await; After inner(); After await'); // 9  ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:18
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:91:18
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:2
}

function inner() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:3
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:26
    LoadGlobal(name 'myAsyncFunc');      // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:94:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:94:21
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:94:21
    StoreVar(index 3);                   // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:94:21
    LoadScoped(index 10);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:95:5
    Literal(lit '; Before await');       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:95:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:95:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:95:10
    StoreScoped(index 10);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:95:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:95:10
    LoadVar(index 3);                    // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:5
    LoadScoped(index 10);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:5
    Literal(lit '; After await');        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    StoreScoped(index 10);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:4
}

function test_promiseConstructor() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:42
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:42
    LoadGlobal(name 'Promise');          // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:102:23
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:102:23
    Literal(lit &function anonymous);    // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:102:31
    New(count 2);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:102:31
    StoreVar(index 3);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:102:31
    LoadVar(index 3);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:105:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:105:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:105:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:105:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:106:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:106:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:106:15
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:106:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:106:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:107:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:107:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:107:2
}

function anonymous() {
  entry:
    LoadArg(index 1);                    // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:103:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:103:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:103:13
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:103:13
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:104:4
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:104:4
}

function test_unresolvedPromise1Subscriber() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:109:1
    Literal(lit &function subscriber1);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:109:52
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:109:52
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:109:52
    Literal(lit deleted);                // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:109:52
    Literal(lit 'Start');                // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:110:11
    StoreScoped(index 5);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:110:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:111:7
    StoreScoped(index 6);                // 6  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:111:7
    LoadGlobal(name 'Promise');          // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:23
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:23
    Literal(lit &function anonymous1);   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:31
    ClosureNew();                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:31
    New(count 2);                        // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:31
    StoreVar(index 4);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:31
    LoadVar(index 3);                    // 7  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:113:14
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:113:14
    LoadVar(index 4);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:113:26
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:113:26
    StoreVar(index 5);                   // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:113:26
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:15
    Literal(lit 'Start; Subscriber 1 started'); // 10         ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:18
    LoadScoped(index 6);                 // 7  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:116:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:116:3
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:116:11
    Call(count 2, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:116:11
    LoadVar(index 5);                    // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:9
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:3
    AsyncResume(count 3, count 5);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:3
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 finished with 42'); // 10  ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:18
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:2
}

function subscriber1() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:39
    LoadScoped(index 12);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:121:5
    Literal(lit '; Subscriber 1 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:121:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:121:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:121:10
    StoreScoped(index 12);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:121:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:121:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:122:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:122:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:122:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:122:20
    LoadScoped(index 12);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:5
    Literal(lit '; Subscriber 1 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:44
    StoreScoped(index 12);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:124:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:124:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:124:4
}

function anonymous1() {
  entry:
    LoadArg(index 1);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:46
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:46
    StoreScoped(index 8);                // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:46
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:46
}

function test_unresolvedPromise2Subscribers() {
  entry:
    AsyncStart(count 9, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:128:1
    Literal(lit &function subscriber2);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:128:53
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:128:53
    Literal(lit &function subscriber3);  // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:128:53
    ClosureNew();                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:128:53
    Literal(lit deleted);                // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:128:53
    Literal(lit deleted);                // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:128:53
    Literal(lit deleted);                // 8  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:128:53
    // The second subscriber triggers a code path where the subscriber list is
    // promoted from a closure to a list.
    Literal(lit 'Start');                // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:132:11
    StoreScoped(index 7);                // 8  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:132:11
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:133:7
    StoreScoped(index 8);                // 8  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:133:7
    LoadGlobal(name 'Promise');          // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:23
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:23
    Literal(lit &function anonymous2);   // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:31
    ClosureNew();                        // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:31
    New(count 2);                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:31
    StoreVar(index 5);                   // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:31
    LoadVar(index 3);                    // 9  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:135:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:135:14
    LoadVar(index 5);                    // 11 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:135:26
    Call(count 2, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:135:26
    StoreVar(index 6);                   // 8  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:135:26
    LoadVar(index 4);                    // 9  subscriber2    ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:14
    LoadVar(index 5);                    // 11 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:26
    Call(count 2, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:26
    StoreVar(index 7);                   // 8  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:26
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 2 started'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:18
    LoadScoped(index 8);                 // 9  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:139:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:139:3
    Literal(lit 42);                     // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:139:11
    Call(count 2, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:139:11
    LoadVar(index 6);                    // 9  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:9
    Await();                             // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:3
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:3
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:3
    LoadVar(index 7);                    // 9  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:141:9
    Await();                             // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:141:3
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:141:3
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:141:3
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 1 finished with 42; Subscriber 2 finished with 42'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:18
    Pop(count 5);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:2
}

function subscriber2() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:39
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:145:5
    Literal(lit '; Subscriber 1 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:145:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:145:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:145:10
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:145:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:145:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:146:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:146:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:146:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:146:20
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:5
    Literal(lit '; Subscriber 1 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:44
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:148:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:148:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:148:4
}

function subscriber3() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:150:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:150:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:150:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:150:39
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:151:5
    Literal(lit '; Subscriber 2 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:151:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:151:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:151:10
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:151:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:151:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:152:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:152:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:152:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:152:20
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:5
    Literal(lit '; Subscriber 2 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:44
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:154:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:154:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:154:4
}

function anonymous2() {
  entry:
    LoadArg(index 1);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:46
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:46
    StoreScoped(index 10);               // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:46
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:46
}

function test_unresolvedPromise3Subscribers() {
  entry:
    AsyncStart(count 11, flag false);    // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:1
    Literal(lit &function subscriber4);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    Literal(lit &function subscriber5);  // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    ClosureNew();                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    Literal(lit &function subscriber6);  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    ClosureNew();                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    Literal(lit deleted);                // 7  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    Literal(lit deleted);                // 8  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    Literal(lit deleted);                // 9  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    Literal(lit deleted);                // 10 p3             ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:53
    // Same as previous test but the subscriber list is already a list when
    // subscriber 3 is added.
    Literal(lit 'Start');                // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:161:11
    StoreScoped(index 9);                // 10 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:161:11
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:162:7
    StoreScoped(index 10);               // 10 resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:162:7
    LoadGlobal(name 'Promise');          // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:23
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:23
    Literal(lit &function anonymous3);   // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:31
    ClosureNew();                        // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:31
    New(count 2);                        // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:31
    StoreVar(index 6);                   // 10 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:31
    LoadVar(index 3);                    // 11 subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:164:14
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:164:14
    LoadVar(index 6);                    // 13 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:164:26
    Call(count 2, flag false);           // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:164:26
    StoreVar(index 7);                   // 10 p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:164:26
    LoadVar(index 4);                    // 11 subscriber2    ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:14
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:14
    LoadVar(index 6);                    // 13 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:26
    Call(count 2, flag false);           // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:26
    StoreVar(index 8);                   // 10 p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:26
    LoadVar(index 5);                    // 11 subscriber3    ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:14
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:14
    LoadVar(index 6);                    // 13 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:26
    Call(count 2, flag false);           // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:26
    StoreVar(index 9);                   // 10 p3             ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:26
    LoadGlobal(name 'assertEqual');      // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:3
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:3
    LoadScoped(index 9);                 // 13 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 3 started'); // 14  ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:18
    Call(count 3, flag true);            // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:18
    LoadScoped(index 10);                // 11 resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:169:3
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:169:3
    ObjectNew();                         // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:169:11
    LoadVar(index 12);                   // 14                ./test/end-to-end/tests/async-await-promise.test.mvm.js:169:11
    Literal(lit 'message');              // 15                ./test/end-to-end/tests/async-await-promise.test.mvm.js:169:11
    Literal(lit 'Hi');                   // 16                ./test/end-to-end/tests/async-await-promise.test.mvm.js:169:22
    ObjectSet();                         // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:169:22
    Call(count 2, flag true);            // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:169:22
    LoadVar(index 7);                    // 11 p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:9
    Await();                             // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:3
    AsyncResume(count 7, count 9);       // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:3
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:3
    LoadVar(index 8);                    // 11 p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:9
    Await();                             // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:3
    AsyncResume(count 7, count 9);       // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:3
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:3
    LoadVar(index 9);                    // 11 p3             ./test/end-to-end/tests/async-await-promise.test.mvm.js:172:9
    Await();                             // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:172:3
    AsyncResume(count 7, count 9);       // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:172:3
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:172:3
    LoadGlobal(name 'assertEqual');      // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:3
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:3
    LoadScoped(index 9);                 // 13 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 3 started; Subscriber 1 finished with Hi; Subscriber 2 finished with Hi; Subscriber 3 finished with Hi'); // 14  ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:18
    Call(count 3, flag true);            // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:18
    Pop(count 7);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:2
}

function subscriber4() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:39
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:176:5
    Literal(lit '; Subscriber 1 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:176:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:176:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:176:10
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:176:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:176:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:177:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:177:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:177:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:177:20
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:5
    Literal(lit '; Subscriber 1 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:44
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:179:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:179:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:179:4
}

function subscriber5() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:181:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:181:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:181:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:181:39
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:182:5
    Literal(lit '; Subscriber 2 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:182:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:182:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:182:10
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:182:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:182:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:183:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:183:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:183:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:183:20
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:5
    Literal(lit '; Subscriber 2 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:44
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:185:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:185:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:185:4
}

function subscriber6() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:187:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:187:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:187:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:187:39
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:188:5
    Literal(lit '; Subscriber 3 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:188:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:188:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:188:10
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:188:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:188:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:189:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:189:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:189:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:189:20
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:5
    Literal(lit '; Subscriber 3 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:44
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:191:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:191:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:191:4
}

function anonymous3() {
  entry:
    LoadArg(index 1);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:46
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:46
    StoreScoped(index 12);               // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:46
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:46
}

function test_awaitBeforeAndAfterResolved() {
  entry:
    AsyncStart(count 9, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:1
    Literal(lit &function subscriber7);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:51
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:51
    Literal(lit &function subscriber8);  // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:51
    ClosureNew();                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:51
    Literal(lit deleted);                // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:51
    Literal(lit deleted);                // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:51
    Literal(lit deleted);                // 8  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:51
    // The second subscriber only subscribes after the first promise has already
    // transitioned to resolved.
    Literal(lit 'Start');                // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:198:11
    StoreScoped(index 7);                // 8  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:198:11
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:199:7
    StoreScoped(index 8);                // 8  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:199:7
    LoadGlobal(name 'Promise');          // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:23
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:23
    Literal(lit &function anonymous4);   // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:31
    ClosureNew();                        // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:31
    New(count 2);                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:31
    StoreVar(index 5);                   // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:31
    LoadVar(index 3);                    // 9  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:201:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:201:14
    LoadVar(index 5);                    // 11 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:201:26
    Call(count 2, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:201:26
    StoreVar(index 6);                   // 8  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:201:26
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:15
    Literal(lit 'Start; Subscriber 1 started'); // 12         ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:18
    LoadScoped(index 8);                 // 9  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:204:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:204:3
    ArrayNew();                          // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:204:11
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:204:11
    Literal(lit 0);                      // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:204:11
    Literal(lit 42);                     // 14                ./test/end-to-end/tests/async-await-promise.test.mvm.js:204:12
    ObjectSet();                         // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:204:11
    Call(count 2, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:204:11
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:15
    Literal(lit 'Start; Subscriber 1 started'); // 12         ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:18
    LoadVar(index 6);                    // 9  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:9
    Await();                             // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:3
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:3
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:3
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:208:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:208:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:208:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 finished with 42'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:208:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:208:18
    LoadVar(index 4);                    // 9  subscriber2    ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:14
    LoadVar(index 5);                    // 11 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:26
    Call(count 2, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:26
    StoreVar(index 7);                   // 8  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:26
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:211:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:211:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:211:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 finished with 42; Subscriber 2 started'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:211:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:211:18
    LoadVar(index 7);                    // 9  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:9
    Await();                             // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:3
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:3
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:3
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 finished with 42; Subscriber 2 started; Subscriber 2 finished with 42'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:18
    Pop(count 5);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:2
}

function subscriber7() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:39
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:216:5
    Literal(lit '; Subscriber 1 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:216:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:216:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:216:10
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:216:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:216:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:217:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:217:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:217:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:217:20
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:5
    Literal(lit '; Subscriber 1 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:44
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:51
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:51
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:51
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:51
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:51
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:51
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:51
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:219:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:219:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:219:4
}

function subscriber8() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:221:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:221:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:221:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:221:39
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:222:5
    Literal(lit '; Subscriber 2 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:222:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:222:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:222:10
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:222:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:222:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:223:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:223:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:223:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:223:20
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:5
    Literal(lit '; Subscriber 2 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:44
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:51
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:51
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:51
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:51
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:51
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:51
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:51
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:225:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:225:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:225:4
}

function anonymous4() {
  entry:
    LoadArg(index 1);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:46
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:46
    StoreScoped(index 10);               // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:46
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:46
}

function test_awaitUnrejected() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:1
    Literal(lit &function subscriber9);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:39
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:39
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:39
    Literal(lit deleted);                // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:39
    Literal(lit 'Start');                // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:229:11
    StoreScoped(index 5);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:229:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:230:7
    StoreScoped(index 6);                // 6  reject         ./test/end-to-end/tests/async-await-promise.test.mvm.js:230:7
    LoadGlobal(name 'Promise');          // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:23
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:23
    Literal(lit &function anonymous5);   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:31
    ClosureNew();                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:31
    New(count 2);                        // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:31
    StoreVar(index 4);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:31
    LoadVar(index 3);                    // 7  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:232:14
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:232:14
    LoadVar(index 4);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:232:26
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:232:26
    StoreVar(index 5);                   // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:232:26
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:15
    Literal(lit 'Start; Subscriber 1 started'); // 10         ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:18
    LoadScoped(index 6);                 // 7  reject         ./test/end-to-end/tests/async-await-promise.test.mvm.js:235:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:235:3
    LoadGlobal(name 'Error');            // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:235:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:235:14
    Literal(lit 'dummy error');          // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:235:20
    New(count 2);                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:235:20
    Call(count 2, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:235:20
    LoadVar(index 5);                    // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:9
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:3
    AsyncResume(count 3, count 5);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:3
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 rejected with dummy error'); // 10  ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:18
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:248:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:248:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:248:2
}

function subscriber9() {
  entry:
    AsyncStart(count 6, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:239:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:239:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:239:3
    LoadScoped(index 13);                // 4  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:240:5
    Literal(lit '; Subscriber 1 started'); // 5               ./test/end-to-end/tests/async-await-promise.test.mvm.js:240:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:240:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:240:10
    StoreScoped(index 13);               // 4  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:240:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:240:10
    StartTry(@block5);                   // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:241:9
    LoadScoped(index 4);                 // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:13
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:7
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:7
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:7
    LoadScoped(index 13);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:243:7
    Literal(lit '; should not get here'); // 7                ./test/end-to-end/tests/async-await-promise.test.mvm.js:243:12
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:243:12
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:243:12
    StoreScoped(index 13);               // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:243:12
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:243:12
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:244:6
    Jump(@block6);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:244:6
  block5:
    LoadScoped(index 13);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:7
    Literal(lit '; Subscriber 1 rejected with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:12
    LoadVar(index 3);                    // 7  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:44
    StoreScoped(index 13);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:246:6
    Jump(@block6);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:246:6
  block6:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:4
}

function anonymous5() {
  entry:
    LoadArg(index 2);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:49
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:49
    StoreScoped(index 8);                // 1  reject         ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:49
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:49
}