unit ['./test/end-to-end/tests/object-operations.test.mvm.js'];

entry ['#entry'];

external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';
external vmExport from free-variable 'vmExport';

global thisModule;
global objBeforeSnapshot;
global foo2;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/object-operations.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:1:1
    Literal(lit &function foo);          // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:1:1
    Literal(lit &function foo2);         // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:1:1
    StoreGlobal(name 'foo2');            // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:1:1
    // ---
    // description: >
    // Tests various object operations
    // runExportedFunction: 0
    // assertionCount: 16
    // ---
    // TODO: Computed properties
    ObjectNew();                         // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:8:27
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:8:27
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:8:27
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/object-operations.test.mvm.js:9:6
    ObjectSet();                         // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:9:6
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:9:6
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:9:6
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/object-operations.test.mvm.js:10:6
    ObjectSet();                         // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:10:6
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:10:6
    Literal(lit 'f');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:10:6
    LoadVar(index 1);                    // 6  foo            ./test/end-to-end/tests/object-operations.test.mvm.js:11:6
    ObjectSet();                         // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:11:6
    StoreGlobal(name 'objBeforeSnapshot'); // 2               ./test/end-to-end/tests/object-operations.test.mvm.js:11:6
    LoadGlobal(name 'vmExport');         // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:63:1
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:63:1
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:63:10
    LoadVar(index 0);                    // 6  run            ./test/end-to-end/tests/object-operations.test.mvm.js:63:13
    Call(count 3, true);                 // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:63:13
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:63:13
    Return();                            // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:63:13
}

