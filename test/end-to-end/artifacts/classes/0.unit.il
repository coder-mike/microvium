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
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // assertionCount: 48
    // testOnly: true
    // ---
    LoadGlobal(name 'vmExport');         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:10:1
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:10:10
    LoadVar(index 0);                    // 5  run            ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:10:13
    Literal(lit 'my');                   // 2                 ./test/end-to-end/tests/classes.test.mvm.js:26:11
    StoreGlobal(name 'x');               // 1                 ./test/end-to-end/tests/classes.test.mvm.js:26:11
    Literal(lit &function GlobalClass);  // 2                 ./test/end-to-end/tests/classes.test.mvm.js:28:1
    ObjectNew();                         // 3  static props   ./test/end-to-end/tests/classes.test.mvm.js:28:1
    ClassCreate();                       // 2  GlobalClass    ./test/end-to-end/tests/classes.test.mvm.js:28:1
    StoreGlobal(name 'GlobalClass');     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:28:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:28:1
    Literal(lit 'prototype');            // 3                 ./test/end-to-end/tests/classes.test.mvm.js:28:1
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:28:1
    LoadVar(index 3);                    // 5  GlobalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:28:1
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:28:1
    Literal(lit &function GlobalClass_myMethod); // 7         ./test/end-to-end/tests/classes.test.mvm.js:28:1
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    Literal(lit 'myStaticMethod');       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:30:3
    Literal(lit &function GlobalClass_myStaticMethod); // 4   ./test/end-to-end/tests/classes.test.mvm.js:30:3
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:3
    Literal(lit 42);                     // 2                 ./test/end-to-end/tests/classes.test.mvm.js:33:22
    LoadGlobal(name 'GlobalClass');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:33:1
    Literal(lit 'myProp');               // 4                 ./test/end-to-end/tests/classes.test.mvm.js:33:1
    LoadVar(index 1);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:33:1
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:33:1
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:33:1
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:35:24
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:35:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:35:36
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:35:36
    StoreGlobal(name 'globalInst');      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:35:36
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/classes.test.mvm.js:172:1
    Return();                            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:172:1
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
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:24:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:24:2
}

function GlobalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:29:29
    Literal(lit 5);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:29:33
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:29:33
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:29:20
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:29:20
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:29:20
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:29:20
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:29:20
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:29:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:29:36
}

function GlobalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:30:25
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:25
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:25
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:30:25
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:25
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:30:25
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:30:25
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:30:25
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:30:25
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:30:25
}

function GlobalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:31:39
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:31:39
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:39
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:31:39
    Branch(@block2, @block1);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:39
  block1:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:31:39
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:49
    Jump(@block2);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:49
  block2:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:31:54
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:54
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:31:29
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:31:29
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:31:29
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:29
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:31:29
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:31:64
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:31:64
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:31:64
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:31:64
}

function test_globalClass() {
  entry:
    Literal(lit deleted);                // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:37:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:38:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:38:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:38:15
    Literal(lit 2);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:38:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:38:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:38:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:39:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    Literal(lit 'myStaticMethod');       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:39:15
    Literal(lit 3);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:39:45
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:39:45
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:39:45
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:40:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:40:3
    LoadGlobal(name 'GlobalClass');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:40:15
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:40:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:40:15
    Literal(lit 42);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:40:35
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:40:35
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:40:35
    // Accessing instance created at runtime of a class created at compile time
    LoadGlobal(name 'GlobalClass');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:43:20
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:43:20
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:43:32
    New(count 2);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:43:32
    StoreVar(index 0);                   // 1  inst           ./test/end-to-end/tests/classes.test.mvm.js:43:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:44:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:44:15
    Literal(lit 25);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:44:23
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:44:23
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:44:23
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:45:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:45:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:45:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:45:15
    Literal(lit 26);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:45:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:45:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:45:32
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:46:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:46:3
    LoadVar(index 0);                    // 4  inst           ./test/end-to-end/tests/classes.test.mvm.js:46:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:46:15
    Literal(lit 27);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:46:32
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:46:32
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:46:32
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:47:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:47:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:47:2
}

