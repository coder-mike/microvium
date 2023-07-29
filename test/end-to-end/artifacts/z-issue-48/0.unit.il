unit ['./test/end-to-end/tests/z-issue-48.test.mvm.js'];

entry ['#entry'];

external console from free-variable 'console';
external assertEqual from free-variable 'assertEqual';
external vmExport from free-variable 'vmExport';

global thisModule;
global log;
global sayHello;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:1:1
    Literal(lit &function sayHello);     // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:1:1
    StoreGlobal(name 'sayHello');        // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:1:1
    // ---
    // description: https://github.com/coder-mike/microvium/issues/48
    // runExportedFunction: 0
    // assertionCount: 5
    // ---
    ArrayNew();                          // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:7:11
    StoreGlobal(name 'log');             // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:7:11
    Literal(lit &function anonymous);    // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:15
    LoadGlobal(name 'console');          // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:1
    Literal(lit 'log');                  // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:1
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:1
    ObjectSet();                         // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:1
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:33:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:33:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:33:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/z-issue-48.test.mvm.js:33:12
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:33:12
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:33:12
    Return();                            // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:33:12
}

function anonymous() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:22
    LoadGlobal(name 'log');              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:22
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:22
    Literal(lit 'push');                 // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:22
    ObjectGet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:22
    StoreVar(index 0);                   // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:22
    LoadArg(index 1);                    // 3  msg            ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:31
    Call(count 2, flag false);           // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:31
    Return();                            // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:8:31
}

function run() {
  entry:
    LoadGlobal(name 'sayHello');         // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:11:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:11:3
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:13:3
    LoadGlobal(name 'log');              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:13:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:13:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:13:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:13:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:13:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:14:3
    LoadGlobal(name 'log');              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:14:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:14:19
    ObjectGet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:14:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:14:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:14:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:15:3
    LoadGlobal(name 'log');              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:15:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:15:19
    ObjectGet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:15:19
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:15:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:15:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:16:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:16:3
    LoadGlobal(name 'log');              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:16:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:16:19
    ObjectGet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:16:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:16:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:16:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:17:3
    LoadGlobal(name 'log');              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:17:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:17:19
    ObjectGet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:17:19
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:17:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:17:23
    ArrayNew();                          // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:19:9
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:19:9
    StoreGlobal(name 'log');             // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:19:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:19:9
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:20:2
    Return();                            // 0                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:20:2
}

function sayHello() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:22:1
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:22:1
    ArrayNew();                          // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:13
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:13
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:13
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:14
    ObjectSet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:14
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:14
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:14
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:17
    ObjectSet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:17
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:17
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:20
    ObjectSet();                         // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:20
    StoreVar(index 0);                   // 2  arr            ./test/end-to-end/tests/z-issue-48.test.mvm.js:23:20
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:16
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:16
    Jump(@block1);                       // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:16
  block1:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:19
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:23
    Branch(@block2, @block3);            // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:23
  block2:
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:5
    LoadGlobal(name 'console');          // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:5
    Literal(lit 'log');                  // 6                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:5
    ObjectGet();                         // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:5
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:5
    LoadVar(index 0);                    // 5  arr            ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:17
    LoadVar(index 1);                    // 6  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:21
    ObjectGet();                         // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:21
    Call(count 2, flag true);            // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:25:21
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:26
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:26
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:26
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:26
    StoreVar(index 1);                   // 3  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:26
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:26
    Jump(@block1);                       // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:24:26
  block3:
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:16
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:16
    Jump(@block4);                       // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:16
  block4:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:19
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:23
    Branch(@block5, @block6);            // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:23
  block5:
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:5
    LoadGlobal(name 'console');          // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:5
    Literal(lit 'log');                  // 6                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:5
    ObjectGet();                         // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:5
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:5
    LoadVar(index 0);                    // 5  arr            ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:17
    LoadVar(index 1);                    // 6  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:21
    ObjectGet();                         // 5                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:21
    Call(count 2, flag true);            // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:28:21
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:26
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:26
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:26
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:26
    StoreVar(index 1);                   // 3  i              ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:26
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:26
    Jump(@block4);                       // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:27:26
  block6:
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:30:2
    Return();                            // 2                 ./test/end-to-end/tests/z-issue-48.test.mvm.js:30:2
}