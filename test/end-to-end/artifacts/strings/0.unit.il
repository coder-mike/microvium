unit ['./test/end-to-end/tests/strings.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/strings.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/strings.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/strings.test.mvm.js:1:1
    // ---
    // description: >
    // Tests various string operations and conversion to strings.
    // runExportedFunction: 0
    // assertionCount: 22
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/strings.test.mvm.js:8:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/strings.test.mvm.js:8:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:8:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/strings.test.mvm.js:8:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/strings.test.mvm.js:8:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:10:1
    Return();                            // 1                 ./test/end-to-end/tests/strings.test.mvm.js:10:1
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:11:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:11:15
    Literal(lit 'abc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:11:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:11:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:12:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:12:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:12:15
    Literal(lit 'cd');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:12:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:12:23
    Literal(lit 'ab_cd');                // 4                 ./test/end-to-end/tests/strings.test.mvm.js:12:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:12:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:13:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:13:15
    Literal(lit 'cd');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:13:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:13:23
    Literal(lit 'ef');                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:13:30
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:13:30
    Literal(lit 'ab_cdef');              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:13:36
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:13:36
    // Int14
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:15:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:15:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:15:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:15:23
    Literal(lit 'ab_5');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:15:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:15:26
    // Negative
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:17:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:17:15
    Literal(lit -5);                     // 4                 ./test/end-to-end/tests/strings.test.mvm.js:17:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:17:24
    Literal(lit 'ab_-5');                // 4                 ./test/end-to-end/tests/strings.test.mvm.js:17:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:17:29
    // Int32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:19:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:19:15
    Literal(lit 500000);                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:19:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:19:23
    Literal(lit 'ab_500000');            // 4                 ./test/end-to-end/tests/strings.test.mvm.js:19:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:19:31
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:20:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:20:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:20:15
    Literal(lit -500000);                // 4                 ./test/end-to-end/tests/strings.test.mvm.js:20:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:20:24
    Literal(lit 'ab_-500000');           // 4                 ./test/end-to-end/tests/strings.test.mvm.js:20:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:20:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:21:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:21:15
    Literal(lit -2147483648);            // 4                 ./test/end-to-end/tests/strings.test.mvm.js:21:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:21:24
    Literal(lit 'ab_-2147483648');       // 4                 ./test/end-to-end/tests/strings.test.mvm.js:21:38
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:21:38
    // Some general constants
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:24:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:24:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:24:15
    Literal(lit null);                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:24:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:24:23
    Literal(lit 'ab_null');              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:24:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:24:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:25:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:25:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:25:15
    Literal(lit true);                   // 4                 ./test/end-to-end/tests/strings.test.mvm.js:25:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:25:23
    Literal(lit 'ab_true');              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:25:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:25:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:26:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:26:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:26:15
    Literal(lit false);                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:26:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:26:23
    Literal(lit 'ab_false');             // 4                 ./test/end-to-end/tests/strings.test.mvm.js:26:30
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:26:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:27:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:27:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:27:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/strings.test.mvm.js:27:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:27:23
    Literal(lit 'ab_undefined');         // 4                 ./test/end-to-end/tests/strings.test.mvm.js:27:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:27:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:28:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:28:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:28:15
    Literal(lit -0);                     // 4                 ./test/end-to-end/tests/strings.test.mvm.js:28:24
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:28:24
    Literal(lit 'ab_0');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:28:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:28:29
    // Special strings
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:31:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:31:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:31:15
    Literal(lit 'proto');                // 4                 ./test/end-to-end/tests/strings.test.mvm.js:31:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:31:23
    Literal(lit 'ab_proto');             // 4                 ./test/end-to-end/tests/strings.test.mvm.js:31:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:31:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:32:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:32:3
    Literal(lit 'proto');                // 3                 ./test/end-to-end/tests/strings.test.mvm.js:32:15
    Literal(lit '_bc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:32:25
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:32:25
    Literal(lit 'proto_bc');             // 4                 ./test/end-to-end/tests/strings.test.mvm.js:32:32
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:32:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:33:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:33:3
    Literal(lit 'ab_');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:33:15
    Literal(lit 'length');               // 4                 ./test/end-to-end/tests/strings.test.mvm.js:33:23
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:33:23
    Literal(lit 'ab_length');            // 4                 ./test/end-to-end/tests/strings.test.mvm.js:33:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:33:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:34:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:34:3
    Literal(lit 'length');               // 3                 ./test/end-to-end/tests/strings.test.mvm.js:34:15
    Literal(lit '_bc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:34:26
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:34:26
    Literal(lit 'length_bc');            // 4                 ./test/end-to-end/tests/strings.test.mvm.js:34:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:34:33
    // Interpolation
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:37:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:37:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/strings.test.mvm.js:37:15
    Literal(lit '');                     // 4                 ./test/end-to-end/tests/strings.test.mvm.js:37:19
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:37:19
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:38:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:38:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:38:15
    Literal(lit 'abc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:38:22
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:38:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:39:3
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/strings.test.mvm.js:39:15
    Literal(lit '_');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:39:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:39:18
    Literal(lit 'abc');                  // 4                 ./test/end-to-end/tests/strings.test.mvm.js:39:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:39:18
    Literal(lit '_abc');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:39:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:39:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:40:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:40:3
    Literal(lit 'abc');                  // 3                 ./test/end-to-end/tests/strings.test.mvm.js:40:15
    Literal(lit '_');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:40:21
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:40:21
    Literal(lit 'abc_');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:40:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:40:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/strings.test.mvm.js:41:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/strings.test.mvm.js:41:3
    Literal(lit 'ab');                   // 3                 ./test/end-to-end/tests/strings.test.mvm.js:41:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/strings.test.mvm.js:41:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:41:20
    Literal(lit 'c');                    // 4                 ./test/end-to-end/tests/strings.test.mvm.js:41:20
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/strings.test.mvm.js:41:20
    Literal(lit 'ab5c');                 // 4                 ./test/end-to-end/tests/strings.test.mvm.js:41:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:41:26
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/strings.test.mvm.js:47:2
    Return();                            // 0                 ./test/end-to-end/tests/strings.test.mvm.js:47:2
}