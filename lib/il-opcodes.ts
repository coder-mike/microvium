// Note: `stackChange` is a number describing how much the stack is expected to

import { Operation } from "./il";

export type RegName = 'ArgCount' | 'Scope';

// change after executing the operation.
export const opcodes = {
  'ArrayNew':    { operands: [                              ], stackChange: 1                     },
  'BinOp':       { operands: ['OpOperand'                   ], stackChange: -1                    },
  'Branch':      { operands: ['LabelOperand', 'LabelOperand'], stackChange: -1                    },
  'Call':        { operands: ['CountOperand'                ], stackChange: callStackChange       },
  'ClosureNew':  { operands: ['CountOperand'                ], stackChange: closureNewStackChange },
  'Jump':        { operands: ['LabelOperand'                ], stackChange: 0                     },
  'Literal':     { operands: ['LiteralOperand'              ], stackChange: 1                     },
  'LoadArg':     { operands: ['IndexOperand'                ], stackChange: 1                     },
  'LoadGlobal':  { operands: ['NameOperand'                 ], stackChange: 1                     },
  'LoadReg':     { operands: ['NameOperand' /* RegName */   ], stackChange: 1                     },
  'LoadVar':     { operands: ['IndexOperand'                ], stackChange: 1                     },
  'Nop':         { operands: ['CountOperand'                ], stackChange: 0                     },
  'ObjectGet':   { operands: [                              ], stackChange: -1                    },
  'ObjectNew':   { operands: [                              ], stackChange: 1                     },
  'ObjectSet':   { operands: [                              ], stackChange: -3                    },
  'Pop':         { operands: ['CountOperand'                ], stackChange: popStackChange        },
  'Return':      { operands: [                              ], stackChange: 1                     },
  'StoreGlobal': { operands: ['NameOperand'                 ], stackChange: -1                    },
  'StoreVar':    { operands: ['IndexOperand'                ], stackChange: -1                    },
  'UnOp':        { operands: ['OpOperand'                   ], stackChange: 0                     },
};

export type Opcode = keyof typeof opcodes;

/**
 * Amount the stack changes for a call operation
 */
function callStackChange(op: Operation): number {
  if (op.opcode !== 'Call') {
    throw new Error('Expected `Call` operation');
  }
  if (op.operands.length !== 1) {
    throw new Error('Invalid operands to `Call` operation');
  }
  const argCountOperand = op.operands[0];
  if (argCountOperand.type !== 'CountOperand') {
    throw new Error('Invalid operands to `Call` operation');
  }
  const argCount = argCountOperand.count;
  // Pops all the arguments off the stack, and pops the function reference off
  // the stack. This is the dynamic stack change. The static stack change also
  // has the pushed return value.
  return - argCount - 1;
}

/**
 * Amount the stack changes for a pop operation
 */
function popStackChange(op: Operation): number {
  if (op.opcode !== 'Pop') {
    throw new Error('Expected `Pop` operation');
  }
  if (op.operands.length !== 1) {
    throw new Error('Invalid operands to `Pop` operation');
  }
  const popCountOperand = op.operands[0];
  if (popCountOperand.type !== 'CountOperand') {
    throw new Error('Invalid operands to `Pop` operation');
  }
  const popCount = popCountOperand.count;
  return -popCount;
}

/**
 * Amount the stack changes for a ClosureNew operation
 */
function closureNewStackChange(op: Operation): number {
  if (op.opcode !== 'ClosureNew') {
    throw new Error('Expected `ClosureNew` operation');
  }
  if (op.operands.length !== 1) {
    throw new Error('Invalid operands to `ClosureNew` operation');
  }
  const fieldCountOperand = op.operands[0];
  if (fieldCountOperand.type !== 'CountOperand') {
    throw new Error('Invalid operands to `ClosureNew` operation');
  }
  const fieldCount = fieldCountOperand.count;
  return -fieldCount;
}