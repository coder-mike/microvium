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
global test_closureOverThisInMethod;

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
    StoreGlobal(name 'test_closureOverThisInMethod'); // 1    ./test/end-to-end/tests/classes.test.mvm.js:1:1
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // assertionCount: 72
    // testOnly: false
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:10:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Literal(lit 'my');                   // 2                 ./test/end-to-end/tests/classes.test.mvm.js:35:11
    StoreGlobal(name 'x');               // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:11
    Literal(lit &function GlobalClass);  // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/classes.test.mvm.js:37:1
    ClassCreate();                       // 2  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:37:1
    StoreGlobal(name 'GlobalClass');     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    LoadVar(index 3);                    // 5  GlobalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:37:1
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    Literal(lit &function GlobalClass_myMethod); // 7         ./test/end-to-end/tests/classes.test.mvm.js:37:1
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    Literal(lit 'myStaticMethod');       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    Literal(lit &function GlobalClass_myStaticMethod); // 4   ./test/end-to-end/tests/classes.test.mvm.js:39:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:3
    Literal(lit 42);                     // 2                 ./test/end-to-end/tests/classes.test.mvm.js:42:22
    LoadGlobal(name 'GlobalClass');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:42:1
    Literal(lit 'myProp');               // 4                 ./test/end-to-end/tests/classes.test.mvm.js:42:1
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:42:1
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:42:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:42:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:24
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:44:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:44:36
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:36
    StoreGlobal(name 'globalInst');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:44:36
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:296:1
    Return();                            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:296:1
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
    LoadGlobal(name 'test_closureOverThisInMethod'); // 1     ./test/end-to-end/tests/classes.test.mvm.js:32:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:32:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:32:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:32:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:33:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:33:2
}

function GlobalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:38:29
    Literal(lit 5);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:38:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:38:33
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:38:20
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:38:20
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:38:20
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:38:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:38:20
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:38:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:38:36
}

function GlobalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:39:25
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:25
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:25
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:25
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:39:25
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:39:25
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:25
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:25
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:39:25
}

function GlobalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:40:39
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:40:39
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:39
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:40:39
    Branch(@block2, @block1);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:39
  block1:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:40:39
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:49
    Jump(@block2);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:49
  block2:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:40:54
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:54
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:40:29
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:40:29
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:40:29
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:40:29
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:40:64
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:40:64
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:64
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:40:64
}

function test_globalClass() {
  entry:
    Literal(lit deleted);                // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:46:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:47:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:47:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:47:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:47:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:47:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:47:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:48:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:48:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:48:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:48:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:48:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:49:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:49:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:49:35
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:49:35
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:49:35
    // Accessing instance created at runtime of a class created at compile time
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:20
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:52:20
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:52:32
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:32
    StoreVar(index 0);                   // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:52:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:53:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:53:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Literal(lit 25);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:23
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:53:23
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:53:23
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:54:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:54:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Literal(lit 26);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:54:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:55:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:55:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:55:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:55:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:55:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:55:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:55:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:55:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:55:15
    Literal(lit 27);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:55:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:55:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:55:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:56:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:56:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:56:2
}

function test_globalInstance() {
  entry:
    Literal(lit deleted);                // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:58:32
    Literal(lit 'ethod');                // 2                 ./test/end-to-end/tests/classes.test.mvm.js:59:13
    StoreVar(index 0);                   // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:59:13
    // Accessing instance constructed at compile time at the global scope
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:61:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    Literal(lit 15);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:62:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:62:15
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:62:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:63:15
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:63:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:63:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:64:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:64:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:64:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:64:15
    LoadGlobal(name 'x');                // 6                 ./test/end-to-end/tests/classes.test.mvm.js:64:26
    Literal(lit 'M');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:64:30
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:64:30
    LoadVar(index 0);                    // 7  y              ./test/end-to-end/tests/classes.test.mvm.js:64:36
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:64:36
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:64:36
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:64:36
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:64:36
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:64:36
    Literal(lit 18);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:64:42
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:64:42
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:64:42
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:65:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:65:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:65:2
}

