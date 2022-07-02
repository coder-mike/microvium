unit ['./test/end-to-end/tests/uint8Array.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external Microvium from free-variable 'Microvium';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global buf1;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: Tests of Uint8Array
    // runExportedFunction: 0
    // assertionCount: 8
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'Microvium');
    LoadVar(index 1);
    Literal(lit 'newUint8Array');
    ObjectGet();
    LoadVar(index 1);
    Literal(lit 5);
    Call(count 2);
    StoreVar(index 1);
    StoreGlobal(name 'buf1');
    Literal(lit deleted);
    Literal(lit 0);
    StoreVar(index 1);
    Jump(@block1);
  block1:
    LoadVar(index 1);
    LoadGlobal(name 'buf1');
    Literal(lit 'length');
    ObjectGet();
    BinOp(op '<');
    Branch(@block2, @block3);
  block2:
    LoadVar(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadGlobal(name 'buf1');
    LoadVar(index 1);
    LoadVar(index 2);
    ObjectSet();
    Pop(count 1);
    LoadVar(index 1);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 1);
    Pop(count 1);
    Pop(count 1);
    Jump(@block1);
  block3:
    Pop(count 1);
    // Writing to Uint8Array at compile-time
    // Reading from Uint8Array at compile-time
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'buf1');
    Literal(lit 'length');
    ObjectGet();
    Literal(lit 5);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'buf1');
    Literal(lit 0);
    ObjectGet();
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'buf1');
    Literal(lit 4);
    ObjectGet();
    Literal(lit 5);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function run() {
  entry:
    Literal(lit deleted);
    // Reading from compile-time Uint8Array at runtime
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'buf1');
    Literal(lit 'length');
    ObjectGet();
    Literal(lit 5);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'buf1');
    Literal(lit 0);
    ObjectGet();
    Literal(lit 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'buf1');
    Literal(lit 4);
    ObjectGet();
    Literal(lit 5);
    Call(count 3);
    Pop(count 1);
    // Mutating compile-time Uint8Array at runtime
    Literal(lit 42);
    LoadGlobal(name 'buf1');
    Literal(lit 2);
    LoadVar(index 1);
    ObjectSet();
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'buf1');
    Literal(lit 2);
    ObjectGet();
    Literal(lit 42);
    Call(count 3);
    Pop(count 1);
    // Creating Uint8Array at runtime
    LoadGlobal(name 'Microvium');
    LoadVar(index 1);
    Literal(lit 'newUint8Array');
    ObjectGet();
    LoadVar(index 1);
    Literal(lit 3);
    Call(count 2);
    StoreVar(index 1);
    StoreVar(index 0);
    Literal(lit deleted);
    Literal(lit 0);
    StoreVar(index 1);
    Jump(@block4);
  block4:
    LoadVar(index 1);
    LoadVar(index 0);
    Literal(lit 'length');
    ObjectGet();
    BinOp(op '<');
    Branch(@block5, @block6);
  block5:
    LoadVar(index 1);
    Literal(lit 100);
    BinOp(op '+');
    LoadVar(index 0);
    LoadVar(index 1);
    LoadVar(index 2);
    ObjectSet();
    Pop(count 1);
    LoadVar(index 1);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 1);
    Pop(count 1);
    Pop(count 1);
    Jump(@block4);
  block6:
    Pop(count 1);
    // Writing
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'length');
    ObjectGet();
    Literal(lit 3);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 0);
    ObjectGet();
    Literal(lit 100);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 1);
    ObjectGet();
    Literal(lit 101);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 2);
    ObjectGet();
    Literal(lit 102);
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}