import * as fs from 'fs-extra';
import { assertSameCode } from '../lib/utils';
import { assert } from 'chai';

export interface TestFilenames {
  [key: string]: TestFilenamePair | TestFilenames;
};

export interface TestFilenamePair {
  output: string;
  expected: string;
  isBinary?: boolean;
}

export function bufferToHexString(b: Buffer) {
  // Hex string with spaces between bytes
  return b.toString('hex').replace(/([0-9a-fA-F]{2})/g, (_, v) => v + ' ').trim();
}

// This class allows tests to do all their checks at the end, while accumulating
// the results incrementally. The reason this is useful is that all the outputs
// for the test are generated before the first failure is encountered.
export class TestResults {
  #results = new Array<{ output: Buffer | string, filenames: TestFilenamePair, encoding: 'utf8' | null }>();

  push(output: Buffer | string, filenames: TestFilenamePair) {
    const encoding = typeof output === 'string' ? 'utf8' : null;
    fs.writeFileSync(filenames.output, output, encoding);
    this.#results.push({ output, filenames, encoding });
  }

  checkAll() {
    for (const { output, filenames, encoding } of this.#results) {
      const expected = fs.readFileSync(filenames.expected, encoding);
      if (encoding === 'utf8') {
        assertSameCode(output as string, expected as string);
      } else {
        assert.deepEqual(output as Buffer, expected as Buffer);
      }
    }
  }
}