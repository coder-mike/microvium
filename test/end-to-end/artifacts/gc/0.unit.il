unit ['./test/end-to-end/tests/gc.test.mvm.js'];

entry ['#entry'];

external getHeapUsed from free-variable 'getHeapUsed';
external undefined from free-variable 'undefined';
external assertEqual from free-variable 'assertEqual';
external runGC from free-variable 'runGC';
external vmExport from free-variable 'vmExport';

global thisModule;
global garbage;
global globalVariable;
global heap;
global function1;
global nestedFunction;
global checkAllocated;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/gc.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/gc.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/gc.test.mvm.js:1:1
    Literal(lit &function function1);    // 2                 ./test/end-to-end/tests/gc.test.mvm.js:1:1
    StoreGlobal(name 'function1');       // 1                 ./test/end-to-end/tests/gc.test.mvm.js:1:1
    Literal(lit &function nestedFunction); // 2               ./test/end-to-end/tests/gc.test.mvm.js:1:1
    StoreGlobal(name 'nestedFunction');  // 1                 ./test/end-to-end/tests/gc.test.mvm.js:1:1
    Literal(lit &function checkAllocated); // 2               ./test/end-to-end/tests/gc.test.mvm.js:1:1
    StoreGlobal(name 'checkAllocated');  // 1                 ./test/end-to-end/tests/gc.test.mvm.js:1:1
    Literal(lit &function checkGC);      // 2                 ./test/end-to-end/tests/gc.test.mvm.js:1:1
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/gc.test.mvm.js:18:5
    StoreGlobal(name 'garbage');         // 2                 ./test/end-to-end/tests/gc.test.mvm.js:18:5
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/gc.test.mvm.js:19:5
    StoreGlobal(name 'globalVariable');  // 2                 ./test/end-to-end/tests/gc.test.mvm.js:19:5
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/gc.test.mvm.js:20:5
    StoreGlobal(name 'heap');            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:20:5
    LoadGlobal(name 'vmExport');         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:86:1
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:86:1
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/gc.test.mvm.js:86:10
    LoadVar(index 0);                    // 6  run            ./test/end-to-end/tests/gc.test.mvm.js:86:13
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:86:13
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/gc.test.mvm.js:86:13
    Return();                            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:86:13
}

// ---
runExportedFunction: 0
nativeOnly: true
testOnly: false
description: Some garbage collection tests
---
// WARNING: these tests don't work if MVM_VERY_EXPENSIVE_MEMORY_CHECKS is
// enabled because it triggers garbage collections at unexpected times.
function run() {
  entry:
    Literal(lit 0);                      // 1                 ./test/end-to-end/tests/gc.test.mvm.js:12:13
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/gc.test.mvm.js:12:13
    StoreGlobal(name 'garbage');         // 1                 ./test/end-to-end/tests/gc.test.mvm.js:12:13
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/gc.test.mvm.js:12:13
    LoadGlobal(name 'getHeapUsed');      // 1                 ./test/end-to-end/tests/gc.test.mvm.js:13:10
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/gc.test.mvm.js:13:10
    Call(count 1, flag false);           // 1                 ./test/end-to-end/tests/gc.test.mvm.js:13:10
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/gc.test.mvm.js:13:10
    StoreGlobal(name 'heap');            // 1                 ./test/end-to-end/tests/gc.test.mvm.js:13:10
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/gc.test.mvm.js:13:10
    LoadGlobal(name 'function1');        // 1                 ./test/end-to-end/tests/gc.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/gc.test.mvm.js:14:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:14:3
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/gc.test.mvm.js:15:2
    Return();                            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:15:2
}

