unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global GlobalClass;
global globalInst;
global test_globalInstance;
global test_globalClass;
global test_localClass;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function test_globalInstance);
    StoreGlobal(name 'test_globalInstance');
    Literal(lit &function test_globalClass);
    StoreGlobal(name 'test_globalClass');
    Literal(lit &function test_localClass);
    StoreGlobal(name 'test_localClass');
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // assertionCount: 13
    // testOnly: true
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    Literal(lit &function GlobalClass);
    ObjectNew();
    ClassCreate();
    StoreGlobal(name 'GlobalClass');
    LoadGlobal(name 'GlobalClass');
    Literal(lit 'prototype');
    ObjectNew();
    LoadVar(index 3);
    Literal(lit 'myMethod');
    Literal(lit &function GlobalClass_myMethod);
    ObjectSet();
    ObjectSet();
    LoadGlobal(name 'GlobalClass');
    Literal(lit 'myStaticMethod');
    Literal(lit &function GlobalClass_myStaticMethod);
    ObjectSet();
    LoadGlobal(name 'GlobalClass');
    Literal(lit undefined);
    Literal(lit 10);
    New(count 2);
    StoreGlobal(name 'globalInst');
    Literal(lit undefined);
    Return();
}

function GlobalClass() {
  entry:
    LoadArg(index 1);
    Literal(lit 5);
    BinOp(op '+');
    LoadArg(index 0);
    Literal(lit 'x');
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    LoadArg(index 0);
    Return();
}

function GlobalClass_constructor() {
  entry:
    LoadArg(index 1);
    Literal(lit 5);
    BinOp(op '+');
    LoadArg(index 0);
    Literal(lit 'x');
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function GlobalClass_myMethod() {
  entry:
    LoadArg(index 0);
    Literal(lit 'x');
    ObjectGet();
    Literal(lit 1);
    BinOp(op '+');
    LoadArg(index 0);
    Literal(lit 'x');
    LoadVar(index 0);
    ObjectSet();
    Return();
}

function GlobalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);
    Literal(lit 'x');
    ObjectGet();
    LoadVar(index 0);
    Branch(@block2, @block1);
  block1:
    Pop(count 1);
    Literal(lit 1);
    Jump(@block2);
  block2:
    Literal(lit 1);
    BinOp(op '+');
    LoadArg(index 0);
    Literal(lit 'x');
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    LoadArg(index 0);
    Literal(lit 'x');
    ObjectGet();
    Return();
}

function run() {
  entry:
    LoadGlobal(name 'test_globalInstance');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'test_globalClass');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'test_localClass');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_globalInstance() {
  entry:
    // Accessing instance constructed at compile time at the global scope
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'globalInst');
    Literal(lit 'x');
    ObjectGet();
    Literal(lit 15);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'globalInst');
    LoadVar(index 2);
    Literal(lit 'myMethod');
    ObjectGet();
    LoadVar(index 2);
    Call(count 1);
    StoreVar(index 2);
    Literal(lit 16);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'globalInst');
    LoadVar(index 2);
    Literal(lit 'myMethod');
    ObjectGet();
    LoadVar(index 2);
    Call(count 1);
    StoreVar(index 2);
    Literal(lit 17);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_globalClass() {
  entry:
    Literal(lit deleted);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'GlobalClass');
    LoadVar(index 3);
    Literal(lit 'myStaticMethod');
    ObjectGet();
    LoadVar(index 3);
    Call(count 1);
    StoreVar(index 3);
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'GlobalClass');
    LoadVar(index 3);
    Literal(lit 'myStaticMethod');
    ObjectGet();
    LoadVar(index 3);
    Call(count 1);
    StoreVar(index 3);
    Literal(lit 3);
    Call(count 3);
    Pop(count 1);
    // Accessing instance created at runtime of a class created at compile time
    LoadGlobal(name 'GlobalClass');
    Literal(lit undefined);
    Literal(lit 20);
    New(count 2);
    StoreVar(index 0);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'x');
    ObjectGet();
    Literal(lit 25);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 3);
    Literal(lit 'myMethod');
    ObjectGet();
    LoadVar(index 3);
    Call(count 1);
    StoreVar(index 3);
    Literal(lit 26);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 3);
    Literal(lit 'myMethod');
    ObjectGet();
    LoadVar(index 3);
    Call(count 1);
    StoreVar(index 3);
    Literal(lit 27);
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_localClass() {
  entry:
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit &function LocalClass);
    ObjectNew();
    ClassCreate();
    StoreVar(index 0);
    LoadVar(index 0);
    Literal(lit 'prototype');
    ObjectNew();
    LoadVar(index 4);
    Literal(lit 'myMethod');
    Literal(lit &function LocalClass_myMethod);
    ObjectSet();
    ObjectSet();
    LoadVar(index 0);
    Literal(lit 'myStaticMethod');
    Literal(lit &function LocalClass_myStaticMethod);
    ObjectSet();
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 4);
    Literal(lit 'myStaticMethod');
    ObjectGet();
    LoadVar(index 4);
    Call(count 1);
    StoreVar(index 4);
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 4);
    Literal(lit 'myStaticMethod');
    ObjectGet();
    LoadVar(index 4);
    Call(count 1);
    StoreVar(index 4);
    Literal(lit 3);
    Call(count 3);
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit undefined);
    Literal(lit 30);
    New(count 2);
    StoreVar(index 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    Literal(lit 'x');
    ObjectGet();
    Literal(lit 37);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    LoadVar(index 4);
    Literal(lit 'myMethod');
    ObjectGet();
    LoadVar(index 4);
    Call(count 1);
    StoreVar(index 4);
    Literal(lit 39);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    LoadVar(index 4);
    Literal(lit 'myMethod');
    ObjectGet();
    LoadVar(index 4);
    Call(count 1);
    StoreVar(index 4);
    Literal(lit 40);
    Call(count 3);
    Pop(count 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}

function LocalClass() {
  entry:
    LoadArg(index 1);
    Literal(lit 7);
    BinOp(op '+');
    LoadArg(index 0);
    Literal(lit 'x');
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    LoadArg(index 0);
    Return();
}

function LocalClass_constructor() {
  entry:
    LoadArg(index 1);
    Literal(lit 7);
    BinOp(op '+');
    LoadArg(index 0);
    Literal(lit 'x');
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function LocalClass_myMethod() {
  entry:
    LoadArg(index 0);
    Literal(lit 'x');
    ObjectGet();
    Literal(lit 1);
    BinOp(op '+');
    LoadArg(index 0);
    Literal(lit 'x');
    LoadVar(index 0);
    ObjectSet();
    Literal(lit 1);
    BinOp(op '+');
    Return();
}

function LocalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);
    Literal(lit 'x');
    ObjectGet();
    LoadVar(index 0);
    Branch(@block4, @block3);
  block3:
    Pop(count 1);
    Literal(lit 1);
    Jump(@block4);
  block4:
    Literal(lit 1);
    BinOp(op '+');
    LoadArg(index 0);
    Literal(lit 'x');
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    LoadArg(index 0);
    Literal(lit 'x');
    ObjectGet();
    Return();
}