unit ['./test/end-to-end/tests/typeof.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';

global thisModule;
global run;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    StoreGlobal(name 'run');
    // ---
    // description: Testing `typeof` operator
    // runExportedFunction: 0
    // assertionCount: 12
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadGlobal(name 'run');
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit undefined);
    UnOp(op 'typeof');
    Literal(lit 'undefined');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 0);
    UnOp(op 'typeof');
    Literal(lit 'number');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit false);
    UnOp(op 'typeof');
    Literal(lit 'boolean');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit true);
    UnOp(op 'typeof');
    Literal(lit 'boolean');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'hello');
    UnOp(op 'typeof');
    Literal(lit 'string');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'hello');
    Literal(lit 'world');
    BinOp(op '+');
    UnOp(op 'typeof');
    Literal(lit 'string');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'x');
    UnOp(op 'typeof');
    UnOp(op 'typeof');
    Literal(lit 'string');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'run');
    UnOp(op 'typeof');
    Literal(lit 'function');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit null);
    UnOp(op 'typeof');
    Literal(lit 'object');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    ObjectNew();
    UnOp(op 'typeof');
    Literal(lit 'object');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    ArrayNew();
    UnOp(op 'typeof');
    Literal(lit 'object');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit &function anonymous);
    UnOp(op 'typeof');
    Literal(lit 'function');
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function anonymous() {
  entry:
    Literal(lit undefined);
    Return();
}