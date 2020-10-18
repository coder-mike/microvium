exports.additionalBeginningSections = [{
  title: '',
  content: `
    This file documents the IL instruction set and its corresponding bytecode
    representations.

    "IL" is a dynamically-typed intermediate language, represented in either
    JSON or text format. It is the result of first stage of compilation, where
    the source text is translated to IL. IL can represent both instructions and
    data, so it used to represent the full state of a VM snapshot.

    "Bytecode" is the name given to the binary form of IL. It is actually a
    completely separate language, with a larger instruction set and different
    semantics, but there is more-or-less a straightforward relationship between
    IL instructions and their corresponding bytecode representations, so this
    document groups them together and describes the difference in semantics
    where appropriate.
  `
}, {
  title: 'Static Information',
  content: `
    Some of the opcodes described below have a "Static information" section.
    Static information is additional information that can be derived by static
    analysis in order to produce more efficient bytecode. In cases where there
    are multiple possible bytecode representations for an IL operation, the
    static information is one mechanism used by the bytecode emitter to
    choose the most suitable bytecode form.

    The original intent of static information is that a program with static
    information must behave exactly the same way if the static information is
    all removed (but not necessarily if just some if it is removed), so that the
    JS-implemented VM can directly execute IL without consulting the static
    information.

    However, there are cases that break this intended invariant. In particular,
    the semantics of function calls change based on static information in a way
    that is not compatible with the semantics of the original IL.

    A typical compilation pipeline will involve:

      1. Translate the source text to IL.
      2. (Optional) Perform static analysis and produce {IL + static information}
      3. Emit bytecode from the {IL + optional static information}
  `
}];

