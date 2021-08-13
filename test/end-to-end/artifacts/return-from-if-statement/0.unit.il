unit ['./test/end-to-end/tests/return-from-if-statement.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external console from free-variable 'console';

global thisModule;
global foo;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function foo);
    StoreGlobal(name 'foo');
    // ---
    // runExportedFunction: 0
    // expectedPrintout: |
    // Consequent path
    // Alternate path
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'foo');
    Literal(lit undefined);
    Literal(lit true);
    Call(count 2);
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'foo');
    Literal(lit undefined);
    Literal(lit false);
    Call(count 2);
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function foo() {
  entry:
    LoadArg(index 1);
    Branch(@block1, @block2);
  block1:
    LoadGlobal(name 'console');
    LoadVar(index 0);
    Literal(lit 'log');
    ObjectGet();
    LoadVar(index 0);
    Literal(lit 'Consequent path');
    Call(count 2);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 1);
    Return();
  block2:
    LoadGlobal(name 'console');
    LoadVar(index 0);
    Literal(lit 'log');
    ObjectGet();
    LoadVar(index 0);
    Literal(lit 'Alternate path');
    Call(count 2);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 2);
    Return();
  block3:
    LoadGlobal(name 'console');
    LoadVar(index 0);
    Literal(lit 'log');
    ObjectGet();
    LoadVar(index 0);
    Literal(lit 'Shouldn\'t get here');
    Call(count 2);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 3);
    Return();
}