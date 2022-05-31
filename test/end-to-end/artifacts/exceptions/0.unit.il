unit ['./test/end-to-end/tests/exceptions.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external print from free-variable 'print';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: >
    // Testing exceptions
    // runExportedFunction: 0
    // expectException: "Dummy failure"
    // testOnly: false
    // expectedPrintout: |
    // foo
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
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'foo');
    Call(count 2);
    Pop(count 1);
    // Should print
    Literal(lit 'Dummy failure');
    Throw();
}