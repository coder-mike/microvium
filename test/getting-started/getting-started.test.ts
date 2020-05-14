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

  const evalHostScript = (scriptText: string) => {
    logOutput = [];
    const dummyRequire = (specifier: string) => {
      assert.deepEqual(specifier, 'microvium');
      return microvium;
    };
    const dummyConsole = {
      log: (arg: string) => logOutput.push(arg)
    }
    eval(`(function (require, console) { ${scriptText}\n })`)(dummyRequire, dummyConsole);
  }

  const runMicroviumCLI = (commandArgs: string) => {
    const result = shelljs.exec(`node ../../../dist/cli.js ${commandArgs}`, {
      async: false,
      cwd: artifactDir,
      silent: true,
    });
    if (result.stderr.trim()) {
      console.error(result.stderr);
    }
    return result;
  };

  test('1.hello-world.mvms', () => {
    // The first example executes on the CLI. I'm suppressing the snapshot
    // output here just because the filename clashes with the output in the 3rd
    // test case.
    const result = runMicroviumCLI('1.hello-world.mvms --no-snapshot');
    assert.deepEqual(result.stdout.trim(), 'Hello, World!');
    assert.deepEqual(result.stderr.trim(), '');
  });

  test('2.with-custom-host.js', () => {
    evalHostScript(gettingStartedMDScripts['2.with-custom-host.js']);
    assert.deepEqual(logOutput, ['Hello, World!']);
  });

  test('3.making-a-snapshot.mvms', () => {
    const result = runMicroviumCLI('3.making-a-snapshot.mvms');
    assert.deepEqual(result.stdout.trim(), '');
    assert.deepEqual(result.stderr.trim(), '');
  });
});
