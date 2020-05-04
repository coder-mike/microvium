# Differences between Microvium Language and Jessie

[Jessie](https://github.com/Agoric/Jessie) is a proposed subset of JavaScript which is intended to be a lightweight and portable description of computations in the same way JSON is a portable description of data. Jessie would be a good candidate language for Microvium to accept. However, there are some differences between the Microvium language and Jessie. Some of these differences are due to Microvium being incomplete, and some are intentional.

## Features in Microvium that are not in Jessie

  - Object and array mutation
  - Computed property access

## Features in Jessie that are not in Microvium

Features in Jessie that are missing from Microvium **by design**:

  - Nothing yet

Features missing from Microvium that may be **implemented later**:

  - Closures, arrow functions
  - Basically the whole runtime library, including but not limited to `Map`, `Set`, `Math`, etc.

## Features that are NOT in Jessie but which Microvium may implement later

  - `await`
  - `class`

## Other deviations from the specification

  - `Array.length` is not writable, thus making arrays contiguous (but arrays can still be extended by `push` and mutated through assignment).
  - `.prototype` ?