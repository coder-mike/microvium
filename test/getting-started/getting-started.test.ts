import { assert } from "chai";
import fs from 'fs-extra';
import * as microvium from '../../lib';
import _ from 'lodash';
import path from 'path';

const artifactDir = './test/getting-started/artifacts';

suite('getting-started', function () {
  // Extract the source texts from the getting-started guide
  const host1Text = fs.readFileSync('./doc/getting-started.md', 'utf8');
  let matches = (host1Text as any)
    .matchAll(/<!-- Script (ID-\d+) -->\r?\n```\w+\r?\n(.*?)\r?\n```/gs) as string[][];
  matches = [...matches];
  const scripts = _.fromPairs([...matches].map(([, id, scriptText]) => [id, scriptText]));

  this.beforeAll(() => fs.emptyDirSync(artifactDir));

  test('ID-1: Hello World', () => {
    const script = scripts['ID-1'];
    fs.writeFileSync(path.join(artifactDir, 'ID-1.mvms'), script);

    const logArray: any[] = [];

    const dummyRequire = (specifier: string) => {
      assert.deepEqual(specifier, 'microvium');
      return microvium;
    };

    const dummyConsole = {
      log: (arg: string) => logArray.push(arg)
    }

    eval(`(function (require, console) { ${script} })`)(dummyRequire, dummyConsole);

    assert.deepEqual(logArray, ['Hello, World!']);
  });
});
