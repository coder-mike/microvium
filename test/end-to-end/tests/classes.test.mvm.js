/*---
description: >
  Testing support for classes
runExportedFunction: 0
assertionCount: 0
testOnly: true
---*/

vmExport(0, run);

class MyClass {}

function run() {
}

/*
# TODO

  - Class expressions
  - Extends/Super
  - Properties
  - Methods
  - Static properties
  - Static methods
  - Constructor
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
*/