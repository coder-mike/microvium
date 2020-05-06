#pragma once

/*
Microvium categorizes operations into groups based on common features. The first
nibble of an instruction is its vm_TeOpcode. This is followed by 4 bits which
can either be interpretted as a data parameter or as another opcode (e.g.
vm_TeOpcodeEx1). I call the first nibble the "primary opcode" and the second
nibble is the "secondary opcode".

There are a number of possible secondary opcodes, and each group has common
preparation logic across the group. Preparation logic means the code that runs
before the operation. For example, many operations require popping a value off
the stack before operating on the value. The VM implementation is more compact
if the pop code is common to all instructions that do the pop.

Operations can have different "followthrough" logic grouped arbitrarily, since
the implementation of all instructions requires a "jump", those that have common
followthrough logic simply jump to the same followthrough without additional
cost, which eventually lands up back at the loop start. So the instruction
grouping does not need to cater for followthrough logic, only preparation logic.

To keep operation commonality as seamlessly as possible, the VM implementation
use 16-bit "registers", which have overloaded meaning depending on the context:

  - `reg1`
    - Initially holds the zero-extended 4-bit secondary nibble
    - Operations that load an 8- or 16-bit literal will overwrite `reg1` with
      the literal.
    - "Pure" operations use reg1 as the first popped operand (none of the pure
      operations have an embedded literal). "Pure" are what I'm calling
      operations whose entire effect is to pop some operands off the stack,
      operate on them, and push a result back onto the stack. For example,
      `ADD`.
    - `reg1` is also used as the "result" value for the common push-result tail
      logic
  - `reg2`
    - used as the second popped value of binary operations
    - used as the value to store, store-like operations
  - `reg3`
    - can be used arbitrarily by operations and does not have a common meaning

Additionally, the number operations have variations that work on 32 or 64 bit
values. These have their own local/ephemeral registers:

  - `reg1I`: the value of the reg1 register unpacked to a `uint32_t`
  - `reg2I`: the value of the reg2 register unpacked to a `uint32_t`
  - `reg1F`: the value of the reg1 register unpacked to a `double`
  - `reg2F`: the value of the reg2 register unpacked to a `double`

Operation groups and their corresponding preparation logic

  - vm_TeOpcodeEx1:
    - The prep does not read a literal (all these instructions are single-byte).
    - The prep pops 0, 1, or 2 values from the stack depending on the
      instruction range

  - vm_TeOpcodeEx2:
    - Prep reads 8-bit literal into reg1
      - Two separate instrution ranges specify whether to sign extend or not.
    - Two instruction ranges specify whether the prep will also pop an arg into
      reg2.

  - vm_TeOpcodeEx3:
    - Prep reads a 16-bit value from byte stream into reg1. This can be
      interpretted as either signed or unsigned by the particular instruction.
    - A subrange within the instruction specifies whether an argument is popped
      from the stack.

  - vm_TeNumberOp:
    - These are all dual-implementation instructions which have both 32 and 64
      bit implementations.
    - Prep pops one or two values off the stack and reads them into reg1 and
      reg2 respectively. The choice of 1 or 2 depends on the subrange. If
      popping one value, the second is left as zero.
    - Prep unpacks to either int32 or float64 depending on the corresponding
      data types.
    - The operations can dispatch to a different tail/followthrough routine
      depending on whether they overflow or not.

  - vm_TeBitwiseOp:
    - These operations all operate on 32-bit integers and produce 32-bit integer
      results.
    - Prep pops one or two values off the stack and reads them into reg1 and
      reg2 respectively. The choice of 1 or 2 depends on the subrange. If
      popping one value, the second is left as zero.
    - Prep unpacks reg1 and reg2 to int32

Followthrough/tail routines:

  - Push float (reg1F)
  - Push int32 (reg1I)
  - Push 16-bit result (reg1)

*/

