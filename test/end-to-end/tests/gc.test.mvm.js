/*---
runExportedFunction: 0
nativeOnly: true
description: Some garbage collection tests
---*/
function run() {
  garbage = 0;
  heap = getHeapUsed();
  function1();
}


let garbage;
let globalVariable;
let heap;

function function1() {
  // New array with global reference
  globalVariable = [0];
  checkAllocated(10, 0);

  // TODO: When we have closures, we should check with a closure reference as well
  // New array with local reference
  let localVariable1A = [1];
  checkAllocated(10, 0);

  // Resize array
  localVariable1A[1] = 42; // See setProperty and growArray
  checkAllocated(10, 4);

  // New array
  let localVariable1B = [2];
  checkAllocated(10, 0);

  // Make eligible for GC
  localVariable1B = undefined;
  checkAllocated(0, 10);

  nestedFunction();
}

function nestedFunction() {
  // New object. Note that new objects are manufactured empty to start with and
  // then properties are added.
  let localVariable2A = { x: 3 };
  checkAllocated(16, 6);

  // Extend object
  localVariable2A.y = 4;
  checkAllocated(10, 6);

  // Extend object
  localVariable2A.z = 5;
  checkAllocated(10, 6);

  // New object
  let localVariable2B = { x: 6 };
  checkAllocated(16, 6);

  // Make eligible for GC
  localVariable2B = 0;
  checkAllocated(0, 10);

  // TODO: This tests an explicit run of the GC, but it would also be good to
  // test an explicit run because the top frame will be internal rather than
  // the host
  // checkGC();
}

function checkAllocated(newAllocatedSize, newGarbageSize) {
  assertEqual(getHeapUsed() - heap, newAllocatedSize);
  heap += newAllocatedSize;
  garbage += newGarbageSize; // (will be checked at end)
}

function checkGC() {
  checkAllocated(0, 0); // Just check consistency between `heap` and `getHeapUsed`
  runGC();
  checkAllocated(-garbage, -garbage); // Check that garbage is deallocated
}

vmExport(0, run);