unit ['./test/end-to-end/tests/switch.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external print from free-variable 'print';

global thisModule;
global convert;
global weirdSwitch;
global evaluateCase;
global switchWithNoDefault;
global switchFallThroughBottom;
global emptySwitch;
global switchWithOnlyDefault;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    Literal(lit &function convert);      // 2                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    StoreGlobal(name 'convert');         // 1                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    Literal(lit &function weirdSwitch);  // 2                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    StoreGlobal(name 'weirdSwitch');     // 1                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    Literal(lit &function evaluateCase); // 2                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    StoreGlobal(name 'evaluateCase');    // 1                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    Literal(lit &function switchWithNoDefault); // 2          ./test/end-to-end/tests/switch.test.mvm.js:1:1
    StoreGlobal(name 'switchWithNoDefault'); // 1             ./test/end-to-end/tests/switch.test.mvm.js:1:1
    Literal(lit &function switchFallThroughBottom); // 2      ./test/end-to-end/tests/switch.test.mvm.js:1:1
    StoreGlobal(name 'switchFallThroughBottom'); // 1         ./test/end-to-end/tests/switch.test.mvm.js:1:1
    Literal(lit &function emptySwitch);  // 2                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    StoreGlobal(name 'emptySwitch');     // 1                 ./test/end-to-end/tests/switch.test.mvm.js:1:1
    Literal(lit &function switchWithOnlyDefault); // 2        ./test/end-to-end/tests/switch.test.mvm.js:1:1
    StoreGlobal(name 'switchWithOnlyDefault'); // 1           ./test/end-to-end/tests/switch.test.mvm.js:1:1
    // ---
    // description: >
    // Switch statements
    // runExportedFunction: 0
    // # The disassembly uses different block numbers and optimizes the fall-through cases better
    // dontCompareDisassembly: true
    // assertionCount: 6
    // expectedPrintout: |
    // emptySwitch:after
    // switchWithOnlyDefault:default
    // switchWithOnlyDefault:after
    // 1
    // 2
    // 4
    // c
    // d
    // !
    // 1
    // 2
    // b
    // c
    // d
    // !
    // x
    // y
    // z
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/switch.test.mvm.js:29:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:29:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/switch.test.mvm.js:29:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/switch.test.mvm.js:29:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:29:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:29:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:107:1
    Return();                            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:107:1
}

function run() {
  entry:
    LoadGlobal(name 'emptySwitch');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:32:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:32:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:32:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:32:3
    LoadGlobal(name 'switchWithOnlyDefault'); // 1            ./test/end-to-end/tests/switch.test.mvm.js:33:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:33:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:33:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:33:3
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:35:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:35:3
    LoadGlobal(name 'convert');          // 3                 ./test/end-to-end/tests/switch.test.mvm.js:35:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:35:15
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/switch.test.mvm.js:35:23
    Call(count 2);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:35:23
    Literal(lit 'It was 5');             // 4                 ./test/end-to-end/tests/switch.test.mvm.js:35:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:35:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:35:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:36:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:36:3
    LoadGlobal(name 'convert');          // 3                 ./test/end-to-end/tests/switch.test.mvm.js:36:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:36:15
    Literal(lit 6);                      // 5                 ./test/end-to-end/tests/switch.test.mvm.js:36:23
    Call(count 2);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:36:23
    Literal(lit 'It was 6');             // 4                 ./test/end-to-end/tests/switch.test.mvm.js:36:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:36:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:36:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:37:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:37:3
    LoadGlobal(name 'convert');          // 3                 ./test/end-to-end/tests/switch.test.mvm.js:37:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:37:15
    Literal(lit 7);                      // 5                 ./test/end-to-end/tests/switch.test.mvm.js:37:23
    Call(count 2);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:37:23
    Literal(lit 'It was 7');             // 4                 ./test/end-to-end/tests/switch.test.mvm.js:37:27
    Call(count 3);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:37:27
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:37:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:38:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:38:3
    LoadGlobal(name 'convert');          // 3                 ./test/end-to-end/tests/switch.test.mvm.js:38:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:38:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/switch.test.mvm.js:38:23
    Call(count 2);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:38:23
    Literal(lit 'It was x');             // 4                 ./test/end-to-end/tests/switch.test.mvm.js:38:29
    Call(count 3);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:38:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:38:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:39:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:39:3
    LoadGlobal(name 'convert');          // 3                 ./test/end-to-end/tests/switch.test.mvm.js:39:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:39:15
    Literal(lit 'something else');       // 5                 ./test/end-to-end/tests/switch.test.mvm.js:39:23
    Call(count 2);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:39:23
    Literal(lit 'Don\'t know what it was'); // 4              ./test/end-to-end/tests/switch.test.mvm.js:39:42
    Call(count 3);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:39:42
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:39:42
    LoadGlobal(name 'weirdSwitch');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:41:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:41:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/switch.test.mvm.js:41:15
    Call(count 2);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:41:15
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:41:15
    LoadGlobal(name 'weirdSwitch');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:42:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:42:3
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/switch.test.mvm.js:42:15
    Call(count 2);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:42:15
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:42:15
    LoadGlobal(name 'switchFallThroughBottom'); // 1          ./test/end-to-end/tests/switch.test.mvm.js:44:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:44:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:44:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:44:3
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:46:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:46:3
    LoadGlobal(name 'switchWithNoDefault'); // 3              ./test/end-to-end/tests/switch.test.mvm.js:46:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:46:15
    Call(count 1);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:46:15
    Literal(lit 22);                     // 4                 ./test/end-to-end/tests/switch.test.mvm.js:46:38
    Call(count 3);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:46:38
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:46:38
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/switch.test.mvm.js:47:2
    Return();                            // 0                 ./test/end-to-end/tests/switch.test.mvm.js:47:2
}

