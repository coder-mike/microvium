unit ['./test/end-to-end/tests/closures-across-snapshot.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:1:1
    Literal(lit &function init);         // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // assertionCount: 1
    // ---
    LoadVar(index 0);                    // 2  init           ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:6:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:6:1
    Call(count 1);                       // 2                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:6:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:6:1
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:8:1
    Return();                            // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:8:1
}

function init() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:8:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:8:17
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:8:17
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:8:17
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:9:11
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:9:11
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:10:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:10:3
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:10:12
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:10:15
    Call(count 3);                       // 2                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:10:15
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:10:15
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:14:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:14:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:14:2
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:12:5
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:12:5
    LoadScoped(index 1);                 // 3  x              ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:12:17
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:12:20
    Call(count 3);                       // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:12:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:12:20
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:13:4
    Return();                            // 0                 ./test/end-to-end/tests/closures-across-snapshot.test.mvm.js:13:4
}