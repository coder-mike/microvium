unit ['./test/end-to-end/tests/switch.test.mvm.js'];

entry ['#entry'];

external vmExport;
external assertEqual;
external print;

global thisModule;
global convert;
global weirdSwitch;
global evaluateCase;
global switchWithNoDefault;
global switchFallThroughBottom;
global emptySwitch;
global switchWithOnlyDefault;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function convert);
    StoreGlobal(name 'convert');
    Literal(lit &function weirdSwitch);
    StoreGlobal(name 'weirdSwitch');
    Literal(lit &function evaluateCase);
    StoreGlobal(name 'evaluateCase');
    Literal(lit &function switchWithNoDefault);
    StoreGlobal(name 'switchWithNoDefault');
    Literal(lit &function switchFallThroughBottom);
    StoreGlobal(name 'switchFallThroughBottom');
    Literal(lit &function emptySwitch);
    StoreGlobal(name 'emptySwitch');
    Literal(lit &function switchWithOnlyDefault);
    StoreGlobal(name 'switchWithOnlyDefault');
    // ---
    // description: >
    // Switch statements
    // runExportedFunction: 0
    // # The disassembly uses different block numbers and optimizes the fall-through cases better
    // dontCompareDisassembly: true
    // assertionCount: 6
    // expectedPrintout: |
    // emptySwitch:after
    // switchWithOnlyDefault:default
    // switchWithOnlyDefault:after
    // 1
    // 2
    // 4
    // c
    // d
    // !
    // 1
    // 2
    // b
    // c
    // d
    // !
    // x
    // y
    // z
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
    LoadGlobal(name 'emptySwitch');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'switchWithOnlyDefault');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'convert');
    Literal(lit undefined);
    Literal(lit 5);
    Call(count 2);
    Literal(lit 'It was 5');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'convert');
    Literal(lit undefined);
    Literal(lit 6);
    Call(count 2);
    Literal(lit 'It was 6');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'convert');
    Literal(lit undefined);
    Literal(lit 7);
    Call(count 2);
    Literal(lit 'It was 7');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'convert');
    Literal(lit undefined);
    Literal(lit 'x');
    Call(count 2);
    Literal(lit 'It was x');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'convert');
    Literal(lit undefined);
    Literal(lit 'something else');
    Call(count 2);
    Literal(lit 'Don\'t know what it was');
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'weirdSwitch');
    Literal(lit undefined);
    Literal(lit 5);
    Call(count 2);
    Pop(count 1);
    LoadGlobal(name 'weirdSwitch');
    Literal(lit undefined);
    Literal(lit 2);
    Call(count 2);
    Pop(count 1);
    LoadGlobal(name 'switchFallThroughBottom');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadGlobal(name 'switchWithNoDefault');
    Literal(lit undefined);
    Call(count 1);
    Literal(lit 22);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function convert() {
  entry:
    Literal(lit deleted);
    Literal(lit undefined);
    StoreVar(index 0);
    LoadArg(index 1);
    Jump(@block1);
  block1:
    LoadVar(index 1);
    Literal(lit 5);
    BinOp(op '===');
    Branch(@block6, @block2);
  block2:
    LoadVar(index 1);
    Literal(lit 6);
    BinOp(op '===');
    Branch(@block7, @block3);
  block3:
    LoadVar(index 1);
    Literal(lit 3);
    Literal(lit 4);
    BinOp(op '+');
    BinOp(op '===');
    Branch(@block8, @block4);
  block4:
    LoadVar(index 1);
    Literal(lit 'x');
    BinOp(op '===');
    Branch(@block9, @block5);
  block5:
    Jump(@block10);
  block6:
    Literal(lit 'It was 5');
    LoadVar(index 2);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block11);
    Jump(@block7);
  block7:
    Literal(lit 'It was 6');
    LoadVar(index 2);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block11);
    Jump(@block8);
  block8:
    Literal(lit 'It was 7');
    Return();
  block9:
    Literal(lit 'It was x');
    Return();
  block10:
    Literal(lit 'Don\'t know what it was');
    Return();
  block11:
    Pop(count 1);
    LoadVar(index 0);
    Return();
}

