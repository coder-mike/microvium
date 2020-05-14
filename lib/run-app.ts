import Microvium from '../lib';
import * as fs from 'fs-extra';
import colors from 'colors';

export interface CLIArgs {
  eval?: string;
  input: string[];
  noSnapshot?: boolean;
  snapshotFilename?: string;
}

export function runApp(args: CLIArgs, silent?: boolean, printHelp?: () => void) {
  const vm = Microvium.create();
  const vmGlobal = vm.globalThis;
  const vmConsole = vmGlobal.console = vm.newObject();
  vmConsole.log = vm.importHostFunction(0xFFFE);
  vmGlobal.vmExport = vm.exportValue;

  if (args.eval) {
    // TODO: support nested import
    vm.evaluateModule({ sourceText: args.eval });
  }

  if (args.input.length > 0) {
    for (const inputFilename of args.input) {
      const inputText = fs.readFileSync(inputFilename, 'utf-8')
      // TODO: support nested import
      vm.evaluateModule({ sourceText: inputText, debugFilename: inputFilename });
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
  } else if (args.snapshotFilename) {
    !silent && console.log(colors.yellow('Cannot use `--no-snapshot` option with `--snapshot`'));
    printHelp && printHelp();
  }
}