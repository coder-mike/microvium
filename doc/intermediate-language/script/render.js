const { DEFAULTS } = require("ts-node");

const opcodes = exports.opcodes;
const instructionSetDocumentation = exports.instructionSetDocumentation;

let currentElement = document.body;

const colors = {
  darkBlue: { fill: '#2656a3', stroke: '#1c3f78', text: 'white' },
  lightBlue: { fill: '#cfe1ff', stroke: '#9db0d1', text: 'black' },
  darkBlue2: { fill: '#266fa3', stroke: '#1c5378', text: 'white' }
}

for (const opcode of Object.keys(opcodes)) {
  title('h2', opcode, opcode);
  const doc = instructionSetDocumentation[opcode];
  if (!doc) continue;
  text('p', doc?.description);
  if (doc.poppedArgs) {
    title('h3', 'Pops');
    if (doc.poppedArgs.length > 0)
      table(undefined, doc.poppedArgs.map((arg, i) => [i + 1, arg.label, arg.type, renderMarkdown(arg.description)]));
    else
      text('p', 'None');
  }
  if (doc.pushedResult) {
    title('h3', 'Pushes');
    if (doc.pushedResult.length > 0)
      table(undefined, doc.pushedResult.map((x, i) => [i + 1, x.label, x.type, renderMarkdown(x.description)]));
    else
     text('p', 'None');
  }

  if (doc.staticInformation) {
    title('h3', 'Static Information (Optional)');
    table(['Name', 'Type', 'Description'], doc.staticInformation.map(x => [x.name, x.type, renderMarkdown(x.description)]));
  }

  if (doc.bytecodeRepresentations) {
    title('h3', 'Bytecode Representations');
    table(['Format', 'Description'], doc.bytecodeRepresentations.map(bcr => [
      renderBytecodeFormat(bcr),
      () => {
        text('div', `<span style="text-size:0.8em">${bcr.description}</span>`);
        container('dl', () => {
          for (const payload of bcr.payloads) {
            container('dt', `<code>${payload.type}</code> ${payload.name}`)
            container('dd', payload.description)
          }
        });
      }
    ]));
  }
}

function title(tag, text, id) {
  container(tag, () => {
    currentElement.innerHTML = text;
    if (id) currentElement.id = id
  });
}
function text(tag, text) {
  if (!text) return;
  container(tag, () => currentElement.innerHTML = text);
}

function container(tag, contents) {
  if (!tag) {
    console.assert(typeof contents !== 'function');
    const element = document.createTextNode(contents);
    parent.appendChild(element);
    return;
  }

  const element = document.createElement(tag);
  const parent = currentElement;
  currentElement = element;
  parent.appendChild(element);
  if (typeof contents === 'function')
    contents(element);
  else
     element.innerHTML = contents;
  currentElement = parent;
}

function table(headings, rows) {
  container('table', () => {
    if (headings) {
      container('tr', () => {
        for (const heading of headings) {
          container('th', heading);
        }
      })
    }
    for (const row of rows) {
      container('tr', () => {
        for (const cell of row) {
          container('td', cell);
        }
      });
    }
  })
}