function test_localClass() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:67:28
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:67:28
    Literal(lit &function LocalClass);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:68:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:68:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:68:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:68:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:68:3
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    Literal(lit &function LocalClass_myMethod); // 8          ./test/end-to-end/tests/classes.test.mvm.js:68:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:70:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:70:5
    Literal(lit 'myStaticMethod');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:70:5
    Literal(lit &function LocalClass_myStaticMethod); // 5    ./test/end-to-end/tests/classes.test.mvm.js:70:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:71:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:73:23
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:73:3
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:73:3
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:73:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:73:3
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:75:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:75:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:75:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:75:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:75:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:76:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:76:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:76:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:76:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:76:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:77:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:77:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:77:15
    Literal(lit 'myProp');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    Literal(lit 42);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:77:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:77:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:77:34
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:79:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:79:20
    Literal(lit 30);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:79:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:79:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:79:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:80:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:80:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:80:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:80:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:80:15
    Literal(lit 37);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:80:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:80:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:80:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:81:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:81:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:81:15
    Literal(lit 39);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:81:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:81:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:81:32
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:82:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:82:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:82:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:82:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:82:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:82:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:82:15
    Literal(lit 40);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:82:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:82:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:82:32
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:83:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:83:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:83:2
}

function LocalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:69:31
    Literal(lit 7);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:69:35
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:69:35
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:69:22
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:69:22
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:69:22
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:69:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:69:22
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:69:38
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:69:38
}

function LocalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:70:27
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:27
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:27
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:70:27
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:27
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:70:27
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:36
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:70:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:70:36
}

function LocalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:71:41
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:71:41
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:71:41
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:71:41
    Branch(@block4, @block3);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:71:41
  block3:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:71:41
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:71:51
    Jump(@block4);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:71:51
  block4:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:71:56
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:71:56
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:71:31
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:71:31
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:71:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:71:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:71:31
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:71:66
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:71:66
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:71:66
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:71:66
}

function test_inheritedProperties() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:85:37
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:85:37
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:85:37
    Literal(lit &function LocalClass1);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:91:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:91:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:92:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:92:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:94:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:94:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:94:21
    StoreVar(index 1);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:94:21
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:95:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:95:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:21
    StoreVar(index 2);                   // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:95:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:97:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:97:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:97:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:97:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:97:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:97:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:97:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:97:24
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:98:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:98:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:98:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:98:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:98:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:98:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:13
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:101:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:101:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:103:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:103:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:103:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:103:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:103:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:103:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:103:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:103:24
    // instance property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:104:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:104:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:104:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:104:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:104:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:104:24
    // prototype property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:105:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:105:3
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:105:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:105:19
    New(count 1);                        // 6                 ./test/end-to-end/tests/classes.test.mvm.js:105:19
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:105:19
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:105:19
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:105:35
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:105:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:105:35
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:106:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:106:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:106:2
}

// * The objective of this test is to confirm that properties on the prototype
   * can be overridden in instances without affecting the prototype.
function LocalClass1() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
}

function test_proto() {
  entry:
    Literal(lit deleted);                // 1  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:108:23
    Literal(lit deleted);                // 2  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:108:23
    Literal(lit deleted);                // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:108:23
    Literal(lit &function LocalClass2);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:109:3
    ClassCreate();                       // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:109:3
    StoreVar(index 0);                   // 3  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:109:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:109:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    Literal(lit &function LocalClass3);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:110:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:110:3
    ClassCreate();                       // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:110:3
    StoreVar(index 1);                   // 3  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:110:3
    LoadVar(index 1);                    // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:110:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:110:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:110:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:110:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:111:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:111:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:111:21
    StoreVar(index 2);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:111:21
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:112:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:112:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:112:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:112:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:112:10
    LoadVar(index 0);                    // 7  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:112:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    BinOp(op '===');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:112:30
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:113:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:113:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:113:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:113:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:113:10
    LoadVar(index 1);                    // 7  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:113:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:113:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:113:30
    BinOp(op '!==');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:113:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:113:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:113:30
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:114:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:114:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:114:2
}

function LocalClass2() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
}

function LocalClass3() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:110:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:110:3
}

function test_returnFromConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:116:39
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:116:39
    Literal(lit &function LocalClass4);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:121:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:121:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:121:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:121:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:124:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:124:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:124:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:124:20
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:125:10
    Literal(lit '__proto__');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:10
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:125:29
    Literal(lit 'prototype');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:125:29
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:29
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:29
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:125:29
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:126:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:126:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:126:10
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:126:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:126:10
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:126:21
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:126:21
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:126:21
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:126:21
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:127:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:127:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:127:2
}

