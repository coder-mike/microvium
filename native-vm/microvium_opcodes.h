#pragma once

/*
Note: the instruction set documentation is in
`microvium/doc/internals/instruction-set`

Microvium categorizes operations into groups based on common features. The first
nibble of an instruction is its vm_TeOpcode. This is followed by 4 bits which
can either be interpreted as a data parameter or as another opcode (e.g.
vm_TeOpcodeEx1). I call the first nibble the "primary opcode" and the second
nibble is the "secondary opcode".

There are a number of possible secondary opcodes, and each group has common
preparation logic across the group. Preparation logic means the code that runs
before the operation. For example, many operations require popping a value off
the stack before operating on the value. The VM implementation is more compact
if the pop code is common to all instructions that do the pop.

Operations can have different "follow through" logic grouped arbitrarily, since
the implementation of all instructions requires a "jump", those that have common
follow through logic simply jump to the same follow through without additional
cost, which eventually lands up back at the loop start. So the instruction
grouping does not need to cater for follow through logic, only preparation
logic.

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
      - Two separate instruction ranges specify whether to sign extend or not.
    - Two instruction ranges specify whether the prep will also pop an arg into
      reg2.

  - vm_TeOpcodeEx3:
    - Prep reads a 16-bit value from byte stream into reg1. This can be
      interpreted as either signed or unsigned by the particular instruction.
    - A sub-range within the instruction specifies whether an argument is popped
      from the stack.
    - (Edit: there are violations of this pattern because I ran out space in
      vm_TeOpcodeEx1)

  - vm_TeOpcodeEx4:
    - Not really any common logic. Just a bucket of miscellaneous instructions.

  - vm_TeNumberOp:
    - These are all dual-implementation instructions which have both 32 and 64
      bit implementations.
    - Prep pops one or two values off the stack and reads them into reg1 and
      reg2 respectively. The choice of 1 or 2 depends on the sub-range. If
      popping one value, the second is left as zero.
    - Prep unpacks to either int32 or float64 depending on the corresponding
      data types.
    - The operations can dispatch to a different tail/follow through routine
      depending on whether they overflow or not.

  - vm_TeBitwiseOp:
    - These operations all operate on 32-bit integers and produce 32-bit integer
      results.
    - Prep pops one or two values off the stack and reads them into reg1 and
      reg2 respectively. The choice of 1 or 2 depends on the sub-range. If
      popping one value, the second is left as zero.
    - Prep unpacks reg1 and reg2 to int32

Follow-through/tail routines:

  - Push float (reg1F)
  - Push int32 (reg1I)
  - Push 16-bit result (reg1)

*/

// TODO: I think this instruction set needs an overhaul. The categorization has
// become chaotic and not that efficient.

// TODO: If we wanted to make space in the primary opcode range, we could remove
// `VM_OP_LOAD_ARG_1` and just leave `VM_OP2_LOAD_ARG_2`, since static analysis
// should be able to convert many instances of `LoadArg` into `LoadVar`

// 4-bit enum
typedef enum vm_TeOpcode {
  VM_OP_LOAD_SMALL_LITERAL  = 0x0, // (+ 4-bit vm_TeSmallLiteralValue)
  VM_OP_LOAD_VAR_1          = 0x1, // (+ 4-bit variable index relative to stack pointer)
  VM_OP_LOAD_SCOPED_1       = 0x2, // (+ 4-bit scoped variable index)
  VM_OP_LOAD_ARG_1          = 0x3, // (+ 4-bit arg index)
  VM_OP_CALL_1              = 0x4, // (+ 4-bit index into short-call table)
  VM_OP_FIXED_ARRAY_NEW_1   = 0x5, // (+ 4-bit length)
  VM_OP_EXTENDED_1          = 0x6, // (+ 4-bit vm_TeOpcodeEx1)
  VM_OP_EXTENDED_2          = 0x7, // (+ 4-bit vm_TeOpcodeEx2)
  VM_OP_EXTENDED_3          = 0x8, // (+ 4-bit vm_TeOpcodeEx3)
  VM_OP_CALL_5              = 0x9, // (+ 4-bit arg count + 16-bit target)

  VM_OP_DIVIDER_1, // <-- ops after this point pop at least one argument (reg2)

  VM_OP_STORE_VAR_1         = 0xA, // (+ 4-bit variable index relative to stack pointer)
  VM_OP_STORE_SCOPED_1      = 0xB, // (+ 4-bit scoped variable index)
  VM_OP_ARRAY_GET_1         = 0xC, // (+ 4-bit item index)
  VM_OP_ARRAY_SET_1         = 0xD, // (+ 4-bit item index)
  VM_OP_NUM_OP              = 0xE, // (+ 4-bit vm_TeNumberOp)
  VM_OP_BIT_OP              = 0xF, // (+ 4-bit vm_TeBitwiseOp)

  VM_OP_END
} vm_TeOpcode;

