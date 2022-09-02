unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external assert from free-variable 'assert';
external Microvium from free-variable 'Microvium';
external Number from free-variable 'Number';
external undefined from free-variable 'undefined';
external Reflect from free-variable 'Reflect';

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
global test_classProperty;
global test_classStaticProperty;
global test_closureMethod;
global test_thisInInitializer;
global test_initializerClosingOverThis;
global test_initializerClosingOverOuter;
global test_staticInitializerUsingThis;
global test_staticInitializerClosingUsingThis;
global test_closureOverThisInConstructor;

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
    Literal(lit &function test_classProperty); // 2           ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_classProperty'); // 1              ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_classStaticProperty); // 2     ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_classStaticProperty'); // 1        ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_closureMethod); // 2           ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_closureMethod'); // 1              ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_thisInInitializer); // 2       ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_thisInInitializer'); // 1          ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_initializerClosingOverThis); // 2  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_initializerClosingOverThis'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_initializerClosingOverOuter); // 2  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_initializerClosingOverOuter'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_staticInitializerUsingThis); // 2  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_staticInitializerUsingThis'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_staticInitializerClosingUsingThis); // 2  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_staticInitializerClosingUsingThis'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_closureOverThisInConstructor); // 2  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_closureOverThisInConstructor'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_closureOverThisInMethod); // 2  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // assertionCount: 70
    // testOnly: false
    // ---
    LoadGlobal(name 'vmExport');         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:10:10
    LoadVar(index 0);                    // 6  run            ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Literal(lit 'my');                   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:34:11
    StoreGlobal(name 'x');               // 2                 ./test/end-to-end/tests/classes.test.mvm.js:34:11
    Literal(lit &function GlobalClass);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:36:1
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:36:1
    ClassCreate();                       // 3  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:36:1
    StoreGlobal(name 'GlobalClass');     // 2                 ./test/end-to-end/tests/classes.test.mvm.js:36:1
    LoadGlobal(name 'GlobalClass');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:36:1
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:36:1
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:36:1
    LoadVar(index 4);                    // 6  GlobalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:36:1
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:36:1
    Literal(lit &function GlobalClass_myMethod); // 8         ./test/end-to-end/tests/classes.test.mvm.js:36:1
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:38:3
    LoadGlobal(name 'GlobalClass');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:38:3
    Literal(lit 'myStaticMethod');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:38:3
    Literal(lit &function GlobalClass_myStaticMethod); // 5   ./test/end-to-end/tests/classes.test.mvm.js:38:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:41:22
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:41:1
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:41:1
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:41:1
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:41:1
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:41:1
    LoadGlobal(name 'GlobalClass');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:43:24
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:43:24
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:43:36
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:43:36
    StoreGlobal(name 'globalInst');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:43:36
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:295:1
    Return();                            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:295:1
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
    LoadGlobal(name 'test_classProperty'); // 1               ./test/end-to-end/tests/classes.test.mvm.js:23:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:23:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:23:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:23:3
    LoadGlobal(name 'test_classStaticProperty'); // 1         ./test/end-to-end/tests/classes.test.mvm.js:24:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:24:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:24:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:24:3
    LoadGlobal(name 'test_closureMethod'); // 1               ./test/end-to-end/tests/classes.test.mvm.js:25:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:25:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:25:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:25:3
    LoadGlobal(name 'test_thisInInitializer'); // 1           ./test/end-to-end/tests/classes.test.mvm.js:26:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:26:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:26:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:26:3
    LoadGlobal(name 'test_initializerClosingOverThis'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:27:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:27:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:27:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:27:3
    LoadGlobal(name 'test_initializerClosingOverOuter'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:28:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:28:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:28:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:28:3
    LoadGlobal(name 'test_staticInitializerUsingThis'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:29:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:29:3
    LoadGlobal(name 'test_staticInitializerClosingUsingThis'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:30:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    LoadGlobal(name 'test_closureOverThisInConstructor'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:31:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:31:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:31:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:32:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:32:2
}

function GlobalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:37:29
    Literal(lit 5);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:33
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:37:20
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:37:20
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:37:20
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:37:20
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:37:36
}

function GlobalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:38:25
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:38:25
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:38:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:38:25
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:38:25
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:38:25
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:38:25
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:38:25
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:38:25
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:38:25
}

function GlobalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:39:39
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:39
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:39
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:39
    Branch(@block2, @block1);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:39
  block1:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:39:39
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:49
    Jump(@block2);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:49
  block2:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:54
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:54
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:39:29
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:39:29
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:29
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:39:29
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:39:64
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:64
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:64
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:39:64
}

function test_globalClass() {
  entry:
    Literal(lit deleted);                // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:45:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:46:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:46:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:46:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:46:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:47:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:47:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:47:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:47:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:47:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:48:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:48:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:48:35
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:48:35
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:48:35
    // Accessing instance created at runtime of a class created at compile time
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:51:20
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:51:20
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:51:32
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:51:32
    StoreVar(index 0);                   // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:51:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:52:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Literal(lit 25);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:23
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:23
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:52:23
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:53:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:53:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:53:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Literal(lit 26);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:53:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:53:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:54:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:54:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Literal(lit 27);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:54:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:55:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:55:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:55:2
}

function test_globalInstance() {
  entry:
    Literal(lit deleted);                // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:57:32
    Literal(lit 'ethod');                // 2                 ./test/end-to-end/tests/classes.test.mvm.js:58:13
    StoreVar(index 0);                   // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:58:13
    // Accessing instance constructed at compile time at the global scope
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:60:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    Literal(lit 15);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:60:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:61:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:62:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:62:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    LoadGlobal(name 'x');                // 6                 ./test/end-to-end/tests/classes.test.mvm.js:63:26
    Literal(lit 'M');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:63:30
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:63:30
    LoadVar(index 0);                    // 7  y              ./test/end-to-end/tests/classes.test.mvm.js:63:36
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:63:36
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:36
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:63:36
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:36
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:63:36
    Literal(lit 18);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:42
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:63:42
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:63:42
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:64:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:64:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:64:2
}

function test_localClass() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:66:28
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:66:28
    Literal(lit &function LocalClass);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:67:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:67:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:67:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:67:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:67:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:67:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:67:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:67:3
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:67:3
    Literal(lit &function LocalClass_myMethod); // 8          ./test/end-to-end/tests/classes.test.mvm.js:67:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:69:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:69:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:69:5
    Literal(lit 'myStaticMethod');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:69:5
    Literal(lit &function LocalClass_myStaticMethod); // 5    ./test/end-to-end/tests/classes.test.mvm.js:69:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:23
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:72:3
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:74:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:74:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:74:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:74:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:74:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:74:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:74:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:74:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:74:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:74:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:74:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:74:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:75:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:75:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:75:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:75:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:75:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:76:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:76:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:76:15
    Literal(lit 'myProp');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    Literal(lit 42);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:76:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:76:34
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:78:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:78:20
    Literal(lit 30);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:78:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:78:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:78:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:79:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:79:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:79:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:79:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:79:15
    Literal(lit 37);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:79:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:79:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:79:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:80:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:80:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:80:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:80:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:80:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:80:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:80:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:80:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:80:15
    Literal(lit 39);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:80:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:80:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:80:32
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:81:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    Literal(lit 40);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:81:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:81:32
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:82:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:82:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:82:2
}

function LocalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:68:31
    Literal(lit 7);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:68:35
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:35
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:68:22
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:68:22
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:68:22
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:68:22
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:38
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:68:38
}

function LocalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:69:27
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:69:27
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:69:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:69:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:69:27
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:69:27
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:69:27
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:69:27
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:69:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:69:36
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:69:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:69:36
}

function LocalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:70:41
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:41
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:41
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:41
    Branch(@block4, @block3);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:41
  block3:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:70:41
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:51
    Jump(@block4);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:51
  block4:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:56
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:56
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:70:31
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:31
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:70:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:70:31
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:70:66
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:66
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:66
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:70:66
}

function test_inheritedProperties() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:84:37
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:84:37
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:84:37
    Literal(lit &function LocalClass1);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:90:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:90:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:90:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:90:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:91:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:93:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:93:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:93:21
    StoreVar(index 1);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:93:21
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:94:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:94:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:94:21
    StoreVar(index 2);                   // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:94:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:96:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:96:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:96:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:96:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:96:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:96:24
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:97:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:97:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:97:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:97:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:97:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:97:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:97:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:97:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:99:13
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:99:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:102:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:102:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:102:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:102:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:102:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:102:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:102:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:102:24
    // instance property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:103:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:103:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:103:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:103:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:103:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:103:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:103:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:103:24
    // prototype property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:104:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:104:19
    New(count 1);                        // 6                 ./test/end-to-end/tests/classes.test.mvm.js:104:19
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:104:19
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:104:19
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:104:35
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:104:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:104:35
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:105:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:105:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:105:2
}

