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
global test_exceptionParameter;
global test_exceptionParameterWithClosure;
global test_rethrow;
global test_breakOutOfTry;
global test_breakOutOfTryWithClosure;
global test_breakOutOfCatch;
global test_breakOutOfDoubleCatch;
global test_returnFromTry;
global test_returnInsideNestedTry;
global test_returnInsideNestedCatch;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_uncaughtException); // 2       ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_uncaughtException'); // 1          ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_minimalTryCatch); // 2         ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_minimalTryCatch'); // 1            ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_catchWithoutThrow); // 2       ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_catchWithoutThrow'); // 1          ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_throwUnwinding); // 2          ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_throwUnwinding'); // 1             ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_normalUnwinding); // 2         ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_normalUnwinding'); // 1            ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_throwAcrossFrames); // 2       ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_throwAcrossFrames'); // 1          ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_conditionalThrow); // 2        ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_conditionalThrow'); // 1           ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_exceptionParameter); // 2      ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_exceptionParameter'); // 1         ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_exceptionParameterWithClosure); // 2  ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_exceptionParameterWithClosure'); // 1  ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_rethrow); // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_rethrow');    // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_breakOutOfTry); // 2           ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_breakOutOfTry'); // 1              ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_breakOutOfTryWithClosure); // 2  ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_breakOutOfTryWithClosure'); // 1   ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_breakOutOfCatch); // 2         ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_breakOutOfCatch'); // 1            ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_breakOutOfDoubleCatch); // 2   ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_breakOutOfDoubleCatch'); // 1      ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_returnFromTry); // 2           ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_returnFromTry'); // 1              ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_returnInsideNestedTry); // 2   ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_returnInsideNestedTry'); // 1      ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    Literal(lit &function test_returnInsideNestedCatch); // 2  ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    StoreGlobal(name 'test_returnInsideNestedCatch'); // 1    ./test/end-to-end/tests/exceptions.test.mvm.js:1:1
    // ---
    // description: >
    // Testing exceptions
    // runExportedFunction: 0
    // # testOnly: true
    // expectException: "My uncaught exception"
    // expectedPrintout: foo
    // assertionCount: 17
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:11:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:11:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:11:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/exceptions.test.mvm.js:11:13
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:11:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:422:1
    Return();                            // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:422:1
}

function run() {
  entry:
    LoadGlobal(name 'test_minimalTryCatch'); // 1             ./test/end-to-end/tests/exceptions.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:14:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:14:3
    LoadGlobal(name 'test_catchWithoutThrow'); // 1           ./test/end-to-end/tests/exceptions.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:15:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:15:3
    LoadGlobal(name 'test_throwUnwinding'); // 1              ./test/end-to-end/tests/exceptions.test.mvm.js:16:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:16:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:16:3
    LoadGlobal(name 'test_normalUnwinding'); // 1             ./test/end-to-end/tests/exceptions.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:17:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:17:3
    LoadGlobal(name 'test_throwAcrossFrames'); // 1           ./test/end-to-end/tests/exceptions.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:18:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:18:3
    LoadGlobal(name 'test_conditionalThrow'); // 1            ./test/end-to-end/tests/exceptions.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:19:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:19:3
    LoadGlobal(name 'test_exceptionParameter'); // 1          ./test/end-to-end/tests/exceptions.test.mvm.js:20:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:20:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:20:3
    LoadGlobal(name 'test_exceptionParameterWithClosure'); // 1  ./test/end-to-end/tests/exceptions.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:21:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:21:3
    LoadGlobal(name 'test_rethrow');     // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:22:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:22:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:22:3
    LoadGlobal(name 'test_breakOutOfTry'); // 1               ./test/end-to-end/tests/exceptions.test.mvm.js:23:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:23:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:23:3
    LoadGlobal(name 'test_breakOutOfTryWithClosure'); // 1    ./test/end-to-end/tests/exceptions.test.mvm.js:24:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:24:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:24:3
    LoadGlobal(name 'test_breakOutOfCatch'); // 1             ./test/end-to-end/tests/exceptions.test.mvm.js:25:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:25:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:25:3
    LoadGlobal(name 'test_breakOutOfDoubleCatch'); // 1       ./test/end-to-end/tests/exceptions.test.mvm.js:26:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:26:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:26:3
    LoadGlobal(name 'test_returnFromTry'); // 1               ./test/end-to-end/tests/exceptions.test.mvm.js:27:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:27:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:27:3
    LoadGlobal(name 'test_returnInsideNestedTry'); // 1       ./test/end-to-end/tests/exceptions.test.mvm.js:28:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:28:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:28:3
    LoadGlobal(name 'test_returnInsideNestedCatch'); // 1     ./test/end-to-end/tests/exceptions.test.mvm.js:29:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:29:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:29:3
    LoadGlobal(name 'test_uncaughtException'); // 1           ./test/end-to-end/tests/exceptions.test.mvm.js:31:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:31:3
    Call(count 1, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:31:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:32:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:32:2
}

function test_uncaughtException() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:35:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:35:3
    Literal(lit 'foo');                  // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:35:9
    Call(count 2, true);                 // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:35:9
    // Should print
    Literal(lit 'My uncaught exception'); // 1                ./test/end-to-end/tests/exceptions.test.mvm.js:36:9
    Throw();                             // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:36:9
}

function test_minimalTryCatch() {
  entry:
    Literal(lit deleted);                // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:40:33
    Literal(lit '');                     // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:41:11
    StoreVar(index 0);                   // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:41:11
    // The try will emit the instruction `StartTry` to push to the exception stack
    StartTry(@block1);                   // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:43:7
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:44:5
    Literal(lit 'a');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:44:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:44:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:44:10
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:44:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:44:10
    // The throw will emit the `Throw` instruction which should unwind the stack
    // and jump to the catch block.
    Literal(lit 'boo!');                 // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:47:11
    Throw();                             // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:47:11
  block1:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:49:11
    // (Entry into the catch should pop the exception since it's unused)
    LoadVar(index 0);                    // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:51:5
    Literal(lit 'c');                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:51:10
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:51:10
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:51:10
    StoreVar(index 0);                   // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:51:10
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:51:10
    Jump(@block2);                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:52:4
  block2:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:54:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:54:3
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:54:15
    Literal(lit 'ac');                   // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:54:18
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:54:18
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:55:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:55:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:55:2
}

function test_catchWithoutThrow() {
  entry:
    Literal(lit deleted);                // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:57:35
    // When an exception isn't thrown, the try block epilog needs to correctly unwind
    // with `EndTry`
    Literal(lit '');                     // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:63:11
    StoreVar(index 0);                   // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:63:11
    StartTry(@block3);                   // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:64:7
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:65:5
    Literal(lit 'a');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:65:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:65:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:65:10
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:65:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:65:10
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:66:5
    Literal(lit 'b');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:66:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:66:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:66:10
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:66:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:66:10
    EndTry();                            // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:67:4
    Jump(@block4);                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:67:4
  block3:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:67:11
    LoadVar(index 0);                    // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:68:5
    Literal(lit 'c');                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:68:10
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:68:10
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:68:10
    StoreVar(index 0);                   // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:68:10
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:68:10
    Jump(@block4);                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:69:4
  block4:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:71:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:71:3
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:71:15
    Literal(lit 'ab');                   // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:71:18
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:71:18
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:72:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:72:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:72:2
}