function function1() {
  entry:
    Literal(lit deleted);                // 1  localVariable1A ./test/end-to-end/tests/gc.test.mvm.js:22:22
    Literal(lit deleted);                // 2  localVariable1B ./test/end-to-end/tests/gc.test.mvm.js:22:22
    // New array with global reference
    ArrayNew();                          // 3                 ./test/end-to-end/tests/gc.test.mvm.js:24:20
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/gc.test.mvm.js:24:20
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/gc.test.mvm.js:24:20
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:24:21
    ObjectSet();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:24:20
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/gc.test.mvm.js:24:20
    StoreGlobal(name 'globalVariable');  // 3                 ./test/end-to-end/tests/gc.test.mvm.js:24:20
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/gc.test.mvm.js:24:20
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:25:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:25:3
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/gc.test.mvm.js:25:18
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:25:22
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:25:22
    // New array with local reference
    ArrayNew();                          // 3                 ./test/end-to-end/tests/gc.test.mvm.js:28:25
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/gc.test.mvm.js:28:25
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/gc.test.mvm.js:28:25
    Literal(lit 1);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:28:26
    ObjectSet();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:28:25
    StoreVar(index 0);                   // 2  localVariable1A ./test/end-to-end/tests/gc.test.mvm.js:28:25
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:29:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:29:3
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/gc.test.mvm.js:29:18
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:29:22
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:29:22
    // Resize array
    Literal(lit 42);                     // 3                 ./test/end-to-end/tests/gc.test.mvm.js:32:24
    LoadVar(index 0);                    // 4  localVariable1A ./test/end-to-end/tests/gc.test.mvm.js:32:3
    Literal(lit 1);                      // 5                 ./test/end-to-end/tests/gc.test.mvm.js:32:19
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/gc.test.mvm.js:32:19
    ObjectSet();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:32:19
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/gc.test.mvm.js:32:19
    // See setProperty and growArray
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:33:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:33:3
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/gc.test.mvm.js:33:18
    Literal(lit 4);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:33:22
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:33:22
    // New array
    ArrayNew();                          // 3                 ./test/end-to-end/tests/gc.test.mvm.js:36:25
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/gc.test.mvm.js:36:25
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/gc.test.mvm.js:36:25
    Literal(lit 2);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:36:26
    ObjectSet();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:36:25
    StoreVar(index 1);                   // 2  localVariable1B ./test/end-to-end/tests/gc.test.mvm.js:36:25
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:37:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:37:3
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/gc.test.mvm.js:37:18
    Literal(lit 0);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:37:22
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:37:22
    // Make eligible for GC
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/gc.test.mvm.js:40:21
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/gc.test.mvm.js:40:21
    StoreVar(index 1);                   // 3  localVariable1B ./test/end-to-end/tests/gc.test.mvm.js:40:21
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/gc.test.mvm.js:40:21
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:41:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:41:3
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/gc.test.mvm.js:41:18
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/gc.test.mvm.js:41:21
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:41:21
    LoadGlobal(name 'nestedFunction');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:43:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:43:3
    Call(count 1, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:43:3
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/gc.test.mvm.js:44:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/gc.test.mvm.js:44:2
    Return();                            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:44:2
}

function nestedFunction() {
  entry:
    Literal(lit deleted);                // 1  localVariable2A ./test/end-to-end/tests/gc.test.mvm.js:46:27
    Literal(lit deleted);                // 2  localVariable2B ./test/end-to-end/tests/gc.test.mvm.js:46:27
    // New object. Note that new objects are manufactured empty to start with and
    // then properties are added.
    ObjectNew();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:49:25
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/gc.test.mvm.js:49:25
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/gc.test.mvm.js:49:25
    Literal(lit 3);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:49:30
    ObjectSet();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:49:30
    StoreVar(index 0);                   // 2  localVariable2A ./test/end-to-end/tests/gc.test.mvm.js:49:30
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:50:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:50:3
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/gc.test.mvm.js:50:18
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:50:22
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:50:22
    // Extend object
    Literal(lit 4);                      // 3                 ./test/end-to-end/tests/gc.test.mvm.js:53:23
    LoadVar(index 0);                    // 4  localVariable2A ./test/end-to-end/tests/gc.test.mvm.js:53:3
    Literal(lit 'y');                    // 5                 ./test/end-to-end/tests/gc.test.mvm.js:53:3
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/gc.test.mvm.js:53:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:53:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/gc.test.mvm.js:53:3
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:54:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:54:3
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/gc.test.mvm.js:54:18
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:54:22
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:54:22
    // Extend object
    Literal(lit 5);                      // 3                 ./test/end-to-end/tests/gc.test.mvm.js:57:23
    LoadVar(index 0);                    // 4  localVariable2A ./test/end-to-end/tests/gc.test.mvm.js:57:3
    Literal(lit 'z');                    // 5                 ./test/end-to-end/tests/gc.test.mvm.js:57:3
    LoadVar(index 2);                    // 6                 ./test/end-to-end/tests/gc.test.mvm.js:57:3
    ObjectSet();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:57:3
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/gc.test.mvm.js:57:3
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:58:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:58:3
    Literal(lit 10);                     // 5                 ./test/end-to-end/tests/gc.test.mvm.js:58:18
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:58:22
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:58:22
    // New object
    ObjectNew();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:61:25
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/gc.test.mvm.js:61:25
    Literal(lit 'x');                    // 5                 ./test/end-to-end/tests/gc.test.mvm.js:61:25
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:61:30
    ObjectSet();                         // 3                 ./test/end-to-end/tests/gc.test.mvm.js:61:30
    StoreVar(index 1);                   // 2  localVariable2B ./test/end-to-end/tests/gc.test.mvm.js:61:30
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:62:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:62:3
    Literal(lit 16);                     // 5                 ./test/end-to-end/tests/gc.test.mvm.js:62:18
    Literal(lit 6);                      // 6                 ./test/end-to-end/tests/gc.test.mvm.js:62:22
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:62:22
    // Make eligible for GC
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/gc.test.mvm.js:65:21
    LoadVar(index 2);                    // 4                 ./test/end-to-end/tests/gc.test.mvm.js:65:21
    StoreVar(index 1);                   // 3  localVariable2B ./test/end-to-end/tests/gc.test.mvm.js:65:21
    Pop(count 1);                        // 2                 ./test/end-to-end/tests/gc.test.mvm.js:65:21
    LoadGlobal(name 'checkAllocated');   // 3                 ./test/end-to-end/tests/gc.test.mvm.js:66:3
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:66:3
    Literal(lit 0);                      // 5                 ./test/end-to-end/tests/gc.test.mvm.js:66:18
    Literal(lit 10);                     // 6                 ./test/end-to-end/tests/gc.test.mvm.js:66:21
    Call(count 3, flag true);            // 2                 ./test/end-to-end/tests/gc.test.mvm.js:66:21
    Pop(count 2);                        // 0                 ./test/end-to-end/tests/gc.test.mvm.js:72:2
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/gc.test.mvm.js:72:2
    Return();                            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:72:2
}

function checkAllocated() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/gc.test.mvm.js:75:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/gc.test.mvm.js:75:3
    LoadGlobal(name 'getHeapUsed');      // 3                 ./test/end-to-end/tests/gc.test.mvm.js:75:15
    Literal(lit undefined);              // 4                 ./test/end-to-end/tests/gc.test.mvm.js:75:15
    Call(count 1, flag false);           // 3                 ./test/end-to-end/tests/gc.test.mvm.js:75:15
    LoadGlobal(name 'heap');             // 4                 ./test/end-to-end/tests/gc.test.mvm.js:75:31
    BinOp(op '-');                       // 3                 ./test/end-to-end/tests/gc.test.mvm.js:75:31
    LoadArg(index 1);                    // 4  newAllocatedSize ./test/end-to-end/tests/gc.test.mvm.js:75:37
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:75:37
    LoadGlobal(name 'heap');             // 1                 ./test/end-to-end/tests/gc.test.mvm.js:76:3
    LoadArg(index 1);                    // 2  newAllocatedSize ./test/end-to-end/tests/gc.test.mvm.js:76:11
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/gc.test.mvm.js:76:11
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/gc.test.mvm.js:76:11
    StoreGlobal(name 'heap');            // 1                 ./test/end-to-end/tests/gc.test.mvm.js:76:11
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/gc.test.mvm.js:76:11
    LoadGlobal(name 'garbage');          // 1                 ./test/end-to-end/tests/gc.test.mvm.js:77:3
    LoadArg(index 2);                    // 2  newGarbageSize ./test/end-to-end/tests/gc.test.mvm.js:77:14
    BinOp(op '+');                       // 1                 ./test/end-to-end/tests/gc.test.mvm.js:77:14
    LoadVar(index 0);                    // 2                 ./test/end-to-end/tests/gc.test.mvm.js:77:14
    StoreGlobal(name 'garbage');         // 1                 ./test/end-to-end/tests/gc.test.mvm.js:77:14
    Pop(count 1);                        // 0                 ./test/end-to-end/tests/gc.test.mvm.js:77:14
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/gc.test.mvm.js:78:2
    Return();                            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:78:2
}

