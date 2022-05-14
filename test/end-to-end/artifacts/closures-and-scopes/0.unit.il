unit ['./test/end-to-end/tests/closures-and-scopes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external assert from free-variable 'assert';
external Number from free-variable 'Number';

global thisModule;
global v1;
global v4;
global basics;
global makeIncrementorA;
global makeIncrementorA2;
global makeIncrementorB;
global makeIncrementorC;
global nestedLexicalScopes;
global differentVariableTypes;
global closureOperations;
global thisCapturing;
global f;
global v2;
global rootScope;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    ScopePush(count 1);
    Literal(lit &function run);
    Literal(lit &function basics);
    StoreGlobal(name 'basics');
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
    Literal(lit &function differentVariableTypes);
    StoreGlobal(name 'differentVariableTypes');
    Literal(lit &function closureOperations);
    StoreGlobal(name 'closureOperations');
    Literal(lit &function thisCapturing);
    StoreGlobal(name 'thisCapturing');
    Literal(lit &function rootScope);
    StoreGlobal(name 'rootScope');
    // ---
    // runExportedFunction: 0
    // assertionCount: 35
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    // Double-nested functions
    Literal(lit undefined);
    StoreGlobal(name 'f');
    Literal(lit 1);
    StoreGlobal(name 'v1');
    Literal(lit 2);
    StoreGlobal(name 'v2');
    // A block
    Literal(lit 3);
    StoreScoped(index 1);
    Literal(lit 4);
    StoreGlobal(name 'v4');
    // Variables at the root level are compiled differently to variables at the
    // block level, so this is just checking that both work ok. `v1` and `v2` will
    // be promoted to global variables because they're accessed by a nested
    // function. `v4` will also be a global, because it's hoisted into the same
    // scope. `v3` will be a closure slot in the context of the entry function.
    Literal(lit &function anonymous14);
    ClosureNew();
    LoadVar(index 1);
    StoreGlobal(name 'f');
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function run() {
  entry:
    LoadGlobal(name 'basics');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'nestedLexicalScopes');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'differentVariableTypes');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'closureOperations');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'thisCapturing');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'rootScope');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function basics() {
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
    Pop(count 5);
    Literal(lit undefined);
    Return();
}

function makeIncrementorA() {
  entry:
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 1);
    // Arrow function
    Literal(lit &function anonymous);
    ClosureNew();
    Return();
}

function anonymous() {
  entry:
    LoadScoped(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 1);
    Return();
}

function makeIncrementorA2() {
  entry:
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 1);
    // Function expression (note that we do not support named function expressions, yet)
    Literal(lit &function anonymous1);
    ClosureNew();
    Return();
}

function anonymous1() {
  entry:
    LoadScoped(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 1);
    Return();
}

function makeIncrementorB() {
  entry:
    ScopePush(count 1);
    Literal(lit &function increment);
    ClosureNew();
    Literal(lit 0);
    StoreScoped(index 1);
    LoadVar(index 0);
    Return();
}

function increment() {
  entry:
    LoadScoped(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 1);
    Return();
}

function makeIncrementorC() {
  entry:
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 1);
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
    LoadScoped(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 1);
    Return();
}

function nestedLexicalScopes() {
  entry:
    ScopePush(count 3);
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit 1);
    StoreScoped(index 1);
    Literal(lit undefined);
    StoreVar(index 0);
    Literal(lit undefined);
    StoreVar(index 1);
    Literal(lit undefined);
    StoreVar(index 2);
    Literal(lit 50);
    StoreScoped(index 2);
    Literal(lit &function anonymous4);
    ClosureNew();
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 100);
    StoreScoped(index 3);
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
    LoadScoped(index 2);
    LoadVar(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 1);
    StoreScoped(index 2);
    Pop(count 1);
    Return();
}

function anonymous5() {
  entry:
    LoadScoped(index 3);
    LoadVar(index 0);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 1);
    StoreScoped(index 3);
    Pop(count 1);
    Return();
}

