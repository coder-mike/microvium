unit ['./test/end-to-end/tests/closures-across-snapshot.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function init);
    // ---
    // runExportedFunction: 0
    // ---
    LoadVar(index 0);
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function init() {
  entry:
    ScopePush(count 1);
    Literal(lit &function run);
    ClosureNew();
    Literal(lit 1);
    StoreScoped(index 1);
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadScoped(index 1);
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}