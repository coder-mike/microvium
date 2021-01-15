// Note: `stackChange` is a number describing how much the stack is expected to

import { IL } from "../lib";
import { unexpected } from "./utils";

export type RegName = 'ArgCount' | 'Scope';

type StackChange = (...operands: IL.Operand[]) => number;
type StackChanges = { [opcode: string]: StackChange };

// For opcodes that don't have a fixed effect on the stack, these functions
// calculate the corresponding stack change given the specific operands
const stackChanges: StackChanges = {
  call: argCount => - count(argCount) - 1,
  closureNew: fieldCount => -count(fieldCount),
  objectGet: propertyKey => (propertyKey === undefined) ? -1 : 0,
  objectSet: propertyKey => (propertyKey === undefined) ? -3 : -2,
  pop: popCount => -count(popCount),
}

// change after executing the operation.
export const opcodes = {
  'ArrayNew':    { operands: [                              ], stackChange: 1                     },
  'BinOp':       { operands: ['OpOperand'                   ], stackChange: -1                    },
  'Branch':      { operands: ['LabelOperand', 'LabelOperand'], stackChange: -1                    },
  'Call':        { operands: ['CountOperand'                ], stackChange: stackChanges.call     },
  'ClosureNew':  { operands: ['CountOperand'                ], stackChange: stackChanges.closureNew },
  'Jump':        { operands: ['LabelOperand'                ], stackChange: 0                     },
  'Literal':     { operands: ['LiteralOperand'              ], stackChange: 1                     },
  'LoadArg':     { operands: ['IndexOperand'                ], stackChange: 1                     },
  'LoadGlobal':  { operands: ['NameOperand'                 ], stackChange: 1                     },
  'LoadScoped':  { operands: ['NameOperand'                 ], stackChange: 1                     },
  'LoadReg':     { operands: ['NameOperand' /* RegName */   ], stackChange: 1                     },
  'LoadVar':     { operands: ['IndexOperand'                ], stackChange: 1                     },
  'Nop':         { operands: ['CountOperand'                ], stackChange: 0                     },
  'ObjectGet':   { operands: ['LiteralOperand?'             ], stackChange: stackChanges.objectGet },
  'ObjectNew':   { operands: [                              ], stackChange: 1                     },
  'ObjectSet':   { operands: ['LiteralOperand?'             ], stackChange: stackChanges.objectSet },
  'Pop':         { operands: ['CountOperand'                ], stackChange: stackChanges.pop      },
  'Return':      { operands: [                              ], stackChange: 1                     },
  'ScopePush':   { operands: ['CountOperand'                ], stackChange: 0                     },
  'StoreGlobal': { operands: ['NameOperand'                 ], stackChange: -1                    },
  'StoreScoped': { operands: ['IndexOperand'                 ], stackChange: -1                   },
  'StoreVar':    { operands: ['IndexOperand'                ], stackChange: -1                    },
  'UnOp':        { operands: ['OpOperand'                   ], stackChange: 0                     },
};

export type Opcode = keyof typeof opcodes;

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