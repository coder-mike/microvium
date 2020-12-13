# Microvium Module API

At a glance, Microvium has the following API related to the module system (this documentation is abbreviated.

See also the full interface in [./lib.ts](../../lib.ts). <br>
See also my blog post about the design here: https://coder-mike.com/2020/05/microvium-modules/

```ts
interface Microvium {
  /** Create a new, empty Microvium virtual machine */
  static create(): Microvium;

  /**
   * Imports the given source text as a module.
   *
   * Returns the module namespace object for the imported module: an object
   * whose properties are the exports of the imported module.
   *
   * A call to `evaluateModule` with the exact same `ModuleSource` will return the
   * exact same `ModuleObject` (by reference equality; reentrant-safe).
   */
  evaluateModule(moduleSource: ModuleSource): ModuleObject;

  /** Writable access to global variables through a proxy object */
  readonly globalThis;
}
```

`ModuleSource` and `ModuleObject` are defined as follows:

```ts
/**
 * Represents the information needed to import a module from source text.
 */
interface ModuleSource {
  /** Microvium source text for the module */
  readonly sourceText: string;

  /** If specified, the debugFilename will appear in stack traces and facilitates
  * breakpoints in the source text. */
  readonly debugFilename?: string;

  /** If specified, this allows the module to have its own nested imports */
  readonly importDependency?: ImportHook;
}

type ImportHook = (specifier: ModuleSpecifier) => ModuleObject | undefined;

type ModuleSpecifier = string; // The string passed to `import`
```

## evaluateModule

```ts
evaluateModule(moduleSource: ModuleSource): ModuleObject;
```

This method takes an object representing the source text and returns an object whose properties are the exports of the imported module.

![evaluateModule.svg](../images/evaluateModule.svg)

### Examples

```ts
vm.evaluateModule({ sourceText: `print('Hello, World!')` });

const { x } = vm.evaluateModule({ sourceText: `export const x = 5;` });
```

## importDependency: ImportHook

This is a callback to the host, on a per-module basis, that must return a module object given a module specifier relative to the importing module. It should encapsulate all the actions required to resolve and load the requested module. It may in turn invoke `evaluateModule`, if the requested module should be loaded into the VM. The returned object is permitted but not required to be an object in the host.

![evaluateModule.svg](../images/ImportHook.svg)

Example: https://coder-mike.com/2020/05/microvium-modules#import-dependency

## Typical Use, with `nodeStyleImporter`

In typical use, the `ImportHook` will not be implemented by hand. The Microvium library offers a `nodeStyleImporter` which should work for most Microvium hosts implemented in node.js:

```ts
function nodeStyleImporter(vm, options): ImportHook;
```

And example usage is as follows:

```ts
import { Microvium, nodeStyleImporter } from 'microvium';

const moduleOptions: ModuleOptions = {
  // Allow the importer to access the file system
  fileSystemAccess: 'subdir-only',

  // Specify the root directory of the project, from which initial imports will be resolved
  basedir: 'my/project/directory',

  // A set of "core" modules: those which can be imported from any Microvium module with the exact same specifier.
  coreModules: {
    'a-core-module': './a-core-module.mvm.js', // Core module implemented VM source text
    'another-core-module': require('a-module-in-the-host') // Core module implemented by the host
  },

  // Allow Microvium modules to import `fs`, `http`, etc.
  allowNodeCoreModules: true,
};

const vm = Microvium.create();
const importer = nodeStyleImporter(vm, moduleOptions);
importer('./the-entry-module');
```

