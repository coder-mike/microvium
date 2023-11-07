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
global test_immediatelyRejectedPromise;
global test_augmentingPromisePrototype;

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
    Literal(lit &function test_immediatelyRejectedPromise); // 2  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_immediatelyRejectedPromise'); // 1  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    Literal(lit &function test_augmentingPromisePrototype); // 2  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    StoreGlobal(name 'test_augmentingPromisePrototype'); // 1  ./test/end-to-end/tests/async-await-promise.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // description: Tests async-await functionality with promises
    // assertionCount: 31
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
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:272:1
    Return();                            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:272:1
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
    LoadGlobal(name 'test_immediatelyRejectedPromise'); // 6  ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:31:5
    LoadGlobal(name 'test_augmentingPromisePrototype'); // 6  ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:11
    AwaitCall(count 1);                  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:11
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:5
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:5
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:32:5
    LoadGlobal(name 'asyncTestComplete'); // 6                ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:5
    Literal(lit true);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:23
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:29
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:34:29
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:35:4
  block1:
    LoadGlobal(name 'asyncTestComplete'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:5
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:5
    Literal(lit false);                  // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:23
    LoadVar(index 3);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:30
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:36:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:37:4
    Jump(@block2);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:37:4
  block2:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:38:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:38:2
}

function test_asyncReturnsPromise() {
  entry:
    Literal(lit deleted);                // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:40:37
    LoadGlobal(name 'myAsyncFunc');      // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:19
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:19
    Call(count 1, flag false);           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:19
    StoreVar(index 0);                   // 1  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:41:19
    LoadGlobal(name 'assert');           // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:3
    LoadVar(index 0);                    // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:10
    Literal(lit '__proto__');            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:10
    LoadGlobal(name 'Promise');          // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:32
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:32
    ObjectGet();                         // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:32
    BinOp(op '===');                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:32
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:42:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:2
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:43:2
}

function myAsyncFunc() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:45:1
    Literal(lit 42);                     // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:10
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:46:3
}

function test_promiseKeys() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:35
    Literal(lit deleted);                // 5  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:35
    Literal(lit deleted);                // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:49:35
    LoadGlobal(name 'myAsyncFunc');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:19
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:19
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:19
    StoreVar(index 3);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:50:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:16
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:16
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:16
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:16
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:16
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:16
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:32
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:32
    StoreVar(index 4);                   // 6  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:51:32
    // Even though the promise has 2 internal slots, which occupy the first
    // key-value pair slot, it should still have no own properties since the
    // the key used for internal slots is not a valid property key.
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:3
    LoadVar(index 4);                    // 9  keys           ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:28
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:55:28
    // Reflect.ownKeys is ignoring the internal slots but should not ignore the
    // properties that follow the internal slots
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:18
    LoadVar(index 3);                    // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    Literal(lit 'prop');                 // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    LoadVar(index 6);                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:59:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:17
    LoadGlobal(name 'Reflect');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:17
    LoadVar(index 7);                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:17
    Literal(lit 'ownKeys');              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:17
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:17
    StoreVar(index 6);                   // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:17
    LoadVar(index 3);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:33
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:33
    StoreVar(index 5);                   // 6  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:60:33
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:15
    Literal(lit 'length');               // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:15
    Literal(lit 1);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:29
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:61:29
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:3
    LoadVar(index 5);                    // 9  keys2          ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:15
    Literal(lit 0);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:21
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:21
    Literal(lit 'prop');                 // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:25
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:62:25
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:63:2
}

function test_promiseAwait() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:36
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:65:36
    LoadGlobal(name 'myAsyncFunc');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:19
    StoreVar(index 3);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:66:19
    LoadVar(index 3);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:67:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:15
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:68:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:69:2
}

function test_promiseAwaitReject() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:71:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:71:42
    LoadGlobal(name 'myAsyncFuncReject'); // 5                ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:19
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:19
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:19
    StoreVar(index 3);                   // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:72:19
    StartTry(@block3);                   // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:73:7
    LoadVar(index 3);                    // 7  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:74:11
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:74:5
    AsyncResume(count 3, count 2);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:74:5
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:74:5
    LoadGlobal(name 'assert');           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:5
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:5
    Literal(lit false);                  // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:12
    Literal(lit 'promise should have rejected'); // 10        ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:19
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:75:19
    EndTry();                            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:76:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:76:4
  block3:
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:5
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:5
    LoadVar(index 4);                    // 8  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:17
    Literal(lit 'message');              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:17
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:17
    Literal(lit '42');                   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:28
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:77:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:78:4
    Jump(@block4);                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:78:4
  block4:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:79:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:79:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:79:2
}

