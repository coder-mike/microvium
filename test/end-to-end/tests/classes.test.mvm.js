/*---
description: >
  Testing support for classes
#runExportedFunction: 0 WIP
#assertionCount: 41 WIP
testOnly: true
---*/

class MyClass {
  x = 10;
}

// vmExport(0, run);

// function run() {
//   // test_globalClass();
//   // test_globalInstance();
//   // test_localClass();
//   // test_inheritedProperties();
//   // test_proto();
//   // test_returnFromConstructor();
//   // test_operators();
//   // test_classAsMember();
//   // test_closingOverClass();
//   // test_closureInConstructor();
// }

// const x = 'second';

// class GlobalClass {
//   constructor(y) { this.x = y + 5 }
//   myMethod() { return ++this.x }
//   [x + 'Method']() { return this.x + 5 }
//   static myStaticMethod() { this.x = (this.x || 1) + 1; return this.x }
// }
// GlobalClass.myProp = 42;

// const globalInst = new GlobalClass(10);

// function test_globalInstance() {
//   const y = 'ethod';
//   // Accessing instance constructed at compile time at the global scope
//   assertEqual(globalInst.x, 15);
//   assertEqual(globalInst.myMethod(), 16);
//   assertEqual(globalInst.myMethod(), 17);
//   assertEqual(globalInst[x + 'M' + y](), 22);
//   assertEqual(globalInst['secondMethod'](), 22);
// }

// function test_globalClass() {
//   assertEqual(GlobalClass.myStaticMethod(), 2);
//   assertEqual(GlobalClass.myStaticMethod(), 3);
//   assertEqual(GlobalClass.myProp, 42);

//   // Accessing instance created at runtime of a class created at compile time
//   const inst = new GlobalClass(20);
//   assertEqual(inst.x, 25);
//   assertEqual(inst.myMethod(), 26);
//   assertEqual(inst.myMethod(), 27);
// }

// function test_localClass() {
//   class LocalClass {
//     constructor(y) { this.x = y + 7 }
//     myMethod() { return ++this.x + 1 }
//     static myStaticMethod() { this.x = (this.x || 1) + 1; return this.x }
//   }
//   LocalClass.myProp = 42;

//   assertEqual(LocalClass.myStaticMethod(), 2);
//   assertEqual(LocalClass.myStaticMethod(), 3);
//   assertEqual(LocalClass.myProp, 42);

//   const inst = new LocalClass(30);
//   assertEqual(inst.x, 37);
//   assertEqual(inst.myMethod(), 39);
//   assertEqual(inst.myMethod(), 40);
// }

// function test_inheritedProperties() {
//   /*
//    * The objective of this test is to confirm that properties on the prototype
//    * can be overridden in instances without affecting the prototype.
//    */

//   class LocalClass {}
//   LocalClass.prototype.x = 5;

//   const inst1 = new LocalClass;
//   const inst2 = new LocalClass;

//   assertEqual(inst1.x, 5)
//   assertEqual(inst2.x, 5)

//   inst1.x = 10;
//   LocalClass.prototype.x = 20;

//   assertEqual(inst1.x, 10) // instance property
//   assertEqual(inst2.x, 20) // prototype property
//   assertEqual(new LocalClass().x, 20) // prototype property
// }

// function test_proto() {
//   class LocalClass1 {}
//   class LocalClass2 {}
//   const inst1 = new LocalClass1();
//   assert(inst1.__proto__ === LocalClass1.prototype);
//   assert(inst1.__proto__ !== LocalClass2.prototype);
// }

// function test_returnFromConstructor() {
//   // I don't expect anyone to use this edge case, but Microvium happens to
//   // support it because a return statement in a constructor is just handled as a
//   // normal return.

//   class LocalClass {
//     constructor() { return { x: 10 } }
//   }
//   const inst = new LocalClass();
//   assert(inst.__proto__ !== LocalClass.prototype);
//   assert(inst.x === 10);
// }

// function test_operators() {
//   class LocalClass {}
//   const inst = new LocalClass;
//   assertEqual(typeof LocalClass, 'function')
//   assertEqual(typeof inst, 'object')
//   assertEqual(Microvium.typeCodeOf(LocalClass), 9)
//   assertEqual(Microvium.typeCodeOf(inst), 6)
//   assertEqual(!!LocalClass, true)
//   assertEqual(!!inst, true)
//   assert(Number.isNaN(+LocalClass))
//   assert(Number.isNaN(+inst))
// }

// function test_classAsMember() {
//   class LocalClass {
//     constructor() { this.x = 5 }
//     foo() { return 10; }
//   }

//   const obj = { LocalClass }
//   const inst = new obj.LocalClass()
//   assertEqual(inst.x, 5);
//   assertEqual(inst.foo(), 10);
// }

// function test_closingOverClass() {
//   function inner() {
//     class LocalClass {
//       constructor() { this.x = 5 }
//       foo() { return 20; }
//     }
//     return () => LocalClass;
//   }

//   const LocalClass = inner()();
//   const inst = new LocalClass();
//   assertEqual(inst.x, 5);
//   assertEqual(inst.foo(), 20);
// }

// function test_closureInConstructor() {
//   class LocalClass {
//     constructor(x) {
//       this.foo = () => ++x;
//     }
//   }
//   const inst = new LocalClass(5);
//   assertEqual(inst.x, undefined);
//   assertEqual(inst.foo(), 6);
//   assertEqual(inst.foo(), 7);
// }

/*
# TODO

  - Closure in method
  - Property without initializer
  - Property initializer
  - Property initializer using `this`
  - Property initializer closing over `this`
  - Property initializer closing over outer scope
  - Static property without initializer
  - Static property initializer
  - Static property initializer using `this`
  - Static property initializer closing over `this`
  - Member computed key referencing outer scope
  - Closure over `this` in constructor
  - Closure over `this` in method
  - Check that `new X?.()` does not compile
  - check that getters and setters produce reasonable errors
  - check `this` in property keys
  - constructor closing over outer scope

  - Remember to test with extra memory checks enabled
*/