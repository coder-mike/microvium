unit ['./test/end-to-end/tests/uint8Array.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external Microvium from free-variable 'Microvium';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global buf1;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/uint8Array.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:1:1
    // ---
    // description: Tests of Uint8Array
    // runExportedFunction: 0
    // assertionCount: 8
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:6:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:6:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:6:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/uint8Array.test.mvm.js:6:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:6:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:14
    LoadGlobal(name 'Microvium');        // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:14
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:14
    Literal(lit 'newUint8Array');        // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:14
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:14
    StoreVar(index 1);                   // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:14
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:38
    Call(count 2, flag false);           // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:38
    StoreGlobal(name 'buf1');            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:8:38
    Literal(lit deleted);                // 2  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:9:1
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:14
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:9:14
    Jump(@block1);                       // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:14
  block1:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:9:17
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:21
    Literal(lit 'length');               // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:21
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:21
    Branch(@block2, @block3);            // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:21
  block2:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:10:13
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:10:17
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:10:17
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:10:3
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:10:8
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/uint8Array.test.mvm.js:10:8
    ObjectSet();                         // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:10:8
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:10:8
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
    StoreVar(index 1);                   // 4  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
    Jump(@block1);                       // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:9:34
  block3:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:10:19
    // Writing to Uint8Array at compile-time
    // Reading from Uint8Array at compile-time
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:13:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:13:1
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:13:13
    Literal(lit 'length');               // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:13:13
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:13:13
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:13:26
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:13:26
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:14:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:14:1
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:14:13
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:14:18
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:14:18
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:14:22
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:14:22
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:15:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:15:1
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:15:13
    Literal(lit 4);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:15:18
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:15:18
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:15:22
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:15:22
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:17:1
    Return();                            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:17:1
}

function run() {
  entry:
    Literal(lit deleted);                // 1  buf2           ./test/end-to-end/tests/uint8Array.test.mvm.js:17:16
    // Reading from compile-time Uint8Array at runtime
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:19:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:19:3
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:19:15
    Literal(lit 'length');               // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:19:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:19:15
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:19:28
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:19:28
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:20:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:20:3
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:20:15
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:20:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:20:20
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:20:24
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:20:24
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:21:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:21:3
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:21:15
    Literal(lit 4);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:21:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:21:20
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:21:24
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:21:24
    // Mutating compile-time Uint8Array at runtime
    Literal(lit 42);                     // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:24:13
    LoadGlobal(name 'buf1');             // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:24:3
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:24:8
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:24:8
    ObjectSet();                         // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:24:8
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:24:8
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:25:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:25:3
    LoadGlobal(name 'buf1');             // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:25:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:25:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:25:20
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:25:24
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:25:24
    // Creating Uint8Array at runtime
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:28:16
    LoadGlobal(name 'Microvium');        // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:28:16
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:28:16
    Literal(lit 'newUint8Array');        // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:28:16
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:28:16
    StoreVar(index 1);                   // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:28:16
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:28:40
    Call(count 2, flag false);           // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:28:40
    StoreVar(index 0);                   // 1  buf2           ./test/end-to-end/tests/uint8Array.test.mvm.js:28:40
    Literal(lit deleted);                // 2  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:29:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:16
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:29:16
    Jump(@block4);                       // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:16
  block4:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:29:19
    LoadVar(index 0);                    // 4  buf2           ./test/end-to-end/tests/uint8Array.test.mvm.js:29:23
    Literal(lit 'length');               // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:23
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:23
    Branch(@block5, @block6);            // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:23
  block5:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:30:15
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:30:19
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:30:19
    LoadVar(index 0);                    // 4  buf2           ./test/end-to-end/tests/uint8Array.test.mvm.js:30:5
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:30:10
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/uint8Array.test.mvm.js:30:10
    ObjectSet();                         // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:30:10
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:30:10
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
    StoreVar(index 1);                   // 4  i              ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
    Jump(@block4);                       // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:29:36
  block6:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:30:23
    // Writing
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:31:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:31:3
    LoadVar(index 0);                    // 4  buf2           ./test/end-to-end/tests/uint8Array.test.mvm.js:31:15
    Literal(lit 'length');               // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:31:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:31:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:31:28
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:31:28
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:32:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:32:3
    LoadVar(index 0);                    // 4  buf2           ./test/end-to-end/tests/uint8Array.test.mvm.js:32:15
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:32:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:32:20
    Literal(lit 100);                    // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:32:24
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:32:24
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:33:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:33:3
    LoadVar(index 0);                    // 4  buf2           ./test/end-to-end/tests/uint8Array.test.mvm.js:33:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:33:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:33:20
    Literal(lit 101);                    // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:33:24
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:33:24
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/uint8Array.test.mvm.js:34:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/uint8Array.test.mvm.js:34:3
    LoadVar(index 0);                    // 4  buf2           ./test/end-to-end/tests/uint8Array.test.mvm.js:34:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:34:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/uint8Array.test.mvm.js:34:20
    Literal(lit 102);                    // 5                 ./test/end-to-end/tests/uint8Array.test.mvm.js:34:24
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:34:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/uint8Array.test.mvm.js:35:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/uint8Array.test.mvm.js:35:2
    Return();                            // 0                 ./test/end-to-end/tests/uint8Array.test.mvm.js:35:2
}