function test_throwUnwinding() {
  entry:
    Literal(lit deleted);                // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:74:32
    Literal(lit '');                     // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:75:11
    StoreVar(index 0);                   // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:75:11
    StartTry(@block7);                   // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:76:7
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:77:5
    Literal(lit 'a');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:77:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:77:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:77:10
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:77:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:77:10
    StartTry(@block5);                   // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:78:9
    LoadVar(index 0);                    // 6  s              ./test/end-to-end/tests/exceptions.test.mvm.js:79:7
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:79:12
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:79:12
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:79:12
    StoreVar(index 0);                   // 6  s              ./test/end-to-end/tests/exceptions.test.mvm.js:79:12
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:79:12
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:80:13
    Throw();                             // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:80:13
  block5:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:82:13
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:83:7
    Literal(lit 'd');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:83:12
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:83:12
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:83:12
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:83:12
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:83:12
    Jump(@block6);                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:84:6
  block6:
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:85:5
    Literal(lit 'e');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:85:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:85:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:85:10
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:85:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:85:10
    // The above `try` and corresponding `throw 1` should push and pop the
    // exception stack respectively. The following `throw` then checks that
    // we're using the popped catch target (g) and not the original (d).
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:89:11
    Throw();                             // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:89:11
  block7:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:91:11
    LoadVar(index 0);                    // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:92:5
    Literal(lit 'g');                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:92:10
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:92:10
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:92:10
    StoreVar(index 0);                   // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:92:10
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:92:10
    Jump(@block8);                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:93:4
  block8:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:95:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:95:3
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:95:15
    Literal(lit 'abdeg');                // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:95:18
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:95:18
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:96:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:96:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:96:2
}

function test_normalUnwinding() {
  entry:
    Literal(lit deleted);                // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:98:33
    Literal(lit '');                     // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:99:11
    StoreVar(index 0);                   // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:99:11
    StartTry(@block11);                  // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:100:7
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:101:5
    Literal(lit 'a');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:101:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:101:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:101:10
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:101:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:101:10
    StartTry(@block9);                   // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:102:9
    LoadVar(index 0);                    // 6  s              ./test/end-to-end/tests/exceptions.test.mvm.js:103:7
    Literal(lit 'b');                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:103:12
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:103:12
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:103:12
    StoreVar(index 0);                   // 6  s              ./test/end-to-end/tests/exceptions.test.mvm.js:103:12
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:103:12
    LoadVar(index 0);                    // 6  s              ./test/end-to-end/tests/exceptions.test.mvm.js:104:7
    Literal(lit 'c');                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:104:12
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:104:12
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:104:12
    StoreVar(index 0);                   // 6  s              ./test/end-to-end/tests/exceptions.test.mvm.js:104:12
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:104:12
    EndTry();                            // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:105:6
    Jump(@block10);                      // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:105:6
  block9:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:105:13
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:106:7
    Literal(lit 'd');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:106:12
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:106:12
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:106:12
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:106:12
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:106:12
    Jump(@block10);                      // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:107:6
  block10:
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:108:5
    Literal(lit 'e');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:108:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:108:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:108:10
    StoreVar(index 0);                   // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:108:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:108:10
    // The above `try` ends with an `EndTry` operation rather than `Throw`,
    // because it doesn't throw. The `EndTry` should pop the exception stack.
    // The following `throw` then checks that we're using the popped catch
    // target (g) and not the original (d).
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:113:11
    Throw();                             // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:113:11
  block11:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:115:11
    LoadVar(index 0);                    // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:116:5
    Literal(lit 'g');                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:116:10
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:116:10
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:116:10
    StoreVar(index 0);                   // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:116:10
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:116:10
    Jump(@block12);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:117:4
  block12:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:119:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:119:3
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:119:15
    Literal(lit 'abceg');                // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:119:18
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:119:18
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:120:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:120:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:120:2
}

function test_throwAcrossFrames() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:122:1
    Literal(lit &function functionThatThrows); // 1           ./test/end-to-end/tests/exceptions.test.mvm.js:122:35
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:122:35
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:122:35
    Literal(lit '');                     // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:123:11
    StoreScoped(index 1);                // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:123:11
    StartTry(@block13);                  // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:124:7
    LoadScoped(index 1);                 // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:125:5
    Literal(lit 'a');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:125:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:125:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:125:10
    StoreScoped(index 1);                // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:125:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:125:10
    LoadVar(index 0);                    // 4  functionThatThrows ./test/end-to-end/tests/exceptions.test.mvm.js:126:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:126:5
    Call(count 1, true);                 // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:126:5
    LoadScoped(index 1);                 // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:127:5
    Literal(lit 'b');                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:127:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:127:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:127:10
    StoreScoped(index 1);                // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:127:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:127:10
    EndTry();                            // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:128:4
    Jump(@block14);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:128:4
  block13:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:128:11
    LoadScoped(index 1);                 // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:129:5
    Literal(lit 'c');                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:129:10
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:129:10
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:129:10
    StoreScoped(index 1);                // 2  s              ./test/end-to-end/tests/exceptions.test.mvm.js:129:10
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:129:10
    Jump(@block14);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:130:4
  block14:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:132:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:132:3
    LoadScoped(index 1);                 // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:132:15
    Literal(lit 'adc');                  // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:132:18
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:132:18
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:140:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:140:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:140:2
}

function functionThatThrows() {
  entry:
    LoadScoped(index 1);                 // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:135:5
    Literal(lit 'd');                    // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:135:10
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:135:10
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:135:10
    StoreScoped(index 1);                // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:135:10
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:135:10
    // The throw here should unwind the stack to get to the catch block
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:137:11
    Throw();                             // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:137:11
}

