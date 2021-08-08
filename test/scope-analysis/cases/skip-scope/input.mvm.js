function foo() {
  // `foo` needs a closure scope because it has closure-scoped variable `x`
  let x;
  // `bar` is a closure because it closes over `x`. But `bar` doesn't need its
  // own closure scope because it has none of its own closure variables
  function bar() {
    // `baz` is also a closure because it closes over `x`. Baz also doesn't need
    // its own scope
    function baz() {
      x;
    }
  }
}