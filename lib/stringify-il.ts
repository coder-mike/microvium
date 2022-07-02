import * as IL from './il';
import { blockTerminatingOpcodes } from './il-opcodes';
import { assertUnreachable, stringifyIdentifier, stringifyStringLiteral, notUndefined, unexpected, hardAssert, entries, entriesInOrder, invalidOperation } from './utils';
import _ from 'lodash';

export interface StringifyILOpts {
  showComments?: boolean;
  commentSourceLocations?: boolean;
}

export function stringifyUnit(unit: IL.Unit, opts: StringifyILOpts = {}): string {
  return `unit ${
    stringifyIdentifier(unit.sourceFilename)
  };\n\nentry ${
    stringifyIdentifier(unit.entryFunctionID)
  };\n\n${
    // Global variables
    unit.freeVariables.length
      ? unit.freeVariables.map(g => `external ${stringifyIdentifier(g)} from free-variable ${stringifyStringLiteral(g)};\n`).join('') + '\n'
      : ''
  }${
    // Imports
    Object.keys(unit.moduleImports).length > 0
      ? unit.moduleImports.map(({ variableName, specifier}) =>
          `external ${stringifyIdentifier(variableName)} from import ${stringifyStringLiteral(specifier)};\n`
        ).join('') + '\n'
      : ''
  }${
    // Module-level variables
    unit.moduleVariables.length
      ? unit.moduleVariables.map(g => `global ${stringifyIdentifier(g)};\n`).join('') + '\n'
      : ''
  }${
    // Functions
    [...Object.values(unit.functions)]
      .map(f => stringifyFunction(f, '', opts))
      .join('\n\n')
  }`
}

export function stringifyFunction(func: IL.Function, indent: string, opts: StringifyILOpts = {}): string {
  let blocks = func.blocks;

  return `${
    func.comments && opts.showComments !== false
      ? func.comments.map(c => `\n// ${c}`).join('')
      : ''
  }function ${stringifyIdentifier(func.id)}() {${
    blocksInOrder(blocks, func.entryBlockID)
      .map(b => stringifyBlock(b, indent + '  ', opts))
      .join('')
  }\n${indent}}`;
}

function blocksInOrder(blocks: IL.Function['blocks'], entryBlockID: string): IL.Block[] {
  if (!(entryBlockID in blocks)) {
    return invalidOperation('Malformed function');
  }
  const { [entryBlockID]: firstBlock, ...otherBlocks } = blocks;
  const result = [
    firstBlock,
    ..._.sortBy(Object.values(otherBlocks), b => {
      const m = b.id.match(/^block(\d+)$/);
      if (!m) return b.id;
      return parseInt(m[1]);
    })
  ]
  hardAssert(!result.some(b => !b));
  return result;
}

export function stringifyBlock(block: IL.Block, indent: string, opts: StringifyILOpts = {}): string {
  return `${
    stringifyComments(indent, block.comments, opts)
  }\n${indent}${block.id}:${
    block.operations
      .map(o => stringifyOperationLine(o, indent + '  ', opts))
      .join('')
  }`
}

export function stringifyComments(indent: string, comments: string[] | undefined, opts: StringifyILOpts = {}) {
  if (!comments || opts.showComments === false) {
    return '';
  }

  return comments
    .flatMap(c => c.split('\n'))
    .map(s => s.trim())
    .map(c => `\n${indent}// ${c}`)
    .join('');
}

export function stringifyOperationLine(operation: IL.Operation, indent: string, opts: StringifyILOpts = {}): string {
  const loc = operation.sourceLoc;
  let line = `${indent}${
    stringifyOperation(operation)
  };`
  if (loc && opts.commentSourceLocations) {
    line = line.padEnd(40, ' ')
    line += ` // ${loc.filename}:${loc.line}:${loc.column + 1}`
  }
  line = `${stringifyComments(indent, operation.comments, opts)}\n${line}`
  return line;
}

export function stringifyOperation(operation: IL.Operation): string {
  switch (operation.opcode) {
    case 'Return': return stringifyReturnOperation(operation);
    default: return stringifyGeneralOperation(operation);

  }
}

export function stringifyReturnOperation(operation: IL.ReturnOperation): string {
  if (operation.staticInfo?.returnUndefined) {
    return stringifyGeneralOperation(operation) + ' // return undefined'
  } else {
    return stringifyGeneralOperation(operation);
  }
}

export function stringifyGeneralOperation(operation: IL.Operation): string {
  return `${operation.opcode}(${
    operation.operands
      .map(stringifyOperand)
      .join(', ')
  })`
}

export function stringifyOperand(operand: IL.Operand): string {
  switch (operand.type) {
    case 'LabelOperand': return `@${operand.targetBlockId}`;
    case 'LiteralOperand': return 'lit ' + stringifyValue(operand.literal);
    case 'CountOperand': return 'count ' + operand.count;
    case 'IndexOperand': return 'index ' + operand.index;
    case 'NameOperand': return `name '${operand.name}'`;
    case 'OpOperand': return `op '${operand.subOperation}'`;
    default: return assertUnreachable(operand);
  }
}

export function stringifyAllocation(allocation: IL.Allocation): string {
  switch (allocation.type) {
    case 'ArrayAllocation':
      return `[${allocation.items
        .map(v => `\n  ${v ? stringifyValue(v) : ''},`)
        .join('')
      }\n]`;
    case 'ObjectAllocation':
      return `{${entriesInOrder(allocation.properties)
        .map(([k, v]) => `\n  ${stringifyIdentifier(k)}: ${stringifyValue(v)},`)
        .join('')
      }\n}`;
    case 'Uint8ArrayAllocation':
      return `Uint8Array { ${allocation.bytes
        .map(b => `0x${b.toString(16).padStart(2, '0')}`)
        .join(', ')
      } }`;
    default: return assertUnreachable(allocation);
  }
}

export function stringifyValue(value: IL.Value): string {
  switch (value.type) {
    case 'DeletedValue': return 'deleted';
    case 'UndefinedValue': return 'undefined';
    case 'NullValue': return 'null';
    case 'BooleanValue':
      return value.value ? 'true' : 'false';
    case 'NumberValue': {
      if (Object.is(value.value, -0)) {
        return '-0';
      } else if (value.value === Infinity) {
        return 'Infinity';
      } else if (value.value === -Infinity) {
        return '-Infinity';
      } else if (isNaN(value.value)) {
        return 'NaN';
      } else {
        return JSON.stringify(value.value);
      }
    }
    case 'StringValue': return stringifyStringLiteral(value.value);
    case 'HostFunctionValue': return `host function ${value.value}`;
    case 'FunctionValue': return `&function ${stringifyIdentifier(value.value)}`;
    case 'ClosureValue': return `closure (${stringifyValue(value.scope)}, ${stringifyValue(value.target)})`;
    case 'ReferenceValue': return `&allocation ${value.value}`;
    case 'EphemeralFunctionValue': return `&ephemeral ${value.value}`;
    case 'EphemeralObjectValue': return `&ephemeral ${value.value}`;
    case 'StackDepthValue': return `&stack ${value.frameNumber}[${value.frameNumber}]`;
    case 'ProgramAddressValue': return `&prog ${value.funcId}[${value.blockId}]`;
    default: return assertUnreachable(value);
  }
}