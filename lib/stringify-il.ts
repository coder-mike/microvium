import * as IL from './il';
import { assertUnreachable, stringifyIdentifier, stringifyStringLiteral, notUndefined, unexpected, hardAssert, entries, entriesInOrder, invalidOperation } from './utils';
import _ from 'lodash';

export interface StringifyILOpts {
  comments?: boolean;
  cullUnreachableBlocks?: boolean;
}

export function stringifyUnit(unit: IL.Unit): string {
  return `unit ${
    stringifyIdentifier(unit.sourceFilename)
  };\n\nentry ${
    stringifyIdentifier(unit.entryFunctionID)
  };\n\n${
    // Global variables
    unit.freeVariables.length
      ? unit.freeVariables.map(g => `import ${stringifyIdentifier(g)};\n`).join('') + '\n'
      : ''
  }${
    // Module-level variables
    unit.moduleVariables.length
      ? unit.moduleVariables.map(g => `var ${stringifyIdentifier(g)};\n`).join('') + '\n'
      : ''
  }${
    // Imports
    Object.keys(unit.moduleImports).length > 0
      ? unit.moduleImports.map(({ variableName, specifier}) =>
          `import ${stringifyIdentifier(variableName)} from ${stringifyIdentifier(specifier)};\n`
        ).join('') + '\n'
      : ''
  }${
    // Functions
    [...Object.values(unit.functions)]
      .map(f => stringifyFunction(f, ''))
      .join('\n\n')
  }`
}

export function stringifyFunction(func: IL.Function, indent: string, opts: StringifyILOpts = {}): string {
  let blocks = func.blocks;
  if (opts.cullUnreachableBlocks) {
    blocks = cullUnreachableBlocks(blocks, func.entryBlockID);
  }
  return `${
    func.comments && opts.comments !== false
      ? func.comments.map(c => `\n// ${c}`).join('')
      : ''
  }function ${stringifyIdentifier(func.id)}() {${
    blocksInOrder(blocks, func.entryBlockID)
      .map(b => stringifyBlock(b, indent + '  ', opts))
      .join('')
  }\n${indent}}`;
}

function cullUnreachableBlocks(blocks: IL.Function['blocks'], entryBlockID: string): IL.Function['blocks'] {
  const blockIsReachableSet = new Set<IL.BlockID>();

  blockIsReachable(entryBlockID);

  return _.pickBy(blocks, b => blockIsReachableSet.has(b.id));

  function blockIsReachable(blockID: string) {
    if (blockIsReachableSet.has(blockID)) {
      return;
    }
    blockIsReachableSet.add(blockID);
    const block = notUndefined(blocks[blockID]);
    for (const op of block.operations) {
      if (op.opcode === 'Branch') {
        const [consequent, alternate] = op.operands;
        if (consequent.type !== 'LabelOperand' || alternate.type !== 'LabelOperand') return unexpected();
        blockIsReachable(consequent.targetBlockID);
        blockIsReachable(alternate.targetBlockID);
      } else if (op.opcode === 'Jump') {
        const [targetLabel] = op.operands;
        if (targetLabel.type !== 'LabelOperand') return unexpected();
        blockIsReachable(targetLabel.targetBlockID);
      }
    }
  }
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
    block.comments && opts.comments !== false
      ? block.comments.map(c => `\n  // ${c}`).join('')
      : ''
  }\n${indent}${block.id}:${
    block.operations
      .map(o => stringifyOperationLine(o, indent + '  ', opts))
      .join('')
  }`
}

export function stringifyOperationLine(operation: IL.Operation, indent: string, opts: StringifyILOpts = {}): string {
  const loc = operation.sourceLoc;
  return `${
    operation.comments && opts.comments !== false
      ? operation.comments.map(c => `\n${indent}// ${c}`).join('')
      : ''
  }\n${indent}${
    stringifyOperation(operation)
  };${
    ''
    // loc
    //   ? `  // ${loc.filename}:${loc.line}:${loc.column}`
    //   : ''
  }`
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
    case 'LabelOperand': return `@${operand.targetBlockID}`;
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
    default: return assertUnreachable(allocation);
  }
}

export function stringifyValue(value: IL.Value): string {
  switch (value.type) {
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
    default: return assertUnreachable(value);
  }
}