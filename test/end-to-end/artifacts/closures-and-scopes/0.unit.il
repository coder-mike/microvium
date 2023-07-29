unit ['./test/end-to-end/tests/closures-and-scopes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external assert from free-variable 'assert';
external Number from free-variable 'Number';

global thisModule;
global v1;
global v4;
global basics;
global makeIncrementorA;
global makeIncrementorA2;
global makeIncrementorB;
global makeIncrementorC;
global nestedLexicalScopes;
global differentVariableTypes;
global closureOperations;
global thisCapturing;
global f;
global v2;
global rootScope;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function basics);       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'basics');          // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function makeIncrementorA); // 2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'makeIncrementorA'); // 1                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function makeIncrementorA2); // 2            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'makeIncrementorA2'); // 1               ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function makeIncrementorB); // 2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'makeIncrementorB'); // 1                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function makeIncrementorC); // 2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'makeIncrementorC'); // 1                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function nestedLexicalScopes); // 2          ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'nestedLexicalScopes'); // 1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function differentVariableTypes); // 2       ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'differentVariableTypes'); // 1          ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function closureOperations); // 2            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'closureOperations'); // 1               ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function thisCapturing); // 2                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'thisCapturing');   // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    Literal(lit &function rootScope);    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    StoreGlobal(name 'rootScope');       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:1:1
    // ---
    // runExportedFunction: 0
    // assertionCount: 35
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:6:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:6:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:6:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:6:13
    Call(count 3, flag true);            // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:6:13
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:200:5
    StoreGlobal(name 'f');               // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:200:5
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:201:10
    StoreGlobal(name 'v1');              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:201:10
    Literal(lit 2);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:202:10
    StoreGlobal(name 'v2');              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:202:10
    // A block
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:205:12
    StoreScoped(index 1);                // 1  v3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:205:12
    Literal(lit 4);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:206:12
    StoreGlobal(name 'v4');              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:206:12
    // Variables at the root level are compiled differently to variables at the
    // block level, so this is just checking that both work ok. `v1` and `v2` will
    // be promoted to global variables because they're accessed by a nested
    // function. `v4` will also be a global, because it's hoisted into the same
    // scope. `v3` will be a closure slot in the context of the entry function.
    Literal(lit &function anonymous14);  // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:212:7
    StoreScoped(index 0);                // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:212:7
    LoadReg(name 'closure');             // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:212:7
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:212:7
    StoreGlobal(name 'f');               // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:212:7
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:212:7
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:219:1
    Return();                            // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:219:1
}

function run() {
  entry:
    LoadGlobal(name 'basics');           // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:9:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:9:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:9:3
    LoadGlobal(name 'nestedLexicalScopes'); // 1              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:10:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:10:3
    LoadGlobal(name 'differentVariableTypes'); // 1           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:11:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:11:3
    LoadGlobal(name 'closureOperations'); // 1                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:12:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:12:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:12:3
    LoadGlobal(name 'thisCapturing');    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:13:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:13:3
    LoadGlobal(name 'rootScope');        // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:14:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:14:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:15:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:15:2
}

