unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external assert from free-variable 'assert';
external Microvium from free-variable 'Microvium';
external Number from free-variable 'Number';
external undefined from free-variable 'undefined';

global thisModule;
global x;
global GlobalClass;
global globalInst;
global test_globalClass;
global test_globalInstance;
global test_localClass;
global test_inheritedProperties;
global test_proto;
global test_returnFromConstructor;
global test_operators;
global test_classAsMember;
global test_closingOverClass;
global test_closureInConstructor;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_globalClass); // 2             ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_globalClass'); // 1                ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_globalInstance); // 2          ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_globalInstance'); // 1             ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_localClass); // 2              ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_localClass'); // 1                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_inheritedProperties); // 2     ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_inheritedProperties'); // 1        ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_proto);   // 2                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_proto');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_returnFromConstructor); // 2   ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_returnFromConstructor'); // 1      ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_operators); // 2               ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_operators');  // 1                 ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_classAsMember); // 2           ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_classAsMember'); // 1              ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_closingOverClass); // 2        ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_closingOverClass'); // 1           ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_closureInConstructor); // 2    ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_closureInConstructor'); // 1       ./test/end-to-end/tests/classes.test.mvm.js:1:1
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // #assertionCount: 40 WIP
    // testOnly: true
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:10:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Literal(lit 'my');                   // 2                 ./test/end-to-end/tests/classes.test.mvm.js:25:11
    StoreGlobal(name 'x');               // 1                 ./test/end-to-end/tests/classes.test.mvm.js:25:11
    Literal(lit &function GlobalClass);  // 2                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/classes.test.mvm.js:27:1
    ClassCreate();                       // 2  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:27:1
    StoreGlobal(name 'GlobalClass');     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    LoadVar(index 3);                    // 5  GlobalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:27:1
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:27:1
    Literal(lit &function GlobalClass_myMethod); // 7         ./test/end-to-end/tests/classes.test.mvm.js:27:1
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    Literal(lit 'myStaticMethod');       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    Literal(lit &function GlobalClass_myStaticMethod); // 4   ./test/end-to-end/tests/classes.test.mvm.js:29:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    Literal(lit 42);                     // 2                 ./test/end-to-end/tests/classes.test.mvm.js:32:22
    LoadGlobal(name 'GlobalClass');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    Literal(lit 'myProp');               // 4                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:34:24
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:34:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:34:36
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:34:36
    StoreGlobal(name 'globalInst');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:34:36
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:159:1
    Return();                            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:159:1
}

function run() {
  entry:
    LoadGlobal(name 'test_globalClass'); // 1                 ./test/end-to-end/tests/classes.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:13:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:13:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:13:3
    LoadGlobal(name 'test_globalInstance'); // 1              ./test/end-to-end/tests/classes.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:14:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:14:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:14:3
    LoadGlobal(name 'test_localClass');  // 1                 ./test/end-to-end/tests/classes.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:15:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:15:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:15:3
    LoadGlobal(name 'test_inheritedProperties'); // 1         ./test/end-to-end/tests/classes.test.mvm.js:16:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:16:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:16:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:16:3
    LoadGlobal(name 'test_proto');       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:17:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:17:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:17:3
    LoadGlobal(name 'test_returnFromConstructor'); // 1       ./test/end-to-end/tests/classes.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:18:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:18:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:18:3
    LoadGlobal(name 'test_operators');   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:19:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:19:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:19:3
    LoadGlobal(name 'test_classAsMember'); // 1               ./test/end-to-end/tests/classes.test.mvm.js:20:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:20:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:20:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:20:3
    LoadGlobal(name 'test_closingOverClass'); // 1            ./test/end-to-end/tests/classes.test.mvm.js:21:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:21:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:21:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:21:3
    LoadGlobal(name 'test_closureInConstructor'); // 1        ./test/end-to-end/tests/classes.test.mvm.js:22:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:22:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:22:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:22:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:23:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:23:2
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

function test_globalClass() {
  entry:
    Literal(lit deleted);                // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:36:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:37:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:37:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:37:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:37:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:37:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:37:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:37:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:37:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:37:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:38:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:38:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:38:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:38:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:39:35
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:35
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:35
    // Accessing instance created at runtime of a class created at compile time
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:42:20
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:42:20
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:42:32
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:42:32
    StoreVar(index 0);                   // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:42:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:43:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:43:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:43:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    Literal(lit 25);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:43:23
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:43:23
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:43:23
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:44:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:44:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Literal(lit 26);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:44:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:45:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:45:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:45:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Literal(lit 27);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:45:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:45:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:46:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:46:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:46:2
}

function test_globalInstance() {
  entry:
    Literal(lit deleted);                // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:48:32
    Literal(lit 'ethod');                // 2                 ./test/end-to-end/tests/classes.test.mvm.js:49:13
    StoreVar(index 0);                   // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:49:13
    // Accessing instance constructed at compile time at the global scope
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:51:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:51:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    Literal(lit 15);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:51:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:51:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:51:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:52:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:52:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:53:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:53:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:53:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:53:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:54:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    LoadGlobal(name 'x');                // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:26
    Literal(lit 'M');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:54:30
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:30
    LoadVar(index 0);                    // 7  y              ./test/end-to-end/tests/classes.test.mvm.js:54:36
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:36
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:36
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:36
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:36
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:54:36
    Literal(lit 18);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:42
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:42
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:54:42
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:55:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:55:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:55:2
}

function test_localClass() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:57:28
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:57:28
    Literal(lit &function LocalClass);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:58:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:58:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:58:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:58:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:58:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:58:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:58:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:58:3
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:58:3
    Literal(lit &function LocalClass_myMethod); // 8          ./test/end-to-end/tests/classes.test.mvm.js:58:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:60:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:60:5
    Literal(lit 'myStaticMethod');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:60:5
    Literal(lit &function LocalClass_myStaticMethod); // 5    ./test/end-to-end/tests/classes.test.mvm.js:60:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:63:23
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:63:3
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:65:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:65:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:65:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:65:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:65:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:65:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:65:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:65:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:65:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:65:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:65:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:65:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:66:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:66:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:66:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:66:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:66:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:66:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:67:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:67:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:67:15
    Literal(lit 'myProp');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:67:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:67:15
    Literal(lit 42);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:67:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:67:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:67:34
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:69:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:69:20
    Literal(lit 30);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:69:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:69:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:69:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:70:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:70:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:70:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:70:15
    Literal(lit 37);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:70:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:71:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:71:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:71:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    Literal(lit 39);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:71:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:71:32
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:72:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Literal(lit 40);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:72:32
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:73:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:73:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:73:2
}

function LocalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:59:31
    Literal(lit 7);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:59:35
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:59:35
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:59:22
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:59:22
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:59:22
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:59:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:59:22
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:59:38
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:59:38
}

function LocalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:60:27
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:27
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:27
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:60:27
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:60:27
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:60:27
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:36
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:60:36
}

function LocalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:61:41
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:41
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:41
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:41
    Branch(@block4, @block3);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:41
  block3:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:61:41
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:51
    Jump(@block4);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:51
  block4:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:56
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:56
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:61:31
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:61:31
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:61:31
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:61:66
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:66
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:66
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:61:66
}

function test_inheritedProperties() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:75:37
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:75:37
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:75:37
    Literal(lit &function LocalClass1);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:81:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:81:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:81:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:81:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:82:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:82:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:84:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:84:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:84:21
    StoreVar(index 1);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:84:21
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:85:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:85:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:85:21
    StoreVar(index 2);                   // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:85:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:87:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:87:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:87:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:87:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:87:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:87:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:87:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:87:24
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:88:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:88:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:88:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:88:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:88:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:88:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:90:13
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:90:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:91:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:93:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:93:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:93:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:93:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:93:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:93:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:93:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:93:24
    // instance property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:94:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:94:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:94:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:94:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:94:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    // prototype property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:95:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:95:19
    New(count 1);                        // 6                 ./test/end-to-end/tests/classes.test.mvm.js:95:19
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:95:19
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:95:19
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:95:35
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:95:35
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:96:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:96:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:96:2
}

// * The objective of this test is to confirm that properties on the prototype
   * can be overridden in instances without affecting the prototype.
function LocalClass1() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
}

function test_proto() {
  entry:
    Literal(lit deleted);                // 1  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:98:23
    Literal(lit deleted);                // 2  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:98:23
    Literal(lit deleted);                // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:98:23
    Literal(lit &function LocalClass2);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:99:3
    ClassCreate();                       // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:99:3
    StoreVar(index 0);                   // 3  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:99:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:99:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    Literal(lit &function LocalClass3);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ClassCreate();                       // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:100:3
    StoreVar(index 1);                   // 3  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:100:3
    LoadVar(index 1);                    // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:101:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:101:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:101:21
    StoreVar(index 2);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:101:21
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:102:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:102:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:102:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:102:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:102:10
    LoadVar(index 0);                    // 7  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:102:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:102:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:102:30
    BinOp(op '===');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:102:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:102:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:102:30
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:103:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:103:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:103:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:103:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:103:10
    LoadVar(index 1);                    // 7  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:103:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    BinOp(op '!==');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:104:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:104:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:104:2
}

function LocalClass2() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
}

function LocalClass3() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
}

function test_returnFromConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:106:39
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:106:39
    Literal(lit &function LocalClass4);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:111:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:111:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:111:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:111:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:111:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:111:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:111:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:111:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:114:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:114:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:114:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:114:20
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:115:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:115:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:115:10
    Literal(lit '__proto__');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:115:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:115:10
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:115:29
    Literal(lit 'prototype');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:115:29
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:115:29
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:115:29
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:115:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:115:29
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:116:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:116:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:116:10
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:116:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:116:10
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:116:21
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:116:21
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:116:21
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:116:21
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:117:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:117:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:117:2
}

// I don't expect anyone to use this edge case, but Microvium happens to
// support it because a return statement in a constructor is just handled as a
// normal return.
function LocalClass4() {
  entry:
    ObjectNew();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:112:28
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:112:28
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:112:28
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:112:33
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:112:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:112:33
}

