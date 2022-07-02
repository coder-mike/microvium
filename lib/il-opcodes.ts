

import { IL } from "../lib";
import { unexpected } from "./utils";

export type RegName = 'ArgCount';

type StackChange = (...operands: IL.Operand[]) => number;
type StackChanges = { [opcode: string]: StackChange };

// For opcodes that don't have a fixed effect on the stack, these functions
// calculate the corresponding stack change given the specific operands
const stackChanges: StackChanges = {
  call: argCount => - count(argCount) - 1,
  pop: popCount => -count(popCount),
}

/**
 * The set of opcodes and metadata about the opcodes
 *
 * Note: `stackChange` is the "dynamic" number describing how much the stack is
 * expected to change after executing the operation. See also
 * `IL.calcDynamicStackChangeOfOp` and `IL.calcStaticStackChangeOfOp`.
 */
export const opcodes = {
  'ArrayGet':      { operands: ['LiteralOperand'              ], stackChange: 0                      },
  'ArrayNew':      { operands: [                              ], stackChange: 1                      },
  'ArraySet':      { operands: ['LiteralOperand'              ], stackChange: -2                     },
  'BinOp':         { operands: ['OpOperand'                   ], stackChange: -1                     },
  'Branch':        { operands: ['LabelOperand', 'LabelOperand'], stackChange: -1                     },
  'Call':          { operands: ['CountOperand'                ], stackChange: stackChanges.call      },
  'ClosureNew':    { operands: [                              ], stackChange: 0                      },
  'EndTry':        { operands: [                              ], stackChange: -2                     },
  'Jump':          { operands: ['LabelOperand'                ], stackChange: 0                      },
  'Literal':       { operands: ['LiteralOperand'              ], stackChange: 1                      },
  'LoadArg':       { operands: ['IndexOperand'                ], stackChange: 1                      },
  'LoadGlobal':    { operands: ['NameOperand'                 ], stackChange: 1                      },
  'LoadScoped':    { operands: ['IndexOperand'                ], stackChange: 1                      },
  'LoadVar':       { operands: ['IndexOperand'                ], stackChange: 1                      },
  'Nop':           { operands: ['CountOperand'                ], stackChange: 0                      },
  'ObjectGet':     { operands: [                              ], stackChange: -1                     },
  'ObjectKeys':    { operands: [                              ], stackChange: 0                      },
  'ObjectNew':     { operands: [                              ], stackChange: 1                      },
  'ObjectSet':     { operands: [                              ], stackChange: -3                     },
  'Pop':           { operands: ['CountOperand'                ], stackChange: stackChanges.pop       },
  'Return':        { operands: [                              ], stackChange: 1                      },
  'ScopeClone':    { operands: [                              ], stackChange: 0                      },
  'ScopePop':      { operands: [                              ], stackChange: 0                      },
  'ScopePush':     { operands: ['CountOperand'                ], stackChange: 0                      },
  'StartTry':      { operands: ['LabelOperand'                ], stackChange: 2                      },
  'StoreGlobal':   { operands: ['NameOperand'                 ], stackChange: -1                     },
  'StoreScoped':   { operands: ['IndexOperand'                ], stackChange: -1                     },
  'StoreVar':      { operands: ['IndexOperand'                ], stackChange: -1                     },
  'Throw':         { operands: [                              ], stackChange: -1                     },
  'Uint8ArrayNew': { operands: [                              ], stackChange: 0                      },
  'UnOp':          { operands: ['OpOperand'                   ], stackChange: 0                      },
};

export type Opcode = keyof typeof opcodes;

export const blockTerminatingOpcodes = new Set<Opcode>(['Jump', 'Branch', 'Return', 'Throw']);

function count(operand: IL.Operand): number {
  if (!operand || operand.type !== 'CountOperand') unexpected();
  return operand.count;
}

const _minOperandCount = new Map(Object.keys(opcodes).map(opcode => [
  opcode,
  opcodes[opcode as IL.Opcode].operands.filter(operand => !(operand as string).endsWith('?')).length
]))

// The minimum number of operands that a particular operation can take
export function minOperandCount(op: IL.Opcode) {
  return _minOperandCount.get(op) ?? unexpected()
}

const _maxOperandCount = new Map(Object.keys(opcodes).map(opcode => [
  opcode,
  opcodes[opcode as IL.Opcode].operands.length
]))

// The maximum number of operands that a particular operation can take
export function maxOperandCount(op: IL.Opcode) {
  return _maxOperandCount.get(op) ?? unexpected()
}

export function labelOperandsOfOperation(op: IL.Operation): IL.LabelOperand[] {
  const meta = opcodes[op.opcode] ?? unexpected();
  const result: IL.LabelOperand[] = [];
  for (const [operandI, operandType] of meta.operands.entries()) {
    if (operandType === 'LabelOperand') {
      result.push(op.operands[operandI] as IL.LabelOperand ?? unexpected())
    }
  }
  return result;
}