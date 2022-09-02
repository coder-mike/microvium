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
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // #assertionCount: 66
    // testOnly: true
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:10:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Literal(lit 'my');                   // 2                 ./test/end-to-end/tests/classes.test.mvm.js:32:11
    StoreGlobal(name 'x');               // 1                 ./test/end-to-end/tests/classes.test.mvm.js:32:11
    Literal(lit &function GlobalClass);  // 2                 ./test/end-to-end/tests/classes.test.mvm.js:34:1
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/classes.test.mvm.js:34:1
    ClassCreate();                       // 2  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:34:1
    StoreGlobal(name 'GlobalClass');     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:34:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:34:1
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/classes.test.mvm.js:34:1
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:34:1
    LoadVar(index 3);                    // 5  GlobalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:34:1
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:34:1
    Literal(lit &function GlobalClass_myMethod); // 7         ./test/end-to-end/tests/classes.test.mvm.js:34:1
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:36:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:36:3
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:36:3
    Literal(lit 'myStaticMethod');       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:36:3
    Literal(lit &function GlobalClass_myStaticMethod); // 4   ./test/end-to-end/tests/classes.test.mvm.js:36:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:3
    Literal(lit 42);                     // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:22
    LoadGlobal(name 'GlobalClass');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:39:1
    Literal(lit 'myProp');               // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:1
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:39:1
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:41:24
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:41:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:41:36
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:41:36
    StoreGlobal(name 'globalInst');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:41:36
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:258:1
    Return();                            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:258:1
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
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:30:2
}

function GlobalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:35:29
    Literal(lit 5);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:35:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:33
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:35:20
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:35:20
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:35:20
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:35:20
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:35:36
}

function GlobalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:36:25
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:36:25
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:36:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:36:25
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:36:25
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:36:25
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:36:25
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:36:25
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:36:25
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:36:25
}

function GlobalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:37:39
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:39
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:39
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:39
    Branch(@block2, @block1);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:39
  block1:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:37:39
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:49
    Jump(@block2);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:49
  block2:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:54
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:54
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:37:29
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:37:29
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:37:29
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:37:29
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:37:64
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:64
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:64
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:37:64
}

function test_globalClass() {
  entry:
    Literal(lit deleted);                // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:43:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:44:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:44:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:45:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:45:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:45:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:45:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:46:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:46:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:35
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:46:35
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:46:35
    // Accessing instance created at runtime of a class created at compile time
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:49:20
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:49:20
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:49:32
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:49:32
    StoreVar(index 0);                   // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:49:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:50:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:50:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:50:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:50:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:50:15
    Literal(lit 25);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:50:23
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:50:23
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:50:23
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:51:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:51:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:51:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:51:15
    Literal(lit 26);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:51:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:51:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:51:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:52:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:52:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Literal(lit 27);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:52:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:53:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:53:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:53:2
}

function test_globalInstance() {
  entry:
    Literal(lit deleted);                // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:55:32
    Literal(lit 'ethod');                // 2                 ./test/end-to-end/tests/classes.test.mvm.js:56:13
    StoreVar(index 0);                   // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:56:13
    // Accessing instance constructed at compile time at the global scope
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:58:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:58:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    Literal(lit 15);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:58:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:58:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:58:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:59:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:59:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:59:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:59:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:60:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:60:15
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:60:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:61:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:15
    LoadGlobal(name 'x');                // 6                 ./test/end-to-end/tests/classes.test.mvm.js:61:26
    Literal(lit 'M');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:61:30
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:61:30
    LoadVar(index 0);                    // 7  y              ./test/end-to-end/tests/classes.test.mvm.js:61:36
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:61:36
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:36
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:61:36
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:36
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:36
    Literal(lit 18);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:42
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:42
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:42
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:62:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:62:2
}

function test_localClass() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:64:28
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:64:28
    Literal(lit &function LocalClass);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:65:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:65:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:65:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:65:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:65:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:65:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:65:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:65:3
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:65:3
    Literal(lit &function LocalClass_myMethod); // 8          ./test/end-to-end/tests/classes.test.mvm.js:65:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:67:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:67:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:67:5
    Literal(lit 'myStaticMethod');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:67:5
    Literal(lit &function LocalClass_myStaticMethod); // 5    ./test/end-to-end/tests/classes.test.mvm.js:67:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:68:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:23
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:70:3
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:70:3
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:70:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:3
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:72:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:72:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:73:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:73:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:73:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:73:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:73:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:74:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:74:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:74:15
    Literal(lit 'myProp');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:74:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:74:15
    Literal(lit 42);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:74:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:74:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:74:34
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:76:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:76:20
    Literal(lit 30);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:76:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:76:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:76:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:77:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:77:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:77:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    Literal(lit 37);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:77:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:77:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:77:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:78:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:78:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:78:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:78:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:78:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:78:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:78:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:78:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:78:15
    Literal(lit 39);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:78:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:78:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:78:32
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:79:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:79:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:79:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:79:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:79:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:79:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:79:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:79:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:79:15
    Literal(lit 40);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:79:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:79:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:79:32
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:80:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:80:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:80:2
}

function LocalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:66:31
    Literal(lit 7);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:66:35
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:35
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:66:22
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:66:22
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:66:22
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:66:22
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:38
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:66:38
}

function LocalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:67:27
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:67:27
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:67:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:67:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:67:27
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:67:27
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:67:27
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:67:27
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:67:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:67:36
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:67:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:67:36
}

function LocalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:68:41
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:68:41
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:41
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:68:41
    Branch(@block4, @block3);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:41
  block3:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:68:41
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:51
    Jump(@block4);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:51
  block4:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:68:56
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:56
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:68:31
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:68:31
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:68:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:68:31
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:68:66
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:68:66
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:68:66
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:68:66
}

function test_inheritedProperties() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:82:37
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:82:37
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:82:37
    Literal(lit &function LocalClass1);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:88:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:88:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:88:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:88:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:89:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:89:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:89:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:89:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:89:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:89:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:89:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:89:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:91:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:91:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:91:21
    StoreVar(index 1);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:91:21
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:92:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:92:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:92:21
    StoreVar(index 2);                   // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:92:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:94:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:94:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:94:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:94:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:94:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:95:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:95:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:95:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:95:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:95:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:97:13
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:97:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:97:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:97:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:97:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:97:3
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:98:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:98:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:100:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:100:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:100:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:100:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:100:24
    // instance property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:101:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:101:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:101:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:101:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:101:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:101:24
    // prototype property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:102:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:102:3
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:102:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:102:19
    New(count 1);                        // 6                 ./test/end-to-end/tests/classes.test.mvm.js:102:19
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:102:19
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:102:19
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:102:35
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:102:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:102:35
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:103:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:103:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:103:2
}

// * The objective of this test is to confirm that properties on the prototype
   * can be overridden in instances without affecting the prototype.
function LocalClass1() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
}

function test_proto() {
  entry:
    Literal(lit deleted);                // 1  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:105:23
    Literal(lit deleted);                // 2  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:105:23
    Literal(lit deleted);                // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:105:23
    Literal(lit &function LocalClass2);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:106:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:106:3
    ClassCreate();                       // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:106:3
    StoreVar(index 0);                   // 3  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:106:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:106:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:106:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:106:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:106:3
    Literal(lit &function LocalClass3);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:107:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:107:3
    ClassCreate();                       // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:107:3
    StoreVar(index 1);                   // 3  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:107:3
    LoadVar(index 1);                    // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:107:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:107:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:107:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:107:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:108:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:108:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:108:21
    StoreVar(index 2);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:108:21
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:109:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:109:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:109:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:109:10
    LoadVar(index 0);                    // 7  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:109:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:109:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:109:30
    BinOp(op '===');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:109:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:109:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:109:30
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:110:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:110:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:110:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:110:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:110:10
    LoadVar(index 1);                    // 7  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:110:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:110:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:110:30
    BinOp(op '!==');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:110:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:110:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:110:30
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:111:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:111:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:111:2
}

function LocalClass2() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:106:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:106:3
}

function LocalClass3() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:107:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:107:3
}

function test_returnFromConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:113:39
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:113:39
    Literal(lit &function LocalClass4);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:118:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:118:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:118:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:118:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:118:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:118:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:118:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:118:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:121:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:121:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:121:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:121:20
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:122:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:122:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:122:10
    Literal(lit '__proto__');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:122:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:122:10
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:122:29
    Literal(lit 'prototype');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:122:29
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:122:29
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:122:29
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:122:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:122:29
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:123:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:123:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:123:10
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:123:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:123:10
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:123:21
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:123:21
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:123:21
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:123:21
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:124:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:124:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:124:2
}

// I don't expect anyone to use this edge case, but Microvium happens to
// support it because a return statement in a constructor is just handled as a
// normal return.
function LocalClass4() {
  entry:
    ObjectNew();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:119:28
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:119:28
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:119:28
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:119:33
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:119:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:119:33
}

