import * as im from 'immutable';
const toSingleQuotes = require('to-single-quotes');

export const never: never = undefined as never;
export const todoSymbol = Symbol('To do');
export type Todo = typeof todoSymbol;

export function notImplemented(feature?: string): never {
  throw new Error(feature ? `Not implemented: ${feature}` : 'Not implemented');
}

export function handlerNotImplemented(): never {
  throw new Error('Internal compiler error: handler not implemented');
}

export function assertUnreachable(value: never): never {
  throw new Error('Internal compiler error (reached unexpected code path)');
}

export function unexpected(message?: string): never {
  throw new Error('Internal compiler error' + (message ? ': ' + message : ''));
}

export function reserved(message?: string): never {
  throw new Error('Internal compiler error: reserved path' + (message ? ': ' + message : ''));
}

export function assert(predicate: any, message?: string): void {
  if (!predicate) {
    throw new Error('Internal compiler error' + (message ? ': ' + message : ''));
  }
}

export function invalidOperation(message: string): never {
  throw new Error(`Unexpected compiler state: ${message}`);
}

export function notUndefined<T>(v: T | undefined): T {
  if (v === undefined) {
    throw new Error('Internal compiler error: Did not expect value to be undefined');
  }
  return v;
}

export function notNull<T>(v: T | null): T {
  if (v === null) {
    throw new Error('Internal compiler error: Did not expect value to be null');
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

// Like Object.entries or Map.entries, but sorts results by key (designed for stringification routines that need deterministic output)
export function entries<V>(o: im.Set<V>): V[];
export function entries<K, V>(o: im.Map<K, V>): [K, V][];
export function entries<K, V>(o: Map<K, V>): [K, V][];
export function entries<T>(o: { [s: string]: T }): [string, T][];
export function entries(o: any): any {
  assert(o !== null && typeof o === 'object');
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