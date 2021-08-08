this;

{
  this;
}

function foo() {
  this;

  () => {
    this;
  }
}

() => {
  this;

  function bar() {
    this;
  }
}
