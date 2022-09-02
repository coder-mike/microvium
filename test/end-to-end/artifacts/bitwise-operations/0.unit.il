unit ['./test/end-to-end/tests/bitwise-operations.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external overflowChecks from free-variable 'overflowChecks';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:1:1
    // ---
    // description: >
    // Tests various operations that should classify as vm_TeBitwiseOp operations
    // runExportedFunction: 0
    // assertionCount: 25
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:7:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:7:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:7:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/bitwise-operations.test.mvm.js:7:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:7:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:7:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:9:1
    Return();                            // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:9:1
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:10:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:10:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:10:20
    BinOp(op '<<');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:10:20
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:10:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:10:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:10:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:11:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:11:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:11:20
    BinOp(op '<<');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:11:20
    Literal(lit 12);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:11:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:11:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:11:23
    // Wrap around
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:13:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:13:15
    Literal(lit 34);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:13:20
    BinOp(op '<<');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:13:20
    Literal(lit 12);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:13:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:13:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:13:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:14:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:14:15
    Literal(lit 32);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:14:20
    BinOp(op '<<');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:14:20
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:14:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:14:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:14:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:15:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:15:15
    Literal(lit 31);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:15:20
    BinOp(op '<<');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:15:20
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:15:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:15:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:15:24
    // Left shift negative numbers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:18:3
    Literal(lit -2);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:18:15
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:18:21
    BinOp(op '<<');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:18:21
    Literal(lit -8);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:18:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:18:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:18:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:20:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:20:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:20:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:20:20
    BinOp(op '>>');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:20:20
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:20:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:20:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:20:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:21:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:21:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:21:21
    BinOp(op '>>>');                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:21:21
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:21:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:21:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:21:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:22:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:22:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:22:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:22:21
    BinOp(op '>>');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:22:21
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:22:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:22:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:22:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:23:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:23:3
    Literal(lit -8);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:23:15
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:23:22
    BinOp(op '>>>');                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:23:22
    Literal(lit 2147483644);             // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:23:25
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:23:25
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:23:25
    // Shifting by zero
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:26:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:26:3
    Literal(lit 4);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:26:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:26:20
    BinOp(op '>>');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:26:20
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:26:23
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:26:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:26:23
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:27:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:27:3
    Literal(lit 4);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:27:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:27:21
    BinOp(op '>>>');                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:27:21
    Literal(lit 4);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:27:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:27:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:27:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:28:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:28:3
    Literal(lit -4);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:28:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:28:21
    BinOp(op '>>');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:28:21
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:28:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:28:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:28:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:3
    Literal(lit -4);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:15
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:22
    BinOp(op '>>>');                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:22
    LoadGlobal(name 'overflowChecks');   // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:25
    Branch(@block1, @block2);            // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:25
  block1:
    Literal(lit 4294967292);             // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:42
    Jump(@block3);                       // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:42
  block2:
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:55
    Jump(@block3);                       // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:55
  block3:
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:55
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:29:55
    // Shifting by negative numbers
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:15
    Literal(lit -30);                    // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:20
    BinOp(op '>>');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:20
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:25
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:30
    BinOp(op '>>');                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:30
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:30
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:32:30
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:15
    Literal(lit -30);                    // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:21
    BinOp(op '>>>');                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:21
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:26
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:32
    BinOp(op '>>>');                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:32
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:33:32
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:3
    Literal(lit 8);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:15
    Literal(lit -30);                    // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:20
    BinOp(op '<<');                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:20
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:25
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:30
    BinOp(op '<<');                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:30
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:30
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:34:30
    // Other operators. These are much simpler
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:37:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:37:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:37:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:37:19
    BinOp(op '|');                       // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:37:19
    Literal(lit 7);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:37:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:37:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:37:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:38:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:38:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:38:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:38:19
    BinOp(op '&');                       // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:38:19
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:38:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:38:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:38:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:39:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:39:15
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:39:19
    BinOp(op '^');                       // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:39:19
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:39:22
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:39:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:39:22
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:40:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:40:3
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:40:16
    UnOp(op '~');                        // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:40:16
    Literal(lit -4);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:40:19
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:40:19
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:40:19
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:41:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:41:3
    Literal(lit -3);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:41:15
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:41:20
    BinOp(op '|');                       // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:41:20
    Literal(lit -1);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:41:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:41:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:41:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:42:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:42:3
    Literal(lit -3);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:42:15
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:42:20
    BinOp(op '&');                       // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:42:20
    Literal(lit -8);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:42:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:42:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:42:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:43:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:43:3
    Literal(lit -3);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:43:15
    Literal(lit -6);                     // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:43:20
    BinOp(op '^');                       // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:43:20
    Literal(lit 7);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:43:24
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:43:24
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:43:24
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:44:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:44:3
    Literal(lit -3);                     // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:44:16
    UnOp(op '~');                        // 3                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:44:16
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:44:20
    Call(count 3);                       // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:44:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:44:20
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:45:2
    Return();                            // 0                 ./test/end-to-end/tests/bitwise-operations.test.mvm.js:45:2
}