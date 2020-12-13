// host.js
const { Microvium, Snapshot } = require('microvium');

// Load the snapshot from file
const snapshot = Snapshot.fromFileSync('script.mvm-bc');

// Restore the virtual machine from the snapshot
const vm = Microvium.restore(snapshot);

// Locate the function with ID 1234. This is the `sayHello` function that the script exported
const sayHello = vm.resolveExport(1234);

// Call the `sayHello` function in the script
sayHello(); // "Hello, World!"