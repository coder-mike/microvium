unit ['./test/end-to-end/tests/closures-in-loops.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external print from free-variable 'print';
external console from free-variable 'console';

global thisModule;
global test1;
global mutationOfLoopVar;
global popScope;
global testBreak;
global testNestedBreak;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    Literal(lit &function test1);        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    StoreGlobal(name 'test1');           // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    Literal(lit &function mutationOfLoopVar); // 2            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    StoreGlobal(name 'mutationOfLoopVar'); // 1               ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    Literal(lit &function popScope);     // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    StoreGlobal(name 'popScope');        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    Literal(lit &function testBreak);    // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    StoreGlobal(name 'testBreak');       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    Literal(lit &function testNestedBreak); // 2              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    StoreGlobal(name 'testNestedBreak'); // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // expectedPrintout: |
    // # Test 1
    // 0, 0
    // 1, 1
    // 2, 2
    // 3, 3
    // 4, 4
    // # Test mutationOfLoopVar
    // 1, 0
    // 3, 2
    // 5, 4
    // 7, 6
    // 9, 8
    // # Test popScope
    // outer, z
    // 0, 0, z
    // 1, 1, z
    // 2, 2, z
    // 3, 3, z
    // 4, 4, z
    // # Test testBreak
    // outer, z
    // 0, 0, z
    // 1, 1, z
    // 2, 2, z
    // # Test testNestedBreak
    // outer, c
    // 0, 0, c, 0, 0
    // 0, 0, c, 1, 1
    // 0, 0, c
    // 1, 1, c, 0, 0
    // 1, 1, c, 1, 1
    // 1, 1, c
    // 2, 2, c, 0, 0
    // 2, 2, c, 1, 1
    // 2, 2, c
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:41:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:41:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:41:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:41:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:41:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:41:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:120:1
    Return();                            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:120:1
}

function run() {
  entry:
    LoadGlobal(name 'test1');            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:44:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:44:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:44:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:44:3
    LoadGlobal(name 'mutationOfLoopVar'); // 1                ./test/end-to-end/tests/closures-in-loops.test.mvm.js:45:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:45:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:45:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:45:3
    LoadGlobal(name 'popScope');         // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:46:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:46:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:46:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:46:3
    LoadGlobal(name 'testBreak');        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:47:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:47:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:47:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:47:3
    LoadGlobal(name 'testNestedBreak');  // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:48:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:48:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:48:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:48:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:49:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:49:2
}

function test1() {
  entry:
    Literal(lit deleted);                // 1  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:51:18
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:52:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:52:3
    Literal(lit '# Test 1');             // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:52:9
    Call(count 2);                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:52:9
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:52:9
    ArrayNew();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:53:15
    StoreVar(index 0);                   // 1  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:53:15
    ScopeNew(count 1);                   // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:3
    Literal(lit 0);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:16
    StoreScoped(index 0);                // 1  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:16
    Jump(@block1);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:16
  block1:
    LoadScoped(index 0);                 // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:19
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:23
    BinOp(op '<');                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:23
    Branch(@block2, @block3);            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:23
  block2:
    ScopePush(count 3);                  // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:31
    LoadScoped(index 3);                 // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:55:15
    StoreScoped(index 1);                // 1  y              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:55:15
    LoadVar(index 0);                    // 2  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:5
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:5
    Literal(lit 'push');                 // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:5
    ObjectGet();                         // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:5
    LoadVar(index 1);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:5
    Literal(lit &function anonymous);    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:14
    StoreScoped(index 0);                // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:14
    LoadReg(name 'closure');             // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:14
    Call(count 2);                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:14
    StoreVar(index 1);                   // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:14
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:14
    ScopePop();                          // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:57:4
    ScopeClone();                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:57:4
    LoadScoped(index 0);                 // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
    StoreScoped(index 0);                // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
    Jump(@block1);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:54:26
  block3:
    ScopeDiscard();                      // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:57:4
    Literal(lit deleted);                // 2  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:16
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:16
    Jump(@block4);                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:16
  block4:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:19
    LoadVar(index 0);                    // 4  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:23
    Literal(lit 'length');               // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:23
    ObjectGet();                         // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:23
    Branch(@block5, @block6);            // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:23
  block5:
    LoadVar(index 0);                    // 3  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:59:5
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:59:5
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:59:9
    ObjectGet();                         // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:59:9
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:59:9
    Call(count 1);                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:59:9
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:59:9
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:59:9
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
    StoreVar(index 1);                   // 4  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
    Jump(@block4);                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:58:35
  block6:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:60:4
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:61:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:61:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:61:2
}

