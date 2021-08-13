unit ['./test/end-to-end/tests/closures-and-scopes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global makeIncrementorA;
global makeIncrementorA2;
global makeIncrementorB;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function makeIncrementorA);
    StoreGlobal(name 'makeIncrementorA');
    Literal(lit &function makeIncrementorA2);
    StoreGlobal(name 'makeIncrementorA2');
    Literal(lit &function makeIncrementorB);
    StoreGlobal(name 'makeIncrementorB');
    // ---
    // runExportedFunction: 0
    // assertionCount: 8
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
    LoadGlobal(name 'makeIncrementorA2');
    Literal(lit undefined);
    Call(count 1);
    StoreVar(index 2);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'makeIncrementorB');
    Literal(lit undefined);
    Call(count 1);
    StoreVar(index 3);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 3);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 3);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    Pop(count 4);
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

function makeIncrementorA2() {
  entry:
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 0);
    // Function expression (note that we do not support named function expressions, yet)
    Literal(lit &function anonymous1);
    ClosureNew();
    Return();
}

function anonymous1() {
  entry:
    LoadScoped(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 0);
    Return();
}

function makeIncrementorB() {
  entry:
    ScopePush(count 1);
    Literal(lit &function increment);
    ClosureNew();
    Literal(lit 0);
    StoreScoped(index 0);
    LoadVar(index 0);
    Return();
}

function increment() {
  entry:
    LoadScoped(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 0);
    Return();
}