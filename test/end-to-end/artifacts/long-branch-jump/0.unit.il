unit ['./test/end-to-end/tests/long-branch-jump.test.mvm.js'];

entry ['#entry'];

external print from free-variable 'print';
external vmExport from free-variable 'vmExport';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    // ---
    // description: >
    // Tests various branching instructions
    // runExportedFunction: 0
    // expectedPrintout: |
    // #1: This is the alternate
    // #2: This is the consequent
    // ---
    Nop(count 200);
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
    Literal(lit false);
    Branch(@block1, @block2);
  block1:
    Nop(count 200);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '#1: This is the consequent');
    Call(count 2);
    Pop(count 1);
    Jump(@block3);
  block2:
    Nop(count 200);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '#1: This is the alternate');
    Call(count 2);
    Pop(count 1);
    Jump(@block3);
  block3:
    Literal(lit true);
    Branch(@block4, @block5);
  block4:
    Nop(count 200);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '#2: This is the consequent');
    Call(count 2);
    Pop(count 1);
    Jump(@block6);
  block5:
    Nop(count 200);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '#2: This is the alternate');
    Call(count 2);
    Pop(count 1);
    Jump(@block6);
  block6:
    Literal(lit undefined);
    Return();
}