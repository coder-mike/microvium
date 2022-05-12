import { assertSameCode, TestFilenames } from "./common";
import fs from 'fs-extra';
import path from 'path';
import os from 'os';

export interface TestCases {
  run(): void;
  filenames: TestFilenames;
}

export interface TestApi {
  inputFilename(filename: string): string;
  input(filename: string, encoding: 'utf8'): InputFileApi<string>;
  actualOutputFilename(filename: string): string;
  expectedOutputFilename(filename: string): string;
  output(filename: string, encoding: 'utf8'): OutputFileApi<string>;
  onRun(handler: () => void): void;
}

export interface InputFileApi<T> {
  read(): T;
}

export interface OutputFileApi<T> {
  /**
   * Define what the actual output is
   */
  actual: T;

  /**
   * Read what the expected output is
   */
  readonly expected: T;

  /**
   * Compare the actual and expected output
   */
  check(): void;

  readonly actualFilename: string;
  readonly expectedFilename: string;
}

export function testsInFolder(folder: string, defineTest: (api: TestApi) => void): TestCases {
  let phase: 'definition-phase' | 'run-phase' = 'definition-phase';

  const allFilenames: TestFilenames = {};
  const testCases = new Array<{ name: string, run: () => void }>();

  const testCaseFolders = fs.readdirSync(folder);
  for (const testCaseFolder of testCaseFolders) {
    const testName = testCaseFolder;
    const testCaseInputDir = path.join(folder, testCaseFolder);
    const testCaseExpectedOutputDir = path.join(folder, testCaseFolder, './expected');
    const testCaseActualOutputPath = path.join(folder, testCaseFolder, './actual');
    const filenamesForTestCase: TestFilenames = {};
    allFilenames[testName] = filenamesForTestCase;
    const handlers = new Array<() => void>();

    defineTest({ input, inputFilename, onRun, output, actualOutputFilename, expectedOutputFilename });

    testCases.push({
      name: testName,
      run() {
        fs.emptyDirSync(testCaseActualOutputPath);
        for (const handler of handlers) {
          handler();
        }
      }
    })

    function onRun(handler: () => void) {
      expectDefinitionPhase('onRun');
      handlers.push(handler);
    }

    function inputFilename(filename: string): string {
      expectDefinitionPhase('inputFilename');
      return path.join(testCaseInputDir, filename);
    }

    function input(filename: string, encoding: 'utf8'): InputFileApi<string> {
      expectDefinitionPhase('input');
      const fullFilename = inputFilename(filename);
      return {
        read() {
          expectRunPhase('Input.read');
          return fs.readFileSync(fullFilename, encoding);
        }
      }
    }

    function actualOutputFilename(filename: string): string {
      expectDefinitionPhase('actualOutputFilename');
      return path.join(testCaseActualOutputPath, filename);
    }

    function expectedOutputFilename(filename: string): string {
      expectDefinitionPhase('expectedOutputFilename');
      return path.join(testCaseExpectedOutputDir, filename);
    }

    function output(filename: string, encoding: 'utf8'): OutputFileApi<string> {
      expectDefinitionPhase('output');

      let actual: string | undefined;
      let expected: string | undefined;

      const file: OutputFileApi<string> = {
        actualFilename: actualOutputFilename(filename),
        expectedFilename: expectedOutputFilename(filename),

        get actual() {
          expectRunPhase('Output.actual');
          if (actual === undefined) {
            throw new Error('Getting `Output.actual` before setting it');
          }
          return actual;
        },

        set actual(value: string) {
          expectRunPhase('Output.actual');
          actual = value ?? '';
          if (encoding === 'utf8' || encoding === 'utf-8') {
            // If you use the git setting "auto" for line feeds (which is the
            // default setting), then git will automatically be translating line
            // feeds to that of the operating system when you check out or
            // commit files. Matching this behavior here will avoid warnings
            // when you commit these files to git.
            value = value.replace(/\r?\n/g, os.EOL);
          }
          fs.writeFileSync(file.actualFilename, value, { encoding });
        },

        get expected() {
          expectRunPhase('Output.expected');
          if (expected === undefined) {
            expected = fs.readFileSync(file.expectedFilename, encoding);
          }
          return expected;
        },

        check() {
          expectRunPhase('Output.check');
          assertSameCode(file.actual, file.expected);
        }
      }

      filenamesForTestCase[filename] = {
        output: file.actualFilename,
        expected: file.expectedFilename,
        isBinary: encoding !== 'utf8'
      }

      return file;
    }
  }

  return { run, filenames: allFilenames };

  function run() {
    phase = 'run-phase';

    if (!globalThis.test) {
      throw new Error('Can only run tests from within the mocha test runner')
    }
    // Invoke the mocha test function
    for (const { name, run } of testCases) {
      globalThis.test(name, run);
    }
  }

  function expectDefinitionPhase(methodName: string) {
    if (phase !== 'definition-phase') {
      throw new Error(`Method "${methodName}" can only be used during the definition phase`)
    }
  }

  function expectRunPhase(methodName: string) {
    if (phase !== 'run-phase') {
      throw new Error(`Method "${methodName}" can only be used during the run phase`)
    }
  }
}