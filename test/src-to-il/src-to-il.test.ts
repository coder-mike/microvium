import { compileScript } from "../../lib/src-to-il/src-to-il";
import { stringifyUnit } from "../../lib/stringify-il";
import * as fs from 'fs';
import { srcToIlFilenames } from "./filenames";
import { assertSameCode } from "../common";
import { writeTextFile } from "../../lib/utils";

suite('src-to-il', function () {
  test('Empty unit', () => {
    const src = ``;
    const unit = compileScript('dummy.mvm.js', src, ['ext']);
    const expected = `
      unit ['dummy.mvm.js'];
      entry ['#entry'];
      var exports;
      function ['#entry']() {
        entry:
          LoadArg(index 0);
          StoreGlobal(name 'exports');
          Literal(lit undefined);
          Return();
      }`;
    assertSameCode(stringifyUnit(unit), expected);
  });

  test('General', () => {
    const filename = './test/src-to-il/input.mvm.js';
    const src = fs.readFileSync(filename, 'utf8');
    const unit = compileScript(filename, src, ['ext', 'require']);
    const stringifiedUnit = stringifyUnit(unit);
    writeTextFile(srcToIlFilenames.il.output, stringifiedUnit);
    const expected = fs.readFileSync(srcToIlFilenames.il.expected, 'utf8');
    assertSameCode(stringifiedUnit, expected);
  });
});