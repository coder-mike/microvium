unit ['./test/end-to-end/tests/object-keys.test.mvm.js'];

entry ['#entry'];

external Reflect from free-variable 'Reflect';
external assertEqual from free-variable 'assertEqual';
external vmExport from free-variable 'vmExport';

global thisModule;
global objBeforeSnapshot;
global keysBeforeSnapshot;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/object-keys.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/object-keys.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/object-keys.test.mvm.js:1:1
    // ---
    // description: >
    // Tests Reflect.ownKeys
    // runExportedFunction: 0
    // # testOnly: true
    // assertionCount: 10
    // ---
    ObjectNew();                         // 2                 ./test/end-to-end/tests/object-keys.test.mvm.js:9:27
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:9:27
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:9:27
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:10:6
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-keys.test.mvm.js:10:6
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:10:6
    Literal(lit 'y');                    // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:10:6
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:11:6
    ObjectSet();                         // 2                 ./test/end-to-end/tests/object-keys.test.mvm.js:11:6
    StoreGlobal(name 'objBeforeSnapshot'); // 1               ./test/end-to-end/tests/object-keys.test.mvm.js:11:6
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/object-keys.test.mvm.js:14:28
    LoadGlobal(name 'Reflect');          // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:14:28
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:14:28
    Literal(lit 'ownKeys');              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:14:28
    ObjectGet();                         // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:14:28
    StoreVar(index 1);                   // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:14:28
    LoadGlobal(name 'objBeforeSnapshot'); // 4                ./test/end-to-end/tests/object-keys.test.mvm.js:14:44
    Call(count 2, flag false);           // 2                 ./test/end-to-end/tests/object-keys.test.mvm.js:14:44
    StoreGlobal(name 'keysBeforeSnapshot'); // 1              ./test/end-to-end/tests/object-keys.test.mvm.js:14:44
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/object-keys.test.mvm.js:39:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:39:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:39:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/object-keys.test.mvm.js:39:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/object-keys.test.mvm.js:39:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/object-keys.test.mvm.js:39:13
    Return();                            // 1                 ./test/end-to-end/tests/object-keys.test.mvm.js:39:13
}

function run() {
  entry:
    Literal(lit deleted);                // 1  keysAfterSnapshot ./test/end-to-end/tests/object-keys.test.mvm.js:16:16
    Literal(lit deleted);                // 2  objAfterSnapshot ./test/end-to-end/tests/object-keys.test.mvm.js:16:16
    Literal(lit deleted);                // 3  keysAfterSnapshot2 ./test/end-to-end/tests/object-keys.test.mvm.js:16:16
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:17:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:17:3
    LoadGlobal(name 'keysBeforeSnapshot'); // 6               ./test/end-to-end/tests/object-keys.test.mvm.js:17:15
    Literal(lit 'length');               // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:17:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:17:15
    Literal(lit 2);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:17:42
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:17:42
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:18:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:18:3
    LoadGlobal(name 'keysBeforeSnapshot'); // 6               ./test/end-to-end/tests/object-keys.test.mvm.js:18:15
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:18:34
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:18:34
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:18:38
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:18:38
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:19:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:19:3
    LoadGlobal(name 'keysBeforeSnapshot'); // 6               ./test/end-to-end/tests/object-keys.test.mvm.js:19:15
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:19:34
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:19:34
    Literal(lit 'y');                    // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:19:38
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:19:38
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:21:29
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:21:29
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:21:29
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:21:29
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:21:29
    StoreVar(index 3);                   // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:21:29
    LoadGlobal(name 'objBeforeSnapshot'); // 6                ./test/end-to-end/tests/object-keys.test.mvm.js:21:45
    Call(count 2, flag false);           // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:21:45
    StoreVar(index 0);                   // 3  keysAfterSnapshot ./test/end-to-end/tests/object-keys.test.mvm.js:21:45
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:22:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:22:3
    LoadVar(index 0);                    // 6  keysAfterSnapshot ./test/end-to-end/tests/object-keys.test.mvm.js:22:15
    Literal(lit 'length');               // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:22:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:22:15
    Literal(lit 2);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:22:41
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:22:41
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:23:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:23:3
    LoadVar(index 0);                    // 6  keysAfterSnapshot ./test/end-to-end/tests/object-keys.test.mvm.js:23:15
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:23:33
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:23:33
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:23:37
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:23:37
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:24:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:24:3
    LoadVar(index 0);                    // 6  keysAfterSnapshot ./test/end-to-end/tests/object-keys.test.mvm.js:24:15
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:24:33
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:24:33
    Literal(lit 'y');                    // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:24:37
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:24:37
    ObjectNew();                         // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:26:28
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:26:28
    Literal(lit 'a');                    // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:26:28
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:27:8
    ObjectSet();                         // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:27:8
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:27:8
    Literal(lit 'b');                    // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:27:8
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:28:8
    ObjectSet();                         // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:28:8
    StoreVar(index 1);                   // 3  objAfterSnapshot ./test/end-to-end/tests/object-keys.test.mvm.js:28:8
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:31:30
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:31:30
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:31:30
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:31:30
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:31:30
    StoreVar(index 3);                   // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:31:30
    LoadVar(index 1);                    // 6  objAfterSnapshot ./test/end-to-end/tests/object-keys.test.mvm.js:31:46
    Call(count 2, flag false);           // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:31:46
    StoreVar(index 2);                   // 3  keysAfterSnapshot2 ./test/end-to-end/tests/object-keys.test.mvm.js:31:46
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:32:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:32:3
    LoadVar(index 2);                    // 6  keysAfterSnapshot2 ./test/end-to-end/tests/object-keys.test.mvm.js:32:15
    Literal(lit 'length');               // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:32:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:32:15
    Literal(lit 2);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:32:42
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:32:42
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:33:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:33:3
    LoadVar(index 2);                    // 6  keysAfterSnapshot2 ./test/end-to-end/tests/object-keys.test.mvm.js:33:15
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:33:34
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:33:34
    Literal(lit 'a');                    // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:33:38
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:33:38
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:34:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:34:3
    LoadVar(index 2);                    // 6  keysAfterSnapshot2 ./test/end-to-end/tests/object-keys.test.mvm.js:34:15
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:34:34
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:34:34
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:34:38
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:34:38
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:15
    LoadGlobal(name 'Reflect');          // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:15
    Literal(lit 'ownKeys');              // 9                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:15
    ObjectGet();                         // 8                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:15
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:15
    ObjectNew();                         // 8                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:31
    Call(count 2, flag false);           // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:31
    Literal(lit 'length');               // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:31
    ObjectGet();                         // 6                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:31
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:43
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/object-keys.test.mvm.js:36:43
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/object-keys.test.mvm.js:37:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/object-keys.test.mvm.js:37:2
    Return();                            // 0                 ./test/end-to-end/tests/object-keys.test.mvm.js:37:2
}