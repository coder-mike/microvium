unit ['./test/end-to-end/tests/object-keys.test.mvm.js'];

entry ['#entry'];

external Reflect from free-variable 'Reflect';
external assertEqual from free-variable 'assertEqual';
external vmExport from free-variable 'vmExport';

global thisModule;
global objBeforeSnapshot;
global keysBeforeSnapshot;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: >
    // Tests Reflect.ownKeys
    // runExportedFunction: 0
    // assertionCount: 9
    // ---
    ObjectNew();
    LoadVar(index 1);
    Literal(lit 'x');
    Literal(lit 5);
    ObjectSet();
    LoadVar(index 1);
    Literal(lit 'y');
    Literal(lit 10);
    ObjectSet();
    StoreGlobal(name 'objBeforeSnapshot');
    LoadGlobal(name 'Reflect');
    LoadVar(index 1);
    Literal(lit 'ownKeys');
    ObjectGet();
    LoadVar(index 1);
    LoadGlobal(name 'objBeforeSnapshot');
    Call(count 2);
    StoreVar(index 1);
    StoreGlobal(name 'keysBeforeSnapshot');
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
    Literal(lit deleted);
    Literal(lit deleted);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'keysBeforeSnapshot');
    Literal(lit 'length');
    ObjectGet();
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'keysBeforeSnapshot');
    Literal(lit 0);
    ObjectGet();
    Literal(lit 'x');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'keysBeforeSnapshot');
    Literal(lit 1);
    ObjectGet();
    Literal(lit 'y');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'Reflect');
    LoadVar(index 3);
    Literal(lit 'ownKeys');
    ObjectGet();
    LoadVar(index 3);
    LoadGlobal(name 'objBeforeSnapshot');
    Call(count 2);
    StoreVar(index 3);
    StoreVar(index 0);
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
    Literal(lit 'x');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 1);
    ObjectGet();
    Literal(lit 'y');
    Call(count 3);
    Pop(count 1);
    ObjectNew();
    LoadVar(index 3);
    Literal(lit 'a');
    Literal(lit 5);
    ObjectSet();
    LoadVar(index 3);
    Literal(lit 'b');
    Literal(lit 10);
    ObjectSet();
    StoreVar(index 1);
    LoadGlobal(name 'Reflect');
    LoadVar(index 3);
    Literal(lit 'ownKeys');
    ObjectGet();
    LoadVar(index 3);
    LoadVar(index 1);
    Call(count 2);
    StoreVar(index 3);
    StoreVar(index 2);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    Literal(lit 'length');
    ObjectGet();
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    Literal(lit 0);
    ObjectGet();
    Literal(lit 'a');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 2);
    Literal(lit 1);
    ObjectGet();
    Literal(lit 'b');
    Call(count 3);
    Pop(count 1);
    Pop(count 3);
    Literal(lit undefined);
    Return();
}