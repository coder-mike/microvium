import * as fs from 'fs-extra';
import { assert } from 'chai';
import * as path from 'path';

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
    if (!fs.pathExistsSync(path.dirname(filenames.output))) {
      fs.emptyDirSync(path.dirname(filenames.output));
    }
    if (!fs.pathExistsSync(path.dirname(filenames.expected))) {
      fs.emptyDirSync(path.dirname(filenames.expected));
    }
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

/**
 * Compares code but normalizes the indentation first
 */
export function assertSameCode(actual: string, expected: string) {
  function normalizeIndentation(code: string) {
    // The rest of this function doesn't work well with empty strings
    if (/^\s*$/.test(code)) {
      return '';
    }
    code = code.replace(/\t/g, '  '); // Replace tabs
    code = code.replace(/^(\s*\n)+/, ''); // replace leading blank lines
    code = code.replace(/(\s*\n)+$/, ''); // replace trailing blank lines
    code = code.replace(/(\s*\n\s*\n)+/g, '\n'); // replace all other blank lines
    code = code.trimRight();
    const lines = code.split('\n');
    const indentOf = (line: string) => (line.match(/^ */) as any)[0].length;
    const nonBlankLines = lines.filter(l => !(/^\s*$/g).test(l));
    const minIndent = ' '.repeat(Math.min.apply(Math, nonBlankLines.map(indentOf)));
    const matchIndent = new RegExp('^' + minIndent, 'gm');
    const normalized = code.replace(matchIndent, '');
    return normalized;
  };
  function normalizeLineEndings(code: string) {
    return code.replace(/(\r\n)|(\n\r)/g, '\n');
  }
  function normalize(code: string) {
    return normalizeIndentation(normalizeLineEndings(code));
  }
  const normalizedActual = normalize(actual);
  const normalizedExpected = normalize(expected);
  assert.deepEqual(normalizedActual, normalizedExpected);
}