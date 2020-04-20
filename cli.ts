#!/usr/bin/env node

// import yargs from 'yargs';
import { ArgumentParser } from 'argparse';
import { microvium } from './lib';
import * as fs from 'fs-extra';
import colors from 'colors';

const packageJSON = require('../package.json');

// const args = yargs
//   .scriptName('microvium')
//   .alias('v', 'version')
//   .command(['run', '$0'], 'Run a script file and generate snapshot', yargs => {
//     yargs.positional('input', {
//       describe: 'Script filename',
//       type: 'string'
//     })
//   }, run)
//   .command('eval', 'Evaluate script text and generate snapshot', yargs => {
//     yargs.positional('input', {
//       describe: 'Script text',
//       type: 'string'
//     })
//   }, eval_)
//   .example('microvium script.js', 'Run script.js and generate snapshot')
//   .example('microvium eval "script"', 'Run the script text and generate snapshot')
//   .strict()
//   .help()
//   .parse();

const argParse = new ArgumentParser({
  version: packageJSON.version,
  addHelp: true,
  prog: 'mvm',
  description: 'microvium - A compact, embeddable scripting engine for microcontrollers for executing small scripts written in a subset of JavaScript.'
});

argParse.addArgument(
  [ '-e', '--eval' ],
  {
    metavar: '"script"',
    dest: 'eval',
    action: 'store',
    help: 'Evaluate the given script text and output snapshot',
  },
);

argParse.addArgument(
  [ '-s', '--snapshot' ],
  {
    metavar: 'FILENAME',
    dest: 'snapshotFilename',
    action: 'store',
    help: 'Snapshot filename to use for output',
  },
);

argParse.addArgument(
  [ '--no-snapshot' ],
  {
    action: 'storeTrue',
    dest: 'noSnapshot',
    help: 'Do not output a snapshot file',
  },
);

argParse.addArgument(
  [ 'input' ],
  {
    nargs: '*',
    help: 'Input file to run',
  },
);

const args = argParse.parseArgs();

const vm = microvium.create();

// vm.global.console = vm.newObject(); // TODO(feature)
vm.global.log = vm.importHostFunction(0xFFFE) // TODO(feature)
vm.global.vmExport = vm.exportValue;

if (args.eval) {
  vm.importSourceText(args.eval);
}

if (args.input.length > 0) {
  for (const inputFilename of args.input) {
    const inputText = fs.readFileSync(inputFilename, 'utf-8')
    vm.importSourceText(inputText, inputFilename);
  }
}

if (!args.eval && args.input.length === 0) {
  argParse.printHelp();
}

// Specified in inverse because the default will be to make a snapshot
const makeSnapshot = !args.noSnapshot;
if (makeSnapshot) {
  const snapshotFilename = args.snapshotFilename || "snapshot.mvm-bc";
  const snapshot = vm.createSnapshot();
  fs.writeFileSync(snapshotFilename, snapshot.data);
} else if (args.snapshotFilename) {
  console.log(colors.yellow('Cannot use `--no-snapshot` option with `--snapshot`'));
  argParse.printHelp();
}