// I don't expect anyone to use this edge case, but Microvium happens to
// support it because a return statement in a constructor is just handled as a
// normal return.
function LocalClass4() {
  entry:
    ObjectNew();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:122:28
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:122:28
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:122:28
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:122:33
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:122:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:122:33
}

function test_operators() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:129:27
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:129:27
    Literal(lit &function LocalClass5);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:130:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:130:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:130:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:130:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:131:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:131:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:131:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:131:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:132:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:132:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:132:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:132:22
    Literal(lit 'function');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:132:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:132:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:132:34
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:133:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:133:22
    Literal(lit 'object');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:133:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:133:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:134:15
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:134:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:36
    Literal(lit 9);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:49
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:49
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:134:49
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:135:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:135:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:135:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:135:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:135:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:135:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:135:36
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:43
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:135:43
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:135:43
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:136:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:136:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:136:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:136:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:136:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:136:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:136:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:136:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:137:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:137:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:137:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:137:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:137:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:137:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:137:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:137:23
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:138:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:138:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:138:10
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:138:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:138:24
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:139:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:139:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:139:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:139:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:139:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:139:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:139:10
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:139:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:139:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:139:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:139:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:139:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:139:24
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:140:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:140:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:140:2
}

function LocalClass5() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
}

function test_classAsMember() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:142:31
    Literal(lit deleted);                // 2  obj            ./test/end-to-end/tests/classes.test.mvm.js:142:31
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:142:31
    Literal(lit &function LocalClass6);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:143:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:143:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:143:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:143:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:143:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:143:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:143:3
    LoadVar(index 5);                    // 7  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:143:3
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:143:3
    Literal(lit &function LocalClass_foo); // 9               ./test/end-to-end/tests/classes.test.mvm.js:143:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:145:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:145:5
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    Literal(lit 'LocalClass');           // 6                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    LoadVar(index 0);                    // 7  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:148:17
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:148:17
    StoreVar(index 1);                   // 3  obj            ./test/end-to-end/tests/classes.test.mvm.js:148:17
    LoadVar(index 1);                    // 4  obj            ./test/end-to-end/tests/classes.test.mvm.js:149:20
    Literal(lit 'LocalClass');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:149:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:149:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:149:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:149:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:149:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:150:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:150:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:150:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:150:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:150:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:150:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:150:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:150:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:151:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:151:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:151:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:151:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:151:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:151:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:151:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:151:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:151:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:151:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:151:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:151:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:152:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:152:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:152:2
}

function LocalClass6() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:144:30
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:144:21
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:144:21
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:144:21
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:144:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:144:21
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:144:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:144:33
}

function LocalClass_foo() {
  entry:
    Literal(lit 10);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:145:20
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:145:20
}

function test_closingOverClass() {
  entry:
    Literal(lit &function inner);        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:154:34
    Literal(lit deleted);                // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:154:34
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:154:34
    LoadVar(index 0);                    // 4  inner          ./test/end-to-end/tests/classes.test.mvm.js:163:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:163:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:163:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:163:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:163:22
    StoreVar(index 1);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:163:22
    LoadVar(index 1);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:164:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:164:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:164:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:164:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:165:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:165:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:165:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:165:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:165:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:165:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:166:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:166:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:166:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:166:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:166:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:166:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:166:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:166:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:166:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:166:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:166:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:166:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:167:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:167:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:167:2
}

function inner() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:155:3
    Literal(lit &function LocalClass7);  // 1                 ./test/end-to-end/tests/classes.test.mvm.js:156:5
    ObjectNew();                         // 2  static props   ./test/end-to-end/tests/classes.test.mvm.js:156:5
    ClassCreate();                       // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:156:5
    StoreScoped(index 1);                // 0  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:156:5
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:156:5
    Literal(lit 'prototype');            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:156:5
    ObjectNew();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:156:5
    LoadVar(index 2);                    // 4  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:156:5
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:156:5
    Literal(lit &function LocalClass_foo1); // 6              ./test/end-to-end/tests/classes.test.mvm.js:156:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:158:7
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:158:7
    Literal(lit &function anonymous);    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:160:12
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:160:12
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:160:12
}

function LocalClass7() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:157:32
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:157:23
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:157:23
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:157:23
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:157:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:157:23
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:157:35
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:157:35
}

