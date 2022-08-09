unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit deleted);
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
    StoreVar(index 1);
    Literal(lit undefined);
    Return();
}

function MyClass() {
  entry:
    LoadArg(index 0);
    Return();
}

function run() {
  entry:
    Literal(lit undefined);
    Return();
}