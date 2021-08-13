unit ['./test/end-to-end/tests/closures-and-scopes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global makeIncrementorA;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function makeIncrementorA);
    StoreGlobal(name 'makeIncrementorA');
    // ---
    // runExportedFunction: 0
    // # assertionCount: 4
    // # testOnly: true
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
    Literal(lit deleted);
    Literal(lit deleted);
    LoadGlobal(name 'makeIncrementorA');
    Literal(lit undefined);
    Call(count 1);
    StoreVar(index 0);
    LoadGlobal(name 'makeIncrementorA');
    Literal(lit undefined);
    Call(count 1);
    StoreVar(index 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}

function makeIncrementorA() {
  entry:
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 0);
    // Arrow function
    Literal(lit &function anonymous);
    ClosureNew();
    Return();
}

function anonymous() {
  entry:
    LoadScoped(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 0);
    Return();
}