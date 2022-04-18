unit ['./test/end-to-end/tests/closures-in-loops.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external print from free-variable 'print';
external console from free-variable 'console';

global thisModule;
global test1;
global mutationOfLoopVar;
global popScope;
global testBreak;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function test1);
    StoreGlobal(name 'test1');
    Literal(lit &function mutationOfLoopVar);
    StoreGlobal(name 'mutationOfLoopVar');
    Literal(lit &function popScope);
    StoreGlobal(name 'popScope');
    Literal(lit &function testBreak);
    StoreGlobal(name 'testBreak');
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
    // # Test popScope
    // outer, z
    // 0, 0, z
    // 1, 1, z
    // 2, 2, z
    // 3, 3, z
    // 4, 4, z
    // # Test testBreak
    // outer, z
    // 0, 0, z
    // 1, 1, z
    // 2, 2, z
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    // Similar to popScope but tests that the scope is popped when the loop breaks early
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
    LoadGlobal(name 'popScope');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'testBreak');
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
    StoreScoped(index 1);
    Jump(@block1);
  block1:
    LoadScoped(index 1);
    Literal(lit 5);
    BinOp(op '<');
    Branch(@block2, @block3);
  block2:
    ScopePush(count 1);
    LoadScoped(index 3);
    StoreScoped(index 1);
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
    LoadScoped(index 1);
    LoadVar(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 2);
    StoreScoped(index 1);
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
    LoadScoped(index 3);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 1);
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
    StoreScoped(index 1);
    Jump(@block7);
  block7:
    LoadScoped(index 1);
    Literal(lit 10);
    BinOp(op '<');
    Branch(@block8, @block9);
  block8:
    ScopePush(count 1);
    LoadScoped(index 3);
    StoreScoped(index 1);
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
    LoadScoped(index 3);
    LoadVar(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 2);
    StoreScoped(index 3);
    Pop(count 1);
    Pop(count 1);
    ScopePop();
    ScopeClone();
    LoadScoped(index 1);
    LoadVar(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 2);
    StoreScoped(index 1);
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
    LoadScoped(index 3);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 1);
    BinOp(op '+');
    Call(count 2);
    Return();
}

function popScope() {
  entry:
    ScopePush(count 2);
    Literal(lit deleted);
    Literal(lit deleted);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '# Test popScope');
    Call(count 2);
    Pop(count 1);
    Literal(lit 'outer');
    StoreScoped(index 1);
    Literal(lit 'z');
    StoreScoped(index 2);
    ArrayNew();
    StoreVar(index 0);
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 1);
    Jump(@block13);
  block13:
    LoadScoped(index 1);
    Literal(lit 5);
    BinOp(op '<');
    Branch(@block14, @block15);
  block14:
    ScopePush(count 1);
    LoadScoped(index 3);
    StoreScoped(index 1);
    LoadVar(index 0);
    LoadVar(index 2);
    Literal(lit 'push');
    ObjectGet();
    LoadVar(index 2);
    Literal(lit &function anonymous2);
    ClosureNew();
    Call(count 2);
    StoreVar(index 2);
    Pop(count 1);
    ScopePop();
    ScopeClone();
    LoadScoped(index 1);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 1);
    Pop(count 1);
    Pop(count 1);
    Jump(@block13);
  block15:
    ScopePop();
    // foo will be doing LoadScoped[0], so this checks that the scope after the
    // loop is correctly back to the original function scope.
    Literal(lit &function anonymous3);
    ClosureNew();
    StoreVar(index 1);
    LoadVar(index 1);
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit deleted);
    Literal(lit 0);
    StoreVar(index 2);
    Jump(@block16);
  block16:
    LoadVar(index 2);
    LoadVar(index 0);
    Literal(lit 'length');
    ObjectGet();
    BinOp(op '<');
    Branch(@block17, @block18);
  block17:
    LoadVar(index 0);
    LoadVar(index 2);
    ObjectGet();
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadVar(index 2);
    LoadVar(index 3);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 4);
    StoreVar(index 2);
    Pop(count 1);
    Pop(count 1);
    Jump(@block16);
  block18:
    Pop(count 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}

function anonymous2() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '');
    LoadScoped(index 3);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 1);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 6);
    BinOp(op '+');
    Call(count 2);
    Return();
}

function anonymous3() {
  entry:
    LoadGlobal(name 'console');
    LoadVar(index 0);
    Literal(lit 'log');
    ObjectGet();
    LoadVar(index 0);
    Literal(lit '');
    LoadScoped(index 1);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 2);
    BinOp(op '+');
    Call(count 2);
    StoreVar(index 0);
    Return();
}

function testBreak() {
  entry:
    ScopePush(count 2);
    Literal(lit deleted);
    Literal(lit deleted);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '# Test testBreak');
    Call(count 2);
    Pop(count 1);
    Literal(lit 'outer');
    StoreScoped(index 1);
    Literal(lit 'z');
    StoreScoped(index 2);
    ArrayNew();
    StoreVar(index 0);
    ScopePush(count 1);
    Literal(lit 0);
    StoreScoped(index 1);
    Jump(@block19);
  block19:
    LoadScoped(index 1);
    Literal(lit 5);
    BinOp(op '<');
    Branch(@block20, @block23);
  block20:
    ScopePush(count 1);
    LoadScoped(index 3);
    StoreScoped(index 1);
    LoadScoped(index 3);
    Literal(lit 3);
    BinOp(op '===');
    Branch(@block21, @block22);
  block21:
    // Break early
    ScopePop();
    Jump(@block23);
    // Break early
    Jump(@block22);
  block22:
    LoadVar(index 0);
    LoadVar(index 2);
    Literal(lit 'push');
    ObjectGet();
    LoadVar(index 2);
    Literal(lit &function anonymous4);
    ClosureNew();
    Call(count 2);
    StoreVar(index 2);
    Pop(count 1);
    ScopePop();
    ScopeClone();
    LoadScoped(index 1);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 1);
    Pop(count 1);
    Pop(count 1);
    Jump(@block19);
  block23:
    ScopePop();
    // If the scope popping worked, the closure here should refer to the outer `x`
    // and `z`. If the scope popping didn't work then variables [1] and [2] here
    // will be point to the wrong place.
    Literal(lit &function anonymous5);
    ClosureNew();
    StoreVar(index 1);
    LoadVar(index 1);
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit deleted);
    Literal(lit 0);
    StoreVar(index 2);
    Jump(@block24);
  block24:
    LoadVar(index 2);
    LoadVar(index 0);
    Literal(lit 'length');
    ObjectGet();
    BinOp(op '<');
    Branch(@block25, @block26);
  block25:
    LoadVar(index 0);
    LoadVar(index 2);
    ObjectGet();
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadVar(index 2);
    LoadVar(index 3);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 4);
    StoreVar(index 2);
    Pop(count 1);
    Pop(count 1);
    Jump(@block24);
  block26:
    Pop(count 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}

function anonymous4() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '');
    LoadScoped(index 3);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 1);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 6);
    BinOp(op '+');
    Call(count 2);
    Return();
}

function anonymous5() {
  entry:
    LoadGlobal(name 'console');
    LoadVar(index 0);
    Literal(lit 'log');
    ObjectGet();
    LoadVar(index 0);
    Literal(lit '');
    LoadScoped(index 1);
    BinOp(op '+');
    Literal(lit ', ');
    BinOp(op '+');
    LoadScoped(index 2);
    BinOp(op '+');
    Call(count 2);
    StoreVar(index 0);
    Return();
}