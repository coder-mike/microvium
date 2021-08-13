unit ['./test/end-to-end/tests/closures-and-scopes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global makeIncrementorA;
global makeIncrementorA2;
global makeIncrementorB;
global makeIncrementorC;
global nestedLexicalScopes;

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
    Literal(lit &function makeIncrementorC);
    StoreGlobal(name 'makeIncrementorC');
    Literal(lit &function nestedLexicalScopes);
    StoreGlobal(name 'nestedLexicalScopes');
    // ---
    // runExportedFunction: 0
    // assertionCount: 16
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    // Double-nested functions
    Literal(lit undefined);
    Return();
}

function run() {
  entry:
    Literal(lit deleted);
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
    LoadGlobal(name 'makeIncrementorC');
    Literal(lit undefined);
    Call(count 1);
    StoreVar(index 4);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 4);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 4);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'nestedLexicalScopes');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Pop(count 5);
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

function makeIncrementorC() {
  entry:
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 0);
    // The inner-most function doesn't access its direct outer scope. It accesses
    // its grandparent scope.
    Literal(lit &function anonymous2);
    ClosureNew();
    Return();
}

function anonymous2() {
  entry:
    Literal(lit &function anonymous3);
    ClosureNew();
    Return();
}

function anonymous3() {
  entry:
    LoadScoped(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 0);
    Return();
}

function nestedLexicalScopes() {
  entry:
    ScopePush(count 3);
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit 1);
    StoreScoped(index 0);
    Literal(lit undefined);
    StoreVar(index 0);
    Literal(lit undefined);
    StoreVar(index 1);
    Literal(lit undefined);
    StoreVar(index 2);
    Literal(lit 50);
    StoreScoped(index 1);
    Literal(lit &function anonymous4);
    ClosureNew();
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 100);
    StoreScoped(index 2);
    Literal(lit &function anonymous5);
    ClosureNew();
    LoadVar(index 3);
    StoreVar(index 1);
    Pop(count 1);
    Literal(lit &function anonymous6);
    ClosureNew();
    LoadVar(index 3);
    StoreVar(index 2);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 50);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 51);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 100);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 101);
    Call(count 3);
    Pop(count 1);
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
    Pop(count 3);
    Literal(lit undefined);
    Return();
}

function anonymous4() {
  entry:
    LoadScoped(index 1);
    LoadVar(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 1);
    StoreScoped(index 1);
    Pop(count 1);
    Return();
}

function anonymous5() {
  entry:
    LoadScoped(index 2);
    LoadVar(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 1);
    StoreScoped(index 2);
    Pop(count 1);
    Return();
}

function anonymous6() {
  entry:
    LoadScoped(index 0);
    LoadVar(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 1);
    StoreScoped(index 0);
    Pop(count 1);
    Return();
}