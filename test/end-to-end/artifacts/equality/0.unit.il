unit ['./test/end-to-end/tests/equality.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assert from free-variable 'assert';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: >
    // Testing equality and inequality operators
    // runExportedFunction: 0
    // assertionCount: 2
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
    // TODO: Flesh out these tests
    LoadGlobal(name 'assert');
    Literal(lit undefined);
    Literal(lit 'ab');
    Literal(lit 'a');
    Literal(lit 'b');
    BinOp(op '+');
    BinOp(op '===');
    Call(count 2);
    Pop(count 1);
    LoadGlobal(name 'assert');
    Literal(lit undefined);
    Literal(lit 'ab');
    Literal(lit 'a');
    Literal(lit 'c');
    BinOp(op '+');
    BinOp(op '!==');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}