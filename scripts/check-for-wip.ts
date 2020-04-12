import glob from 'glob';
import * as fs from 'fs-extra';
import colors from 'colors';

const errorCases: Array<{ pattern: RegExp, errorMessage: string }> = [
  { pattern: /\/\/ WIP/, errorMessage: 'Cannot commit with unfinished WIP' },
  { pattern: /test\.only/, errorMessage: 'Cannot commit with `test.only`' },
  { pattern: /\bdebugger(;|$)/, errorMessage: 'Cannot commit with `debugger` statements' },
];

run();

async function run() {
  const files = [
    ...glob.sync('./*.ts'),
    ...glob.sync('./test/**/*.ts'),
    ...glob.sync('./lib/**/*.ts'),
    ...glob.sync('./vm/**/*.{c,h}')
  ];
  const throttleWindow: Promise<any>[] = [];
  for (const filename of files) {
    if (throttleWindow.length > 20) await throttleWindow.shift();
    throttleWindow.push(checkFile(filename));
  }
  await Promise.all(throttleWindow);
  console.log('No WIP found');
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
        process.exit(1);
      }
    }
  }
}