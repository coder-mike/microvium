import * as fs from 'fs';
import * as im from 'immutable';
import * as os from 'os';
import * as _ from 'lodash';
import { Microvium } from '../lib';

const toSingleQuotes = require('to-single-quotes');

export type Callback<T> = (v: T) => void;

export class MicroviumUsageError extends Error {
}

export class CompileError extends MicroviumUsageError {
}

export class MicroviumSyntaxError extends CompileError {
}

export class RuntimeError extends MicroviumUsageError {
}

export const never: never = undefined as never;
export const todoSymbol = Symbol('To do');
export type Todo = typeof todoSymbol;

export function throwError(message: string): never {
  // A good place to set a breakpoint
  throw new Error(message);
}

export function notImplemented(feature?: string): never {
  throwError(feature ? `Feature not implemented: ${feature}` : 'Feature not implemented');
}

export function handlerNotImplemented(): never {
  throwError('Internal compiler error: handler not implemented');
}

export function assertUnreachable(value: never): never {
  throwError('Internal compiler error (reached unexpected code path)');
}

export function unexpected(message?: string): never {
  throwError('Internal compiler error' + (message ? ': ' + message : ''));
}

export function reserved(message?: string): never {
  throwError('Internal compiler error: reserved path' + (message ? ': ' + message : ''));
}

export function hardAssert(predicate: any, message?: string): void {
  if (!predicate) {
    throwError('Internal compiler error' + (message ? ': ' + message : ''));
  }
}

export function invalidOperation(message: string): never {
  throwError(`Unexpected compiler state: ${message}`);
}

export function notUndefined<T>(v: T | undefined | null): T {
  if (v === undefined || v === null) {
    throwError('Internal compiler error: Did not expect value to be undefined');
  }
  return v;
}

export function notNull<T>(v: T | null): T {
  if (v === null) {
    throwError('Internal compiler error: Did not expect value to be null');
  }
  return v;
}

export function abstractFunctionCalled(name: string): never {
  unexpected(`Abstract method called: ${name}`);
}

export function uniqueName(base: string, nameTaken: (name: string) => boolean): string {
  if (!nameTaken(base)) {
    return base;
  }
  const endsInNumber = base.match(/^(.*?)(\d+)$/);
  let counter;
  if (endsInNumber) {
    let counterStr: string;
    [, base, counterStr] = endsInNumber;
    counter = parseInt(counterStr);
  } else {
    counter = 1;
  }
  let name = base + counter;
  while (nameTaken(name)) {
    name = base + (++counter);
  }
  return name;
}

/*
 * I caught myself using `uniqueName` but not adding the result to the set,
 * which is why I created this.
 */
export function uniqueNameInSet(base: string, set: Set<string>): string {
  const name = uniqueName(base, n => set.has(n));
  set.add(name);
  return name;
}

// Like Object.entries or Map.entries, but sorts results by key (designed for stringification routines that need deterministic output)
export function entries<V>(o: im.Set<V>): V[];
export function entries<K, V>(o: im.Map<K, V>): [K, V][];
export function entries<K, V>(o: Map<K, V>): [K, V][];
export function entries<T>(o: { [s: string]: T }): [string, T][];
export function entries<T>(o: { [s: number]: T }): [string, T][];
export function entries(o: any): any {
  hardAssert(o !== null && typeof o === 'object');
  if (im.Set.isSet(o)) {
    const values = [...o];
    values.sort();
    return values;
  } else if (im.Map.isMap(o)) {
    const values = [...o.entries()];
    values.sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0);
    return values;
  } else if (o instanceof Map) {
    const values = [...o.entries()];
    values.sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0);
    return values;
  } else {
    const values = Object.entries(o);
    values.sort((a, b) => a[0] < b[0] ? -1 : a[0] > b[0] ? 1 : 0);
    return values;
  }
}

export function entriesInOrder<V>(o: im.Set<V>): V[];
export function entriesInOrder<K, V>(o: im.Map<K, V>): [K, V][];
export function entriesInOrder<K, V>(o: Map<K, V>): [K, V][];
export function entriesInOrder<T>(o: { [s: string]: T }): [string, T][];
export function entriesInOrder<T>(o: { [s: number]: T }): [string, T][];
export function entriesInOrder(o: any): any {
  return _.sortBy(entries(o));
}

export function mapObject<V1, V2>(obj: { [s: string]: V1 }, f: (v: V1, k: string) => V2): { [s: string]: V2 } {
  return fromEntries(Object.entries(obj)
    .map(([k, v]) => [k, f(v, k)]))
}

export function mapMap<K, V1, V2>(src: Map<K, V1>, f: (v: V1, k: K) => V2): Map<K, V2> {
  return new Map<K, V2>(entries(src)
    .map(([k, v]) => [k, f(v, k)]))
}