function anonymous() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:20
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:20
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:26
    LoadScoped(index 3);                 // 4  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:29
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:29
    LoadScoped(index 1);                 // 4  y              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:35
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:35
    Call(count 2);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:35
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:56:35
}

function mutationOfLoopVar() {
  entry:
    Literal(lit deleted);                // 1  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:63:30
    LoadGlobal(name 'print');            // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:64:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:64:3
    Literal(lit '# Test mutationOfLoopVar'); // 4             ./test/end-to-end/tests/closures-in-loops.test.mvm.js:64:9
    Call(count 2);                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:64:9
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:64:9
    ArrayNew();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:65:15
    StoreVar(index 0);                   // 1  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:65:15
    ScopeNew(count 1);                   // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:3
    Literal(lit 0);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:16
    StoreScoped(index 0);                // 1  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:16
    Jump(@block7);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:16
  block7:
    LoadScoped(index 0);                 // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:19
    Literal(lit 10);                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:23
    BinOp(op '<');                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:23
    Branch(@block8, @block9);            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:23
  block8:
    ScopePush(count 3);                  // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:32
    LoadScoped(index 3);                 // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:67:15
    StoreScoped(index 1);                // 1  y              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:67:15
    LoadVar(index 0);                    // 2  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:5
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:5
    Literal(lit 'push');                 // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:5
    ObjectGet();                         // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:5
    LoadVar(index 1);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:5
    Literal(lit &function anonymous1);   // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:14
    StoreScoped(index 0);                // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:14
    LoadReg(name 'closure');             // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:14
    Call(count 2);                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:14
    StoreVar(index 1);                   // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:14
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:14
    LoadScoped(index 3);                 // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:69:5
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:69:5
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:69:5
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:69:5
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:69:5
    StoreScoped(index 3);                // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:69:5
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:69:5
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:69:5
    ScopePop();                          // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:70:4
    ScopeClone();                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:70:4
    LoadScoped(index 0);                 // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
    StoreScoped(index 0);                // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
    Jump(@block7);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:66:27
  block9:
    ScopeDiscard();                      // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:70:4
    Literal(lit deleted);                // 2  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:16
    StoreVar(index 1);                   // 2  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:16
    Jump(@block10);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:16
  block10:
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:19
    LoadVar(index 0);                    // 4  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:23
    Literal(lit 'length');               // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:23
    ObjectGet();                         // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:23
    Branch(@block11, @block12);          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:23
  block11:
    LoadVar(index 0);                    // 3  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:72:5
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:72:5
    LoadVar(index 1);                    // 5  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:72:9
    ObjectGet();                         // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:72:9
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:72:9
    Call(count 1);                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:72:9
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:72:9
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:72:9
    LoadVar(index 1);                    // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
    StoreVar(index 1);                   // 4  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
    Jump(@block10);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:71:35
  block12:
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:73:4
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:74:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:74:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:74:2
}

function anonymous1() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:20
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:20
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:26
    LoadScoped(index 3);                 // 4  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:29
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:29
    LoadScoped(index 1);                 // 4  y              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:35
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:35
    Call(count 2);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:35
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:68:35
}

