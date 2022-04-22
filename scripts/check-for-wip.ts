// Checks source code files for signs that I would call "WIP". Particularly for
// my workflow.

import glob from 'glob';
import * as fs from 'fs-extra';
import colors from 'colors';

const errorCases: Array<{ pattern: RegExp, errorMessage: string }> = [
  { pattern: /\bWIP\b/, errorMessage: 'Cannot commit with unfinished WIP' },
  { pattern: /test\.only\(/, errorMessage: 'Cannot commit with `test.only`' },
  { pattern: /^testOnly: true/, errorMessage: 'Cannot commit with `testOnly: true`' },
  { pattern: /(?<!\/\*disable-wip-check\*\/)\bdebugger(;|$)/, errorMessage: 'Cannot commit with `debugger` statements' },
];

let wipCount = 0;

run();


async function run() {
  const files = [
    ...glob.sync('./todo'),
    ...glob.sync('./*.ts'),
    ...glob.sync('./test/**/*.ts'),
    ...glob.sync('./test/**/*.test.mvm.js'),
    ...glob.sync('./lib/**/*.ts'),
    ...glob.sync('./native-vm/**/*.{c,h}')
  ];
  const throttleWindow: Promise<any>[] = [];
  for (const filename of files) {
    if (throttleWindow.length > 20) await throttleWindow.shift();
    throttleWindow.push(checkFile(filename));
  }
  await Promise.all(throttleWindow);
  if (wipCount) {
    process.exit(1);
  } else {
    console.log(colors.green('  ✓ No WIP found'));
  }
}

async function checkFile(filename: string) {
  const contents = await fs.readFile(filename, 'utf8');
  const lines = contents.split('\n');
  for (const [lineI, line] of lines.entries()) {
    for (const { pattern, errorMessage } of errorCases) {
      if (pattern.test(line)) {
        console.error(colors.red(`${errorMessage} at (${
          colors.yellow(`${filename}:${lineI + 1}`)
        })`));
        wipCount++;
      }
    }
  }
}