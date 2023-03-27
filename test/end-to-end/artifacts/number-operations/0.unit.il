unit ['./test/end-to-end/tests/number-operations.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external Infinity from free-variable 'Infinity';
external overflowChecks from free-variable 'overflowChecks';
external assert from free-variable 'assert';
external Number from free-variable 'Number';
external NaN from free-variable 'NaN';

global thisModule;
global testNegate;
global testUnaryPlus;
global testAddition;
global testSubtraction;
global testMultiplication;
global testDivision;
global testLessThan;
global testGreaterThan;
global testRemainder;
global testPower;
global testIncrDecr;
global testStringToInt;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testNegate);   // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testNegate');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testUnaryPlus); // 2                ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testUnaryPlus');   // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testAddition); // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testAddition');    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testSubtraction); // 2              ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testSubtraction'); // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testMultiplication); // 2           ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testMultiplication'); // 1              ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testDivision); // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testDivision');    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testLessThan); // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testLessThan');    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testGreaterThan); // 2              ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testGreaterThan'); // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testRemainder); // 2                ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testRemainder');   // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testPower);    // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testPower');       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testIncrDecr); // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testIncrDecr');    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testStringToInt); // 2              ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testStringToInt'); // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    // ---
    // description: >
    // Tests various operations that should classify as vm_TeNumberOp operations
    // runExportedFunction: 0
    // assertionCount: 138
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/number-operations.test.mvm.js:7:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:213:1
    Return();                            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:213:1
}

function run() {
  entry:
    LoadGlobal(name 'testNegate');       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:10:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:10:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:10:3
    LoadGlobal(name 'testUnaryPlus');    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:11:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:11:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:11:3
    LoadGlobal(name 'testAddition');     // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:12:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:12:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:12:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:12:3
    LoadGlobal(name 'testSubtraction');  // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:13:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:13:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:13:3
    LoadGlobal(name 'testMultiplication'); // 1               ./test/end-to-end/tests/number-operations.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:14:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:14:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:14:3
    LoadGlobal(name 'testDivision');     // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:15:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:15:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:15:3
    LoadGlobal(name 'testLessThan');     // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:16:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:16:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:16:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:16:3
    LoadGlobal(name 'testGreaterThan');  // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:17:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:17:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:17:3
    LoadGlobal(name 'testRemainder');    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:18:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:18:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:18:3
    LoadGlobal(name 'testPower');        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:19:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:19:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:19:3
    LoadGlobal(name 'testIncrDecr');     // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:20:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:20:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:20:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:20:3
    LoadGlobal(name 'testStringToInt');  // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:22:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:22:2
}

function testNegate() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:19
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:23
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:3
    LoadGlobal(name 'Infinity');         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:16
    UnOp(op '-');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:16
    Literal(lit -1.1);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:26
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:33
    BinOp(op '/');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:33
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:33
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:3
    Literal(lit -2147483648);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:17
    UnOp(op '-');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:17
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:31
    Branch(@block1, @block2);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:31
  block1:
    Literal(lit 2147483648);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:48
    Jump(@block3);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:48
  block2:
    Literal(lit -2147483648);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:61
    Jump(@block3);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:61
  block3:
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:61
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:61
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:2
}

function testUnaryPlus() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:21
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:21
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:23
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:23
    Literal(lit 3.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:2
}