function popScope() {
  entry:
    ScopeNew(count 3);                   // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:76:1
    Literal(lit deleted);                // 1  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:76:21
    Literal(lit deleted);                // 2  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:76:21
    LoadGlobal(name 'print');            // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:77:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:77:3
    Literal(lit '# Test popScope');      // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:77:9
    Call(count 2);                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:77:9
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:77:9
    Literal(lit 'outer');                // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:78:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:78:11
    Literal(lit 'z');                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:79:11
    StoreScoped(index 2);                // 2  z              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:79:11
    ArrayNew();                          // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:80:15
    StoreVar(index 0);                   // 2  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:80:15
    ScopePush(count 2);                  // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:16
    StoreScoped(index 0);                // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:16
    Jump(@block13);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:16
  block13:
    LoadScoped(index 0);                 // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:19
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:23
    Branch(@block14, @block15);          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:23
  block14:
    ScopePush(count 3);                  // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:31
    LoadScoped(index 3);                 // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:82:15
    StoreScoped(index 1);                // 2  y              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:82:15
    LoadVar(index 0);                    // 3  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:5
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:5
    Literal(lit 'push');                 // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:5
    ObjectGet();                         // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:5
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:5
    Literal(lit &function anonymous2);   // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:14
    StoreScoped(index 0);                // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:14
    LoadReg(name 'closure');             // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:14
    Call(count 2);                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:14
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:14
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:14
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:84:4
    ScopeClone();                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:84:4
    LoadScoped(index 0);                 // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
    StoreScoped(index 0);                // 4  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
    Jump(@block13);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:81:26
  block15:
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:84:4
    // foo will be doing LoadScoped[0], so this checks that the scope after the
    // loop is correctly back to the original function scope.
    Literal(lit &function anonymous3);   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:15
    StoreScoped(index 0);                // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:15
    LoadReg(name 'closure');             // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:15
    StoreVar(index 1);                   // 2  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:15
    LoadVar(index 1);                    // 3  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:88:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:88:3
    Call(count 1);                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:88:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:88:3
    Literal(lit deleted);                // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:3
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:16
    StoreVar(index 2);                   // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:16
    Jump(@block16);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:16
  block16:
    LoadVar(index 2);                    // 4  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:19
    LoadVar(index 0);                    // 5  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:23
    Literal(lit 'length');               // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:23
    ObjectGet();                         // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:23
    BinOp(op '<');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:23
    Branch(@block17, @block18);          // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:23
  block17:
    LoadVar(index 0);                    // 4  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:91:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:91:5
    LoadVar(index 2);                    // 6  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:91:9
    ObjectGet();                         // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:91:9
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:91:9
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:91:9
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:91:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:91:9
    LoadVar(index 2);                    // 4  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
    StoreVar(index 2);                   // 5  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
    Jump(@block16);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:90:35
  block18:
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:92:4
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:93:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:93:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:93:2
}

function anonymous2() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:20
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:20
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:26
    LoadScoped(index 3);                 // 4  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:29
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:29
    LoadScoped(index 1);                 // 4  y              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:35
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:35
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:35
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:35
    LoadScoped(index 7);                 // 4  z              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:41
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:41
    Call(count 2);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:41
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:83:41
}

function anonymous3() {
  entry:
    LoadGlobal(name 'console');          // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:21
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:21
    Literal(lit 'log');                  // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:21
    ObjectGet();                         // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:21
    LoadVar(index 0);                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:21
    Literal(lit '');                     // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:33
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:36
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:36
    Literal(lit ', ');                   // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:36
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:36
    LoadScoped(index 2);                 // 5  z              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:42
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:42
    Call(count 2);                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:42
    StoreVar(index 0);                   // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:42
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:87:42
}

// Similar to popScope but tests that the scope is popped when the loop breaks early
function testBreak() {
  entry:
    ScopeNew(count 3);                   // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:96:1
    Literal(lit deleted);                // 1  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:96:22
    Literal(lit deleted);                // 2  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:96:22
    LoadGlobal(name 'print');            // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:97:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:97:3
    Literal(lit '# Test testBreak');     // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:97:9
    Call(count 2);                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:97:9
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:97:9
    Literal(lit 'outer');                // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:98:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:98:11
    Literal(lit 'z');                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:99:11
    StoreScoped(index 2);                // 2  z              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:99:11
    ArrayNew();                          // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:100:15
    StoreVar(index 0);                   // 2  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:100:15
    ScopePush(count 2);                  // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:16
    StoreScoped(index 0);                // 2  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:16
    Jump(@block19);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:16
  block19:
    LoadScoped(index 0);                 // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:19
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:23
    Branch(@block20, @block23);          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:23
  block20:
    ScopePush(count 3);                  // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:31
    LoadScoped(index 3);                 // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:102:15
    StoreScoped(index 1);                // 2  y              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:102:15
    LoadScoped(index 3);                 // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:103:9
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:103:15
    BinOp(op '===');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:103:15
    Branch(@block21, @block22);          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:103:9
  block21:
    // Break early
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:105:7
    Jump(@block23);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:105:7
  block22:
    LoadVar(index 0);                    // 3  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:5
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:5
    Literal(lit 'push');                 // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:5
    ObjectGet();                         // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:5
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:5
    Literal(lit &function anonymous4);   // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:14
    StoreScoped(index 0);                // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:14
    LoadReg(name 'closure');             // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:14
    Call(count 2);                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:14
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:14
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:14
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:108:4
    ScopeClone();                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:108:4
    LoadScoped(index 0);                 // 3  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
    StoreScoped(index 0);                // 4  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
    Jump(@block19);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:101:26
  block23:
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:108:4
    // If the scope popping worked, the closure here should refer to the outer `x`
    // and `z`. If the scope popping didn't work then variables [1] and [2] here
    // will be point to the wrong place.
    Literal(lit &function anonymous5);   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:15
    StoreScoped(index 0);                // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:15
    LoadReg(name 'closure');             // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:15
    StoreVar(index 1);                   // 2  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:15
    LoadVar(index 1);                    // 3  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:113:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:113:3
    Call(count 1);                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:113:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:113:3
    Literal(lit deleted);                // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:3
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:16
    StoreVar(index 2);                   // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:16
    Jump(@block24);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:16
  block24:
    LoadVar(index 2);                    // 4  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:19
    LoadVar(index 0);                    // 5  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:23
    Literal(lit 'length');               // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:23
    ObjectGet();                         // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:23
    BinOp(op '<');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:23
    Branch(@block25, @block26);          // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:23
  block25:
    LoadVar(index 0);                    // 4  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:116:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:116:5
    LoadVar(index 2);                    // 6  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:116:9
    ObjectGet();                         // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:116:9
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:116:9
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:116:9
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:116:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:116:9
    LoadVar(index 2);                    // 4  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
    StoreVar(index 2);                   // 5  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
    Jump(@block24);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:115:35
  block26:
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:117:4
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:118:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:118:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:118:2
}