typedef enum vm_TeOpcodeEx1 {
  VM_OP1_RETURN                  = 0x0,
  VM_OP1_THROW                   = 0x1,

  // (target) -> TsClosure
  VM_OP1_CLOSURE_NEW             = 0x2,

  // (TsClass, ...args) -> object
  VM_OP1_NEW                     = 0x3, // (+ 8-bit unsigned arg count. Target is dynamic)

  VM_OP1_RESERVED_VIRTUAL_NEW    = 0x4,

  VM_OP1_SCOPE_NEW               = 0x5, // (+ 8-bit variable count)

  // (value) -> mvm_TeType
  VM_OP1_TYPE_CODE_OF            = 0x6, // More efficient than VM_OP1_TYPEOF

  VM_OP1_POP                     = 0x7, // Pop one item

  VM_OP1_TYPEOF                  = 0x8,

  VM_OP1_OBJECT_NEW              = 0x9,

  // boolean -> boolean
  VM_OP1_LOGICAL_NOT             = 0xA,

  VM_OP1_DIVIDER_1, // <-- ops after this point are treated as having at least 2 stack arguments

  // (object, prop) -> any
  VM_OP1_OBJECT_GET_1            = 0xB, // (field ID is dynamic)

  // (string, string) -> string
  // (number, number) -> number
  VM_OP1_ADD                     = 0xC,

  // (any, any) -> boolean
  VM_OP1_EQUAL                   = 0xD,
  VM_OP1_NOT_EQUAL               = 0xE,

  // (object, prop, any) -> void
  VM_OP1_OBJECT_SET_1            = 0xF, // (field ID is dynamic)

  VM_OP1_END
} vm_TeOpcodeEx1;

// All of these operations are implemented with an 8-bit literal embedded into
// the instruction. The literal is stored in reg1.
typedef enum vm_TeOpcodeEx2 {
  VM_OP2_BRANCH_1            = 0x0, // (+ 8-bit signed offset)

  VM_OP2_STORE_ARG           = 0x1, // (+ 8-bit unsigned arg index)
  VM_OP2_STORE_SCOPED_2      = 0x2, // (+ 8-bit unsigned scoped variable index)
  VM_OP2_STORE_VAR_2         = 0x3, // (+ 8-bit unsigned variable index relative to stack pointer)
  VM_OP2_ARRAY_GET_2_RESERVED = 0x4, // (+ 8-bit unsigned field index)
  VM_OP2_ARRAY_SET_2_RESERVED = 0x5, // (+ 8-bit unsigned field index)

  VM_OP2_DIVIDER_1, // <-- ops before this point pop from the stack into reg2

  VM_OP2_JUMP_1              = 0x6, // (+ 8-bit signed offset)
  VM_OP2_CALL_HOST           = 0x7, // (+ 8-bit arg count + 8-bit unsigned index into resolvedImports)
  VM_OP2_CALL_3              = 0x8, // (+ 8-bit unsigned arg count. Target is dynamic)
  VM_OP2_CALL_6              = 0x9, // (+ 8-bit index into short-call table)

  VM_OP2_LOAD_SCOPED_2       = 0xA, // (+ 8-bit unsigned scoped variable index)
  VM_OP2_LOAD_VAR_2          = 0xB, // (+ 8-bit unsigned variable index relative to stack pointer)
  VM_OP2_LOAD_ARG_2          = 0xC, // (+ 8-bit unsigned arg index)

  VM_OP2_EXTENDED_4          = 0xD, // (+ 8-bit unsigned vm_TeOpcodeEx4)

  VM_OP2_ARRAY_NEW           = 0xE, // (+ 8-bit capacity count)
  VM_OP2_FIXED_ARRAY_NEW_2   = 0xF, // (+ 8-bit length count)

  VM_OP2_END
} vm_TeOpcodeEx2;

// Most of these instructions all have an embedded 16-bit literal value
typedef enum vm_TeOpcodeEx3 {
  // Note: Pop[0] can be used as a single-byte NOP instruction
  VM_OP3_POP_N               = 0x0, // (+ 8-bit pop count) Pops N items off the stack
  VM_OP3_SCOPE_DISCARD       = 0x1, // Set the closure reg to undefined
  VM_OP3_SCOPE_CLONE         = 0x2,
  VM_OP3_AWAIT               = 0x3, // (no literal operands)
  VM_OP3_AWAIT_CALL          = 0x4, // (+ 8-bit arg count)
  VM_OP3_ASYNC_RESUME        = 0x5, // (no literal operands)

  VM_OP3_RESERVED_3          = 0x6,

  VM_OP3_DIVIDER_1, // <-- ops before this point are miscellaneous and don't automatically get any literal values or stack values

  VM_OP3_JUMP_2              = 0x7, // (+ 16-bit signed offset)
  VM_OP3_LOAD_LITERAL        = 0x8, // (+ 16-bit value)
  VM_OP3_LOAD_GLOBAL_3       = 0x9, // (+ 16-bit global variable index)
  VM_OP3_LOAD_SCOPED_3       = 0xA, // (+ 16-bit scoped variable index)

  VM_OP3_DIVIDER_2, // <-- ops after this point pop an argument into reg2

  VM_OP3_BRANCH_2            = 0xB, // (+ 16-bit signed offset)
  VM_OP3_STORE_GLOBAL_3      = 0xC, // (+ 16-bit global variable index)
  VM_OP3_STORE_SCOPED_3      = 0xD, // (+ 16-bit scoped variable index)

  VM_OP3_OBJECT_GET_2        = 0xE, // (+ 16-bit property key)
  VM_OP3_OBJECT_SET_2        = 0xF, // (+ 16-bit property key)

  VM_OP3_END
} vm_TeOpcodeEx3;

