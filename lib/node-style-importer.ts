import Microvium, { ImportHook, ModuleObject, ModuleSpecifier, ModuleSource } from "../lib";
import { stringifyIdentifier, hardAssert } from "./utils";
import resolve from 'resolve';
import minimatch from 'minimatch';
import path from 'path';
import fs from 'fs';
import { builtinModules } from 'module';

export interface ModuleOptions extends resolve.SyncOpts {
  /**
   * The "project" directory -- where to resolve initial specifiers from. This
   * is used as the basedir for core module specifiers, and for specifiers for
   * the root module (modules imported directly, rather than as nested
   * dependencies of other modules). Nested dependencies always use a basedir
   * corresponding to the location of the dependency.
   */
  basedir?: string;

  /**
   * Core modules are those that can be referenced from anywhere with the same
   * specifier, like node's 'fs' module which is not loaded as a relative path.
   *
   * This mapping either produces an object (e.g. if the core module is
   * implemented by the host directly), or it produces another specifier that
   * identifies the core module (e.g. a path specifier). If a specifier is
   * provided, it is resolved relative to the basedir.
   */
  coreModules?: { [specifier: string]: ModuleObject | ModuleSpecifier };

  /**
   * - 'none': no access to file system (only specified core modules will be available)
   * - 'sub-dir-only': only files that a subdirectory of the initial basedir will be accessible.
   * - 'unrestricted': whole file system is eligible for import
   *
   * Defaults to 'subdir-only'
   */
  fileSystemAccess?: 'none' | 'subdir-only' | 'unrestricted';

  /**
   * Allow access to node core modules such as 'http' or 'fs'
   */
  allowNodeCoreModules?: boolean;

  /** Glob patterns consumed by minimatch library to specify files eligible to
   * be imported. Only files listed here can be imported. Defaults to match all
   * files. */
  includes?: string[];

  /** Glob patterns consumed by minimatch library to specify files not eligible
   * to be imported. Only files listed here can be imported. Files that are both
   * included and excluded are excluded. Defaults to match no files. */
  excludes?: string[];
}

/**
 * Create a node-style module importer for the given VM and options.
 *
 * The term "node-style" here refers to the fact that the importer primarily
 * works around filenames. Module caching is done on the full path
 */
export function nodeStyleImporter(vm: Microvium, options: ModuleOptions = {}): ImportHook {

  type FullModulePath = string;

  options = {
    extensions: ['.mvm.js', '.js', '.json'],
    ...options
  }
  const coreModules = options.coreModules || {};
  const rootDir = options.basedir === undefined ? process.cwd() : options.basedir;
  const fileSystemAccess = options.fileSystemAccess || 'subdir-only';
  const moduleCache = new Map<FullModulePath, ModuleSource>();

  const rootImporter = makeNestedImporter(rootDir);
  return rootImporter;

  // An importer that works relative to a different basedir (e.g. for a nested dependency)
  function makeNestedImporter(basedir: string): ImportHook {
    return (specifier: ModuleSpecifier): ModuleObject | undefined => {
      if (specifier in coreModules) {
        const coreModule = coreModules[specifier];
        // The value can be a specifier for the core module
        if (typeof coreModule === 'string') {
          return rootImporter(coreModule)
        }
        hardAssert(typeof coreModule === 'object' && coreModule !== null);
        return coreModule;
      }

      // If it's not in the core module list and we can't access the file
      // system, then we can't import the module
      if (fileSystemAccess === 'none') {
        throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
      }

      // References to files start with `/`, `./` or `../`
      // https://nodejs.org/api/modules.html#modules_file_modules
      const isFilePath = /^((\/)|(\.\/)|(\.\.\/))/.test(specifier);

      const resolved = resolve.sync(specifier, {
        ...options,
        basedir
      });

      const isNodeCoreModule = builtinModules.includes(resolved);

      if (isNodeCoreModule) {
        if (options.allowNodeCoreModules) {
          return require(resolved)
        } else {
          throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
        }
      }

      // If it didn't resolve to a file path, and we've already checked
      // specified core modules and node core modules, then it's not valid
      if (!isFilePath) {
        throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
      }

      const fullModulePath: FullModulePath = resolved;

      const relativePath = path.relative(rootDir, fullModulePath);

      if (options.fileSystemAccess === 'subdir-only') {
        if (path.posix.normalize(relativePath).startsWith('../')) {
          throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
        }
      }

      if (options.includes) {
        const isIncluded = options.includes.some(include => minimatch(relativePath, include));
        if (!isIncluded) {
          throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
        }
      }

      if (options.excludes) {
        const isIncluded = options.excludes.some(exclude => minimatch(relativePath, exclude));
        if (!isIncluded) {
          throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
        }
      }

      const fileExtension = path.extname(fullModulePath);
      if (fileExtension === '.js') {
        let source: ModuleSource;
        if (moduleCache.has(fullModulePath)) {
          source = moduleCache.get(fullModulePath)!;
        } else {
          const moduleDir = path.dirname(fullModulePath);
          const sourceText = fs.readFileSync(fullModulePath, 'utf8');
          const debugFilename = fullModulePath;
          const importDependency = makeNestedImporter(moduleDir);
          source = { sourceText, debugFilename, importDependency };
          moduleCache.set(fullModulePath, source);
        }
        const module = vm.evaluateModule(source);
        return module;
      } else {
        // Other resources, e.g. JSON
        return require(fullModulePath);
      }
    }
  }
}