function testAddition() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:19
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:19
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:15
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:23
    Literal(lit 5000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:30
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:30
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:30
    // out of 8 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:15
    Literal(lit 3500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:23
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:30
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:30
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:30
    // 12 bit addition (should not overflow, but should take the fast path still)
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:3
    Literal(lit 6000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:15
    Literal(lit 500);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:23
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:28
    // 13 bit addition. Does not technically overflow but should take the slow path
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:3
    Literal(lit 500);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:15
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:21
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:28
    // 13 bit addition. Does not technically overflow but should take the slow path
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:3
    Literal(lit 10000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:15
    Literal(lit 8000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:24
    Literal(lit 18000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:31
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:31
    // out of 14 bit signed range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:3
    Literal(lit 80000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:15
    Literal(lit 70000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:24
    Literal(lit 150000);                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:32
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:32
    // out of 16 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:3
    Literal(lit 7500);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:15
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:23
    Literal(lit 14500);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:30
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:30
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:30
    // overflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:3
    Literal(lit 2000000000);             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:15
    Literal(lit 2000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:31
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:31
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:46
    Branch(@block4, @block5);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:46
  block4:
    Literal(lit 4000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:63
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:63
  block5:
    Literal(lit -294967296);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:79
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:79
  block6:
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:79
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:79
    // overflow signed 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:3
    Literal(lit -1.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:22
    Literal(lit -0.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:15
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:20
    Literal(lit -1.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:3
    Literal(lit -5000000000);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:15
    Literal(lit 4999999000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:32
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:32
    Literal(lit -1000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:47
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:47
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:47
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:2
}

function testSubtraction() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:19
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:15
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:23
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:23
    Literal(lit 1000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:30
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:30
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:30
    // out of 8 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:3
    Literal(lit 10000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:15
    Literal(lit 8000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:24
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:31
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:31
    // out of 14 bit signed range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:3
    Literal(lit 80000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:15
    Literal(lit 70000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:24
    Literal(lit 10000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:32
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:32
    // out of 16 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:3
    Literal(lit -7500);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:15
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:24
    Literal(lit -14500);                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:31
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:31
    // underflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:3
    Literal(lit -2000000000);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:15
    Literal(lit 2000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:32
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:32
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:47
    Branch(@block7, @block8);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:47
  block7:
    Literal(lit -4000000000);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:64
    Jump(@block9);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:64
  block8:
    Literal(lit 294967296);              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:81
    Jump(@block9);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:81
  block9:
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:81
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:81
    // underflow signed 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:3
    Literal(lit 1.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:21
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:21
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:15
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:19
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:19
    Literal(lit 1.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:3
    Literal(lit 5000000000);             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:15
    Literal(lit 4999999000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:31
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:31
    Literal(lit 1000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:46
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:46
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:46
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:2
}

function testMultiplication() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:19
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:19
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:3
    Literal(lit 5.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:21
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:21
    Literal(lit 33);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:3
    Literal(lit -5);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:16
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:23
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:15
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:20
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:20
    Literal(lit -30);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:3
    Literal(lit 5000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:15
    Literal(lit 5000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:23
    Literal(lit 25000000);               // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:30
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:30
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:30
    // Overflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:3
    Literal(lit 17000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:24
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:24
    Literal(lit 34000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:3
    Literal(lit 5000000);                // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:15
    Literal(lit 5000000);                // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:27
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:27
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:38
    Branch(@block10, @block11);          // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:38
  block10:
    Literal(lit 25000000000000);         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:55
    Jump(@block12);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:55
  block11:
    Literal(lit -1004630016);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:76
    Jump(@block12);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:76
  block12:
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:76
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:76
    // Overflow 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:3
    Literal(lit 25000000000000);         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:36
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:36
    Literal(lit 25000000000000);         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:39
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:39
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:39
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:2
}

function testDivision() {
  entry:
    // Floating point division (the normal)
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:3
    Literal(lit 6);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:3
    Literal(lit 7);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:19
    Literal(lit 3.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:3
    Literal(lit 8.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:15
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:21
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:21
    Literal(lit 3.4);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:19
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:19
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:24
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:24
    // Without overflow checks enabled, the negation of integer zero is integer zero
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:21
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:23
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:23
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:23
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:23
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:27
    Branch(@block13, @block14);          // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:27
  block13:
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:45
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:45
    Jump(@block15);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:45
  block14:
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:56
    Jump(@block15);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:56
  block15:
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:56
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:56
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:20
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:20
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:24
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:20
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:20
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:10
    LoadGlobal(name 'Infinity');         // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:23
    LoadGlobal(name 'Infinity');         // 7                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:34
    BinOp(op '/');                       // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:34
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:34
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:34
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:34
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:34
    // Integer division
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:3
    Literal(lit 6);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:3
    Literal(lit 7);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:19
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:3
    Literal(lit 8.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:16
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:22
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:22
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:32
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:3
    Literal(lit -6);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:20
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:3
    Literal(lit -7);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:20
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:3
    Literal(lit -8.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:16
    Literal(lit -2.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:23
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:23
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:34
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:34
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:3
    Literal(lit -6);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:3
    Literal(lit -7);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:20
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:3
    Literal(lit -8.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:16
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:23
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:23
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:33
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:33
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:3
    LoadGlobal(name 'NaN');              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:15
    LoadGlobal(name 'NaN');              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:21
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:21
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:30
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:30
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:3
    LoadGlobal(name 'Infinity');         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:15
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:26
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:26
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:40
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:40
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:40
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:2
}

function testLessThan() {
  entry:
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:19
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:22
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:24
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:26
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:23
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:25
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:22
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:2
}

function testGreaterThan() {
  entry:
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:19
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:22
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:24
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:26
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:23
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:25
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:22
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:2
}

function testRemainder() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:3
    Literal(lit 550);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:15
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:21
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:21
    Literal(lit 50);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:20
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:20
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:3
    Literal(lit 2.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:22
    Literal(lit 0.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:3
    Literal(lit 5.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:22
    Literal(lit 1.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:3
    Literal(lit 550.25);                 // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:15
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:24
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:24
    Literal(lit 50.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:29
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:3
    Literal(lit -7.25);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:23
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:23
    Literal(lit -3.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:3
    Literal(lit 7.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:15
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:22
    Literal(lit 3.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:3
    Literal(lit -7.25);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:15
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:23
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:23
    Literal(lit -3.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:27
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:23
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:27
    BinOp(op '%');                       // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:27
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:27
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:27
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:27
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:10
    Literal(lit 5.1);                    // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:23
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:29
    BinOp(op '%');                       // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:29
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:29
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:29
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:29
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:2
}

function testPower() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:20
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:20
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:20
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:20
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:3
    Literal(lit 2.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:22
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:22
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:25
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:10
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:23
    LoadGlobal(name 'Infinity');         // 7                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:28
    BinOp(op '**');                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:28
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:28
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:28
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:28
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:2
}

function testIncrDecr() {
  entry:
    Literal(lit deleted);                // 1  x              ./test/end-to-end/tests/number-operations.test.mvm.js:197:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:11
    StoreVar(index 0);                   // 1  x              ./test/end-to-end/tests/number-operations.test.mvm.js:198:11
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:199:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:15
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:15
    StoreVar(index 0);                   // 5  x              ./test/end-to-end/tests/number-operations.test.mvm.js:199:15
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:20
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:20
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:200:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:18
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:18
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:20
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:20
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:18
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:18
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    BinOp(op '-');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    StoreVar(index 0);                   // 5  x              ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:20
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:20
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:204:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:18
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:18
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:20
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:20
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:206:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:18
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:18
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:18
    Literal(lit 1.5);                    // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:7
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:7
    StoreVar(index 0);                   // 2  x              ./test/end-to-end/tests/number-operations.test.mvm.js:208:7
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:7
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    Literal(lit 2.5);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:20
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:20
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:210:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:15
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:210:15
    Literal(lit 1.5);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:20
    Call(count 3);                       // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:20
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:2
}

function testStringToInt() {
  entry:
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:10
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:24
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:24
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:214:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:10
    Literal(lit 'length');               // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:24
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:24
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:215:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    Literal(lit '__proto__');            // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    Literal(lit '1a');                   // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    Literal(lit '1.1.1');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    Literal(lit '123456789123456789.1.1'); // 6               ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    Literal(lit '123\u0000');            // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    Call(count 2);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    Call(count 2);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    // Empty string
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:223:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:223:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:223:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:223:16
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:223:20
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:223:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:223:20
    // Whitespace
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:226:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:226:3
    Literal(lit '  ');                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:226:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:226:16
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:226:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:226:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:226:22
    // Small integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:229:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:229:3
    Literal(lit '123');                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:229:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:229:16
    Literal(lit 123);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:229:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:229:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:229:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:230:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:230:3
    Literal(lit '-123');                 // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:230:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:230:16
    Literal(lit -123);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:230:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:230:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:230:24
    // Leading and trailing whitespace
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:233:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:233:3
    Literal(lit '  123   ');             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:233:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:233:16
    Literal(lit 123);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:233:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:233:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:233:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:234:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:234:3
    Literal(lit '  -123   ');            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:234:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:234:16
    Literal(lit -123);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:234:29
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:234:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:234:29
    // Int32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:237:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:237:3
    Literal(lit '12345678');             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:237:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:237:16
    Literal(lit 12345678);               // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:237:28
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:237:28
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:237:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:238:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:238:3
    Literal(lit '-12345678');            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:238:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:238:16
    Literal(lit -12345678);              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:238:29
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:238:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:238:29
    // Multiply
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:241:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:241:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:241:15
    Literal(lit '123');                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:241:19
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:241:19
    Literal(lit 123);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:241:26
    Call(count 3);                       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:241:26
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:241:26
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:242:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:242:2
}