function LocalClass_foo1() {
  entry:
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:158:22
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:158:22
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:160:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:160:18
}

function test_closureInConstructor() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:169:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:169:38
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:169:38
    Literal(lit 10);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:170:11
    StoreScoped(index 1);                // 2  y              ./test/end-to-end/tests/classes.test.mvm.js:170:11
    Literal(lit &function LocalClass8);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:171:3
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:171:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:171:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:171:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:171:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:171:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:171:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:171:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:171:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:176:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:176:20
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:176:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:176:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:176:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:177:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:177:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:177:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:177:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:178:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:178:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:178:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    Literal(lit 16);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:178:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:178:27
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:179:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    Literal(lit 17);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:179:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:179:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:179:27
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:180:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:180:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:180:2
}

function LocalClass8() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:171:3
    LoadArg(index 1);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:172:5
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:172:5
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:18
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:18
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:173:7
    Literal(lit 'foo');                  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:173:7
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:173:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:173:7
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:174:6
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:174:6
}

function anonymous1() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:173:24
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:173:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:24
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:173:24
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:173:24
    LoadScoped(index 3);                 // 2  y              ./test/end-to-end/tests/classes.test.mvm.js:173:30
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:30
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:173:30
}

function test_classProperty() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:182:31
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:182:31
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:182:31
    Literal(lit deleted);                // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:182:31
    Literal(lit &function LocalClass9);  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    ObjectNew();                         // 6  static props   ./test/end-to-end/tests/classes.test.mvm.js:183:3
    ClassCreate();                       // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:183:3
    StoreVar(index 0);                   // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:183:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    ObjectNew();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:184:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:184:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:184:21
    StoreVar(index 1);                   // 4  inst1          ./test/end-to-end/tests/classes.test.mvm.js:184:21
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:185:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:185:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:185:21
    StoreVar(index 2);                   // 4  inst2          ./test/end-to-end/tests/classes.test.mvm.js:185:21
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:186:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:186:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:186:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:187:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:187:3
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    LoadVar(index 5);                    // 9                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:188:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:188:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:188:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:188:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:188:15
    Literal(lit 6);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:188:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:188:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:188:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:189:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:189:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:189:15
    Literal(lit '__proto__');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:189:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:189:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:34
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:189:34
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:189:34
    // The property is not on the prototype
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:190:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:190:3
    LoadVar(index 2);                    // 7  inst2          ./test/end-to-end/tests/classes.test.mvm.js:190:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:190:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:190:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    // Test that properties are independent
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/classes.test.mvm.js:192:16
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:192:16
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:192:16
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:192:16
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:192:16
    LoadVar(index 1);                    // 8  inst1          ./test/end-to-end/tests/classes.test.mvm.js:192:32
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:192:32
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:192:32
    StoreVar(index 3);                   // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:192:32
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:193:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:193:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:193:15
    Literal(lit 'length');               // 8                 ./test/end-to-end/tests/classes.test.mvm.js:193:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:193:15
    Literal(lit 2);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:193:28
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:193:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:193:28
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:194:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:194:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:194:15
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:194:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:194:20
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:194:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:194:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:194:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:195:15
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:195:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:195:20
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:195:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:195:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:195:24
    // y is a key
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:196:15
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:196:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:196:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:196:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:196:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:196:24
    Pop(count 4);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:197:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:197:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:197:2
}

function LocalClass9() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:183:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:183:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:183:26
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:183:26
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:183:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:183:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:183:26
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:183:26
}

function test_classStaticProperty() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:199:37
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:199:37
    Literal(lit &function LocalClass10); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:200:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:200:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:200:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:200:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:200:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:200:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:200:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:200:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:200:3
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:200:3
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:201:16
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:201:16
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:201:16
    Literal(lit 'y');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:201:16
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:201:16
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:201:16
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:204:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:204:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:204:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:204:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:205:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:205:3
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:205:31
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:31
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:205:31
    Literal(lit 'length');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:31
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:205:31
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:45
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:205:45
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:205:45
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:206:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:206:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:206:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:206:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:206:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:206:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:206:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:206:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:207:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:207:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:207:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:207:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:207:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:207:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:207:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:207:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:208:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:208:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:208:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:208:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:208:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:208:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:209:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:209:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:209:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:209:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:209:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:209:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:209:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:209:29
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:210:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:210:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:210:2
}

function LocalClass10() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:200:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:200:3
}

