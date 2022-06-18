unit ['./test/end-to-end/tests/exceptions.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external print from free-variable 'print';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global test_uncaughtException;
global test_minimalTryCatch;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function test_uncaughtException);
    StoreGlobal(name 'test_uncaughtException');
    Literal(lit &function test_minimalTryCatch);
    StoreGlobal(name 'test_minimalTryCatch');
    // ---
    // description: >
    // Testing exceptions
    // runExportedFunction: 0
    // expectException: "My uncaught exception"
    // testOnly: false
    // expectedPrintout: |
    // foo
    // assertionCount: 3
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
    LoadGlobal(name 'test_minimalTryCatch');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'test_uncaughtException');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_uncaughtException() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'foo');
    Call(count 2);
    Pop(count 1);
    // Should print
    Literal(lit 'My uncaught exception');
    Throw();
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'bar');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_minimalTryCatch() {
  entry:
    Literal(lit deleted);
    ArrayNew();
    StoreVar(index 0);
    StartTry(@block1);
    LoadVar(index 0);
    LoadVar(index 3);
    Literal(lit 'push');
    ObjectGet();
    LoadVar(index 3);
    Literal(lit 42);
    Call(count 2);
    StoreVar(index 3);
    Pop(count 1);
    Literal(lit 'boo!');
    Throw();
    LoadVar(index 0);
    LoadVar(index 3);
    Literal(lit 'push');
    ObjectGet();
    LoadVar(index 3);
    Literal(lit 43);
    Call(count 2);
    StoreVar(index 3);
    Pop(count 1);
    EndTry();
    Jump(@block2);
  block1:
    Pop(count 1);
    LoadVar(index 0);
    LoadVar(index 1);
    Literal(lit 'push');
    ObjectGet();
    LoadVar(index 1);
    Literal(lit 44);
    Call(count 2);
    StoreVar(index 1);
    Pop(count 1);
    Jump(@block2);
  block2:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'length');
    ObjectGet();
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 0);
    ObjectGet();
    Literal(lit 42);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 1);
    ObjectGet();
    Literal(lit 44);
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}