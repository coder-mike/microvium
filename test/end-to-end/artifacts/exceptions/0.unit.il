unit ['./test/end-to-end/tests/exceptions.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external print from free-variable 'print';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global test_uncaughtException;
global test_minimalTryCatch;
global test_catchWithoutThrow;
global test_throwUnwinding;
global test_normalUnwinding;
global test_throwAcrossFrames;
global test_conditionalThrow;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function test_uncaughtException);
    StoreGlobal(name 'test_uncaughtException');
    Literal(lit &function test_minimalTryCatch);
    StoreGlobal(name 'test_minimalTryCatch');
    Literal(lit &function test_catchWithoutThrow);
    StoreGlobal(name 'test_catchWithoutThrow');
    Literal(lit &function test_throwUnwinding);
    StoreGlobal(name 'test_throwUnwinding');
    Literal(lit &function test_normalUnwinding);
    StoreGlobal(name 'test_normalUnwinding');
    Literal(lit &function test_throwAcrossFrames);
    StoreGlobal(name 'test_throwAcrossFrames');
    Literal(lit &function test_conditionalThrow);
    StoreGlobal(name 'test_conditionalThrow');
    // ---
    // description: >
    // Testing exceptions
    // runExportedFunction: 0
    // expectException: "My uncaught exception"
    // testOnly: false
    // expectedPrintout: foo
    // assertionCount: 6
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
    LoadGlobal(name 'test_minimalTryCatch');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'test_catchWithoutThrow');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'test_throwUnwinding');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'test_normalUnwinding');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'test_throwAcrossFrames');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadGlobal(name 'test_conditionalThrow');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    // test_exceptionParameter();
    LoadGlobal(name 'test_uncaughtException');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_uncaughtException() {
  entry:
    LoadGlobal(name 'print');
    Literal(lit undefined);
    Literal(lit 'foo');
    Call(count 2);
    Pop(count 1);
    // Should print
    Literal(lit 'My uncaught exception');
    Throw();
}

function test_minimalTryCatch() {
  entry:
    Literal(lit deleted);
    Literal(lit '');
    StoreVar(index 0);
    // The try will emit the instruction `StartTry` to push to the exception stack
    StartTry(@block1);
    LoadVar(index 0);
    Literal(lit 'a');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    // The throw will emit the `Throw` instruction which should unwind the stack
    // and jump to the catch block.
    Literal(lit 'boo!');
    Throw();
  // The try will emit the instruction `StartTry` to push to the exception stack
  block1:
    Pop(count 1);
    // (Entry into the catch should pop the exception since it's unused)
    LoadVar(index 0);
    Literal(lit 'c');
    BinOp(op '+');
    LoadVar(index 1);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block2);
  block2:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'ac');
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_catchWithoutThrow() {
  entry:
    Literal(lit deleted);
    // When an exception isn't thrown, the try block epilog needs to correctly unwind
    // with `EndTry`
    Literal(lit '');
    StoreVar(index 0);
    StartTry(@block3);
    LoadVar(index 0);
    Literal(lit 'a');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit 'b');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    EndTry();
    Jump(@block4);
  block3:
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit 'c');
    BinOp(op '+');
    LoadVar(index 1);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block4);
  block4:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'ab');
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_throwUnwinding() {
  entry:
    Literal(lit deleted);
    Literal(lit '');
    StoreVar(index 0);
    StartTry(@block7);
    LoadVar(index 0);
    Literal(lit 'a');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    StartTry(@block5);
    LoadVar(index 0);
    Literal(lit 'b');
    BinOp(op '+');
    LoadVar(index 5);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 1);
    Throw();
  block5:
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit 'd');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block6);
  block6:
    LoadVar(index 0);
    Literal(lit 'e');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    // The above `try` and corresponding `throw 1` should push and pop the
    // exception stack respectively. The following `throw` then checks that
    // we're using the popped catch target (g) and not the original (d).
    Literal(lit 2);
    Throw();
  block7:
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit 'g');
    BinOp(op '+');
    LoadVar(index 1);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block8);
  block8:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'abdeg');
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_normalUnwinding() {
  entry:
    Literal(lit deleted);
    Literal(lit '');
    StoreVar(index 0);
    StartTry(@block11);
    LoadVar(index 0);
    Literal(lit 'a');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    StartTry(@block9);
    LoadVar(index 0);
    Literal(lit 'b');
    BinOp(op '+');
    LoadVar(index 5);
    StoreVar(index 0);
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit 'c');
    BinOp(op '+');
    LoadVar(index 5);
    StoreVar(index 0);
    Pop(count 1);
    EndTry();
    Jump(@block10);
  block9:
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit 'd');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block10);
  block10:
    LoadVar(index 0);
    Literal(lit 'e');
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 0);
    Pop(count 1);
    // The above `try` ends with an `EndTry` operation rather than `Throw`,
    // because it doesn't throw. The `EndTry` should pop the exception stack.
    // The following `throw` then checks that we're using the popped catch
    // target (g) and not the original (d).
    Literal(lit 2);
    Throw();
  block11:
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit 'g');
    BinOp(op '+');
    LoadVar(index 1);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block12);
  block12:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit 'abceg');
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function test_throwAcrossFrames() {
  entry:
    ScopePush(count 1);
    Literal(lit &function functionThatThrows);
    ClosureNew();
    Literal(lit '');
    StoreScoped(index 1);
    StartTry(@block13);
    LoadScoped(index 1);
    Literal(lit 'a');
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 1);
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    LoadScoped(index 1);
    Literal(lit 'b');
    BinOp(op '+');
    LoadVar(index 3);
    StoreScoped(index 1);
    Pop(count 1);
    EndTry();
    Jump(@block14);
  block13:
    Pop(count 1);
    LoadScoped(index 1);
    Literal(lit 'c');
    BinOp(op '+');
    LoadVar(index 1);
    StoreScoped(index 1);
    Pop(count 1);
    Jump(@block14);
  block14:
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadScoped(index 1);
    Literal(lit 'adc');
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function functionThatThrows() {
  entry:
    LoadScoped(index 1);
    Literal(lit 'd');
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 1);
    Pop(count 1);
    // The throw here should unwind the stack to get to the catch block
    Literal(lit 1);
    Throw();
}