function anonymous4() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:20
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:20
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:26
    LoadScoped(index 3);                 // 4  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:29
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:29
    LoadScoped(index 1);                 // 4  y              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:35
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:35
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:35
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:35
    LoadScoped(index 7);                 // 4  z              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:41
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:41
    Call(count 2);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:41
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:107:41
}

function anonymous5() {
  entry:
    LoadGlobal(name 'console');          // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:21
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:21
    Literal(lit 'log');                  // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:21
    ObjectGet();                         // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:21
    LoadVar(index 0);                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:21
    Literal(lit '');                     // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:33
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:36
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:36
    Literal(lit ', ');                   // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:36
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:36
    LoadScoped(index 2);                 // 5  z              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:42
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:42
    Call(count 2);                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:42
    StoreVar(index 0);                   // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:42
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:112:42
}

function testNestedBreak() {
  entry:
    ScopeNew(count 3);                   // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:120:1
    Literal(lit deleted);                // 1  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:120:28
    Literal(lit deleted);                // 2  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:120:28
    LoadGlobal(name 'print');            // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:121:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:121:3
    Literal(lit '# Test testNestedBreak'); // 5               ./test/end-to-end/tests/closures-in-loops.test.mvm.js:121:9
    Call(count 2);                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:121:9
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:121:9
    Literal(lit 'outer');                // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:122:11
    StoreScoped(index 1);                // 2  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:122:11
    Literal(lit 'c');                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:123:11
    StoreScoped(index 2);                // 2  c              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:123:11
    ArrayNew();                          // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:124:15
    StoreVar(index 0);                   // 2  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:124:15
    ScopePush(count 2);                  // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:16
    StoreScoped(index 0);                // 2  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:16
    Jump(@block27);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:16
  block27:
    LoadScoped(index 0);                 // 3  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:19
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:23
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:23
    Branch(@block28, @block36);          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:23
  block28:
    ScopePush(count 3);                  // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:31
    LoadScoped(index 3);                 // 3  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:126:15
    StoreScoped(index 1);                // 2  b              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:126:15
    ScopePush(count 2);                  // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:5
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:18
    StoreScoped(index 0);                // 2  d              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:18
    Jump(@block29);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:18
  block29:
    LoadScoped(index 0);                 // 3  d              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:21
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:25
    BinOp(op '<');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:25
    Branch(@block30, @block33);          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:25
  block30:
    ScopePush(count 3);                  // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:33
    LoadScoped(index 3);                 // 3  d              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:128:17
    StoreScoped(index 1);                // 2  e              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:128:17
    LoadVar(index 0);                    // 3  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:7
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:7
    Literal(lit 'push');                 // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:7
    ObjectGet();                         // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:7
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:7
    Literal(lit &function anonymous6);   // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:16
    StoreScoped(index 0);                // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:16
    LoadReg(name 'closure');             // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:16
    Call(count 2);                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:16
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:16
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:16
    LoadScoped(index 3);                 // 3  d              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:130:11
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:130:17
    BinOp(op '===');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:130:17
    Branch(@block31, @block32);          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:130:11
  block31:
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:130:20
    Jump(@block33);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:130:20
  block32:
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:131:6
    ScopeClone();                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:131:6
    LoadScoped(index 0);                 // 3  d              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
    StoreScoped(index 0);                // 4  d              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
    Jump(@block29);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:127:28
  block33:
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:131:6
    LoadVar(index 0);                    // 3  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:5
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:5
    Literal(lit 'push');                 // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:5
    ObjectGet();                         // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:5
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:5
    Literal(lit &function anonymous7);   // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:14
    StoreScoped(index 0);                // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:14
    LoadReg(name 'closure');             // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:14
    Call(count 2);                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:14
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:14
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:14
    LoadScoped(index 3);                 // 3  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:133:9
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:133:15
    BinOp(op '===');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:133:15
    Branch(@block34, @block35);          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:133:9
  block34:
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:133:18
    Jump(@block36);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:133:18
  block35:
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:134:4
    ScopeClone();                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:134:4
    LoadScoped(index 0);                 // 3  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
    StoreScoped(index 0);                // 4  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
    Jump(@block27);                      // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:125:26
  block36:
    ScopePop();                          // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:134:4
    // If the scope popping worked, the closure here should refer to the outer `x`
    // and `z`. If the scope popping didn't work then variables [1] and [2] here
    // will be point to the wrong place.
    Literal(lit &function anonymous8);   // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:15
    StoreScoped(index 0);                // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:15
    LoadReg(name 'closure');             // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:15
    StoreVar(index 1);                   // 2  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:15
    LoadVar(index 1);                    // 3  foo            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:139:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:139:3
    Call(count 1);                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:139:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:139:3
    Literal(lit deleted);                // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:3
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:16
    StoreVar(index 2);                   // 3  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:16
    Jump(@block37);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:16
  block37:
    LoadVar(index 2);                    // 4  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:19
    LoadVar(index 0);                    // 5  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:23
    Literal(lit 'length');               // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:23
    ObjectGet();                         // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:23
    BinOp(op '<');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:23
    Branch(@block38, @block39);          // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:23
  block38:
    LoadVar(index 0);                    // 4  arr            ./test/end-to-end/tests/closures-in-loops.test.mvm.js:142:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:142:5
    LoadVar(index 2);                    // 6  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:142:9
    ObjectGet();                         // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:142:9
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:142:9
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:142:9
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:142:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:142:9
    LoadVar(index 2);                    // 4  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
    BinOp(op '+');                       // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
    StoreVar(index 2);                   // 5  i              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
    Jump(@block37);                      // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:141:35
  block39:
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:143:4
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:144:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:144:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:144:2
}