function basics() {
  entry:
    Literal(lit deleted);                // 1  incrementor1   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:17:19
    Literal(lit deleted);                // 2  incrementor2   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:17:19
    Literal(lit deleted);                // 3  incrementor3   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:17:19
    Literal(lit deleted);                // 4  incrementor4   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:17:19
    Literal(lit deleted);                // 5  incrementorC   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:17:19
    LoadGlobal(name 'makeIncrementorA'); // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:18:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:18:24
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:18:24
    StoreVar(index 0);                   // 5  incrementor1   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:18:24
    LoadGlobal(name 'makeIncrementorA'); // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:19:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:19:24
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:19:24
    StoreVar(index 1);                   // 5  incrementor2   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:19:24
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:20:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:20:3
    LoadVar(index 0);                    // 8  incrementor1   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:20:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:20:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:20:15
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:20:31
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:20:31
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:21:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:21:3
    LoadVar(index 0);                    // 8  incrementor1   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:21:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:21:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:21:15
    Literal(lit 2);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:21:31
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:21:31
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:22:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:22:3
    LoadVar(index 1);                    // 8  incrementor2   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:22:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:22:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:22:15
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:22:31
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:22:31
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:23:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:23:3
    LoadVar(index 1);                    // 8  incrementor2   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:23:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:23:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:23:15
    Literal(lit 2);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:23:31
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:23:31
    LoadGlobal(name 'makeIncrementorA2'); // 6                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:25:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:25:24
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:25:24
    StoreVar(index 2);                   // 5  incrementor3   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:25:24
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:26:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:26:3
    LoadVar(index 2);                    // 8  incrementor3   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:26:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:26:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:26:15
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:26:31
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:26:31
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:27:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:27:3
    LoadVar(index 2);                    // 8  incrementor3   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:27:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:27:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:27:15
    Literal(lit 2);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:27:31
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:27:31
    LoadGlobal(name 'makeIncrementorB'); // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:29:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:29:24
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:29:24
    StoreVar(index 3);                   // 5  incrementor4   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:29:24
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:30:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:30:3
    LoadVar(index 3);                    // 8  incrementor4   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:30:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:30:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:30:15
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:30:31
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:30:31
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:31:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:31:3
    LoadVar(index 3);                    // 8  incrementor4   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:31:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:31:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:31:15
    Literal(lit 2);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:31:31
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:31:31
    LoadGlobal(name 'makeIncrementorC'); // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:33:24
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:33:24
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:33:24
    StoreVar(index 4);                   // 5  incrementorC   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:33:24
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:3
    LoadVar(index 4);                    // 8  incrementorC   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:15
    Literal(lit 1);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:33
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:34:33
    LoadGlobal(name 'assertEqual');      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:3
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:3
    LoadVar(index 4);                    // 8  incrementorC   ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:15
    Literal(lit undefined);              // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:15
    Call(count 1, flag false);           // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:15
    Literal(lit 2);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:33
    Call(count 3, flag true);            // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:35:33
    Pop(count 5);                        // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:36:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:36:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:36:2
}

function makeIncrementorA() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:38:1
    Literal(lit 0);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:39:11
    StoreScoped(index 1);                // 0  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:39:11
    // Arrow function
    Literal(lit &function anonymous);    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:10
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:10
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:10
    // Arrow function
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:3
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:16
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:16
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:16
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:16
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:16
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:41:16
}

function makeIncrementorA2() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:44:1
    Literal(lit 0);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:45:11
    StoreScoped(index 1);                // 0  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:45:11
    // Function expression (note that we do not support named function expressions, yet)
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:10
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:10
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:10
    // Function expression (note that we do not support named function expressions, yet)
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:3
}

function anonymous1() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:30
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:30
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:30
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:30
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:30
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:47:23
}

function makeIncrementorB() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:50:1
    Literal(lit &function increment);    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:50:29
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:50:29
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:50:29
    Literal(lit 0);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:51:11
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:51:11
    LoadVar(index 0);                    // 2  increment      ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:52:10
    Return();                            // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:52:3
}

// Function declaration
function increment() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:55:12
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:55:12
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:55:12
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:55:12
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:55:12
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:55:5
}

// Double-nested functions
function makeIncrementorC() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:60:1
    Literal(lit 0);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:61:11
    StoreScoped(index 1);                // 0  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:61:11
    // The inner-most function doesn't access its direct outer scope. It accesses
    // its grandparent scope.
    Literal(lit &function anonymous2);   // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:10
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:10
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:10
    // The inner-most function doesn't access its direct outer scope. It accesses
    // its grandparent scope.
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:3
}

function anonymous2() {
  entry:
    ScopePush(count 2);                  // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:10
    Literal(lit &function anonymous3);   // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:16
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:16
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:16
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:16
}

function anonymous3() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:22
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:22
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:22
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:22
    StoreScoped(index 3);                // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:22
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:64:22
}