function test_conditionalThrow() {
  entry:
    Literal(lit deleted);                // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:142:34
    // This test is mainly to make sure that the static analysis does not think that
    // the code after the if-statement is unreachable if one of the branches is
    // unreachable.
    Literal(lit '');                     // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:148:11
    StoreVar(index 0);                   // 1  s              ./test/end-to-end/tests/exceptions.test.mvm.js:148:11
    Literal(lit deleted);                // 2  i              ./test/end-to-end/tests/exceptions.test.mvm.js:149:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:16
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/exceptions.test.mvm.js:149:16
    Jump(@block15);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:16
  block15:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/exceptions.test.mvm.js:149:19
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:23
    Branch(@block16, @block24);          // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:23
  block16:
    LoadVar(index 0);                    // 3  s              ./test/end-to-end/tests/exceptions.test.mvm.js:150:5
    LoadVar(index 1);                    // 4  i              ./test/end-to-end/tests/exceptions.test.mvm.js:150:10
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:150:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:150:10
    StoreVar(index 0);                   // 3  s              ./test/end-to-end/tests/exceptions.test.mvm.js:150:10
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:150:10
    StartTry(@block22);                  // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:151:9
    LoadVar(index 0);                    // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:152:7
    Literal(lit 'a');                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:152:12
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:152:12
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:152:12
    StoreVar(index 0);                   // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:152:12
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:152:12
    // Check throwing in the consequent branch
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/exceptions.test.mvm.js:154:11
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:154:15
    BinOp(op '%');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:154:15
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:154:21
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:154:21
    Branch(@block17, @block18);          // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:154:11
  block17:
    LoadVar(index 0);                    // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:155:9
    Literal(lit 'b');                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:155:14
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:155:14
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:155:14
    StoreVar(index 0);                   // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:155:14
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:155:14
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:156:15
    Throw();                             // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:156:15
  block18:
    LoadVar(index 0);                    // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:158:7
    Literal(lit 'c');                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:158:12
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:158:12
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:158:12
    StoreVar(index 0);                   // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:158:12
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:158:12
    // Check throwing in the alternate branch
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/exceptions.test.mvm.js:160:11
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:160:15
    BinOp(op '%');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:160:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:160:21
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:160:21
    // Check throwing in the alternate branch
    Branch(@block19, @block20);          // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:160:7
  block19:
    LoadVar(index 0);                    // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:161:9
    Literal(lit 'd');                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:161:14
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:161:14
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:161:14
    StoreVar(index 0);                   // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:161:14
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:161:14
    Jump(@block21);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:162:8
  block20:
    LoadVar(index 0);                    // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:164:9
    Literal(lit 'e');                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:164:14
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:164:14
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:164:14
    StoreVar(index 0);                   // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:164:14
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:164:14
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:165:15
    Throw();                             // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:165:15
  block21:
    // The static analysis needs to
    LoadVar(index 0);                    // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:168:7
    Literal(lit 'f');                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:168:12
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:168:12
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:168:12
    StoreVar(index 0);                   // 5  s              ./test/end-to-end/tests/exceptions.test.mvm.js:168:12
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:168:12
    EndTry();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:169:6
    Jump(@block23);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:169:6
  block22:
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:169:13
    LoadVar(index 0);                    // 3  s              ./test/end-to-end/tests/exceptions.test.mvm.js:170:7
    Literal(lit 'g');                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:170:12
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:170:12
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:170:12
    StoreVar(index 0);                   // 3  s              ./test/end-to-end/tests/exceptions.test.mvm.js:170:12
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:170:12
    Jump(@block23);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:171:6
  block23:
    LoadVar(index 0);                    // 3  s              ./test/end-to-end/tests/exceptions.test.mvm.js:172:5
    Literal(lit 'h');                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:172:10
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:172:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:172:10
    StoreVar(index 0);                   // 3  s              ./test/end-to-end/tests/exceptions.test.mvm.js:172:10
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:172:10
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
    StoreVar(index 1);                   // 4  i              ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
    Jump(@block15);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:149:26
  block24:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:173:4
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:175:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:175:3
    LoadVar(index 0);                    // 4  s              ./test/end-to-end/tests/exceptions.test.mvm.js:175:15
    Literal(lit '0abgh1acegh2acdfh3abgh'); // 5               ./test/end-to-end/tests/exceptions.test.mvm.js:175:18
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:175:18
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:176:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:176:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:176:2
}

function test_exceptionParameter() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:178:1
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:178:1
    Literal(lit deleted);                // 3  x              ./test/end-to-end/tests/exceptions.test.mvm.js:178:36
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:179:11
    StoreVar(index 2);                   // 3  x              ./test/end-to-end/tests/exceptions.test.mvm.js:179:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:180:7
    StoreVar(index 0);                   // 3  v0             ./test/end-to-end/tests/exceptions.test.mvm.js:180:7
    StartTry(@block25);                  // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:181:7
    Literal(lit deleted);                // 6  y              ./test/end-to-end/tests/exceptions.test.mvm.js:181:7
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:182:9
    StoreVar(index 5);                   // 6  y              ./test/end-to-end/tests/exceptions.test.mvm.js:182:9
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:183:9
    StoreVar(index 1);                   // 6  v1             ./test/end-to-end/tests/exceptions.test.mvm.js:183:9
    Literal(lit 42);                     // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:184:11
    Throw();                             // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:184:11
  block25:
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:185:15
    Literal(lit deleted);                // 6  z              ./test/end-to-end/tests/exceptions.test.mvm.js:185:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:186:9
    StoreVar(index 5);                   // 6  z              ./test/end-to-end/tests/exceptions.test.mvm.js:186:9
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:187:9
    StoreVar(index 4);                   // 6  v2             ./test/end-to-end/tests/exceptions.test.mvm.js:187:9
    LoadVar(index 3);                    // 7  e              ./test/end-to-end/tests/exceptions.test.mvm.js:188:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:188:9
    StoreVar(index 2);                   // 7  x              ./test/end-to-end/tests/exceptions.test.mvm.js:188:9
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:188:9
    Pop(count 3);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:189:4
    Jump(@block26);                      // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:189:4
  block26:
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:190:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:190:3
    LoadVar(index 2);                    // 6  x              ./test/end-to-end/tests/exceptions.test.mvm.js:190:15
    Literal(lit 42);                     // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:190:18
    Call(count 3, true);                 // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:190:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:191:2
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:191:2
    Return();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:191:2
}

function test_exceptionParameterWithClosure() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:193:1
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:193:1
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:193:1
    Literal(lit deleted);                // 3  x              ./test/end-to-end/tests/exceptions.test.mvm.js:193:47
    Literal(lit deleted);                // 4  f              ./test/end-to-end/tests/exceptions.test.mvm.js:193:47
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:194:11
    StoreVar(index 2);                   // 4  x              ./test/end-to-end/tests/exceptions.test.mvm.js:194:11
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:195:7
    StoreVar(index 3);                   // 4  f              ./test/end-to-end/tests/exceptions.test.mvm.js:195:7
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:196:7
    StoreVar(index 0);                   // 4  v0             ./test/end-to-end/tests/exceptions.test.mvm.js:196:7
    StartTry(@block27);                  // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:197:7
    Literal(lit deleted);                // 7  y              ./test/end-to-end/tests/exceptions.test.mvm.js:197:7
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:198:9
    StoreVar(index 6);                   // 7  y              ./test/end-to-end/tests/exceptions.test.mvm.js:198:9
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:199:9
    StoreVar(index 1);                   // 7  v1             ./test/end-to-end/tests/exceptions.test.mvm.js:199:9
    Literal(lit 42);                     // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:200:11
    Throw();                             // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:200:11
  block27:
    StoreScoped(index 1);                // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:201:15
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:201:15
    Literal(lit deleted);                // 6  z              ./test/end-to-end/tests/exceptions.test.mvm.js:201:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:202:9
    StoreVar(index 5);                   // 6  z              ./test/end-to-end/tests/exceptions.test.mvm.js:202:9
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:203:9
    StoreVar(index 4);                   // 6  v2             ./test/end-to-end/tests/exceptions.test.mvm.js:203:9
    LoadScoped(index 1);                 // 7  e              ./test/end-to-end/tests/exceptions.test.mvm.js:204:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:204:9
    StoreVar(index 2);                   // 7  x              ./test/end-to-end/tests/exceptions.test.mvm.js:204:9
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:204:9
    Literal(lit &function anonymous);    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:205:9
    StoreScoped(index 0);                // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:205:9
    LoadReg(name 'closure');             // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:205:9
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:205:9
    StoreVar(index 3);                   // 7  f              ./test/end-to-end/tests/exceptions.test.mvm.js:205:9
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:205:9
    Pop(count 2);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:206:4
    Jump(@block28);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:206:4
  block28:
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:207:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:207:3
    LoadVar(index 2);                    // 7  x              ./test/end-to-end/tests/exceptions.test.mvm.js:207:15
    Literal(lit 42);                     // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:207:18
    Call(count 3, true);                 // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:207:18
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:208:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:208:3
    LoadVar(index 3);                    // 7  f              ./test/end-to-end/tests/exceptions.test.mvm.js:208:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:208:15
    Call(count 1, true);                 // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:208:15
    Literal(lit 42);                     // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:208:20
    Call(count 3, true);                 // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:208:20
    Pop(count 2);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:209:2
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:209:2
    Return();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:209:2
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  e              ./test/end-to-end/tests/exceptions.test.mvm.js:205:15
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:205:15
}

