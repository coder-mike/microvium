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
      ? entries(unit.moduleImports).map(([varName, specifier]) => `import ${stringifyIdentifier(varName)} from ${stringifyIdentifier(specifier)};\n`).join('') + '\n'
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

export function stringifyAllocation(allocation: IL.Allocation): string {
  switch (allocation.type) {
    case 'ArrayAllocation':
      return `[${allocation.items
        .map(v => `\n  ${stringifyValue(v)},`)
        .join('')
      }\n]`;
    case 'ObjectAllocation':
      return `{${entries(allocation.properties)
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
    case 'ReferenceValue': return `&allocation ${value.value}`;
    case 'EphemeralFunctionValue': return `&ephemeral ${value.value}`;
    case 'EphemeralObjectValue': return `&ephemeral ${value.value}`;
    default: return assertUnreachable(value);
  }
}