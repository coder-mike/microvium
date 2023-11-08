unit ['./test/end-to-end/tests/strings.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';
external textSupport from free-variable 'textSupport';

global thisModule;
global testStringPrototypeMethods;
global asciiTests;
global basicMultilingualPlaneTests;
global fullUnicodeTests;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/strings.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/strings.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/strings.test.mvm.js:1:1
    Literal(lit &function testStringPrototypeMethods); // 2   ./test/end-to-end/tests/strings.test.mvm.js:1:1
    StoreGlobal(name 'testStringPrototypeMethods'); // 1      ./test/end-to-end/tests/strings.test.mvm.js:1:1
    Literal(lit &function asciiTests);   // 2                 ./test/end-to-end/tests/strings.test.mvm.js:1:1
    StoreGlobal(name 'asciiTests');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:1:1
    Literal(lit &function basicMultilingualPlaneTests); // 2  ./test/end-to-end/tests/strings.test.mvm.js:1:1
    StoreGlobal(name 'basicMultilingualPlaneTests'); // 1     ./test/end-to-end/tests/strings.test.mvm.js:1:1
    Literal(lit &function fullUnicodeTests); // 2             ./test/end-to-end/tests/strings.test.mvm.js:1:1
    StoreGlobal(name 'fullUnicodeTests'); // 1                ./test/end-to-end/tests/strings.test.mvm.js:1:1
    Literal(lit &function compileTimeStringPrototypeSetup); // 2  ./test/end-to-end/tests/strings.test.mvm.js:1:1
    // ---
    // description: >
    // Tests various string operations and conversion to strings.
    // runExportedFunction: 0
    // assertionCount: 38
    // ---
    LoadGlobal(name 'vmExport');         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:8:1
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:8:1
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/strings.test.mvm.js:8:10
    LoadVar(index 0);                    // 6  run            ./test/end-to-end/tests/strings.test.mvm.js:8:13
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/strings.test.mvm.js:8:13
    LoadVar(index 1);                    // 3  compileTimeStringPrototypeSetup ./test/end-to-end/tests/strings.test.mvm.js:10:1
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:10:1
    Call(count 1, flag true);            // 2                 ./test/end-to-end/tests/strings.test.mvm.js:10:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/strings.test.mvm.js:96:1
    Return();                            // 2                 ./test/end-to-end/tests/strings.test.mvm.js:96:1
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:13:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:13:15
    Literal(lit 'abc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:13:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:13:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:14:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:14:15
    Literal(lit 'cd');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:14:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:14:23
    Literal(lit 'ab_cd');                // 4                 ./test/end-to-end/tests/strings.test.mvm.js:14:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:14:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:15:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:15:15
    Literal(lit 'cd');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:15:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:15:23
    Literal(lit 'ef');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:15:30
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:15:30
    Literal(lit 'ab_cdef');              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:15:36
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:15:36
    // Int14
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:17:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:17:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:17:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:17:23
    Literal(lit 'ab_5');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:17:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:17:26
    // Negative
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:19:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:19:15
    Literal(lit -5);                     // 4                 ./test/end-to-end/tests/strings.test.mvm.js:19:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:19:24
    Literal(lit 'ab_-5');                // 4                 ./test/end-to-end/tests/strings.test.mvm.js:19:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:19:29
    // Int32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:21:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:21:15
    Literal(lit 500000);                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:21:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:21:23
    Literal(lit 'ab_500000');            // 4                 ./test/end-to-end/tests/strings.test.mvm.js:21:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:21:31
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:22:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:22:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:22:15
    Literal(lit -500000);                // 4                 ./test/end-to-end/tests/strings.test.mvm.js:22:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:22:24
    Literal(lit 'ab_-500000');           // 4                 ./test/end-to-end/tests/strings.test.mvm.js:22:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:22:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:23:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:23:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:23:15
    Literal(lit -2147483648);            // 4                 ./test/end-to-end/tests/strings.test.mvm.js:23:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:23:24
    Literal(lit 'ab_-2147483648');       // 4                 ./test/end-to-end/tests/strings.test.mvm.js:23:38
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:23:38
    // Some general constants
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:26:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:26:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:26:15
    Literal(lit null);                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:26:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:26:23
    Literal(lit 'ab_null');              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:26:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:26:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:27:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:27:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:27:15
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:27:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:27:23
    Literal(lit 'ab_true');              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:27:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:27:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:28:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:28:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:28:15
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:28:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:28:23
    Literal(lit 'ab_false');             // 4                 ./test/end-to-end/tests/strings.test.mvm.js:28:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:28:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:29:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:29:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:29:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:29:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:29:23
    Literal(lit 'ab_undefined');         // 4                 ./test/end-to-end/tests/strings.test.mvm.js:29:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:29:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:30:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:30:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:30:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/strings.test.mvm.js:30:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:30:24
    Literal(lit 'ab_0');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:30:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:30:29
    // Special strings
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:33:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:33:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:33:15
    Literal(lit 'proto');                // 4                 ./test/end-to-end/tests/strings.test.mvm.js:33:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:33:23
    Literal(lit 'ab_proto');             // 4                 ./test/end-to-end/tests/strings.test.mvm.js:33:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:33:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:34:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:34:3
    Literal(lit 'proto');                // 3                 ./test/end-to-end/tests/strings.test.mvm.js:34:15
    Literal(lit '_bc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:34:25
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:34:25
    Literal(lit 'proto_bc');             // 4                 ./test/end-to-end/tests/strings.test.mvm.js:34:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:34:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:35:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:35:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:35:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/strings.test.mvm.js:35:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:35:23
    Literal(lit 'ab_length');            // 4                 ./test/end-to-end/tests/strings.test.mvm.js:35:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:35:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:36:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:36:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/strings.test.mvm.js:36:15
    Literal(lit '_bc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:36:26
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:36:26
    Literal(lit 'length_bc');            // 4                 ./test/end-to-end/tests/strings.test.mvm.js:36:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:36:33
    // Interpolation
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:39:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/strings.test.mvm.js:39:15
    Literal(lit '');                     // 4                 ./test/end-to-end/tests/strings.test.mvm.js:39:19
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:39:19
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:40:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:40:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:40:15
    Literal(lit 'abc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:40:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:40:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:41:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:41:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/strings.test.mvm.js:41:15
    Literal(lit '_');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:41:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:41:18
    Literal(lit 'abc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:41:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:41:18
    Literal(lit '_abc');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:41:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:41:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:42:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:42:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:42:15
    Literal(lit '_');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:42:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:42:21
    Literal(lit 'abc_');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:42:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:42:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:43:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:43:3
    Literal(lit 'ab');                   // 3                 ./test/end-to-end/tests/strings.test.mvm.js:43:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:43:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:43:20
    Literal(lit 'c');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:43:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:43:20
    Literal(lit 'ab5c');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:43:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:43:26
    LoadGlobal(name 'testStringPrototypeMethods'); // 1       ./test/end-to-end/tests/strings.test.mvm.js:45:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:45:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:45:3
    LoadGlobal(name 'asciiTests');       // 1                 ./test/end-to-end/tests/strings.test.mvm.js:47:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:47:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:47:3
    // The `textSupport` global is set by the test harness depending on the value
    // of MVM_TEXT_SUPPORT in the port file.
    LoadGlobal(name 'textSupport');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:51:7
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/strings.test.mvm.js:51:23
    BinOp(op '===');                     // 1                 ./test/end-to-end/tests/strings.test.mvm.js:51:23
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/strings.test.mvm.js:51:23
    Branch(@block2, @block1);            // 1                 ./test/end-to-end/tests/strings.test.mvm.js:51:23
  block1:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/strings.test.mvm.js:51:23
    LoadGlobal(name 'textSupport');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:51:38
    Literal(lit 2);                      // 2                 ./test/end-to-end/tests/strings.test.mvm.js:51:54
    BinOp(op '===');                     // 1                 ./test/end-to-end/tests/strings.test.mvm.js:51:54
    Jump(@block2);                       // 1                 ./test/end-to-end/tests/strings.test.mvm.js:51:54
  block2:
    Branch(@block3, @block4);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:51:7
  block3:
    LoadGlobal(name 'basicMultilingualPlaneTests'); // 1      ./test/end-to-end/tests/strings.test.mvm.js:52:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:52:5
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:52:5
    Jump(@block4);                       // 0                 ./test/end-to-end/tests/strings.test.mvm.js:53:4
  block4:
    LoadGlobal(name 'textSupport');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:55:7
    Literal(lit 2);                      // 2                 ./test/end-to-end/tests/strings.test.mvm.js:55:23
    BinOp(op '===');                     // 1                 ./test/end-to-end/tests/strings.test.mvm.js:55:23
    Branch(@block5, @block6);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:55:7
  block5:
    LoadGlobal(name 'fullUnicodeTests'); // 1                 ./test/end-to-end/tests/strings.test.mvm.js:56:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:56:5
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:56:5
    Jump(@block6);                       // 0                 ./test/end-to-end/tests/strings.test.mvm.js:57:4
  block6:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/strings.test.mvm.js:58:2
    Return();                            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:58:2
}

function testStringPrototypeMethods() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/strings.test.mvm.js:62:2
    Return();                            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:62:2
}

function asciiTests() {
  entry:
    // ROM string
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:66:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:66:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:66:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/strings.test.mvm.js:66:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:66:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:66:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:66:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:67:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:67:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:67:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:67:21
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:67:21
    Literal(lit 'a');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:67:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:67:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:68:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:68:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:68:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:68:21
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:68:21
    Literal(lit 'c');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:68:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:68:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:69:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:69:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:69:15
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:69:21
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:69:21
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:69:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:69:25
    // RAM string (constructed)
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:72:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:72:3
    Literal(lit 'a');                    // 3                 ./test/end-to-end/tests/strings.test.mvm.js:72:16
    Literal(lit 'bc');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:72:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:72:22
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/strings.test.mvm.js:72:22
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:72:22
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:72:36
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:72:36
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:73:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:73:3
    Literal(lit 'a');                    // 3                 ./test/end-to-end/tests/strings.test.mvm.js:73:16
    Literal(lit 'bc');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:73:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:73:22
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:73:28
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:73:28
    Literal(lit 'a');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:73:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:73:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:74:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:74:3
    Literal(lit 'a');                    // 3                 ./test/end-to-end/tests/strings.test.mvm.js:74:16
    Literal(lit 'bc');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:74:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:74:22
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:74:28
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:74:28
    Literal(lit 'c');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:74:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:74:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:75:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:75:3
    Literal(lit 'a');                    // 3                 ./test/end-to-end/tests/strings.test.mvm.js:75:16
    Literal(lit 'bc');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:75:22
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:75:22
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:75:28
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:75:28
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:75:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:75:32
    // Special strings
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:78:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:78:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/strings.test.mvm.js:78:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/strings.test.mvm.js:78:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:78:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:78:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:78:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:79:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:79:3
    Literal(lit '__proto__');            // 3                 ./test/end-to-end/tests/strings.test.mvm.js:79:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/strings.test.mvm.js:79:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:79:15
    Literal(lit 9);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:79:35
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:79:35
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:80:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:80:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/strings.test.mvm.js:80:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:80:24
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:80:24
    Literal(lit 'l');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:80:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:80:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:81:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:81:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/strings.test.mvm.js:81:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:81:24
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:81:24
    Literal(lit 'h');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:81:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:81:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:82:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:82:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/strings.test.mvm.js:82:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:82:24
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:82:24
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:82:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:82:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:83:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:83:3
    Literal(lit '__proto__');            // 3                 ./test/end-to-end/tests/strings.test.mvm.js:83:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:83:27
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:83:27
    Literal(lit '_');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:83:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:83:31
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:84:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:84:3
    Literal(lit '__proto__');            // 3                 ./test/end-to-end/tests/strings.test.mvm.js:84:15
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:84:27
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:84:27
    Literal(lit '_');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:84:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:84:31
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:85:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:85:3
    Literal(lit '__proto__');            // 3                 ./test/end-to-end/tests/strings.test.mvm.js:85:15
    Literal(lit 9);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:85:27
    ObjectGet();                         // 3                 ./test/end-to-end/tests/strings.test.mvm.js:85:27
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:85:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:85:31
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/strings.test.mvm.js:86:2
    Return();                            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:86:2
}

function basicMultilingualPlaneTests() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/strings.test.mvm.js:90:2
    Return();                            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:90:2
}

function fullUnicodeTests() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/strings.test.mvm.js:94:2
    Return();                            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:94:2
}

function compileTimeStringPrototypeSetup() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/strings.test.mvm.js:98:2
    Return();                            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:98:2
}