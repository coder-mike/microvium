unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';

global thisModule;
global MyClass;
global inst;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // assertionCount: 0
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
    New(count 1);
    StoreGlobal(name 'inst');
    Literal(lit undefined);
    Return();
}

function MyClass() {
  entry:
    LoadArg(index 0);
    Return();
}

function MyClass_myMethod() {
  entry:
    Literal(lit 5);
    Return();
}

function run() {
  entry:
    Literal(lit deleted);
    Literal(lit deleted);
    LoadGlobal(name 'MyClass');
    StoreVar(index 0);
    LoadGlobal(name 'inst');
    StoreVar(index 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}