function test_operators() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:126:27
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:126:27
    Literal(lit &function LocalClass5);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:127:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:127:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:127:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:127:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:128:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:128:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:128:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:128:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:129:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:129:22
    Literal(lit 'function');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:129:34
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:130:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:130:22
    Literal(lit 'object');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:130:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:130:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:130:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:131:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:131:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:131:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:131:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:131:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:131:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:131:15
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:131:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:131:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:131:36
    Literal(lit 9);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:131:49
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:131:49
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:131:49
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:132:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:132:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:132:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:132:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:132:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:132:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:132:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:132:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:132:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:132:36
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:132:43
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:132:43
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:132:43
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:133:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:133:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:133:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:133:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:133:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:134:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:134:23
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:135:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:135:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:135:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:135:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:135:10
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:135:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:135:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:135:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:135:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:135:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:135:24
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:136:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:136:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:136:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:136:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:136:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:136:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:136:10
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:136:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:136:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:136:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:136:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:136:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:136:24
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:137:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:137:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:137:2
}

function LocalClass5() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
}

function test_classAsMember() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:139:31
    Literal(lit deleted);                // 2  obj            ./test/end-to-end/tests/classes.test.mvm.js:139:31
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:139:31
    Literal(lit &function LocalClass6);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:140:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:140:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:140:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:140:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:140:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:140:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:140:3
    LoadVar(index 5);                    // 7  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:140:3
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:140:3
    Literal(lit &function LocalClass_foo); // 9               ./test/end-to-end/tests/classes.test.mvm.js:140:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:142:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:142:5
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:145:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:145:15
    Literal(lit 'LocalClass');           // 6                 ./test/end-to-end/tests/classes.test.mvm.js:145:15
    LoadVar(index 0);                    // 7  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:145:17
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:145:17
    StoreVar(index 1);                   // 3  obj            ./test/end-to-end/tests/classes.test.mvm.js:145:17
    LoadVar(index 1);                    // 4  obj            ./test/end-to-end/tests/classes.test.mvm.js:146:20
    Literal(lit 'LocalClass');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:146:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:146:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:146:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:146:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:146:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:147:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:147:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:147:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:147:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:147:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:147:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:147:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:147:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:148:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:148:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:148:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:148:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:148:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:148:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:148:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:149:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:149:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:149:2
}

function LocalClass6() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:141:30
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:141:21
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:141:21
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:141:21
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:141:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:141:21
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:141:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:141:33
}

function LocalClass_foo() {
  entry:
    Literal(lit 10);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:142:20
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:142:20
}

function test_closingOverClass() {
  entry:
    Literal(lit &function inner);        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:151:34
    Literal(lit deleted);                // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:151:34
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:151:34
    LoadVar(index 0);                    // 4  inner          ./test/end-to-end/tests/classes.test.mvm.js:160:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:160:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:160:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:160:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:160:22
    StoreVar(index 1);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:160:22
    LoadVar(index 1);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:161:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:161:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:161:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:161:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:162:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:162:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:162:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:162:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:162:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:162:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:162:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:162:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:163:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:163:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:163:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:163:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:163:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:163:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:163:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:163:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:163:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:163:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:163:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:163:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:164:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:164:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:164:2
}

function inner() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:152:3
    Literal(lit &function LocalClass7);  // 1                 ./test/end-to-end/tests/classes.test.mvm.js:153:5
    ObjectNew();                         // 2  static props   ./test/end-to-end/tests/classes.test.mvm.js:153:5
    ClassCreate();                       // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:153:5
    StoreScoped(index 1);                // 0  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:153:5
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:153:5
    Literal(lit 'prototype');            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:153:5
    ObjectNew();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:153:5
    LoadVar(index 2);                    // 4  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:153:5
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:153:5
    Literal(lit &function LocalClass_foo1); // 6              ./test/end-to-end/tests/classes.test.mvm.js:153:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:155:7
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:155:7
    Literal(lit &function anonymous);    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:157:12
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:157:12
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:157:12
}

function LocalClass7() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:154:32
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:154:23
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:154:23
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:154:23
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:154:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:154:23
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:154:35
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:154:35
}

function LocalClass_foo1() {
  entry:
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:155:22
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:155:22
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:157:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:157:18
}

function test_closureInConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:166:38
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:166:38
    Literal(lit &function LocalClass8);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:167:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:167:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:167:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:167:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:172:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:172:20
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:172:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:172:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:172:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:173:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:173:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:173:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:173:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:173:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:173:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:174:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:174:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:174:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:174:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:174:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:174:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:174:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:174:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:174:15
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:174:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:174:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:174:27
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:175:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:175:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:175:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:175:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:175:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:175:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:175:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:175:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:175:15
    Literal(lit 7);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:175:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:175:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:175:27
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:176:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:176:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:176:2
}

