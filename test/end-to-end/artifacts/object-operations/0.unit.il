unit ['./test/end-to-end/tests/object-operations.test.mvm.js'];

entry ['#entry'];

external assertEqual;
external undefined;
external vmExport;

global thisModule;
global objBeforeSnapshot;
global foo2;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function foo);
    Literal(lit &function foo2);
    StoreGlobal(name 'foo2');
    // ---
    // description: >
    // Tests various object operations
    // runExportedFunction: 0
    // assertionCount: 13
    // ---
    // TODO: Computed properties
    ObjectNew();
    LoadVar(index 2);
    Literal(lit 'x');
    Literal(lit 5);
    ObjectSet();
    LoadVar(index 2);
    Literal(lit 'y');
    Literal(lit 10);
    ObjectSet();
    LoadVar(index 2);
    Literal(lit 'f');
    LoadVar(index 1);
    ObjectSet();
    StoreGlobal(name 'objBeforeSnapshot');
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
    Literal(lit deleted);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'objBeforeSnapshot');
    Literal(lit 'x');
    ObjectGet();
    Literal(lit 5);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'objBeforeSnapshot');
    Literal(lit 'y');
    ObjectGet();
    Literal(lit 10);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'objBeforeSnapshot');
    Literal(lit 'z');
    ObjectGet();
    Literal(lit undefined);
    Call(count 3);
    Pop(count 1);
    // Method call
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'objBeforeSnapshot');
    LoadVar(index 3);
    Literal(lit 'f');
    ObjectGet();
    LoadVar(index 3);
    Literal(lit 17);
    Call(count 2);
    StoreVar(index 3);
    Literal(lit 18);
    Call(count 3);
    Pop(count 1);
    // Set existing property on snapshotted object
    Literal(lit 12);
    LoadGlobal(name 'objBeforeSnapshot');
    Literal(lit 'x');
    LoadVar(index 1);
    ObjectSet();
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'objBeforeSnapshot');
    Literal(lit 'x');
    ObjectGet();
    Literal(lit 12);
    Call(count 3);
    Pop(count 1);
    // Create new property on snapshotted object
    Literal(lit 13);
    LoadGlobal(name 'objBeforeSnapshot');
    Literal(lit 'z');
    LoadVar(index 1);
    ObjectSet();
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'objBeforeSnapshot');
    Literal(lit 'z');
    ObjectGet();
    Literal(lit 13);
    Call(count 3);
    Pop(count 1);
    // New empty object
    ObjectNew();
    LoadVar(index 1);
    Literal(lit 'a');
    Literal(lit 14);
    ObjectSet();
    LoadVar(index 1);
    Literal(lit 'b');
    Literal(lit 15);
    ObjectSet();
    LoadVar(index 1);
    Literal(lit 'f');
    LoadGlobal(name 'foo2');
    ObjectSet();
    StoreVar(index 0);
    Literal(lit 16);
    LoadVar(index 0);
    Literal(lit 'c');
    LoadVar(index 1);
    ObjectSet();
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'a');
    ObjectGet();
    Literal(lit 14);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'b');
    ObjectGet();
    Literal(lit 15);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'c');
    ObjectGet();
    Literal(lit 16);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'd');
    ObjectGet();
    Literal(lit undefined);
    Call(count 3);
    Pop(count 1);
    // Method call
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    LoadVar(index 3);
    Literal(lit 'f');
    ObjectGet();
    LoadVar(index 3);
    Literal(lit 19);
    Call(count 2);
    StoreVar(index 3);
    Literal(lit 20);
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function foo() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadArg(index 1);
    Literal(lit 17);
    Call(count 3);
    Pop(count 1);
    Literal(lit 18);
    Return();
}

function foo2() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadArg(index 1);
    Literal(lit 19);
    Call(count 3);
    Pop(count 1);
    Literal(lit 20);
    Return();
}