function test_globalInstance() {
  entry:
    Literal(lit deleted);                // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:49:32
    Literal(lit 'ethod');                // 2                 ./test/end-to-end/tests/classes.test.mvm.js:50:13
    StoreVar(index 0);                   // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:50:13
    // Accessing instance constructed at compile time at the global scope
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:52:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:52:15
    Literal(lit 15);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:52:29
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:52:29
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:52:29
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:53:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:53:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:53:15
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:53:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:53:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:53:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:54:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Literal(lit 'myMethod');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:54:15
    Literal(lit 17);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:54:38
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:54:38
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:54:38
    LoadGlobal(name 'assertEqual');      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:55:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:55:3
    LoadGlobal(name 'globalInst');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:55:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:55:15
    LoadGlobal(name 'x');                // 6                 ./test/end-to-end/tests/classes.test.mvm.js:55:26
    Literal(lit 'M');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:55:30
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:55:30
    LoadVar(index 0);                    // 7  y              ./test/end-to-end/tests/classes.test.mvm.js:55:36
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:55:36
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:55:36
    LoadVar(index 3);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:55:36
    Call(count 1);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:55:36
    StoreVar(index 3);                   // 4                 ./test/end-to-end/tests/classes.test.mvm.js:55:36
    Literal(lit 18);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:55:42
    Call(count 3);                       // 2                 ./test/end-to-end/tests/classes.test.mvm.js:55:42
    Pop(count 1);                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:55:42
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:56:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:56:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:56:2
}

function test_localClass() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:58:28
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:58:28
    Literal(lit &function LocalClass);   // 3                 ./test/end-to-end/tests/classes.test.mvm.js:59:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:59:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:59:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:59:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:59:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:59:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:59:3
    LoadVar(index 4);                    // 6  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:59:3
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:59:3
    Literal(lit &function LocalClass_myMethod); // 8          ./test/end-to-end/tests/classes.test.mvm.js:59:3
    ObjectSet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:61:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:5
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:61:5
    Literal(lit 'myStaticMethod');       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:5
    Literal(lit &function LocalClass_myStaticMethod); // 5    ./test/end-to-end/tests/classes.test.mvm.js:61:5
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:5
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/classes.test.mvm.js:64:23
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:64:3
    Literal(lit 'myProp');               // 5                 ./test/end-to-end/tests/classes.test.mvm.js:64:3
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:64:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:64:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:64:3
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:66:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:66:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:66:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:66:15
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:66:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:66:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:66:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:67:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:67:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:67:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:67:15
    Literal(lit 'myStaticMethod');       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:67:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:67:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:67:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:67:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:67:15
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:67:44
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:67:44
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:67:44
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:68:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:68:15
    Literal(lit 'myProp');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:68:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:68:15
    Literal(lit 42);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:68:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:68:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:68:34
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:70:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:70:20
    Literal(lit 30);                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:70:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:70:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:70:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:71:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:71:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:71:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:71:15
    Literal(lit 37);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:71:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:71:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:71:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:72:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:72:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:72:15
    Literal(lit 39);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:72:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:72:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:72:32
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:73:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:73:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:73:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    Literal(lit 'myMethod');             // 7                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:73:15
    Literal(lit 40);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:73:32
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:73:32
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:73:32
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:74:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:74:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:74:2
}

function LocalClass() {
  entry:
    LoadArg(index 1);                    // 1  y              ./test/end-to-end/tests/classes.test.mvm.js:60:31
    Literal(lit 7);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:60:35
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:35
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:60:22
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:60:22
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:60:22
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:22
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:60:22
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:60:38
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:60:38
}

function LocalClass_myMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:61:27
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:27
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:27
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:27
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:61:27
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:61:27
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:61:27
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:27
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:61:36
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:61:36
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:61:36
}

function LocalClass_myStaticMethod() {
  entry:
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:62:41
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:41
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:41
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:41
    Branch(@block4, @block3);            // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:41
  block3:
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:62:41
    Literal(lit 1);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:51
    Jump(@block4);                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:51
  block4:
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:56
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:56
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:62:31
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:62:31
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:62:31
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:31
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:62:31
    LoadArg(index 0);                    // 1  this           ./test/end-to-end/tests/classes.test.mvm.js:62:66
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:62:66
    ObjectGet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:62:66
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:62:66
}