function test_rethrow() {
  entry:
    StartTry(@block31);                  // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:212:7
    StartTry(@block29);                  // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:213:9
    ObjectNew();                         // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:214:13
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:214:13
    Literal(lit 'message');              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:214:13
    Literal(lit 'boo!');                 // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:214:24
    ObjectSet();                         // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:214:24
    Throw();                             // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:214:24
  block29:
    LoadVar(index 2);                    // 4  e              ./test/end-to-end/tests/exceptions.test.mvm.js:216:13
    Throw();                             // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:216:13
  block30:
    EndTry();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:218:4
    Jump(@block32);                      // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:218:4
  block31:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:219:5
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:219:5
    LoadVar(index 0);                    // 4  e              ./test/end-to-end/tests/exceptions.test.mvm.js:219:17
    Literal(lit 'message');              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:219:17
    ObjectGet();                         // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:219:17
    Literal(lit 'boo!');                 // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:219:28
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:219:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:220:4
    Jump(@block32);                      // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:220:4
  block32:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:221:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:221:2
}

function test_breakOutOfTry() {
  entry:
    Literal(lit deleted);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:223:31
    Literal(lit 'start');                // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:224:14
    StoreVar(index 0);                   // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:224:14
    Literal(lit deleted);                // 2  i              ./test/end-to-end/tests/exceptions.test.mvm.js:225:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:16
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/exceptions.test.mvm.js:225:16
    Jump(@block33);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:16
  block33:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/exceptions.test.mvm.js:225:19
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:23
    Branch(@block34, @block39);          // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:23
  block34:
    LoadVar(index 0);                    // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:226:5
    Literal(lit '_i');                   // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:226:13
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/exceptions.test.mvm.js:226:18
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:226:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:226:18
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:226:18
    StoreVar(index 0);                   // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:226:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:226:18
    StartTry(@block37);                  // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:227:9
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/exceptions.test.mvm.js:228:11
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:228:17
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:228:17
    Branch(@block35, @block36);          // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:228:11
  block35:
    Literal(lit deleted);                // 5  x              ./test/end-to-end/tests/exceptions.test.mvm.js:228:20
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:229:13
    StoreVar(index 4);                   // 5  x              ./test/end-to-end/tests/exceptions.test.mvm.js:229:13
    LoadVar(index 0);                    // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:230:9
    Literal(lit '_break');               // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:230:17
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:230:17
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:230:17
    StoreVar(index 0);                   // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:230:17
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:230:17
    // The break here should pop `x` off the stack, `EndTry`, but should not
    // pop the loop variable because the break jumps to the loops
    // terminating block which pops the loop variable.
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:234:9
    EndTry();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:234:9
    Jump(@block39);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:234:9
  block36:
    EndTry();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:236:6
    Jump(@block38);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:236:6
  block37:
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:236:13
    // This should never execute
    LoadVar(index 0);                    // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:238:7
    Literal(lit '_catch');               // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:238:15
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:238:15
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:238:15
    StoreVar(index 0);                   // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:238:15
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:238:15
    Jump(@block38);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:239:6
  block38:
    // This should execute once
    LoadVar(index 0);                    // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:241:5
    Literal(lit '_loopEnd');             // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:241:13
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:241:13
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:241:13
    StoreVar(index 0);                   // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:241:13
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:241:13
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
    StoreVar(index 1);                   // 4  i              ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
    Jump(@block33);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:225:28
  block39:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:242:4
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:243:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:243:3
    LoadVar(index 0);                    // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:243:15
    Literal(lit 'start_i0_loopEnd_i1_loopEnd_i2_break'); // 5  ./test/end-to-end/tests/exceptions.test.mvm.js:243:21
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:243:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:244:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:244:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:244:2
}

function test_breakOutOfTryWithClosure() {
  entry:
    Literal(lit deleted);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:246:42
    Literal(lit 'start');                // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:247:14
    StoreVar(index 0);                   // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:247:14
    ScopeNew(count 1);                   // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:3
    Literal(lit 0);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:16
    StoreScoped(index 0);                // 1  i              ./test/end-to-end/tests/exceptions.test.mvm.js:248:16
    Jump(@block40);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:16
  block40:
    LoadScoped(index 0);                 // 2  i              ./test/end-to-end/tests/exceptions.test.mvm.js:248:19
    Literal(lit 100);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:23
    BinOp(op '<');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:23
    Branch(@block41, @block46);          // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:23
  block41:
    ScopePush(count 2);                  // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:33
    LoadVar(index 0);                    // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:249:5
    Literal(lit '_i');                   // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:249:13
    LoadScoped(index 2);                 // 4  i              ./test/end-to-end/tests/exceptions.test.mvm.js:249:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:249:18
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:249:18
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:249:18
    StoreVar(index 0);                   // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:249:18
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:249:18
    // This forces loop variable `i` to be closure allocated
    Literal(lit &function anonymous1);   // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:251:6
    StoreScoped(index 0);                // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:251:6
    LoadReg(name 'closure');             // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:251:6
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:251:6
    StartTry(@block44);                  // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:252:9
    LoadScoped(index 2);                 // 4  i              ./test/end-to-end/tests/exceptions.test.mvm.js:253:11
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:253:17
    BinOp(op '===');                     // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:253:17
    Branch(@block42, @block43);          // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:253:11
  block42:
    Literal(lit deleted);                // 4  x              ./test/end-to-end/tests/exceptions.test.mvm.js:253:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:254:13
    StoreVar(index 3);                   // 4  x              ./test/end-to-end/tests/exceptions.test.mvm.js:254:13
    LoadVar(index 0);                    // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:255:9
    Literal(lit '_break');               // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:255:17
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:255:17
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:255:17
    StoreVar(index 0);                   // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:255:17
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:255:17
    // The break here should pop `x` off the stack, `EndTry`, but should not
    // pop the closure scope because the break jumps to the loops
    // terminating block which pops the closure scope.
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:259:9
    EndTry();                            // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:259:9
    ScopePop();                          // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:259:9
    Jump(@block46);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:259:9
  block43:
    EndTry();                            // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:261:6
    Jump(@block45);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:261:6
  block44:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:261:13
    // This should never execute
    LoadVar(index 0);                    // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:263:7
    Literal(lit '_catch');               // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:263:15
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:263:15
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:263:15
    StoreVar(index 0);                   // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:263:15
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:263:15
    Jump(@block45);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:264:6
  block45:
    // This should execute once
    LoadVar(index 0);                    // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:266:5
    Literal(lit '_loopEnd');             // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:266:13
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:266:13
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:266:13
    StoreVar(index 0);                   // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:266:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:266:13
    ScopePop();                          // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:267:4
    ScopeClone();                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:267:4
    LoadScoped(index 0);                 // 2  i              ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
    StoreScoped(index 0);                // 3  i              ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
    Jump(@block40);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:248:28
  block46:
    ScopeDiscard();                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:267:4
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:268:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:268:3
    LoadVar(index 0);                    // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:268:15
    Literal(lit 'start_i0_loopEnd_i1_loopEnd_i2_break'); // 5  ./test/end-to-end/tests/exceptions.test.mvm.js:268:21
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:268:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:269:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:269:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:269:2
}

