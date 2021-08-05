import { analyzeScopes } from "../../lib/src-to-il/analyze-scopes";
import { stringifyAnalysis } from "../../lib/src-to-il/analyze-scopes/stringify-analysis";
import { parseToAst } from "../../lib/src-to-il/src-to-il";
import fs from 'fs-extra';
import path from 'path';
import { assertSameCode } from "../common";

const testInputDir = './test/scope-analysis/cases';
const testOutputDir = './test/scope-analysis/output';
const testCases = fs.readdirSync(testInputDir);

function analyze(filename: string) {
  const script = fs.readFileSync(filename, 'utf8');
  const file = parseToAst(filename, script);
  const analysis = analyzeScopes(file, filename);
  return stringifyAnalysis(analysis);
}

suite('scope-analysis', function () {
  for (const testCase of testCases) {
    const [, testName, modifier] = testCase.match(/^(.+?)(\.only|\.skip)?$/)!;

    const only = modifier === '.only';
    const skip = modifier === '.skip';

    const runner =
      skip ? test.skip :
      only ? test.only :
      test;

    runner(testName, () => {
      const testInputPath = path.join(testInputDir, testCase);
      const testOutputPath = path.join(testOutputDir, testName);
      fs.emptyDirSync(testOutputPath);

      const inputFilename = path.join(testInputPath, 'input.mvm.js');
      const analysis = analyze(inputFilename);
      const outputFilename = path.join(testOutputPath, 'output');
      fs.writeFileSync(outputFilename, analysis);

      const expectedFilename = path.join(testInputPath, 'expected');
      const expected = fs.readFileSync(expectedFilename, 'utf-8');

      assertSameCode(analysis, expected);
    })
  }
})