function test_inheritedProperties() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:76:37
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:76:37
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:76:37
    Literal(lit &function LocalClass1);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:82:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:82:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:82:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:82:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    Literal(lit 5);                      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:83:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:83:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:83:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:83:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:83:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:83:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:83:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:83:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:85:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:85:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:85:21
    StoreVar(index 1);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:85:21
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:86:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:86:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:86:21
    StoreVar(index 2);                   // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:86:21
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:88:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:88:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:88:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:88:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:88:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:88:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:88:24
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:89:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:89:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:89:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:89:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:89:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:89:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:89:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:89:24
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:91:13
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:91:3
    Literal(lit 20);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:92:28
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:92:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    LoadVar(index 3);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:92:3
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:94:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:94:3
    LoadVar(index 1);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:94:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:94:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:94:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:94:24
    // instance property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:95:3
    LoadVar(index 2);                    // 6  inst2          ./test/end-to-end/tests/classes.test.mvm.js:95:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:95:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:95:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:95:24
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:95:24
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:95:24
    // prototype property
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:96:3
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:96:19
    Literal(lit undefined);              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:96:19
    New(count 1);                        // 6                 ./test/end-to-end/tests/classes.test.mvm.js:96:19
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:96:19
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:96:19
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:96:35
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:96:35
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:96:35
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:97:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:97:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:97:2
}

// * The objective of this test is to confirm that properties on the prototype
   * can be overridden in instances without affecting the prototype.
function LocalClass1() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:82:3
}

function test_proto() {
  entry:
    Literal(lit deleted);                // 1  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:99:23
    Literal(lit deleted);                // 2  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:99:23
    Literal(lit deleted);                // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:99:23
    Literal(lit &function LocalClass2);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ClassCreate();                       // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:100:3
    StoreVar(index 0);                   // 3  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:100:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Literal(lit &function LocalClass3);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:101:3
    ClassCreate();                       // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:101:3
    StoreVar(index 1);                   // 3  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:101:3
    LoadVar(index 1);                    // 4  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:101:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    LoadVar(index 0);                    // 4  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:102:21
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:102:21
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:102:21
    StoreVar(index 2);                   // 3  inst1          ./test/end-to-end/tests/classes.test.mvm.js:102:21
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:103:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:103:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:103:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:103:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:103:10
    LoadVar(index 0);                    // 7  LocalClass1    ./test/end-to-end/tests/classes.test.mvm.js:103:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    BinOp(op '===');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:103:30
    LoadGlobal(name 'assert');           // 4                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:104:3
    LoadVar(index 2);                    // 6  inst1          ./test/end-to-end/tests/classes.test.mvm.js:104:10
    Literal(lit '__proto__');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:104:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:104:10
    LoadVar(index 1);                    // 7  LocalClass2    ./test/end-to-end/tests/classes.test.mvm.js:104:30
    Literal(lit 'prototype');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:104:30
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:104:30
    BinOp(op '!==');                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:104:30
    Call(count 2);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:104:30
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:104:30
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:105:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:105:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:105:2
}

function LocalClass2() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:100:3
}

function LocalClass3() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:101:3
}

function test_returnFromConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:107:39
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:107:39
    Literal(lit &function LocalClass4);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:112:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:112:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:112:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:112:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:112:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:112:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:112:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:112:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:115:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:115:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:115:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:115:20
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:116:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:116:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:116:10
    Literal(lit '__proto__');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:116:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:116:10
    LoadVar(index 0);                    // 6  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:116:29
    Literal(lit 'prototype');            // 7                 ./test/end-to-end/tests/classes.test.mvm.js:116:29
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:116:29
    BinOp(op '!==');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:116:29
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:116:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:116:29
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:117:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:117:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:117:10
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:117:10
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:117:10
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/classes.test.mvm.js:117:21
    BinOp(op '===');                     // 5                 ./test/end-to-end/tests/classes.test.mvm.js:117:21
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:117:21
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:117:21
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:118:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:118:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:118:2
}

