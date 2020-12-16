// Takes the output from the tests and pastes it over the "expected" value, so
// that those tests pass. Not all tests use an output of this form.

import fs from 'fs';
import colors from 'colors';
import { testFilenames } from '../test/filenames';
import { TestFilenames, TestFilenamePair } from '../test/common';

for (const [testSuiteName, pairs] of Object.entries(testFilenames)) {
  console.log('# ' + colors.bold(testSuiteName));
  processTestFilenames('', pairs);
}

function processTestFilenames(parentPrefix: string, testFilenames: TestFilenames) {
  for (const [key, pair] of Object.entries(testFilenames)) {
    if (!isTestFilenamePair(pair)) {
      processTestFilenames(parentPrefix + key + '.', pair);
      continue;
    }
    let status: string;
    let color: colors.Color;
    const isBinary = pair.isBinary || false;
    try {
      const output = fs.readFileSync(pair.output, null);
      try {
        const expected = fs.readFileSync(pair.expected, null);
        if (output.equals(expected)) {
          color = colors.blue;
          status = '✓ Up to date';
        } else {
          try {
            fs.writeFileSync(pair.expected, output, null);
            color = colors.green;
            status = '✔ Updated';
          } catch {
            status = '✘ Failed to write';
            color = colors.red;
          }
        }
      } catch {
        try {
          fs.writeFileSync(pair.expected, output, null);
          color = colors.yellow;
          status = '✔ Created';
        } catch {
          status = '✘ Failed to write';
          color = colors.red;
        }
      }
    } catch {
      status = '✘ Failed to read output';
      color = colors.red;
    }
    const label = parentPrefix + key;
    console.log(` • ${
      label
    } ${
      colors.gray(''.padEnd(23 - label.length, '.'))
    } ${
      color(status.padEnd(12))
    } ${
      colors.gray(`(${pair.expected})`)
    }`);
  }
}

function isTestFilenamePair(value: TestFilenames | TestFilenamePair): value is TestFilenamePair {
  return typeof value.output === 'string' && typeof value.expected === 'string';
}