unit ['./test/end-to-end/tests/conversions.test.mvm.js'];

entry ['#entry'];

external vmExport;
external assertEqual;
external assert;
external Number;
external undefined;

global thisModule;
global testConvertToNumber;
global testConvertToBoolean;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function testConvertToNumber);
    StoreGlobal(name 'testConvertToNumber');
    Literal(lit &function testConvertToBoolean);
    StoreGlobal(name 'testConvertToBoolean');
    // ---
    // description: >
    // Tests primitive type conversions
    // runExportedFunction: 0
    // # assertionCount: 25
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
    LoadGlobal(name 'testConvertToNumber');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'testConvertToBoolean');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function testConvertToNumber() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 1);
    Literal(lit 1);
    BinOp(op '+');
    UnOp(op '+');
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 1.1);
    Literal(lit 2);
    BinOp(op '+');
    UnOp(op '+');
    Literal(lit 3.1);
    Call(count 3);
    Pop(count 1);
    // <-- this is the failing one (WIP)
    LoadGlobal(name 'assert');
    Literal(lit undefined);
    LoadGlobal(name 'Number');
    LoadVar(index 2);
    Literal(lit 'isNaN');
    ObjectGet();
    LoadVar(index 2);
    Literal(lit undefined);
    UnOp(op '+');
    Call(count 2);
    StoreVar(index 2);
    Call(count 2);
    Pop(count 1);
    LoadGlobal(name 'assert');
    Literal(lit undefined);
    LoadGlobal(name 'Number');
    LoadVar(index 2);
    Literal(lit 'isNaN');
    ObjectGet();
    LoadVar(index 2);
    ObjectNew();
    UnOp(op '+');
    Call(count 2);
    StoreVar(index 2);
    Call(count 2);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit null);
    UnOp(op '+');
    Literal(lit 0);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function testConvertToBoolean() {
  entry:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 1);
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit true);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 0);
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit false);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -1);
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit true);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit undefined);
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit false);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit null);
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit false);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    ObjectNew();
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit true);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    ArrayNew();
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit true);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit '');
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit false);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'x');
    UnOp(op '!');
    UnOp(op '!');
    Literal(lit true);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}