function LocalClass8() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    LoadArg(index 1);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:168:5
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:168:5
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:169:18
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:169:18
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:169:7
    Literal(lit 'foo');                  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:169:7
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:169:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:169:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:169:7
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:170:6
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:170:6
}

function anonymous1() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:169:24
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:169:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:169:24
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:169:24
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:169:24
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:169:24
}

function test_classProperty() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:178:31
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:178:31
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:178:31
    Literal(lit deleted);                // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:178:31
    Literal(lit &function LocalClass9);  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    ObjectNew();                         // 6  static props   ./test/end-to-end/tests/classes.test.mvm.js:179:3
    ClassCreate();                       // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:179:3
    StoreVar(index 0);                   // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:179:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:179:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    ObjectNew();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:180:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:180:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:180:21
    StoreVar(index 1);                   // 4  inst1          ./test/end-to-end/tests/classes.test.mvm.js:180:21
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:181:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:181:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:181:21
    StoreVar(index 2);                   // 4  inst2          ./test/end-to-end/tests/classes.test.mvm.js:181:21
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:182:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:182:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:182:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:182:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:182:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:182:24
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    LoadVar(index 5);                    // 9                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:184:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:184:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:184:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:184:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:184:15
    Literal(lit 6);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:185:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:185:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:185:15
    Literal(lit '__proto__');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:185:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:185:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:185:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:185:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:185:34
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:185:34
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:185:34
    // The property is not on the prototype
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    LoadVar(index 2);                    // 7  inst2          ./test/end-to-end/tests/classes.test.mvm.js:186:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:186:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:186:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    // Test that properties are independent
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/classes.test.mvm.js:188:16
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:188:16
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:188:16
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:188:16
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:188:16
    LoadVar(index 1);                    // 8  inst1          ./test/end-to-end/tests/classes.test.mvm.js:188:32
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:188:32
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:188:32
    StoreVar(index 3);                   // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:188:32
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:189:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:189:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:189:15
    Literal(lit 'length');               // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:189:15
    Literal(lit 2);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:28
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:189:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:189:28
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:190:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:190:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:190:15
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:190:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:190:20
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:191:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:191:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:191:15
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:191:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:191:20
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:191:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:191:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:191:24
    // y is a key
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:192:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:192:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:192:15
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:192:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:192:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:192:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:192:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:192:24
    Pop(count 4);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:193:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:193:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:193:2
}

function LocalClass9() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:179:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:179:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:179:26
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:179:26
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:179:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:179:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:179:26
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:179:26
}

function test_classStaticProperty() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:195:37
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:195:37
    Literal(lit &function LocalClass10); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:196:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:196:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:196:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:196:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:196:3
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:197:16
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:197:16
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:197:16
    Literal(lit 'y');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:197:16
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:197:16
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:197:16
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:200:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:200:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:200:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:200:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:201:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:201:3
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/classes.test.mvm.js:201:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:201:15
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:201:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:201:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:201:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:201:31
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:201:31
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:201:31
    Literal(lit 'length');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:201:31
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:201:31
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:201:45
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:201:45
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:201:45
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:202:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:202:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:202:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:202:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:202:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:202:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:202:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:202:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:203:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:203:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:203:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:203:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:203:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:203:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:203:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:203:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:204:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:204:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:204:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:204:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:204:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:204:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:204:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:204:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:205:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:205:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:205:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:205:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:205:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:205:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:205:29
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:206:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:206:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:206:2
}

function LocalClass10() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:196:3
}

function test_closureMethod() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:208:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:208:31
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:208:31
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:209:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:209:11
    Literal(lit &function LocalClass11); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:210:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:210:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:210:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:210:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:210:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:210:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:210:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:210:3
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:210:3
    Literal(lit &function LocalClass_method); // 8            ./test/end-to-end/tests/classes.test.mvm.js:210:3
    ClosureNew();                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:210:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:211:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:211:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:216:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:216:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:216:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:216:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:217:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:217:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:217:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:217:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:217:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:217:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:217:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:217:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:217:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:217:30
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:217:30
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:217:30
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:218:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:218:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:218:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:218:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:218:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:218:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:218:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:218:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:218:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:218:30
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:218:30
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:218:30
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/classes.test.mvm.js:219:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:219:18
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:219:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:219:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:220:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:220:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:220:2
}

function LocalClass11() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:210:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:210:3
}

