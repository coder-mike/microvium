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
    // assertionCount: 14
    // testOnly: false
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:8:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:8:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:8:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/conversions.test.mvm.js:8:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:8:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:31:1
    Return();                            // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:31:1
}

function run() {
  entry:
    LoadGlobal(name 'testConvertToNumber'); // 1              ./test/end-to-end/tests/conversions.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:11:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:11:3
    LoadGlobal(name 'testConvertToBoolean'); // 1             ./test/end-to-end/tests/conversions.test.mvm.js:12:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:12:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:12:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:13:2
    Return();                            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:13:2
}

function testConvertToNumber() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:16:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:16:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:16:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:16:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:16:21
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:16:21
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:16:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:16:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:17:3
    Literal(lit 1.1);                    // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:17:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:17:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:17:23
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:17:23
    Literal(lit 3.1);                    // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:17:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:17:27
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:18:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:18:10
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:18:24
    LoadGlobal(name 'assert');           // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:19:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:19:10
    LoadGlobal(name 'Number');           // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:19:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:19:10
    Literal(lit 'isNaN');                // 6                 ./test/end-to-end/tests/conversions.test.mvm.js:19:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:19:10
    StoreVar(index 2);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:19:10
    ObjectNew();                         // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:19:24
    UnOp(op '+');                        // 5                 ./test/end-to-end/tests/conversions.test.mvm.js:19:24
    Call(count 2, flag false);           // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:19:24
    Call(count 2, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:19:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:20:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:20:3
    Literal(lit null);                   // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:20:16
    UnOp(op '+');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:20:16
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:20:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:20:22
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:29:2
    Return();                            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:29:2
}

function testConvertToBoolean() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:32:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:32:3
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:32:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:32:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:32:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:32:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:32:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:33:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:33:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:33:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:33:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:33:18
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:33:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:33:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:34:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:34:3
    Literal(lit -1);                     // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:34:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:34:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:34:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:34:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:34:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:35:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:35:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:35:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:35:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:35:18
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:35:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:35:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:36:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:36:3
    Literal(lit null);                   // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:36:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:36:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:36:18
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:36:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:36:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:37:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:37:3
    ObjectNew();                         // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:37:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:37:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:37:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:37:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:37:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:38:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:38:3
    ArrayNew();                          // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:38:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:38:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:38:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:38:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:38:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:39:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:39:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:39:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:39:18
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:39:23
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:39:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:40:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/conversions.test.mvm.js:40:3
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:40:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:40:18
    UnOp(op '!');                        // 3                 ./test/end-to-end/tests/conversions.test.mvm.js:40:18
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/conversions.test.mvm.js:40:24
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:40:24
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/conversions.test.mvm.js:41:2
    Return();                            // 0                 ./test/end-to-end/tests/conversions.test.mvm.js:41:2
}