/*---
description: Tests of Uint8Array
runExportedFunction: 0
assertionCount: 8
---*/
vmExport(0, run);

const buf1 = Microvium.newUint8Array(5)
for (let i = 0; i < buf1.length; i++)
  buf1[i] = i + 1; // Writing to Uint8Array at compile-time

// Reading from Uint8Array at compile-time
assertEqual(buf1.length, 5)
assertEqual(buf1[0], 1)
assertEqual(buf1[4], 5)

function run() {
  // Reading from compile-time Uint8Array at runtime
  assertEqual(buf1.length, 5)
  assertEqual(buf1[0], 1)
  assertEqual(buf1[4], 5)

  // Mutating compile-time Uint8Array at runtime
  buf1[2] = 42;
  assertEqual(buf1[2], 42)

  // Creating Uint8Array at runtime
  const buf2 = Microvium.newUint8Array(3)
  for (let i = 0; i < buf2.length; i++)
    buf2[i] = i + 100; // Writing
  assertEqual(buf2.length, 3)
  assertEqual(buf2[0], 100)
  assertEqual(buf2[1], 101)
  assertEqual(buf2[2], 102)
}