function convert() {
  entry:
    Literal(lit deleted);                // 1  result         ./test/end-to-end/tests/switch.test.mvm.js:49:21
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:50:7
    StoreVar(index 0);                   // 1  result         ./test/end-to-end/tests/switch.test.mvm.js:50:7
    LoadArg(index 1);                    // 2  x              ./test/end-to-end/tests/switch.test.mvm.js:51:11
    Jump(@block1);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:51:11
  block1:
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/switch.test.mvm.js:51:11
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/switch.test.mvm.js:53:10
    BinOp(op '===');                     // 3                 ./test/end-to-end/tests/switch.test.mvm.js:53:10
    Branch(@block6, @block2);            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:53:10
  block2:
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/switch.test.mvm.js:51:11
    Literal(lit 6);                      // 4                 ./test/end-to-end/tests/switch.test.mvm.js:54:10
    BinOp(op '===');                     // 3                 ./test/end-to-end/tests/switch.test.mvm.js:54:10
    Branch(@block7, @block3);            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:54:10
  block3:
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/switch.test.mvm.js:51:11
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/switch.test.mvm.js:55:10
    Literal(lit 4);                      // 5                 ./test/end-to-end/tests/switch.test.mvm.js:55:12
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/switch.test.mvm.js:55:12
    BinOp(op '===');                     // 3                 ./test/end-to-end/tests/switch.test.mvm.js:55:12
    Branch(@block8, @block4);            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:55:12
  block4:
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/switch.test.mvm.js:51:11
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:56:10
    BinOp(op '===');                     // 3                 ./test/end-to-end/tests/switch.test.mvm.js:56:10
    Branch(@block9, @block5);            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:56:10
  block5:
    Jump(@block10);                      // 2                 ./test/end-to-end/tests/switch.test.mvm.js:51:11
  block6:
    Literal(lit 'It was 5');             // 3                 ./test/end-to-end/tests/switch.test.mvm.js:53:22
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:53:22
    StoreVar(index 0);                   // 3  result         ./test/end-to-end/tests/switch.test.mvm.js:53:22
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/switch.test.mvm.js:53:22
    Jump(@block11);                      // 2                 ./test/end-to-end/tests/switch.test.mvm.js:53:34
  block7:
    Literal(lit 'It was 6');             // 3                 ./test/end-to-end/tests/switch.test.mvm.js:54:22
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:54:22
    StoreVar(index 0);                   // 3  result         ./test/end-to-end/tests/switch.test.mvm.js:54:22
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/switch.test.mvm.js:54:22
    Jump(@block11);                      // 2                 ./test/end-to-end/tests/switch.test.mvm.js:54:34
  block8:
    Literal(lit 'It was 7');             // 3                 ./test/end-to-end/tests/switch.test.mvm.js:55:22
    Return();                            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:55:22
  block9:
    Literal(lit 'It was x');             // 3                 ./test/end-to-end/tests/switch.test.mvm.js:56:22
    Return();                            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:56:22
  block10:
    Literal(lit 'Don\'t know what it was'); // 3              ./test/end-to-end/tests/switch.test.mvm.js:57:21
    Return();                            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:57:21
  block11:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:51:11
    LoadVar(index 0);                    // 2  result         ./test/end-to-end/tests/switch.test.mvm.js:59:10
    Return();                            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:59:10
}

