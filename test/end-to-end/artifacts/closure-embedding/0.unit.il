unit ['./test/end-to-end/tests/closure-embedding.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global test_basicClosureEmbedding;
global test_declarationClosureEmbedding;
global test_loop;
global test_doubleNesting;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_basicClosureEmbedding); // 2   ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_basicClosureEmbedding'); // 1      ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_declarationClosureEmbedding); // 2  ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_declarationClosureEmbedding'); // 1  ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_loop);    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_loop');       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_doubleNesting); // 2           ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_doubleNesting'); // 1              ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // assertionCount: 17
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:1
    Return();                            // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:1
}

function run() {
  entry:
    LoadGlobal(name 'test_basicClosureEmbedding'); // 1       ./test/end-to-end/tests/closure-embedding.test.mvm.js:9:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:9:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:9:3
    LoadGlobal(name 'test_declarationClosureEmbedding'); // 1  ./test/end-to-end/tests/closure-embedding.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:10:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:10:3
    LoadGlobal(name 'test_loop');        // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:3
    LoadGlobal(name 'test_doubleNesting'); // 1               ./test/end-to-end/tests/closure-embedding.test.mvm.js:12:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:12:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:12:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:13:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:13:2
}

function test_basicClosureEmbedding() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:15:1
    Literal(lit deleted);                // 1  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:15:39
    Literal(lit deleted);                // 2  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:15:39
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:11
    // increment will be embedded
    Literal(lit &function anonymous);    // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:21
    StoreScoped(index 0);                // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:21
    LoadReg(name 'closure');             // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:21
    StoreVar(index 0);                   // 2  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:21
    // decrement will not be embedded
    Literal(lit &function anonymous1);   // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:21
    ClosureNew();                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:21
    StoreVar(index 1);                   // 2  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:21
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:28
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:15
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:28
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:3
    LoadVar(index 1);                    // 5  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:15
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:28
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:24:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:24:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:24:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:24:18
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:24:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:2
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
}

function anonymous1() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:27
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:27
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:27
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:27
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:27
}

function test_declarationClosureEmbedding() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:27:1
    Literal(lit &function increment);    // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:27:45
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:27:45
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:27:45
    Literal(lit &function decrement);    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:27:45
    ClosureNew();                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:27:45
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:28:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:28:11
    // decrement will not be embedded
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:28
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:15
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:28
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:3
    LoadVar(index 1);                    // 5  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:15
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:28
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:36:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:36:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:36:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:36:18
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:36:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:37:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:37:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:37:2
}

// increment will be embedded
function increment() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:26
}

// decrement will not be embedded
function decrement() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:33
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:33
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:33
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:33
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:33
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:26
}

function test_loop() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:39:1
    Literal(lit deleted);                // 1  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:39:22
    Literal(lit deleted);                // 2  other          ./test/end-to-end/tests/closure-embedding.test.mvm.js:39:22
    Literal(lit deleted);                // 3  other2         ./test/end-to-end/tests/closure-embedding.test.mvm.js:39:22
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:40:11
    StoreScoped(index 1);                // 3  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:40:11
    ArrayNew();                          // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:15
    StoreVar(index 0);                   // 3  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:15
    Literal(lit deleted);                // 4  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:3
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:16
    StoreVar(index 3);                   // 4  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:16
    Jump(@block1);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:16
  block1:
    LoadVar(index 3);                    // 5  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:19
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:23
    BinOp(op '<');                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:23
    Branch(@block2, @block3);            // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:23
  block2:
    ScopePush(count 2);                  // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:32
    // Will be embedded into the loop
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:5
    LoadVar(index 0);                    // 6  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:5
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:5
    Literal(lit 'push');                 // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:5
    ObjectGet();                         // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:5
    StoreVar(index 4);                   // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:5
    Literal(lit &function anonymous2);   // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:14
    StoreScoped(index 0);                // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:14
    LoadReg(name 'closure');             // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:14
    Call(count 2, flag true);            // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:14
    // Will not be embedded
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:5
    LoadVar(index 0);                    // 6  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:5
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:5
    Literal(lit 'push');                 // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:5
    ObjectGet();                         // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:5
    StoreVar(index 4);                   // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:5
    Literal(lit &function anonymous3);   // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:14
    ClosureNew();                        // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:14
    Call(count 2, flag true);            // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:14
    ScopePop();                          // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:47:4
    LoadVar(index 3);                    // 5  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
    StoreVar(index 3);                   // 6  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
    Jump(@block1);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:42:27
  block3:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:47:4
    // Will be embedded into the outer scope
    Literal(lit &function anonymous4);   // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:17
    StoreScoped(index 0);                // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:17
    LoadReg(name 'closure');             // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:17
    StoreVar(index 1);                   // 3  other          ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:17
    // Will not be embedded
    Literal(lit &function anonymous5);   // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:18
    ClosureNew();                        // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:18
    StoreVar(index 2);                   // 3  other2         ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:18
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:3
    LoadVar(index 0);                    // 6  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:15
    Literal(lit 'length');               // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:27
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:27
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:15
    LoadVar(index 0);                    // 7  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:15
    Literal(lit 0);                      // 9                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    ObjectGet();                         // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:15
    LoadVar(index 0);                    // 7  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:15
    Literal(lit 0);                      // 9                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    ObjectGet();                         // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    Literal(lit 2);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:15
    LoadVar(index 0);                    // 7  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:15
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:19
    ObjectGet();                         // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:19
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:19
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:19
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:3
    LoadVar(index 1);                    // 6  other          ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:15
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:24
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:24
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:3
    LoadVar(index 2);                    // 6  other2         ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:15
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:25
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:58:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:58:3
    LoadScoped(index 1);                 // 6  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:58:15
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:58:18
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:58:18
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:59:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:59:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:59:2
}