// * The objective of this test is to confirm that properties on the prototype
   * can be overridden in instances without affecting the prototype.
function LocalClass1() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:90:3
}

function test_proto() {
  entry:
    Literal(lit deleted);                // 1  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:107:23
    Literal(lit deleted);                // 2  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:107:23
    Literal(lit deleted);                // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:107:23
    Literal(lit &function LocalClass2);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:108:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:108:3
    ClassCreate();                       // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:108:3
    StoreVar(index 0);                   // 3  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:108:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:108:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:108:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:108:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:108:3
    Literal(lit &function LocalClass3);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:109:3
    ClassCreate();                       // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:109:3
    StoreVar(index 1);                   // 3  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:109:3
    LoadVar(index 1);                    // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:109:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:110:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:110:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:110:21
    StoreVar(index 2);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:110:21
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:111:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:111:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:111:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:111:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:111:10
    LoadVar(index 0);                    // 7  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:111:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:111:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:111:30
    BinOp(op '===');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:111:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:111:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:111:30
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:112:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:112:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:112:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:112:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:112:10
    LoadVar(index 1);                    // 7  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:112:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    BinOp(op '!==');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:113:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:113:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:113:2
}

function LocalClass2() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:108:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:108:3
}

function LocalClass3() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
}

function test_returnFromConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:115:39
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:115:39
    Literal(lit &function LocalClass4);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:120:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:120:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:120:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:120:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:123:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:123:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:123:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:123:20
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:124:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:124:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:124:10
    Literal(lit '__proto__');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:124:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:124:10
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:124:29
    Literal(lit 'prototype');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:124:29
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:124:29
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:124:29
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:124:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:124:29
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:125:10
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:10
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:21
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:21
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:21
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:125:21
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:126:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:126:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:126:2
}

// I don't expect anyone to use this edge case, but Microvium happens to
// support it because a return statement in a constructor is just handled as a
// normal return.
function LocalClass4() {
  entry:
    ObjectNew();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:121:28
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:121:28
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:121:28
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:121:33
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:121:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:121:33
}

function test_operators() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:128:27
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:128:27
    Literal(lit &function LocalClass5);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:129:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:129:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:129:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:129:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:130:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:130:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:130:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:130:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:131:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:131:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:131:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:131:22
    Literal(lit 'function');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:131:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:131:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:131:34
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:132:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:132:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:132:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:132:22
    Literal(lit 'object');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:132:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:132:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:132:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:133:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:133:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:133:15
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:133:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:133:36
    Literal(lit 9);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:49
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:133:49
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:133:49
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:134:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:36
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:43
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:43
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:134:43
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:135:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:135:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:135:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:135:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:135:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:135:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:135:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:136:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:136:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:136:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:136:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:136:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:136:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:136:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:136:23
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:137:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:137:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:137:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:137:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:137:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:137:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:137:10
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:137:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:137:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:137:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:137:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:137:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:137:24
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:138:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:138:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:138:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:139:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:139:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:139:2
}

function LocalClass5() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
}

