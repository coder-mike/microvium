unit ['./test/end-to-end/tests/1.hello-world.test.mvm.js'];

entry ['#entry'];

external print;
external vmExport;

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: >
    // Exports a function with ID 42 that prints "hello-world".
    // runExportedFunction: 42
    // expectedPrintout: Hello, World!
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 42);
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
    Literal(lit 'Hello, World!');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}