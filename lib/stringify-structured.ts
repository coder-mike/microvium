/*
 * A stringification function that's easy to inject spots of custom behavior
 * into, but defaults to a reasonable lightweight format (not JSON). Does not
 * attempt to be reversible (it's intended for diagnostics not serialization).
 *
 * This works essentially by breaking up the stringification into two parts:
 *
 *   1. Produce a "tree of strings" that represents the structure of the output,
 *      independent of newlines and indentation.
 *   2. Convert the tree to a string using indentation and wrapping rules
 *
 * The advantage of this approach is that there is less work to define custom
 * formatters which still behave nicely in the overall structure of the output.
 *
 * # Openers and Closers
 *
 * In JSON, an array of numbers might be represented by the string `[ 1, 2, 3 ]`
 * or by the multi-line string:
 *
 *     [
 *       1,
 *       2,
 *       3
 *     ]
 *
 * In both of these representations, this library calls `[` an "opener" and `]`
 * a "closer". These are treated differently to other children of the tree.
 *
 * If the formatter can fit the opener, the body, and the closer all on one
 * line, it will do so. Otherwise, it will break the result up into multiple
 * lines with an indented body.
 */

import { hardAssert, isNameString, stringifyStringLiteral } from "./utils";

export const structuredSymbol = Symbol('structured');

export type Structure =
  | PrimitiveStructure
  | ArrayLikeStructure
  | KeyValueLikeStructure

export type PrimitiveStructure = string;

export interface ArrayLikeStructure {
  open?: string;
  body: Structure[];
  joiner?: string;
  close?: string;
}

const isPrimitiveStructure = (s: Structure): s is PrimitiveStructure =>
  typeof s === 'string';

const isArrayLikeStructure = (s: Structure): s is ArrayLikeStructure =>
  typeof s !== 'string' && 'body' in s;

const isKeyValueLikeStructure = (s: Structure): s is KeyValueLikeStructure =>
  typeof s !== 'string' && 'key' in s;

export interface KeyValueLikeStructure {
  key: Structure;
  joiner?: string;
  value: Structure;
}


export type Formatter = (value: any) => Structure;

export interface StringifyStructuredOpts {
  baseIdent?: string;
  maxLineLength?: number;
}

export function stringifyStructured(value: any, opts?: StringifyStructuredOpts): string {
  const indent = opts?.baseIdent ?? '';
  const maxLineLength = opts?.maxLineLength ?? 0;

  const formatted = defaultStructure(value);
  const result = formattedToStr(formatted, indent, maxLineLength);

  return result;
}

/**
 * Creates a value that `stringifyStructured` will interpret as knowing about
 * its own structure, rather than using `defaultStructure`
 */
export function prestructured(structure: Structure | (() => Structure)) {
  return {
    [structuredSymbol]: typeof structure === 'function' ? structure : () => structure
  }
}

export const defaultStructure: Formatter = function (value: any): Structure {
  const alreadyVisited = new Set<any>();
  return inner(value);

  function inner(value: any): Structure {
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

        if (structuredSymbol in value) {
          return value[structuredSymbol]();
        }

        if (Array.isArray(value)) {
          return {
            open: '[',
            body: value.map(inner),
            joiner: ',',
            close: ']'
          };
        }

        if (value instanceof Set) {
          return {
            open: '<set> [',
            body: [...value].map(inner),
            joiner: ',',
            close: ']'
          }
        }

        if (value instanceof Map) {
          return {
            open: '<Map> {',
            body: [...value].map(([k, v]) =>({
              key: stringifyKey(k),
              joiner: ':',
              value: inner(v),
            })),
            joiner: ',',
            close: '}'
          }
        }

        return {
          open: '{',
          body: Object.entries(value).map(([k, v]) =>({
            key: stringifyKey(k),
            joiner: ':',
            value: inner(v),
          })),
          joiner: ',',
          close: '}'
        }
      }
      default: return '<unknown>';
    }
  }
}