function run() {
  entry:
    Literal(lit deleted);                // 1  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:14:16
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:15:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:15:3
    LoadGlobal(name 'objBeforeSnapshot'); // 4                ./test/end-to-end/tests/object-operations.test.mvm.js:15:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:15:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:15:15
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:15:36
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:15:36
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:16:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:16:3
    LoadGlobal(name 'objBeforeSnapshot'); // 4                ./test/end-to-end/tests/object-operations.test.mvm.js:16:15
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:16:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:16:15
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:16:36
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:16:36
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:17:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:17:3
    LoadGlobal(name 'objBeforeSnapshot'); // 4                ./test/end-to-end/tests/object-operations.test.mvm.js:17:15
    Literal(lit 'z');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:17:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:17:15
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:17:36
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:17:36
    // Method call
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:3
    LoadGlobal(name 'objBeforeSnapshot'); // 4                ./test/end-to-end/tests/object-operations.test.mvm.js:20:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:15
    Literal(lit 'f');                    // 6                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:15
    Literal(lit 17);                     // 7                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:35
    Call(count 2, true);                 // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:35
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:35
    Literal(lit 18);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:40
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:20:40
    // Set existing property on snapshotted object
    Literal(lit 12);                     // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:23:25
    LoadGlobal(name 'objBeforeSnapshot'); // 3                ./test/end-to-end/tests/object-operations.test.mvm.js:23:3
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:23:3
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:23:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:23:3
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:23:3
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:24:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:24:3
    LoadGlobal(name 'objBeforeSnapshot'); // 4                ./test/end-to-end/tests/object-operations.test.mvm.js:24:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:24:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:24:15
    Literal(lit 12);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:24:36
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:24:36
    // Create new property on snapshotted object
    Literal(lit 13);                     // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:26:25
    LoadGlobal(name 'objBeforeSnapshot'); // 3                ./test/end-to-end/tests/object-operations.test.mvm.js:26:3
    Literal(lit 'z');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:26:3
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:26:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:26:3
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:26:3
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:27:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:27:3
    LoadGlobal(name 'objBeforeSnapshot'); // 4                ./test/end-to-end/tests/object-operations.test.mvm.js:27:15
    Literal(lit 'z');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:27:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:27:15
    Literal(lit 13);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:27:36
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:27:36
    // New empty object
    ObjectNew();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:15
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:15
    Literal(lit 'a');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:15
    Literal(lit 14);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:20
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:20
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:20
    Literal(lit 'b');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:20
    Literal(lit 15);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:27
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:27
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:27
    Literal(lit 'f');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:27
    LoadGlobal(name 'foo2');             // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:34
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:30:34
    StoreVar(index 0);                   // 1  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:30:34
    Literal(lit 16);                     // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:31:11
    LoadVar(index 0);                    // 3  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:31:3
    Literal(lit 'c');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:31:3
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:31:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:31:3
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:31:3
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:32:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:32:3
    LoadVar(index 0);                    // 4  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:32:15
    Literal(lit 'a');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:32:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:32:15
    Literal(lit 14);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:32:22
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:32:22
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:33:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:33:3
    LoadVar(index 0);                    // 4  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:33:15
    Literal(lit 'b');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:33:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:33:15
    Literal(lit 15);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:33:22
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:33:22
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:34:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:34:3
    LoadVar(index 0);                    // 4  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:34:15
    Literal(lit 'c');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:34:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:34:15
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:34:22
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:34:22
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:35:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:35:3
    LoadVar(index 0);                    // 4  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:35:15
    Literal(lit 'd');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:35:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:35:15
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:35:22
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:35:22
    // Method call
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:3
    LoadVar(index 0);                    // 4  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:38:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:15
    Literal(lit 'f');                    // 6                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:15
    Literal(lit 19);                     // 7                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:21
    Call(count 2, true);                 // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:21
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:21
    Literal(lit 20);                     // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:26
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:38:26
    Literal(lit 'obj');                  // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:40:22
    LoadVar(index 0);                    // 3  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:40:3
    Literal(lit 'n');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:40:7
    Literal(lit 'ame');                  // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:40:13
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:40:13
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:40:13
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:40:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:40:13
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:41:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:41:3
    LoadVar(index 0);                    // 4  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:41:15
    Literal(lit 'name');                 // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:41:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:41:15
    Literal(lit 'obj');                  // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:41:25
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:41:25
    // The string "name1" (and "name2") doesn't occur in the source text, so it's
    // not in the intern table in the bytecode, but it still needs to be in the
    // runtime intern table.
    Literal(lit 'obj1');                 // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:46:23
    LoadVar(index 0);                    // 3  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:46:3
    Literal(lit 'n');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:46:7
    Literal(lit 'ame1');                 // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:46:13
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:46:13
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:46:13
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:46:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:46:13
    Literal(lit 'obj2');                 // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:47:23
    LoadVar(index 0);                    // 3  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:47:3
    Literal(lit 'n');                    // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:47:7
    Literal(lit 'ame2');                 // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:47:13
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:47:13
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:47:13
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:47:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:47:13
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:48:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:48:3
    LoadVar(index 0);                    // 4  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:48:15
    Literal(lit 'n');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:48:19
    Literal(lit 'ame1');                 // 6                 ./test/end-to-end/tests/object-operations.test.mvm.js:48:25
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:48:25
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:48:25
    Literal(lit 'obj1');                 // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:48:34
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:48:34
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:49:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-operations.test.mvm.js:49:3
    LoadVar(index 0);                    // 4  obj            ./test/end-to-end/tests/object-operations.test.mvm.js:49:15
    Literal(lit 'n');                    // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:49:19
    Literal(lit 'ame2');                 // 6                 ./test/end-to-end/tests/object-operations.test.mvm.js:49:25
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:49:25
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:49:25
    Literal(lit 'obj2');                 // 5                 ./test/end-to-end/tests/object-operations.test.mvm.js:49:34
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:49:34
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/object-operations.test.mvm.js:51:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:51:2
    Return();                            // 0                 ./test/end-to-end/tests/object-operations.test.mvm.js:51:2
}

function foo() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:54:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:54:3
    LoadArg(index 1);                    // 3  a              ./test/end-to-end/tests/object-operations.test.mvm.js:54:15
    Literal(lit 17);                     // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:54:18
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/object-operations.test.mvm.js:54:18
    Literal(lit 18);                     // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:55:10
    Return();                            // 0                 ./test/end-to-end/tests/object-operations.test.mvm.js:55:10
}

function foo2() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:59:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/object-operations.test.mvm.js:59:3
    LoadArg(index 1);                    // 3  a              ./test/end-to-end/tests/object-operations.test.mvm.js:59:15
    Literal(lit 19);                     // 4                 ./test/end-to-end/tests/object-operations.test.mvm.js:59:18
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/object-operations.test.mvm.js:59:18
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/object-operations.test.mvm.js:60:10
    Return();                            // 0                 ./test/end-to-end/tests/object-operations.test.mvm.js:60:10
}