function test_operators() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:119:27
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:119:27
    Literal(lit &function LocalClass5);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:120:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:120:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:120:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:120:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:121:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:121:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:121:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:121:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:122:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:122:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:122:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:122:22
    Literal(lit 'function');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:122:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:122:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:122:34
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:123:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:123:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:123:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:123:22
    Literal(lit 'object');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:123:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:123:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:123:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:124:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:124:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:124:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:124:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:124:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:124:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:124:15
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:124:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:124:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:124:36
    Literal(lit 9);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:124:49
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:124:49
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:124:49
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:125:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:36
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:43
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:43
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:125:43
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:126:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:126:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:126:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:126:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:126:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:126:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:126:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:126:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:127:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:127:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:127:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:127:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:127:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:127:23
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:128:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:128:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:128:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:128:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:128:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:128:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:128:10
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:128:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:128:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:128:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:128:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:128:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:128:24
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:129:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:130:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:130:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:130:2
}

function LocalClass5() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
}

function test_classAsMember() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:132:31
    Literal(lit deleted);                // 2  obj            ./test/end-to-end/tests/classes.test.mvm.js:132:31
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:132:31
    Literal(lit &function LocalClass6);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:133:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:133:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:133:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:133:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    LoadVar(index 5);                    // 7  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:133:3
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    Literal(lit &function LocalClass_foo); // 9               ./test/end-to-end/tests/classes.test.mvm.js:133:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:135:5
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:138:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:138:15
    Literal(lit 'LocalClass');           // 6                 ./test/end-to-end/tests/classes.test.mvm.js:138:15
    LoadVar(index 0);                    // 7  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:138:17
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:138:17
    StoreVar(index 1);                   // 3  obj            ./test/end-to-end/tests/classes.test.mvm.js:138:17
    LoadVar(index 1);                    // 4  obj            ./test/end-to-end/tests/classes.test.mvm.js:139:20
    Literal(lit 'LocalClass');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:139:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:139:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:139:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:139:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:139:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:140:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:140:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:140:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:140:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:140:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:140:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:140:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:140:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:141:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:141:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:141:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:141:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:141:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:141:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:141:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:141:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:141:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:141:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:141:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:141:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:142:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:142:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:142:2
}

function LocalClass6() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:134:30
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:134:21
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:21
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:134:21
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:134:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:134:21
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:134:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:134:33
}

function LocalClass_foo() {
  entry:
    Literal(lit 10);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:135:20
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:135:20
}

function test_closingOverClass() {
  entry:
    Literal(lit &function inner);        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:144:34
    Literal(lit deleted);                // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:144:34
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:144:34
    LoadVar(index 0);                    // 4  inner          ./test/end-to-end/tests/classes.test.mvm.js:153:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:153:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:153:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:153:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:153:22
    StoreVar(index 1);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:153:22
    LoadVar(index 1);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:154:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:154:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:154:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:154:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:155:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:155:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:155:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:155:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:155:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:155:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:155:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:155:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:156:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:156:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:156:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:156:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:156:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:156:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:156:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:156:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:156:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:156:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:156:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:156:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:157:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:157:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:157:2
}

function inner() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:145:3
    Literal(lit &function LocalClass7);  // 1                 ./test/end-to-end/tests/classes.test.mvm.js:146:5
    ObjectNew();                         // 2  static props   ./test/end-to-end/tests/classes.test.mvm.js:146:5
    ClassCreate();                       // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:146:5
    StoreScoped(index 1);                // 0  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:146:5
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:146:5
    Literal(lit 'prototype');            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:146:5
    ObjectNew();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:146:5
    LoadVar(index 2);                    // 4  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:146:5
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:146:5
    Literal(lit &function LocalClass_foo1); // 6              ./test/end-to-end/tests/classes.test.mvm.js:146:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:148:7
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:148:7
    Literal(lit &function anonymous);    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:150:12
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:150:12
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:150:12
}

function LocalClass7() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:147:32
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:147:23
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:147:23
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:147:23
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:147:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:147:23
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:147:35
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:147:35
}

function LocalClass_foo1() {
  entry:
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:148:22
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:148:22
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:150:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:150:18
}

function test_closureInConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:159:38
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:159:38
    Literal(lit &function LocalClass8);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:160:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:160:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:160:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:160:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:160:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:160:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:160:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:160:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:165:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:165:20
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:165:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:165:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:165:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:166:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:166:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:166:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:166:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:166:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:166:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:166:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:166:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:167:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:167:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:167:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:167:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:167:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:167:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:167:15
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:167:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:167:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:167:27
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:168:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:168:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:168:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    Literal(lit 7);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:168:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:168:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:168:27
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:169:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:169:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:169:2
}

function LocalClass8() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:160:3
    LoadArg(index 1);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:161:5
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:161:5
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:162:18
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:162:18
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:162:7
    Literal(lit 'foo');                  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:162:7
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:162:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:162:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:162:7
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:163:6
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:163:6
}

function anonymous1() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:162:24
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:162:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:162:24
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:162:24
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:162:24
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:162:24
}