function anonymous6() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:22
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:22
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:28
    LoadScoped(index 8);                 // 4  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:31
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:31
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:31
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:31
    LoadScoped(index 6);                 // 4  b              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:37
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:37
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:37
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:37
    LoadScoped(index 12);                // 4  c              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:43
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:43
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:43
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:43
    LoadScoped(index 3);                 // 4  d              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:49
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:49
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:49
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:49
    LoadScoped(index 1);                 // 4  e              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:55
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:55
    Call(count 2);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:55
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:129:55
}

function anonymous7() {
  entry:
    LoadGlobal(name 'print');            // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:20
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:20
    Literal(lit '');                     // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:26
    LoadScoped(index 3);                 // 4  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:29
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:29
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:29
    LoadScoped(index 1);                 // 4  b              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:35
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:35
    Literal(lit ', ');                   // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:35
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:35
    LoadScoped(index 7);                 // 4  c              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:41
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:41
    Call(count 2);                       // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:41
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:132:41
}

function anonymous8() {
  entry:
    LoadGlobal(name 'console');          // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:21
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:21
    Literal(lit 'log');                  // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:21
    ObjectGet();                         // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:21
    LoadVar(index 0);                    // 3                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:21
    Literal(lit '');                     // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:33
    LoadScoped(index 1);                 // 5  a              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:36
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:36
    Literal(lit ', ');                   // 5                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:36
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:36
    LoadScoped(index 2);                 // 5  c              ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:42
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:42
    Call(count 2);                       // 2                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:42
    StoreVar(index 0);                   // 1                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:42
    Return();                            // 0                 ./test/end-to-end/tests/closures-in-loops.test.mvm.js:138:42
}