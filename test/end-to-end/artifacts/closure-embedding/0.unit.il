unit ['./test/end-to-end/tests/closure-embedding.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global test_basicClosureEmbedding;
global test_declarationClosureEmbedding;
global test_loop1;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_basicClosureEmbedding); // 2   ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_basicClosureEmbedding'); // 1      ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_declarationClosureEmbedding); // 2  ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_declarationClosureEmbedding'); // 1  ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_loop1);   // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_loop1');      // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // assertionCount: 15
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:38:1
    Return();                            // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:38:1
}

function run() {
  entry:
    LoadGlobal(name 'test_basicClosureEmbedding'); // 1       ./test/end-to-end/tests/closure-embedding.test.mvm.js:9:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:9:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:9:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:9:3
    LoadGlobal(name 'test_declarationClosureEmbedding'); // 1  ./test/end-to-end/tests/closure-embedding.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:10:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:10:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:10:3
    LoadGlobal(name 'test_loop1');       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:12:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:12:2
}

function test_basicClosureEmbedding() {
  entry:
    ScopePush(count 2);                  // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:14:1
    Literal(lit deleted);                // 1  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:14:39
    Literal(lit deleted);                // 2  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:14:39
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:15:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:15:11
    // increment will be embedded
    Literal(lit &function anonymous);    // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:21
    StoreScoped(index 0);                // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:21
    LoadReg(name 'closure');             // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:21
    StoreVar(index 0);                   // 2  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:21
    // decrement will not be embedded
    Literal(lit &function anonymous1);   // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:21
    ClosureNew();                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:21
    StoreVar(index 1);                   // 2  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:21
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:3
    LoadVar(index 1);                    // 5  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:18
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:24:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:24:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:24:2
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:27
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:27
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:27
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:17:27
}

function anonymous1() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:27
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:27
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:27
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:27
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:27
}

function test_declarationClosureEmbedding() {
  entry:
    ScopePush(count 2);                  // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:26:1
    Literal(lit &function increment);    // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:26:45
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:26:45
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:26:45
    Literal(lit &function decrement);    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:26:45
    ClosureNew();                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:26:45
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:27:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:27:11
    // decrement will not be embedded
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:3
    LoadVar(index 1);                    // 5  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:18
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:36:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:36:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:36:2
}

// increment will be embedded
function increment() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:29:33
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:29:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:29:33
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:29:33
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:29:33
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:29:33
}

// decrement will not be embedded
function decrement() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:33
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:33
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:33
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:33
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:33
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:33
}

function test_loop1() {
  entry:
    ScopePush(count 2);                  // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:38:1
    Literal(lit deleted);                // 1  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:38:23
    Literal(lit deleted);                // 2  other          ./test/end-to-end/tests/closure-embedding.test.mvm.js:38:23
    Literal(lit deleted);                // 3  other2         ./test/end-to-end/tests/closure-embedding.test.mvm.js:38:23
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:39:11
    StoreScoped(index 1);                // 3  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:39:11
    ArrayNew();                          // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:40:15
    StoreVar(index 0);                   // 3  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:40:15
    Literal(lit deleted);                // 4  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:3
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:16
    StoreVar(index 3);                   // 4  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:16
    Jump(@block1);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:16
  block1:
    LoadVar(index 3);                    // 5  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:19
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:23
    BinOp(op '<');                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:23
    Branch(@block2, @block3);            // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:23
  block2:
    ScopePush(count 2);                  // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:32
    // Will be embedded into the loop
    LoadVar(index 0);                    // 5  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:5
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:5
    Literal(lit 'push');                 // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:5
    ObjectGet();                         // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:5
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:5
    Literal(lit &function anonymous2);   // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:14
    StoreScoped(index 0);                // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:14
    LoadReg(name 'closure');             // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:14
    Call(count 2);                       // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:14
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:14
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:14
    // Will not be embedded
    LoadVar(index 0);                    // 5  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:5
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:5
    Literal(lit 'push');                 // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:5
    ObjectGet();                         // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:5
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:5
    Literal(lit &function anonymous3);   // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:14
    ClosureNew();                        // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:14
    Call(count 2);                       // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:14
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:14
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:14
    ScopePop();                          // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:4
    LoadVar(index 3);                    // 5  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
    StoreVar(index 3);                   // 6  i              ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
    Jump(@block1);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:41:27
  block3:
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:46:4
    // Will be embedded into the outer scope
    Literal(lit &function anonymous4);   // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:17
    StoreScoped(index 0);                // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:17
    LoadReg(name 'closure');             // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:17
    StoreVar(index 1);                   // 3  other          ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:17
    // Will not be embedded
    Literal(lit &function anonymous5);   // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:18
    ClosureNew();                        // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:18
    StoreVar(index 2);                   // 3  other2         ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:18
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:3
    LoadVar(index 0);                    // 6  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:15
    Literal(lit 'length');               // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:51:27
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:3
    LoadVar(index 0);                    // 6  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:15
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:19
    ObjectGet();                         // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:19
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:19
    Call(count 1);                       // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:19
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:19
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:25
    Call(count 3);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:25
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:52:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:3
    LoadVar(index 0);                    // 6  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:15
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    ObjectGet();                         // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    Call(count 1);                       // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:19
    Literal(lit 2);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:25
    Call(count 3);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:25
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:53:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:3
    LoadVar(index 0);                    // 6  arr            ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:15
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    ObjectGet();                         // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    Call(count 1);                       // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:19
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:25
    Call(count 3);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:25
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:54:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:3
    LoadVar(index 1);                    // 6  other          ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:15
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:55:24
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:3
    LoadVar(index 2);                    // 6  other2         ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:15
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:25
    Call(count 3);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:25
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:56:25
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:3
    LoadScoped(index 1);                 // 6  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:15
    Literal(lit 0);                      // 7                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:18
    Call(count 3);                       // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:18
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:57:18
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:58:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:58:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:58:2
}

function anonymous2() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:20
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:20
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:20
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:20
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:20
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:43:20
}

function anonymous3() {
  entry:
    LoadScoped(index 5);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:20
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:24
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:45:24
}

function anonymous4() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:23
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:23
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:23
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:23
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:23
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:48:23
}

function anonymous5() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:24
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:24
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:24
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:24
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:24
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:50:24
}