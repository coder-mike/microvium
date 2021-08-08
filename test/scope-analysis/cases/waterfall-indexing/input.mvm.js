function foo(x) {
  let a;
  let b;
  function bar(y) {
    let c;
    let d;
    function baz(z) {
      let e;
      let f;
      function qux() {
        z; // 0
        e; // 1
        f; // 2
        y; // 3
        c; // 4
        d; // 5
        x; // 6
        a; // 7
        b; // 8
      }
    }
  }
}