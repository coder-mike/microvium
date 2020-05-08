// This script updates the CODE_COVERAGE macro IDs for coverage testing
import fs from 'fs';
import os from 'os';
import path from 'path';
import colors from 'colors';

interface LineInfo {
  indent: string;
  suffix: '' | '_UNTESTED' | '_UNIMPLEMENTED';
  id: number;
  lineI: number;
}

interface HitInfo {
  id: number;
  hitCount: number;
}

const hitInfoFilename = path.resolve('./test/end-to-end/artifacts/code-coverage-details.json');
const microviumCFilename = path.resolve('./native-vm/microvium.c');

const ids = new Set<number>();
const toAssign = new Array<LineInfo>();

const lines = fs.readFileSync(microviumCFilename, 'utf8')
  .split(/\r?\n/g);

const coveragePoints: LineInfo[] = [];
for (const [lineI, line] of lines.entries()) {
  const m = line.match(/^(\s*)CODE_COVERAGE(|_UNTESTED|_UNIMPLEMENTED)(\((.*?)\))?;?\s*(\/\/.*)?$/);
  if (!m) continue;
  const info: LineInfo = { suffix: m[2] as any, id: parseInt(m[4]), lineI, indent: m[1] };
  coveragePoints.push(info);
}

for (const c of coveragePoints) {
  if (!isNaN(c.id)) {
    if (ids.has(c.id)) {
      console.error(`  Warning: duplicate coverage ID ${c.id} at ` + colors.yellow(`${microviumCFilename}:${c.lineI + 1}`));
      toAssign.push(c);
    } else {
      ids.add(c.id);
    }
  } else {
    toAssign.push(c);
  }
}

let changedCount = 0;
let nextID = 1;
for (const c of toAssign) {
  while (ids.has(nextID)) {
    nextID++;
  }
  const id = nextID++;
  c.id = id;
  const s = `CODE_COVERAGE${c.suffix}(${id});`;
  lines[c.lineI] = `${c.indent}${s}`;
  console.log(`✓ ` + colors.green(`${microviumCFilename}:${c.lineI + 1} `) + s);
  changedCount++;
}

if (fs.existsSync(hitInfoFilename)) {
  const hitInfos = JSON.parse(fs.readFileSync(hitInfoFilename, 'utf8'));
  const hitCounts = new Map<number, number>(hitInfos
    .map((h: any) => [h.id, h.hitCount]));
  for (const c of coveragePoints) {
    const hitCount = hitCounts.get(c.id) || 0;
    const hitCountStr = hitCount.toString();
    if (hitCount && c.suffix === '_UNTESTED') c.suffix = '';
    const s = `CODE_COVERAGE${c.suffix}(${c.id}); // Hit-count: ${hitCountStr}`;
    const lineContent = `${c.indent}${s}`;
    if (lines[c.lineI] !== lineContent) {
      lines[c.lineI] = lineContent;
      console.log(`  ${microviumCFilename}:${c.lineI + 1} CODE_COVERAGE${c.suffix}(${c.id}); // Hit-count: ${(hitCount ? colors.green : colors.red)(hitCountStr)}`);
      changedCount++;
    }
  }
}

if (!changedCount) {
  console.log(colors.cyan(`✓ All ${coveragePoints.length} coverage markers are up to date`));
} else {
  fs.writeFileSync(microviumCFilename, lines.join(os.EOL));
}
