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
global test_closureMethod;
global test_thisInInitializer;
global test_initializerClosingOverThis;
global test_initializerClosingOverOuter;

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
    Literal(lit &function test_closureMethod); // 2           ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_closureMethod'); // 1              ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_thisInInitializer); // 2       ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_thisInInitializer'); // 1          ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_initializerClosingOverThis); // 2  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_initializerClosingOverThis'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    Literal(lit &function test_initializerClosingOverOuter); // 2  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    StoreGlobal(name 'test_initializerClosingOverOuter'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:1:1
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // assertionCount: 59
    // testOnly: true
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:10:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Literal(lit 'my');                   // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:11
    StoreGlobal(name 'x');               // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:11
    Literal(lit &function GlobalClass);  // 2                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/classes.test.mvm.js:32:1
    ClassCreate();                       // 2  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:32:1
    StoreGlobal(name 'GlobalClass');     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    LoadVar(index 3);                    // 5  GlobalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:32:1
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:32:1
    Literal(lit &function GlobalClass_myMethod); // 7         ./test/end-to-end/tests/classes.test.mvm.js:32:1
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:34:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:34:3
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:34:3
    Literal(lit 'myStaticMethod');       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:34:3
    Literal(lit &function GlobalClass_myStaticMethod); // 4   ./test/end-to-end/tests/classes.test.mvm.js:34:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:3
    Literal(lit 42);                     // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:22
    LoadGlobal(name 'GlobalClass');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    Literal(lit 'myProp');               // 4                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:37:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:24
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:39:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:36
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:36
    StoreGlobal(name 'globalInst');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:36
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:231:1
    Return();                            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:231:1
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
    LoadGlobal(name 'test_closureMethod'); // 1               ./test/end-to-end/tests/classes.test.mvm.js:24:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:24:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:24:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:24:3
    LoadGlobal(name 'test_thisInInitializer'); // 1           ./test/end-to-end/tests/classes.test.mvm.js:25:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:25:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:25:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:25:3
    LoadGlobal(name 'test_initializerClosingOverThis'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:26:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:26:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:26:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:26:3
    LoadGlobal(name 'test_initializerClosingOverOuter'); // 1  ./test/end-to-end/tests/classes.test.mvm.js:27:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:27:3
    Call(count 1);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:27:3
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:27:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:28:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:28:2
}

function GlobalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:33:29
    Literal(lit 5);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:33:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:33:33
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:33:20
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:33:20
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:33:20
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:33:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:33:20
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:33:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:33:36
}

function GlobalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:34:25
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:34:25
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:34:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:34:25
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:34:25
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:34:25
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:34:25
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:34:25
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:34:25
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:34:25
}

function GlobalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:35:39
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:35:39
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:39
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:35:39
    Branch(@block2, @block1);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:39
  block1:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:35:39
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:49
    Jump(@block2);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:49
  block2:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:35:54
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:54
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:35:29
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:35:29
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:35:29
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:35:29
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:35:64
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:35:64
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:64
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:35:64
}

function test_globalClass() {
  entry:
    Literal(lit deleted);                // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:41:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:42:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:42:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:42:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:42:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:42:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:42:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:42:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:42:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:42:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:42:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:42:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:42:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:43:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:43:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:43:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:43:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:43:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:43:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:44:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:35
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:35
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:44:35
    // Accessing instance created at runtime of a class created at compile time
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:47:20
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:47:20
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:47:32
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:47:32
    StoreVar(index 0);                   // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:47:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:48:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:48:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:48:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:48:15
    Literal(lit 25);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:48:23
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:48:23
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:48:23
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:49:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:49:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:49:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:49:15
    Literal(lit 26);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:49:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:49:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:49:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:50:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:50:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:50:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:50:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:50:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:50:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:50:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:50:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:50:15
    Literal(lit 27);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:50:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:50:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:50:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:51:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:51:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:51:2
}

function test_globalInstance() {
  entry:
    Literal(lit deleted);                // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:53:32
    Literal(lit 'ethod');                // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:13
    StoreVar(index 0);                   // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:54:13
    // Accessing instance constructed at compile time at the global scope
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:56:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:56:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:56:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:56:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:56:15
    Literal(lit 15);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:56:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:56:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:56:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:57:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:57:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:57:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:57:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:57:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:57:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:57:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:57:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:57:15
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:57:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:57:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:57:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:58:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:58:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:58:15
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:58:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:58:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:58:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:59:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:59:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:15
    LoadGlobal(name 'x');                // 6                 ./test/end-to-end/tests/classes.test.mvm.js:59:26
    Literal(lit 'M');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:59:30
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:59:30
    LoadVar(index 0);                    // 7  y              ./test/end-to-end/tests/classes.test.mvm.js:59:36
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:59:36
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:36
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:59:36
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:36
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:59:36
    Literal(lit 18);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:42
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:59:42
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:59:42
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:60:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:60:2
}

