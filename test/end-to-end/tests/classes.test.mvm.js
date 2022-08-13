/*---
description: >
  Testing support for classes
runExportedFunction: 0
assertionCount: 0
testOnly: true
---*/

vmExport(0, run);

class MyClass {
  myMethod() { return 5 }
}
const inst = new MyClass;

function run() {
  let x = MyClass;
  let y = inst;
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
*/