unit ['./test/end-to-end/tests/strings.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: >
    // Tests various string operations and conversion to strings.
    // runExportedFunction: 0
    // assertionCount: 22
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
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'abc');
    Literal(lit 'abc');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit 'cd');
    BinOp(op '+');
    Literal(lit 'ab_cd');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit 'cd');
    BinOp(op '+');
    Literal(lit 'ef');
    BinOp(op '+');
    Literal(lit 'ab_cdef');
    Call(count 3);
    Pop(count 1);
    // Int14
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit 5);
    BinOp(op '+');
    Literal(lit 'ab_5');
    Call(count 3);
    Pop(count 1);
    // Negative
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit -5);
    BinOp(op '+');
    Literal(lit 'ab_-5');
    Call(count 3);
    Pop(count 1);
    // Int32
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit 500000);
    BinOp(op '+');
    Literal(lit 'ab_500000');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit -500000);
    BinOp(op '+');
    Literal(lit 'ab_-500000');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit -2147483648);
    BinOp(op '+');
    Literal(lit 'ab_-2147483648');
    Call(count 3);
    Pop(count 1);
    // Some general constants
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit null);
    BinOp(op '+');
    Literal(lit 'ab_null');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit true);
    BinOp(op '+');
    Literal(lit 'ab_true');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit false);
    BinOp(op '+');
    Literal(lit 'ab_false');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit undefined);
    BinOp(op '+');
    Literal(lit 'ab_undefined');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit -0);
    BinOp(op '+');
    Literal(lit 'ab_0');
    Call(count 3);
    Pop(count 1);
    // Special strings
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit 'proto');
    BinOp(op '+');
    Literal(lit 'ab_proto');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'proto');
    Literal(lit '_bc');
    BinOp(op '+');
    Literal(lit 'proto_bc');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab_');
    Literal(lit 'length');
    BinOp(op '+');
    Literal(lit 'ab_length');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'length');
    Literal(lit '_bc');
    BinOp(op '+');
    Literal(lit 'length_bc');
    Call(count 3);
    Pop(count 1);
    // Interpolation
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit '');
    Literal(lit '');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'abc');
    Literal(lit 'abc');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit '');
    Literal(lit '_');
    BinOp(op '+');
    Literal(lit 'abc');
    BinOp(op '+');
    Literal(lit '_abc');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'abc');
    Literal(lit '_');
    BinOp(op '+');
    Literal(lit 'abc_');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 'ab');
    Literal(lit 5);
    BinOp(op '+');
    Literal(lit 'c');
    BinOp(op '+');
    Literal(lit 'ab5c');
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}