function test_conditionalThrow() {
  entry:
    Literal(lit deleted);
    // This test is mainly to make sure that the static analysis does not think that
    // the code after the if-statement is unreachable if one of the branches is
    // unreachable.
    Literal(lit '');
    StoreVar(index 0);
    Literal(lit deleted);
    Literal(lit 0);
    StoreVar(index 1);
    Jump(@block15);
  block15:
    LoadVar(index 1);
    Literal(lit 4);
    BinOp(op '<');
    Branch(@block16, @block24);
  block16:
    LoadVar(index 0);
    LoadVar(index 1);
    BinOp(op '+');
    LoadVar(index 2);
    StoreVar(index 0);
    Pop(count 1);
    StartTry(@block22);
    LoadVar(index 0);
    Literal(lit 'a');
    BinOp(op '+');
    LoadVar(index 4);
    StoreVar(index 0);
    Pop(count 1);
    // Check throwing in the consequent branch
    LoadVar(index 1);
    Literal(lit 3);
    BinOp(op '%');
    Literal(lit 0);
    BinOp(op '===');
    Branch(@block17, @block18);
  block17:
    LoadVar(index 0);
    Literal(lit 'b');
    BinOp(op '+');
    LoadVar(index 4);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 1);
    Throw();
  block18:
    LoadVar(index 0);
    Literal(lit 'c');
    BinOp(op '+');
    LoadVar(index 4);
    StoreVar(index 0);
    Pop(count 1);
    // Check throwing in the alternate branch
    LoadVar(index 1);
    Literal(lit 3);
    BinOp(op '%');
    Literal(lit 1);
    BinOp(op '!==');
    // Check throwing in the alternate branch
    Branch(@block19, @block20);
  block19:
    LoadVar(index 0);
    Literal(lit 'd');
    BinOp(op '+');
    LoadVar(index 4);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block21);
  block20:
    LoadVar(index 0);
    Literal(lit 'e');
    BinOp(op '+');
    LoadVar(index 4);
    StoreVar(index 0);
    Pop(count 1);
    Literal(lit 2);
    Throw();
  block21:
    // The static analysis needs to
    LoadVar(index 0);
    Literal(lit 'f');
    BinOp(op '+');
    LoadVar(index 4);
    StoreVar(index 0);
    Pop(count 1);
    EndTry();
    Jump(@block23);
  block22:
    Pop(count 1);
    LoadVar(index 0);
    Literal(lit 'g');
    BinOp(op '+');
    LoadVar(index 2);
    StoreVar(index 0);
    Pop(count 1);
    Jump(@block23);
  block23:
    LoadVar(index 0);
    Literal(lit 'h');
    BinOp(op '+');
    LoadVar(index 2);
    StoreVar(index 0);
    Pop(count 1);
    LoadVar(index 1);
    LoadVar(index 2);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 3);
    StoreVar(index 1);
    Pop(count 1);
    Pop(count 1);
    Jump(@block15);
  block24:
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 0);
    Literal(lit '0abgh1acegh2acdfh3abgh');
    Call(count 3);
    Pop(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}