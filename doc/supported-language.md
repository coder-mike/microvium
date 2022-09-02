# Supported Language

To date, only a (small) subset of the JavaScript language is supported in Microvium. Basically, Microvium as it stands is meant to be a more-friendly alternative to something like [EmbedVM](http://www.clifford.at/embedvm/).

## Supported Language features

Note: the most up-to-date authority on supported features is the [set of test scripts](../test/end-to-end/tests), each file of which is a stand-alone Microvium script that exercises a series of features in the language.

 - Basic control flow statements (`if`/`else`, `while`, `do..while`, `for`)
 - Primitive operators (`+`, `++`, `-`, `--`, `/`, `%`, `*`, `**`, `&`, `|`, `>>`, `>>>`, `<<`, `^`, `===`, `!==`, `>`, `<`, `>=`, `<=`, `!`, `~`, `? :`, `typeof`)
 - Variable declarations: `var`, `let`, and `const`
 - Nested functions (closures) and function/arrow expressions
 - Dynamically-sized arrays and objects (with limitations, see the next section), computed properties (`o[p]`).
 - Function and method calls (`f()`, `o.m()`, `o[m]()`), `this`
 - Primitive literals and simple globals: `true`/`false`, `42`, `"hello"`, `undefined`, `null`, `NaN`, `Infinity`
 - Object and array literals (`{...}` and `[...]`).
 - Modules, with `import` and `export` statements
 - `throw`, `try`, and `catch` (but not `finally`)
 - `Reflect.ownKeys` (enumerate the keys of an object)
 - `Uint8Array` as a lightweight buffer type
 - Some `class` features: class declarations, constructors and methods.
 - See also [supported builtins](./supported-builtins.md)

## NOT Supported

Some notable JavaScript features that are NOT supported in Microvium (some of these may be supported in the future):

 - `void`, `delete`, and `in` operators.
 - Option chaining operators like `x?.y`
 - Nullish coalescing operator `??`
 - The increment/decrement operators aren't supported on expressions that have computed properties, such as `obj[x]++`.
 - Class inheritance (`extends`, `super`) and computed class members (but you can assign directly to the class prototype if you need to).
 - `instanceof`
 - Class expressions
 - Most of the builtin functions and objects. For example, there is no `Array.prototype.map` or `Uint8Array.prototype.map`.
 - `finally`
 - Iterators and `for..of`
 - `for..in` (for object key iteration, use `Reflect.ownKeys`)
 - Sloppy equality (`==`, `!=`)
 - [`arguments`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/arguments), `with`
 - Regular expressions
 - BigInt, symbols, WeakMaps
 - Destructuring, spread, rest, and default parameters
 - Generators, Promises, async/await
 - `require` or dynamic `import`
 - `eval`
 - `globalThis`

Note: any deviation of Microvium from the ECMAScript standard (including unsupported features) is subject to change and should not be relied upon.