// 4-bit enum
typedef enum vm_TeOpcode {
  MVM_OP_LOAD_SMALL_LITERAL  = 0x0, // (+ 4-bit vm_TeSmallLiteralValue)

  MVM_OP_LOAD_VAR_1          = 0x1, // (+ 4-bit variable index relative to stack pointer)
  MVM_OP_STORE_VAR_1         = 0x2, // (+ 4-bit variable index relative to stack pointer)

  MVM_OP_LOAD_GLOBAL_1       = 0x3, // (+ 4-bit global variable index)
  MVM_OP_STORE_GLOBAL_1      = 0x4, // (+ 4-bit global variable index)

  MVM_OP_LOAD_ARG_1          = 0x5, // (+ 4-bit arg index)

  MVM_OP_POP                 = 0x6, // (+ 4-bit arg count of things to pop)
  MVM_OP_CALL_1              = 0x7, // (+ 4-bit index into short-call table)

  MVM_OP_STRUCT_GET_1        = 0x8, // (+ 4-bit field index)
  MVM_OP_STRUCT_SET_1        = 0x9, // (+ 4-bit field index)

  MVM_OP_NUM_OP              = 0xA, // (+ 4-bit vm_TeNumberOp)
  MVM_OP_BIT_OP              = 0xB, // (+ 4-bit vm_TeBitwiseOp)
  MVM_OP_EXTENDED_5          = 0xC, // (+ 4-bit vm_TeOpcodeEx5)

  MVM_OP_EXTENDED_1          = 0xD, // (+ 4-bit vm_TeOpcodeEx1)
  MVM_OP_EXTENDED_2          = 0xE, // (+ 4-bit vm_TeOpcodeEx2)
  MVM_OP_EXTENDED_3          = 0xF, // (+ 4-bit vm_TeOpcodeEx3)

  MVM_OP_END
} vm_TeOpcode;

#define VM_RETURN_FLAG_POP_FUNCTION (1 << 0)
#define VM_RETURN_FLAG_UNDEFINED    (1 << 1)

typedef enum vm_TeOpcodeEx1 {
  MVM_OP1_RETURN_1                = 0x0,
  MVM_OP1_RETURN_2                = 0x0 | VM_RETURN_FLAG_POP_FUNCTION,
  MVM_OP1_RETURN_3                = 0x0 | VM_RETURN_FLAG_UNDEFINED,
  MVM_OP1_RETURN_4                = 0x0 | VM_RETURN_FLAG_POP_FUNCTION | VM_RETURN_FLAG_UNDEFINED,

  MVM_OP1_OBJECT_NEW              = 0x4,
  MVM_OP1_CALL_DETACHED_EPHEMERAL = 0x5, // (No parameters) Represents the calling of an ephemeral that existed in a previous epoch

  // <-- ops after this point pop at least one argument

  // boolean -> boolean
  VM_UOP_LOGICAL_NOT              = 0x6,

  // <-- ops after this point pop at least two arguments

  // (object, prop) -> any
  MVM_OP1_OBJECT_GET_1            = 0x7, // (field ID is dynamic)

  // (string, string) -> string
  // (number, number) -> number
  MVM_OP1_ADD                     = 0x8, // TODO: My thinking is that this can jump to MVM_NUM_OP_ADD_NUM for the number case (after pushing its operands back on the stack presumably)

  // (any, any) -> boolean
  MVM_OP1_EQUAL                   = 0x9,
  MVM_OP1_NOT_EQUAL               = 0xA,

  // (object, prop, any) -> void
  MVM_OP1_OBJECT_SET_1            = 0xB, // (field ID is dynamic)

  MVM_OP1_END
} vm_TeOpcodeEx1;

// All of these operations are implemented with an 8-bit literal embedded into
// the instruction. The literal is stored in reg1.
typedef enum vm_TeOpcodeEx2 {
  MVM_OP2_BRANCH_1            = 0x0, // (+ 8-bit signed offset)
  MVM_OP2_JUMP_1              = 0x1, // (+ 8-bit signed offset)

  // <-- ops before this point use a signed literal

  MVM_OP2_STORE_ARG           = 0x1, // (+ 8-bit unsigned arg index)
  MVM_OP2_STORE_GLOBAL_2      = 0x2, // (+ 8-bit unsigned global variable index)
  MVM_OP2_STORE_VAR_2         = 0x3, // (+ 8-bit unsigned variable index relative to stack pointer)
  MVM_OP2_STRUCT_SET_2        = 0x4, // (+ 8-bit unsigned field index)

  // <-- ops before this point pop from the stack into reg2

  MVM_OP2_CALL_HOST           = 0x5, // (+ 8-bit unsigned index into resolvedImports + 8-bit arg count)
  MVM_OP2_CALL_3              = 0x6, // (+ 8-bit unsigned arg count. Target is dynamic)

  MVM_OP2_LOAD_GLOBAL_2       = 0x7, // (+ 8-bit unsigned global variable index)
  MVM_OP2_LOAD_VAR_2          = 0x8, // (+ 8-bit unsigned variable index relative to stack pointer)
  MVM_OP2_LOAD_ARG_2          = 0x9, // (+ 8-bit unsigned arg index)
  MVM_OP2_STRUCT_GET_2        = 0xA, // (+ 8-bit unsigned field index)

  MVM_OP2_END
} vm_TeOpcodeEx2;

