#!/usr/bin/env node

// import yargs from 'yargs';
import { ArgumentParser } from 'argparse';
import { runApp } from './lib/run-app';

const packageJSON = require('../package.json');

const argParse = new ArgumentParser({
  version: packageJSON.version,
  addHelp: true,
  prog: 'microvium',
  description: 'Microvium - A compact, embeddable scripting engine for microcontrollers for executing small scripts written in a subset of JavaScript.'
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
  [ '--debug' ],
  {
    action: 'storeTrue',
    dest: 'debug',
    help: 'Start in debug mode',
  },
);

argParse.addArgument(
  [ '--map-file' ],
  {
    metavar: 'FILENAME',
    action: 'store',
    dest: 'mapFile',
    help: 'Generate map file (human-readable disassembly of snapshot bytecode)',
  },
);

argParse.addArgument(
  [ '--generate-lib' ],
  {
    help: 'Interactively generate C runtime engine library',
    action: 'storeTrue',
    dest: 'generateLib',
  }
);

argParse.addArgument(
  [ 'input' ],
  {
    nargs: '*',
    help: 'Input file to run',
  },
);

const args = argParse.parseArgs();

runApp(args, false, () => argParse.printHelp());