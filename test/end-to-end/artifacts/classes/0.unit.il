unit ['./test/end-to-end/tests/classes.test.mvm.js'];

entry ['#entry'];

external vmExport from free-variable 'vmExport';
external assertEqual from free-variable 'assertEqual';
external undefined from free-variable 'undefined';

global thisModule;
global test_closureInConstructor;

function ['#entry']() {
  entry:
    LoadArg(index 0);
    StoreGlobal(name 'thisModule');
    Literal(lit &function run);
    Literal(lit &function test_closureInConstructor);
    StoreGlobal(name 'test_closureInConstructor');
    // ---
    // description: >
    // Testing support for classes
    // runExportedFunction: 0
    // #assertionCount: 41
    // testOnly: true
    // ---
    LoadGlobal(name 'vmExport');
    Literal(lit undefined);
    Literal(lit 0);
    LoadVar(index 0);
    Call(count 3);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

function run() {
  entry:
    // test_globalClass();
    // test_globalInstance();
    // test_localClass();
    // test_inheritedProperties();
    // test_proto();
    // test_returnFromConstructor();
    // test_operators();
    // test_classAsMember();
    // test_closingOverClass();
    LoadGlobal(name 'test_closureInConstructor');
    Literal(lit undefined);
    Call(count 1);
    Pop(count 1);
    Literal(lit undefined);
    Return();
}

// const x = 'second';
// class GlobalClass {
// constructor(y) { this.x = y + 5 }
// myMethod() { return ++this.x }
// [x + 'Method']() { return this.x + 5 }
// static myStaticMethod() { this.x = (this.x || 1) + 1; return this.x }
// }
// GlobalClass.myProp = 42;
// const globalInst = new GlobalClass(10);
// function test_globalInstance() {
// const y = 'ethod';
// // Accessing instance constructed at compile time at the global scope
// assertEqual(globalInst.x, 15);
// assertEqual(globalInst.myMethod(), 16);
// assertEqual(globalInst.myMethod(), 17);
// assertEqual(globalInst[x + 'M' + y](), 22);
// assertEqual(globalInst['secondMethod'](), 22);
// }
// function test_globalClass() {
// assertEqual(GlobalClass.myStaticMethod(), 2);
// assertEqual(GlobalClass.myStaticMethod(), 3);
// assertEqual(GlobalClass.myProp, 42);
// // Accessing instance created at runtime of a class created at compile time
// const inst = new GlobalClass(20);
// assertEqual(inst.x, 25);
// assertEqual(inst.myMethod(), 26);
// assertEqual(inst.myMethod(), 27);
// }
// function test_localClass() {
// class LocalClass {
// constructor(y) { this.x = y + 7 }
// myMethod() { return ++this.x + 1 }
// static myStaticMethod() { this.x = (this.x || 1) + 1; return this.x }
// }
// LocalClass.myProp = 42;
// assertEqual(LocalClass.myStaticMethod(), 2);
// assertEqual(LocalClass.myStaticMethod(), 3);
// assertEqual(LocalClass.myProp, 42);
// const inst = new LocalClass(30);
// assertEqual(inst.x, 37);
// assertEqual(inst.myMethod(), 39);
// assertEqual(inst.myMethod(), 40);
// }
// function test_inheritedProperties() {
// /*
// * The objective of this test is to confirm that properties on the prototype
// * can be overridden in instances without affecting the prototype.
// */
// class LocalClass {}
// LocalClass.prototype.x = 5;
// const inst1 = new LocalClass;
// const inst2 = new LocalClass;
// assertEqual(inst1.x, 5)
// assertEqual(inst2.x, 5)
// inst1.x = 10;
// LocalClass.prototype.x = 20;
// assertEqual(inst1.x, 10) // instance property
// assertEqual(inst2.x, 20) // prototype property
// assertEqual(new LocalClass().x, 20) // prototype property
// }
// function test_proto() {
// class LocalClass1 {}
// class LocalClass2 {}
// const inst1 = new LocalClass1();
// assert(inst1.__proto__ === LocalClass1.prototype);
// assert(inst1.__proto__ !== LocalClass2.prototype);
// }
// function test_returnFromConstructor() {
// // I don't expect anyone to use this edge case, but Microvium happens to
// // support it because a return statement in a constructor is just handled as a
// // normal return.
// class LocalClass {
// constructor() { return { x: 10 } }
// }
// const inst = new LocalClass();
// assert(inst.__proto__ !== LocalClass.prototype);
// assert(inst.x === 10);
// }
// function test_operators() {
// class LocalClass {}
// const inst = new LocalClass;
// assertEqual(typeof LocalClass, 'function')
// assertEqual(typeof inst, 'object')
// assertEqual(Microvium.typeCodeOf(LocalClass), 9)
// assertEqual(Microvium.typeCodeOf(inst), 6)
// assertEqual(!!LocalClass, true)
// assertEqual(!!inst, true)
// assert(Number.isNaN(+LocalClass))
// assert(Number.isNaN(+inst))
// }
// function test_classAsMember() {
// class LocalClass {
// constructor() { this.x = 5 }
// foo() { return 10; }
// }
// const obj = { LocalClass }
// const inst = new obj.LocalClass()
// assertEqual(inst.x, 5);
// assertEqual(inst.foo(), 10);
// }
// function test_closingOverClass() {
// function inner() {
// class LocalClass {
// constructor() { this.x = 5 }
// foo() { return 20; }
// }
// return () => LocalClass;
// }
// const LocalClass = inner()();
// const inst = new LocalClass();
// assertEqual(inst.x, 5);
// assertEqual(inst.foo(), 20);
// }
function test_closureInConstructor() {
  entry:
    Literal(lit deleted);
    Literal(lit deleted);
    Literal(lit &function LocalClass_constructor);
    ObjectNew();
    ClassCreate();
    StoreVar(index 0);
    LoadVar(index 0);
    Literal(lit 'prototype');
    ObjectNew();
    ObjectSet();
    LoadVar(index 0);
    Literal(lit undefined);
    Literal(lit 5);
    New(count 2);
    StoreVar(index 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    Literal(lit 'x');
    ObjectGet();
    Literal(lit undefined);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    LoadVar(index 4);
    Literal(lit 'foo');
    ObjectGet();
    LoadVar(index 4);
    Call(count 1);
    StoreVar(index 4);
    Literal(lit 6);
    Call(count 3);
    Pop(count 1);
    LoadGlobal(name 'assertEqual');
    Literal(lit undefined);
    LoadVar(index 1);
    LoadVar(index 4);
    Literal(lit 'foo');
    ObjectGet();
    LoadVar(index 4);
    Call(count 1);
    StoreVar(index 4);
    Literal(lit 7);
    Call(count 3);
    Pop(count 1);
    Pop(count 2);
    Literal(lit undefined);
    Return();
}

function LocalClass_constructor() {
  entry:
    Literal(lit &function anonymous);
    ClosureNew();
    LoadArg(index 0);
    Literal(lit 'foo');
    LoadVar(index 0);
    ObjectSet();
    Pop(count 1);
    LoadArg(index 0);
    Return();
}

function anonymous() {
  entry:
    LoadScoped(index 1);
    Literal(lit 1);
    BinOp(op '+');
    LoadVar(index 0);
    StoreScoped(index 1);
    Return();
}