// I don't expect anyone to use this edge case, but Microvium happens to
// support it because a return statement in a constructor is just handled as a
// normal return.
function LocalClass4() {
  entry:
    ObjectNew();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:113:28
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:113:28
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:113:28
    Literal(lit 10);                     // 4                 ./test/end-to-end/tests/classes.test.mvm.js:113:33
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:113:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:113:33
}

function test_operators() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:120:27
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:120:27
    Literal(lit &function LocalClass5);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:121:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:121:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:121:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:121:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:122:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:122:20
    New(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:122:20
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:122:20
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:123:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:123:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:123:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:123:22
    Literal(lit 'function');             // 6                 ./test/end-to-end/tests/classes.test.mvm.js:123:34
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:123:34
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:123:34
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:124:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:124:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:124:22
    UnOp(op 'typeof');                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:124:22
    Literal(lit 'object');               // 6                 ./test/end-to-end/tests/classes.test.mvm.js:124:28
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:124:28
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:124:28
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:125:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:125:15
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:125:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:125:36
    Literal(lit 9);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:125:49
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:125:49
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:125:49
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:126:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:126:3
    LoadGlobal(name 'Microvium');        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:126:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:126:15
    Literal(lit 'typeCodeOf');           // 7                 ./test/end-to-end/tests/classes.test.mvm.js:126:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:126:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:126:15
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:126:36
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:126:36
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:126:36
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:126:43
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:126:43
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:126:43
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:127:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:127:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:127:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:127:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:127:29
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:127:29
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:127:29
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:128:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:128:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:128:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:128:17
    UnOp(op '!');                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:128:17
    Literal(lit true);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:128:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:128:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:128:23
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:129:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:129:10
    LoadVar(index 0);                    // 8  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:129:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:129:24
    LoadGlobal(name 'assert');           // 3                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:130:3
    LoadGlobal(name 'Number');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:130:10
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:130:10
    Literal(lit 'isNaN');                // 7                 ./test/end-to-end/tests/classes.test.mvm.js:130:10
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:130:10
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:130:10
    LoadVar(index 1);                    // 8  inst           ./test/end-to-end/tests/classes.test.mvm.js:130:24
    UnOp(op '+');                        // 8                 ./test/end-to-end/tests/classes.test.mvm.js:130:24
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:130:24
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:130:24
    Call(count 2);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:130:24
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:130:24
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:131:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:131:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:131:2
}

function LocalClass5() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:121:3
}

function test_classAsMember() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:133:31
    Literal(lit deleted);                // 2  obj            ./test/end-to-end/tests/classes.test.mvm.js:133:31
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:133:31
    Literal(lit &function LocalClass6);  // 4                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    ObjectNew();                         // 5  static props   ./test/end-to-end/tests/classes.test.mvm.js:134:3
    ClassCreate();                       // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:134:3
    StoreVar(index 0);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:134:3
    LoadVar(index 0);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:134:3
    Literal(lit 'prototype');            // 5                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    ObjectNew();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    LoadVar(index 5);                    // 7  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:134:3
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:134:3
    Literal(lit &function LocalClass_foo); // 9               ./test/end-to-end/tests/classes.test.mvm.js:134:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:136:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:136:5
    ObjectNew();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:139:15
    LoadVar(index 3);                    // 5                 ./test/end-to-end/tests/classes.test.mvm.js:139:15
    Literal(lit 'LocalClass');           // 6                 ./test/end-to-end/tests/classes.test.mvm.js:139:15
    LoadVar(index 0);                    // 7  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:139:17
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:139:17
    StoreVar(index 1);                   // 3  obj            ./test/end-to-end/tests/classes.test.mvm.js:139:17
    LoadVar(index 1);                    // 4  obj            ./test/end-to-end/tests/classes.test.mvm.js:140:20
    Literal(lit 'LocalClass');           // 5                 ./test/end-to-end/tests/classes.test.mvm.js:140:20
    ObjectGet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:140:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:140:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:140:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:140:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:141:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:141:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:141:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:141:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:141:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:141:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:141:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:141:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:142:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:142:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:142:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:142:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:142:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:142:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:142:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:142:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:142:15
    Literal(lit 10);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:142:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:142:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:142:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:143:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:143:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:143:2
}

