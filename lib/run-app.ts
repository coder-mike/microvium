import Microvium, { defaultHostEnvironment, HostImportTable, MicroviumCreateOpts } from '../lib';
import * as fs from 'fs-extra';
import * as path from 'path';
import colors from 'colors';
import { nodeStyleImporter } from './node-style-importer';
import { importPodValueRecursive, unexpected } from './utils';
import { decodeSnapshot } from './decode-snapshot';
import inquirer from 'inquirer';

export interface CLIArgs {
  eval?: string;
  input: string[];
  noSnapshot?: boolean;
  snapshotFilename?: string;
  debug?: true;
  mapFile?: string;
  generateLib?: boolean;
  outputBytes?: boolean;
}

export const delay = (ms: number) => new Promise(resolve => setTimeout(resolve, ms));

export async function runApp(args: CLIArgs, silent?: boolean, printHelp?: () => void) {
  const opts: MicroviumCreateOpts = {};
  let didSomething = false;
  let usedVM = false;
  // console.dir(args);

  if (args.debug) {
    // TODO(low): How does node.js decide the debug port?
    opts.debugConfiguration = { port: 8080 };
  }

  const importTable: HostImportTable = { ...defaultHostEnvironment };
  const vm = Microvium.create(importTable, opts);

  const vmGlobal = vm.globalThis;
  const vmConsole = vmGlobal.console = vm.newObject();
  vmConsole.log = (...args: any[]) => console.log(...args);
  vmGlobal.vmImport = vm.vmImport;
  vmGlobal.vmExport = vm.vmExport;
  vmGlobal.JSON = vm.newObject();
  vmGlobal.JSON.parse = jsonParse(vm);

  const importDependency = nodeStyleImporter(vm, {
    fileSystemAccess: 'unrestricted',
    allowNodeCoreModules: true
  });

  if (args.generateLib) {
    await runGenerator();
    didSomething = true;
  }

  if (args.eval) {
    vm.evaluateModule({ sourceText: args.eval, importDependency });
    didSomething = true;
    usedVM = true;
  }

  if (args.input.length > 0) {
    for (const inputFilename of args.input) {
      const inputText = fs.readFileSync(inputFilename, 'utf-8');
      const importDependency = nodeStyleImporter(vm, {
        fileSystemAccess: 'unrestricted',
        allowNodeCoreModules: true,
        basedir: path.dirname(inputFilename)
      });
      vm.evaluateModule({ sourceText: inputText, debugFilename: inputFilename, importDependency });
      didSomething = true;
      usedVM = true;
    }
  }

  if (!didSomething) {
    printHelp && printHelp();
    return;
  }

  // The default is be make a snapshot if there are input files (if the VM was used)
  const makeSnapshot = usedVM && !args.noSnapshot
  if (makeSnapshot) {
    let snapshotFilename = args.snapshotFilename;
    if (!snapshotFilename) {
      if (args.input.length > 0) {
        const fn = args.input[0];
        if (fn.endsWith('.mvm.js')) snapshotFilename = fn.slice(0, -7) + '.mvm-bc';
        else snapshotFilename = changeExtension(args.input[0], '.mvm-bc');
      } else {
        snapshotFilename = "script.mvm-bc";
      }
    };
    const snapshot = vm.createSnapshot();
    fs.writeFileSync(snapshotFilename, snapshot.data);
    console.log(`Output generated: ${snapshotFilename}`);
    console.log(`${snapshot.data.length} bytes`);
    if (args.mapFile) {
      fs.writeFileSync(args.mapFile, decodeSnapshot(snapshot).disassembly);
    }
    if (args.outputBytes) {
      console.log(`\nBytecode bytes:\n{${[...snapshot.data].map(b => `0x${b.toString(16)}`).join(',')}}`)
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

async function runGenerator() {
  let portFileContents: string;
  try {

    console.log("\nThe following will create the Microvium C library in './microvium/'.");
    const { continue_ } = await inquirer.prompt([{
      type: 'confirm',
      name: 'continue_',
      message: 'Do you want to continue?'
    }]);

    if (!continue_) {
      console.log('Code generation cancelled\n')
      return;
    }

    // Note: the artificial delays make it easier for a user to "follow along"
    // with what the generator is doing.

    const portFileDestName = './microvium/microvium_port.h';
    const filesToCopy = [{
      source: 'dist-c/microvium.c',
      dest: './microvium/microvium.c',
      description: 'The Microvium engine',
    }, {
      source: 'dist-c/microvium.h',
      dest: './microvium/microvium.h',
      description: 'Header file to #include',
    }, {
      source: 'dist-c/microvium_port_example.h',
      dest: portFileDestName,
      description: 'Port file to configure',
    }];
    fs.ensureDirSync('microvium');
    if (filesToCopy.some(f => fs.existsSync(f.dest))) {
      console.log(colors.red(`\n${colors.bold('WARNING')}: This will overwrite existing files in ${colors.white(colors.bold('./microvium/'))} directory`))
      const { overwrite } = await inquirer.prompt([{
        type: 'confirm',
        name: 'overwrite',
        message: `Continue?`,
        default: true
      }]);
      if (!overwrite) {
        console.log('Code generation cancelled\n')
        return;
      }
    }

    console.log('\n  Creating files...');
    await delay(500);

    const maxDestFilenameLength = Math.max(...filesToCopy.map(f => f.dest.length));

    for (const { source, dest, description } of filesToCopy) {
      await copyFile(source, dest);
      console.log(`    ${colors.green(dest.padEnd(maxDestFilenameLength, ' '))}   ${colors.white(description)}`);
      await delay(200);
    }
    console.log('  Done');
    await delay(500);

    console.log(`\n${colors.bold('microvium_port.h')} needs to be configured for your target architecture.`);
    const { customize } = await inquirer.prompt([{
      type: 'list',
      name: 'customize',
      message: 'Configure now?',
      choices: [{
        name: "Yes (recommended)",
        short: 'Yes',
        value: true
      }, {
        name: "No, I'll do it myself",
        short: 'Later',
        value: false
      }]
    }]);

    if (!customize) {
      console.log('Ok, run this wizard again if you change your mind.')
      console.log('The port file is ./microvium/microvium_port.h')
      console.log('See https://microvium.com/getting-started for more info.')
      return;
    }

    console.log(`\n${colors.yellow('Any of the following choices can be modified later in')} ${colors.bold('microvium_port.h')}`)
    console.log('Just press enter on any question to accept the default (conservative) choice.')
    await delay(1000);
    console.log('');

    const setupQuestions: inquirer.QuestionCollection = [{
      type: 'list',
      name: 'pointerSize',
      message: 'Architecture `void*` pointer size',
      choices: [
        '8-bit',
        '16-bit',
        '32-bit',
        '64-bit',
      ],
      default: '32-bit'
    }, {
      type: 'list',
      message: 'What should happen when the VM encounters an error?',
      name: 'errorBehavior',
      choices: [{
        name: 'Endless loop to trigger WDT: `while (1) {}`',
        value: 'endless-loop',
        short: 'Endless loop'
      }, {
        name: 'Use C stdlib to exit: `assert(false), exit(1)`',
        value: 'assert-and-exit',
        short: 'Assert & exit'
      }, {
        name: "I'll Implement my own `mvmFatalError` function somewhere",
        value: 'external-error',
        short: 'Call mvmFatalError'
      }],
      default: 'assert-and-exit'
    }, {
      type: 'list',
      name: 'nativeLongPointer',
      message: 'Can the bytecode be addressed by a `const void*` pointer?',
      choices: [{
        name: 'Yes (more efficient)',
        value: true,
        short: 'Yes'
      },{
        name: 'No (more portable)',
        value: false,
        short: 'No'
      }],
      default: (answers: any) => answers.pointerSize === '32-bit' || answers.pointerSize === '64-bit'
    }, {
      type: 'list',
      name: 'supportFloat',
      message: 'Enable 64-bit float support?',
      choices: [{
        name: 'Yes (recommended)',
        value: true,
        short: 'Yes'
      },{
        name: 'No (smaller ROM footprint)',
        value: false,
        short: 'No'
      }],
      default: true
    }, {
      type: 'list',
      name: 'overflowChecks',
      message: 'Enable integer overflow checks?',
      choices: [{
        name: 'Yes (recommended)',
        value: true,
        short: 'Yes'
      },{
        name: 'No (smaller ROM footprint)',
        value: false,
        short: 'No'
      }],
      default: true
    }, {
      type: 'confirm',
      name: 'debugAPI',
      message: 'Enable debug API',
      default: true
    }, {
      type: 'number',
      name: 'stackSize',
      message: 'VM Stack size (bytes)',
      default: 256
    }, {
      type: 'number',
      name: 'maxHeapSize',
      message: 'VM Max Heap Size (bytes)',
      default: 1024
    },];
    const answers = await inquirer.prompt(setupQuestions);

    portFileContents = fs.readFileSync('./microvium/microvium_port.h', 'utf8');
    define('MVM_STACK_SIZE', answers.stackSize);
    define('MVM_MAX_HEAP_SIZE', answers.maxHeapSize);
    define('MVM_NATIVE_POINTER_IS_16_BIT', answers.pointerSize === '16-bit' ? 1 : 0);
    define('MVM_SUPPORT_FLOAT', answers.supportFloat ? 1 : 0);
    define('MVM_PORT_INT32_OVERFLOW_CHECKS', answers.overflowChecks ? 1 : 0);
    define('MVM_SAFE_MODE', 0);
    define('MVM_DONT_TRUST_BYTECODE', 0);
    if (answers.nativeLongPointer) {
      define('MVM_LONG_PTR_TYPE', 'void*');
      define('MVM_LONG_PTR_NEW(p)', '((MVM_LONG_PTR_TYPE)p)');
      define('MVM_LONG_PTR_TRUNCATE(p)', '((void*)p)');
      define('MVM_LONG_PTR_ADD(p, s)', '((void*)((uint8_t*)p + (intptr_t)s))');
      define('MVM_LONG_PTR_SUB(p2, p1)', '((int16_t)((uint8_t*)p2 - (uint8_t*)p1))');
      define('MVM_READ_LONG_PTR_1(lpSource)', '(*((uint8_t*)lpSource))');
      define('MVM_READ_LONG_PTR_2(lpSource)', '(*((uint16_t*)lpSource))');
      define('MVM_READ_LONG_PTR_4(lpSource)', '(*((uint32_t*)lpSource))');
      define('MVM_LONG_MEM_CMP(p1, p2, size)', 'memcmp(p1, p2, size)');
      define('MVM_LONG_MEM_CPY(target, source, size)', 'memcpy(target, source, size)');
    } else {
      define('MVM_LONG_PTR_TYPE', 'int32_t');
      define('MVM_LONG_PTR_NEW(p)', '((MVM_LONG_PTR_TYPE)p)');
      define('MVM_LONG_PTR_TRUNCATE(p)', '((void*)p)');
      define('MVM_LONG_PTR_ADD(p, s)', 'p + (int32_t)s');
      define('MVM_LONG_PTR_SUB(p2, p1)', '((int16_t)(p2 - p1))');
      unableToDefine('MVM_READ_LONG_PTR_1(lpSource)');
      unableToDefine('MVM_READ_LONG_PTR_2(lpSource)');
      unableToDefine('MVM_READ_LONG_PTR_4(lpSource)');
      unableToDefine('MVM_LONG_MEM_CMP(p1, p2, size)');
      unableToDefine('MVM_LONG_MEM_CPY(target, source, size)');
    }
    define('MVM_FATAL_ERROR(vm, e)',
      answers.errorBehavior === 'endless-loop' ? 'mvm_endlessLoop()' :
      answers.errorBehavior === 'assert-and-exit' ? '(assert(false), exit(e))' :
      answers.errorBehavior === 'external-error' ? 'vmFatalError(vm, e)' :
      unexpected());
    if (answers.errorBehavior === 'endless-loop') {
      prependCode('static inline void mvm_endlessLoop() { while (1); }');
    }
    if (answers.errorBehavior === 'external-error') {
      prependCode('// To be implemented in the host\nvoid vmFatalError(mvm_VM* vm, mvm_TeError err);');
    }
    define('MVM_INCLUDE_SNAPSHOT_CAPABILITY', 0);
    define('MVM_INCLUDE_DEBUG_CAPABILITY', answers.debugAPI ? 1 : 0);


    console.log('');
    console.log('  Updating port file...');
    fs.writeFileSync(portFileDestName, portFileContents);
    console.log(`    ${colors.green(portFileDestName)}`)
    console.log(`  ${colors.bold('Done')}`);
    console.log('');
    console.log(`See ${colors.cyan('https://microvium.com/getting-started')} for more information`);
  } catch (e) {
    // console.log('There was a problem with the generator. Please contact Microvium support.')
    console.error(e.message);
  }

  async function copyFile(source: string, dest: string) {
    const contents = fs.readFileSync(path.join(__dirname, '../..', source), 'utf-8');
    fs.writeFileSync(dest, contents);
  }

  function define(name: string, value: any) {
    const pattern = new RegExp(`^(#define ${escapeRegExp(name)}) (.*)$`, 'gm');
    if (!portFileContents.match(pattern)) {
      console.error('  ' + colors.yellow(`WARNING: could not find #define named "${name}" in port file`))
    }
    portFileContents = portFileContents.replace(pattern, `$1 ${value}`);
  }

  function unableToDefine(name: string) {
    define(name, '<define me>');
    console.error('  ' + colors.yellow(`WARNING: unable to automatically #define "${name}" in port file. Please provide the implementation manually.`))
  }

  function prependCode(code: any) {
    const anchor = '#include <stdint.h>';
    portFileContents = portFileContents.replace(anchor, anchor + '\n\n' + code);
  }

  function escapeRegExp(s: string) {
    return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); // $& means the whole matched string
  }
}

// https://stackoverflow.com/a/57371333
function changeExtension(file: string, ext: string) {
  return path.join(path.dirname(file), path.basename(file, path.extname(file)) + ext)
}

export function jsonParse(vm: Microvium) {
  return function(text: string) {
    const value = JSON.parse(text);
    return importPodValueRecursive(vm, value);
  }
}