// These instructions all have an embedded 16-bit literal value
typedef enum vm_TeOpcodeEx3 {
  MVM_OP3_CALL_2              = 0x0, // (+ 16-bit function offset + 8-bit arg count)
  MVM_OP3_JUMP_2              = 0x1, // (+ 16-bit signed offset)
  MVM_OP3_LOAD_LITERAL        = 0x3, // (+ 16-bit value)
  MVM_OP3_LOAD_GLOBAL_3       = 0x4, // (+ 16-bit global variable index)

  // <-- ops after this point pop an argument into reg1

  MVM_OP3_BRANCH_2            = 0x2, // (+ 16-bit signed offset)
  MVM_OP3_STORE_GLOBAL_3      = 0x5, // (+ 16-bit global variable index)

  MVM_OP3_OBJECT_GET_2        = 0x4, // (+ 16-bit string reference)
  MVM_OP3_OBJECT_SET_2        = 0x5, // (+ 16-bit string reference)

  MVM_OP3_END
} vm_TeOpcodeEx3;


// Number operations. These are operations which take one or two arguments from
// the stack and coerce them to numbers. Each of these will have two
// implementations: one for 32-bit int, and one for 64-bit float.
typedef enum vm_TeNumberOp {

  // (number, number) -> boolean
  MVM_NUM_OP_LESS_THAN      = 0x1,
  MVM_NUM_OP_GREATER_THAN   = 0x2,
  MVM_NUM_OP_LESS_EQUAL     = 0x3,
  MVM_NUM_OP_GREATER_EQUAL  = 0x4,

  // (number, number) -> number
  MVM_NUM_OP_ADD_NUM        = 0x5,
  MVM_NUM_OP_SUBTRACT       = 0x6,
  MVM_NUM_OP_MULTIPLY       = 0x7,
  MVM_NUM_OP_DIVIDE         = 0x8,
  MVM_NUM_OP_DIVIDE_AND_TRUNC = 0x9, // Implemented in code as `x / y | 0`
  MVM_NUM_OP_REMAINDER      = 0xA,
  MVM_NUM_OP_POWER          = 0xB,

  // <-- ops after this point are unary
  MVM_NUM_OP_DIVIDER_UNARY  = 0xC,

  // number -> number
  MVM_NUM_OP_NEGATE         = 0xC,
  MVM_NUM_OP_UNARY_PLUS     = 0xD,

  VM_BOP1_END
} vm_TeBinOp1;

// Bitwise operations:
typedef enum vm_TeBitwiseOp {

  // (bits, bits) -> bits
  MVM_BIT_OP_SHR_ARITHMETIC = 0x0,
  MVM_BIT_OP_SHR_BITWISE    = 0x1,
  MVM_BIT_OP_SHL            = 0x2,
  MVM_BIT_OP_OR             = 0x3,
  MVM_BIT_OP_AND            = 0x4,
  MVM_BIT_OP_XOR            = 0x5,

  // <-- ops after this point are unary

  // bits -> bits
  MVM_BIT_OP_NOT            = 0x6,
  MVM_BIT_OP_OR_ZERO        = 0x7, // Coercing value to int with `x | 0`

  VM_BOP2_END
} vm_TeBinOp2;

// 4-bit enum
typedef enum vm_TeSmallLiteralValue {
  VM_SLV_NULL            = 0x0,
  VM_SLV_UNDEFINED       = 0x1,
  VM_SLV_FALSE           = 0x2,
  VM_SLV_TRUE            = 0x3,
  VM_SLV_EMPTY_STRING    = 0x4,
  VM_SLV_INT_0           = 0x5,
  VM_SLV_INT_1           = 0x6,
  VM_SLV_INT_2           = 0x7,
  VM_SLV_INT_MINUS_1     = 0x8,
} vm_TeSmallLiteralValue;
