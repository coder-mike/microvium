import { unexpected } from "./utils";
import colors from 'colors';
import fs from 'fs';
import os from 'os';
import path from 'path';

export interface LineInfo {
  lineI: number;
  indent: string;
  type: 'normal' | 'untested' | 'unimplemented' | 'error-path' | 'table';
  id: number; // Will be NaN if the ID has not been filled in
  comment?: string;
  // For table coverage
  indexInTable?: string; // Runtime expression
  tableSize?: string; // Runtime expression
}

export interface CoverageHitInfos {
  [id: number]: {
    lineHitCount: number,
    tableSize?: number,
    hitCountByTableEntry?: { [index: number]: number | undefined }
  } | undefined
}

export function getCoveragePoints(sourceLines: string[], filename: string): LineInfo[] {
  const coveragePoints: LineInfo[] = [];
  for (const [lineI, line] of sourceLines.entries()) {
    let m = line.match(/^(\s*)CODE_COVERAGE(|_UNTESTED|_UNIMPLEMENTED|_ERROR_PATH)\((.*?)\);\s*(\/\/.*)?$/);
    if (m) {
      const info: LineInfo = {
        lineI,
        indent: m[1],
        type:
          m[2] === '' ? 'normal':
          m[2] === '_UNTESTED' ? 'untested':
          m[2] === '_UNIMPLEMENTED' ? 'unimplemented':
          m[2] === '_ERROR_PATH' ? 'error-path':
          unexpected(),
        id: parseInt(m[3]),
        comment: m[4],
      };
      coveragePoints.push(info);
    } else if (line.includes('CODE_COVERAGE')) {
      throw new Error(`Invalid CODE_COVERAGE marker\n        at ${filename}:${lineI + 1}`);
    }
    m = line.match(/^(\s*)TABLE_COVERAGE\((.*?),(.*?)(?:,(.*?))?\);\s*(\/\/.*)?$/);
    if (m) {
      const info: LineInfo = {
        type: 'table',
        lineI,
        indent: m[1],
        indexInTable: m[2].trim(),
        tableSize: m[3].trim(),
        id: parseInt(m[4]),
        comment: m[5],
      };
      coveragePoints.push(info);
    } else if (line.includes('TABLE_COVERAGE')) {
      throw new Error(`Invalid TABLE_COVERAGE marker\n    at ${colors.red(`${filename}:${lineI + 1}`)}`);
    }
  }
  return coveragePoints;
}

export function reconstructCoverageLine(lineInfo: LineInfo, includeIndent: boolean) {
  let macroMain: string;
  switch (lineInfo.type) {
    case 'normal': macroMain = `CODE_COVERAGE(${lineInfo.id});`; break;
    case 'untested': macroMain = `CODE_COVERAGE_UNTESTED(${lineInfo.id});`; break;
    case 'unimplemented': macroMain = `CODE_COVERAGE_UNIMPLEMENTED(${lineInfo.id});`; break;
    case 'error-path': macroMain = `CODE_COVERAGE_ERROR_PATH(${lineInfo.id});`; break;
    case 'table': macroMain = `TABLE_COVERAGE(${lineInfo.indexInTable}, ${lineInfo.tableSize}, ${lineInfo.id});`; break;
  }
  return `${
    includeIndent ? lineInfo.indent : ''
  }${
    macroMain
  }${
    lineInfo.comment
      ? ' ' + lineInfo.comment
      : ''
  }`;
}

export function updateCoverageMarkers(silent: boolean) {
  const hitInfoFilename = path.resolve('./test/end-to-end/artifacts/code-coverage-details.json');
  const microviumCFilename = './native-vm/microvium.c';

  const ids = new Set<number>();
  const toAssign = new Array<LineInfo>();

  const lines = fs.readFileSync(microviumCFilename, 'utf8')
    .split(/\r?\n/g);


  const log = (s: string) => !silent && console.log(s);

  const coveragePoints = getCoveragePoints(lines, microviumCFilename);

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
  }

  // If we have hit count information, then we calculate all lines based on hit information
  if (fs.existsSync(hitInfoFilename)) {
    const coverageHits: CoverageHitInfos = JSON.parse(fs.readFileSync(hitInfoFilename, 'utf8'));
    for (const c of coveragePoints) {
      const hitInfo = coverageHits[c.id];
      // If there is any hit information, and the type is
      if (hitInfo) {
        if (c.type === 'untested') c.type = 'normal';
        if (hitInfo.tableSize !== undefined && hitInfo.hitCountByTableEntry !== undefined) {
          c.comment = `// Hit ${Object.keys(hitInfo.hitCountByTableEntry).length}/${hitInfo.tableSize}`;
        } else {
          c.comment = '// Hit';
        }
      } else {
        c.comment = '// Not hit';
      }
      const s = reconstructCoverageLine(c, false);
      const lineContent = `${c.indent}${s}`;
      if (lines[c.lineI] !== lineContent) {
        lines[c.lineI] = lineContent;
        log(`  ${microviumCFilename}:${c.lineI + 1} ${s}`);
        changedCount++;
      }
    }
  } else {
    for (const c of toAssign) {
      const s = reconstructCoverageLine(c, false);
      lines[c.lineI] = `${c.indent}${s}`;
      log(`✓ ` + colors.green(`${microviumCFilename}:${c.lineI + 1} `) + s);
      changedCount++;
    }
  }

  if (!changedCount) {
    log(colors.cyan(`✓ All ${coveragePoints.length} coverage markers are up to date`));
  } else {
    fs.writeFileSync(microviumCFilename, lines.join(os.EOL));
  }
}