function LocalClass6() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:135:30
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:135:21
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:135:21
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:135:21
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:135:21
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:135:21
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:135:33
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:135:33
}

function LocalClass_foo() {
  entry:
    Literal(lit 10);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:136:20
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:136:20
}

function test_closingOverClass() {
  entry:
    Literal(lit &function inner);        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:145:34
    Literal(lit deleted);                // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:145:34
    Literal(lit deleted);                // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:145:34
    LoadVar(index 0);                    // 4  inner          ./test/end-to-end/tests/classes.test.mvm.js:154:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:154:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:154:22
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:154:22
    Call(count 1);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:154:22
    StoreVar(index 1);                   // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:154:22
    LoadVar(index 1);                    // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:155:20
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:155:20
    New(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:155:20
    StoreVar(index 2);                   // 3  inst           ./test/end-to-end/tests/classes.test.mvm.js:155:20
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:156:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:156:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:156:15
    Literal(lit 'x');                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:156:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:156:15
    Literal(lit 5);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:156:23
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:156:23
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:156:23
    LoadGlobal(name 'assertEqual');      // 4                 ./test/end-to-end/tests/classes.test.mvm.js:157:3
    Literal(lit undefined);              // 5                 ./test/end-to-end/tests/classes.test.mvm.js:157:3
    LoadVar(index 2);                    // 6  inst           ./test/end-to-end/tests/classes.test.mvm.js:157:15
    LoadVar(index 5);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:157:15
    Literal(lit 'foo');                  // 8                 ./test/end-to-end/tests/classes.test.mvm.js:157:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:157:15
    LoadVar(index 5);                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:157:15
    Call(count 1);                       // 7                 ./test/end-to-end/tests/classes.test.mvm.js:157:15
    StoreVar(index 5);                   // 6                 ./test/end-to-end/tests/classes.test.mvm.js:157:15
    Literal(lit 20);                     // 7                 ./test/end-to-end/tests/classes.test.mvm.js:157:27
    Call(count 3);                       // 4                 ./test/end-to-end/tests/classes.test.mvm.js:157:27
    Pop(count 1);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:157:27
    Pop(count 3);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:158:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:158:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:158:2
}

function inner() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:146:3
    Literal(lit &function LocalClass7);  // 1                 ./test/end-to-end/tests/classes.test.mvm.js:147:5
    ObjectNew();                         // 2  static props   ./test/end-to-end/tests/classes.test.mvm.js:147:5
    ClassCreate();                       // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:147:5
    StoreScoped(index 1);                // 0  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:147:5
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:147:5
    Literal(lit 'prototype');            // 2                 ./test/end-to-end/tests/classes.test.mvm.js:147:5
    ObjectNew();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:147:5
    LoadVar(index 2);                    // 4  LocalClass.prototype ./test/end-to-end/tests/classes.test.mvm.js:147:5
    Literal(lit 'foo');                  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:147:5
    Literal(lit &function LocalClass_foo1); // 6              ./test/end-to-end/tests/classes.test.mvm.js:147:5
    ObjectSet();                         // 3                 ./test/end-to-end/tests/classes.test.mvm.js:149:7
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:149:7
    Literal(lit &function anonymous);    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:151:12
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:151:12
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:151:12
}

function LocalClass7() {
  entry:
    Literal(lit 5);                      // 1                 ./test/end-to-end/tests/classes.test.mvm.js:148:32
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:148:23
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/classes.test.mvm.js:148:23
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:148:23
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:148:23
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:148:23
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:148:35
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:148:35
}

function LocalClass_foo1() {
  entry:
    Literal(lit 20);                     // 1                 ./test/end-to-end/tests/classes.test.mvm.js:149:22
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:149:22
}

function anonymous() {
  entry:
    LoadScoped(index 1);                 // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:151:18
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:151:18
}

