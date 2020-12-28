// Copy non-TypeScript files to output

const path = require('path');
const glob = require('glob');
const shelljs = require('shelljs');
import fs from 'fs';

// Combine
require('./preprocess-microvium');

const microviumDir = path.resolve(__dirname, '../');
const source = microviumDir;
const target = path.join(microviumDir, 'dist');
glob(path.resolve(microviumDir, './lib/**/!(*.ts)'), { nodir: true }, (err: any, matches: any) => {
  for (const sourcePath of matches) {
    const targetPath = path.resolve(target, path.relative(source, sourcePath));
    // console.log(`${sourcePath}\n    ${targetPath}`);
    shelljs.cp(sourcePath, targetPath);
  }
});
