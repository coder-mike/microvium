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
    // ---
    // description: >
    // Tests various operations that should classify as vm_TeNumberOp operations
    // runExportedFunction: 0
    // assertionCount: 122
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/number-operations.test.mvm.js:7:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:1
    Return();                            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:1
}

function run() {
  entry:
    LoadGlobal(name 'testNegate');       // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:10:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:10:3
    LoadGlobal(name 'testUnaryPlus');    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:11:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:11:3
    LoadGlobal(name 'testAddition');     // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:12:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:12:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:12:3
    LoadGlobal(name 'testSubtraction');  // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:13:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:13:3
    LoadGlobal(name 'testMultiplication'); // 1               ./test/end-to-end/tests/number-operations.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:14:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:14:3
    LoadGlobal(name 'testDivision');     // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:15:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:15:3
    LoadGlobal(name 'testLessThan');     // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:16:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:16:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:16:3
    LoadGlobal(name 'testGreaterThan');  // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:17:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:17:3
    LoadGlobal(name 'testRemainder');    // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:18:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:18:3
    LoadGlobal(name 'testPower');        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:19:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:19:3
    LoadGlobal(name 'testIncrDecr');     // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:20:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:20:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:20:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:2
}

function testNegate() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:19
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:23
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:3
    LoadGlobal(name 'Infinity');         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:16
    UnOp(op '-');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:16
    Literal(lit -1.1);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:26
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:33
    BinOp(op '/');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:25:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:3
    Literal(lit -2147483648);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:17
    UnOp(op '-');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:17
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:31
    Branch(@block1, @block2);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:31
  block1:
    Literal(lit 2147483648);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:48
    Jump(@block3);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:48
  block2:
    Literal(lit -2147483648);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:61
    Jump(@block3);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:61
  block3:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:26:61
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:2
}

function testUnaryPlus() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:21
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:21
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:23
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:23
    Literal(lit 3.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:31:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:32:2
}

