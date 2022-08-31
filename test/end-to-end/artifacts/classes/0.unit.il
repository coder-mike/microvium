unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

global thisModule;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit deleted);                // 1                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit deleted);                // 2                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    // ---
    // description: >
    // Testing support for classes
    // #runExportedFunction: 0 WIP
    // #assertionCount: 40 WIP
    // testOnly: true
    // ---
    // vmExport(0, run);
    // function run() {
    // // test_globalClass();
    // // test_globalInstance();
    // // test_localClass();
    // // test_inheritedProperties();
    // // test_proto();
    // // test_returnFromConstructor();
    // // test_operators();
    // // test_classAsMember();
    // // test_closingOverClass();
    // // test_closureInConstructor();
    // }
    Literal(lit 'my');                   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:25:11
    StoreVar(index 0);                   // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:25:11
    Literal(lit &function GlobalClass);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:27:1
    ClassCreate();                       // 3  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:27:1
    StoreVar(index 1);                   // 2  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:27:1
    LoadVar(index 1);                    // 3  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:27:1
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    LoadVar(index 4);                    // 6  GlobalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:27:1
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    Literal(lit &function GlobalClass_myMethod); // 8         ./test/end-to-end/tests/classes.test.mvm.js:27:1
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    LoadVar(index 1);                    // 3  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:29:3
    Literal(lit 'myStaticMethod');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    Literal(lit &function GlobalClass_myStaticMethod); // 5   ./test/end-to-end/tests/classes.test.mvm.js:29:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    Return();                            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
}

function GlobalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:28:29
    Literal(lit 5);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:28:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:28:33
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:28:20
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:28:20
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:28:20
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:28:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:28:20
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:28:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:28:36
}

function GlobalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:29:25
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:29:25
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:29:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:29:25
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:29:25
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:29:25
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:29:25
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:29:25
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:29:25
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:29:25
}

function GlobalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:30:39
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:39
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:39
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:39
    Branch(@block2, @block1);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:39
  block1:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:30:39
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:49
    Jump(@block2);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:49
  block2:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:54
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:54
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:30:29
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:30:29
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:30:29
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:30:29
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:30:64
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:64
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:64
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:30:64
}