function test_localClass() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:62:28
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:62:28
    Literal(lit &function LocalClass);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:63:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:63:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:63:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:63:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:63:3
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:63:3
    Literal(lit &function LocalClass_myMethod); // 8          ./test/end-to-end/tests/classes.test.mvm.js:63:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:65:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:65:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:65:5
    Literal(lit 'myStaticMethod');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:65:5
    Literal(lit &function LocalClass_myStaticMethod); // 5    ./test/end-to-end/tests/classes.test.mvm.js:65:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:66:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:68:23
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:68:3
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:70:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:70:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:70:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:70:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:70:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:70:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:70:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:70:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:70:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:70:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:71:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:71:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:71:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:71:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:71:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Literal(lit 'myProp');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Literal(lit 42);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:72:34
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:74:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:74:20
    Literal(lit 30);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:74:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:74:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:74:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:75:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:75:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:75:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:75:15
    Literal(lit 37);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:75:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:75:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:75:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:76:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:76:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:76:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:76:15
    Literal(lit 39);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:76:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:76:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:76:32
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:77:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:77:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:77:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:77:15
    Literal(lit 40);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:77:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:77:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:77:32
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:78:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:78:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:78:2
}

function LocalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:64:31
    Literal(lit 7);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:64:35
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:64:35
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:64:22
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:64:22
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:64:22
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:64:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:64:22
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:64:38
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:64:38
}

function LocalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:65:27
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:65:27
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:65:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:65:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:65:27
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:65:27
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:65:27
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:65:27
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:65:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:65:36
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:65:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:65:36
}

function LocalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:66:41
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:66:41
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:41
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:66:41
    Branch(@block4, @block3);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:41
  block3:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:66:41
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:51
    Jump(@block4);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:51
  block4:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:66:56
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:56
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:66:31
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:66:31
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:66:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:66:31
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:66:66
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:66:66
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:66:66
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:66:66
}

function test_inheritedProperties() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:80:37
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:80:37
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:80:37
    Literal(lit &function LocalClass1);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:86:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:86:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:86:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:86:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:86:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:86:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:86:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:86:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:87:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:87:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:87:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:87:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:87:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:87:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:87:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:87:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:89:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:89:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:89:21
    StoreVar(index 1);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:89:21
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:90:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:90:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:90:21
    StoreVar(index 2);                   // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:90:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:92:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:92:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:92:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:92:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:92:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:92:24
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:93:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:93:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:93:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:93:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:93:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:93:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:93:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:93:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:13
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:95:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:96:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:96:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:98:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:98:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:98:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:98:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:98:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:98:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:98:24
    // instance property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:99:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:99:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:99:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:99:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:99:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:99:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:99:24
    // prototype property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:100:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:100:19
    New(count 1);                        // 6                 ./test/end-to-end/tests/classes.test.mvm.js:100:19
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:100:19
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:100:19
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:100:35
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:100:35
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:101:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:101:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:101:2
}

// * The objective of this test is to confirm that properties on the prototype
   * can be overridden in instances without affecting the prototype.
function LocalClass1() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:86:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:86:3
}

function test_proto() {
  entry:
    Literal(lit deleted);                // 1  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:103:23
    Literal(lit deleted);                // 2  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:103:23
    Literal(lit deleted);                // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:103:23
    Literal(lit &function LocalClass2);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:104:3
    ClassCreate();                       // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:104:3
    StoreVar(index 0);                   // 3  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:104:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:104:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    Literal(lit &function LocalClass3);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:105:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:105:3
    ClassCreate();                       // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:105:3
    StoreVar(index 1);                   // 3  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:105:3
    LoadVar(index 1);                    // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:105:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:105:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:105:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:105:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:106:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:106:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:106:21
    StoreVar(index 2);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:106:21
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:107:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:107:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:107:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:107:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:107:10
    LoadVar(index 0);                    // 7  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:107:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:107:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:107:30
    BinOp(op '===');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:107:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:107:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:107:30
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:108:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:108:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:108:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:108:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:108:10
    LoadVar(index 1);                    // 7  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:108:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:108:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:108:30
    BinOp(op '!==');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:108:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:108:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:108:30
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:109:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:109:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:109:2
}