function testAddition() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:19
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:19
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:15
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:23
    Literal(lit 5000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:36:30
    // out of 8 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:15
    Literal(lit 3500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:23
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:37:30
    // 12 bit addition (should not overflow, but should take the fast path still)
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:3
    Literal(lit 6000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:15
    Literal(lit 500);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:23
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:28
    // 13 bit addition. Does not technically overflow but should take the slow path
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:3
    Literal(lit 500);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:15
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:21
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:28
    // 13 bit addition. Does not technically overflow but should take the slow path
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:3
    Literal(lit 10000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:15
    Literal(lit 8000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:24
    Literal(lit 18000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:31
    // out of 14 bit signed range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:3
    Literal(lit 80000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:15
    Literal(lit 70000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:24
    Literal(lit 150000);                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:32
    // out of 16 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:3
    Literal(lit 7500);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:15
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:23
    Literal(lit 14500);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:30
    // overflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:3
    Literal(lit 2000000000);             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:15
    Literal(lit 2000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:31
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:31
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:46
    Branch(@block4, @block5);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:46
  block4:
    Literal(lit 4000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:63
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:63
  block5:
    Literal(lit -294967296);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:79
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:79
  block6:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:79
    // overflow signed 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:3
    Literal(lit -1.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:22
    Literal(lit -0.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:15
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:20
    Literal(lit -1.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:3
    Literal(lit -5000000000);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:15
    Literal(lit 4999999000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:32
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:32
    Literal(lit -1000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:47
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:47
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:2
}

function testSubtraction() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:19
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:15
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:23
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:23
    Literal(lit 1000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:51:30
    // out of 8 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:3
    Literal(lit 10000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:15
    Literal(lit 8000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:24
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:52:31
    // out of 14 bit signed range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:3
    Literal(lit 80000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:15
    Literal(lit 70000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:24
    Literal(lit 10000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:32
    // out of 16 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:3
    Literal(lit -7500);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:15
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:24
    Literal(lit -14500);                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:31
    // underflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:3
    Literal(lit -2000000000);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:15
    Literal(lit 2000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:32
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:32
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:47
    Branch(@block7, @block8);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:47
  block7:
    Literal(lit -4000000000);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:64
    Jump(@block9);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:64
  block8:
    Literal(lit 294967296);              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:81
    Jump(@block9);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:81
  block9:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:81
    // underflow signed 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:3
    Literal(lit 1.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:21
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:21
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:15
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:19
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:19
    Literal(lit 1.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:3
    Literal(lit 5000000000);             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:15
    Literal(lit 4999999000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:31
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:31
    Literal(lit 1000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:46
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:46
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:2
}

function testMultiplication() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:19
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:19
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:3
    Literal(lit 5.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:21
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:21
    Literal(lit 33);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:63:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:3
    Literal(lit -5);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:16
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:23
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:64:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:15
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:20
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:20
    Literal(lit -30);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:3
    Literal(lit 5000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:15
    Literal(lit 5000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:23
    Literal(lit 25000000);               // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:30
    // Overflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:3
    Literal(lit 17000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:24
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:24
    Literal(lit 34000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:3
    Literal(lit 5000000);                // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:15
    Literal(lit 5000000);                // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:27
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:27
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:38
    Branch(@block10, @block11);          // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:38
  block10:
    Literal(lit 25000000000000);         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:55
    Jump(@block12);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:55
  block11:
    Literal(lit -1004630016);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:76
    Jump(@block12);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:76
  block12:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:69:76
    // Overflow 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:3
    Literal(lit 25000000000000);         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:36
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:36
    Literal(lit 25000000000000);         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:39
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:39
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:2
}

function testDivision() {
  entry:
    // Floating point division (the normal)
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:75:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:75:3
    Literal(lit 6);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:75:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:75:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:75:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:75:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:75:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:3
    Literal(lit 7);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:19
    Literal(lit 3.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:76:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:3
    Literal(lit 8.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:15
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:21
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:21
    Literal(lit 3.4);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:77:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:19
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:19
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:24
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:24
    // Without overflow checks enabled, the negation of integer zero is integer zero
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:21
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:23
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:23
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:23
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:23
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:27
    Branch(@block13, @block14);          // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:27
  block13:
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:45
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:45
    Jump(@block15);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:45
  block14:
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:56
    Jump(@block15);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:56
  block15:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:56
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:20
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:20
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:24
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:20
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:20
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:83:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:10
    LoadGlobal(name 'Infinity');         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:23
    LoadGlobal(name 'Infinity');         // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:34
    BinOp(op '/');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:34
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:34
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:34
    // Integer division
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:3
    Literal(lit 6);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:3
    Literal(lit 7);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:19
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:88:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:3
    Literal(lit 8.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:16
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:22
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:22
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:89:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:3
    Literal(lit -6);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:20
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:3
    Literal(lit -7);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:20
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:3
    Literal(lit -8.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:16
    Literal(lit -2.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:23
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:23
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:3
    Literal(lit -6);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:3
    Literal(lit -7);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:20
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:3
    Literal(lit -8.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:16
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:23
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:23
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:3
    LoadGlobal(name 'NaN');              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:15
    LoadGlobal(name 'NaN');              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:21
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:21
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:3
    LoadGlobal(name 'Infinity');         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:15
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:26
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:26
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:40
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:40
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:2
}

function testLessThan() {
  entry:
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:106:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:106:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:106:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:106:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:106:19
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:106:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:106:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:107:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:108:22
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:112:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:113:24
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:117:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:118:26
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:122:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:123:23
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:127:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:128:25
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:22
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:132:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:133:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:2
}

function testGreaterThan() {
  entry:
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:138:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:138:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:138:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:138:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:138:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:138:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:138:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:19
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:139:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:140:22
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:144:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:145:24
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:149:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:150:26
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:154:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:155:23
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:159:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:160:25
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:22
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:164:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:165:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:2
}

function testRemainder() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:170:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:3
    Literal(lit 550);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:15
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:21
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:21
    Literal(lit 50);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:171:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:20
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:20
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:175:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:3
    Literal(lit 2.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:22
    Literal(lit 0.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:3
    Literal(lit 5.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:22
    Literal(lit 1.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:3
    Literal(lit 550.25);                 // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:15
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:24
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:24
    Literal(lit 50.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:179:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:3
    Literal(lit -7.25);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:23
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:23
    Literal(lit -3.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:3
    Literal(lit 7.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:15
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:22
    Literal(lit 3.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:3
    Literal(lit -7.25);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:15
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:23
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:23
    Literal(lit -3.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:183:27
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:10
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:23
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:27
    BinOp(op '%');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:27
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:27
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:27
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:10
    Literal(lit 5.1);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:23
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:29
    BinOp(op '%');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:29
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:29
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:29
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:187:2
}

function testPower() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:20
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:20
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:20
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:20
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:191:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:3
    Literal(lit 2.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:22
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:22
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:192:25
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:10
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:23
    LoadGlobal(name 'Infinity');         // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:28
    BinOp(op '**');                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:28
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:28
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:28
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:2
}

function testIncrDecr() {
  entry:
    Literal(lit deleted);                // 1  x              ./test/end-to-end/tests/number-operations.test.mvm.js:196:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:197:11
    StoreVar(index 0);                   // 1  x              ./test/end-to-end/tests/number-operations.test.mvm.js:197:11
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:198:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:15
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:15
    StoreVar(index 0);                   // 5  x              ./test/end-to-end/tests/number-operations.test.mvm.js:198:15
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:198:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:199:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:199:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:200:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:15
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:200:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    BinOp(op '-');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    StoreVar(index 0);                   // 5  x              ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:204:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:15
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:204:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:18
    Literal(lit 1.5);                    // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:7
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:7
    StoreVar(index 0);                   // 2  x              ./test/end-to-end/tests/number-operations.test.mvm.js:207:7
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:7
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:208:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:15
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:208:15
    Literal(lit 2.5);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:209:15
    Literal(lit 1.5);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:209:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:2
}