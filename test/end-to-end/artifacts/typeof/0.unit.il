unit ['./test/end-to-end/tests/typeof.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';

global thisModule;
global run;

function ['#entry']() {
  entry:
    LoadArg(index 0);                    // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:1:1
    StoreGlobal(name 'thisModule');      // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:1:1
    Literal(lit &function run);          // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:1:1
    StoreGlobal(name 'run');             // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:1:1
    // ---
    // description: Testing `typeof` operator
    // runExportedFunction: 0
    // assertionCount: 12
    // ---
    LoadGlobal(name 'vmExport');         // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:6:1
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:6:1
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:6:10
    LoadGlobal(name 'run');              // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:6:13
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:6:13
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:8:1
    Return();                            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:8:1
}

function run() {
  entry:
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:9:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:9:3
    Literal(lit undefined);              // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:9:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:9:22
    Literal(lit 'undefined');            // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:9:33
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:9:33
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:10:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:10:3
    Literal(lit 0);                      // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:10:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:10:22
    Literal(lit 'number');               // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:10:25
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:10:25
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:11:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:11:3
    Literal(lit false);                  // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:11:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:11:22
    Literal(lit 'boolean');              // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:11:29
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:11:29
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:12:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:12:3
    Literal(lit true);                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:12:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:12:22
    Literal(lit 'boolean');              // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:12:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:12:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:13:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:13:3
    Literal(lit 'hello');                // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:13:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:13:22
    Literal(lit 'string');               // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:13:31
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:13:31
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:14:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:14:3
    Literal(lit 'hello');                // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:14:23
    Literal(lit 'world');                // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:14:33
    BinOp(op '+');                       // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:14:33
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:14:33
    Literal(lit 'string');               // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:14:43
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:14:43
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:15:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:15:3
    Literal(lit 'x');                    // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:15:29
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:15:29
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:15:29
    Literal(lit 'string');               // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:15:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:15:34
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:16:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:16:3
    LoadGlobal(name 'run');              // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:16:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:16:22
    Literal(lit 'function');             // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:16:27
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:16:27
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:17:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:17:3
    Literal(lit null);                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:17:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:17:22
    Literal(lit 'object');               // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:17:28
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:17:28
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:18:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:18:3
    ObjectNew();                         // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:18:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:18:22
    Literal(lit 'object');               // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:18:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:18:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:19:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:19:3
    ArrayNew();                          // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:19:22
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:19:22
    Literal(lit 'object');               // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:19:26
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:19:26
    LoadGlobal(name 'assertEqual');      // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:20:3
    Literal(lit undefined);              // 2                 ./test/end-to-end/tests/typeof.test.mvm.js:20:3
    Literal(lit &function anonymous);    // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:20:23
    UnOp(op 'typeof');                   // 3                 ./test/end-to-end/tests/typeof.test.mvm.js:20:23
    Literal(lit 'function');             // 4                 ./test/end-to-end/tests/typeof.test.mvm.js:20:34
    Call(count 3, flag true);            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:20:34
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:21:2
    Return();                            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:21:2
}

function anonymous() {
  entry:
    Literal(lit undefined);              // 1                 ./test/end-to-end/tests/typeof.test.mvm.js:20:31
    Return();                            // 0                 ./test/end-to-end/tests/typeof.test.mvm.js:20:31
}