function anonymous1() {
  entry:
    LoadScoped(index 2);                 // 1  i              ./test/end-to-end/tests/exceptions.test.mvm.js:251:12
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:251:12
}

function test_breakOutOfCatch() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:271:1
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:271:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:271:1
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:271:1
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:271:1
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:271:1
    Literal(lit deleted);                // 7  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:271:33
    Literal(lit 'start');                // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:272:14
    StoreVar(index 6);                   // 7  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:272:14
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:273:7
    StoreVar(index 0);                   // 7  v1             ./test/end-to-end/tests/exceptions.test.mvm.js:273:7
    Literal(lit deleted);                // 8  i              ./test/end-to-end/tests/exceptions.test.mvm.js:274:3
    Literal(lit 0);                      // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:274:16
    StoreVar(index 7);                   // 8  i              ./test/end-to-end/tests/exceptions.test.mvm.js:274:16
    Jump(@block47);                      // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:274:16
  block47:
    LoadVar(index 7);                    // 9  i              ./test/end-to-end/tests/exceptions.test.mvm.js:274:19
    Literal(lit 100);                    // 10                ./test/end-to-end/tests/exceptions.test.mvm.js:274:23
    BinOp(op '<');                       // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:274:23
    Branch(@block48, @block55);          // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:274:23
  block48:
    Literal(lit deleted);                // 9  a              ./test/end-to-end/tests/exceptions.test.mvm.js:274:33
    // Stack depth 2
    LoadVar(index 6);                    // 10 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:276:5
    Literal(lit '_i');                   // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:276:13
    LoadVar(index 7);                    // 12 i              ./test/end-to-end/tests/exceptions.test.mvm.js:276:18
    BinOp(op '+');                       // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:276:18
    BinOp(op '+');                       // 10                ./test/end-to-end/tests/exceptions.test.mvm.js:276:18
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:276:18
    StoreVar(index 6);                   // 10 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:276:18
    Pop(count 1);                        // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:276:18
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/exceptions.test.mvm.js:277:9
    StoreVar(index 8);                   // 9  a              ./test/end-to-end/tests/exceptions.test.mvm.js:277:9
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/exceptions.test.mvm.js:278:9
    StoreVar(index 1);                   // 9  v2             ./test/end-to-end/tests/exceptions.test.mvm.js:278:9
    // Stack depth 3
    StartTry(@block53);                  // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:280:9
    Literal(lit deleted);                // 12 b              ./test/end-to-end/tests/exceptions.test.mvm.js:280:9
    // Stack depth 5
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/exceptions.test.mvm.js:282:11
    StoreVar(index 11);                  // 12 b              ./test/end-to-end/tests/exceptions.test.mvm.js:282:11
    Literal(lit undefined);              // 13                ./test/end-to-end/tests/exceptions.test.mvm.js:283:11
    StoreVar(index 2);                   // 12 v3             ./test/end-to-end/tests/exceptions.test.mvm.js:283:11
    // Stack depth 6
    StartTry(@block51);                  // 14                ./test/end-to-end/tests/exceptions.test.mvm.js:285:11
    Literal(lit deleted);                // 15 c              ./test/end-to-end/tests/exceptions.test.mvm.js:285:11
    // Stack depth 8
    Literal(lit undefined);              // 16                ./test/end-to-end/tests/exceptions.test.mvm.js:287:13
    StoreVar(index 14);                  // 15 c              ./test/end-to-end/tests/exceptions.test.mvm.js:287:13
    Literal(lit undefined);              // 16                ./test/end-to-end/tests/exceptions.test.mvm.js:288:13
    StoreVar(index 3);                   // 15 v4             ./test/end-to-end/tests/exceptions.test.mvm.js:288:13
    // Stack depth 9
    LoadVar(index 7);                    // 16 i              ./test/end-to-end/tests/exceptions.test.mvm.js:290:13
    Literal(lit 2);                      // 17                ./test/end-to-end/tests/exceptions.test.mvm.js:290:19
    BinOp(op '===');                     // 16                ./test/end-to-end/tests/exceptions.test.mvm.js:290:19
    Branch(@block49, @block50);          // 15                ./test/end-to-end/tests/exceptions.test.mvm.js:290:13
  block49:
    Literal(lit deleted);                // 16 d              ./test/end-to-end/tests/exceptions.test.mvm.js:290:22
    Literal(lit undefined);              // 17                ./test/end-to-end/tests/exceptions.test.mvm.js:291:15
    StoreVar(index 15);                  // 16 d              ./test/end-to-end/tests/exceptions.test.mvm.js:291:15
    Literal(lit undefined);              // 17                ./test/end-to-end/tests/exceptions.test.mvm.js:292:15
    StoreVar(index 4);                   // 16 v5             ./test/end-to-end/tests/exceptions.test.mvm.js:292:15
    // Stack depth 10
    LoadVar(index 6);                    // 17 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:294:11
    Literal(lit '_throw');               // 18                ./test/end-to-end/tests/exceptions.test.mvm.js:294:19
    BinOp(op '+');                       // 17                ./test/end-to-end/tests/exceptions.test.mvm.js:294:19
    LoadVar(index 16);                   // 18                ./test/end-to-end/tests/exceptions.test.mvm.js:294:19
    StoreVar(index 6);                   // 17 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:294:19
    Pop(count 1);                        // 16                ./test/end-to-end/tests/exceptions.test.mvm.js:294:19
    ObjectNew();                         // 17                ./test/end-to-end/tests/exceptions.test.mvm.js:295:17
    LoadVar(index 16);                   // 18                ./test/end-to-end/tests/exceptions.test.mvm.js:295:17
    Literal(lit 'message');              // 19                ./test/end-to-end/tests/exceptions.test.mvm.js:295:17
    Literal(lit 'boo!');                 // 20                ./test/end-to-end/tests/exceptions.test.mvm.js:295:28
    ObjectSet();                         // 17                ./test/end-to-end/tests/exceptions.test.mvm.js:295:28
    Throw();                             // 16                ./test/end-to-end/tests/exceptions.test.mvm.js:295:28
  block50:
    EndTry();                            // 12                ./test/end-to-end/tests/exceptions.test.mvm.js:297:8
    Jump(@block52);                      // 12                ./test/end-to-end/tests/exceptions.test.mvm.js:297:8
  block51:
    Literal(lit undefined);              // 14                ./test/end-to-end/tests/exceptions.test.mvm.js:297:20
    Literal(lit deleted);                // 15 x              ./test/end-to-end/tests/exceptions.test.mvm.js:297:20
    Literal(lit undefined);              // 16                ./test/end-to-end/tests/exceptions.test.mvm.js:298:13
    StoreVar(index 14);                  // 15 x              ./test/end-to-end/tests/exceptions.test.mvm.js:298:13
    Literal(lit undefined);              // 16                ./test/end-to-end/tests/exceptions.test.mvm.js:299:13
    StoreVar(index 13);                  // 15 v6             ./test/end-to-end/tests/exceptions.test.mvm.js:299:13
    LoadVar(index 6);                    // 16 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:300:9
    Literal(lit '_catch1');              // 17                ./test/end-to-end/tests/exceptions.test.mvm.js:300:17
    BinOp(op '+');                       // 16                ./test/end-to-end/tests/exceptions.test.mvm.js:300:17
    LoadVar(index 15);                   // 17                ./test/end-to-end/tests/exceptions.test.mvm.js:300:17
    StoreVar(index 6);                   // 16 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:300:17
    Pop(count 1);                        // 15                ./test/end-to-end/tests/exceptions.test.mvm.js:300:17
    // The break here should pop `x`, `e1`, `b`, and `a` off the stack but
    // not the inner `try` since we're already outside the try block. But it
    // should also pop the outer `catch` since that's still on the stack.
    // The break itself should not pop `i` or `flow`. `i` is popped by the
    // loop exit sequence, which is what we're jumping to with the break.
    Pop(count 3);                        // 12                ./test/end-to-end/tests/exceptions.test.mvm.js:306:9
    EndTry();                            // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:306:9
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:306:9
    Jump(@block55);                      // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:306:9
  // The break here should pop `x`, `e1`, `b`, and `a` off the stack but
  // not the inner `try` since we're already outside the try block. But it
  // should also pop the outer `catch` since that's still on the stack.
  // The break itself should not pop `i` or `flow`. `i` is popped by the
  // loop exit sequence, which is what we're jumping to with the break.
  block52:
    EndTry();                            // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:308:6
    Jump(@block54);                      // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:308:6
  block53:
    Literal(lit undefined);              // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:309:16
    Literal(lit undefined);              // 12                ./test/end-to-end/tests/exceptions.test.mvm.js:310:11
    StoreVar(index 10);                  // 11 v7             ./test/end-to-end/tests/exceptions.test.mvm.js:310:11
    // This should never execute
    LoadVar(index 6);                    // 12 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:312:7
    Literal(lit '_catch2');              // 13                ./test/end-to-end/tests/exceptions.test.mvm.js:312:15
    BinOp(op '+');                       // 12                ./test/end-to-end/tests/exceptions.test.mvm.js:312:15
    LoadVar(index 11);                   // 13                ./test/end-to-end/tests/exceptions.test.mvm.js:312:15
    StoreVar(index 6);                   // 12 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:312:15
    Pop(count 1);                        // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:312:15
    Pop(count 2);                        // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:313:6
    Jump(@block54);                      // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:313:6
  block54:
    Literal(lit undefined);              // 10                ./test/end-to-end/tests/exceptions.test.mvm.js:314:9
    StoreVar(index 5);                   // 9  v8             ./test/end-to-end/tests/exceptions.test.mvm.js:314:9
    // This should execute once
    LoadVar(index 6);                    // 10 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:316:5
    Literal(lit '_loopEnd');             // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:316:13
    BinOp(op '+');                       // 10                ./test/end-to-end/tests/exceptions.test.mvm.js:316:13
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:316:13
    StoreVar(index 6);                   // 10 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:316:13
    Pop(count 1);                        // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:316:13
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:317:4
    LoadVar(index 7);                    // 9  i              ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
    LoadVar(index 8);                    // 10                ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
    Literal(lit 1);                      // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
    BinOp(op '+');                       // 10                ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
    LoadVar(index 9);                    // 11                ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
    StoreVar(index 7);                   // 10 i              ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
    Pop(count 1);                        // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
    Pop(count 1);                        // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
    Jump(@block47);                      // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:274:28
  block55:
    Pop(count 1);                        // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:317:4
    LoadGlobal(name 'assertEqual');      // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:319:3
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/exceptions.test.mvm.js:319:3
    LoadVar(index 6);                    // 10 flow           ./test/end-to-end/tests/exceptions.test.mvm.js:319:15
    Literal(lit 'start_i0_loopEnd_i1_loopEnd_i2_throw_catch1'); // 11  ./test/end-to-end/tests/exceptions.test.mvm.js:319:21
    Call(count 3, true);                 // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:319:21
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:320:2
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:320:2
    Return();                            // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:320:2
}

