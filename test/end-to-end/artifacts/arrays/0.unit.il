unit ['./test/end-to-end/tests/arrays.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';
external assert from free-variable 'assert';

global thisModule;
global a;
global b;
global c;
global d;
global init;
global testArrays;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:1:1
    Literal(lit &function init);         // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:1:1
    StoreGlobal(name 'init');            // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:1:1
    Literal(lit &function testArrays);   // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:1:1
    StoreGlobal(name 'testArrays');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // ---
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:5:5
    StoreGlobal(name 'a');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:5:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:6:5
    StoreGlobal(name 'b');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:6:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:7:5
    StoreGlobal(name 'c');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:7:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:8:5
    StoreGlobal(name 'd');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:8:5
    LoadGlobal(name 'init');             // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:10:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:10:1
    Call(count 1);                       // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:10:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:10:1
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:11:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:11:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:11:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/arrays.test.mvm.js:11:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:11:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:11:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:42:1
    Return();                            // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:42:1
}

function run() {
  entry:
    // Run the test twice. Particularly, when running after a snapshot
    // restoration, the first time will be running against the arrays in the
    // snapshot, while the second time will be running against newly-allocated
    // arrays.
    LoadGlobal(name 'testArrays');       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:18:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:18:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:18:3
    LoadGlobal(name 'testArrays');       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:19:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:19:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:19:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:20:2
    Return();                            // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:20:2
}

function init() {
  entry:
    ArrayNew();                          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:23:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:23:7
    StoreGlobal(name 'a');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:23:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:23:7
    ArrayNew();                          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:24:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:24:7
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:24:7
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:24:8
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:24:8
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:24:8
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:24:8
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:24:11
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:24:11
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:24:11
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:24:11
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:24:14
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:24:14
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:24:14
    StoreGlobal(name 'b');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:24:14
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:24:14
    ArrayNew();                          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:25:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:25:7
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:25:7
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:25:8
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:25:8
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:25:8
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:25:8
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    StoreGlobal(name 'c');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:25:13
    ArrayNew();                          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:26:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:26:7
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:26:7
    ArrayNew();                          // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:27:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/arrays.test.mvm.js:27:5
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/arrays.test.mvm.js:27:5
    ArrayNew();                          // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:28:7
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/arrays.test.mvm.js:28:7
    Literal(lit 0);                      // 9                 ./test/end-to-end/tests/arrays.test.mvm.js:28:7
    Literal(lit 1);                      // 10                ./test/end-to-end/tests/arrays.test.mvm.js:29:9
    ObjectSet();                         // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:29:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/arrays.test.mvm.js:29:9
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/arrays.test.mvm.js:29:9
    Literal(lit 2);                      // 10                ./test/end-to-end/tests/arrays.test.mvm.js:30:9
    ObjectSet();                         // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:30:9
    ObjectSet();                         // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:30:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/arrays.test.mvm.js:30:9
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/arrays.test.mvm.js:30:9
    ArrayNew();                          // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:32:7
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/arrays.test.mvm.js:32:7
    Literal(lit 0);                      // 9                 ./test/end-to-end/tests/arrays.test.mvm.js:32:7
    Literal(lit 3);                      // 10                ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    ObjectSet();                         // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    Literal(lit 4);                      // 10                ./test/end-to-end/tests/arrays.test.mvm.js:34:9
    ObjectSet();                         // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:34:9
    ObjectSet();                         // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:34:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/arrays.test.mvm.js:34:9
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/arrays.test.mvm.js:34:9
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:36:7
    ObjectSet();                         // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:36:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:36:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:36:7
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:36:7
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:38:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:38:5
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:38:5
    StoreGlobal(name 'd');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:38:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:38:5
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:40:2
    Return();                            // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:40:2
}

