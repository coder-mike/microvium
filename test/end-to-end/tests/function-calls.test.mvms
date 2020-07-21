/*---
runExportedFunction: 0
expectedPrintout: |
  foo a
  foo bar b
  foo a b c
---*/
function run() {
  // Basic function
  foo('a');
  // Higher-order function
  bar(foo, 'b');
  // Arguments and return value
  const x = concat('a', 'b', 'c');
  foo(x);
}

function foo(x) {
  print('foo ' + x);
}

function bar(f, x) {
  f('bar ' + x);
}

function concat(a, b, c) {
  return a + ' ' + b + ' ' + c;
}

vmExport(0, run);