function test_closureInConstructor() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:160:38
    Literal(lit deleted);                // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:160:38
    Literal(lit &function LocalClass8);  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:161:3
    ObjectNew();                         // 4  static props   ./test/end-to-end/tests/classes.test.mvm.js:161:3
    ClassCreate();                       // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:161:3
    StoreVar(index 0);                   // 2  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:161:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:161:3
    Literal(lit 'prototype');            // 4                 ./test/end-to-end/tests/classes.test.mvm.js:161:3
    ObjectNew();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:161:3
    ObjectSet();                         // 2                 ./test/end-to-end/tests/classes.test.mvm.js:161:3
    LoadVar(index 0);                    // 3  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:166:20
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:166:20
    Literal(lit 5);                      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:166:31
    New(count 2);                        // 3                 ./test/end-to-end/tests/classes.test.mvm.js:166:31
    StoreVar(index 1);                   // 2  inst           ./test/end-to-end/tests/classes.test.mvm.js:166:31
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:167:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:167:15
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:167:15
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:167:15
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:167:23
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:167:23
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:167:23
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:168:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:168:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:168:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:168:15
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:168:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:168:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:168:27
    LoadGlobal(name 'assertEqual');      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:169:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/classes.test.mvm.js:169:3
    LoadVar(index 1);                    // 5  inst           ./test/end-to-end/tests/classes.test.mvm.js:169:15
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:169:15
    Literal(lit 'foo');                  // 7                 ./test/end-to-end/tests/classes.test.mvm.js:169:15
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:169:15
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:169:15
    Call(count 1);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:169:15
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:169:15
    Literal(lit 7);                      // 6                 ./test/end-to-end/tests/classes.test.mvm.js:169:27
    Call(count 3);                       // 3                 ./test/end-to-end/tests/classes.test.mvm.js:169:27
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/classes.test.mvm.js:169:27
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:170:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:170:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:170:2
}

function LocalClass8() {
  entry:
    ScopePush(count 1);                  // 0                 ./test/end-to-end/tests/classes.test.mvm.js:161:3
    LoadArg(index 1);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:162:5
    StoreScoped(index 1);                // 0                 ./test/end-to-end/tests/classes.test.mvm.js:162:5
    Literal(lit &function anonymous1);   // 1                 ./test/end-to-end/tests/classes.test.mvm.js:163:18
    ClosureNew();                        // 1                 ./test/end-to-end/tests/classes.test.mvm.js:163:18
    LoadArg(index 0);                    // 2  this           ./test/end-to-end/tests/classes.test.mvm.js:163:7
    Literal(lit 'foo');                  // 3                 ./test/end-to-end/tests/classes.test.mvm.js:163:7
    LoadVar(index 0);                    // 4                 ./test/end-to-end/tests/classes.test.mvm.js:163:7
    ObjectSet();                         // 1                 ./test/end-to-end/tests/classes.test.mvm.js:163:7
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:163:7
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:164:6
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:164:6
}

function anonymous1() {
  entry:
    LoadScoped(index 1);                 // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:163:24
    Literal(lit 1);                      // 2                 ./test/end-to-end/tests/classes.test.mvm.js:163:24
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/classes.test.mvm.js:163:24
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:163:24
    StoreScoped(index 1);                // 1  x              ./test/end-to-end/tests/classes.test.mvm.js:163:24
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:163:24
}

