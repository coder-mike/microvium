import { assert } from "chai";
import fs from 'fs-extra';
import * as microvium from '../../lib';
import _ from 'lodash';
import path from 'path';
import shelljs from 'shelljs';
import { runApp } from "../../lib/run-app";

const artifactDir = './test/getting-started/artifacts';

suite('getting-started', function () {
  // Extract the source texts from the getting-started guide
  const host1Text = fs.readFileSync('./doc/getting-started.md', 'utf8');
  let matches = (host1Text as any)
    .matchAll(/<!-- Script (.*?) -->\r?\n```\w+\r?\n(.*?)\r?\n```/gs) as string[][];
  matches = [...matches];
  const gettingStartedMDScripts = _.fromPairs([...matches].map(([, id, scriptText]) => [id, scriptText]));

  fs.emptyDirSync(artifactDir);
  for (const [id, scriptText] of Object.entries(gettingStartedMDScripts)) {
    fs.writeFileSync(path.join(artifactDir, id), scriptText);
  }

  let logOutput: any[] = [];
  this.beforeEach(() => logOutput = []);

  const evalHostScript = (scriptText: string) => {
    const dummyRequire = (specifier: string) => {
      assert.deepEqual(specifier, 'microvium');
      return microvium;
    };
    const dummyConsole = {
      log: (arg: string) => logOutput.push(arg)
    }
    eval(`(function (require, console) { ${scriptText} })`)(dummyRequire, dummyConsole);
  }

  test('1.hello-world.mvms', () => {
    // The first example executes on the CLI
    const result = shelljs.exec(`node ../../../dist/cli.js 1.hello-world.mvms`, {
      async: false,
      cwd: artifactDir,
      silent: true,
    })

    assert.deepEqual(result.stdout.trim(), 'Hello, World!');
  });
});
