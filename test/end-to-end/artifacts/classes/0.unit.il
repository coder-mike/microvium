unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global test_localClass;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function test_localClass);
    StoreGlobal(name 'test_localClass');
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // assertionCount: 3
    // testOnly: true
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

// class GlobalClass {
// constructor(y) { this.x = y + 5 }
// myMethod() { return ++this.x }
// }
// const globalInst = new GlobalClass(10);
function run() {
  entry:
    // test_globalInstance();
    // test_globalClass();
    LoadGlobal(name 'test_localClass');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

// function test_globalInstance() {
// // Accessing instance constructed at compile time at the global scope
// assertEqual(globalInst.x, 15);
// assertEqual(globalInst.myMethod(), 16);
// assertEqual(globalInst.myMethod(), 17);
// }
// function test_globalClass() {
// // Accessing instance created at runtime of a class created at compile time
// const inst = new GlobalClass(20);
// assertEqual(inst.x, 25);
// assertEqual(inst.myMethod(), 26);
// assertEqual(inst.myMethod(), 27);
// }
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