function weirdSwitch() {
  entry:
    // JavaScript has weird (IMO) behavior with fall through from `default`. The
    // test case for `4` is evaluated before the fallback to the default case, but
    // then the consequent for the default case falls through to the consequent of
    // case `4`.
    LoadArg(index 1);
    Jump(@block12);
  block12:
    LoadVar(index 0);
    LoadGlobal(name 'evaluateCase');
    Literal(lit undefined);
    Literal(lit 1);
    Call(count 2);
    BinOp(op '===');
    Branch(@block16, @block13);
  block13:
    LoadVar(index 0);
    LoadGlobal(name 'evaluateCase');
    Literal(lit undefined);
    Literal(lit 2);
    Call(count 2);
    BinOp(op '===');
    Branch(@block17, @block14);
  block14:
    LoadVar(index 0);
    LoadGlobal(name 'evaluateCase');
    Literal(lit undefined);
    Literal(lit 4);
    Call(count 2);
    BinOp(op '===');
    Branch(@block19, @block15);
  block15:
    Jump(@block18);
  block16:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'a');
    Call(count 2);
    Pop(count 1);
    Jump(@block17);
  block17:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'b');
    Call(count 2);
    Pop(count 1);
    Jump(@block18);
  block18:
    LoadGlobal(name 'evaluateCase');
    Literal(lit undefined);
    Literal(lit 'c');
    Call(count 2);
    Pop(count 1);
    Jump(@block19);
  block19:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'd');
    Call(count 2);
    Pop(count 1);
    Jump(@block20);
  block20:
    Pop(count 1);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit '!');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function evaluateCase() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    LoadArg(index 1);
    Call(count 2);
    Pop(count 1);
    LoadArg(index 1);
    Return();
}

function switchWithNoDefault() {
  entry:
    Literal(lit 5);
    Jump(@block21);
  block21:
    LoadVar(index 0);
    Literal(lit 1);
    BinOp(op '===');
    Branch(@block24, @block22);
  block22:
    LoadVar(index 0);
    Literal(lit 2);
    BinOp(op '===');
    Branch(@block25, @block23);
  block23:
    LoadVar(index 0);
    Literal(lit 3);
    BinOp(op '===');
    Branch(@block26, @block27);
  block24:
    Literal(lit 1);
    Return();
  block25:
    Literal(lit 2);
    Return();
  block26:
    Literal(lit 3);
    Return();
  block27:
    Pop(count 1);
    Literal(lit 22);
    Return();
}

function switchFallThroughBottom() {
  entry:
    Literal(lit 1);
    Jump(@block28);
  block28:
    LoadVar(index 0);
    Literal(lit 0);
    BinOp(op '===');
    Branch(@block31, @block29);
  block29:
    LoadVar(index 0);
    Literal(lit 1);
    BinOp(op '===');
    Branch(@block32, @block30);
  block30:
    LoadVar(index 0);
    Literal(lit 2);
    BinOp(op '===');
    Branch(@block33, @block34);
  block31:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'w');
    Call(count 2);
    Pop(count 1);
    Jump(@block32);
  block32:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'x');
    Call(count 2);
    Pop(count 1);
    Jump(@block33);
  block33:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'y');
    Call(count 2);
    Pop(count 1);
    Jump(@block34);
  block34:
    Pop(count 1);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'z');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function emptySwitch() {
  entry:
    Literal(lit 1);
    Jump(@block35);
  block35:
    Pop(count 1);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'emptySwitch:after');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function switchWithOnlyDefault() {
  entry:
    Literal(lit 1);
    Jump(@block36);
  block36:
    Jump(@block37);
  block37:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'switchWithOnlyDefault:default');
    Call(count 2);
    Pop(count 1);
    Jump(@block38);
  block38:
    Pop(count 1);
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'switchWithOnlyDefault:after');
    Call(count 2);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}