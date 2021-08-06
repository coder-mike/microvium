import { TestFilenames } from "./common";
import fs from 'fs-extra';
import path from 'path';
import assert from 'assert';

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

  const testInputDir = path.join(folder, '/cases');
  const testOutputDir = path.join(folder, '/output');
  const allFilenames: TestFilenames = {};
  const runHandlers = new Array<() => void>();

  const testCaseFolders = fs.readdirSync(testInputDir);
  for (const testCaseFolder of testCaseFolders) {
    const testName = testCaseFolder;
    const testCaseInputDir = path.join(testInputDir, testCaseFolder);
    const testCaseExpectedOutputDir = path.join(testInputDir, testCaseFolder, './expected');
    const testCaseActualOutputPath = path.join(testOutputDir, testCaseFolder);
    const filenamesForTestCase: TestFilenames = {};
    allFilenames[testName] = filenamesForTestCase;

    defineTest({ input, inputFilename, onRun, output, actualOutputFilename, expectedOutputFilename });

    runHandlers.push(() => fs.emptyDirSync(testCaseActualOutputPath));

    function onRun(handler: () => void) {
      expectDefinitionPhase('onRun');
      runHandlers.push(handler);
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
          assert.strictEqual(file.actual, file.expected);
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
    globalThis.test(() => {
      for (const handler of runHandlers) {
        handler();
      }
    });
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