function nestedLexicalScopes() {
  entry:
    ScopeNew(count 4);                   // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:67:1
    Literal(lit deleted);                // 1  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:67:32
    Literal(lit deleted);                // 2  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:67:32
    Literal(lit deleted);                // 3  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:67:32
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:68:11
    StoreScoped(index 1);                // 3  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:68:11
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:69:7
    StoreVar(index 0);                   // 3  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:69:7
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:70:7
    StoreVar(index 1);                   // 3  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:70:7
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:71:7
    StoreVar(index 2);                   // 3  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:71:7
    Literal(lit 50);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:73:13
    StoreScoped(index 2);                // 3  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:73:13
    Literal(lit &function anonymous4);   // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:10
    StoreScoped(index 0);                // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:10
    LoadReg(name 'closure');             // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:10
    StoreVar(index 0);                   // 4  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:10
    Literal(lit 100);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:77:13
    StoreScoped(index 3);                // 3  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:77:13
    Literal(lit &function anonymous5);   // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:10
    ClosureNew();                        // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:10
    StoreVar(index 1);                   // 4  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:10
    Literal(lit &function anonymous6);   // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:8
    ClosureNew();                        // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:8
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:8
    StoreVar(index 2);                   // 4  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:8
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:8
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:81:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:81:3
    LoadVar(index 0);                    // 6  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:81:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:81:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:81:15
    Literal(lit 50);                     // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:81:21
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:81:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:82:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:82:3
    LoadVar(index 0);                    // 6  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:82:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:82:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:82:15
    Literal(lit 51);                     // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:82:21
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:82:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:83:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:83:3
    LoadVar(index 1);                    // 6  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:83:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:83:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:83:15
    Literal(lit 100);                    // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:83:21
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:83:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:84:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:84:3
    LoadVar(index 1);                    // 6  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:84:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:84:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:84:15
    Literal(lit 101);                    // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:84:21
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:84:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:85:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:85:3
    LoadVar(index 2);                    // 6  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:85:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:85:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:85:15
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:85:21
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:85:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:86:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:86:3
    LoadVar(index 2);                    // 6  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:86:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:86:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:86:15
    Literal(lit 2);                      // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:86:21
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:86:21
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:87:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:87:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:87:2
}

function anonymous4() {
  entry:
    LoadScoped(index 2);                 // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:16
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:16
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:16
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:16
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:16
    StoreScoped(index 2);                // 2  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:16
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:16
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:74:16
}

function anonymous5() {
  entry:
    LoadScoped(index 5);                 // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:16
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:16
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:16
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:16
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:16
    StoreScoped(index 5);                // 2  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:16
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:16
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:78:16
}

function anonymous6() {
  entry:
    LoadScoped(index 3);                 // 1  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:14
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:14
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:14
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:14
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:14
    StoreScoped(index 3);                // 2  x              ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:14
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:14
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:80:14
}

function differentVariableTypes() {
  entry:
    Literal(lit deleted);                // 1  foo            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:89:35
    Literal(lit deleted);                // 2  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:89:35
    Literal(lit deleted);                // 3  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:89:35
    Literal(lit deleted);                // 4  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:89:35
    Literal(lit &function anonymous7);   // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    StoreVar(index 0);                   // 4  foo            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    LoadVar(index 0);                    // 5  foo            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:144:14
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:144:14
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:144:18
    Literal(lit 2);                      // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:144:21
    Literal(lit 3);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:144:24
    Call(count 4, flag false);           // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:144:24
    StoreVar(index 1);                   // 4  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:144:24
    LoadVar(index 1);                    // 5  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:145:14
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:145:14
    Literal(lit 4);                      // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:145:17
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:145:20
    Literal(lit 6);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:145:23
    Call(count 4, flag false);           // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:145:23
    StoreVar(index 2);                   // 4  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:145:23
    LoadVar(index 1);                    // 5  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:146:14
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:146:14
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:146:17
    Literal(lit 8);                      // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:146:20
    Literal(lit 9);                      // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:146:23
    Call(count 4, flag false);           // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:146:23
    StoreVar(index 3);                   // 4  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:146:23
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:3
    LoadVar(index 2);                    // 7  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:15
    Literal(lit 10);                     // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:18
    Literal(lit 11);                     // 10                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:22
    Literal(lit 12);                     // 11                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:26
    Call(count 4, flag false);           // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:26
    Literal(lit 2971);                   // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:31
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:147:31
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:3
    LoadVar(index 2);                    // 7  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:15
    Literal(lit 13);                     // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:18
    Literal(lit 14);                     // 10                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:22
    Literal(lit 15);                     // 11                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:26
    Call(count 4, flag false);           // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:26
    Literal(lit 3415);                   // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:31
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:148:31
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:3
    LoadVar(index 2);                    // 7  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:15
    Literal(lit 16);                     // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:18
    Literal(lit 17);                     // 10                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:22
    Literal(lit 19);                     // 11                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:26
    Call(count 4, flag false);           // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:26
    Literal(lit 3918);                   // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:31
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:149:31
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:3
    LoadVar(index 3);                    // 7  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:15
    Literal(lit 19);                     // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:18
    Literal(lit 20);                     // 10                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:22
    Literal(lit 21);                     // 11                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:26
    Call(count 4, flag false);           // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:26
    Literal(lit 3838);                   // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:31
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:150:31
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:3
    LoadVar(index 3);                    // 7  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:15
    Literal(lit 22);                     // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:18
    Literal(lit 23);                     // 10                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:22
    Literal(lit 24);                     // 11                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:26
    Call(count 4, flag false);           // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:26
    Literal(lit 4282);                   // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:31
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:151:31
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:3
    LoadVar(index 3);                    // 7  f3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:15
    Literal(lit 25);                     // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:18
    Literal(lit 26);                     // 10                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:22
    Literal(lit 27);                     // 11                ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:26
    Call(count 4, flag false);           // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:26
    Literal(lit 4726);                   // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:31
    Call(count 3, flag true);            // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:152:31
    Pop(count 4);                        // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:153:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:153:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:153:2
}

