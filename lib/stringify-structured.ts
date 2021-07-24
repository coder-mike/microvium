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

import { isNameString, stringifyStringLiteral } from "./utils";

export const structuredSymbol = Symbol('structured');

export type Structured =
  | string
  | { open?: string, body: Structured[], joiner?: string, close?: string }

export type Formatter = (value: any) => Structured;

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
export function prestructured(structure: Structured | (() => Structured)) {
  return {
    [structuredSymbol]: typeof structure === 'function' ? structure : () => structure
  }
}

export const defaultStructure: Formatter = function (value: any): Structured {
  const alreadyVisited = new Set<any>();
  return inner(value);

  function inner(value: any): Structured {
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
              open: stringifyKey(k) + ':',
              body: [inner(v)],
            })),
            joiner: ',',
            close: '}'
          }
        }

        return {
          open: '{',
          body: Object.entries(value).map(([k, v]) =>({
            open: stringifyKey(k) + ':',
            body: [inner(v)],
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
  structured: Structured,
  indent = '',
  maxLineLength = 120,
  indentIncrement = '  '
): string {
  return inner(structured, indent).content;

  function inner(
    structured: Structured,
    indent: string,
  ): {
    content: string,
    multiline: boolean,
  } {
    if (typeof structured === 'string') {
      const content = structured;
      const multiline = structured.includes('\n');
      return { multiline, content };
    }

    const { open, body, close } = structured;
    const joiner = structured.joiner ?? '';

    const childIndent = indent + indentIncrement;
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

    const anyItemsAreMultiline = items.some(item => item.multiline);
    const multiline = anyItemsAreMultiline || singleLineLength > maxLineLength;

    if (multiline) {
      const content = `${open}${items.map(v => `\n${childIndent}${v.content}`).join(joiner)}\n${indent}${close}`;
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