function LocalClass2() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
}

function LocalClass3() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:105:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:105:3
}

function test_returnFromConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:111:39
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:111:39
    Literal(lit &function LocalClass4);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:116:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:116:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:116:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:116:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:116:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:116:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:116:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:116:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:119:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:119:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:119:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:119:20
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:120:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:120:10
    Literal(lit '__proto__');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:120:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:120:10
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:120:29
    Literal(lit 'prototype');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:120:29
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:120:29
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:120:29
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:120:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:120:29
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:121:10
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:121:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:121:10
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:121:21
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:121:21
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:121:21
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:121:21
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:122:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:122:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:122:2
}

// I don't expect anyone to use this edge case, but Microvium happens to
// support it because a return statement in a constructor is just handled as a
// normal return.
function LocalClass4() {
  entry:
    ObjectNew();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:117:28
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:117:28
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:117:28
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:117:33
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:117:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:117:33
}

function test_operators() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:124:27
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:124:27
    Literal(lit &function LocalClass5);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:125:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:125:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:125:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:125:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:126:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:126:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:126:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:126:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:127:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:127:22
    Literal(lit 'function');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:127:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:127:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:127:34
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:128:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:128:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:128:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:128:22
    Literal(lit 'object');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:128:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:128:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:128:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:129:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:129:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:129:15
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:129:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:129:36
    Literal(lit 9);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:49
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:49
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:129:49
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:130:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:130:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:130:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:130:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:130:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:130:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:130:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:130:36
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:130:43
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:130:43
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:130:43
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:131:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:131:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:131:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:131:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:131:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:131:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:131:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:131:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:132:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:132:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:132:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:132:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:132:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:132:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:132:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:132:23
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:133:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:133:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:133:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:133:10
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:133:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:133:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:133:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:133:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:133:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:133:24
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:134:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:134:10
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:134:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:134:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:134:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:134:24
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:135:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:135:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:135:2
}

function LocalClass5() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
}

function test_classAsMember() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:137:31
    Literal(lit deleted);                // 2  obj            ./test/end-to-end/tests/classes.test.mvm.js:137:31
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:137:31
    Literal(lit &function LocalClass6);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:138:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:138:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:138:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:138:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:138:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:138:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:138:3
    LoadVar(index 5);                    // 7  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:138:3
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:138:3
    Literal(lit &function LocalClass_foo); // 9               ./test/end-to-end/tests/classes.test.mvm.js:138:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:140:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:140:5
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:143:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:143:15
    Literal(lit 'LocalClass');           // 6                 ./test/end-to-end/tests/classes.test.mvm.js:143:15
    LoadVar(index 0);                    // 7  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:143:17
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:143:17
    StoreVar(index 1);                   // 3  obj            ./test/end-to-end/tests/classes.test.mvm.js:143:17
    LoadVar(index 1);                    // 4  obj            ./test/end-to-end/tests/classes.test.mvm.js:144:20
    Literal(lit 'LocalClass');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:144:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:144:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:144:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:144:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:144:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:145:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:145:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:145:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:145:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:145:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:145:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:145:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:145:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:146:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:146:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:146:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:146:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:146:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:146:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:146:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:146:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:146:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:146:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:146:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:146:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:147:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:147:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:147:2
}

function LocalClass6() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:139:30
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:139:21
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:139:21
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:139:21
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:139:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:139:21
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:139:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:139:33
}

function LocalClass_foo() {
  entry:
    Literal(lit 10);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:140:20
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:140:20
}

function test_closingOverClass() {
  entry:
    Literal(lit &function inner);        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:149:34
    Literal(lit deleted);                // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:149:34
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:149:34
    LoadVar(index 0);                    // 4  inner          ./test/end-to-end/tests/classes.test.mvm.js:158:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:158:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:158:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:158:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:158:22
    StoreVar(index 1);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:158:22
    LoadVar(index 1);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:159:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:159:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:159:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:159:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:160:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:160:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:160:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:160:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:160:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:160:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:160:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:160:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:161:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:161:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:161:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:161:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:161:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:161:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:161:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:161:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:161:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:161:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:161:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:161:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:162:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:162:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:162:2
}