function anonymous6() {
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

function differentVariableTypes() {
  entry:
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit &function anonymous7);
    StoreVar(index 0);
    LoadVar(index 0);
    Literal(lit undefined);
    Literal(lit 1);
    Literal(lit 2);
    Literal(lit 3);
    Call(count 4);
    StoreVar(index 1);
    LoadVar(index 1);
    Literal(lit undefined);
    Literal(lit 4);
    Literal(lit 5);
    Literal(lit 6);
    Call(count 4);
    StoreVar(index 2);
    LoadVar(index 1);
    Literal(lit undefined);
    Literal(lit 7);
    Literal(lit 8);
    Literal(lit 9);
    Call(count 4);
    StoreVar(index 3);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    Literal(lit undefined);
    Literal(lit 10);
    Literal(lit 11);
    Literal(lit 12);
    Call(count 4);
    Literal(lit 2971);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    Literal(lit undefined);
    Literal(lit 13);
    Literal(lit 14);
    Literal(lit 15);
    Call(count 4);
    Literal(lit 3415);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    Literal(lit undefined);
    Literal(lit 16);
    Literal(lit 17);
    Literal(lit 19);
    Call(count 4);
    Literal(lit 3918);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 3);
    Literal(lit undefined);
    Literal(lit 19);
    Literal(lit 20);
    Literal(lit 21);
    Call(count 4);
    Literal(lit 3838);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 3);
    Literal(lit undefined);
    Literal(lit 22);
    Literal(lit 23);
    Literal(lit 24);
    Call(count 4);
    Literal(lit 4282);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 3);
    Literal(lit undefined);
    Literal(lit 25);
    Literal(lit 26);
    Literal(lit 27);
    Call(count 4);
    Literal(lit 4726);
    Call(count 3);
    Pop(count 1);
    Pop(count 4);
    Literal(lit undefined);
    Return();
}

function anonymous7() {
  entry:
    ScopePush(count 8);
    LoadArg(index 1);
    StoreScoped(index 1);
    LoadArg(index 3);
    StoreScoped(index 2);
    Literal(lit undefined);
    StoreScoped(index 3);
    Literal(lit undefined);
    StoreScoped(index 4);
    // mutated parameter
    Literal(lit 5);
    StoreScoped(index 5);
    // const
    Literal(lit 6);
    StoreScoped(index 3);
    // var
    Literal(lit 7);
    StoreScoped(index 6);
    // let
    // New block scope
    Literal(lit 5);
    StoreScoped(index 7);
    // const
    Literal(lit 6);
    StoreScoped(index 4);
    // var
    Literal(lit 7);
    StoreScoped(index 8);
    // let
    Literal(lit &function anonymous8);
    ClosureNew();
    Return();
}

function anonymous8() {
  entry:
    ScopePush(count 8);
    LoadArg(index 1);
    StoreScoped(index 1);
    LoadArg(index 3);
    StoreScoped(index 2);
    Literal(lit undefined);
    StoreScoped(index 3);
    Literal(lit undefined);
    StoreScoped(index 4);
    // local mutated parameter
    Literal(lit 5);
    StoreScoped(index 5);
    // const
    Literal(lit 6);
    StoreScoped(index 3);
    // var
    Literal(lit 7);
    StoreScoped(index 6);
    // let
    // New block scope
    Literal(lit 5);
    StoreScoped(index 7);
    // const
    Literal(lit 6);
    StoreScoped(index 4);
    // var
    Literal(lit 7);
    StoreScoped(index 8);
    // let
    Literal(lit &function anonymous9);
    ClosureNew();
    Return();
}

function anonymous9() {
  entry:
    LoadArg(index 3);
    // local mutated parameter
    Literal(lit 0);
    LoadScoped(index 10);
    Literal(lit 2);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 11);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 11);
    Pop(count 1);
    Literal(lit 3);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 14);
    Literal(lit 5);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 12);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 12);
    Pop(count 1);
    Literal(lit 7);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 15);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 15);
    Pop(count 1);
    Literal(lit 11);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 16);
    Literal(lit 13);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 13);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 13);
    Pop(count 1);
    Literal(lit 17);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 17);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 17);
    Pop(count 1);
    Literal(lit 19);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 1);
    Literal(lit 23);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 2);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 2);
    Pop(count 1);
    Literal(lit 29);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 5);
    Literal(lit 31);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 3);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 3);
    Pop(count 1);
    Literal(lit 37);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 6);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 6);
    Pop(count 1);
    Literal(lit 41);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 7);
    Literal(lit 43);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 4);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 4);
    Pop(count 1);
    Literal(lit 47);
    BinOp(op '*');
    BinOp(op '+');
    LoadScoped(index 8);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 8);
    Pop(count 1);
    Literal(lit 53);
    BinOp(op '*');
    BinOp(op '+');
    LoadArg(index 1);
    BinOp(op '+');
    LoadVar(index 0);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 59);
    BinOp(op '*');
    BinOp(op '+');
    Return();
}