export function fromEntries<V>(entries: [string, V][]) {
  const result: { [k: string]: V } = {};
  for (const [k, v] of entries) {
    result[k] = v;
  }
  return result;
}

export function todo(message: string): Todo {
  console.error('To do: ' + message);
  return todoSymbol;
}

export function stringifyIdentifier(key: string): string {
  if (isNameString(key)) {
    return key;
  } else {
    return `[${stringifyStringLiteral(key)}]`;
  }
}

export function stringifyStringLiteral(s: string): string {
  return toSingleQuotes(JSON.stringify(s))
}

export function isNameString(NameOperand: string): boolean {
  return /^[a-zA-Z_]+[a-zA-Z0-9_]*$/.test(NameOperand);
}

export function writeTextFile(filename: string, content: string) {
  fs.writeFileSync(filename, content.replace(/\r?\n/g, os.EOL))
}

/** An array of the given length with no holes in it */
export function arrayOfLength(len: number): undefined[] {
  const arr: undefined[] = [];
  for (let i = 0; i < len; i++)
    arr.push(undefined);
  return arr;
}

// Imports a host POD value into the VM
export function importPodValueRecursive(vm: Microvium, value: any) {
  if (typeof value === 'object') {
    if (Array.isArray(value)) {
      const arr = vm.newArray();
      for (let i = 0; i < value.length; i++) {
        arr[i] = importPodValueRecursive(vm, value[i]);
      }
      return arr;
    } else {
      const obj = vm.newObject();
      for (const k of Object.keys(value)) {
        obj[k] = importPodValueRecursive(vm, value[k]);
      }
      return obj;
    }
  } else {
    return value;
  }
}

const definedFormatSymbol = Symbol('definedFormat');

export function stringifyGeneric(value: any, indent: string = ''): string {
  const alreadyVisited = new Set<any>();
  return inner(value, indent);

  function inner(value: any, indent: string): string {
    const childIndent = indent + '  ';
    switch (typeof value) {
      case 'undefined': return 'undefined';
      case 'function': return '<function>';
      case 'boolean': return value ? 'true' : 'false';
      case 'symbol': return value.toString();
      case 'number': return value.toString();
      case 'bigint': return value.toString();
      case 'string': return stringifyStringLiteral(value);
      case 'object': {
        if (value === null) return 'null';
        if (alreadyVisited.has(value)) return '<circular>';
        alreadyVisited.add(value);

        if (definedFormatSymbol in value) {
          return value[definedFormatSymbol](indent);
        }

        if (Array.isArray(value)) {
          const items = value.map(v => inner(v, childIndent))
          if (totalItemsLength(items) < 80) {
            return `[${items.join(', ')}]`;
          } else {
            return `[${items.map(v => `\n${childIndent}${v}`).join(',')}\n${indent}]`;
          }
        }

        if (value instanceof Set) {
          const items = [...value].map(v => inner(v, childIndent))
          if (totalItemsLength(items) < 80) {
            return `<Set> [${items.join(', ')}]`;
          } else {
            return `<Set> [${items.map(v => `\n${childIndent}${v}`).join(',')}\n${indent}]`;
          }
        }

        if (value instanceof Map) {
          const entries = [...value].map(([k, v]) => [stringifyKey(k), inner(v, childIndent)])
          if (totalEntriesLength(entries) < 80) {
            return `<Map> { ${entries.map(([k, v]) => `${k} => ${v}`).join(', ')} }`;
          } else {
            return `<Map> {${entries.map(([k, v]) => `\n${childIndent}${k} => ${v}`).join(', ')}\n${indent}}`;
          }
        }

        const entries = Object.entries(value).map(([k, v]) => [stringifyKey(k), inner(v, childIndent)])
        if (totalEntriesLength(entries) < 80) {
          return `{ ${entries.map(([k, v]) => `${k}: ${v}`).join(', ')} }`;
        } else {
          return `{${entries.map(([k, v]) => `\n${childIndent}${k}: ${v}`).join(', ')}\n${indent}}`;
        }
      }
      default: return '<unknown';
    }
  }

  function stringifyKey(value: any): string {
    switch (typeof value) {
      default:
        return `[${inner(value, '')}]`
      case 'string':
        return isNameString(value)
          ? value
          : stringifyStringLiteral(value);
      case 'object': {
        if (value === null) return 'null';
        return '[<object>]';
      }
    }
  }

  function totalItemsLength(items: string[]) {
    return items.reduce((a, s) => a + s.length, 0);
  }

  function totalEntriesLength(entries: string[][]) {
    return entries.reduce((a, s) => a + s[0].length + s[1].length, 0);
  }
}

export function defineFormat(f: string | ((indent: string) => string)) {
  return {
    [definedFormatSymbol]: typeof f === 'function' ? f : () => f
  }
}