function anonymous7() {
  entry:
    ScopeNew(count 9);                   // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    LoadArg(index 1);                    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    LoadArg(index 3);                    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    StoreScoped(index 2);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    StoreScoped(index 3);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    StoreScoped(index 4);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:90:15
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:95:16
    StoreScoped(index 5);                // 0  x4             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:95:16
    // const
    Literal(lit 6);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:96:14
    StoreScoped(index 3);                // 0  x5             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:96:14
    // var
    Literal(lit 7);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:97:14
    StoreScoped(index 6);                // 0  x6             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:97:14
    // let
    // New block scope
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:100:18
    StoreScoped(index 7);                // 0  x7             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:100:18
    // const
    Literal(lit 6);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:101:16
    StoreScoped(index 4);                // 0  x8             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:101:16
    // var
    Literal(lit 7);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:102:16
    StoreScoped(index 8);                // 0  x9             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:102:16
    // bar
    Literal(lit &function anonymous8);   // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    // let
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:7
}

function anonymous8() {
  entry:
    ScopePush(count 10);                 // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    LoadArg(index 1);                    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    LoadArg(index 3);                    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    StoreScoped(index 2);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    StoreScoped(index 3);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    StoreScoped(index 4);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:103:24
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:108:21
    StoreScoped(index 5);                // 0  x13            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:108:21
    // const
    Literal(lit 6);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:109:19
    StoreScoped(index 3);                // 0  x14            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:109:19
    // var
    Literal(lit 7);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:110:19
    StoreScoped(index 6);                // 0  x15            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:110:19
    // let
    // New block scope
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:113:23
    StoreScoped(index 7);                // 0  x16            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:113:23
    // const
    Literal(lit 6);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:114:21
    StoreScoped(index 4);                // 0  x17            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:114:21
    // var
    Literal(lit 7);                      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:115:21
    StoreScoped(index 8);                // 0  x18            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:115:21
    // baz
    Literal(lit &function anonymous9);   // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:116:28
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:116:28
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:116:28
    // let
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:116:11
}

function anonymous9() {
  entry:
    LoadArg(index 3);                    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:116:28
    Literal(lit 0);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:121:13
    LoadScoped(index 11);                // 3  x1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:122:17
    Literal(lit 2);                      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:122:22
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:122:22
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:122:22
    LoadScoped(index 12);                // 3  x3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:17
    StoreScoped(index 12);               // 4  x3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:17
    Literal(lit 3);                      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:24
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:24
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:123:24
    LoadScoped(index 15);                // 3  x4             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:124:17
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:124:22
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:124:22
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:124:22
    LoadScoped(index 13);                // 3  x5             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:17
    StoreScoped(index 13);               // 4  x5             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:17
    Literal(lit 7);                      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:24
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:24
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:125:24
    LoadScoped(index 16);                // 3  x6             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:17
    StoreScoped(index 16);               // 4  x6             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:17
    Literal(lit 11);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:24
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:24
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:126:24
    LoadScoped(index 17);                // 3  x7             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:127:17
    Literal(lit 13);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:127:22
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:127:22
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:127:22
    LoadScoped(index 14);                // 3  x8             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:17
    StoreScoped(index 14);               // 4  x8             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:17
    Literal(lit 17);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:24
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:24
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:128:24
    LoadScoped(index 18);                // 3  x9             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:17
    StoreScoped(index 18);               // 4  x9             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:17
    Literal(lit 19);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:24
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:24
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:129:24
    LoadScoped(index 1);                 // 3  x10            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:130:17
    Literal(lit 23);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:130:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:130:23
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:130:23
    LoadScoped(index 2);                 // 3  x12            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:17
    StoreScoped(index 2);                // 4  x12            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:17
    Literal(lit 29);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:25
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:25
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:131:25
    LoadScoped(index 5);                 // 3  x13            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:132:17
    Literal(lit 31);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:132:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:132:23
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:132:23
    LoadScoped(index 3);                 // 3  x14            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:17
    StoreScoped(index 3);                // 4  x14            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:17
    Literal(lit 37);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:25
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:25
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:133:25
    LoadScoped(index 6);                 // 3  x15            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:17
    StoreScoped(index 6);                // 4  x15            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:17
    Literal(lit 41);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:25
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:25
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:134:25
    LoadScoped(index 7);                 // 3  x16            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:135:17
    Literal(lit 43);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:135:23
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:135:23
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:135:23
    LoadScoped(index 4);                 // 3  x17            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:17
    StoreScoped(index 4);                // 4  x17            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:17
    Literal(lit 47);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:25
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:25
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:136:25
    LoadScoped(index 8);                 // 3  x18            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:17
    StoreScoped(index 8);                // 4  x18            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:17
    Literal(lit 53);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:25
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:25
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:137:25
    LoadArg(index 1);                    // 3  x19            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:138:17
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:138:17
    LoadVar(index 0);                    // 3  x21            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:17
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:17
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:17
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:17
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:17
    StoreVar(index 0);                   // 4  x21            ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:17
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:17
    Literal(lit 59);                     // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:25
    BinOp(op '*');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:25
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:25
    Return();                            // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:139:25
}