function test_classAsMember() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:141:31
    Literal(lit deleted);                // 2  obj            ./test/end-to-end/tests/classes.test.mvm.js:141:31
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:141:31
    Literal(lit &function LocalClass6);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:142:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:142:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:142:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:142:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:142:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:142:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:142:3
    LoadVar(index 5);                    // 7  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:142:3
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:142:3
    Literal(lit &function LocalClass_foo); // 9               ./test/end-to-end/tests/classes.test.mvm.js:142:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:144:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:144:5
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:147:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:147:15
    Literal(lit 'LocalClass');           // 6                 ./test/end-to-end/tests/classes.test.mvm.js:147:15
    LoadVar(index 0);                    // 7  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:147:17
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:147:17
    StoreVar(index 1);                   // 3  obj            ./test/end-to-end/tests/classes.test.mvm.js:147:17
    LoadVar(index 1);                    // 4  obj            ./test/end-to-end/tests/classes.test.mvm.js:148:20
    Literal(lit 'LocalClass');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:148:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:148:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:148:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:148:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:148:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:149:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:149:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:149:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:149:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:149:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:149:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:149:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:149:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:150:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:150:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:150:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:150:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:150:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:150:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:150:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:150:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:150:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:150:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:150:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:150:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:151:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:151:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:151:2
}

function LocalClass6() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:143:30
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:143:21
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:143:21
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:143:21
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:143:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:143:21
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:143:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:143:33
}

function LocalClass_foo() {
  entry:
    Literal(lit 10);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:144:20
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:144:20
}

function test_closingOverClass() {
  entry:
    Literal(lit &function inner);        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:153:34
    Literal(lit deleted);                // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:153:34
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:153:34
    LoadVar(index 0);                    // 4  inner          ./test/end-to-end/tests/classes.test.mvm.js:162:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:162:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:162:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:162:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:162:22
    StoreVar(index 1);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:162:22
    LoadVar(index 1);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:163:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:163:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:163:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:163:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:164:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:164:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:164:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:164:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:164:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:164:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:164:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:164:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:165:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:165:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:165:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:165:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:165:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:165:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:165:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:165:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:165:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:165:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:166:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:166:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:166:2
}

function inner() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:154:3
    Literal(lit &function LocalClass7);  // 1                 ./test/end-to-end/tests/classes.test.mvm.js:155:5
    ObjectNew();                         // 2  static props   ./test/end-to-end/tests/classes.test.mvm.js:155:5
    ClassCreate();                       // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:155:5
    StoreScoped(index 1);                // 0  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:155:5
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:155:5
    Literal(lit 'prototype');            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:155:5
    ObjectNew();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:155:5
    LoadVar(index 2);                    // 4  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:155:5
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:155:5
    Literal(lit &function LocalClass_foo1); // 6              ./test/end-to-end/tests/classes.test.mvm.js:155:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:157:7
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:157:7
    Literal(lit &function anonymous);    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:159:12
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:159:12
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:159:12
}

function LocalClass7() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:156:32
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:156:23
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:156:23
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:156:23
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:156:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:156:23
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:156:35
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:156:35
}

function LocalClass_foo1() {
  entry:
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:157:22
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:157:22
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:159:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:159:18
}

function test_closureInConstructor() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:168:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:168:38
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:168:38
    Literal(lit 10);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:169:11
    StoreScoped(index 1);                // 2  y              ./test/end-to-end/tests/classes.test.mvm.js:169:11
    Literal(lit &function LocalClass8);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:170:3
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:170:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:170:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:170:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:170:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:170:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:170:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:170:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:170:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:175:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:175:20
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:175:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:175:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:175:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:176:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:176:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:176:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:176:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:176:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:176:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:176:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:176:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:177:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:177:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:177:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:177:15
    Literal(lit 16);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:177:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:177:27
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:178:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:178:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:178:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    Literal(lit 17);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:178:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:178:27
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:179:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:179:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:179:2
}

function LocalClass8() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:170:3
    LoadArg(index 1);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:171:5
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:171:5
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:172:18
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:172:18
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:172:7
    Literal(lit 'foo');                  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:172:7
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:172:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:172:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:172:7
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:6
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:173:6
}

