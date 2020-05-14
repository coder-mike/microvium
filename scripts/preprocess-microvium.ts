/*
 * This is for usability, that we pack all of the dependent header files into
 * the distributable `microvium.c` so that all the implementation details are
 * encapsulated
 */

import fs from 'fs-extra';

fs.mkdirpSync('./dist-c');
let microviumC = fs.readFileSync('./native-vm/microvium.c', 'utf8');

replace('#include "microvium_internals.h"', './native-vm/microvium_internals.h');
replace('#include "microvium_bytecode.h"', './native-vm/microvium_bytecode.h');
replace('#include "microvium_opcodes.h"', './native-vm/microvium_opcodes.h');

function replace(include: string, sourceFilename: string) {
  if (!microviumC.includes(include)) {
    throw Error(`Injection point not found: "${include}"`);
  }
  let sourceHeader = fs.readFileSync(sourceFilename, 'utf8');
  sourceHeader = sourceHeader.replace('#pragma once', '');
  microviumC = microviumC.replace(include, sourceHeader + '\n');
}

fs.writeFileSync('./dist-c/microvium.c', microviumC);
fs.copyFileSync('./native-vm/microvium.h', './dist-c/microvium.h');
fs.copyFileSync('./native-vm/microvium_port_example.h', './dist-c/microvium_port_example.h');