function renderBytecodeFormat(bcr) {
  const bitSize = 16;
  const titleHeight = 30;
  const typeLabelHeight = 16;
  const payloadNameHeight = 26;

  return container => {
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    svg.setAttribute('width', bitSize * (1 + 32));
    svg.setAttribute('height', titleHeight + typeLabelHeight + bitSize * 2 + payloadNameHeight);

    const title = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    svg.appendChild(title);
    title.setAttribute('x', bitSize / 2);
    title.setAttribute('y', 20);
    title.style.fontSize = '1em';
    title.style.fontWeight = 'bold';
    title.style.fontFamily = 'monospace';
    title.textContent = `${bcr.category}.${bcr.op}`;


    const bitGroup = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    svg.appendChild(bitGroup);
    bitGroup.setAttribute('transform', `translate(${bitSize / 2},${titleHeight + typeLabelHeight + bitSize / 2})`);

    let cursorBit = 0;

    if (bcr.category === 'vm_TeOpcode') {
      const firstNibble = exports.vm_TeOpcode[bcr.op];
      const signed = false;
      renderBits(cursorBit, 4, firstNibble, signed, colors.darkBlue, 'opcode');
      cursorBit += 4;
    } else {
      let firstNibble;
      switch (bcr.category) {
        case 'vm_TeOpcodeEx1': firstNibble = exports.vm_TeOpcode.VM_OP_EXTENDED_1; break;
        case 'vm_TeOpcodeEx2': firstNibble = exports.vm_TeOpcode.VM_OP_EXTENDED_2; break;
        case 'vm_TeOpcodeEx3': firstNibble = exports.vm_TeOpcode.VM_OP_EXTENDED_3; break;
        case 'vm_TeNumberOp': firstNibble = exports.vm_TeOpcode.VM_OP_NUM_OP; break;
        case 'vm_TeBitwiseOp': firstNibble = exports.vm_TeOpcode.VM_OP_BIT_OP; break;
        default: throw new Error('Unrecognized category');
      }
      const secondNibble = exports[bcr.category][bcr.op];
      const signed = false;
      renderBits(cursorBit, 4, firstNibble, signed, colors.darkBlue, 'opcode');
      renderBits(cursorBit + 4, 4, secondNibble, signed, colors.darkBlue2, 'opcode');
      cursorBit += 8;
    }

    for (const payload of bcr.payloads) {
      const { sizeBits, signed } = typeInfo(payload.type);
      renderBits(cursorBit, sizeBits, '.', signed, colors.lightBlue, payload.name, payload.type);

      cursorBit += sizeBits;
    }

    container.appendChild(svg);

    function renderBits(offsetBits, bitCount, value, signed, color, label, typeName) {
      if (signed) throw new Error('Signed not supported yet')
      for (let i = 0; i < bitCount; i++) {
        let bitValue;
        if (value === '.')
          bitValue = '.';
        else
          bitValue = value & (1 << (bitCount - i - 1)) ? 1 : 0;
        renderBit(offsetBits + i, bitValue, color)
      }

      renderMarker(offsetBits);
      renderMarker(offsetBits + bitCount);
      renderPayloadName(offsetBits, bitCount, label);
      typeName && renderTypeName(offsetBits, bitCount, typeName);
    }

    function renderPayloadName(bitStart, bitCount, text) {
      const label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      bitGroup.appendChild(label);
      label.setAttribute('x', (bitStart + bitCount / 2) * bitSize);
      label.setAttribute('y', bitSize * 1.6);
      label.style.textAnchor = 'middle';
      label.style.alignmentBaseline = 'middle';
      label.style.fontSize = 10;
      label.style.fontFamily = 'monospace';
      label.setAttribute('fill', 'black');
      label.textContent = text;
    }

    function renderTypeName(bitStart, bitCount, text) {
      const background = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      const space = 2;
      bitGroup.appendChild(background);
      background.setAttribute('x', bitStart * bitSize + space);
      background.setAttribute('y', - typeLabelHeight + space);
      background.setAttribute('width', bitCount * bitSize - space * 2);
      background.setAttribute('height', typeLabelHeight - space * 2);
      background.setAttribute('fill', 'rgba(0,0,0,0.1)')

      const label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      bitGroup.appendChild(label);
      label.setAttribute('x', (bitStart + bitCount / 2) * bitSize);
      label.setAttribute('y', - typeLabelHeight / 2 + 1);
      label.style.textAnchor = 'middle';
      label.style.alignmentBaseline = 'middle';
      label.style.fontSize = 10;
      label.style.fontFamily = 'monospace';
      label.style.fontWeight = 'bold';
      label.setAttribute('fill', 'black');
      label.textContent = text;
    }

    function renderMarker(bitOffset) {
      const marker = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      bitGroup.appendChild(marker);
      marker.setAttribute('x1', bitOffset * bitSize)
      marker.setAttribute('y1', bitSize * 1.2)
      marker.setAttribute('x2', bitOffset * bitSize)
      marker.setAttribute('y2', bitSize * 2);
      marker.setAttribute('stroke', 'black');
      marker.setAttribute('stroke-width', '0.5');
    }

    function renderBit(bitOffset, bitValue, color) {
      const bit = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      bitGroup.appendChild(bit);
      bit.setAttribute('x', bitOffset * bitSize);
      bit.setAttribute('y', 0);
      bit.setAttribute('width', bitSize);
      bit.setAttribute('height', bitSize);
      bit.setAttribute('fill', color.fill);
      bit.setAttribute('stroke', color.stroke);
      bit.setAttribute('stroke-width', '1');

      const label = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      bitGroup.appendChild(label);
      label.setAttribute('x', bitOffset * bitSize + bitSize / 2);
      label.setAttribute('y', bitSize / 2 + 1);
      label.style.textAnchor = 'middle';
      label.style.alignmentBaseline = 'middle';
      label.style.fontSize = 10;
      label.style.fontFamily = 'monospace';
      label.setAttribute('fill', color.text);
      if (bitValue === '.')
        label.textContent = '•';
      else
        label.textContent = bitValue ? '1' : '0';
    }
  };
}

function typeInfo(type) {
  switch (type) {
    case 'UInt4': return { sizeBits: 4, signed: false };
    case 'SInt4': return { sizeBits: 4, signed: true };
    case 'Int4': return { sizeBits: 4, signed: true };
    case 'UInt8': return { sizeBits: 8, signed: false };
    case 'SInt8': return { sizeBits: 8, signed: true };
    case 'Int8': return { sizeBits: 8, signed: true };
    case 'UInt16': return { sizeBits: 16, signed: false };
    case 'SInt16': return { sizeBits: 16, signed: true };
    case 'Int16': return { sizeBits: 16, signed: true };
    default: throw new Error('Unknown type');
  }
}

function renderMarkdown(input) {
  return marked(input.trim());
}