function test_classProperty() {
  entry:
    Literal(lit deleted);                // 1  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:172:31
    Literal(lit deleted);                // 2  inst1          ./test/end-to-end/tests/classes.test.mvm.js:172:31
    Literal(lit deleted);                // 3  inst2          ./test/end-to-end/tests/classes.test.mvm.js:172:31
    Literal(lit deleted);                // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:172:31
    Literal(lit &function LocalClass9);  // 5                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    ObjectNew();                         // 6  static props   ./test/end-to-end/tests/classes.test.mvm.js:173:3
    ClassCreate();                       // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:173:3
    StoreVar(index 0);                   // 4  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:173:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:173:3
    Literal(lit 'prototype');            // 6                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    ObjectNew();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    ObjectSet();                         // 4                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:174:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:174:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:174:21
    StoreVar(index 1);                   // 4  inst1          ./test/end-to-end/tests/classes.test.mvm.js:174:21
    LoadVar(index 0);                    // 5  LocalClass     ./test/end-to-end/tests/classes.test.mvm.js:175:21
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:175:21
    New(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:175:21
    StoreVar(index 2);                   // 4  inst2          ./test/end-to-end/tests/classes.test.mvm.js:175:21
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:176:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:176:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:176:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:176:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:176:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:176:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:176:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:176:24
    LoadVar(index 1);                    // 5  inst1          ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Literal(lit 'x');                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    ObjectGet();                         // 5                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Literal(lit 1);                      // 7                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    BinOp(op '+');                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    LoadVar(index 5);                    // 9                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    ObjectSet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Pop(count 1);                        // 5                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:177:3
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:178:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:178:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:178:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:178:15
    Literal(lit 6);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:178:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:178:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:178:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:179:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:179:15
    Literal(lit '__proto__');            // 8                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:179:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:179:34
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:179:34
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:179:34
    // The property is not on the prototype
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:180:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:180:3
    LoadVar(index 2);                    // 7  inst2          ./test/end-to-end/tests/classes.test.mvm.js:180:15
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:180:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:180:15
    Literal(lit 5);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:180:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:180:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:180:24
    // Test that properties are independent
    LoadGlobal(name 'Reflect');          // 5                 ./test/end-to-end/tests/classes.test.mvm.js:182:16
    LoadVar(index 4);                    // 6                 ./test/end-to-end/tests/classes.test.mvm.js:182:16
    Literal(lit 'ownKeys');              // 7                 ./test/end-to-end/tests/classes.test.mvm.js:182:16
    ObjectGet();                         // 6                 ./test/end-to-end/tests/classes.test.mvm.js:182:16
    LoadVar(index 4);                    // 7                 ./test/end-to-end/tests/classes.test.mvm.js:182:16
    LoadVar(index 1);                    // 8  inst1          ./test/end-to-end/tests/classes.test.mvm.js:182:32
    Call(count 2);                       // 6                 ./test/end-to-end/tests/classes.test.mvm.js:182:32
    StoreVar(index 4);                   // 5                 ./test/end-to-end/tests/classes.test.mvm.js:182:32
    StoreVar(index 3);                   // 4  keys           ./test/end-to-end/tests/classes.test.mvm.js:182:32
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:183:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:183:15
    Literal(lit 'length');               // 8                 ./test/end-to-end/tests/classes.test.mvm.js:183:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:183:15
    Literal(lit 2);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:183:28
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:183:28
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:183:28
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:184:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:184:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:184:15
    Literal(lit 0);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:184:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:184:20
    Literal(lit 'x');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:184:24
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:185:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:185:3
    LoadVar(index 3);                    // 7  keys           ./test/end-to-end/tests/classes.test.mvm.js:185:15
    Literal(lit 1);                      // 8                 ./test/end-to-end/tests/classes.test.mvm.js:185:20
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:185:20
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:185:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:185:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:185:24
    // y is a key
    LoadGlobal(name 'assertEqual');      // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    Literal(lit undefined);              // 6                 ./test/end-to-end/tests/classes.test.mvm.js:186:3
    LoadVar(index 1);                    // 7  inst1          ./test/end-to-end/tests/classes.test.mvm.js:186:15
    Literal(lit 'y');                    // 8                 ./test/end-to-end/tests/classes.test.mvm.js:186:15
    ObjectGet();                         // 7                 ./test/end-to-end/tests/classes.test.mvm.js:186:15
    Literal(lit undefined);              // 8                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    Call(count 3);                       // 5                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    Pop(count 1);                        // 4                 ./test/end-to-end/tests/classes.test.mvm.js:186:24
    Pop(count 4);                        // 0                 ./test/end-to-end/tests/classes.test.mvm.js:187:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/classes.test.mvm.js:187:2
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:187:2
}

function LocalClass9() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    Literal(lit 'x');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:173:3
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/classes.test.mvm.js:173:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:173:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:26
    Literal(lit 'y');                    // 2                 ./test/end-to-end/tests/classes.test.mvm.js:173:26
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/classes.test.mvm.js:173:26
    ObjectSet();                         // 0                 ./test/end-to-end/tests/classes.test.mvm.js:173:26
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/classes.test.mvm.js:173:26
    Return();                            // 0                 ./test/end-to-end/tests/classes.test.mvm.js:173:26
}