unit ['./test/end-to-end/tests/0.empty-export.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // runExportedFunction: 0
    // description: Tests that an empty function can be exported and run
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
    Literal(lit undefined);
    Return();
}