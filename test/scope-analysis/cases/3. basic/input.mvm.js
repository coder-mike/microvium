let global1;
export let exported1;
import { imported1 as imported2 } from 'another-module';

foo;
bar;
global1;
exported1;
imported2;
freeVariable1;

// Note: bar is accessed from function `foo` but `foo` is only accessed from the
// global scope so `foo` is actually a local variable in the entry function
// while `bar` is a global
function foo() {
  let local1;
  var local2;
  const local3 = 42;

  global1;
  local1;
  local2;
  local3;
  local4; // Hoisted
  exported1;
  imported2;
  bar;
  freeVariable2;

  {
    var local4;
    let local5;
    const local6 = 43;

    global1;
    local1;
    local2;
    local3;
    local4;
    exported1;
    imported2;
    bar;
    local5;
    local6;
    freeVariable3;
  }
}

function bar() {

}

/*
Bugs:

It looks like the global variable `bar` is never initialized in the module prolog
 */

// TODO: a global variable named `thisModule`
// TODO: two functions with the same name
// TODO: parameters