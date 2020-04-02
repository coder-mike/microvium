import * as il from './il';
import { assertUnreachable } from './utils';

export function stringifyUnit(unit: il.Unit): string {
  return `unit ${
    JSON.stringify(unit.sourceFilename)
  };\n\nentry ${
    unit.entryFunctionID
  };\n\n${
    // Global variables
    unit.globalImports.length
      ? unit.globalImports.map(g => `import ${g};\n`).join('') + '\n'
      : ''
  }${
    // Module-level variables
    unit.moduleVariables.length
      ? unit.moduleVariables.map(g => `var ${g};\n`).join('') + '\n'
      : ''
  }${
    // Functions
    [...Object.values(unit.functions)]
      .map(f => stringifyFunction(f, ''))
      .join('\n\n')
  }`
}

export function stringifyFunction(func: il.Function, indent: string): string {
  return `${
    func.comments
      ? func.comments.map(c => `\n// ${c}`).join('')
      : ''
  }function ${func.id}() {${
    [...Object.values(func.blocks)]
      .map(b => stringifyBlock(b, indent + '  '))
      .join('')
  }\n${indent}}`;
}

export function stringifyBlock(block: il.Block, indent: string): string {
  return `${
    block.comments
      ? block.comments.map(c => `\n  // ${c}`).join('')
      : ''
  }\n${indent}${block.id}:${
    block.operations
      .map(o => stringifyOperationLine(o, indent + '  '))
      .join('')
  }`
}

export function stringifyOperationLine(operation: il.Operation, indent: string): string {
  return `${
    operation.comments
      ? operation.comments.map(c => `\n${indent}// ${c}`).join('')
      : ''
  }\n${indent}${
    stringifyOperation(operation)
  };`
}

export function stringifyOperation(operation: il.Operation): string {
  return `${operation.opcode}(${
    operation.operands
      .map(stringifyOperand)
      .join(', ')
  })`
}

export function stringifyOperand(operand: il.Operand): string {
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

export function stringifyValue(literal: il.Value): string {
  switch (literal.type) {
    case 'UndefinedValue': return 'undefined';
    case 'NullValue': return 'null';
    case 'BooleanValue':
    case 'NumberValue':
    case 'StringValue': return JSON.stringify(literal.value);
    default: return assertUnreachable(literal);
  }
}