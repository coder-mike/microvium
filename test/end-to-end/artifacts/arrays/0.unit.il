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
    // description: >
    // Testing basic array operations
    // runExportedFunction: 0
    // assertionCount: 104
    // ---
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:8:5
    StoreGlobal(name 'a');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:8:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:9:5
    StoreGlobal(name 'b');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:9:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:10:5
    StoreGlobal(name 'c');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:10:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:11:5
    StoreGlobal(name 'd');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:11:5
    LoadGlobal(name 'init');             // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:13:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:13:1
    Call(count 1, true);                 // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:13:1
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:14:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:14:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:14:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/arrays.test.mvm.js:14:13
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:14:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:45:1
    Return();                            // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:45:1
}

function run() {
  entry:
    // Run the test twice. Particularly, when running after a snapshot
    // restoration, the first time will be running against the arrays in the
    // snapshot, while the second time will be running against newly-allocated
    // arrays.
    LoadGlobal(name 'testArrays');       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:21:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:21:3
    LoadGlobal(name 'testArrays');       // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:22:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:22:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:22:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:23:2
    Return();                            // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:23:2
}

function init() {
  entry:
    ArrayNew();                          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:26:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:26:7
    StoreGlobal(name 'a');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:26:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:26:7
    ArrayNew();                          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:27:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:27:7
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:27:7
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:27:8
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:27:8
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:27:8
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:27:8
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:27:11
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:27:11
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:27:11
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:27:11
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:27:14
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:27:14
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:27:14
    StoreGlobal(name 'b');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:27:14
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:27:14
    ArrayNew();                          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:28:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:28:7
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:28:7
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:28:8
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:28:8
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:28:8
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:28:8
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    StoreGlobal(name 'c');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:28:13
    ArrayNew();                          // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:29:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:29:7
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:29:7
    ArrayNew();                          // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:30:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/arrays.test.mvm.js:30:5
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/arrays.test.mvm.js:30:5
    ArrayNew();                          // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:31:7
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/arrays.test.mvm.js:31:7
    Literal(lit 0);                      // 9                 ./test/end-to-end/tests/arrays.test.mvm.js:31:7
    Literal(lit 1);                      // 10                ./test/end-to-end/tests/arrays.test.mvm.js:32:9
    ObjectSet();                         // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:32:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/arrays.test.mvm.js:32:9
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/arrays.test.mvm.js:32:9
    Literal(lit 2);                      // 10                ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    ObjectSet();                         // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    ObjectSet();                         // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/arrays.test.mvm.js:33:9
    ArrayNew();                          // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:35:7
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/arrays.test.mvm.js:35:7
    Literal(lit 0);                      // 9                 ./test/end-to-end/tests/arrays.test.mvm.js:35:7
    Literal(lit 3);                      // 10                ./test/end-to-end/tests/arrays.test.mvm.js:36:9
    ObjectSet();                         // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:36:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/arrays.test.mvm.js:36:9
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/arrays.test.mvm.js:36:9
    Literal(lit 4);                      // 10                ./test/end-to-end/tests/arrays.test.mvm.js:37:9
    ObjectSet();                         // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:37:9
    ObjectSet();                         // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:37:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/arrays.test.mvm.js:37:9
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/arrays.test.mvm.js:37:9
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/arrays.test.mvm.js:39:7
    ObjectSet();                         // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:39:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:39:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:39:7
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:39:7
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:41:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:41:5
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:41:5
    StoreGlobal(name 'd');               // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:41:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:41:5
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:43:2
    Return();                            // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:43:2
}