function closureOperations() {
  entry:
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit &function anonymous10);
    StoreVar(index 0);
    Literal(lit &function anonymous11);
    StoreVar(index 1);
    // Check equality operator
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 0);
    BinOp(op '===');
    Literal(lit true);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 1);
    BinOp(op '===');
    Literal(lit false);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 0);
    BinOp(op '!==');
    Literal(lit false);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 1);
    BinOp(op '!==');
    Literal(lit true);
    Call(count 3);
    Pop(count 1);
    // Other operations
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 0);
    BinOp(op '|');
    Literal(lit 0);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assert');
    Literal(lit undefined);
    LoadGlobal(name 'Number');
    LoadVar(index 4);
    Literal(lit 'isNaN');
    ObjectGet();
    LoadVar(index 4);
    LoadVar(index 0);
    UnOp(op '+');
    Call(count 2);
    StoreVar(index 4);
    Call(count 2);
    Pop(count 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}

function anonymous10() {
  entry:
    Literal(lit undefined);
    Return();
}

function anonymous11() {
  entry:
    Literal(lit undefined);
    Return();
}

function thisCapturing() {
  entry:
    ScopePush(count 1);
    Literal(lit &function printMe1);
    StoreScoped(index 1);
    Literal(lit &function getObj2);
    ClosureNew();
    Literal(lit deleted);
    Literal(lit deleted);
    ObjectNew();
    LoadVar(index 3);
    Literal(lit 'printMe1');
    LoadScoped(index 1);
    ObjectSet();
    LoadVar(index 3);
    Literal(lit 'getObj2');
    LoadVar(index 0);
    ObjectSet();
    LoadVar(index 3);
    Literal(lit 'me');
    Literal(lit 'obj1');
    ObjectSet();
    StoreVar(index 1);
    LoadVar(index 1);
    LoadVar(index 3);
    Literal(lit 'getObj2');
    ObjectGet();
    LoadVar(index 3);
    Call(count 1);
    StoreVar(index 3);
    StoreVar(index 2);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    LoadVar(index 5);
    Literal(lit 'printMe1');
    ObjectGet();
    LoadVar(index 5);
    Call(count 1);
    StoreVar(index 5);
    Literal(lit 'obj1');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    LoadVar(index 5);
    Literal(lit 'printMe1');
    ObjectGet();
    LoadVar(index 5);
    Call(count 1);
    StoreVar(index 5);
    Literal(lit 'obj2');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    LoadVar(index 5);
    Literal(lit 'printMe2');
    ObjectGet();
    LoadVar(index 5);
    Call(count 1);
    StoreVar(index 5);
    Literal(lit 'obj1');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    LoadVar(index 5);
    Literal(lit 'printMe3');
    ObjectGet();
    LoadVar(index 5);
    Call(count 1);
    StoreVar(index 5);
    Literal(lit 'obj2');
    Call(count 3);
    Pop(count 1);
    Pop(count 3);
    Literal(lit undefined);
    Return();
}

function printMe1() {
  entry:
    LoadArg(index 0);
    Literal(lit 'me');
    ObjectGet();
    Return();
}

function getObj2() {
  entry:
    ScopePush(count 1);
    LoadArg(index 0);
    StoreScoped(index 1);
    ObjectNew();
    LoadVar(index 0);
    Literal(lit 'printMe1');
    LoadScoped(index 3);
    ObjectSet();
    LoadVar(index 0);
    Literal(lit 'printMe2');
    Literal(lit &function anonymous12);
    ClosureNew();
    ObjectSet();
    LoadVar(index 0);
    Literal(lit 'printMe3');
    Literal(lit &function anonymous13);
    ObjectSet();
    LoadVar(index 0);
    Literal(lit 'me');
    Literal(lit 'obj2');
    ObjectSet();
    Return();
}

function anonymous12() {
  entry:
    // obj1
    LoadScoped(index 1);
    Literal(lit 'me');
    ObjectGet();
    Return();
}

function anonymous13() {
  entry:
    // obj2
    LoadArg(index 0);
    Literal(lit 'me');
    ObjectGet();
    Return();
}

function anonymous14() {
  entry:
    Literal(lit 1000);
    LoadGlobal(name 'v1');
    LoadVar(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 2);
    StoreGlobal(name 'v1');
    Pop(count 1);
    BinOp(op '*');
    Literal(lit 100);
    LoadGlobal(name 'v2');
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreGlobal(name 'v2');
    Pop(count 1);
    BinOp(op '*');
    BinOp(op '+');
    Literal(lit 10);
    LoadScoped(index 1);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 1);
    Pop(count 1);
    BinOp(op '*');
    BinOp(op '+');
    Literal(lit 1);
    LoadGlobal(name 'v4');
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreGlobal(name 'v4');
    Pop(count 1);
    BinOp(op '*');
    BinOp(op '+');
    Return();
}

function rootScope() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'f');
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 1234);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'f');
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 2345);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'f');
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 3456);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}