function test_breakOutOfDoubleCatch() {
  entry:
    Literal(lit deleted);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:322:39
    Literal(lit 'start');                // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:323:14
    StoreVar(index 0);                   // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:323:14
    Literal(lit deleted);                // 2  i              ./test/end-to-end/tests/exceptions.test.mvm.js:324:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:16
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/exceptions.test.mvm.js:324:16
    Jump(@block56);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:16
  block56:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/exceptions.test.mvm.js:324:19
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:23
    Branch(@block57, @block64);          // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:23
  block57:
    LoadVar(index 0);                    // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:325:5
    Literal(lit '_i');                   // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:325:13
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/exceptions.test.mvm.js:325:18
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:325:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:325:18
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:325:18
    StoreVar(index 0);                   // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:325:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:325:18
    StartTry(@block62);                  // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:326:9
    LoadVar(index 0);                    // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:327:7
    Literal(lit '_try');                 // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:327:15
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:327:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:327:15
    StoreVar(index 0);                   // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:327:15
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:327:15
    StartTry(@block60);                  // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:328:11
    LoadVar(index 0);                    // 7  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:329:9
    Literal(lit '_try');                 // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:329:17
    BinOp(op '+');                       // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:329:17
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:329:17
    StoreVar(index 0);                   // 7  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:329:17
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:329:17
    LoadVar(index 1);                    // 7  i              ./test/end-to-end/tests/exceptions.test.mvm.js:330:13
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:330:19
    BinOp(op '===');                     // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:330:19
    Branch(@block58, @block59);          // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:330:13
  block58:
    LoadVar(index 0);                    // 7  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:331:11
    Literal(lit '_throw');               // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:331:19
    BinOp(op '+');                       // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:331:19
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/exceptions.test.mvm.js:331:19
    StoreVar(index 0);                   // 7  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:331:19
    Pop(count 1);                        // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:331:19
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:332:17
    Throw();                             // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:332:17
  block59:
    EndTry();                            // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:334:8
    Jump(@block61);                      // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:334:8
  block60:
    LoadVar(index 0);                    // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:335:9
    Literal(lit '_catch1');              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:335:17
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:335:17
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:335:17
    StoreVar(index 0);                   // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:335:17
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:335:17
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:336:9
    EndTry();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:336:9
    Jump(@block64);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:336:9
  block61:
    EndTry();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:338:6
    Jump(@block63);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:338:6
  block62:
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:338:13
    // Should not get here
    LoadVar(index 0);                    // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:340:7
    Literal(lit '_catch2');              // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:340:15
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:340:15
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:340:15
    StoreVar(index 0);                   // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:340:15
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:340:15
    Jump(@block63);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:341:6
  block63:
    LoadVar(index 0);                    // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:342:5
    Literal(lit '_loopEnd');             // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:342:13
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:342:13
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:342:13
    StoreVar(index 0);                   // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:342:13
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:342:13
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
    StoreVar(index 1);                   // 4  i              ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
    Jump(@block56);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:324:28
  block64:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:343:4
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:345:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:345:3
    LoadVar(index 0);                    // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:345:15
    Literal(lit 'start_i0_try_try_loopEnd_i1_try_try_throw_catch1'); // 5  ./test/end-to-end/tests/exceptions.test.mvm.js:345:21
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:345:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:346:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:346:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:346:2
}

