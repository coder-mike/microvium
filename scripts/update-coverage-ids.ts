// This script updates the CODE_COVERAGE macro IDs for coverage testing
import fs from 'fs';
import os from 'os';
import path from 'path';
import colors from 'colors';

interface LineInfo {
  indent: string;
  untested: boolean;
  id: number;
  lineI: number;
}

const filename = path.resolve('./native-vm/microvium.c');

const lines = fs.readFileSync(filename, 'utf8')
  .split(/\r?\n/g);
const ids = new Set<number>();
const toAssign = new Array<LineInfo>();
let coverageInstanceCount = 0;

for (const [lineI, line] of lines.entries()) {
  const m = line.match(/^(\s*)CODE_COVERAGE(_UNTESTED)?(\((.*?)\))?;?\s*(\/\/.*)?$/)
  if (m) {
    coverageInstanceCount++;
    const indent = m[1];
    const untested = Boolean(m[2]);
    let id = parseInt(m[4]);
    const lineInfo: LineInfo = { untested, id, lineI, indent };
    if (!isNaN(id)) {
      if (ids.has(id)) {
        console.error(`  Warning: duplicate coverage ID ${id} at ` + colors.yellow(`${filename}:${lineI + 1}`));
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
  const s = `CODE_COVERAGE${untested ? '_UNTESTED' : ''}(${id});`;
  lines[lineI] = `${indent}${s}`;
  console.log(`✓ ` + colors.green(`${filename}:${lineI + 1} `) + s);
}

if (toAssign.length === 0) {
  console.log(colors.cyan(`✓ All ${coverageInstanceCount} coverage IDs are up to date`));
} else {
  fs.writeFileSync(filename, lines.join(os.EOL));
}

