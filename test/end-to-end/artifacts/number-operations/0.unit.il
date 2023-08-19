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
global testIntToString;
global testFloatToString;

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
    Literal(lit &function testIntToString); // 2              ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testIntToString'); // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    Literal(lit &function testFloatToString); // 2            ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    StoreGlobal(name 'testFloatToString'); // 1               ./test/end-to-end/tests/number-operations.test.mvm.js:1:1
    // ---
    // description: >
    // Tests various operations that should classify as vm_TeNumberOp operations
    // runExportedFunction: 0
    // assertionCount: 153
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/number-operations.test.mvm.js:7:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:7:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:254:1
    Return();                            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:254:1
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
    LoadGlobal(name 'testStringToInt');  // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:21:3
    LoadGlobal(name 'testIntToString');  // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:22:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:22:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:22:3
    LoadGlobal(name 'testFloatToString'); // 1                ./test/end-to-end/tests/number-operations.test.mvm.js:23:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:23:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:23:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:24:2
}

function testNegate() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:19
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:23
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:27:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:3
    LoadGlobal(name 'Infinity');         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:16
    UnOp(op '-');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:16
    Literal(lit -1.1);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:26
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:33
    BinOp(op '/');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:28:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:3
    Literal(lit -2147483648);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:17
    UnOp(op '-');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:17
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:31
    Branch(@block1, @block2);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:31
  block1:
    Literal(lit 2147483648);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:48
    Jump(@block3);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:48
  block2:
    Literal(lit -2147483648);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:61
    Jump(@block3);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:61
  block3:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:29:61
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:30:2
}

function testUnaryPlus() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:21
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:21
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:33:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:34:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:34:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:34:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:34:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:34:23
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:34:23
    Literal(lit 3.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:34:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:34:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:35:2
}

