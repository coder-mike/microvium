// script.mvm.js
console.log = vmImport(1);
function sayHello() {
  console.log('Hello, World!');
}
vmExport(1234, sayHello);