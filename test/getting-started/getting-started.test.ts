import { assert } from "chai";
import fs from 'fs-extra';
import * as microvium from '../../lib';
import _ from 'lodash';
import path from 'path';
import shelljs from 'shelljs';
import { writeTextFile } from "../../lib/utils";

const artifactDir = './test/getting-started/code';

suite('getting-started', function () {
  // Extract the source texts from the getting-started guide
  const host1Text = fs.readFileSync('./doc/getting-started.md', 'utf8');
  let matches = (host1Text as any)
    .matchAll(/<!-- Script (.*?) -->\r?\n```\w+\r?\n(.*?)\r?\n```/gs) as string[][];
  matches = [...matches];
  const gettingStartedMDScripts = _.fromPairs([...matches].map(([, id, scriptText]) => [id, scriptText]));

  fs.mkdirpSync(artifactDir);
  for (const [id, scriptText] of Object.entries(gettingStartedMDScripts)) {
    writeTextFile(path.join(artifactDir, id), scriptText);
  }

  let logOutput: any[] = [];

  let suiteFailed = false;
  this.afterEach(function() {
    if (this.currentTest && this.currentTest.isFailed()) {
      suiteFailed = true;
    }
  })
  // The guide has steps that depend on the previous, so we skip the remainder of the suite on the first failure
  this.beforeEach(function() {
    if (suiteFailed) {
      this.skip();
    }
  })

  const evalHostScript = (scriptText: string) => {
    logOutput = [];
    const dummyRequire = (specifier: string) => {
      assert.deepEqual(specifier, 'microvium');
      return microvium;
    };
    const realConsoleLog = console.log;
    const tempCwd = process.cwd();
    console.log = (arg: string) => logOutput.push(arg);
    process.chdir(artifactDir);
    try {
      eval(`(function (require) { ${scriptText}\n })`)(dummyRequire);
    } finally {
      process.chdir(tempCwd);
      console.log = realConsoleLog;
    }
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

  test('4.restoring-a-snapshot.js', () => {
    logOutput = [];
    evalHostScript(gettingStartedMDScripts['4.restoring-a-snapshot.js']);
    assert.deepEqual(logOutput, ['Hello, World!']);
  });

  test('5.restoring-a-snapshot-in-c.c', function() {
    // This test case actually compiles the C code in the getting-started.md
    // guide, so it takes a while
    this.timeout(20_000);

    const buildDir = path.resolve(artifactDir, 'build');

    // The guide says to copy the source files into the project dir, so to be
    // completely fair, I'll do that here as well, so the `code` dir becomes a
    // self-contained example without any external dependencies. This also means
    // that users can refer to the artifact directory as a self-contained
    // example.
    fs.mkdirpSync(path.resolve(artifactDir, 'microvium'));
    fs.mkdirpSync(buildDir);
    fs.copyFileSync('./dist-c/microvium.c', path.resolve(artifactDir, 'microvium/microvium.c'));
    fs.copyFileSync('./dist-c/microvium.h', path.resolve(artifactDir, 'microvium/microvium.h'));
    fs.copyFileSync('./dist-c/microvium_port_example.h', path.resolve(artifactDir, 'microvium_port.h'));
    fs.copyFileSync('./test/getting-started/CMakeLists.txt', path.resolve(artifactDir, 'CMakeLists.txt'));

    const originalDir = process.cwd();
    process.chdir(buildDir);
    try {
      let result = shelljs.exec(`cmake .. && cmake --build .`, { silent: true });
      assert.deepEqual(result.stderr, '');
      process.chdir("..");
      result = shelljs.exec('"./build/Debug/restoring-a-snapshot-in-c.exe"', { silent: true });
      assert.deepEqual(result.stderr, '');
      assert.deepEqual(result.stdout.trim(), 'Hello, World!');
    } finally {
      process.chdir(originalDir);
    }
  });
});