function testArrays() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:46:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:46:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:46:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:46:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:46:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:46:25
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:46:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:47:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:47:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:47:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:47:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:47:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:47:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:47:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:49:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:49:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:49:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:49:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:49:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:49:25
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:49:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:50:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:50:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:50:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:50:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:50:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:50:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:50:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:51:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:51:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:51:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:51:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:51:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:51:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:51:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:52:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:52:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:52:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:52:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:52:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:52:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:52:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:53:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:53:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:53:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:53:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:53:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:53:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:53:21
    // Mutation
    Literal(lit 24);                     // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:56:10
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:56:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:56:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:56:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:56:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:56:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:57:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:57:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:57:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:57:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:57:17
    Literal(lit 24);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:57:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:57:21
    // Extend the array
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:60:10
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:60:3
    Literal(lit 4);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:60:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:60:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:60:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:60:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:61:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:61:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:61:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:61:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:61:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:61:25
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:61:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:62:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:62:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:62:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:62:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:62:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:62:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:62:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:63:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:63:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:63:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:63:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:63:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:63:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:63:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:64:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:64:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:64:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:64:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:64:17
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:64:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:64:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:65:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:65:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:65:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:65:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:65:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:65:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:65:21
    // Write to a hole
    Literal(lit 4);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:68:10
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:68:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:68:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:68:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:68:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:68:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:69:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:69:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:69:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:69:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:69:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:69:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:69:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:70:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:70:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:70:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:70:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:70:17
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:70:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:70:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:71:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:71:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:71:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:71:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:71:17
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:71:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:71:21
    // Shorten the array
    Literal(lit 3);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:74:14
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:74:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:74:3
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:74:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:74:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:74:3
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:75:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:75:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:75:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:75:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:75:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:75:25
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:75:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:76:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:76:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:76:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:76:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:76:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:76:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:76:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:77:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:77:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:77:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:77:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:77:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:77:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:77:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:78:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:78:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:78:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:78:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:78:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:78:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:78:21
    // Make the array longer by setting the length (this is likely not to increase
    // the _capacity_ of the array, since the capacity is probably still large
    // from earlier, so this tests that making the array shorter and then longer
    // does not expose stale values)
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:84:14
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:84:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:84:3
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:84:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:84:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:84:3
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:85:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:85:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:85:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:85:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:85:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:85:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:85:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:86:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:86:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:86:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:86:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:86:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:86:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:86:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:87:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:87:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:87:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:87:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:87:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:87:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:87:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:88:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:88:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:88:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:88:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:88:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:88:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:88:21
    // Make the array longer by setting the length, but to a value that exceeds the original capacity
    Literal(lit 8);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:91:14
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:91:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:91:3
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:91:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:91:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:91:3
    Literal(lit 8);                      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:92:10
    LoadGlobal(name 'b');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:92:3
    Literal(lit 7);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:92:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:92:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:92:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:92:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:93:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:93:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:93:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:93:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:93:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:93:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:93:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:94:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:94:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:94:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:94:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:94:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:94:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:94:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:95:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:95:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:95:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:95:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:95:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:95:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:95:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:96:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:96:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:96:15
    Literal(lit 7);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:96:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:96:17
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:96:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:96:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:97:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:97:3
    LoadGlobal(name 'b');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:97:15
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:97:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:97:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:97:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:97:21
    // Grow an empty array (`a` is an empty array so far)
    Literal(lit 10);                     // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:100:10
    LoadGlobal(name 'a');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:100:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:100:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:100:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:100:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:100:5
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:101:10
    LoadGlobal(name 'a');                // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:101:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:101:5
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:101:5
    ObjectSet();                         // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:101:5
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:101:5
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:102:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:102:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:102:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:102:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:102:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:102:25
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:102:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:103:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:103:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:103:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:103:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:103:17
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:103:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:103:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:104:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:104:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:104:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:104:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:104:17
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:104:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:104:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:105:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:105:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:105:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:105:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:105:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:105:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:105:21
    // Test elision
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:108:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:108:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:108:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:108:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:108:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:108:25
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:108:25
    // Length is 4, even though it ends in a hole
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:109:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:109:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:109:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:109:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:109:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:109:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:109:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:110:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:110:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:110:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:110:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:110:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:110:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:110:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:111:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:111:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:111:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:111:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:111:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:111:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:111:21
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:112:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:112:3
    LoadGlobal(name 'c');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:112:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:112:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:112:17
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:112:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:112:21
    // Test Array.push
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:115:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:115:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:115:10
    Literal(lit '__proto__');            // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:115:10
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:115:10
    Literal(lit null);                   // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:115:26
    BinOp(op '!==');                     // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:115:26
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:115:26
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:116:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:116:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:116:10
    Literal(lit '__proto__');            // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:116:10
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:116:10
    Literal(lit 'push');                 // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:116:10
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:116:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:116:31
    BinOp(op '!==');                     // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:116:31
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:116:31
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:117:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:117:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:117:10
    Literal(lit 'push');                 // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:117:10
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:117:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:117:21
    BinOp(op '!==');                     // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:117:21
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:117:21
    LoadGlobal(name 'a');                // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:118:3
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:118:3
    Literal(lit 'push');                 // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:118:3
    ObjectGet();                         // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:118:3
    LoadVar(index 0);                    // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:118:3
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:118:10
    Call(count 2, true);                 // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:118:10
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:118:10
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:119:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:119:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:119:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:119:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:119:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:119:25
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:119:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:120:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:120:3
    LoadGlobal(name 'a');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:120:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:120:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:120:17
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:120:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:120:21
    // See that the nested arrays are correct
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:123:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:123:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:123:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:123:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:123:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:123:25
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:123:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:124:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:124:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:124:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:124:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:124:17
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:124:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:124:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:124:28
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:124:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:125:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:125:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:125:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:125:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:125:17
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:125:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:125:20
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:125:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:125:20
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:125:31
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:125:31
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:126:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:126:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:126:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:126:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:126:17
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:126:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:126:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:126:23
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:126:23
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:126:27
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:126:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:127:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:127:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:127:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:127:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:127:17
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:127:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:127:20
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:127:23
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:127:23
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:127:27
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:127:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:128:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:128:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:128:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:128:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:128:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:128:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:128:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:128:23
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:128:23
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:128:27
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:128:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:129:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:129:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:129:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:129:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:129:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:129:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:129:20
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:129:23
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:129:23
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:129:27
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:129:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:130:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:130:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:130:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:130:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:130:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:130:20
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:130:20
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:130:24
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:130:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:131:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:131:3
    LoadGlobal(name 'd');                // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:131:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:131:17
    ObjectGet();                         // 3                 ./test/end-to-end/tests/arrays.test.mvm.js:131:17
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/arrays.test.mvm.js:131:21
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:131:21
    // Reset the arrays to their initial state, because this test runs multiple
    // times (before and after the snapshot)
    LoadGlobal(name 'init');             // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:135:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/arrays.test.mvm.js:135:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:135:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/arrays.test.mvm.js:136:2
    Return();                            // 0                 ./test/end-to-end/tests/arrays.test.mvm.js:136:2
}