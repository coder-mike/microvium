unit ['./test/end-to-end/tests/closure-embedding.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;
global test_basicClosureEmbedding;
global test_declarationClosureEmbedding;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_basicClosureEmbedding); // 2   ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_basicClosureEmbedding'); // 1      ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    Literal(lit &function test_declarationClosureEmbedding); // 2  ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    StoreGlobal(name 'test_declarationClosureEmbedding'); // 1  ./test/end-to-end/tests/closure-embedding.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // assertionCount: 8
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:6:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:1
    Return();                            // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:1
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
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:11:2
}

function test_basicClosureEmbedding() {
  entry:
    ScopePush(count 2);                  // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:13:1
    Literal(lit deleted);                // 1  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:13:39
    Literal(lit deleted);                // 2  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:13:39
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:14:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:14:11
    // increment will be embedded
    Literal(lit &function anonymous);    // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:21
    StoreScoped(index 0);                // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:21
    LoadReg(name 'closure');             // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:21
    StoreVar(index 0);                   // 2  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:21
    // decrement will not be embedded
    Literal(lit &function anonymous1);   // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:21
    ClosureNew();                        // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:21
    StoreVar(index 1);                   // 2  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:21
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:19:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:20:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:3
    LoadVar(index 1);                    // 5  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:21:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:18
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:22:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:23:2
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:27
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:27
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:27
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:16:27
}

function anonymous1() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:18:27
}

function test_declarationClosureEmbedding() {
  entry:
    ScopePush(count 2);                  // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:1
    Literal(lit &function increment);    // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:45
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:45
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:45
    Literal(lit &function decrement);    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:45
    ClosureNew();                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:25:45
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:26:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:26:11
    // decrement will not be embedded
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:31:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:3
    LoadVar(index 0);                    // 5  increment      ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:32:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:3
    LoadVar(index 1);                    // 5  decrement      ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:33:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:18
    Call(count 3);                       // 3                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:34:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:2
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:35:2
}

// increment will be embedded
function increment() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:28:33
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:28:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:28:33
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:28:33
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:28:33
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:28:33
}

// decrement will not be embedded
function decrement() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    BinOp(op '-');                       // 1                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
    Return();                            // 0                 ./test/end-to-end/tests/closure-embedding.test.mvm.js:30:33
}