function test_closureMethod() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:212:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:212:31
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:212:31
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:213:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:213:11
    Literal(lit &function LocalClass11); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:214:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:214:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:214:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:214:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:214:3
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
    Literal(lit &function LocalClass_method); // 8            ./test/end-to-end/tests/classes.test.mvm.js:214:3
    ClosureNew();                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:215:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:215:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:220:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:220:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:220:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:220:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:221:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:221:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:221:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:221:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:221:30
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:221:30
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:221:30
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:222:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:222:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:222:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:222:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:222:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:222:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:222:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:222:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:222:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:222:30
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:222:30
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:222:30
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:223:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:223:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/classes.test.mvm.js:223:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:223:18
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:223:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:223:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:224:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:224:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:224:2
}

function LocalClass11() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
}

function LocalClass_method() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:216:14
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:216:14
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:216:14
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:216:14
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:216:14
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:216:14
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:216:14
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:216:14
}

function test_thisInInitializer() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:226:35
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:226:35
    Literal(lit &function LocalClass12); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:227:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:227:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:227:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:227:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:227:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:227:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:227:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:227:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:232:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:232:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:232:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:232:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:233:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:233:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:233:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:233:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:233:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:233:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:234:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:234:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:234:15
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:234:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:234:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:234:23
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:235:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:235:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:235:2
}

function LocalClass12() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:227:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:227:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:228:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:228:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:228:9
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:228:9
    LoadArg(index 0);                    // 3  this           ./test/end-to-end/tests/classes.test.mvm.js:229:9
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:229:9
    ObjectGet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:229:9
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:229:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:229:18
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:229:18
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:229:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:229:18
}

function test_initializerClosingOverThis() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:237:44
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:237:44
    Literal(lit deleted);                // 3  f              ./test/end-to-end/tests/classes.test.mvm.js:237:44
    Literal(lit &function LocalClass13); // 4                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:238:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:238:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:238:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:238:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:243:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:243:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:243:20
    StoreVar(index 1);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:243:20
    LoadVar(index 1);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:244:13
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:244:13
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:244:13
    StoreVar(index 2);                   // 3  f              ./test/end-to-end/tests/classes.test.mvm.js:244:13
    // call y without passing `this`
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:245:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:245:3
    LoadVar(index 2);                    // 6  f              ./test/end-to-end/tests/classes.test.mvm.js:245:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:245:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:245:15
    Literal(lit 6);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:245:20
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:245:20
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:245:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:246:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:246:3
    LoadVar(index 2);                    // 6  f              ./test/end-to-end/tests/classes.test.mvm.js:246:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:246:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:246:15
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:246:20
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:246:20
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:246:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:247:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:247:3
    LoadVar(index 1);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:247:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:247:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:247:15
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:247:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:247:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:247:23
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:248:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:248:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:248:2
}

function LocalClass13() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:239:9
    Literal(lit &function anonymous2);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:240:9
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:240:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:240:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:240:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:240:9
}

function anonymous2() {
  entry:
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:240:17
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:240:17
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:240:17
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:240:17
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:240:17
    LoadScoped(index 1);                 // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:240:17
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:240:17
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:240:17
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:240:17
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:240:17
}

function test_initializerClosingOverOuter() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:250:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:250:45
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:250:45
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:251:15
    StoreScoped(index 1);                // 2  count          ./test/end-to-end/tests/classes.test.mvm.js:251:15
    Literal(lit &function LocalClass14); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:252:3
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:252:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:252:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:252:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:252:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:252:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:252:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:252:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:252:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:256:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:256:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:256:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:256:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:257:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:257:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:257:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:257:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:257:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:257:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:257:25
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:258:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:258:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:258:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:258:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:258:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:258:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:258:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:258:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:258:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:258:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:258:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:258:25
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
    LoadScoped(index 1);                 // 5  count          ./test/end-to-end/tests/classes.test.mvm.js:259:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:259:22
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:259:22
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:259:22
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:260:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:260:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:260:2
}

function LocalClass14() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:252:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:252:3
    Literal(lit &function anonymous3);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:253:9
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:253:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:253:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:253:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:253:9
}

function anonymous3() {
  entry:
    LoadScoped(index 1);                 // 1  count          ./test/end-to-end/tests/classes.test.mvm.js:253:15
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    StoreScoped(index 1);                // 2  count          ./test/end-to-end/tests/classes.test.mvm.js:253:15
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
}