function anonymous1() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:172:24
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:172:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:172:24
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:172:24
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:172:24
    LoadScoped(index 3);                 // 2  y              ./test/end-to-end/tests/classes.test.mvm.js:172:30
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:172:30
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:172:30
}

function test_classProperty() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:181:31
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:181:31
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:181:31
    Literal(lit deleted);                // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:181:31
    Literal(lit &function LocalClass9);  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    ObjectNew();                         // 6  static props   ./test/end-to-end/tests/classes.test.mvm.js:182:3
    ClassCreate();                       // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:182:3
    StoreVar(index 0);                   // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:182:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:182:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    ObjectNew();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:183:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:183:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:183:21
    StoreVar(index 1);                   // 4  inst1          ./test/end-to-end/tests/classes.test.mvm.js:183:21
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:184:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:184:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:184:21
    StoreVar(index 2);                   // 4  inst2          ./test/end-to-end/tests/classes.test.mvm.js:184:21
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:185:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:185:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:185:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:185:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:185:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:185:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:185:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:185:24
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:186:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:186:3
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    LoadVar(index 5);                    // 9                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:187:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:187:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:187:15
    Literal(lit 6);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:187:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:187:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:187:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:188:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:188:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:188:15
    Literal(lit '__proto__');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:188:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:188:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:188:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:188:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:188:34
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:188:34
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:188:34
    // The property is not on the prototype
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:189:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:189:3
    LoadVar(index 2);                    // 7  inst2          ./test/end-to-end/tests/classes.test.mvm.js:189:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:189:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:189:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:189:24
    // Test that properties are independent
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/classes.test.mvm.js:191:16
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:191:16
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:191:16
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:191:16
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:191:16
    LoadVar(index 1);                    // 8  inst1          ./test/end-to-end/tests/classes.test.mvm.js:191:32
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:191:32
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:191:32
    StoreVar(index 3);                   // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:191:32
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:192:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:192:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:192:15
    Literal(lit 'length');               // 8                 ./test/end-to-end/tests/classes.test.mvm.js:192:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:192:15
    Literal(lit 2);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:192:28
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:192:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:192:28
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:193:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:193:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:193:15
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:193:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:193:20
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:193:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:193:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:193:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:194:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:194:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:194:15
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:194:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:194:20
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:194:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:194:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:194:24
    // y is a key
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:195:15
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:195:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:195:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:195:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:195:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:195:24
    Pop(count 4);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:196:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:196:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:196:2
}

function LocalClass9() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:182:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:182:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:182:26
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:182:26
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:182:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:182:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:182:26
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:182:26
}

function test_classStaticProperty() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:198:37
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:198:37
    Literal(lit &function LocalClass10); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:199:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:199:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:199:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:199:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:199:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:199:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:199:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:199:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:199:3
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:199:3
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:200:16
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:200:16
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:200:16
    Literal(lit 'y');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:200:16
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:200:16
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:200:16
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:203:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:203:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:203:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:203:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:204:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:204:3
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/classes.test.mvm.js:204:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:204:15
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:204:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:204:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:204:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:204:31
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:204:31
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:204:31
    Literal(lit 'length');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:204:31
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:204:31
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:204:45
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:204:45
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:204:45
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:205:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:205:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:205:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:205:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:205:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:206:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:206:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:206:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:206:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:206:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:206:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:206:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:206:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:207:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:207:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:207:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:207:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:207:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:207:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:207:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:207:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:208:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:208:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:208:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:208:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:208:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:208:29
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:209:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:209:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:209:2
}

function LocalClass10() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:199:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:199:3
}

function test_closureMethod() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:211:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:211:31
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:211:31
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:212:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:212:11
    Literal(lit &function LocalClass11); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:213:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:213:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:213:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:213:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:213:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:213:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:213:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:213:3
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:213:3
    Literal(lit &function LocalClass_method); // 8            ./test/end-to-end/tests/classes.test.mvm.js:213:3
    ClosureNew();                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:213:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:214:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:214:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:219:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:219:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:219:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:219:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:220:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:220:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:220:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:220:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:220:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:220:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:220:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:220:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:220:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:220:30
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:220:30
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:220:30
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:221:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:221:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:221:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:221:30
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:221:30
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:221:30
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:222:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:222:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/classes.test.mvm.js:222:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:222:18
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:222:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:222:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:223:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:223:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:223:2
}

