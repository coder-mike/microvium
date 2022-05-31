# Supported Language

To date, only a (small) subset of the JavaScript language is supported in Microvium. Basically, Microvium as it stands is meant to be a more-friendly alternative to something like [EmbedVM](http://www.clifford.at/embedvm/).

## Supported Language features

Note: the most up-to-date authority on supported features is the [set of test scripts](../test/end-to-end/tests), each file of which is a stand-alone Microvium script that exercises a series of features in the language.

 - Basic control flow statements (`if`/`else`, `while`, `do..while`, `for`)
 - Primitive operators (`+`, `-`, `/`, `%`, `*`, `**`, `&`, `|`, `>>`, `>>>`, `<<`, `^`, `===`, `!==`, `>`, `<`, `>=`, `<=`, `!`, `~`, `?...:`)
 - Variable declarations: `var`, `let`, and `const`
 - Nested functions (closures) and function/arrow expressions
 - Dynamically-sized arrays and objects (with limitations, see the next section), computed properties (`o[p]`).
 - Function and method calls (`f()`, `o.m()`, `o[m]()`), `this`
 - Primitive literals and simple globals: `true`/`false`, `42`, `"hello"`, `undefined`, `null`, `NaN`, `Infinity`
 - Object and array literals (`{}` and `[]`).
 - Modules, with `import` and `export` statements
 - `throw` (but not `try`/`catch`)

## NOT Supported

Some notable JavaScript features that are NOT supported in Microvium (some of these may be supported in the future):

 - `typeof`, `void`, `delete`, and `in` operators
 - Class, `instanceof` and object prototypes
 - Most of the builtin functions and objects. For example, there is no `Array.prototype.map`
 - `catch`, and `finally`.
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
 - `globalThis`

Note: any deviation of Microvium from the ECMAScript standard (including unsupported features) is subject to change and should not be relied upon.