function test_returnFromTry() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:348:1
    Literal(lit &function test_returnFromTry_inner); // 1     ./test/end-to-end/tests/exceptions.test.mvm.js:348:31
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:348:31
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:348:31
    Literal(lit 'start');                // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:349:14
    StoreScoped(index 1);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:349:14
    StartTry(@block67);                  // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:350:7
    LoadVar(index 0);                    // 4  test_returnFromTry_inner ./test/end-to-end/tests/exceptions.test.mvm.js:351:5
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:351:5
    Call(count 1, true);                 // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:351:5
    // The key thing here is that the `return` inside the inner function must
    // have popped exactly one try block off the stack, leaving the outer one.
    // If it fails to EndTry, this throw will be completely broken.
    Literal(lit '_outer_try');           // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:355:11
    Throw();                             // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:355:11
  block67:
    // Should get here
    LoadScoped(index 1);                 // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:358:5
    Literal(lit '_outer_catch');         // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:358:13
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:358:13
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:358:13
    StoreScoped(index 1);                // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:358:13
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:358:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:359:4
    Jump(@block68);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:359:4
  block68:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:361:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:361:3
    LoadScoped(index 1);                 // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:361:15
    Literal(lit 'start_inner_inner_try_return_outer_catch'); // 5  ./test/end-to-end/tests/exceptions.test.mvm.js:361:21
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:361:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:390:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:390:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:390:2
}

function test_returnFromTry_inner() {
  entry:
    ScopePush(count 3);                  // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:363:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:363:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:363:3
    LoadScoped(index 4);                 // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:364:5
    Literal(lit '_inner');               // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:364:13
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:364:13
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:364:13
    StoreScoped(index 4);                // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:364:13
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:364:13
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:365:9
    StoreVar(index 0);                   // 2  a              ./test/end-to-end/tests/exceptions.test.mvm.js:365:9
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:366:9
    StoreScoped(index 1);                // 2  b              ./test/end-to-end/tests/exceptions.test.mvm.js:366:9
    Literal(lit &function anonymous2);   // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:367:5
    StoreScoped(index 0);                // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:367:5
    LoadReg(name 'closure');             // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:367:5
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:367:5
    // Force inner func to be a closure
    // Stack depth 2 (a, c)
    StartTry(@block65);                  // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:369:9
    Literal(lit deleted);                // 5  d              ./test/end-to-end/tests/exceptions.test.mvm.js:369:9
    // Stack depth 4
    LoadScoped(index 4);                 // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:371:7
    Literal(lit '_inner_try');           // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:371:15
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:371:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:371:15
    StoreScoped(index 4);                // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:371:15
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:371:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:372:11
    StoreVar(index 1);                   // 5  c              ./test/end-to-end/tests/exceptions.test.mvm.js:372:11
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:373:11
    StoreVar(index 4);                   // 5  d              ./test/end-to-end/tests/exceptions.test.mvm.js:373:11
    // Stack depth 5
    LoadScoped(index 4);                 // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:375:7
    Literal(lit '_return');              // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:375:15
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:375:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:375:15
    StoreScoped(index 4);                // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:375:15
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:375:15
    // The return statement must emit an EndTry. It does not need to pop `c`,
    // `d`, `a`, or `b` off the stack because the return opcode will do this,
    // but the return opcode does not pop the try. It also does not need to
    // PopScope because this also automatically happens upon a return
    EndTry();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:380:7
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:380:7
    Return();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:380:7
  // The return statement must emit an EndTry. It does not need to pop `c`,
  // `d`, `a`, or `b` off the stack because the return opcode will do this,
  // but the return opcode does not pop the try. It also does not need to
  // PopScope because this also automatically happens upon a return
  block65:
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:381:17
    Literal(lit deleted);                // 5  g              ./test/end-to-end/tests/exceptions.test.mvm.js:381:17
    // Should not get here
    LoadScoped(index 4);                 // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:383:7
    Literal(lit '_inner_catch');         // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:383:15
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:383:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/exceptions.test.mvm.js:383:15
    StoreScoped(index 4);                // 6  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:383:15
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:383:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:384:11
    StoreVar(index 3);                   // 5  f              ./test/end-to-end/tests/exceptions.test.mvm.js:384:11
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:385:11
    StoreVar(index 4);                   // 5  g              ./test/end-to-end/tests/exceptions.test.mvm.js:385:11
    Pop(count 3);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:386:6
    Jump(@block66);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:386:6
  block66:
    // Should not get here
    LoadScoped(index 4);                 // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:388:5
    Literal(lit '_end_inner');           // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:388:13
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:388:13
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:388:13
    StoreScoped(index 4);                // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:388:13
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:388:13
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:389:4
    Return();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:389:4
}

function anonymous2() {
  entry:
    LoadScoped(index 1);                 // 1  b              ./test/end-to-end/tests/exceptions.test.mvm.js:367:11
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:367:11
}