exports.instructionSetDocumentation = {
  /* ----------------------------------------------------------------------- */
  /*
  ['ExampleStructure']: {
    description: '',
    longDescription: ``,
    literalOperands: [{
      name: '',
      type: '',
      description: ''
    }],
    poppedArgs: [],
    pushedResults: [{
      label: '',
      type: '',
      description: ''
    }],
    staticInformation: [{
      name: '',
      type: '',
      description: ''
    }],
    bytecodeRepresentations: [{
      category: '',
      op: '',
      description: '',
      payloads: [{
        name: '',
        type: '',
        description: ''
      }]
    }]
  },
  */
  /* ----------------------------------------------------------------------- */
  ['ArrayNew']: {
    description: 'Creates a new JavaScript array.',
    literalOperands: [],
    poppedArgs: [],
    pushedResults: [{
      label: 'array',
      type: 'ShortPtr',
      description: 'A pointer to the new array'
    }],
    staticInformation: [
      {
        name: 'minCapacity',
        type: 'UInt8',
        description: `
          The initial capacity of the array. If the array is fixed length, this
          is the final length of the array.
        `
      },
      {
        name: 'fixedLength',
        type: 'boolean',
        description: `
          If true, the emitted instruction will be \`VM_OP_FIXED_ARRAY_NEW_1\`
          or \`VM_OP2_FIXED_ARRAY_NEW_2\`. This is only valid if the array's
          length will not change
        `
      }
    ],
    bytecodeRepresentations: [
      {
        category: 'vm_TeOpcode',
        op: 'VM_OP_FIXED_ARRAY_NEW_1',
        description: `
          Creates an array of a fixed length. The array is not frozen, but it is
          illegal for user code to attempt to extend the array. The resulting
          array does not support non-index properties.
        `,
        payloads: [
          {
            name: 'length',
            type: 'UInt4',
            description: 'The (fixed) length of the array'
          }
        ]
      },
      {
        category: 'vm_TeOpcodeEx2',
        op: 'VM_OP2_FIXED_ARRAY_NEW_2',
        description: `
          Creates an array of a fixed length. The array is not frozen, but it is
          illegal for user code to attempt to extend the array. The resulting
          array does not support non-index properties.
        `,
        payloads: [{
          name: 'length',
          type: 'UInt8',
          description: 'The (fixed) length of the array'
        }]
      },
      {
        category: 'vm_TeOpcodeEx2',
        op: 'VM_OP2_ARRAY_NEW',
        description: `
          Creates an array with a dynamic length.
        `,
        payloads: [{
          name: 'capacity',
          type: 'UInt8',
          description: 'The capacity of the array (amount of space initially allocated)'
        }]
      },
    ]
  },
  /* ----------------------------------------------------------------------- */
  ['BinOp']: {
    description: 'Performs an operation with two operands',
    literalOperands: [{
      name: 'op',
      type: 'Operator',
      description: 'One of `+`, `-`, `/`, `DIVIDE_AND_TRUNC`, `%`, `*`, `**`, `&`, `|`, `>>`, `>>>`, `<<`, `^`, `===`, `!==`, `>`, `<`, `>=`, `<=`' +
        '\n\nThese operations have the same meaning as the corresponding operation in JavaScript, except `DIVIDE_AND_TRUNC`, which is equivalent to the JavaScript `left / right | 0` and is used to represent integer division.' +
        '\n\nNote that `&&` and `||` are not operators. During compilation these are lowered to Branch operations because they are short-circuiting operators.' +
        '\n\nNote that `==` and `!=` are not allowed.' +
        '\n\nNote that `in` and `instanceof` are not yet supported.'
    }],
    poppedArgs: [{
      label: 'right',
      type: 'Value',
      description: 'Second operand'
    }, {
      label: 'left',
      type: 'Value',
      description: 'First operand'
    }],
    pushedResults: [{
      label: 'result',
      type: 'Value',
      description: 'The result of the binary operation'
    }],
    bytecodeRepresentations: [{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_LESS_THAN',
      description: '`<`',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_GREATER_THAN',
      description: '`>`',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_LESS_EQUAL',
      description: '`<=`',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_GREATER_EQUAL',
      description: '`>=`',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_ADD_NUM',
      description: 'Converts its arguments to numbers and then performs `+` on them. Intended to be used to implement the `+` operator for cases where the input types are already known to be numbers.\n\nSee also `vm_TeOpcodeEx1.VM_OP1_ADD`.',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_SUBTRACT',
      description: '`-`',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_MULTIPLY',
      description: '`*`',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_DIVIDE',
      description: 'JavaScript `/` operation.\n\nNote that this is very inefficient because the operation is done using 64-bit floating pointer arithmetic. Instead use `vm_TeNumberOp.VM_NUM_OP_DIVIDE_AND_TRUNC` where possible.',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_DIVIDE_AND_TRUNC',
      description: 'Implements the effect of `x / y | 0` — performing a number division operation and truncating the result to a 32-bit signed integer. This is much more efficient than `vm_TeNumberOp.VM_NUM_OP_DIVIDE` because it generally requires no 64-bit floating point operations.',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_REMAINDER',
      description: '`%`',
      payloads: []
    },{
      category: 'vm_TeNumberOp',
      op: 'VM_NUM_OP_POWER',
      description: '`**`',
      payloads: []
    },{
      category: 'vm_TeOpcodeEx1',
      op: 'VM_OP1_ADD',
      description: 'JavaScript `+` operator, which can perform either string concatenation or numeric addition. If the operands are known to be numbers, use `vm_TeNumberOp.VM_NUM_OP_ADD_NUM` instead for efficiency.',
      payloads: []
    },{
      category: 'vm_TeBitwiseOp',
      op: 'VM_BIT_OP_SHR_ARITHMETIC',
      description: '`>>` — Sign-propagating right-shift.',
      payloads: []
    },{
      category: 'vm_TeBitwiseOp',
      op: 'VM_BIT_OP_SHR_LOGICAL',
      description: '`>>>` — Zero-filling right-shift.',
      payloads: []
    },{
      category: 'vm_TeBitwiseOp',
      op: 'VM_BIT_OP_SHL',
      description: '`<<` — Bitwise left shift',
      payloads: []
    },{
      category: 'vm_TeBitwiseOp',
      op: 'VM_BIT_OP_OR',
      description: '`|` — Bitwise OR',
      payloads: []
    },{
      category: 'vm_TeBitwiseOp',
      op: 'VM_BIT_OP_AND',
      description: '`&` — Bitwise AND',
      payloads: []
    },{
      category: 'vm_TeBitwiseOp',
      op: 'VM_BIT_OP_XOR',
      description: '`^` — Bitwise XOR',
      payloads: []
    }]
  },
  /* ----------------------------------------------------------------------- */
  ['Branch']: {
    description: ['Jumps the program counter to one of two target labels (blocks) depending on the truthiness of the condition value.',
      'Note: the bytecode representations of the branch instruction only have a single target, corresponding to the `true` path. If the label is false, control falls through to the next instruction. A full IL branch instruction can be implemented by a Branch bytecode instruction followed by a Jump bytecode instruction',
      'Note: target labels must reference blocks in the same function as the branch instruction.'
    ].join('\n\n'),
    literalOperands: [{
      name: 'trueTarget',
      type: 'Label',
      description: 'Block to jump if condition is true'
    }, {
      name: 'falseTarget',
      type: 'Label',
      description: 'Block to jump if condition is false'
    }],
    poppedArgs: [{
      label: 'condition',
      type: 'Value',
      description: ''
    }],
    pushedResults: [],
    bytecodeRepresentations: [{
      category: 'vm_TeOpcodeEx2',
      op: 'VM_OP2_BRANCH_1',
      description: 'Offset the program counter by the given amount if the popped condition is truthy.',
      payloads: [{
        name: 'offset',
        type: 'SInt8',
        description: 'Amount to offset the program counter by, measured in bytes relative to the end of the branch instruction.'
      }]
    }, {
      category: 'vm_TeOpcodeEx3',
      op: 'VM_OP3_BRANCH_2',
      description: 'Offset the program counter by the given amount if the popped condition is truthy.',
      payloads: [{
        name: 'offset',
        type: 'SInt16',
        description: 'Amount to offset the program counter by, measured in bytes relative to the end of the branch instruction.'
      }]
    }]
  },
  /* ----------------------------------------------------------------------- */
  ['Call']: {
    description: 'The function call operator',
    longDescription: `
      See also [Return](#Return).

      ### Basic Behavior

      For the basic function call, the callee must push the
      function reference and each of the arguments onto
      the stack in order. The CALL operation pushes
      3-4 words to the stack to save the current registers, and then passes
      control to the given function.

      The CALL operation also sets flags in the VM state to indicate what
      dynamic elements were pushed onto the stack. When the matching RETURN
      operation is later executed, it will consult these flags to decide what to
      pop off the stack (so far, this is only the \`scope\` register).

      This basic behavior is what's shown in the
      diagram below. There are variations on this basic behavior, as discussed
      below.

      \`VM_OP2_CALL_3\` is the most general bytecode form of a call, but the
      expectation is that \`VM_OP_CALL_5\` and \`VM_OP2_CALL_6\` will be the most common
      manifestations of a call instruction in a typical script, after optimization.

      ### Host Functions

      Calls to host functions (known as "native calls") do not save the current
      registers on the Microvium stack -- they instead save them on the C stack,
      and then they call C function pointer corresponding to the function
      reference, and set the \`AF_CALLED_FROM_EXTERNAL\` flag.

      ### Reentrancy

      Microvium is reentrant -- host functions called by Microvium may in turn
      call Microvium functions. The \`AF_CALLED_FROM_EXTERNAL\` VM flag signals
      the boundary between the two. When [RETURNing](#Return) from a context with
      \`AF_CALLED_FROM_EXTERNAL\`, it will end the current Microvium run loop and return to
      the host.

      ### Short Calls

      The naive bytecode representation of a JavaScript call operation is quite
      verbose, involving a 24-bit [Lit](#VM_OP3_LOAD_LITERAL) operation to push
      the function pointer, followed by a 16-bit [Call](#VM_OP2_CALL_3)
      operation with the embedded argument count -- a total of 5 bytes.

      The short-call ([VM_OP_CALL_1](#VM_OP_CALL_1) and [VM_OP2_CALL_6](#VM_OP2_CALL_6)) bytecode operations are a
      1-2 byte call form that exists for the most frequent calls. They have a
      4- or 8-bit opcode followed by a 4- or 8-bit reference to an entry in the global
      short-call table, where each entry in the table embeds both the function
      reference and the argument count for the corresponding call operation as a
      3-byte structure. The space-savings comes primarily when there are multiple
      calls to the same function with the same number of arguments.

      Short-call table entries can reference either Microvium or host functions.
      A maximum of 256 short-call table entries are possible, with the first 16 being addressable
      with a single-byte CALL and the others addressable with a 2-byte CALL. It's up to the
      optimization pass to decide which call operations should be short-calls.

      For CALLs where the argument count and target are known, but the combination
      of target + argument count are only used up to 3 times in the application,
      a \`VM_OP_CALL_5\` call may be more efficient.
    `,
    literalOperands: [{
      name: 'argumentCount',
      type: 'Count',
      description: 'The number of arguments to pass to the callee'
    }],
    poppedArgs: [{
      label: '...',
    }, {
      type: 'Value',
      label: 'Argument 3',
    }, {
      type: 'Value',
      label: 'Argument 2',
    }, {
      type: 'Value',
      label: 'Argument 1',
    }, {
      type: 'Pointer',
      label: 'Function',
    }, {
      type: 'Value',
      label: 'this',
    }],
    variadic: true,
    pushedResults: [{
      type: 'Value',
      label: 'this',
    }, {
      type: 'Pointer',
      label: 'Function',
    }, {
      type: 'Value',
      label: 'Argument 1',
    }, {
      type: 'Value',
      label: 'Argument 2',
    }, {
      type: 'Value',
      label: 'Argument 3',
    }, {
      label: '...',
    }, {
      label: 'Prev. frame base',
      description: ''
    }, {
      label: 'Prev. arg count',
      description: ''
    }, {
      label: 'Prev. PC',
      description: ''
    }],
    staticInformation: [{
      name: 'shortCallIndex',
      type: 'number?',
      description: 'Defined as an integer in the range (0..255) if the operation should be emitted as a [short call](#short-calls), or `undefined` if left as a normal call. If defined, the call [target](#Call_target) must also be specified.'
    }, {
      name: 'target',
      type: 'Value?',
      description: 'The call target '
    }],
    bytecodeRepresentations: [{
      category: 'vm_TeOpcode',
      op: 'VM_OP_CALL_1',
      description: 'A call operation where the target and argument count are determined by the corresponding entry in the short-call table (see `BCS_SHORT_CALL_TABLE`).' +
        '\n\nWhen using this form, the function reference must NOT be pushed onto the stack.',
      payloads: [{
        name: 'index',
        type: 'UInt4',
        description: 'Index into short-call table'
      }]
    }, {
      category: 'vm_TeOpcodeEx2',
      op: 'VM_OP2_CALL_6',
      description: 'A call operation where the target and argument count are determined by the corresponding entry in the short-call table (see `BCS_SHORT_CALL_TABLE`).' +
        '\n\nWhen using this form, the function reference must NOT be pushed onto the stack.',
      payloads: [{
        name: 'index',
        type: 'UInt8',
        description: 'Index into short-call table'
      }]
    }, {
      category: 'vm_TeOpcodeEx2',
      op: 'VM_OP2_CALL_3',
      description: 'A call operation where the target is dynamically known.' +
        '\n\nWhen using this form, the function reference MUST be pushed onto the stack.',
      payloads: [{
        name: 'argCount',
        type: 'UInt8',
        description: 'Argument count'
      }]
    }, {
      category: 'vm_TeOpcode',
      op: 'VM_OP_CALL_5',
      description: 'A call operation with a literal bytecode target and argument count, up to 15 arguments.' +
        '\n\nNote that the literal `target` must be a bytecode address.',
      payloads: [{
        name: 'argCount',
        type: 'UInt4',
        description: 'Number of arguments'
      }, {
        name: 'target',
        type: 'UInt16',
        description: 'Bytecode address of target function'
      }]
    }, {
      category: 'vm_TeOpcodeEx2',
      op: 'VM_OP2_CALL_HOST',
      description: 'A call operation where the target is known to be a host function' +
        '\n\nWhen using this form, the function reference must NOT be pushed onto the stack.',
      payloads: [{
        name: 'argCount',
        type: 'UInt8',
        description: 'Argument count'
      }, {
        name: 'index',
        type: 'UInt8',
        description: 'Index into import table (see `BCS_IMPORT_TABLE`)'
      }]
    }]
  },
  /* ----------------------------------------------------------------------- */
  ['ClosureNew']: {
    description: 'Creates a new closure object',
    longDescription: `
      A \`Closure\` in Microvium is a callable type which internally
      references a \`target\` function, a \`scope\`, and optionally a \`props\` object for
      property storage and a \`this\` value for \`this\` capture. (See
      \`TsClosure\` structure)

      Writing to the properties of the closure effectively writes to the
      properties of the given \`props\` object if it's provided. If it's not
      provided, it's illegal to get or set properties on the closure.

      Calling the closure is effectively calling
      the given \`target\` function, except that the \`scope\` and \`this_\` registers of
      the VM will adopt the \`scope\` and \`this_\` values from the closure. If a
      \`this_\` field is not part of the closure, the called function will adopt
      the \`this\` value specified by the calling instruction.

      A closure takes 6, 8, or 10 bytes on the runtime heap, including the
      allocation header, depending on which optional fields are included.

      The stack diagram below is for the case of a closure constructed with all
      4 fields, but it can be constructed also with just the first 2 or 3 fields.
      The fields are popped in the reverse order they appear in \`TsClosure\`.

      Closures are logically immutable, in the sense that there are no operators
      that can change one of the 4 internal fields of a closure (scope, target, props, or this).

      Closure equality is compared by reference equality of the \`TsClosure\` allocation.` ,
    literalOperands: [{
      name: 'fieldCount',
      type: 'Count',
      description: '2, 3, or 4. Indicates the number of fields included in the closure, of `target`, `scope`, `props`, and `this`. This number of fields will be popped off the stack in reverse order.'
    }],
    poppedArgs: [{
      label: 'props',
      type: 'object',
      description: 'The object on which to store the closure\'s properties, and provide the closure\'s identity. If the program is statically determined never to read or write properties to the closure, and to never use the identity of the closure, the `props` value is allowed to be `undefined`.'
    }, {
      label: 'this_',
      type: 'object',
      description: 'Value to pass as the `this_`.'
    }, {
      label: 'scope',
      type: 'any',
      description: 'Any value to use as the closure scope. This value is passed blindly as the first argument to the function. In typical use, the scope of a closure will be an array, where the first element in the array refers to the outer scope.'
    }, {
      label: 'target',
      type: 'function',
      description: 'The function to associate with the closure. May be a host function or internal function.'
    }],
    pushedResults: [{
      type: 'Closure',
      label: 'closure',
      description: 'The new closure'
    }],
    staticInformation: [],
    bytecodeRepresentations: [{
      category: 'vm_TeOpcodeEx1',
      op: 'VM_OP1_CLOSURE_NEW',
      description: 'Creates the new closure.',
      payloads: []
    }]
  },
  /* ----------------------------------------------------------------------- */
};