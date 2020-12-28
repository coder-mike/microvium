/*
 * This is for usability, that we pack all of the dependent header files into
 * the distributable `microvium.c` so that all the implementation details are
 * encapsulated
 */

import fs from 'fs-extra';
import { writeTextFile } from '../lib/utils';

fs.mkdirpSync('./dist-c');
let microviumC = fs.readFileSync('./native-vm/microvium.c', 'utf8');

const versionString = JSON.parse(fs.readFileSync('package.json', 'utf8')).version;

substituteFile('#include "microvium_internals.h"', './native-vm/microvium_internals.h');
substituteFile('#include "microvium_bytecode.h"', './native-vm/microvium_bytecode.h');
substituteFile('#include "microvium_opcodes.h"', './native-vm/microvium_opcodes.h');
microviumC = performSubstitutions(microviumC);

writeTextFile('./dist-c/microvium.c', microviumC);

let microviumH = fs.readFileSync('./native-vm/microvium.h', 'utf8');
microviumH = performSubstitutions(microviumH);
fs.writeFileSync('./dist-c/microvium.h', microviumH);

fs.copyFileSync('./native-vm/microvium_port_example.h', './dist-c/microvium_port_example.h');

function substituteFile(include: string, sourceFilename: string) {
  if (!microviumC.includes(include)) {
    throw Error(`Injection point not found: "${include}"`);
  }
  let sourceHeader = fs.readFileSync(sourceFilename, 'utf8');
  sourceHeader = sourceHeader.replace('#pragma once', '');
  microviumC = microviumC.replace(include, sourceHeader + '\n');
}

function performSubstitutions(codeFile: string): string {
  return codeFile.replace('{{version}}', versionString);
}