function inner() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:150:3
    Literal(lit &function LocalClass7);  // 1                 ./test/end-to-end/tests/classes.test.mvm.js:151:5
    ObjectNew();                         // 2  static props   ./test/end-to-end/tests/classes.test.mvm.js:151:5
    ClassCreate();                       // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:151:5
    StoreScoped(index 1);                // 0  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:151:5
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:151:5
    Literal(lit 'prototype');            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:151:5
    ObjectNew();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:151:5
    LoadVar(index 2);                    // 4  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:151:5
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:151:5
    Literal(lit &function LocalClass_foo1); // 6              ./test/end-to-end/tests/classes.test.mvm.js:151:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:153:7
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:153:7
    Literal(lit &function anonymous);    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:155:12
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:155:12
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:155:12
}

function LocalClass7() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:152:32
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:152:23
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:152:23
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:152:23
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:152:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:152:23
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:152:35
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:152:35
}

function LocalClass_foo1() {
  entry:
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:153:22
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:153:22
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:155:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:155:18
}

function test_closureInConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:164:38
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:164:38
    Literal(lit &function LocalClass8);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:165:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:165:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:165:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:165:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:170:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:170:20
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:170:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:170:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:170:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:171:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:171:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:171:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:171:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:171:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:171:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:171:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:171:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:172:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:172:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:172:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:172:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:172:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:172:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:172:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:172:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:172:15
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:172:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:172:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:172:27
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:173:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:173:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:173:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:173:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:173:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:173:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:173:15
    Literal(lit 7);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:173:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:173:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:173:27
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:174:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:174:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:174:2
}

function LocalClass8() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:165:3
    LoadArg(index 1);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:166:5
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:166:5
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:167:18
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:167:18
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:167:7
    Literal(lit 'foo');                  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:167:7
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:167:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:167:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:167:7
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:168:6
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:168:6
}

function anonymous1() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:167:24
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:167:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:167:24
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:167:24
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:167:24
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:167:24
}

function test_classProperty() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:176:31
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:176:31
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:176:31
    Literal(lit deleted);                // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:176:31
    Literal(lit &function LocalClass9);  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    ObjectNew();                         // 6  static props   ./test/end-to-end/tests/classes.test.mvm.js:177:3
    ClassCreate();                       // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:177:3
    StoreVar(index 0);                   // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:177:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    ObjectNew();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:178:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:178:21
    StoreVar(index 1);                   // 4  inst1          ./test/end-to-end/tests/classes.test.mvm.js:178:21
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:179:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:179:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:179:21
    StoreVar(index 2);                   // 4  inst2          ./test/end-to-end/tests/classes.test.mvm.js:179:21
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:180:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:180:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:180:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:180:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:180:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:180:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:180:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:180:24
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:181:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:181:3
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    LoadVar(index 5);                    // 9                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:181:3
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:182:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:182:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:182:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:182:15
    Literal(lit 6);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:182:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:182:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:182:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:183:15
    Literal(lit '__proto__');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:183:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:183:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:183:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:183:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:183:34
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:183:34
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:183:34
    // The property is not on the prototype
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:184:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:184:3
    LoadVar(index 2);                    // 7  inst2          ./test/end-to-end/tests/classes.test.mvm.js:184:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:184:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:184:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    // Test that properties are independent
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:16
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:16
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:186:16
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:16
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:186:16
    LoadVar(index 1);                    // 8  inst1          ./test/end-to-end/tests/classes.test.mvm.js:186:32
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:32
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:32
    StoreVar(index 3);                   // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:186:32
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:187:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:187:15
    Literal(lit 'length');               // 8                 ./test/end-to-end/tests/classes.test.mvm.js:187:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:187:15
    Literal(lit 2);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:187:28
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:187:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:187:28
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:188:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:188:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:188:15
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:188:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:188:20
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:188:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:188:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:188:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:189:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:189:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:189:15
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:189:20
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:189:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:189:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:189:24
    // y is a key
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:190:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:190:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:190:15
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:190:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:190:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:190:24
    Pop(count 4);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:191:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:191:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:191:2
}

function LocalClass9() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:177:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:177:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:177:26
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:177:26
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:177:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:177:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:177:26
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:177:26
}

function test_closureMethod() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:193:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:193:31
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:193:31
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:194:11
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:194:11
    Literal(lit &function LocalClass10); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:195:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:195:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:195:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:195:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:195:3
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    Literal(lit &function LocalClass_method); // 8            ./test/end-to-end/tests/classes.test.mvm.js:195:3
    ClosureNew();                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:196:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:196:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:201:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:201:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:201:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:201:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:202:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:202:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:202:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:202:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:202:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:202:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:202:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:202:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:202:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:202:30
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:202:30
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:202:30
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:203:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:203:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:203:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:203:15
    Literal(lit 'method');               // 7                 ./test/end-to-end/tests/classes.test.mvm.js:203:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:203:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:203:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:203:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:203:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:203:30
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:203:30
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:203:30
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:204:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:204:3
    LoadScoped(index 1);                 // 5  x              ./test/end-to-end/tests/classes.test.mvm.js:204:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:204:18
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:204:18
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:204:18
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:205:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:205:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:205:2
}

