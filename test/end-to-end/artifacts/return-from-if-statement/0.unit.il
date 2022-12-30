unit ['./test/end-to-end/tests/return-from-if-statement.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external console from free-variable 'console';

global thisModule;
global foo;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:1:1
    Literal(lit &function foo);          // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:1:1
    StoreGlobal(name 'foo');             // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // expectedPrintout: |
    // Consequent path
    // Alternate path
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:7:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:7:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:7:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:7:13
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:7:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:14:1
    Return();                            // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:14:1
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:10:3
    LoadGlobal(name 'foo');              // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:10:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:10:15
    Literal(lit true);                   // 5                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:10:19
    Call(count 2, true);                 // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:10:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:10:26
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:10:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:11:3
    LoadGlobal(name 'foo');              // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:11:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:11:15
    Literal(lit false);                  // 5                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:11:19
    Call(count 2, true);                 // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:11:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:11:27
    Call(count 3, true);                 // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:11:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:12:2
    Return();                            // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:12:2
}

function foo() {
  entry:
    LoadArg(index 1);                    // 1  b              ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:15:7
    Branch(@block1, @block2);            // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:15:3
  block1:
    LoadGlobal(name 'console');          // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:16:5
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:16:5
    Literal(lit 'log');                  // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:16:5
    ObjectGet();                         // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:16:5
    LoadVar(index 0);                    // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:16:5
    Literal(lit 'Consequent path');      // 4                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:16:17
    Call(count 2, true);                 // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:16:17
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:16:17
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:17:12
    Return();                            // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:17:12
  block2:
    LoadGlobal(name 'console');          // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:19:5
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:19:5
    Literal(lit 'log');                  // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:19:5
    ObjectGet();                         // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:19:5
    LoadVar(index 0);                    // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:19:5
    Literal(lit 'Alternate path');       // 4                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:19:17
    Call(count 2, true);                 // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:19:17
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:19:17
    Literal(lit 2);                      // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:20:12
    Return();                            // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:20:12
  block3:
    LoadGlobal(name 'console');          // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:22:3
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:22:3
    Literal(lit 'log');                  // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:22:3
    ObjectGet();                         // 2                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:22:3
    LoadVar(index 0);                    // 3                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:22:3
    Literal(lit 'Shouldn\'t get here');  // 4                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:22:15
    Call(count 2, true);                 // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:22:15
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:22:15
    Literal(lit 3);                      // 1                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:23:10
    Return();                            // 0                 ./test/end-to-end/tests/return-from-if-statement.test.mvm.js:23:10
}