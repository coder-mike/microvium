/*---
runExportedFunction: 0
nativeOnly: false
testOnly: false
description: Testing use of globalThis to interact with globals at compile time.
assertionCount: 2
---*/

vmExport(0, run);

// Creating a global using globalThis
globalThis.foo = 42;
assertEqual(globalThis.foo, 42);
assertEqual(foo, 42);

// Compile-time mutation through global variable
foo = 43;
assertEqual(foo, 43);
assertEqual(globalThis.foo, 43);

// Compile-time mutation through variable name
foo = 44;
assertEqual(globalThis.foo, 44);
assertEqual(foo, 44);


function run() {
  // Runtime should restore last compile-time value
  assertEqual(foo, 44);
  // Runtime mutation (only works through variable name)
  foo = 45;
  assertEqual(foo, 45);
}
