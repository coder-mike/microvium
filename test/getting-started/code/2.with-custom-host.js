// host.js
const Microvium = require('microvium');

const vm = Microvium.create();

// Create a "print" function in the global scope that refers to this lambda function in the host
vm.globalThis.print = s => console.log(s);

// Run some module source code
vm.evaluateModule({ sourceText: 'print("Hello, World!");' }); // Prints "Hello, World!" to the console