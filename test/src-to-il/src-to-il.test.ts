import { compileScript } from "../../lib/src-to-il";
import { stringifyUnit } from "../../lib/stringify-il";
import * as fs from 'fs';
import { srcToIlFilenames } from "./filenames";
import { assertSameCode } from "../common";
import { writeTextFile } from "../../lib/utils";

suite('src-to-il', function () {
  test('Empty unit', () => {
    const src = ``;
    const unit = compileScript('dummy.mvms', src, ['ext']);
    const expected = `
      unit ['dummy.mvms'];
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
    const filename = './test/src-to-il/input.mvms';
    const src = fs.readFileSync(filename, 'utf8');
    const unit = compileScript(filename, src, ['ext', 'require']);
    const stringifiedUnit = stringifyUnit(unit);
    writeTextFile(srcToIlFilenames.il.output, stringifiedUnit);
    const expected = fs.readFileSync(srcToIlFilenames.il.expected, 'utf8');
    assertSameCode(stringifiedUnit, expected);
  });
});