function checkGC() {
  entry:
    LoadGlobal(name 'checkAllocated');   // 1                 ./test/end-to-end/tests/gc.test.mvm.js:81:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/gc.test.mvm.js:81:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/gc.test.mvm.js:81:18
    Literal(lit 0);                      // 4                 ./test/end-to-end/tests/gc.test.mvm.js:81:21
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:81:21
    // Just check consistency between `heap` and `getHeapUsed`
    LoadGlobal(name 'runGC');            // 1                 ./test/end-to-end/tests/gc.test.mvm.js:82:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/gc.test.mvm.js:82:3
    Call(count 1, flag true);            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:82:3
    LoadGlobal(name 'checkAllocated');   // 1                 ./test/end-to-end/tests/gc.test.mvm.js:83:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/gc.test.mvm.js:83:3
    LoadGlobal(name 'garbage');          // 3                 ./test/end-to-end/tests/gc.test.mvm.js:83:19
    UnOp(op '-');                        // 3                 ./test/end-to-end/tests/gc.test.mvm.js:83:19
    LoadGlobal(name 'garbage');          // 4                 ./test/end-to-end/tests/gc.test.mvm.js:83:29
    UnOp(op '-');                        // 4                 ./test/end-to-end/tests/gc.test.mvm.js:83:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:83:29
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/gc.test.mvm.js:84:2
    Return();                            // 0                 ./test/end-to-end/tests/gc.test.mvm.js:84:2
}