function test_staticInitializerUsingThis() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:262:44
    Literal(lit &function LocalClass15); // 2                 ./test/end-to-end/tests/classes.test.mvm.js:263:3
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/classes.test.mvm.js:263:3
    ClassCreate();                       // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:263:3
    StoreVar(index 0);                   // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:263:3
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:263:3
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/classes.test.mvm.js:263:3
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:263:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:263:3
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:263:3
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:263:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:264:16
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:264:16
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:264:16
    Literal(lit 'y');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:264:16
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:267:16
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:267:16
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:267:16
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:267:31
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:267:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:267:31
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:269:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:269:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:269:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:269:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:269:15
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:269:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:269:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:269:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:270:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:270:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:270:15
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:270:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:270:15
    Literal(lit 8);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:270:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:270:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:270:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:271:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:271:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:271:2
}

function LocalClass15() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:263:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:263:3
}

function test_staticInitializerClosingUsingThis() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:273:1
    Literal(lit &function LocalClass16); // 1                 ./test/end-to-end/tests/classes.test.mvm.js:274:3
    ObjectNew();                         // 2  static props   ./test/end-to-end/tests/classes.test.mvm.js:274:3
    ClassCreate();                       // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:274:3
    StoreScoped(index 1);                // 0  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:274:3
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:274:3
    Literal(lit 'prototype');            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:274:3
    ObjectNew();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:274:3
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:274:3
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:274:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:274:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:275:16
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:275:16
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:275:16
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:275:16
    Literal(lit &function anonymous4);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:278:16
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:278:16
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:278:16
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:280:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:280:3
    LoadScoped(index 1);                 // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:280:15
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:280:15
    ObjectGet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:280:15
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:280:29
    Call(count 3);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:280:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:280:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:281:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:281:3
    LoadScoped(index 1);                 // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:281:15
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:281:15
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:281:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:281:15
    LoadVar(index 2);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:281:15
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:281:15
    StoreVar(index 2);                   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:281:15
    Literal(lit 8);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:281:31
    Call(count 3);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:281:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:281:31
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:282:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:282:2
}

function LocalClass16() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:274:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:274:3
}

function anonymous4() {
  entry:
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:278:22
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:278:22
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:278:22
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:278:37
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:278:37
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:278:37
}

function test_closureOverThisInConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:284:46
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:284:46
    Literal(lit &function LocalClass17); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:285:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:285:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:285:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:285:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:291:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:291:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:291:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:291:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:292:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:292:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:292:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:292:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:292:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:292:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:292:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:292:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:293:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:293:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:293:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:293:15
    Literal(lit 'y');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:293:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:293:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:293:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:293:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:293:15
    Literal(lit 8);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:293:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:293:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:293:25
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:294:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:294:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:294:2
}

function LocalClass17() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:285:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:286:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:286:9
    Literal(lit &function anonymous5);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:288:16
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:288:16
    LoadScoped(index 1);                 // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:288:7
    Literal(lit 'y');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:288:7
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:288:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:288:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:288:7
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:289:6
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:289:6
}

function anonymous5() {
  entry:
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:288:22
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:288:22
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:288:22
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:288:31
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:288:31
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:288:31
}

function test_closureOverThisInMethod() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:296:41
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:296:41
    Literal(lit &function LocalClass18); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:297:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:297:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:297:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:297:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:297:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:297:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:297:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:297:3
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:297:3
    Literal(lit &function LocalClass_method1); // 8           ./test/end-to-end/tests/classes.test.mvm.js:297:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:299:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:299:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:303:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:303:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:303:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:303:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:304:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:304:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:304:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:304:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:304:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:304:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:304:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:305:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:305:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:305:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:305:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:305:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:305:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:305:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:305:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:305:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:305:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:305:15
    Literal(lit 8);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:305:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:305:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:305:32
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:306:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:306:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:306:2
}

function LocalClass18() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:297:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:297:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:298:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:298:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:298:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:298:9
}

function LocalClass_method1() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:299:5
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:299:5
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:299:5
    Literal(lit &function anonymous6);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:300:14
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:300:14
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:300:14
}

function anonymous6() {
  entry:
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:300:20
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:300:20
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:300:20
    Literal(lit 3);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:300:29
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:300:29
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:300:29
}