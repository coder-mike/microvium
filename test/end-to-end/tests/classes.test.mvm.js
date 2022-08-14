/*---
description: >
  Testing support for classes
runExportedFunction: 0
assertionCount: 3
testOnly: true
---*/

vmExport(0, run);

// class GlobalClass {
//   constructor(y) { this.x = y + 5 }
//   myMethod() { return ++this.x }
// }
// const globalInst = new GlobalClass(10);

function run() {
  // test_globalInstance();
  // test_globalClass();
  test_localClass();
}

// function test_globalInstance() {
//   // Accessing instance constructed at compile time at the global scope
//   assertEqual(globalInst.x, 15);
//   assertEqual(globalInst.myMethod(), 16);
//   assertEqual(globalInst.myMethod(), 17);
// }

// function test_globalClass() {
//   // Accessing instance created at runtime of a class created at compile time
//   const inst = new GlobalClass(20);
//   assertEqual(inst.x, 25);
//   assertEqual(inst.myMethod(), 26);
//   assertEqual(inst.myMethod(), 27);
// }

function test_localClass() {
  class LocalClass {
    constructor(y) { this.x = y + 7 }
    myMethod() { return ++this.x + 1 }
  }

  const inst = new LocalClass(30);
  assertEqual(inst.x, 37);
  assertEqual(inst.myMethod(), 39);
  assertEqual(inst.myMethod(), 40);
}

/*
# TODO

  - Class declaration at runtime
  - property access on classes
  - Class expressions
  - Extends/Super
  - property access inherited/member
  - Properties
  - __proto__
  - Methods
  - Static properties
  - Static methods
  - Constructor
  - Constructor parameters
  - Constructor `return`
  - Static props referencing the partially-created class
  - Typeof
  - typeCodeOf
  - Truthy
  - to number
  - Equality
  - Scope analysis, closures
  - Closure lifting of class declaration
  - Closure over constructor variable
  - Closure over `this` in constructor
  - Closure over `this` in property initializer
  - Exported class
  - Class in loop correctly popped during break
  - `new x.Y()`
  - `new x[y]()`
  - Check that `new X?.()` does not compile
  - non-static members "x = 5;"
  - computed-key methods
  - computed-key properties
  - check that getters and setters produce reasonable errors
  - check `this` in property keys
  - constructor as closure

  - Remember to test with extra memory checks enabled
*/