function closureOperations() {
  entry:
    Literal(lit deleted);                // 1  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:155:30
    Literal(lit deleted);                // 2  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:155:30
    Literal(lit &function anonymous10);  // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:156:14
    StoreVar(index 0);                   // 2  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:156:14
    Literal(lit &function anonymous11);  // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:157:14
    StoreVar(index 1);                   // 2  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:157:14
    // Check equality operator
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:160:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:160:3
    LoadVar(index 0);                    // 5  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:160:15
    LoadVar(index 0);                    // 6  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:160:22
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:160:22
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:160:26
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:160:26
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:161:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:161:3
    LoadVar(index 0);                    // 5  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:161:15
    LoadVar(index 1);                    // 6  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:161:22
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:161:22
    Literal(lit false);                  // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:161:26
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:161:26
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:162:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:162:3
    LoadVar(index 0);                    // 5  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:162:15
    LoadVar(index 0);                    // 6  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:162:22
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:162:22
    Literal(lit false);                  // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:162:26
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:162:26
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:163:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:163:3
    LoadVar(index 0);                    // 5  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:163:15
    LoadVar(index 1);                    // 6  f2             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:163:22
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:163:22
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:163:26
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:163:26
    // Other operations
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:166:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:166:3
    LoadVar(index 0);                    // 5  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:166:15
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:166:20
    BinOp(op '|');                       // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:166:20
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:166:23
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:166:23
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:10
    LoadGlobal(name 'Number');           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:10
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:10
    Literal(lit 'isNaN');                // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:10
    ObjectGet();                         // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:10
    StoreVar(index 4);                   // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:10
    LoadVar(index 0);                    // 7  f1             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:24
    UnOp(op '+');                        // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:24
    Call(count 2, flag false);           // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:24
    Call(count 2, flag true);            // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:167:24
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:170:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:170:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:170:2
}

function anonymous10() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:156:22
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:156:22
}

function anonymous11() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:157:22
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:157:22
}