function testAddition() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:19
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:19
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:38:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:15
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:23
    Literal(lit 5000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:39:30
    // out of 8 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:15
    Literal(lit 3500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:23
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:40:30
    // 12 bit addition (should not overflow, but should take the fast path still)
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:3
    Literal(lit 6000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:15
    Literal(lit 500);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:23
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:41:28
    // 13 bit addition. Does not technically overflow but should take the slow path
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:3
    Literal(lit 500);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:15
    Literal(lit 6500);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:21
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:42:28
    // 13 bit addition. Does not technically overflow but should take the slow path
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:3
    Literal(lit 10000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:15
    Literal(lit 8000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:24
    Literal(lit 18000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:43:31
    // out of 14 bit signed range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:3
    Literal(lit 80000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:15
    Literal(lit 70000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:24
    Literal(lit 150000);                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:44:32
    // out of 16 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:3
    Literal(lit 7500);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:15
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:23
    Literal(lit 14500);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:45:30
    // overflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:3
    Literal(lit 2000000000);             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:15
    Literal(lit 2000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:31
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:31
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:46
    Branch(@block4, @block5);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:46
  block4:
    Literal(lit 4000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:63
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:63
  block5:
    Literal(lit -294967296);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:79
    Jump(@block6);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:79
  block6:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:46:79
    // overflow signed 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:3
    Literal(lit -1.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:22
    Literal(lit -0.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:47:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:15
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:20
    Literal(lit -1.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:48:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:49:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:49:3
    Literal(lit -5000000000);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:49:15
    Literal(lit 4999999000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:49:32
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:49:32
    Literal(lit -1000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:49:47
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:49:47
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:50:2
}

function testSubtraction() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:19
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:53:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:3
    Literal(lit 3000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:15
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:23
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:23
    Literal(lit 1000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:54:30
    // out of 8 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:3
    Literal(lit 10000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:15
    Literal(lit 8000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:24
    Literal(lit 2000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:55:31
    // out of 14 bit signed range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:3
    Literal(lit 80000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:15
    Literal(lit 70000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:24
    Literal(lit 10000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:56:32
    // out of 16 bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:3
    Literal(lit -7500);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:15
    Literal(lit 7000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:24
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:24
    Literal(lit -14500);                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:57:31
    // underflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:3
    Literal(lit -2000000000);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:15
    Literal(lit 2000000000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:32
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:32
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:47
    Branch(@block7, @block8);            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:47
  block7:
    Literal(lit -4000000000);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:64
    Jump(@block9);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:64
  block8:
    Literal(lit 294967296);              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:81
    Jump(@block9);                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:81
  block9:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:58:81
    // underflow signed 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:3
    Literal(lit 1.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:21
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:21
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:59:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:15
    Literal(lit 0.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:19
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:19
    Literal(lit 1.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:60:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:61:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:61:3
    Literal(lit 5000000000);             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:61:15
    Literal(lit 4999999000);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:61:31
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:61:31
    Literal(lit 1000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:61:46
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:61:46
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:62:2
}

function testMultiplication() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:19
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:19
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:65:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:3
    Literal(lit 5.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:21
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:21
    Literal(lit 33);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:66:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:3
    Literal(lit -5);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:16
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:23
    Literal(lit 30);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:67:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:15
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:20
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:20
    Literal(lit -30);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:68:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:3
    Literal(lit 5000);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:15
    Literal(lit 5000);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:23
    Literal(lit 25000000);               // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:70:30
    // Overflow 14-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:3
    Literal(lit 17000);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:24
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:24
    Literal(lit 34000);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:71:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:3
    Literal(lit 5000000);                // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:15
    Literal(lit 5000000);                // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:27
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:27
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:38
    Branch(@block10, @block11);          // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:38
  block10:
    Literal(lit 25000000000000);         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:55
    Jump(@block12);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:55
  block11:
    Literal(lit -1004630016);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:76
    Jump(@block12);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:76
  block12:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:72:76
    // Overflow 32-bit range
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:73:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:73:3
    Literal(lit 25000000000000);         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:73:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:73:36
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:73:36
    Literal(lit 25000000000000);         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:73:39
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:73:39
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:74:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:74:2
}

function testDivision() {
  entry:
    // Floating point division (the normal)
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:3
    Literal(lit 6);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:78:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:3
    Literal(lit 7);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:19
    Literal(lit 3.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:79:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:3
    Literal(lit 8.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:15
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:21
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:21
    Literal(lit 3.4);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:80:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:19
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:81:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:19
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:19
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:24
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:82:24
    // Without overflow checks enabled, the negation of integer zero is integer zero
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:21
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:23
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:23
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:23
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:23
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:27
    Branch(@block13, @block14);          // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:27
  block13:
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:45
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:45
    Jump(@block15);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:45
  block14:
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:56
    Jump(@block15);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:56
  block15:
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:84:56
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:20
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:20
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:24
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:85:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:86:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:86:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:86:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:86:20
    BinOp(op '/');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:86:20
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:86:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:86:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:10
    LoadGlobal(name 'Infinity');         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:23
    LoadGlobal(name 'Infinity');         // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:34
    BinOp(op '/');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:34
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:34
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:87:34
    // Integer division
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:3
    Literal(lit 6);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:90:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:3
    Literal(lit 7);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:19
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:91:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:3
    Literal(lit 8.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:16
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:22
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:22
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:92:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:3
    Literal(lit -6);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:20
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:93:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:3
    Literal(lit -7);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:20
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:94:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:3
    Literal(lit -8.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:16
    Literal(lit -2.5);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:23
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:23
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:95:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:3
    Literal(lit -6);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:96:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:3
    Literal(lit -7);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:20
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:97:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:3
    Literal(lit -8.5);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:16
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:23
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:23
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:98:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:99:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:19
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:100:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:101:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:20
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:102:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:3
    LoadGlobal(name 'NaN');              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:15
    LoadGlobal(name 'NaN');              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:21
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:21
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:103:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:104:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:104:3
    LoadGlobal(name 'Infinity');         // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:104:15
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:104:26
    BinOp(op 'DIVIDE_AND_TRUNC');        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:104:26
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:104:40
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:104:40
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:105:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:105:2
}

function testLessThan() {
  entry:
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:19
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:109:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:110:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:110:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:110:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:110:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:110:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:110:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:110:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:19
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:111:22
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:114:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:115:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:115:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:115:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:115:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:115:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:115:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:115:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:20
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:116:24
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:119:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:120:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:120:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:120:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:120:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:120:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:120:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:120:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:21
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:121:26
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:124:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:125:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:125:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:125:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:125:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:125:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:125:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:125:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:20
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:126:23
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:129:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:130:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:130:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:130:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:130:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:130:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:130:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:130:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:21
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:131:25
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:134:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:22
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:135:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:136:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:136:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:136:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:136:22
    BinOp(op '<=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:136:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:136:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:136:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:137:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:137:2
}

function testGreaterThan() {
  entry:
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:141:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:142:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:142:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:142:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:142:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:142:19
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:142:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:142:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:19
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:19
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:143:22
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:146:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:147:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:147:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:147:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:147:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:147:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:147:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:147:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:20
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:148:24
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:151:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:152:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:152:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:152:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:152:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:152:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:152:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:152:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:21
    BinOp(op '>');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:153:26
    // Integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:20
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:156:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:157:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:157:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:157:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:157:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:157:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:157:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:157:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:20
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:20
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:158:23
    // Negative integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:161:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:162:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:162:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:162:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:162:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:162:21
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:162:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:162:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:15
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:21
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:21
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:163:25
    // Floating point
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:22
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:166:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:15
    Literal(lit 1.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:167:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:168:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:168:3
    Literal(lit 2.1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:168:15
    Literal(lit 2.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:168:22
    BinOp(op '>=');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:168:22
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:168:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:168:27
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:169:2
}

function testRemainder() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:19
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:172:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:19
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:173:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:3
    Literal(lit 550);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:15
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:21
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:21
    Literal(lit 50);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:174:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:20
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:176:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:19
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:177:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:15
    Literal(lit -3);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:20
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:20
    Literal(lit -2);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:178:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:3
    Literal(lit 2.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:22
    Literal(lit 0.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:180:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:3
    Literal(lit 5.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:22
    Literal(lit 1.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:181:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:3
    Literal(lit 550.25);                 // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:15
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:24
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:24
    Literal(lit 50.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:182:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:3
    Literal(lit -7.25);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:15
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:23
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:23
    Literal(lit -3.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:184:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:3
    Literal(lit 7.25);                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:15
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:22
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:22
    Literal(lit 3.25);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:185:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:3
    Literal(lit -7.25);                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:15
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:23
    BinOp(op '%');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:23
    Literal(lit -3.25);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:186:27
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:10
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:23
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:27
    BinOp(op '%');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:27
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:27
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:188:27
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:10
    Literal(lit 5.1);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:23
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:29
    BinOp(op '%');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:29
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:29
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:189:29
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:190:2
}

function testPower() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:20
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:20
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:193:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:20
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:20
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:194:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:3
    Literal(lit 2.5);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:22
    BinOp(op '**');                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:22
    Literal(lit 2.5);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:195:25
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:10
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:23
    LoadGlobal(name 'Infinity');         // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:28
    BinOp(op '**');                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:28
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:28
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:196:28
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:197:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:197:2
}

function testIncrDecr() {
  entry:
    Literal(lit deleted);                // 1  x              ./test/end-to-end/tests/number-operations.test.mvm.js:199:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:200:11
    StoreVar(index 0);                   // 1  x              ./test/end-to-end/tests/number-operations.test.mvm.js:200:11
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    StoreVar(index 0);                   // 5  x              ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:201:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:202:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:202:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:203:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:203:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:204:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:204:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    BinOp(op '-');                       // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    StoreVar(index 0);                   // 5  x              ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:205:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:206:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:206:18
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:207:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:15
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:207:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:207:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:208:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:18
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:208:18
    Literal(lit 1.5);                    // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:7
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:7
    StoreVar(index 0);                   // 2  x              ./test/end-to-end/tests/number-operations.test.mvm.js:210:7
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:210:7
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:211:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:15
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:211:15
    Literal(lit 2.5);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:211:20
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:212:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:212:3
    LoadVar(index 0);                    // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:212:15
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:212:15
    BinOp(op '-');                       // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:212:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:212:15
    StoreVar(index 0);                   // 4  x              ./test/end-to-end/tests/number-operations.test.mvm.js:212:15
    Literal(lit 1.5);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:212:20
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:212:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:213:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:213:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:213:2
}

function testStringToInt() {
  entry:
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:10
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:216:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:10
    Literal(lit 'length');               // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:217:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:10
    Literal(lit '__proto__');            // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:218:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:10
    Literal(lit '1a');                   // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:219:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:10
    Literal(lit '1.1.1');                // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:220:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:10
    Literal(lit '123456789123456789.1.1'); // 5               ./test/end-to-end/tests/number-operations.test.mvm.js:221:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:221:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:10
    Literal(lit '123\u0000');            // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:222:24
    // Empty string
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:225:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:225:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:225:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:225:16
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:225:20
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:225:20
    // Whitespace
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:228:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:228:3
    Literal(lit '  ');                   // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:228:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:228:16
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:228:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:228:22
    // Small integers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:231:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:231:3
    Literal(lit '123');                  // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:231:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:231:16
    Literal(lit 123);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:231:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:231:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:232:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:232:3
    Literal(lit '-123');                 // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:232:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:232:16
    Literal(lit -123);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:232:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:232:24
    // Leading and trailing whitespace
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:235:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:235:3
    Literal(lit '  123   ');             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:235:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:235:16
    Literal(lit 123);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:235:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:235:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:236:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:236:3
    Literal(lit '  -123   ');            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:236:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:236:16
    Literal(lit -123);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:236:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:236:29
    // Int32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:239:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:239:3
    Literal(lit '12345678');             // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:239:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:239:16
    Literal(lit 12345678);               // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:239:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:239:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:240:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:240:3
    Literal(lit '-12345678');            // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:240:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:240:16
    Literal(lit -12345678);              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:240:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:240:29
    // Multiply
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:243:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:243:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:243:15
    Literal(lit '123');                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:243:19
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:243:19
    Literal(lit 123);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:243:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:243:26
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:244:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:244:2
}

function testIntToString() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:247:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:247:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:247:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:247:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:247:20
    Literal(lit '0');                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:247:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:247:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:248:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:248:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:248:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:248:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:248:20
    Literal(lit '1');                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:248:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:248:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:249:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:249:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:249:15
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:249:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:249:20
    Literal(lit '-1');                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:249:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:249:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:250:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:250:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:250:15
    Literal(lit 2147483647);             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:250:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:250:21
    Literal(lit '2147483647');           // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:250:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:250:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:251:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:251:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:251:15
    Literal(lit -2147483648);            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:251:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:251:21
    Literal(lit '-2147483648');          // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:251:35
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:251:35
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:252:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:252:2
}

function testFloatToString() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:255:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:255:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:255:15
    LoadGlobal(name 'NaN');              // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:255:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:255:20
    Literal(lit 'NaN');                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:255:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:255:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:256:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:256:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:256:15
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:256:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:256:20
    Literal(lit 'Infinity');             // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:256:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:256:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:257:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:257:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:257:15
    LoadGlobal(name 'Infinity');         // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:257:22
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:257:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:257:22
    Literal(lit '-Infinity');            // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:257:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:257:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:258:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:258:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:258:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:258:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:258:21
    Literal(lit '0');                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:258:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:258:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:259:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:259:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:259:15
    Literal(lit 0.1);                    // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:259:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:259:20
    Literal(lit '0.1');                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:259:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:259:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:260:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:260:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:260:15
    Literal(lit -0.1);                   // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:260:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:260:21
    Literal(lit '-0.1');                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:260:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:260:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:261:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:261:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:261:15
    Literal(lit 1e+30);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:261:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:261:20
    Literal(lit '1e+30');                // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:261:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:261:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:262:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:262:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:262:15
    Literal(lit -1e+30);                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:262:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:262:21
    Literal(lit '-1e+30');               // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:262:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:262:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:263:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:263:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:263:15
    Literal(lit 1e-30);                  // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:263:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:263:20
    Literal(lit '1e-30');                // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:263:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:263:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:264:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/number-operations.test.mvm.js:264:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:264:15
    Literal(lit -1e-30);                 // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:264:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/number-operations.test.mvm.js:264:21
    Literal(lit '-1e-30');               // 4                 ./test/end-to-end/tests/number-operations.test.mvm.js:264:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:264:30
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/number-operations.test.mvm.js:265:2
    Return();                            // 0                 ./test/end-to-end/tests/number-operations.test.mvm.js:265:2
}