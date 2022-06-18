unit ['./test/end-to-end/tests/exceptions.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external print from free-variable 'print';

global thisModule;
global uncaughtException;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function uncaughtException);
    StoreGlobal(name 'uncaughtException');
    // ---
    // description: >
    // Testing exceptions
    // runExportedFunction: 0
    // expectException: "My uncaught exception"
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
    LoadGlobal(name 'uncaughtException');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function uncaughtException() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'foo');
    Call(count 2);
    Pop(count 1);
    // Should print
    Literal(lit 'My uncaught exception');
    Throw();
}