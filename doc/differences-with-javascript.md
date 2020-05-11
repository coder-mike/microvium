# Differences between Microvium Language and JavaScript

(TODO: fill this out more)

  - Cannot get property of non-object. E.g. `(1).toString()` is not valid.
  - Property indexes are not coerced to strings. It is a runtime error to use the incorrect index type.
  - Integer-valued property key strings are illegal (TODO: These should be a runtime error)
  - Integer array indexes are non-negative integers`*`
  - Coercion of an array to a number `+[]` is a type error

`*`A property key is an _index_ if it is _number_ which is a non-negative integer (this does not include any strings).