function myAsyncFuncReject() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:81:1
    LoadGlobal(name 'Error');            // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:13
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:13
    Literal(lit '42');                   // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:19
    New(count 2);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:19
    Throw();                             // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:82:19
}

function test_awaitMustBeAsynchronous() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:85:1
    Literal(lit &function inner);        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:85:47
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:85:47
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:85:47
    Literal(lit 'Start');                // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:11
    StoreScoped(index 4);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:86:11
    LoadVar(index 3);                    // 6  inner          ./test/end-to-end/tests/async-await-promise.test.mvm.js:87:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:87:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:87:19
    StoreVar(index 4);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:87:19
    // No await - should not block
    LoadScoped(index 4);                 // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:88:3
    Literal(lit '; After inner()');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:88:8
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:88:8
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:88:8
    StoreScoped(index 4);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:88:8
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:88:8
    LoadVar(index 4);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:89:9
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:89:3
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:89:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:89:3
    // The key here is that "After inner" should come before "After await",
    // because even though myAsyncFunc resolves immediately, the continuation
    // should be scheduled asynchronously.
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:3
    LoadScoped(index 4);                 // 8  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:15
    Literal(lit 'Start; Before await; After inner(); After await'); // 9  ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:18
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:93:18
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:101:2
}

function inner() {
  entry:
    AsyncStart(count 4, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:95:3
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:95:26
    LoadGlobal(name 'myAsyncFunc');      // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:21
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:21
    StoreVar(index 3);                   // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:96:21
    LoadScoped(index 10);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:5
    Literal(lit '; Before await');       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    StoreScoped(index 10);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:97:10
    LoadVar(index 3);                    // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:11
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:5
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:5
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:98:5
    LoadScoped(index 10);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:5
    Literal(lit '; After await');        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:10
    StoreScoped(index 10);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:99:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:100:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:100:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:100:4
}

function test_promiseConstructor() {
  entry:
    AsyncStart(count 4, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:103:1
    Literal(lit deleted);                // 4  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:103:42
    Literal(lit deleted);                // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:103:42
    LoadGlobal(name 'Promise');          // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:104:23
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:104:23
    Literal(lit &function anonymous);    // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:104:31
    New(count 2);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:104:31
    StoreVar(index 3);                   // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:104:31
    LoadVar(index 3);                    // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:107:24
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:107:18
    AsyncResume(count 2, count 4);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:107:18
    StoreVar(index 4);                   // 5  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:107:18
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:108:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:108:3
    LoadVar(index 4);                    // 8  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:108:15
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:108:23
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:108:23
    Pop(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:109:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:109:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:109:2
}

function anonymous() {
  entry:
    LoadArg(index 1);                    // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:105:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:105:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:105:13
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:105:13
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:106:4
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:106:4
}

function test_unresolvedPromise1Subscriber() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:111:1
    Literal(lit &function subscriber1);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:111:52
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:111:52
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:111:52
    Literal(lit deleted);                // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:111:52
    Literal(lit 'Start');                // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:11
    StoreScoped(index 5);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:112:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:113:7
    StoreScoped(index 6);                // 6  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:113:7
    LoadGlobal(name 'Promise');          // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:23
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:23
    Literal(lit &function anonymous1);   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:31
    ClosureNew();                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:31
    New(count 2);                        // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:31
    StoreVar(index 4);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:31
    LoadVar(index 3);                    // 7  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:14
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:14
    LoadVar(index 4);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:26
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:26
    StoreVar(index 5);                   // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:115:26
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:15
    Literal(lit 'Start; Subscriber 1 started'); // 10         ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:117:18
    LoadScoped(index 6);                 // 7  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:3
    Literal(lit 42);                     // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:11
    Call(count 2, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:118:11
    LoadVar(index 5);                    // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:119:9
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:119:3
    AsyncResume(count 3, count 5);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:119:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:119:3
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 finished with 42'); // 10  ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:120:18
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:127:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:127:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:127:2
}

function subscriber1() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:122:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:122:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:122:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:122:39
    LoadScoped(index 12);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:5
    Literal(lit '; Subscriber 1 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:10
    StoreScoped(index 12);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:123:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:124:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:124:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:124:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:124:20
    LoadScoped(index 12);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:5
    Literal(lit '; Subscriber 1 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:44
    StoreScoped(index 12);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:125:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:126:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:126:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:126:4
}

function anonymous1() {
  entry:
    LoadArg(index 1);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:46
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:46
    StoreScoped(index 8);                // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:46
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:114:46
}

function test_unresolvedPromise2Subscribers() {
  entry:
    AsyncStart(count 9, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:130:1
    Literal(lit &function subscriber2);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:130:53
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:130:53
    Literal(lit &function subscriber3);  // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:130:53
    ClosureNew();                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:130:53
    Literal(lit deleted);                // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:130:53
    Literal(lit deleted);                // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:130:53
    Literal(lit deleted);                // 8  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:130:53
    // The second subscriber triggers a code path where the subscriber list is
    // promoted from a closure to a list.
    Literal(lit 'Start');                // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:11
    StoreScoped(index 7);                // 8  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:134:11
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:135:7
    StoreScoped(index 8);                // 8  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:135:7
    LoadGlobal(name 'Promise');          // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:23
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:23
    Literal(lit &function anonymous2);   // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:31
    ClosureNew();                        // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:31
    New(count 2);                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:31
    StoreVar(index 5);                   // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:31
    LoadVar(index 3);                    // 9  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:137:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:137:14
    LoadVar(index 5);                    // 11 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:137:26
    Call(count 2, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:137:26
    StoreVar(index 6);                   // 8  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:137:26
    LoadVar(index 4);                    // 9  subscriber2    ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:14
    LoadVar(index 5);                    // 11 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:26
    Call(count 2, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:26
    StoreVar(index 7);                   // 8  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:138:26
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 2 started'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:140:18
    LoadScoped(index 8);                 // 9  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:141:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:141:3
    Literal(lit 42);                     // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:141:11
    Call(count 2, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:141:11
    LoadVar(index 6);                    // 9  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:9
    Await();                             // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:3
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:3
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:142:3
    LoadVar(index 7);                    // 9  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:143:9
    Await();                             // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:143:3
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:143:3
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:143:3
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 1 finished with 42; Subscriber 2 finished with 42'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:144:18
    Pop(count 5);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:157:2
}

function subscriber2() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:146:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:146:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:146:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:146:39
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:5
    Literal(lit '; Subscriber 1 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:10
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:147:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:148:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:148:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:148:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:148:20
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:149:5
    Literal(lit '; Subscriber 1 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:149:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:149:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:149:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:149:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:149:44
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:149:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:149:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:150:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:150:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:150:4
}

function subscriber3() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:152:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:152:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:152:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:152:39
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:5
    Literal(lit '; Subscriber 2 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:10
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:153:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:154:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:154:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:154:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:154:20
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:5
    Literal(lit '; Subscriber 2 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:44
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:155:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:156:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:156:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:156:4
}

function anonymous2() {
  entry:
    LoadArg(index 1);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:46
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:46
    StoreScoped(index 10);               // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:46
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:136:46
}

function test_unresolvedPromise3Subscribers() {
  entry:
    AsyncStart(count 11, flag false);    // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:1
    Literal(lit &function subscriber4);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    Literal(lit &function subscriber5);  // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    ClosureNew();                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    Literal(lit &function subscriber6);  // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    ClosureNew();                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    Literal(lit deleted);                // 7  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    Literal(lit deleted);                // 8  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    Literal(lit deleted);                // 9  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    Literal(lit deleted);                // 10 p3             ./test/end-to-end/tests/async-await-promise.test.mvm.js:159:53
    // Same as previous test but the subscriber list is already a list when
    // subscriber 3 is added.
    Literal(lit 'Start');                // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:11
    StoreScoped(index 9);                // 10 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:163:11
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:164:7
    StoreScoped(index 10);               // 10 resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:164:7
    LoadGlobal(name 'Promise');          // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:23
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:23
    Literal(lit &function anonymous3);   // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:31
    ClosureNew();                        // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:31
    New(count 2);                        // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:31
    StoreVar(index 6);                   // 10 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:31
    LoadVar(index 3);                    // 11 subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:14
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:14
    LoadVar(index 6);                    // 13 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:26
    Call(count 2, flag false);           // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:26
    StoreVar(index 7);                   // 10 p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:166:26
    LoadVar(index 4);                    // 11 subscriber2    ./test/end-to-end/tests/async-await-promise.test.mvm.js:167:14
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:167:14
    LoadVar(index 6);                    // 13 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:167:26
    Call(count 2, flag false);           // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:167:26
    StoreVar(index 8);                   // 10 p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:167:26
    LoadVar(index 5);                    // 11 subscriber3    ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:14
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:14
    LoadVar(index 6);                    // 13 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:26
    Call(count 2, flag false);           // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:26
    StoreVar(index 9);                   // 10 p3             ./test/end-to-end/tests/async-await-promise.test.mvm.js:168:26
    LoadGlobal(name 'assertEqual');      // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:3
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:3
    LoadScoped(index 9);                 // 13 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 3 started'); // 14  ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:18
    Call(count 3, flag true);            // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:170:18
    LoadScoped(index 10);                // 11 resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:3
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:3
    ObjectNew();                         // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:11
    LoadVar(index 12);                   // 14                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:11
    Literal(lit 'message');              // 15                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:11
    Literal(lit 'Hi');                   // 16                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:22
    ObjectSet();                         // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:22
    Call(count 2, flag true);            // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:171:22
    LoadVar(index 7);                    // 11 p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:172:9
    Await();                             // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:172:3
    AsyncResume(count 7, count 9);       // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:172:3
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:172:3
    LoadVar(index 8);                    // 11 p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:9
    Await();                             // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:3
    AsyncResume(count 7, count 9);       // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:3
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:173:3
    LoadVar(index 9);                    // 11 p3             ./test/end-to-end/tests/async-await-promise.test.mvm.js:174:9
    Await();                             // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:174:3
    AsyncResume(count 7, count 9);       // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:174:3
    Pop(count 1);                        // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:174:3
    LoadGlobal(name 'assertEqual');      // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:3
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:3
    LoadScoped(index 9);                 // 13 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 2 started; Subscriber 3 started; Subscriber 1 finished with Hi; Subscriber 2 finished with Hi; Subscriber 3 finished with Hi'); // 14  ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:18
    Call(count 3, flag true);            // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:175:18
    Pop(count 7);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:194:2
}

function subscriber4() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:177:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:177:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:177:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:177:39
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:5
    Literal(lit '; Subscriber 1 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:10
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:178:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:179:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:179:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:179:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:179:20
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:5
    Literal(lit '; Subscriber 1 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:44
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:180:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:181:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:181:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:181:4
}

function subscriber5() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:183:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:183:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:183:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:183:39
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:5
    Literal(lit '; Subscriber 2 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:10
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:184:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:185:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:185:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:185:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:185:20
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:5
    Literal(lit '; Subscriber 2 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:44
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:186:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:187:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:187:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:187:4
}

function subscriber6() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:189:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:189:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:189:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:189:39
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:5
    Literal(lit '; Subscriber 3 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:10
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:190:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:191:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:191:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:191:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:191:20
    LoadScoped(index 16);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:5
    Literal(lit '; Subscriber 3 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:44
    StoreScoped(index 16);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:192:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:193:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:193:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:193:4
}

function anonymous3() {
  entry:
    LoadArg(index 1);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:46
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:46
    StoreScoped(index 12);               // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:46
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:165:46
}

function test_awaitBeforeAndAfterResolved() {
  entry:
    AsyncStart(count 9, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:196:1
    Literal(lit &function subscriber7);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:196:51
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:196:51
    Literal(lit &function subscriber8);  // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:196:51
    ClosureNew();                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:196:51
    Literal(lit deleted);                // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:196:51
    Literal(lit deleted);                // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:196:51
    Literal(lit deleted);                // 8  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:196:51
    // The second subscriber only subscribes after the first promise has already
    // transitioned to resolved.
    Literal(lit 'Start');                // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:11
    StoreScoped(index 7);                // 8  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:200:11
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:201:7
    StoreScoped(index 8);                // 8  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:201:7
    LoadGlobal(name 'Promise');          // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:23
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:23
    Literal(lit &function anonymous4);   // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:31
    ClosureNew();                        // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:31
    New(count 2);                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:31
    StoreVar(index 5);                   // 8  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:31
    LoadVar(index 3);                    // 9  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:14
    LoadVar(index 5);                    // 11 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:26
    Call(count 2, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:26
    StoreVar(index 6);                   // 8  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:203:26
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:15
    Literal(lit 'Start; Subscriber 1 started'); // 12         ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:205:18
    LoadScoped(index 8);                 // 9  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:206:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:206:3
    ArrayNew();                          // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:206:11
    LoadVar(index 10);                   // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:206:11
    Literal(lit 0);                      // 13                ./test/end-to-end/tests/async-await-promise.test.mvm.js:206:11
    Literal(lit 42);                     // 14                ./test/end-to-end/tests/async-await-promise.test.mvm.js:206:12
    ObjectSet();                         // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:206:11
    Call(count 2, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:206:11
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:15
    Literal(lit 'Start; Subscriber 1 started'); // 12         ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:207:18
    LoadVar(index 6);                    // 9  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:209:9
    Await();                             // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:209:3
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:209:3
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:209:3
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 finished with 42'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:210:18
    LoadVar(index 4);                    // 9  subscriber2    ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:14
    LoadVar(index 5);                    // 11 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:26
    Call(count 2, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:26
    StoreVar(index 7);                   // 8  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:212:26
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 finished with 42; Subscriber 2 started'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:213:18
    LoadVar(index 7);                    // 9  p2             ./test/end-to-end/tests/async-await-promise.test.mvm.js:214:9
    Await();                             // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:214:3
    AsyncResume(count 5, count 7);       // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:214:3
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:214:3
    LoadGlobal(name 'assertEqual');      // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:3
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:3
    LoadScoped(index 7);                 // 11 s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 finished with 42; Subscriber 2 started; Subscriber 2 finished with 42'); // 12  ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:18
    Call(count 3, flag true);            // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:215:18
    Pop(count 5);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:228:2
}

function subscriber7() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:217:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:217:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:217:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:217:39
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:5
    Literal(lit '; Subscriber 1 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:10
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:218:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:219:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:219:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:219:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:219:20
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:5
    Literal(lit '; Subscriber 1 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:44
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:51
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:51
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:51
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:51
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:51
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:51
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:220:51
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:221:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:221:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:221:4
}

function subscriber8() {
  entry:
    AsyncStart(count 5, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:223:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:223:3
    StoreScoped(index 3);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:223:3
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:223:39
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:5
    Literal(lit '; Subscriber 2 started'); // 6               ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:10
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:10
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:10
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:224:10
    LoadScoped(index 3);                 // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:225:26
    Await();                             // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:225:20
    AsyncResume(count 1, count 3);       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:225:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:225:20
    LoadScoped(index 14);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:5
    Literal(lit '; Subscriber 2 finished with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:10
    LoadVar(index 3);                    // 7  result         ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:44
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:51
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:51
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:51
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:51
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:51
    StoreScoped(index 14);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:51
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:226:51
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:227:4
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:227:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:227:4
}

function anonymous4() {
  entry:
    LoadArg(index 1);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:46
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:46
    StoreScoped(index 10);               // 1  resolve        ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:46
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:202:46
}

function test_awaitUnrejected() {
  entry:
    AsyncStart(count 7, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:230:1
    Literal(lit &function subscriber9);  // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:230:39
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:230:39
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:230:39
    Literal(lit deleted);                // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:230:39
    Literal(lit 'Start');                // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:11
    StoreScoped(index 5);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:231:11
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:232:7
    StoreScoped(index 6);                // 6  reject         ./test/end-to-end/tests/async-await-promise.test.mvm.js:232:7
    LoadGlobal(name 'Promise');          // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:23
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:23
    Literal(lit &function anonymous5);   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:31
    ClosureNew();                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:31
    New(count 2);                        // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:31
    StoreVar(index 4);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:31
    LoadVar(index 3);                    // 7  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:14
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:14
    LoadVar(index 4);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:26
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:26
    StoreVar(index 5);                   // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:234:26
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:15
    Literal(lit 'Start; Subscriber 1 started'); // 10         ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:236:18
    LoadScoped(index 6);                 // 7  reject         ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:3
    LoadGlobal(name 'Error');            // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:14
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:14
    Literal(lit 'dummy error');          // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:20
    New(count 2);                        // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:20
    Call(count 2, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:237:20
    LoadVar(index 5);                    // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:238:9
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:238:3
    AsyncResume(count 3, count 5);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:238:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:238:3
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:239:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:239:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:239:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 rejected with dummy error'); // 10  ./test/end-to-end/tests/async-await-promise.test.mvm.js:239:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:239:18
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:250:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:250:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:250:2
}

function subscriber9() {
  entry:
    AsyncStart(count 6, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:241:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:241:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:241:3
    LoadScoped(index 13);                // 4  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:5
    Literal(lit '; Subscriber 1 started'); // 5               ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:10
    StoreScoped(index 13);               // 4  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:242:10
    StartTry(@block5);                   // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:243:9
    LoadScoped(index 4);                 // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:244:13
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:244:7
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:244:7
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:244:7
    LoadScoped(index 13);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:7
    Literal(lit '; should not get here'); // 7                ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:12
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:12
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:12
    StoreScoped(index 13);               // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:12
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:245:12
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:246:6
    Jump(@block6);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:246:6
  block5:
    LoadScoped(index 13);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:7
    Literal(lit '; Subscriber 1 rejected with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:12
    LoadVar(index 3);                    // 7  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:44
    StoreScoped(index 13);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:247:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:248:6
    Jump(@block6);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:248:6
  block6:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:249:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:249:4
}

function anonymous5() {
  entry:
    LoadArg(index 2);                    // 1  r              ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:49
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:49
    StoreScoped(index 8);                // 1  reject         ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:49
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:233:49
}

function test_immediatelyRejectedPromise() {
  entry:
    AsyncStart(count 6, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:252:1
    Literal(lit &function subscriber10); // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:252:50
    ClosureNew();                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:252:50
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:252:50
    Literal(lit deleted);                // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:252:50
    Literal(lit 'Start');                // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:253:11
    StoreScoped(index 5);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:253:11
    LoadGlobal(name 'Promise');          // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:23
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:23
    Literal(lit &function anonymous6);   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:31
    New(count 2);                        // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:31
    StoreVar(index 4);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:31
    LoadVar(index 3);                    // 7  subscriber1    ./test/end-to-end/tests/async-await-promise.test.mvm.js:255:14
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:255:14
    LoadVar(index 4);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:255:26
    Call(count 2, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:255:26
    StoreVar(index 5);                   // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:255:26
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:257:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:257:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:257:15
    Literal(lit 'Start; Subscriber 1 started'); // 10         ./test/end-to-end/tests/async-await-promise.test.mvm.js:257:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:257:18
    LoadVar(index 5);                    // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:258:9
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:258:3
    AsyncResume(count 3, count 5);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:258:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:258:3
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:259:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:259:3
    LoadScoped(index 5);                 // 9  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:259:15
    Literal(lit 'Start; Subscriber 1 started; Subscriber 1 rejected with dummy error'); // 10  ./test/end-to-end/tests/async-await-promise.test.mvm.js:259:18
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:259:18
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:270:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:270:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:270:2
}

function subscriber10() {
  entry:
    AsyncStart(count 6, flag true);      // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:261:3
    LoadArg(index 1);                    // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:261:3
    StoreScoped(index 4);                // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:261:3
    LoadScoped(index 13);                // 4  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:262:5
    Literal(lit '; Subscriber 1 started'); // 5               ./test/end-to-end/tests/async-await-promise.test.mvm.js:262:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:262:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:262:10
    StoreScoped(index 13);               // 4  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:262:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:262:10
    StartTry(@block7);                   // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:263:9
    LoadScoped(index 4);                 // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:264:13
    Await();                             // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:264:7
    AsyncResume(count 2, count 2);       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:264:7
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:264:7
    LoadScoped(index 13);                // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:265:7
    Literal(lit '; should not get here'); // 7                ./test/end-to-end/tests/async-await-promise.test.mvm.js:265:12
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:265:12
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:265:12
    StoreScoped(index 13);               // 6  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:265:12
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:265:12
    EndTry();                            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:266:6
    Jump(@block8);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:266:6
  block7:
    LoadScoped(index 13);                // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:7
    Literal(lit '; Subscriber 1 rejected with '); // 6        ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:12
    LoadVar(index 3);                    // 7  e              ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:44
    Literal(lit 'message');              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:44
    ObjectGet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:44
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:44
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:44
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:44
    StoreScoped(index 13);               // 5  s              ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:44
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:267:44
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:268:6
    Jump(@block8);                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:268:6
  block8:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:269:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:269:4
}

function anonymous6() {
  entry:
    LoadArg(index 2);                    // 1  reject         ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:46
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:46
    LoadGlobal(name 'Error');            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:57
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:57
    Literal(lit 'dummy error');          // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:63
    New(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:63
    Call(count 2, flag false);           // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:63
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:254:63
}

function test_augmentingPromisePrototype() {
  entry:
    AsyncStart(count 5, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:272:1
    Literal(lit &function myAsync);      // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:272:50
    Literal(lit deleted);                // 5  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:272:50
    Literal(lit deleted);                // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:272:50
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:273:25
    LoadGlobal(name 'Promise');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:273:3
    Literal(lit 'prototype');            // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:273:3
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:273:3
    Literal(lit 'x');                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:273:3
    LoadVar(index 6);                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:273:3
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:273:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:273:3
    Literal(lit &function anonymous7);   // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:25
    LoadGlobal(name 'Promise');          // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:3
    Literal(lit 'prototype');            // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:3
    ObjectGet();                         // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:3
    Literal(lit 'f');                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:3
    LoadVar(index 6);                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:3
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:3
    LoadGlobal(name 'Promise');          // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:23
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:23
    Literal(lit &function anonymous8);   // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:31
    New(count 2);                        // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:31
    StoreVar(index 4);                   // 6  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:31
    LoadVar(index 3);                    // 7  myAsync        ./test/end-to-end/tests/async-await-promise.test.mvm.js:276:14
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:276:14
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:276:14
    StoreVar(index 5);                   // 6  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:276:14
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:278:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:278:3
    LoadVar(index 4);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:278:15
    Literal(lit 'x');                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:278:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:278:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:278:26
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:278:26
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:15
    LoadVar(index 4);                    // 10 promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:15
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:15
    Literal(lit 'f');                    // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:15
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:15
    StoreVar(index 8);                   // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:15
    Call(count 1, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:28
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:279:28
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:280:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:280:3
    LoadVar(index 5);                    // 9  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:280:15
    Literal(lit 'x');                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:280:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:280:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:280:21
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:280:21
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:15
    LoadVar(index 5);                    // 10 p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:15
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:15
    Literal(lit 'f');                    // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:15
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:15
    StoreVar(index 8);                   // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:15
    Call(count 1, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:23
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:281:23
    LoadVar(index 5);                    // 7  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:282:9
    Await();                             // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:282:3
    AsyncResume(count 3, count 5);       // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:282:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:282:3
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:283:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:283:3
    LoadVar(index 5);                    // 9  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:283:15
    Literal(lit 'x');                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:283:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:283:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:283:21
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:283:21
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:15
    LoadVar(index 5);                    // 10 p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:15
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:15
    Literal(lit 'f');                    // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:15
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:15
    StoreVar(index 8);                   // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:15
    Call(count 1, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:23
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:284:23
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:285:10
    LoadVar(index 5);                    // 8  p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:285:3
    Literal(lit 'x');                    // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:285:3
    LoadVar(index 6);                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:285:3
    ObjectSet();                         // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:285:3
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:285:3
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:286:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:286:3
    LoadVar(index 4);                    // 9  promise        ./test/end-to-end/tests/async-await-promise.test.mvm.js:286:15
    Literal(lit 'x');                    // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:286:15
    ObjectGet();                         // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:286:15
    Literal(lit 5);                      // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:286:26
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:286:26
    LoadGlobal(name 'assertEqual');      // 7                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:3
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:15
    LoadVar(index 5);                    // 10 p1             ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:15
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:15
    Literal(lit 'f');                    // 12                ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:15
    ObjectGet();                         // 11                ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:15
    StoreVar(index 8);                   // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:15
    Call(count 1, flag false);           // 9                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:15
    Literal(lit 10);                     // 10                ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:23
    Call(count 3, flag true);            // 6                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:287:23
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:291:2
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:291:2
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:291:2
}

function myAsync() {
  entry:
    AsyncStart(count 2, flag false);     // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:289:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:290:4
    AsyncReturn();                       // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:290:4
}

function anonymous7() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:45
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:45
    ObjectGet();                         // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:45
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:274:38
}

function anonymous8() {
  entry:
    LoadArg(index 2);                    // 1  reject         ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:46
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:46
    LoadGlobal(name 'Error');            // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:57
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:57
    Literal(lit 'dummy error');          // 5                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:63
    New(count 2);                        // 3                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:63
    Call(count 2, flag false);           // 1                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:63
    Return();                            // 0                 ./test/end-to-end/tests/async-await-promise.test.mvm.js:275:63
}