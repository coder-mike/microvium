unit ['./test/end-to-end/tests/function-calls.test.mvm.js'];

entry ['#entry'];

external print from free-variable 'print';
external vmExport from free-variable 'vmExport';

global thisModule;
global foo;
global bar;
global concat;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    Literal(lit &function foo);          // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    StoreGlobal(name 'foo');             // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    Literal(lit &function bar);          // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    StoreGlobal(name 'bar');             // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    Literal(lit &function concat);       // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    StoreGlobal(name 'concat');          // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:1:1
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:30:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:30:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/function-calls.test.mvm.js:30:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/function-calls.test.mvm.js:30:13
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:30:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:30:13
    Return();                            // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:30:13
}

// ---
runExportedFunction: 0
expectedPrintout: |
  foo a
  foo bar b
  foo a b c
---
function run() {
  entry:
    Literal(lit deleted);                // 1  x              ./test/end-to-end/tests/function-calls.test.mvm.js:8:16
    // Basic function
    LoadGlobal(name 'foo');              // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:10:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:10:3
    Literal(lit 'a');                    // 4                 ./test/end-to-end/tests/function-calls.test.mvm.js:10:7
    Call(count 2, true);                 // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:10:7
    // Higher-order function
    LoadGlobal(name 'bar');              // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:12:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:12:3
    LoadGlobal(name 'foo');              // 4                 ./test/end-to-end/tests/function-calls.test.mvm.js:12:7
    Literal(lit 'b');                    // 5                 ./test/end-to-end/tests/function-calls.test.mvm.js:12:12
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:12:12
    // Arguments and return value
    LoadGlobal(name 'concat');           // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:14:13
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:14:13
    Literal(lit 'a');                    // 4                 ./test/end-to-end/tests/function-calls.test.mvm.js:14:20
    Literal(lit 'b');                    // 5                 ./test/end-to-end/tests/function-calls.test.mvm.js:14:25
    Literal(lit 'c');                    // 6                 ./test/end-to-end/tests/function-calls.test.mvm.js:14:30
    Call(count 4, true);                 // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:14:30
    StoreVar(index 0);                   // 1  x              ./test/end-to-end/tests/function-calls.test.mvm.js:14:30
    LoadGlobal(name 'foo');              // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:15:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:15:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/function-calls.test.mvm.js:15:7
    Call(count 2, true);                 // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:15:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/function-calls.test.mvm.js:16:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:16:2
    Return();                            // 0                 ./test/end-to-end/tests/function-calls.test.mvm.js:16:2
}

function foo() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:19:3
    Literal(lit 'foo ');                 // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:19:9
    LoadArg(index 1);                    // 4  x              ./test/end-to-end/tests/function-calls.test.mvm.js:19:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:19:18
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/function-calls.test.mvm.js:19:18
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:20:2
    Return();                            // 0                 ./test/end-to-end/tests/function-calls.test.mvm.js:20:2
}

function bar() {
  entry:
    LoadArg(index 1);                    // 1  f              ./test/end-to-end/tests/function-calls.test.mvm.js:23:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:23:3
    Literal(lit 'bar ');                 // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:23:5
    LoadArg(index 2);                    // 4  x              ./test/end-to-end/tests/function-calls.test.mvm.js:23:14
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/function-calls.test.mvm.js:23:14
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/function-calls.test.mvm.js:23:14
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:24:2
    Return();                            // 0                 ./test/end-to-end/tests/function-calls.test.mvm.js:24:2
}

function concat() {
  entry:
    LoadArg(index 1);                    // 1  a              ./test/end-to-end/tests/function-calls.test.mvm.js:27:10
    Literal(lit ' ');                    // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:27:14
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:27:14
    LoadArg(index 2);                    // 2  b              ./test/end-to-end/tests/function-calls.test.mvm.js:27:20
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:27:20
    Literal(lit ' ');                    // 2                 ./test/end-to-end/tests/function-calls.test.mvm.js:27:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:27:24
    LoadArg(index 3);                    // 2  c              ./test/end-to-end/tests/function-calls.test.mvm.js:27:30
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/function-calls.test.mvm.js:27:30
    Return();                            // 0                 ./test/end-to-end/tests/function-calls.test.mvm.js:27:30
}