// This is a bucket of less frequently used instructions that didn't fit into
// the other opcode ranges. We can put up to 256 opcodes here.
typedef enum vm_TeOpcodeEx4 {
  VM_OP4_START_TRY           = 0x00, // (+ 16-bit label to the catch block)
  VM_OP4_END_TRY             = 0x01, // (No literal operands)
  VM_OP4_OBJECT_KEYS         = 0x02, // (No literal operands)
  VM_OP4_UINT8_ARRAY_NEW     = 0x03, // (No literal operands)

  // (constructor, props) -> TsClass
  VM_OP4_CLASS_CREATE        = 0x04, // Creates TsClass (does not in instantiate a class)

  VM_OP4_TYPE_CODE_OF        = 0x05, // Opcode for mvm_typeOf

  VM_OP4_LOAD_REG_CLOSURE    = 0x06, // (No literal operands)

  VM_OP4_SCOPE_PUSH          = 0x07, // (+ 8-bit unsigned slot count) also sets last slot to parent scope
  VM_OP4_SCOPE_POP           = 0x08, // Sets the closure reg to the parent of the current closure

  VM_OP4_ASYNC_START         = 0x09, // + 7-bit closure slot count and 1-bit flag for parent-capturing.
  VM_OP4_ASYNC_RETURN        = 0x0A, // (No literal operands)

  VM_OP4_END
} vm_TeOpcodeEx4;


// Number operations. These are operations which take one or two arguments from
// the stack and coerce them to numbers. Each of these will have two
// implementations: one for 32-bit int, and one for 64-bit float.
typedef enum vm_TeNumberOp {

  // (number, number) -> boolean
  VM_NUM_OP_LESS_THAN        = 0x0,
  VM_NUM_OP_GREATER_THAN     = 0x1,
  VM_NUM_OP_LESS_EQUAL       = 0x2,
  VM_NUM_OP_GREATER_EQUAL    = 0x3,

  // (number, number) -> number
  VM_NUM_OP_ADD_NUM          = 0x4,
  VM_NUM_OP_SUBTRACT         = 0x5,
  VM_NUM_OP_MULTIPLY         = 0x6,
  VM_NUM_OP_DIVIDE           = 0x7,
  VM_NUM_OP_DIVIDE_AND_TRUNC = 0x8, // Represented in JS as `x / y | 0`
  VM_NUM_OP_REMAINDER        = 0x9,
  VM_NUM_OP_POWER            = 0xA,

  VM_NUM_OP_DIVIDER, // <-- ops after this point are unary

  // number -> number
  VM_NUM_OP_NEGATE           = 0xB,
  VM_NUM_OP_UNARY_PLUS       = 0xC,

  VM_NUM_OP_END
} vm_TeNumberOp;

// Bitwise operations:
typedef enum vm_TeBitwiseOp {
  // (bits, bits) -> bits
  VM_BIT_OP_SHR_ARITHMETIC = 0x0, // Aka signed shift right. Aka sign-propagating right shift.
  VM_BIT_OP_SHR_LOGICAL    = 0x1, // Aka unsigned shift right. Aka zero-fill right shift.
  VM_BIT_OP_SHL            = 0x2, // Shift left

  VM_BIT_OP_END_OF_SHIFT_OPERATORS, // <-- ops before this point need their operand in the 0-32 range

  VM_BIT_OP_OR             = 0x3,
  VM_BIT_OP_AND            = 0x4,
  VM_BIT_OP_XOR            = 0x5,

  VM_BIT_OP_DIVIDER_2, // <-- ops after this point are unary

  // bits -> bits
  VM_BIT_OP_NOT            = 0x6,

  VM_BIT_OP_END
} vm_TeBitwiseOp;

// vm_TeSmallLiteralValue : 4-bit enum
//
// Note: Only up to 16 values are allowed here.
typedef enum vm_TeSmallLiteralValue {
  VM_SLV_DELETED         = 0x0,
  VM_SLV_UNDEFINED       = 0x1,
  VM_SLV_NULL            = 0x2,
  VM_SLV_FALSE           = 0x3,
  VM_SLV_TRUE            = 0x4,
  VM_SLV_INT_MINUS_1     = 0x5,
  VM_SLV_INT_0           = 0x6,
  VM_SLV_INT_1           = 0x7,
  VM_SLV_INT_2           = 0x8,
  VM_SLV_INT_3           = 0x9,
  VM_SLV_INT_4           = 0xA,
  VM_SLV_INT_5           = 0xB,
} vm_TeSmallLiteralValue;
