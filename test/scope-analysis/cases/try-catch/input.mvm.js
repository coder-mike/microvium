
function foo(a) {
  let x;
  try {
    let y;
  } catch (e) {
    let z;
  }
}

function bar(a) {
  let x;
  try {
    let y;
  } catch (e) {
    let z;
    () => e; // Capture e in the closure
  }
}