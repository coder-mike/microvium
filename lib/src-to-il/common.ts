import { noCase } from 'no-case';
import { CompileError, unexpected } from '../utils';
import * as B from './supported-babel-types';

// Tells us where we are in the source file
export interface SourceCursor {
  filename: string;
  node: B.Node;
  endOfNode?: boolean; // For things like blocks, it helps to know if we're doing the epilog
}

// This is called before we investigate a node during analysis or IL output. It
// records the current AST node being compiled so that if subsequent errors are
// generated then we know where the error occurred
export function visitingNode(cur: SourceCursor, node: B.Node) {
  cur.node = node;
  cur.endOfNode = false;
}

export function compileError(cur: SourceCursor, message: string, node: B.Node = cur.node): never {
  if (!node.loc) return unexpected();
  throw new CompileError(`${
    message
  }\n      at ${cur.node.type} (${
    cur.filename
  }:${
    node.loc.start.line
  }:${
    node.loc.start.column
  })`);
}

export function isSourceCursor(cur: any): cur is SourceCursor {
  return typeof cur === 'object' && cur !== null && cur.filename && cur.node;
}

export function featureNotSupported(cur: SourceCursor, feature: string, node: B.Node = cur.node): never {
  return compileError(cur, 'Not supported: ' + feature, node);
}

export function compileErrorIfReachable(cur: SourceCursor, value: never): never {
  const v = value as any;
  const type = typeof v === 'object' && v !== null ? v.type : undefined;
  const message = type ? `Not supported: ${noCase(type)}` : 'Not supported';
  compileError(cur, message);
}

/**
 * An error resulting from the internal compiler code, not a user mistake
 */
export function internalCompileError(cur: SourceCursor, message: string): never {
  if (!cur.node.loc) return unexpected();
  throw new Error(`Internal compile error: ${
    message
  }\n      at ${cur.node.type} (${
    cur.filename
  }:${
    cur.node.loc.start.line
  }:${
    cur.node.loc.start.column
  })`);
}