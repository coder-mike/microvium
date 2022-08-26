unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit deleted);
    Literal(lit &function MyClass);
    ObjectNew();
    ClassCreate();
    StoreVar(index 0);
    LoadVar(index 0);
    Literal(lit 'prototype');
    ObjectNew();
    ObjectSet();
    Literal(lit undefined);
    Return();
}

// ---
description: >
  Testing support for classes
#runExportedFunction: 0 WIP
#assertionCount: 41 WIP
testOnly: true
---
function MyClass() {
  entry:
    LoadArg(index 0);
    Literal(lit 'x');
    Literal(lit 10);
    ObjectSet();
    LoadArg(index 1);
    LoadArg(index 0);
    Literal(lit 'y');
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    LoadArg(index 0);
    Return();
}