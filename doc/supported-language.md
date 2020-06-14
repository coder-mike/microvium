# Supported Language

To date, only a (small) subset of the JavaScript language is supported in Microvium. Basically, Microvium as it stands is meant to be a more-friendly alternative to something like [EmbedVM](http://www.clifford.at/embedvm/).

## Supported Language features

Note: the most up-to-date authority on supported features is the [set of test scripts](../test/end-to-end/tests), each file of which is a stand-alone Microvium script that exercises a series of features in the language.

 - Basic control flow statements (`if`/`else`, `while`, `do..while`, `for`)
 - Primitive operators (`+`, `-`, `/`, `%`, `*`, `**`, `&`, `|`, `>>`, `>>>`, `<<`, `^`, `===`, `!==`, `>`, `<`, `>=`, `<=`, `!`, `~`, `?...:`)
 - Variable declarations: `var`, `let`, and `const`
 - Top-level function declarations (not nested)
 - Dynamically-sized arrays and objects (with limitations, see the next section), computed properties (`o[p]`).
 - Function and method calls (`f()`, `o.m()`, `o[m]()`), `this`
 - Primitive literals (`true`/`false`, `42`, `"hello"`, `undefined`, `null`, `NaN`, `Infinity`), object literals (`{}`), and array literals (`[]`).
 - Modules, with `import` and `export` statements

(Pedant note: `undefined`, `NaN`, and `Infinity` are not literals, they are globals)

## NOT Supported

Some notable JavaScript features that are NOT supported in Microvium (some of these may be supported in the future):

 - `typeof`, `void`, `delete`, and `in` operators
 - Class, `instanceof` and object prototypes
 - Nested functions and function/arrow expressions
 - Most of the builtin functions and objects. For example, there is no `Array.prototype.map`
 - Exceptions, `throw`, `catch`, and `finally`.
 - Iterators and `for..of`
 - Sloppy equality (`==`, `!=`)
 - `arguments`, `with`
 - Regular expressions
 - Timers
 - BigInt, symbols, WeakMaps
 - Destructuring, spread, rest, and default parameters
 - Generators, Promise, Async/Await
 - Some arguably-less-common control-flow and expressions such as `for..in`
 - Dynamic `import` and top-level await
 - `eval`
 - Internationalization (`Intl`)

(Pedant note: timers are not a standard feature of JavaScript)

## Deviation from JavaScript semantics

There are some features of JavaScript which are roughly supported in Microvium but have different semantics for performance reasons. This list will grow:

  - Cannot get property of non-object. E.g. `(1).toString()` is not valid.
  - Property assignment to a non-index key on an array has no effect (e.g. `array.x = y`)
  - Integer array indexes are non-negative integers`*`
  - Coercion of an array to a number `+[]` is a type error

`*`A property key is an _index_ if it is _number_ which is a non-negative integer (this does not include any strings).
