unit ['./test/end-to-end/tests/no-op-function.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external Microvium from free-variable 'Microvium';
external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';
external assert from free-variable 'assert';
external Number from free-variable 'Number';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/no-op-function.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // assertionCount: 8
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:6:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:6:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:6:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/no-op-function.test.mvm.js:6:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:6:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:8:1
    Return();                            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:8:1
}

function run() {
  entry:
    Literal(lit deleted);                // 1  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:8:16
    LoadGlobal(name 'Microvium');        // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:9:15
    Literal(lit 'noOpFunction');         // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:9:15
    ObjectGet();                         // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:9:15
    StoreVar(index 0);                   // 1  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:9:15
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:10:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:10:3
    LoadVar(index 0);                    // 4  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:10:22
    UnOp(op 'typeof');                   // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:10:22
    Literal(lit 'function');             // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:10:27
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:10:27
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:3
    LoadGlobal(name 'Microvium');        // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:15
    Literal(lit 'typeCodeOf');           // 6                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:15
    LoadVar(index 0);                    // 7  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:11:36
    Call(count 2, flag false);           // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:36
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:36
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:42
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:11:42
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:12:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:12:3
    LoadVar(index 0);                    // 4  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:12:15
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:12:15
    Call(count 1, flag false);           // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:12:15
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:12:22
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:12:22
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:13:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:13:3
    LoadVar(index 0);                    // 4  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:13:15
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:13:15
    Literal(lit 42);                     // 6                 ./test/end-to-end/tests/no-op-function.test.mvm.js:13:19
    Call(count 2, flag false);           // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:13:19
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:13:24
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:13:24
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:3
    Literal(lit '');                     // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:15
    LoadVar(index 0);                    // 5  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:14:20
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:20
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:25
    Literal(lit 'isMicrovium');          // 6                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:25
    ObjectGet();                         // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:25
    Branch(@block1, @block2);            // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:25
  block1:
    Literal(lit '[Function]');           // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:49
    Jump(@block3);                       // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:49
  block2:
    Literal(lit '() => undefined');      // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:64
    Jump(@block3);                       // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:64
  block3:
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:14:64
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:15:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:15:3
    LoadVar(index 0);                    // 4  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:15:15
    LoadVar(index 0);                    // 5  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:15:23
    BinOp(op '===');                     // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:15:23
    Literal(lit true);                   // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:15:28
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:15:28
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:16:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:16:3
    LoadVar(index 0);                    // 4  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:16:15
    LoadVar(index 0);                    // 5  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:16:23
    BinOp(op '!==');                     // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:16:23
    Literal(lit false);                  // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:16:28
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:16:28
    LoadGlobal(name 'assert');           // 2                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:3
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:10
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:10
    LoadVar(index 0);                    // 7  nof            ./test/end-to-end/tests/no-op-function.test.mvm.js:17:24
    UnOp(op '+');                        // 7                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:24
    Call(count 2, flag false);           // 5                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:24
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:24
    Call(count 2, flag true);            // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:17:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/no-op-function.test.mvm.js:18:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/no-op-function.test.mvm.js:18:2
    Return();                            // 0                 ./test/end-to-end/tests/no-op-function.test.mvm.js:18:2
}