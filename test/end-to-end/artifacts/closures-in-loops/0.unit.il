unit ['./test/end-to-end/tests/closures-in-loops.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external print from free-variable 'print';

global thisModule;
global test1;
global mutationOfLoopVar;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function test1);
    StoreGlobal(name 'test1');
    Literal(lit &function mutationOfLoopVar);
    StoreGlobal(name 'mutationOfLoopVar');
    // ---
    // runExportedFunction: 0
    // expectedPrintout: |
    // # Test 1
    // 0, 0
    // 1, 1
    // 2, 2
    // 3, 3
    // 4, 4
    // # Test mutationOfLoopVar
    // 1, 0
    // 3, 2
    // 5, 4
    // 7, 6
    // 9, 8
    // #  # Test popScope
    // #  outer, z
    // #  0, 0, z
    // #  1, 1, z
    // #  2, 2, z
    // #  3, 3, z
    // #  4, 4, z
    // #  # Test break
    // #  outer, z
    // #  0, 0, z
    // #  1, 1, z
    // #  2, 2, z
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
    LoadGlobal(name 'test1');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'mutationOfLoopVar');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test1() {
  entry:
    Literal(lit deleted);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '# Test 1');
    Call(count 2);
    Pop(count 1);
    ArrayNew();
    StoreVar(index 0);
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 0);
    Jump(@block1);
  block1:
    LoadScoped(index 0);
    Literal(lit 5);
    BinOp(op '<');
    Branch(@block2, @block3);
  block2:
    ScopePush(count 1);
    LoadScoped(index 1);
    StoreScoped(index 0);
    LoadVar(index 0);
    LoadVar(index 1);
    Literal(lit 'push');
    ObjectGet();
    LoadVar(index 1);
    Literal(lit &function anonymous);
    ClosureNew();
    Call(count 2);
    StoreVar(index 1);
    Pop(count 1);
    ScopePop();
    ScopeClone();
    LoadScoped(index 0);
    LoadVar(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 2);
    StoreScoped(index 0);
    Pop(count 1);
    Pop(count 1);
    Jump(@block1);
  block3:
    ScopePop();
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
    LoadVar(index 0);
    LoadVar(index 1);
    ObjectGet();
    Literal(lit undefined);
    Call(count 1);
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
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function anonymous() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '');
    LoadScoped(index 1);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 0);
    BinOp(op '+');
    Call(count 2);
    Return();
}

function mutationOfLoopVar() {
  entry:
    Literal(lit deleted);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '# Test mutationOfLoopVar');
    Call(count 2);
    Pop(count 1);
    ArrayNew();
    StoreVar(index 0);
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 0);
    Jump(@block7);
  block7:
    LoadScoped(index 0);
    Literal(lit 10);
    BinOp(op '<');
    Branch(@block8, @block9);
  block8:
    ScopePush(count 1);
    LoadScoped(index 1);
    StoreScoped(index 0);
    LoadVar(index 0);
    LoadVar(index 1);
    Literal(lit 'push');
    ObjectGet();
    LoadVar(index 1);
    Literal(lit &function anonymous1);
    ClosureNew();
    Call(count 2);
    StoreVar(index 1);
    Pop(count 1);
    LoadScoped(index 1);
    LoadVar(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 2);
    StoreScoped(index 1);
    Pop(count 1);
    Pop(count 1);
    ScopePop();
    ScopeClone();
    LoadScoped(index 0);
    LoadVar(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 2);
    StoreScoped(index 0);
    Pop(count 1);
    Pop(count 1);
    Jump(@block7);
  block9:
    ScopePop();
    Literal(lit deleted);
    Literal(lit 0);
    StoreVar(index 1);
    Jump(@block10);
  block10:
    LoadVar(index 1);
    LoadVar(index 0);
    Literal(lit 'length');
    ObjectGet();
    BinOp(op '<');
    Branch(@block11, @block12);
  block11:
    LoadVar(index 0);
    LoadVar(index 1);
    ObjectGet();
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadVar(index 1);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 1);
    Pop(count 1);
    Pop(count 1);
    Jump(@block10);
  block12:
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function anonymous1() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '');
    LoadScoped(index 1);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 0);
    BinOp(op '+');
    Call(count 2);
    Return();
}