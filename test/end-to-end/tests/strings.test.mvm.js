/*---
description: >
  Tests various string operations and conversion to strings.
runExportedFunction: 0
assertionCount: 38
---*/

vmExport(0, run);

compileTimeStringPrototypeSetup();

function run() {
  assertEqual('abc', "abc");
  assertEqual('ab_' + 'cd', 'ab_cd');
  assertEqual('ab_' + 'cd' + 'ef', 'ab_cdef');
  // Int14
  assertEqual('ab_' + 5, 'ab_5');
  // Negative
  assertEqual('ab_' + (-5), 'ab_-5');
  // Int32
  assertEqual('ab_' + 500000, 'ab_500000');
  assertEqual('ab_' + (-500000), 'ab_-500000');
  assertEqual('ab_' + (-0x80000000), 'ab_-2147483648');

  // Some general constants
  assertEqual('ab_' + null, 'ab_null');
  assertEqual('ab_' + true, 'ab_true');
  assertEqual('ab_' + false, 'ab_false');
  assertEqual('ab_' + undefined, 'ab_undefined');
  assertEqual('ab_' + (-0), 'ab_0');

  // Special strings
  assertEqual('ab_' + 'proto', 'ab_proto');
  assertEqual('proto' + '_bc', 'proto_bc');
  assertEqual('ab_' + 'length', 'ab_length');
  assertEqual('length' + '_bc', 'length_bc');

  // Interpolation
  assertEqual(``, '');
  assertEqual(`abc`, 'abc');
  assertEqual(`${'_'}abc`, '_abc');
  assertEqual(`abc${'_'}`, 'abc_');
  assertEqual(`ab${5}c`, 'ab5c');

  testStringPrototypeMethods();

  asciiTests();

  // The `textSupport` global is set by the test harness depending on the value
  // of MVM_TEXT_SUPPORT in the port file.
  if (textSupport === 1 /* BMP */ || textSupport === 2 /* Full unicode */) {
    basicMultilingualPlaneTests();
  }

  if (textSupport === 2 /* Full unicode */) {
    fullUnicodeTests();
  }
}

function testStringPrototypeMethods() {
  // WIP
}

function asciiTests() {
  // ROM string
  assertEqual('abc'.length, 3);
  assertEqual('abc'[0], 'a');
  assertEqual('abc'[2], 'c');
  assertEqual('abc'[3], undefined);

  // RAM string (constructed)
  assertEqual(('a' + 'bc').length, 3);
  assertEqual(('a' + 'bc')[0], 'a');
  assertEqual(('a' + 'bc')[2], 'c');
  assertEqual(('a' + 'bc')[3], undefined);

  // Special strings
  assertEqual('length'.length, 6);
  assertEqual('__proto__'.length, 9);
  assertEqual('length'[0], 'l');
  assertEqual('length'[5], 'h');
  assertEqual('length'[6], undefined);
  assertEqual('__proto__'[0], '_');
  assertEqual('__proto__'[8], '_');
  assertEqual('__proto__'[9], undefined);
}

function basicMultilingualPlaneTests() {

}

function fullUnicodeTests() {

}

function compileTimeStringPrototypeSetup() {

}

// WIP: The snapshot encoder needs to identify if any literal strings require
// different levels of unicode support and correspondingly set the flags