/*---
description: >
  Switch statements
runExportedFunction: 0
# The disassembly uses different block numbers and optimizes the fall-through cases better
dontCompareDisassembly: true
assertionCount: 6
expectedPrintout: |
  emptySwitch:after
  switchWithOnlyDefault:default
  switchWithOnlyDefault:after
  1
  2
  4
  c
  d
  !
  1
  2
  b
  c
  d
  !
  x
  y
  z
---*/

vmExport(0, run);

function run() {
  emptySwitch();
  switchWithOnlyDefault();

  assertEqual(convert(5), 'It was 5');
  assertEqual(convert(6), 'It was 6');
  assertEqual(convert(7), 'It was 7');
  assertEqual(convert('x'), 'It was x');
  assertEqual(convert('something else'), "Don't know what it was");

  weirdSwitch(5);
  weirdSwitch(2);

  switchFallThroughBottom();

  assertEqual(switchWithNoDefault(), 22);
}

function convert(x) {
  let result;
  switch (x) {
    // TODO: break also affects loops. We should have tests for breaking out of loops nested in switches and vice versa
    case 5: result = 'It was 5'; break;
    case 6: result = 'It was 6'; break;
    case 3+4: return 'It was 7';
    case 'x': return 'It was x';
    default: return "Don't know what it was";
  }
  return result;
}

function weirdSwitch(x) {
  // JavaScript has weird (IMO) behavior with fall through from `default`. The
  // test case for `4` is evaluated before the fallback to the default case, but
  // then the consequent for the default case falls through to the consequent of
  // case `4`.
  switch (x) {
    case evaluateCase(1): print('a');
    case evaluateCase(2): print('b');
    default: evaluateCase('c');
    case evaluateCase(4): print('d');
  }
  print('!');
}

function evaluateCase(x) {
  print(x);
  return x;
}

function switchWithNoDefault(x) {
  switch (5) {
    case 1: return 1;
    case 2: return 2;
    case 3: return 3;
    /* No cases matched, implicit default hit */
  }
  return 22;
}

function switchFallThroughBottom() {
  switch (1) {
    case 0: print('w');
    case 1: print('x')
    case 2: print('y');
    /* Fall through bottom of switch */
  }
  print('z');
}

function emptySwitch() {
  switch (1) {
  }
  print('emptySwitch:after')
}

function switchWithOnlyDefault() {
  switch (1) {
    default: print('switchWithOnlyDefault:default')
  }
  print('switchWithOnlyDefault:after')
}