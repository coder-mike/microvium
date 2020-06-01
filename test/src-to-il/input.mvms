function foo(param1, param2, param3) {
  // Parameters
  param1;
  param2;
  param3;
  // Literal values (these are also expression statements)
  undefined;
  null;
  true;
  false;
  0;
  1.5;
  "Hello";
  'there';
  // If-statement
  if (1) {
  }
  // If-statement with nested
  if (2) {
    // (nested if statement)
    if (3) {
    }
  }
  // If-else statement
  if (4) {
    // (nested in consequent)
    if (5) {
    }
  } else {
    // (nested in alternate)
    if (6) {
    }
  }
  // Do statement
  do {} while (7);
  // Do-while with nested if
  do {
    // (nested in do-while)
    if (8) {}
  } while (9);

  // While statement
  while (9) { }

  // Variable declaration
  let a;

  // Declaration with 2 variables
  let b, c, d;

  // Variable declaration with initializer
  let e = 5;

  // Double variable declaration with initializers
  let f = 6, g = 7;

  // Access local variable
  a;

  // Local variable from nested context
  {
    a;
  }

  // Local variable in nested context
  {
    let a;
    a;
    {
      a;
    }
  }

  // Global variable
  globalA;
  // Global variable from nested context
  {
    globalA;
  }

  // For-loop
  for (let i = 0; i < 10; i++) {
    // `If` nested in `for` loop
    if (10) {}
  }

  // Unary operators
  +a;
  +1;
  -a;
  -1;
  !a;
  ~a;

  // Assignment expressions
  a = b = c;
  a += b;
  a -= b;
  a *= b;
  a /= b;
  a %= b;
  a <<= b;
  a >>= b;
  a >>>= b;
  a |= b;
  a ^= b;
  a &= b;

  // Comparison expressions
  a === b;
  a !== b;
  a > b;
  a >= b;
  a < b;
  a <= b;

  // Arithmetic expressions
  a % b;
  a++;
  a--;
  ++a;
  --a;

  // Bitwise expressions
  a & b;
  a | b;
  a ^ b;
  ~a;
  a << b;
  a >> b;
  a >>> b;

  // Logical operators
  a && b;
  a || b;
  !a;

  // Function call
  a(b, c);

  // Referencing a function
  foo;

  // Array access
  a = [];
  a = [1, 2];
  a[0];
  a[0] = 1;
  a[0] += 1;
  // a.length
  a.length;
  // a.push(b);
  a.push(b);

  // Object property access
  a = {};
  a = { b: 5, c: 6 };
  a.b;
  a.b = c;
  a.b += 1;

  // Imported variable
  ext;
  ext();
  ext[0];
  ext[0] = 5;
  ext.x = 6;

  // Return statement
  return;
  return a;
}

// Global variables
let globalA;
let globalB = 42;
let globalC, globalD = 43;

{
  let notAGlobal = 44;
}

// Read global variable
globalA;

// Read global variable in nested scope
{
  globalA;
}

// Read local variable in global scope
{
  let a;
  a;
}
{
  let a;
  a;
}

// Literal types (these are also expression statements)
undefined;
null;
true;
false;
0;
1.5;
"Hello";
'there';
// If-statement
if (1) {
}
// If-statement with nested
if (2) {
  // (nested if statement)
  if (3) {
  }
}
// If-else statement
if (4) {
  // (nested in consequent)
  if (5) {
  }
} else {
  // (nested in alternate)
  if (6) {
  }
}
// Do statement
do {} while (7);
// Do-while with nested if
do {
  // (nested in do-while)
  if (8) {}
} while (9);

// For-loop
for (let i = 0; i < 10; i++) {
  // `If` nested in `for` loop
  if (10) {}
}

// Export let
export let exportedA = 5;
// Export function
export function bar() {
}
// Import namespace
import * as importedNamespace from './another-file';
// Import named declaration
import { importedProperty } from './another-file';
// Import with alias
import { importedProperty as importedLocal } from './another-file';

// Access let export
exportedA;
exportedA = 3;
// Access exported function
bar;
// Access imported namespace
importedNamespace;
// Access imported member
importedProperty;
importedProperty = 5;
// Access imported alias
importedLocal;
importedLocal = 6;
