// This script updates the CODE_COVERAGE macro IDs for coverage testing
import fs from 'fs';
import os from 'os';

interface LineInfo {
  indent: string;
  untested: boolean;
  id: number;
  lineI: number;
}

const lines = fs.readFileSync('./native-vm/microvium.c', 'utf8')
  .split(/\r?\n/g);
const ids = new Set<number>();
const toAssign = new Array<LineInfo>();

for (const [lineI, line] of lines.entries()) {
  const m = line.match(/^(\s*)CODE_COVERAGE(_UNTESTED)?\((.*?)\);\s*(\/\/.*)?$/)
  if (m) {
    const indent = m[1];
    const untested = Boolean(m[2]);
    let id = parseInt(m[3]);
    const lineInfo: LineInfo = { untested, id, lineI, indent };
    console.log(lineInfo);
    if (!isNaN(id)) {
      if (ids.has(id)) {
        console.error(`Warning: duplicate CODE_COVERAGE ID (${id}) on line ${lineI + 1}`);
        toAssign.push(lineInfo);
      } else {
        ids.add(id);
      }
    } else {
      toAssign.push(lineInfo);
    }
  }
}

let nextID = 1;
for (const { untested, lineI, indent } of toAssign) {
  while (ids.has(nextID)) {
    nextID++;
  }
  const id = nextID++;
  lines[lineI] = `${indent}CODE_COVERAGE${untested ? '_UNTESTED' : ''}(${id});`;
}

fs.writeFileSync('./native-vm/microvium.c', lines.join(os.EOL));
