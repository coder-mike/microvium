unit ['./test/end-to-end/tests/globalThis.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external globalThis from free-variable 'globalThis';
external assertEqual from free-variable 'assertEqual';
external foo from free-variable 'foo';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/globalThis.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // nativeOnly: false
    // testOnly: false
    // description: Testing use of globalThis to interact with globals at compile time.
    // assertionCount: 2
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:9:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:9:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:9:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/globalThis.test.mvm.js:9:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:9:13
    // Creating a global using globalThis
    Literal(lit 42);                     // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:12:18
    LoadGlobal(name 'globalThis');       // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:12:1
    Literal(lit 'foo');                  // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:12:1
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:12:1
    ObjectSet();                         // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:12:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:12:1
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:13:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:13:1
    LoadGlobal(name 'globalThis');       // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:13:13
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:13:13
    ObjectGet();                         // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:13:13
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:13:29
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:13:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:14:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:14:1
    LoadGlobal(name 'foo');              // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:14:13
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:14:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:14:18
    // Compile-time mutation through global variable
    Literal(lit 43);                     // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:17:7
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:17:7
    StoreGlobal(name 'foo');             // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:17:7
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:17:7
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:18:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:18:1
    LoadGlobal(name 'foo');              // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:18:13
    Literal(lit 43);                     // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:18:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:18:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:19:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:19:1
    LoadGlobal(name 'globalThis');       // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:19:13
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:19:13
    ObjectGet();                         // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:19:13
    Literal(lit 43);                     // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:19:29
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:19:29
    // Compile-time mutation through variable name
    Literal(lit 44);                     // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:22:7
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:22:7
    StoreGlobal(name 'foo');             // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:22:7
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:22:7
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:23:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:23:1
    LoadGlobal(name 'globalThis');       // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:23:13
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:23:13
    ObjectGet();                         // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:23:13
    Literal(lit 44);                     // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:23:29
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:23:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:24:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:24:1
    LoadGlobal(name 'foo');              // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:24:13
    Literal(lit 44);                     // 5                 ./test/end-to-end/tests/globalThis.test.mvm.js:24:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:24:18
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:27:1
    Return();                            // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:27:1
}

function run() {
  entry:
    // Runtime should restore last compile-time value
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:29:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:29:3
    LoadGlobal(name 'foo');              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:29:15
    Literal(lit 44);                     // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:29:20
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/globalThis.test.mvm.js:29:20
    // Runtime mutation (only works through variable name)
    Literal(lit 45);                     // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:31:9
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:31:9
    StoreGlobal(name 'foo');             // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:31:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/globalThis.test.mvm.js:31:9
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:32:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/globalThis.test.mvm.js:32:3
    LoadGlobal(name 'foo');              // 3                 ./test/end-to-end/tests/globalThis.test.mvm.js:32:15
    Literal(lit 45);                     // 4                 ./test/end-to-end/tests/globalThis.test.mvm.js:32:20
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/globalThis.test.mvm.js:32:20
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/globalThis.test.mvm.js:33:2
    Return();                            // 0                 ./test/end-to-end/tests/globalThis.test.mvm.js:33:2
}