function weirdSwitch() {
  entry:
    // JavaScript has weird (IMO) behavior with fall through from `default`. The
    // test case for `4` is evaluated before the fallback to the default case, but
    // then the consequent for the default case falls through to the consequent of
    // case `4`.
    LoadArg(index 1);                    // 1  x              ./test/end-to-end/tests/switch.test.mvm.js:67:11
    Jump(@block12);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:67:11
  block12:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:67:11
    LoadGlobal(name 'evaluateCase');     // 3                 ./test/end-to-end/tests/switch.test.mvm.js:68:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:68:10
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/switch.test.mvm.js:68:23
    Call(count 2);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:68:23
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:68:23
    Branch(@block16, @block13);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:68:23
  block13:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:67:11
    LoadGlobal(name 'evaluateCase');     // 3                 ./test/end-to-end/tests/switch.test.mvm.js:69:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:69:10
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/switch.test.mvm.js:69:23
    Call(count 2);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:69:23
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:69:23
    Branch(@block17, @block14);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:69:23
  block14:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:67:11
    LoadGlobal(name 'evaluateCase');     // 3                 ./test/end-to-end/tests/switch.test.mvm.js:71:10
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/switch.test.mvm.js:71:10
    Literal(lit 4);                      // 5                 ./test/end-to-end/tests/switch.test.mvm.js:71:23
    Call(count 2);                       // 3                 ./test/end-to-end/tests/switch.test.mvm.js:71:23
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:71:23
    Branch(@block19, @block15);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:71:23
  block15:
    Jump(@block18);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:67:11
  block16:
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:68:27
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:68:27
    Literal(lit 'a');                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:68:33
    Call(count 2);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:68:33
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:68:33
    Jump(@block17);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:68:33
  block17:
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:69:27
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:69:27
    Literal(lit 'b');                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:69:33
    Call(count 2);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:69:33
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:69:33
    Jump(@block18);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:69:33
  block18:
    LoadGlobal(name 'evaluateCase');     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:70:14
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:70:14
    Literal(lit 'c');                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:70:27
    Call(count 2);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:70:27
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:70:27
    Jump(@block19);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:70:27
  block19:
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:71:27
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:71:27
    Literal(lit 'd');                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:71:33
    Call(count 2);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:71:33
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:71:33
    Jump(@block20);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:71:33
  block20:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:67:11
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:73:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:73:3
    Literal(lit '!');                    // 3                 ./test/end-to-end/tests/switch.test.mvm.js:73:9
    Call(count 2);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:73:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:73:9
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/switch.test.mvm.js:74:2
    Return();                            // 0                 ./test/end-to-end/tests/switch.test.mvm.js:74:2
}

function evaluateCase() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:77:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:77:3
    LoadArg(index 1);                    // 3  x              ./test/end-to-end/tests/switch.test.mvm.js:77:9
    Call(count 2);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:77:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:77:9
    LoadArg(index 1);                    // 1  x              ./test/end-to-end/tests/switch.test.mvm.js:78:10
    Return();                            // 0                 ./test/end-to-end/tests/switch.test.mvm.js:78:10
}