function LocalClass_method() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:212:14
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:212:14
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:212:14
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:212:14
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:212:14
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:212:14
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:212:14
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:212:14
}

function test_thisInInitializer() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:222:35
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:222:35
    Literal(lit &function LocalClass12); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:223:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:223:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:223:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:223:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:223:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:223:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:223:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:223:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:228:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:228:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:228:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:228:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:229:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:229:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:229:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:229:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:229:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:229:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:229:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:229:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:230:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:230:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:230:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:230:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:230:15
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:230:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:230:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:230:23
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:231:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:231:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:231:2
}

function LocalClass12() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:223:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:223:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:224:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:224:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:224:9
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:224:9
    LoadArg(index 0);                    // 3  this           ./test/end-to-end/tests/classes.test.mvm.js:225:9
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:225:9
    ObjectGet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:225:9
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:225:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:225:18
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:225:18
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:225:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:225:18
}

function test_initializerClosingOverThis() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:233:44
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:233:44
    Literal(lit deleted);                // 3  f              ./test/end-to-end/tests/classes.test.mvm.js:233:44
    Literal(lit &function LocalClass13); // 4                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:234:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:234:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:234:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:234:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:239:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:239:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:239:20
    StoreVar(index 1);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:239:20
    LoadVar(index 1);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:240:13
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:240:13
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:240:13
    StoreVar(index 2);                   // 3  f              ./test/end-to-end/tests/classes.test.mvm.js:240:13
    // call y without passing `this`
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:241:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:241:3
    LoadVar(index 2);                    // 6  f              ./test/end-to-end/tests/classes.test.mvm.js:241:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:241:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:241:15
    Literal(lit 6);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:241:20
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:241:20
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:241:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:242:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:242:3
    LoadVar(index 2);                    // 6  f              ./test/end-to-end/tests/classes.test.mvm.js:242:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:242:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:242:15
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:242:20
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:242:20
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:242:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:243:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:243:3
    LoadVar(index 1);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:243:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:243:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:243:15
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:243:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:243:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:243:23
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:244:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:244:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:244:2
}

function LocalClass13() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:234:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:235:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:235:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:235:9
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:235:9
    Literal(lit &function anonymous2);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:236:9
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:236:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:236:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:236:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:236:9
}

function anonymous2() {
  entry:
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:236:17
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:236:17
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:236:17
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:236:17
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:236:17
    LoadScoped(index 1);                 // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:236:17
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:236:17
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:236:17
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:236:17
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:236:17
}

function test_initializerClosingOverOuter() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:246:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:246:45
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:246:45
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:247:15
    StoreScoped(index 1);                // 2  count          ./test/end-to-end/tests/classes.test.mvm.js:247:15
    Literal(lit &function LocalClass14); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:248:3
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:248:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:248:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:248:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:248:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:248:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:248:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:248:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:248:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:252:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:252:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:252:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:252:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:253:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:253:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:253:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:253:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:253:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:253:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:253:25
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:254:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:254:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:254:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:254:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:254:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:254:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:254:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:254:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:254:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:254:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:254:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:254:25
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:255:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:255:3
    LoadScoped(index 1);                 // 5  count          ./test/end-to-end/tests/classes.test.mvm.js:255:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:255:22
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:255:22
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:255:22
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:256:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:256:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:256:2
}

function LocalClass14() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:248:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:248:3
    Literal(lit &function anonymous3);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:249:9
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:249:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:249:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:249:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:249:9
}

function anonymous3() {
  entry:
    LoadScoped(index 1);                 // 1  count          ./test/end-to-end/tests/classes.test.mvm.js:249:15
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:249:15
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:249:15
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:249:15
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:249:15
    StoreScoped(index 1);                // 2  count          ./test/end-to-end/tests/classes.test.mvm.js:249:15
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:249:15
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:249:15
}

function test_staticInitializerUsingThis() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:258:44
    Literal(lit &function LocalClass15); // 2                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/classes.test.mvm.js:259:3
    ClassCreate();                       // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:259:3
    StoreVar(index 0);                   // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:259:3
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:259:3
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:259:3
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:260:16
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:260:16
    LoadVar(index 0);                    // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:260:16
    Literal(lit 'y');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:260:16
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:263:16
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:263:16
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:263:16
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:263:31
    BinOp(op '+');                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:263:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:263:31
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:265:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:265:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:265:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:265:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:265:15
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:265:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:265:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:265:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:266:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:266:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:266:15
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:266:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:266:15
    Literal(lit 8);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:266:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:266:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:266:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:267:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:267:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:267:2
}

function LocalClass15() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:259:3
}