function LocalClass10() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:195:3
}

function LocalClass_method() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:197:14
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:197:14
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:197:14
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:197:14
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:197:14
    StoreScoped(index 1);                // 2  x              ./test/end-to-end/tests/classes.test.mvm.js:197:14
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:197:14
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:197:14
}

function test_thisInInitializer() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:207:35
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:207:35
    Literal(lit &function LocalClass11); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:208:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:208:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:208:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:208:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:213:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:213:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:213:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:213:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:214:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:214:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:214:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:214:15
    Literal(lit 5);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:214:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:214:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:214:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:215:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:215:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:215:15
    Literal(lit 'y');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:215:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:215:15
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:215:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:215:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:215:23
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:216:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:216:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:216:2
}

function LocalClass11() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:208:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:209:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:209:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:209:9
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:209:9
    LoadArg(index 0);                    // 3  this           ./test/end-to-end/tests/classes.test.mvm.js:210:9
    Literal(lit 'x');                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:210:9
    ObjectGet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:210:9
    Literal(lit 1);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:210:18
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:210:18
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:210:18
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:210:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:210:18
}

function test_initializerClosingOverThis() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:218:44
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:218:44
    Literal(lit deleted);                // 3  f              ./test/end-to-end/tests/classes.test.mvm.js:218:44
    Literal(lit &function LocalClass12); // 4                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:219:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:219:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:219:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:219:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:224:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:224:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:224:20
    StoreVar(index 1);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:224:20
    LoadVar(index 1);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:225:13
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:225:13
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:225:13
    StoreVar(index 2);                   // 3  f              ./test/end-to-end/tests/classes.test.mvm.js:225:13
    // call y without passing `this`
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:226:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:226:3
    LoadVar(index 2);                    // 6  f              ./test/end-to-end/tests/classes.test.mvm.js:226:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:226:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:226:15
    Literal(lit 6);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:226:20
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:226:20
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:226:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:227:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:227:3
    LoadVar(index 2);                    // 6  f              ./test/end-to-end/tests/classes.test.mvm.js:227:15
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:227:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:227:15
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:227:20
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:227:20
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:227:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:228:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:228:3
    LoadVar(index 1);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:228:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:228:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:228:15
    Literal(lit 7);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:228:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:228:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:228:23
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:229:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:229:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:229:2
}

function LocalClass12() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:219:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:220:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:220:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:220:9
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:220:9
    Literal(lit &function anonymous2);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:221:9
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:221:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:221:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:221:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:221:9
}

function anonymous2() {
  entry:
    LoadScoped(index 1);                 // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:221:17
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:221:17
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:221:17
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:221:17
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:221:17
    LoadScoped(index 1);                 // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:221:17
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:221:17
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:221:17
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:221:17
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:221:17
}

function test_initializerClosingOverOuter() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:231:1
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:231:45
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:231:45
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:232:15
    StoreScoped(index 1);                // 2  count          ./test/end-to-end/tests/classes.test.mvm.js:232:15
    Literal(lit &function LocalClass13); // 3                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:233:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:233:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:233:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:233:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:237:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:237:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:237:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:237:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:238:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:238:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:238:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:238:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:238:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:238:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:238:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:238:15
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:238:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:238:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:238:25
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:239:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:239:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:239:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:239:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:239:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:239:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:239:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:239:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:239:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:239:25
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:239:25
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:239:25
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:240:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:240:3
    LoadScoped(index 1);                 // 5  count          ./test/end-to-end/tests/classes.test.mvm.js:240:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:240:22
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:240:22
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:240:22
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:241:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:241:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:241:2
}

function LocalClass13() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:233:3
    Literal(lit &function anonymous3);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:234:9
    ClosureNew();                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:234:9
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:234:9
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:234:9
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:234:9
}

function anonymous3() {
  entry:
    LoadScoped(index 1);                 // 1  count          ./test/end-to-end/tests/classes.test.mvm.js:234:15
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:234:15
    Literal(lit 1);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:234:15
    BinOp(op '+');                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:234:15
    LoadVar(index 1);                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:234:15
    StoreScoped(index 1);                // 2  count          ./test/end-to-end/tests/classes.test.mvm.js:234:15
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:234:15
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:234:15
}