import { FetchDependency, ModuleObject, ModuleSpecifier, ModuleSource } from "../lib";
import { stringifyIdentifier } from "./utils";
import resolve from 'resolve';
import minimatch from 'minimatch';
import path from 'path';
import fs from 'fs';
import { builtinModules } from 'module';

export interface DefaultFetchDependencyOptions extends resolve.SyncOpts {
  /**
   * Core modules are those that can be referenced from anywhere with the same
   * specifier, like node's 'fs' module which is not loaded as a relative path
   */
  coreModules?: { [specifier: string]: ModuleObject };

  /**
   * - 'none': no access to file system (only specified core modules will be available)
   * - 'sub-dir-only': only files that a subdirectory of the initial basedir will be accessible.
   * - 'unrestricted': whole file system is eligible for import
   *
   * Defaults to 'none'
   */
  accessFromFileSystem?: 'none' | 'subdir-only' | 'unrestricted';

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

export function defaultModuleMap(options: DefaultFetchDependencyOptions = {}): FetchDependency {
  options = {
    extensions: ['mvms'],
    ...options
  }
  const coreModules = options.coreModules || {};
  const rootDir = options.basedir === undefined ? process.cwd() : options.basedir;
  const accessFromFileSystem = options.accessFromFileSystem || 'none';
  // Cache of microvium modules (does not include modules provided by the host's
  // `require` since these are already cached)
  const moduleCache = new Map<string, ModuleSource>();

  return makeFetchDependency(rootDir);

  function makeFetchDependency(basedir: string): FetchDependency {
    return specifier => {
      if (specifier in coreModules) {
        return { exports: coreModules[specifier] };
      }

      // If it's not in the core module list and we can't access the file
      // system, then we can't import the module
      if (accessFromFileSystem === 'none') {
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
          return {
            exports: require(resolved)
          }
        } else {
          throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
        }
      }

      // If it didn't resolve to a file path, and we've already checked
      // specified core modules and node core modules, then it's not valid
      if (!isFilePath) {
        throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
      }

      const relativePath = path.relative(rootDir, resolved);

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

      const fileExtension = path.extname(resolved);
      if (fileExtension === 'mvms') {
        if (moduleCache.has(resolved)) {
          return moduleCache.get(resolved)!;
        }
        const moduleDir = path.dirname(resolved);
        const sourceText = fs.readFileSync(resolved, 'utf8');
        const debugFilename = resolved;
        const fetchDependency = makeFetchDependency(moduleDir);
        const moduleSource: ModuleSource = { sourceText, debugFilename, fetchDependency };
        moduleCache.set(resolved, moduleSource);
        return moduleSource;
      } else {
        return require(resolved);
      }
    }
  }
}