function anonymous2() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:20
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:20
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:20
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:20
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:20
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:44:20
}

function anonymous3() {
  entry:
    LoadScoped(index 5);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:20
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:24
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:24
}

function anonymous4() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:23
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:23
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:23
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:23
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:23
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:49:23
}

function anonymous5() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:24
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:24
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:24
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:24
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:24
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:24
}

function test_doubleNesting() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:1
    Literal(lit &function bar);          // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:31
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:31
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:31
    Literal(lit &function baz);          // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:31
    ClosureNew();                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:31
    Literal(lit deleted);                // 3  barResult      ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:31
    Literal(lit deleted);                // 4  bazResult      ./test/end-to-end/tests/closure-embedding.test.mvm.js:61:31
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:62:11
    StoreScoped(index 1);                // 4  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:62:11
    LoadVar(index 0);                    // 5  bar            ./test/end-to-end/tests/closure-embedding.test.mvm.js:74:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:74:21
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:74:21
    StoreVar(index 2);                   // 4  barResult      ./test/end-to-end/tests/closure-embedding.test.mvm.js:74:21
    LoadVar(index 1);                    // 5  baz            ./test/end-to-end/tests/closure-embedding.test.mvm.js:75:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:75:21
    Call(count 1, flag false);           // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:75:21
    StoreVar(index 3);                   // 4  bazResult      ./test/end-to-end/tests/closure-embedding.test.mvm.js:75:21
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:76:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:76:3
    LoadVar(index 2);                    // 7  barResult      ./test/end-to-end/tests/closure-embedding.test.mvm.js:76:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:76:15
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:76:15
    Literal(lit 3);                      // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:76:28
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:76:28
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:77:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:77:3
    LoadVar(index 3);                    // 7  bazResult      ./test/end-to-end/tests/closure-embedding.test.mvm.js:77:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:77:15
    Call(count 1, flag false);           // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:77:15
    Literal(lit 4);                      // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:77:28
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:77:28
    Pop(count 4);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:78:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:78:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:78:2
}

function bar() {
  entry:
    ScopePush(count 3);                  // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:64:3
    Literal(lit 2);                      // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:65:13
    StoreScoped(index 1);                // 0  y              ./test/end-to-end/tests/closure-embedding.test.mvm.js:65:13
    Literal(lit &function anonymous6);   // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:66:12
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:66:12
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:66:12
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:66:5
}

function anonymous6() {
  entry:
    LoadScoped(index 4);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:66:18
    LoadScoped(index 1);                 // 2  y              ./test/end-to-end/tests/closure-embedding.test.mvm.js:66:22
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:66:22
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:66:22
}

function baz() {
  entry:
    ScopePush(count 3);                  // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:69:3
    Literal(lit 3);                      // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:70:13
    StoreScoped(index 1);                // 0  z              ./test/end-to-end/tests/closure-embedding.test.mvm.js:70:13
    Literal(lit &function anonymous7);   // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:71:12
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:71:12
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:71:12
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:71:5
}

function anonymous7() {
  entry:
    LoadScoped(index 6);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:71:18
    LoadScoped(index 1);                 // 2  z              ./test/end-to-end/tests/closure-embedding.test.mvm.js:71:22
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:71:22
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:71:22
}