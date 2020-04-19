import * as IL from './il';
import * as VM from './virtual-machine-types';
import { assertUnreachable, stringifyIdentifier, stringifyStringLiteral, notUndefined, unexpected, assert, entries } from './utils';
import _ from 'lodash';

export function stringifyUnit(unit: IL.Unit): string {
  return `unit ${
    stringifyIdentifier(unit.sourceFilename)
  };\n\nentry ${
    stringifyIdentifier(unit.entryFunctionID)
  };\n\n${
    // Global variables
    unit.globalImports.length
      ? unit.globalImports.map(g => `import ${stringifyIdentifier(g)};\n`).join('') + '\n'
      : ''
  }${
    // Module-level variables
    unit.moduleVariables.length
      ? unit.moduleVariables.map(g => `var ${stringifyIdentifier(g)};\n`).join('') + '\n'
      : ''
  }${
    // Functions
    [...Object.values(unit.functions)]
      .map(f => stringifyFunction(f, ''))
      .join('\n\n')
  }`
}

export function stringifyFunction(func: IL.Function, indent: string): string {
  return `${
    func.comments
      ? func.comments.map(c => `\n// ${c}`).join('')
      : ''
  }function ${stringifyIdentifier(func.id)}() {${
    [...Object.values(func.blocks)]
      .map(b => stringifyBlock(b, indent + '  '))
      .join('')
  }\n${indent}}`;
}

export function stringifyBlock(block: IL.Block, indent: string): string {
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

export function stringifyOperationLine(operation: IL.Operation, indent: string): string {
  return `${
    operation.comments
      ? operation.comments.map(c => `\n${indent}// ${c}`).join('')
      : ''
  }\n${indent}${
    stringifyOperation(operation)
  };`
}

export function stringifyOperation(operation: IL.Operation): string {
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

export function stringifyValue(literal: IL.Value): string {
  switch (literal.type) {
    case 'UndefinedValue': return 'undefined';
    case 'NullValue': return 'null';
    case 'StringValue': return stringifyStringLiteral(literal.value);
    case 'BooleanValue':
    case 'NumberValue': return JSON.stringify(literal.value);
    default: return assertUnreachable(literal);
  }
}

export function stringifyAllocation(allocation: VM.Allocation): string {
  switch (allocation.type) {
    case 'ArrayAllocation':
      return `[${allocation.items
        .map(v => `\n  ${stringifyVMValue(v)},`)
        .join('')
      }\n]`;
    case 'ObjectAllocation':
      return `{${entries(allocation.properties)
        .map(([k, v]) => `\n  ${stringifyIdentifier(k)}: ${stringifyVMValue(v)},`)
        .join('')
      }\n}`;
    default: return assertUnreachable(allocation);
  }
}

export function stringifyVMValue(value: VM.Value): string {
  switch (value.type) {
    case 'UndefinedValue': return 'undefined';
    case 'NullValue': return 'null';
    case 'BooleanValue':
    case 'NumberValue':
    case 'StringValue': return JSON.stringify(value.value);
    case 'HostFunctionValue': return `host function ${value.value}`;
    case 'FunctionValue': return `&function ${stringifyIdentifier(value.value)}`;
    case 'ReferenceValue': return `&allocation ${value.value}`;
    case 'EphemeralFunctionValue': return `&ephemeral ${value.value}`;
    default: return assertUnreachable(value);
  }
}