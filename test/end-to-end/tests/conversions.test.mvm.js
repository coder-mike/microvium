/*---
description: >
  Tests primitive type conversions
runExportedFunction: 0
assertionCount: 14
testOnly: false
---*/
vmExport(0, run);

function run() {
  testConvertToNumber();
  testConvertToBoolean();
}

function testConvertToNumber() {
  assertEqual(+(1 + 1), 2);
  assertEqual(+(1.1 + 2), 3.1);
  assert(Number.isNaN(+undefined));
  assert(Number.isNaN(+{}));
  assertEqual(+null, 0);
  // TODO
  // +[] should throw, since its behavior seems to be unintuitive and there isn't really a need for it.

  // TODO
  // assertEqual(+"5", 5);
  // assertEqual(+"-5", -5);
  // assertEqual(+"-5.1", -5.1);
  // assert(+" 5 ", 5);
}

function testConvertToBoolean() {
  assertEqual(!!(1), true);
  assertEqual(!!(0), false);
  assertEqual(!!(-1), true);
  assertEqual(!!(undefined), false);
  assertEqual(!!(null), false);
  assertEqual(!!({}), true);
  assertEqual(!!([]), true);
  assertEqual(!!(''), false);
  assertEqual(!!('x'), true);
}