function test_returnInsideNestedTry() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:392:1
    Literal(lit &function inner);        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:392:39
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:392:39
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:392:39
    Literal(lit 'start');                // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:393:14
    StoreScoped(index 1);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:393:14
    StartTry(@block73);                  // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:394:7
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/exceptions.test.mvm.js:394:7
    LoadScoped(index 1);                 // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:395:5
    Literal(lit '_try1');                // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:395:13
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:395:13
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:395:13
    StoreScoped(index 1);                // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:395:13
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:395:13
    LoadVar(index 0);                    // 5  inner          ./test/end-to-end/tests/exceptions.test.mvm.js:396:20
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:396:20
    Call(count 1, true);                 // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:396:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/exceptions.test.mvm.js:396:20
    LoadScoped(index 1);                 // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:397:5
    LoadVar(index 3);                    // 6  result         ./test/end-to-end/tests/exceptions.test.mvm.js:397:13
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:397:13
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:397:13
    StoreScoped(index 1);                // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:397:13
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:397:13
    Literal(lit '_thrown');              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:398:11
    Throw();                             // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:398:11
  block73:
    LoadScoped(index 1);                 // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:400:5
    Literal(lit '_catch1');              // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:400:13
    LoadVar(index 1);                    // 5  e              ./test/end-to-end/tests/exceptions.test.mvm.js:400:25
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:400:25
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:400:25
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:400:25
    StoreScoped(index 1);                // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:400:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:400:25
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:401:4
    Jump(@block74);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:401:4
  block74:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:403:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:403:3
    LoadScoped(index 1);                 // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:403:15
    Literal(lit 'start_try1_inner_try2_try3_value_catch1_thrown'); // 5  ./test/end-to-end/tests/exceptions.test.mvm.js:403:21
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:403:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:420:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:420:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:420:2
}

function inner() {
  entry:
    LoadScoped(index 1);                 // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:406:5
    Literal(lit '_inner');               // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:406:13
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:406:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:406:13
    StoreScoped(index 1);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:406:13
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:406:13
    StartTry(@block71);                  // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:407:9
    LoadScoped(index 1);                 // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:408:7
    Literal(lit '_try2');                // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:408:15
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:408:15
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:408:15
    StoreScoped(index 1);                // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:408:15
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:408:15
    StartTry(@block69);                  // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:409:11
    LoadScoped(index 1);                 // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:410:9
    Literal(lit '_try3');                // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:410:17
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:410:17
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:410:17
    StoreScoped(index 1);                // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:410:17
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:410:17
    EndTry();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:411:9
    EndTry();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:411:9
    Literal(lit '_value');               // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:411:16
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:411:16
  block69:
    LoadScoped(index 1);                 // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:413:9
    Literal(lit '_catch3');              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:413:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:413:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:413:17
    StoreScoped(index 1);                // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:413:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:413:17
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:414:8
    Jump(@block70);                      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:414:8
  block70:
    EndTry();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:415:6
    Jump(@block72);                      // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:415:6
  block71:
    LoadScoped(index 1);                 // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:416:7
    Literal(lit '_catch2');              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:416:15
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:416:15
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:416:15
    StoreScoped(index 1);                // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:416:15
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:416:15
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:417:6
    Jump(@block72);                      // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:417:6
  block72:
    LoadScoped(index 1);                 // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:418:5
    Literal(lit 'end');                  // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:418:13
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:418:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:418:13
    StoreScoped(index 1);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:418:13
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:418:13
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:419:4
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:419:4
}

function test_returnInsideNestedCatch() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:422:1
    Literal(lit &function inner1);       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:422:41
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:422:41
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:422:41
    Literal(lit 'start');                // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:423:14
    StoreScoped(index 1);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:423:14
    StartTry(@block79);                  // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:424:7
    Literal(lit deleted);                // 4  result         ./test/end-to-end/tests/exceptions.test.mvm.js:424:7
    LoadScoped(index 1);                 // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:425:5
    Literal(lit '_try1');                // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:425:13
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:425:13
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:425:13
    StoreScoped(index 1);                // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:425:13
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:425:13
    LoadVar(index 0);                    // 5  inner          ./test/end-to-end/tests/exceptions.test.mvm.js:426:20
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:426:20
    Call(count 1, true);                 // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:426:20
    StoreVar(index 3);                   // 4  result         ./test/end-to-end/tests/exceptions.test.mvm.js:426:20
    LoadScoped(index 1);                 // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:427:5
    LoadVar(index 3);                    // 6  result         ./test/end-to-end/tests/exceptions.test.mvm.js:427:13
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:427:13
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/exceptions.test.mvm.js:427:13
    StoreScoped(index 1);                // 5  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:427:13
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:427:13
    Literal(lit '_throw1');              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:428:11
    Throw();                             // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:428:11
  block79:
    LoadScoped(index 1);                 // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:430:5
    LoadVar(index 1);                    // 4  e1             ./test/end-to-end/tests/exceptions.test.mvm.js:430:13
    Literal(lit '_catch1');              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:430:18
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:430:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:430:18
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:430:18
    StoreScoped(index 1);                // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:430:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:430:18
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:431:4
    Jump(@block80);                      // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:431:4
  block80:
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:432:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:432:3
    LoadScoped(index 1);                 // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:432:15
    Literal(lit 'start_try1_inner_try2_throw2_catch2_try3_throw3_catch3_value_throw1_catch1'); // 5  ./test/end-to-end/tests/exceptions.test.mvm.js:432:21
    Call(count 3, true);                 // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:432:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:452:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:452:2
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:452:2
}

function inner1() {
  entry:
    LoadScoped(index 1);                 // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:435:5
    Literal(lit '_inner');               // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:435:13
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:435:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:435:13
    StoreScoped(index 1);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:435:13
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:435:13
    StartTry(@block75);                  // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:436:9
    LoadScoped(index 1);                 // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:437:7
    Literal(lit '_try2');                // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:437:15
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:437:15
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:437:15
    StoreScoped(index 1);                // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:437:15
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:437:15
    Literal(lit '_throw2');              // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:438:13
    Throw();                             // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:438:13
  block75:
    LoadScoped(index 1);                 // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:440:7
    LoadVar(index 0);                    // 3  e2             ./test/end-to-end/tests/exceptions.test.mvm.js:440:15
    Literal(lit '_catch2');              // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:440:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:440:20
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:440:20
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:440:20
    StoreScoped(index 1);                // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:440:20
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:440:20
    StartTry(@block76);                  // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:441:11
    LoadScoped(index 1);                 // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:442:9
    Literal(lit '_try3');                // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:442:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:442:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:442:17
    StoreScoped(index 1);                // 4  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:442:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:442:17
    Literal(lit '_throw3');              // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:443:15
    Throw();                             // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:443:15
  block76:
    LoadScoped(index 1);                 // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:445:9
    LoadVar(index 1);                    // 4  e3             ./test/end-to-end/tests/exceptions.test.mvm.js:445:17
    Literal(lit '_catch3');              // 5                 ./test/end-to-end/tests/exceptions.test.mvm.js:445:22
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:445:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:445:22
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/exceptions.test.mvm.js:445:22
    StoreScoped(index 1);                // 3  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:445:22
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:445:22
    Literal(lit '_value');               // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:446:16
    Return();                            // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:446:16
  block77:
    LoadScoped(index 1);                 // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:448:7
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:448:15
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:448:15
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/exceptions.test.mvm.js:448:15
    StoreScoped(index 1);                // 2  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:448:15
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:448:15
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:449:6
    Jump(@block78);                      // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:449:6
  block78:
    LoadScoped(index 1);                 // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:450:5
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:450:13
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:450:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/exceptions.test.mvm.js:450:13
    StoreScoped(index 1);                // 1  flow           ./test/end-to-end/tests/exceptions.test.mvm.js:450:13
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:450:13
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/exceptions.test.mvm.js:451:4
    Return();                            // 0                 ./test/end-to-end/tests/exceptions.test.mvm.js:451:4
}