import { FetchDependency, ModuleObject, ModuleSpecifier, ModuleSource } from "../lib";
import { stringifyIdentifier, assert } from "./utils";
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

export function fetchEntryModule(specifier: ModuleSpecifier, options: ModuleOptions = {}): ModuleSource {
  const fetcher = makeFetcher(options);
  const module = fetcher(specifier);
  if (module && 'source' in module) {
    return module.source;
  } else {
    throw new Error(`Module not found: ${stringifyIdentifier(specifier)}`);
  }
}

export function makeFetcher(options: ModuleOptions = {}): FetchDependency {
  options = {
    extensions: ['.mvms'],
    ...options
  }
  const coreModules = options.coreModules || {};
  const rootDir = options.basedir === undefined ? process.cwd() : options.basedir;
  const accessFromFileSystem = options.accessFromFileSystem || 'none';
  // Cache of microvium modules (does not include modules provided by the host's
  // `require` since these are already cached)
  const moduleCache = new Map<string, ModuleSource>();

  const fetchRootDependency = makeFetchDependency(rootDir);
  return fetchRootDependency;

  function makeFetchDependency(basedir: string): FetchDependency {
    return (specifier: ModuleSpecifier): { source: ModuleSource } | { module: ModuleObject } | undefined | false => {
      if (specifier in coreModules) {
        const coreModule = coreModules[specifier];
        // The value can be a specifier for the core module
        if (typeof coreModule === 'string') {
          return fetchRootDependency(coreModule)
        }
        assert(typeof coreModule === 'object' && coreModule !== null);
        return { module: coreModule };
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
            module: require(resolved)
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

      if (options.accessFromFileSystem === 'subdir-only') {
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

      const fileExtension = path.extname(resolved);
      if (fileExtension === '.mvms') {
        if (moduleCache.has(resolved)) {
          return { source: moduleCache.get(resolved)! };
        }
        const moduleDir = path.dirname(resolved);
        const sourceText = fs.readFileSync(resolved, 'utf8');
        const debugFilename = resolved;
        const fetchDependency = makeFetchDependency(moduleDir);
        const source: ModuleSource = { sourceText, debugFilename, fetchDependency };
        moduleCache.set(resolved, source);
        return { source };
      } else {
        return { module: require(resolved) };
      }
    }
  }
}