export function formattedToStr(
  structure: Structure,
  indent = '',
  maxLineLength = 120,
  indentIncrement = '  '
): string {
  return inner(structure, indent).content;

  function inner(
    structure: Structure,
    indent: string,
  ): {
    content: string,
    multiline: boolean,
  } {
    const childIndent = indent + indentIncrement;

    if (isPrimitiveStructure(structure)) {
      if (structure.includes('\n')) {
        // Treat at text lines and re-indent, since it's probably not at the
        // right indent
        return inner(
          { body: structure.split(/\r?\n\s*/g) },
          childIndent
        )
      }
      return {
        multiline: false,
        content: structure
      };
    }

    // Structure is a key-value pair
    if (isKeyValueLikeStructure(structure)) {
      const joiner = structure.joiner ?? '';
      const key = inner(structure.key, childIndent);

      // Special case where the value of the key-value pair is array-like, since
      // we can have the opener on the same line as the key (e.g. in an object
      // property that has an array value, the array's opening `[` can occur on
      // the same line as the property key
      if (
        isArrayLikeStructure(structure.value) &&
        // Does the structure have an opener that we can collapse into the key line?
        structure.value.open &&
        // Does the key fit on the same line as the opener?
        indent.length + key.content.length + joiner.length + 1 + structure.value.open.length <= maxLineLength
      ) {
        return inner(
          {
            // Collapse the value's opener into the key
            key: `${structure.key}${joiner} ${structure.value.open}`,
            joiner: undefined, // Collapsed into the key
            value: {
              open: undefined, // Collapsed into the key
              body: structure.value.body,
              joiner: structure.value.joiner,
              close: structure.value.close
            }
          },
          indent
        )
      }

      const value = inner(structure.value, childIndent);
      const singleLineLength =
        indent.length +
        key.content.length + joiner.length + 1 +
        value.content.length;

      const anyPartsAreMultiline = key.multiline || value.multiline || joiner.includes('\n');
      const multiline = anyPartsAreMultiline || singleLineLength > maxLineLength;

      if (multiline) {
        return {
          multiline,
          content: `${key.content}${joiner}\n${childIndent}${value.content}`
        }
      } else {
        return {
          multiline,
          content: `${key.content}${joiner} ${value.content}`
        }
      }
    }

    hardAssert(isArrayLikeStructure(structure));

    const { open, body, close } = structure;
    const joiner = structure.joiner ?? '';

    const items = body.map(x => inner(x, childIndent));
    // If rendering as a single line, there will be a space after the opener and before the closer
    const singleLinePrefix = open ? open + ' ' : '';
    const singleLineSuffix = close ? close + ' ' : '';
    const singleLineLength =
      indent.length +
      singleLinePrefix.length +
      totalLength(items.map(p => p.content)) +
      joiner.length * (Math.max(0, body.length)) +
      singleLineSuffix.length;

    const anyPartsAreMultiline = items.some(item => item.multiline)
      || open?.includes('\n')
      || close?.includes('\n')
      || joiner?.includes('\n');

    const multiline = anyPartsAreMultiline || singleLineLength > maxLineLength;

    if (multiline) {
      let content = open ?? '';
      content += items.map(v => `\n${childIndent}${v.content}`).join(joiner)
      if (close) content += `\n${indent}${close}`;
      return { multiline, content };
    } else {
      const content = `${singleLinePrefix}${items.map(v => v.content).join(joiner + ' ')}${singleLineSuffix}`;
      return { multiline, content };
    }
  }

  function totalLength(ss: string[]) {
    return ss.reduce((a, s) => a + s.length, 0);
  }
}

export function stringifyKey(value: any): string {
  switch (typeof value) {
    case 'undefined': return '[undefined]';
    case 'function': return '[<function>]';
    case 'boolean': return `[${value ? 'true' : 'false'}]`;
    case 'symbol': return `[${value.toString()}]`;
    case 'number': return `[${value}]`;
    case 'bigint': return `[${value}]`;
    case 'string':
      return isNameString(value)
      ? value
      : stringifyStringLiteral(value);
    case 'object': {
      if (value === null) return 'null';
      return '[<object>]';
    }
    default:
      return '[<unknown>]'
  }
}