unit ['./test/end-to-end/tests/bitwise-operations.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external overflowChecks from free-variable 'overflowChecks';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: >
    // Tests various operations that should classify as vm_TeBitwiseOp operations
    // runExportedFunction: 0
    // assertionCount: 25
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
    Literal(lit 3);
    Literal(lit 0);
    BinOp(op '<<');
    Literal(lit 3);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 3);
    Literal(lit 2);
    BinOp(op '<<');
    Literal(lit 12);
    Call(count 3);
    Pop(count 1);
    // Wrap around
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 3);
    Literal(lit 34);
    BinOp(op '<<');
    Literal(lit 12);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 3);
    Literal(lit 32);
    BinOp(op '<<');
    Literal(lit 3);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 2);
    Literal(lit 31);
    BinOp(op '<<');
    Literal(lit 0);
    Call(count 3);
    Pop(count 1);
    // Left shift negative numbers
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -2);
    Literal(lit 2);
    BinOp(op '<<');
    Literal(lit -8);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 8);
    Literal(lit 1);
    BinOp(op '>>');
    Literal(lit 4);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 8);
    Literal(lit 1);
    BinOp(op '>>>');
    Literal(lit 4);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -8);
    Literal(lit 1);
    BinOp(op '>>');
    Literal(lit -4);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -8);
    Literal(lit 1);
    BinOp(op '>>>');
    Literal(lit 2147483644);
    Call(count 3);
    Pop(count 1);
    // Shifting by zero
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 4);
    Literal(lit 0);
    BinOp(op '>>');
    Literal(lit 4);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 4);
    Literal(lit 0);
    BinOp(op '>>>');
    Literal(lit 4);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -4);
    Literal(lit 0);
    BinOp(op '>>');
    Literal(lit -4);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -4);
    Literal(lit 0);
    BinOp(op '>>>');
    LoadGlobal(name 'overflowChecks');
    Branch(@block1, @block2);
  block1:
    Literal(lit 4294967292);
    Jump(@block3);
  block2:
    Literal(lit -4);
    Jump(@block3);
  block3:
    Call(count 3);
    Pop(count 1);
    // Shifting by negative numbers
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 8);
    Literal(lit -30);
    BinOp(op '>>');
    Literal(lit 8);
    Literal(lit 2);
    BinOp(op '>>');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 8);
    Literal(lit -30);
    BinOp(op '>>>');
    Literal(lit 8);
    Literal(lit 2);
    BinOp(op '>>>');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 8);
    Literal(lit -30);
    BinOp(op '<<');
    Literal(lit 8);
    Literal(lit 2);
    BinOp(op '<<');
    Call(count 3);
    Pop(count 1);
    // Other operators. These are much simpler
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 3);
    Literal(lit 6);
    BinOp(op '|');
    Literal(lit 7);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 3);
    Literal(lit 6);
    BinOp(op '&');
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 3);
    Literal(lit 6);
    BinOp(op '^');
    Literal(lit 5);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit 3);
    UnOp(op '~');
    Literal(lit -4);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -3);
    Literal(lit -6);
    BinOp(op '|');
    Literal(lit -1);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -3);
    Literal(lit -6);
    BinOp(op '&');
    Literal(lit -8);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -3);
    Literal(lit -6);
    BinOp(op '^');
    Literal(lit 7);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    Literal(lit -3);
    UnOp(op '~');
    Literal(lit 2);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}