function LocalClass11() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:213:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:213:3
}

function LocalClass_method() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:215:14
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:215:14
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:215:14
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:215:14
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:215:14
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:215:14
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:215:14
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:215:14
}

function test_thisInInitializer() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:225:35
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:225:35
    Literal(lit &function LocalClass12); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:226:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:226:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:226:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:226:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:226:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:226:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:226:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:226:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:231:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:231:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:231:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:231:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:232:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:232:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:232:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:232:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:232:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:232:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:232:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:232:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:233:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:233:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:233:15
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:233:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:233:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:233:23
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:234:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:234:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:234:2
}

function LocalClass12() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:226:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:226:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:227:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:227:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:227:9
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:227:9
    LoadArg(index 0);                    // 3  this           ./test/end-to-end/tests/classes.test.mvm.js:228:9
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:228:9
    ObjectGet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:228:9
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:228:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:228:18
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:228:18
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:228:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:228:18
}

function test_initializerClosingOverThis() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:236:44
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:236:44
    Literal(lit deleted);                // 3  f              ./test/end-to-end/tests/classes.test.mvm.js:236:44
    Literal(lit &function LocalClass13); // 4                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:237:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:237:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:237:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:237:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:242:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:242:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:242:20
    StoreVar(index 1);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:242:20
    LoadVar(index 1);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:243:13
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:243:13
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:243:13
    StoreVar(index 2);                   // 3  f              ./test/end-to-end/tests/classes.test.mvm.js:243:13
    // call y without passing `this`
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:244:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:244:3
    LoadVar(index 2);                    // 6  f              ./test/end-to-end/tests/classes.test.mvm.js:244:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:244:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:244:15
    Literal(lit 6);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:244:20
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:244:20
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:244:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:245:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:245:3
    LoadVar(index 2);                    // 6  f              ./test/end-to-end/tests/classes.test.mvm.js:245:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:245:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:245:15
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:245:20
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:245:20
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:245:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:246:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:246:3
    LoadVar(index 1);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:246:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:246:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:246:15
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:246:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:246:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:246:23
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:247:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:247:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:247:2
}

function LocalClass13() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:237:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:238:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:238:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:238:9
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:238:9
    Literal(lit &function anonymous2);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
}

function anonymous2() {
  entry:
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:239:17
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:239:17
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:239:17
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:239:17
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:239:17
    LoadScoped(index 1);                 // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:239:17
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:239:17
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:239:17
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:239:17
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:239:17
}

function test_initializerClosingOverOuter() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:249:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:249:45
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:249:45
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:250:15
    StoreScoped(index 1);                // 2  count          ./test/end-to-end/tests/classes.test.mvm.js:250:15
    Literal(lit &function LocalClass14); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:251:3
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:251:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:251:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:251:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:251:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:251:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:251:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:251:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:251:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:255:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:255:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:255:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:255:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:256:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:256:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:256:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:256:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:256:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:256:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:256:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:256:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:256:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:256:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:256:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:256:25
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:257:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:257:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:257:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:257:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:257:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:257:25
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:258:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:258:3
    LoadScoped(index 1);                 // 5  count          ./test/end-to-end/tests/classes.test.mvm.js:258:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:258:22
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:258:22
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:258:22
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:259:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:259:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:259:2
}

function LocalClass14() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:251:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:251:3
    Literal(lit &function anonymous3);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:252:9
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:252:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:252:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:252:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:252:9
}

function anonymous3() {
  entry:
    LoadScoped(index 1);                 // 1  count          ./test/end-to-end/tests/classes.test.mvm.js:252:15
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:252:15
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:252:15
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:252:15
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:252:15
    StoreScoped(index 1);                // 2  count          ./test/end-to-end/tests/classes.test.mvm.js:252:15
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:252:15
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:252:15
}