function testArrays() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:43:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:43:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:43:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:43:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:43:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:43:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:43:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:43:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:44:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:44:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:44:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:44:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:44:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:44:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:44:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:44:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:46:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:46:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:46:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:46:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:46:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:46:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:46:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:46:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:47:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:47:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:47:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:47:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:47:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:47:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:47:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:47:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:48:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:48:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:48:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:48:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:48:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:48:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:48:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:48:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:49:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:49:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:49:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:49:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:49:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:49:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:49:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:49:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:50:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:50:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:50:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:50:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:50:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:50:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:50:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:50:21
    // Mutation
    Literal(lit 24);                     // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:53:10
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:53:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:53:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:53:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:53:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:53:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:54:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:54:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:54:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:54:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:54:17
    Literal(lit 24);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:54:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:54:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:54:21
    // Extend the array
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:57:10
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:57:3
    Literal(lit 4);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:57:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:57:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:57:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:57:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:58:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:58:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:58:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:58:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:58:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:58:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:58:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:58:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:59:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:59:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:59:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:59:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:59:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:59:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:59:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:59:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:60:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:60:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:60:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:60:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:60:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:60:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:60:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:60:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:61:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:61:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:61:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:61:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:61:17
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:61:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:61:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:61:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:62:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:62:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:62:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:62:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:62:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:62:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:62:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:62:21
    // Write to a hole
    Literal(lit 4);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:65:10
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:65:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:65:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:65:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:65:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:65:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:66:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:66:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:66:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:66:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:66:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:66:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:66:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:66:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:67:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:67:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:67:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:67:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:67:17
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:67:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:67:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:67:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:68:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:68:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:68:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:68:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:68:17
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:68:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:68:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:68:21
    // Shorten the array
    Literal(lit 3);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:71:14
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:71:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:71:3
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:71:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:71:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:71:3
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:72:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:72:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:72:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:72:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:72:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:72:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:72:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:72:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:73:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:73:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:73:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:73:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:73:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:73:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:73:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:73:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:74:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:74:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:74:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:74:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:74:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:74:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:74:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:74:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:75:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:75:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:75:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:75:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:75:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:75:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:75:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:75:21
    // Make the array longer by setting the length (this is likely not to increase
    // the _capacity_ of the array, since the capacity is probably still large
    // from earlier, so this tests that making the array shorter and then longer
    // does not expose stale values)
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:81:14
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:81:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:81:3
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:81:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:81:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:81:3
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:82:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:82:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:82:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:82:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:82:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:82:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:82:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:82:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:83:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:83:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:83:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:83:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:83:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:83:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:83:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:83:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:84:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:84:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:84:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:84:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:84:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:84:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:84:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:84:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:85:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:85:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:85:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:85:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:85:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:85:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:85:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:85:21
    // Make the array longer by setting the length, but to a value that exceeds the original capacity
    Literal(lit 8);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:88:14
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:88:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:88:3
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:88:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:88:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:88:3
    Literal(lit 8);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:89:10
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:89:3
    Literal(lit 7);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:89:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:89:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:89:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:89:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:90:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:90:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:90:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:90:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:90:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:90:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:90:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:90:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:91:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:91:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:91:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:91:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:91:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:91:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:91:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:91:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:92:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:92:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:92:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:92:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:92:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:92:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:92:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:92:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:93:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:93:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:93:15
    Literal(lit 7);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:93:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:93:17
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:93:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:93:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:93:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:94:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:94:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:94:15
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:94:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:94:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:94:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:94:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:94:21
    // Grow an empty array (`a` is an empty array so far)
    Literal(lit 10);                     // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:97:10
    LoadGlobal(name 'a');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:97:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:97:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:97:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:97:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:97:5
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:98:10
    LoadGlobal(name 'a');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:98:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:98:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:98:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:98:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:98:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:99:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:99:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:99:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:99:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:99:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:99:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:99:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:99:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:100:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:100:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:100:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:100:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:100:17
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:100:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:100:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:100:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:101:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:101:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:101:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:101:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:101:17
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:101:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:101:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:101:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:102:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:102:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:102:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:102:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:102:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:102:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:102:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:102:21
    // Test elision
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:105:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:105:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:105:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:105:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:105:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:105:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:105:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:105:25
    // Length is 4, even though it ends in a hole
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:106:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:106:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:106:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:106:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:106:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:106:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:106:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:106:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:107:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:107:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:107:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:107:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:107:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:107:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:107:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:107:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:108:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:108:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:108:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:108:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:108:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:108:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:108:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:108:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:109:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:109:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:109:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:109:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:109:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:109:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:109:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:109:21
    // Test Array.push
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:112:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:112:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:112:10
    Literal(lit '__proto__');            // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:112:10
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:112:10
    Literal(lit null);                   // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:112:26
    BinOp(op '!==');                     // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:112:26
    Call(count 2);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:112:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:112:26
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:113:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:113:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:113:10
    Literal(lit '__proto__');            // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:113:10
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:113:10
    Literal(lit 'push');                 // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:113:10
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:113:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:113:31
    BinOp(op '!==');                     // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:113:31
    Call(count 2);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:113:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:113:31
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:114:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:114:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:114:10
    Literal(lit 'push');                 // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:114:10
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:114:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:114:21
    BinOp(op '!==');                     // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:114:21
    Call(count 2);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:114:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:114:21
    LoadGlobal(name 'a');                // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:115:3
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:115:3
    Literal(lit 'push');                 // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:115:3
    ObjectGet();                         // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:115:3
    LoadVar(index 0);                    // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:115:3
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:115:10
    Call(count 2);                       // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:115:10
    StoreVar(index 0);                   // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:115:10
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:115:10
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:116:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:116:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:116:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:116:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:116:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:116:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:116:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:116:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:117:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:117:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:117:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:117:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:117:17
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:117:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:117:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:117:21
    // See that the nested arrays are correct
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:120:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:120:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:120:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:120:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:120:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:120:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:120:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:120:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:121:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:121:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:121:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:121:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:121:17
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:121:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:121:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:121:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:121:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:121:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:122:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:122:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:122:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:122:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:122:17
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:122:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:122:20
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:122:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:122:20
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:122:31
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:122:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:122:31
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:123:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:123:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:123:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:123:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:123:17
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:123:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:123:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:123:23
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:123:23
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:123:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:123:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:123:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:124:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:124:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:124:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:124:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:124:17
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:124:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:124:20
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:124:23
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:124:23
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:124:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:124:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:124:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:125:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:125:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:125:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:125:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:125:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:125:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:125:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:125:23
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:125:23
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:125:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:125:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:125:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:126:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:126:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:126:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:126:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:126:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:126:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:126:20
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:126:23
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:126:23
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:126:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:126:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:126:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:127:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:127:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:127:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:127:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:127:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:127:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:127:20
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:127:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:127:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:127:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:128:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:128:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:128:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:128:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:128:17
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:128:21
    Call(count 3);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:128:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:128:21
    // Reset the arrays to their initial state, because this test runs multiple
    // times (before and after the snapshot)
    LoadGlobal(name 'init');             // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:132:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:132:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:132:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:132:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:133:2
    Return();                            // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:133:2
}