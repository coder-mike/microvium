import { analyzeScopes } from "../../lib/src-to-il/analyze-scopes";
import { stringifyAnalysis } from "../../lib/src-to-il/analyze-scopes/stringify-analysis";
import { parseToAst } from "../../lib/src-to-il/src-to-il";
import fs from 'fs-extra';
import { testsInFolder } from "../file-based-tests";

export const tests = testsInFolder('./test/scope-analysis', test => {
  const inputFilename = test.inputFilename('input.mvm.js');
  const output = test.output('output', 'utf8');

  test.onRun(() => {
    const script = fs.readFileSync(inputFilename, 'utf8');
    const file = parseToAst(inputFilename, script);
    const analysis = analyzeScopes(file, inputFilename);
    output.actual = stringifyAnalysis(analysis);
    output.check();
  })
})