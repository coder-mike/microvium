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
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function foo);
    StoreGlobal(name 'foo');
    Literal(lit &function bar);
    StoreGlobal(name 'bar');
    Literal(lit &function concat);
    StoreGlobal(name 'concat');
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
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
    Literal(lit deleted);
    // Basic function
    LoadGlobal(name 'foo');
    Literal(lit undefined);
    Literal(lit 'a');
    Call(count 2);
    Pop(count 1);
    // Higher-order function
    LoadGlobal(name 'bar');
    Literal(lit undefined);
    LoadGlobal(name 'foo');
    Literal(lit 'b');
    Call(count 3);
    Pop(count 1);
    // Arguments and return value
    LoadGlobal(name 'concat');
    Literal(lit undefined);
    Literal(lit 'a');
    Literal(lit 'b');
    Literal(lit 'c');
    Call(count 4);
    StoreVar(index 0);
    LoadGlobal(name 'foo');
    Literal(lit undefined);
    LoadVar(index 0);
    Call(count 2);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function foo() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'foo ');
    LoadArg(index 1);
    BinOp(op '+');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function bar() {
  entry:
    LoadArg(index 1);
    Literal(lit undefined);
    Literal(lit 'bar ');
    LoadArg(index 2);
    BinOp(op '+');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function concat() {
  entry:
    LoadArg(index 1);
    Literal(lit ' ');
    BinOp(op '+');
    LoadArg(index 2);
    BinOp(op '+');
    Literal(lit ' ');
    BinOp(op '+');
    LoadArg(index 3);
    BinOp(op '+');
    Return();
}