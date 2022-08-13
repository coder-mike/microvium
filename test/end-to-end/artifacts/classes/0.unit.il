unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global MyClass;
global inst1;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
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
    Literal(lit &function MyClass);
    ObjectNew();
    ClassCreate();
    StoreGlobal(name 'MyClass');
    LoadGlobal(name 'MyClass');
    Literal(lit 'prototype');
    ObjectNew();
    LoadVar(index 3);
    Literal(lit 'myMethod');
    Literal(lit &function MyClass_myMethod);
    ObjectSet();
    ObjectSet();
    LoadGlobal(name 'MyClass');
    Literal(lit undefined);
    Literal(lit 10);
    New(count 2);
    StoreGlobal(name 'inst1');
    Literal(lit undefined);
    Return();
}

function MyClass() {
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

function MyClass_constructor() {
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

function MyClass_myMethod() {
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

function run() {
  entry:
    Literal(lit deleted);
    // Accessing instance constructed at compile time
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'inst1');
    Literal(lit 'x');
    ObjectGet();
    Literal(lit 15);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'inst1');
    LoadVar(index 3);
    Literal(lit 'myMethod');
    ObjectGet();
    LoadVar(index 3);
    Call(count 1);
    StoreVar(index 3);
    Literal(lit 16);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'inst1');
    LoadVar(index 3);
    Literal(lit 'myMethod');
    ObjectGet();
    LoadVar(index 3);
    Call(count 1);
    StoreVar(index 3);
    Literal(lit 17);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'MyClass');
    Literal(lit undefined);
    Literal(lit 20);
    New(count 2);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}