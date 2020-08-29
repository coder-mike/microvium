
exports.instructionSetDocumentation = {
  ['ArrayNew']: {
    description: 'Creates a new JavaScript array.',
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
        payloads: [
          {
            name: 'length',
            type: 'UInt8',
            description: 'The (fixed) length of the array'
          }
        ]
      },
      {
        category: 'vm_TeOpcodeEx2',
        op: 'VM_OP2_ARRAY_NEW',
        description: `
          Creates an array with a dynamic length.
        `,
        payloads: [
          {
            name: 'capacity',
            type: 'UInt8',
            description: 'The capacity of the array (amount of space initially allocated)'
          }
        ]
      },
    ]
  }
};