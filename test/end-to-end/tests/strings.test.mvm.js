/*---
description: >
  Tests various string operations and conversion to strings.
runExportedFunction: 0
assertionCount: 22
---*/

vmExport(0, run);

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

  // TODO: Strings as properties (interning)
  // TODO: Strings in RAM vs ROM
  // TODO: s[i] and s.length
  // TODO: check interning for `obj['len' + 'th']
}