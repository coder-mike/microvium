import Microvium, { defaultHostEnvironment, MicroviumCreateOpts } from '../lib';
import * as fs from 'fs-extra';
import colors from 'colors';
import { nodeStyleImporter } from './node-style-importer';
import { writeTextFile } from './utils';
import { decodeSnapshot } from './decode-snapshot';

export interface CLIArgs {
  eval?: string;
  input: string[];
  noSnapshot?: boolean;
  snapshotFilename?: string;
  debug?: true;
  mapFile?: string;
}

export function runApp(args: CLIArgs, silent?: boolean, printHelp?: () => void) {
  const opts: MicroviumCreateOpts = {};
  if (args.debug) {
    // TODO(low): How does node.js decide the debug port?
    opts.debugConfiguration = { port: 8080 };
  }

  const vm = Microvium.create(defaultHostEnvironment, opts);

  const vmGlobal = vm.globalThis;
  const vmConsole = vmGlobal.console = vm.newObject();
  vmConsole.log = vm.importHostFunction(0xFFFE);
  vmGlobal.vmExport = vm.exportValue;

  const importDependency = nodeStyleImporter(vm, {
    fileSystemAccess: 'unrestricted'
  })

  if (args.eval) {
    vm.evaluateModule({ sourceText: args.eval, importDependency });
  }

  if (args.input.length > 0) {
    for (const inputFilename of args.input) {
      const inputText = fs.readFileSync(inputFilename, 'utf-8')
      vm.evaluateModule({ sourceText: inputText, debugFilename: inputFilename, importDependency });
    }
  }

  if (!args.eval && args.input.length === 0) {
    printHelp && printHelp();
  }

  // Specified in inverse because the default will be to make a snapshot
  const makeSnapshot = !args.noSnapshot;
  if (makeSnapshot) {
    const snapshotFilename = args.snapshotFilename || "snapshot.mvm-bc";
    const snapshot = vm.createSnapshot();
    fs.writeFileSync(snapshotFilename, snapshot.data);
    if (args.mapFile) {
      fs.writeFileSync(args.mapFile, decodeSnapshot(snapshot).disassembly);
    }
  } else {
    if (args.snapshotFilename) {
      !silent && console.log(colors.yellow('Cannot use `--no-snapshot` option with `--snapshot`'));
      printHelp && printHelp();
    }
    if (args.mapFile) {
      !silent && console.log(colors.yellow('Cannot use `--no-snapshot` option with `--map-file`'));
      printHelp && printHelp();
    }
  }
}