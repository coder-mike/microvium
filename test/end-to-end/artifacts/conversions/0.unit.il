unit ['./test/end-to-end/tests/conversions.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external assert from free-variable 'assert';
external Number from free-variable 'Number';
external undefined from free-variable 'undefined';

global thisModule;
global testConvertToNumber;
global testConvertToBoolean;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:1:1
    Literal(lit &function testConvertToNumber); // 2          ./test/end-to-end/tests/conversions.test.mvm.js:1:1
    StoreGlobal(name 'testConvertToNumber'); // 1             ./test/end-to-end/tests/conversions.test.mvm.js:1:1
    Literal(lit &function testConvertToBoolean); // 2         ./test/end-to-end/tests/conversions.test.mvm.js:1:1
    StoreGlobal(name 'testConvertToBoolean'); // 1            ./test/end-to-end/tests/conversions.test.mvm.js:1:1
    // ---
    // description: >
    // Tests primitive type conversions
    // runExportedFunction: 0
    // # assertionCount: 25
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:7:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:7:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:7:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/conversions.test.mvm.js:7:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:7:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:30:1
    Return();                            // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:30:1
}

function run() {
  entry:
    LoadGlobal(name 'testConvertToNumber'); // 1              ./test/end-to-end/tests/conversions.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:10:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:10:3
    LoadGlobal(name 'testConvertToBoolean'); // 1             ./test/end-to-end/tests/conversions.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:11:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:11:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:12:2
    Return();                            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:12:2
}

function testConvertToNumber() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:15:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:15:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:15:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:15:21
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:15:21
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:15:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:15:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:16:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:16:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:16:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:16:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:16:23
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:16:23
    Literal(lit 3.1);                    // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:16:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:16:27
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:17:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:17:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:17:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:17:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:17:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:17:10
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/conversions.test.mvm.js:17:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/conversions.test.mvm.js:17:24
    Call(count 2, flag false);           // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:17:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:17:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:17:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:18:3
    LoadGlobal(name 'Number');           // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    Literal(lit 'isNaN');                // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    ObjectGet();                         // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    ObjectNew();                         // 6                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    UnOp(op '+');                        // 6                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    Call(count 2, flag false);           // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:19:3
    Literal(lit null);                   // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:19:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:19:16
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:19:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:19:22
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:28:2
    Return();                            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:28:2
}

function testConvertToBoolean() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:31:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:31:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:31:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:31:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:31:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:31:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:31:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:32:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:32:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:32:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:32:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:32:18
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:32:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:32:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:33:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:33:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:33:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:33:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:33:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:33:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:33:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:34:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:34:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:34:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:34:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:34:18
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:34:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:34:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:35:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:35:3
    Literal(lit null);                   // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:35:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:35:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:35:18
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:35:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:35:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:36:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:36:3
    ObjectNew();                         // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:36:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:36:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:36:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:36:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:36:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:37:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:37:3
    ArrayNew();                          // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:37:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:37:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:37:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:37:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:37:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:38:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:38:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:38:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:38:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:38:18
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:38:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:38:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:39:3
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:39:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:39:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:39:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:39:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:39:24
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:40:2
    Return();                            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:40:2
}