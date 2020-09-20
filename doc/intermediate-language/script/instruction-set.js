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

      ### Typical Behavior

      For typical function call, the callee must push the function reference
      onto the stack, followed by each of the arguments, in order. The call
      operation pushes 3 words to the stack to save the current registers, and
      then passes control to the given function. This typical behavior is what's
      shown in the diagram below. There are variations on this typical behavior,
      as discussed below.

      ### Host Functions

      Calls to host functions (known as "native calls") do not save the current
      registers on the Microvium stack -- they instead save them on the C stack,
      and then they call C function pointer corresponding to the function
      reference. During the execution of the C function, the Microvium program
      counter is \`null\` to indicate that Microvium does not have control.

      ### Reentrancy

      Microvium is reentrant -- host functions called by Microvium may in turn
      call Microvium functions. The \`null\` program counter register signals
      the boundary between the two. If the [Return](#Return) operation uncovers
      a \`null\` PC, it will end the current Microvium run loop and return to
      the host. When the host calls Microvium, Microvium's first action is to
      push its current registers states, which include the \`null\` PC.

      ### Short Calls

      The naive bytecode representation of a JavaScript call operation is quite
      verbose, involving a 24-bit [Lit](#VM_OP3_LOAD_LITERAL) operation to push
      the function pointer, followed by a 16-bit [Call](#VM_OP2_CALL_3)
      operation with the embedded argument count -- a total of 5 bytes.

      The short-call ([VM_OP_CALL_1](#VM_OP_CALL_1)) bytecode operation is
      single-byte call form that exists for the most frequent calls. It has a
      4-bit opcode followed by a 4-bit reference to an entry in the global
      short-call table, where each entry in the table embeds both the function
      reference and the argument count for the corresponding call operation.

      Short-call table entries can reference either Microvium or host functions.
      A maximum of 16 short-call table entries are possible -- it's up to the
      optimization pass to enforce this.
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
    }],
    variadic: true,
    pushedResults: [{
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
      label: 'Frame base',
      description: ''
    }, {
      label: 'Arg count',
      description: ''
    }, {
      label: 'PC',
      description: ''
    }],
    staticInformation: [{
      name: 'shortCall',
      type: 'boolean',
      description: 'True if the operation should be emitted as a [short call](#short-calls). If true, the call [target](#Call_target) must also be specified.'
    }, {
      name: 'target',
      type: 'Value?',
      description: 'The call target '
    }],
    bytecodeRepresentations: [{
      category: 'vm_TeOpcode',
      op: 'VM_OP_CALL_1',
      description: 'A call operation where the target and argument count are determined by the corresponding entry in the short-call table (see `BCS_SHORT_CALL_TABLE`).' +
        '\n\nWhen using this form, the function reference must NOT be pushed onto the stack, and the correct [Return](#Return) bytecode form must be chosen.',
      payloads: [{
        name: 'index',
        type: 'UInt4',
        description: 'Index into short-call table'
      }]
    }, {
      category: 'vm_TeOpcodeEx2',
      op: 'VM_OP2_CALL_2',
      description: 'A call operation where the target is known to be a Microvium function and the identity of the function is known.' +
        '\n\nWhen using this form, the function reference must NOT be pushed onto the stack, and the correct [Return](#Return) bytecode form must be chosen.',
      payloads: [{
        name: 'argCount',
        type: 'UInt8',
        description: 'Argument count'
      }, {
        name: 'target',
        type: 'UInt16',
        description: 'Bytecode address of target function'
      }]
    }, {
      category: 'vm_TeOpcodeEx2',
      op: 'VM_OP2_CALL_3',
      description: 'A call operation where the target is dynamically known.' +
        '\n\nWhen using this form, the function reference MUST be pushed onto the stack, and the correct [Return](#Return) bytecode form must be chosen to pop it.',
      payloads: [{
        name: 'argCount',
        type: 'UInt8',
        description: 'Argument count'
      }]
    }, {
      category: 'vm_TeOpcodeEx2',
      op: 'VM_OP2_CALL_HOST',
      description: 'A call operation where the target is known to be a host function' +
        '\n\nWhen using this form, the function reference must NOT be pushed onto the stack, and the correct [Return](#Return) bytecode form must be chosen.',
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
      A \`Closure\` in Microvium is a callable object which internally
      references a \`target\` function, a \`scope\`, and an \`props\` object for
      property storage.

      Writing to the properties of the closure effectively writes to the
      properties of the given object. Calling the closure is effectively calling
      the given function, except that the first argument is replaced with the
      given scope.

      A closure takes 8 bytes on the runtime heap, including the allocation header.

      Closures are logically immutable, in the sense that there are no operators
      that can change one of the 3 internal fields of a closure (scope, target, or props).

      The identity of a closure is determined by the value of the props field.` ,
    literalOperands: [],
    poppedArgs: [{
      label: 'props',
      type: 'object',
      description: 'The object on which to store the closure\'s properties, and provide the closure\'s identity. If the program is statically determined never to read or write properties to the closure, and to never use the identity of the closure, the `props` value is allowed to be `undefined`.'
    }, {
      label: 'target',
      type: 'function',
      description: 'The function to associate with the closure. May be a host function or internal function.'
    }, {
      label: 'scope',
      type: 'any',
      description: 'Any value to use as the closure scope. This value is passed blindly as the first argument to the function. In typical use, the scope of a closure will be an array, where the first element in the array refers to the outer scope.'
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