function thisCapturing() {
  entry:
    ScopeNew(count 2);                   // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:172:1
    Literal(lit &function printMe1);     // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:172:26
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:172:26
    Literal(lit &function getObj2);      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:172:26
    StoreScoped(index 0);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:172:26
    LoadReg(name 'closure');             // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:172:26
    Literal(lit deleted);                // 2  obj1           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:172:26
    Literal(lit deleted);                // 3  obj2           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:172:26
    ObjectNew();                         // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:186:16
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:186:16
    Literal(lit 'printMe1');             // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:186:16
    LoadScoped(index 1);                 // 7  printMe1       ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:187:5
    ObjectSet();                         // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:187:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:187:5
    Literal(lit 'getObj2');              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:187:5
    LoadVar(index 0);                    // 7  getObj2        ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:188:5
    ObjectSet();                         // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:188:5
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:188:5
    Literal(lit 'me');                   // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:188:5
    Literal(lit 'obj1');                 // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:189:9
    ObjectSet();                         // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:189:9
    StoreVar(index 1);                   // 3  obj1           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:189:9
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:192:16
    LoadVar(index 1);                    // 5  obj1           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:192:16
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:192:16
    Literal(lit 'getObj2');              // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:192:16
    ObjectGet();                         // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:192:16
    StoreVar(index 3);                   // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:192:16
    Call(count 1, flag false);           // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:192:16
    StoreVar(index 2);                   // 3  obj2           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:192:16
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:15
    LoadVar(index 1);                    // 7  obj1           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:15
    Literal(lit 'printMe1');             // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:15
    ObjectGet();                         // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:15
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:15
    Literal(lit 'obj1');                 // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:32
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:194:32
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:15
    LoadVar(index 2);                    // 7  obj2           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:15
    Literal(lit 'printMe1');             // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:15
    ObjectGet();                         // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:15
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:15
    Literal(lit 'obj2');                 // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:32
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:195:32
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:15
    LoadVar(index 2);                    // 7  obj2           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:15
    Literal(lit 'printMe2');             // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:15
    ObjectGet();                         // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:15
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:15
    Literal(lit 'obj1');                 // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:32
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:196:32
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:15
    LoadVar(index 2);                    // 7  obj2           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:15
    LoadVar(index 6);                    // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:15
    Literal(lit 'printMe3');             // 9                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:15
    ObjectGet();                         // 8                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:15
    StoreVar(index 5);                   // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:15
    Call(count 1, flag false);           // 6                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:15
    Literal(lit 'obj2');                 // 7                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:32
    Call(count 3, flag true);            // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:197:32
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:198:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:198:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:198:2
}

function printMe1() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:174:12
    Literal(lit 'me');                   // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:174:12
    ObjectGet();                         // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:174:12
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:174:5
}

function getObj2() {
  entry:
    ScopePush(count 3);                  // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:177:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:177:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:177:3
    ObjectNew();                         // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:178:12
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:178:12
    Literal(lit 'printMe1');             // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:178:12
    LoadScoped(index 4);                 // 4  printMe1       ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:179:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:179:7
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:179:7
    Literal(lit 'printMe2');             // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:179:7
    Literal(lit &function anonymous12);  // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:17
    StoreScoped(index 0);                // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:17
    LoadReg(name 'closure');             // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:17
    ObjectSet();                         // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:17
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:17
    Literal(lit 'printMe3');             // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:17
    Literal(lit &function anonymous13);  // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:181:17
    ObjectSet();                         // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:181:17
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:181:17
    Literal(lit 'me');                   // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:181:17
    Literal(lit 'obj2');                 // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:182:11
    ObjectSet();                         // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:182:11
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:178:5
}

function anonymous12() {
  entry:
    // obj1
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:32
    Literal(lit 'me');                   // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:32
    ObjectGet();                         // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:32
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:180:32
}

function anonymous13() {
  entry:
    // obj2
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:181:46
    Literal(lit 'me');                   // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:181:46
    ObjectGet();                         // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:181:46
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:181:30
}

function anonymous14() {
  entry:
    Literal(lit 1000);                   // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:5
    LoadGlobal(name 'v1');               // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:12
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:12
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:12
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:12
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:12
    StoreGlobal(name 'v1');              // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:12
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:12
    BinOp(op '*');                       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:213:12
    Literal(lit 100);                    // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:5
    LoadGlobal(name 'v2');               // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    StoreGlobal(name 'v2');              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    BinOp(op '*');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:214:11
    Literal(lit 10);                     // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:5
    LoadScoped(index 1);                 // 3  v3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    StoreScoped(index 1);                // 4  v3             ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    BinOp(op '*');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:215:10
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:5
    LoadGlobal(name 'v4');               // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    StoreGlobal(name 'v4');              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    BinOp(op '*');                       // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:216:9
}

function rootScope() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:220:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:220:3
    LoadGlobal(name 'f');                // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:220:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:220:15
    Call(count 1, flag false);           // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:220:15
    Literal(lit 1234);                   // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:220:20
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:220:20
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:221:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:221:3
    LoadGlobal(name 'f');                // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:221:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:221:15
    Call(count 1, flag false);           // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:221:15
    Literal(lit 2345);                   // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:221:20
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:221:20
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:222:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:222:3
    LoadGlobal(name 'f');                // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:222:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:222:15
    Call(count 1, flag false);           // 3                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:222:15
    Literal(lit 3456);                   // 4                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:222:20
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:222:20
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:223:2
    Return();                            // 0                 ./test/end-to-end/tests/closures-and-scopes.test.mvm.js:223:2
}