function switchWithNoDefault() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:82:11
    Jump(@block21);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:82:11
  block21:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:82:11
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/switch.test.mvm.js:83:10
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:83:10
    Branch(@block24, @block22);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:83:10
  block22:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:82:11
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/switch.test.mvm.js:84:10
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:84:10
    Branch(@block25, @block23);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:84:10
  block23:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:82:11
    Literal(lit 3);                      // 3                 ./test/end-to-end/tests/switch.test.mvm.js:85:10
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:85:10
    Branch(@block26, @block27);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:85:10
  block24:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/switch.test.mvm.js:83:20
    Return();                            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:83:20
  block25:
    Literal(lit 2);                      // 2                 ./test/end-to-end/tests/switch.test.mvm.js:84:20
    Return();                            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:84:20
  block26:
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/switch.test.mvm.js:85:20
    Return();                            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:85:20
  block27:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:82:11
    Literal(lit 22);                     // 1                 ./test/end-to-end/tests/switch.test.mvm.js:88:10
    Return();                            // 0                 ./test/end-to-end/tests/switch.test.mvm.js:88:10
}

function switchFallThroughBottom() {
  entry:
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:92:11
    Jump(@block28);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:92:11
  block28:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:92:11
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/switch.test.mvm.js:93:10
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:93:10
    Branch(@block31, @block29);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:93:10
  block29:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:92:11
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/switch.test.mvm.js:94:10
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:94:10
    Branch(@block32, @block30);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:94:10
  block30:
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/switch.test.mvm.js:92:11
    Literal(lit 2);                      // 3                 ./test/end-to-end/tests/switch.test.mvm.js:95:10
    BinOp(op '===');                     // 2                 ./test/end-to-end/tests/switch.test.mvm.js:95:10
    Branch(@block33, @block34);          // 1                 ./test/end-to-end/tests/switch.test.mvm.js:95:10
  block31:
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:93:13
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:93:13
    Literal(lit 'w');                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:93:19
    Call(count 2);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:93:19
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:93:19
    Jump(@block32);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:93:19
  block32:
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:94:13
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:94:13
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:94:19
    Call(count 2);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:94:19
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:94:19
    Jump(@block33);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:94:19
  block33:
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:95:13
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:95:13
    Literal(lit 'y');                    // 4                 ./test/end-to-end/tests/switch.test.mvm.js:95:19
    Call(count 2);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:95:19
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:95:19
    Jump(@block34);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:95:19
  block34:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:92:11
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:98:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:98:3
    Literal(lit 'z');                    // 3                 ./test/end-to-end/tests/switch.test.mvm.js:98:9
    Call(count 2);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:98:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:98:9
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/switch.test.mvm.js:99:2
    Return();                            // 0                 ./test/end-to-end/tests/switch.test.mvm.js:99:2
}

function emptySwitch() {
  entry:
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:102:11
    Jump(@block35);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:102:11
  block35:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:102:11
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:104:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:104:3
    Literal(lit 'emptySwitch:after');    // 3                 ./test/end-to-end/tests/switch.test.mvm.js:104:9
    Call(count 2);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:104:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:104:9
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/switch.test.mvm.js:105:2
    Return();                            // 0                 ./test/end-to-end/tests/switch.test.mvm.js:105:2
}

function switchWithOnlyDefault() {
  entry:
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:108:11
    Jump(@block36);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:108:11
  block36:
    Jump(@block37);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:108:11
  block37:
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/switch.test.mvm.js:109:14
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/switch.test.mvm.js:109:14
    Literal(lit 'switchWithOnlyDefault:default'); // 4        ./test/end-to-end/tests/switch.test.mvm.js:109:20
    Call(count 2);                       // 2                 ./test/end-to-end/tests/switch.test.mvm.js:109:20
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/switch.test.mvm.js:109:20
    Jump(@block38);                      // 1                 ./test/end-to-end/tests/switch.test.mvm.js:109:20
  block38:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:108:11
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/switch.test.mvm.js:111:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/switch.test.mvm.js:111:3
    Literal(lit 'switchWithOnlyDefault:after'); // 3          ./test/end-to-end/tests/switch.test.mvm.js:111:9
    Call(count 2);                       // 1                 ./test/end-to-end/tests/switch.test.mvm.js:111:9
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/switch.test.mvm.js:111:9
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/switch.test.mvm.js:112:2
    Return();                            // 0                 ./test/end-to-end/tests/switch.test.mvm.js:112:2
}