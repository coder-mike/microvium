unit ['./test/end-to-end/tests/gc.test.mvm.js'];

entry ['#entry'];

external getHeapUsed from free-variable 'getHeapUsed';
external undefined from free-variable 'undefined';
external assertEqual from free-variable 'assertEqual';
external runGC from free-variable 'runGC';
external vmExport from free-variable 'vmExport';

global thisModule;
global garbage;
global globalVariable;
global heap;
global function1;
global nestedFunction;
global checkAllocated;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function function1);
    StoreGlobal(name 'function1');
    Literal(lit &function nestedFunction);
    StoreGlobal(name 'nestedFunction');
    Literal(lit &function checkAllocated);
    StoreGlobal(name 'checkAllocated');
    Literal(lit &function checkGC);
    // ---
    // runExportedFunction: 0
    // nativeOnly: true
    // description: Some garbage collection tests
    // ---
    Literal(lit undefined);
    StoreGlobal(name 'garbage');
    Literal(lit undefined);
    StoreGlobal(name 'globalVariable');
    Literal(lit undefined);
    StoreGlobal(name 'heap');
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
    Literal(lit 0);
    LoadVar(index 0);
    StoreGlobal(name 'garbage');
    Pop(count 1);
    LoadGlobal(name 'getHeapUsed');
    Literal(lit undefined);
    Call(count 1);
    LoadVar(index 0);
    StoreGlobal(name 'heap');
    Pop(count 1);
    LoadGlobal(name 'function1');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function function1() {
  entry:
    Literal(lit deleted);
    Literal(lit deleted);
    // New array with global reference
    ArrayNew();
    LoadVar(index 2);
    Literal(lit 0);
    Literal(lit 0);
    ObjectSet();
    LoadVar(index 2);
    StoreGlobal(name 'globalVariable');
    Pop(count 1);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 10);
    Literal(lit 0);
    Call(count 3);
    Pop(count 1);
    // TODO: When we have closures, we should check with a closure reference as well
    // New array with local reference
    ArrayNew();
    LoadVar(index 2);
    Literal(lit 0);
    Literal(lit 1);
    ObjectSet();
    StoreVar(index 0);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 10);
    Literal(lit 0);
    Call(count 3);
    Pop(count 1);
    // Resize array
    Literal(lit 42);
    LoadVar(index 0);
    Literal(lit 1);
    LoadVar(index 2);
    ObjectSet();
    Pop(count 1);
    // See setProperty and growArray
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 10);
    Literal(lit 4);
    Call(count 3);
    Pop(count 1);
    // New array
    ArrayNew();
    LoadVar(index 2);
    Literal(lit 0);
    Literal(lit 2);
    ObjectSet();
    StoreVar(index 1);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 10);
    Literal(lit 0);
    Call(count 3);
    Pop(count 1);
    // Make eligible for GC
    Literal(lit undefined);
    LoadVar(index 2);
    StoreVar(index 1);
    Pop(count 1);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 0);
    Literal(lit 10);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'nestedFunction');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}

function nestedFunction() {
  entry:
    Literal(lit deleted);
    Literal(lit deleted);
    // New object. Note that new objects are manufactured empty to start with and
    // then properties are added.
    ObjectNew();
    LoadVar(index 2);
    Literal(lit 'x');
    Literal(lit 3);
    ObjectSet();
    StoreVar(index 0);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 16);
    Literal(lit 6);
    Call(count 3);
    Pop(count 1);
    // Extend object
    Literal(lit 4);
    LoadVar(index 0);
    Literal(lit 'y');
    LoadVar(index 2);
    ObjectSet();
    Pop(count 1);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 10);
    Literal(lit 6);
    Call(count 3);
    Pop(count 1);
    // Extend object
    Literal(lit 5);
    LoadVar(index 0);
    Literal(lit 'z');
    LoadVar(index 2);
    ObjectSet();
    Pop(count 1);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 10);
    Literal(lit 6);
    Call(count 3);
    Pop(count 1);
    // New object
    ObjectNew();
    LoadVar(index 2);
    Literal(lit 'x');
    Literal(lit 6);
    ObjectSet();
    StoreVar(index 1);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 16);
    Literal(lit 6);
    Call(count 3);
    Pop(count 1);
    // Make eligible for GC
    Literal(lit 0);
    LoadVar(index 2);
    StoreVar(index 1);
    Pop(count 1);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 0);
    Literal(lit 10);
    Call(count 3);
    Pop(count 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}

function checkAllocated() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'getHeapUsed');
    Literal(lit undefined);
    Call(count 1);
    LoadGlobal(name 'heap');
    BinOp(op '-');
    LoadArg(index 1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'heap');
    LoadArg(index 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreGlobal(name 'heap');
    Pop(count 1);
    LoadGlobal(name 'garbage');
    LoadArg(index 2);
    BinOp(op '+');
    LoadVar(index 0);
    StoreGlobal(name 'garbage');
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function checkGC() {
  entry:
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    Literal(lit 0);
    Literal(lit 0);
    Call(count 3);
    Pop(count 1);
    // Just check consistency between `heap` and `getHeapUsed`
    LoadGlobal(name 'runGC');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'checkAllocated');
    Literal(lit undefined);
    LoadGlobal(name 'garbage');
    UnOp(op '-');
    LoadGlobal(name 'garbage');
    UnOp(op '-');
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}