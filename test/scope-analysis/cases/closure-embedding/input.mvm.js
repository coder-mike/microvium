

function case1() {
  // Increment should be embedded, but decrement should not be. The variable x
  // should be slot 1 because slot 0 is reserved for the function pointer. It
  // should be accessed by relative index 1 and 3 depending on which function.
  let x = 0;
  function increment1() { ++x }
  function decrement1() { --x }
}

function case2() {
  // In this example, the loop body has a different instance count to the
  // function body, and so `increment` can't be embedded into the function body,
  // but it will be embedded into the loop body. The `++x` expression will
  // access `x` at relative index 2. The closure for the body of `case2` will
  // only have a single slot.
  let x = 0;
  for (let i = 0; i < 10; i++) {
    function increment2() { ++x; }
  }
}

function case3() {
  // This is the same as the previous example except that the increment function
  // also closes over `i`, which causes a whole new closure in the chain,
  // because `i` is considered to be in a different instance count to
  // `increment3`.
  let x = 0;
  for (let i = 0; i < 10; i++) {
    i + x; // Uses relative indexes 2 and 4
    function increment3() { i + x; } // Uses relative indexes 2 and 4
  }
}

function case4() {
  // This is the same as the previous example except that we don't capture i
  // directly, we instead capture it inside of the loop body, which is the same
  // "instance count" as increment4, so it saves on one scope in the chain.
  // `increment4` will be embedded into the loop body.
  let x = 0;
  for (let i = 0; i < 10; i++) {
    const i2 = i;
    function increment4() { i2 + x; } // Uses relative indexes 1 and 3
  }
}

// WIP: we need a test case that tests the re-use of the parent slot for another variable.