function test_staticInitializerUsingThis() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:261:44
    Literal(lit &function LocalClass15); // 2                 ./test/end-to-end/tests/classes.test.mvm.js:262:3
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/classes.test.mvm.js:262:3
    ClassCreate();                       // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:262:3
    StoreVar(index 0);                   // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:262:3
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:262:3
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/classes.test.mvm.js:262:3
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:262:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:262:3
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:262:3
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:262:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:263:16
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:263:16
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:263:16
    Literal(lit 'y');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:263:16
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:266:16
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:266:16
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:266:16
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:266:31
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:266:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:266:31
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:268:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:268:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:268:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:268:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:268:15
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:268:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:268:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:268:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:269:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:269:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:269:15
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:269:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:269:15
    Literal(lit 8);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:269:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:269:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:269:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:270:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:270:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:270:2
}

function LocalClass15() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:262:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:262:3
}

function test_staticInitializerClosingUsingThis() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:272:1
    Literal(lit &function LocalClass16); // 1                 ./test/end-to-end/tests/classes.test.mvm.js:273:3
    ObjectNew();                         // 2  static props   ./test/end-to-end/tests/classes.test.mvm.js:273:3
    ClassCreate();                       // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:273:3
    StoreScoped(index 1);                // 0  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:273:3
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:273:3
    Literal(lit 'prototype');            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:273:3
    ObjectNew();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:273:3
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:273:3
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:273:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:273:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:274:16
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:274:16
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:274:16
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:274:16
    Literal(lit &function anonymous4);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:277:16
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:277:16
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:277:16
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:279:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:279:3
    LoadScoped(index 1);                 // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:279:15
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:279:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:279:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:279:29
    Call(count 3);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:279:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:279:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:280:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:280:3
    LoadScoped(index 1);                 // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:280:15
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:280:15
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:280:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:280:15
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:280:15
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:280:15
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:280:15
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:280:31
    Call(count 3);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:280:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:280:31
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:281:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:281:2
}

function LocalClass16() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:273:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:273:3
}

function anonymous4() {
  entry:
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:277:22
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:277:22
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:277:22
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:277:37
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:277:37
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:277:37
}

function test_closureOverThisInConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:283:46
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:283:46
    Literal(lit &function LocalClass17); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:284:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:284:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:284:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:284:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:290:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:290:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:290:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:290:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:291:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:291:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:291:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:291:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:291:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:291:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:291:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:291:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:292:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:292:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:292:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:292:15
    Literal(lit 'y');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:292:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:292:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:292:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:292:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:292:15
    Literal(lit 8);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:292:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:292:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:292:25
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:293:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:293:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:293:2
}

function LocalClass17() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:284:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:285:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:285:9
    Literal(lit &function anonymous5);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:287:16
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:287:16
    LoadScoped(index 1);                 // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:287:7
    Literal(lit 'y');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:287:7
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:287:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:287:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:287:7
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:288:6
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:288:6
}

function anonymous5() {
  entry:
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:287:22
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:287:22
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:287:22
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:287:31
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:287:31
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:287:31
}

function test_closureOverThisInMethod() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:295:41
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:295:41
    Literal(lit &function LocalClass18); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:296:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:296:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:296:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:296:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:296:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:296:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:296:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:296:3
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:296:3
    Literal(lit &function LocalClass_method1); // 8           ./test/end-to-end/tests/classes.test.mvm.js:296:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:298:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:298:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:302:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:302:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:302:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:302:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:303:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:303:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:303:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:303:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:303:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:303:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:303:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:303:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:304:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:304:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:304:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    Literal(lit 8);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:304:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:304:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:304:32
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:305:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:305:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:305:2
}

function LocalClass18() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:296:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:296:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:297:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:297:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:297:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:297:9
}

function LocalClass_method1() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:298:5
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:298:5
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:298:5
    Literal(lit &function anonymous6);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:299:14
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:299:14
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:299:14
}

function anonymous6() {
  entry:
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:299:20
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:299:20
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:299:20
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:299:29
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:299:29
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:299:29
}