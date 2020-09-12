/*
 * This is a pure-JavaScript that renders the instruction set defined in
 * `instruction-set.js`.
 *
 * The general design of this file is imperative. The script iterates the
 * `opcodes`, and builds up the DOM tree as it goes. The `currentElement`
 * variable refers to the current DOM element. A number of imperative statements
 * like `title`, `text`, `table`, and `container` add the corresponding contents
 * to the current element.
 *
 * Some of these imperative functions are parameterized by their contents. For
 * example, `table` and `container` have accept a representation of what's
 * inside the table or container respectively. This representation is most often
 * a callback function which performs its own imperative statements and is
 * rendered in `renderNode`.
 */

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
  if (doc.description) {
    p(md(doc.description));
  }
  if (doc.literalOperands) {
    p(`<code>${opcode}(${doc.literalOperands.map(l => l.name).join(', ')})</code>`);
  }
  if (doc.literalOperands) {
    if (doc.literalOperands.length > 0) {
      container('dl', () => {
        for (const operand of doc.literalOperands) {
          container('dt', `<code>${operand.type}</code> ${operand.name}`)
          container('dd', md(operand.description))
        }
      })
    }
  }
  if (doc.longDescription) {
    p(md(doc.longDescription));
  }
  if (doc.poppedArgs || doc.pushedResults) {
    title('h3', 'Stack Effect');
    renderStackChange(doc)(currentElement);
    if (!doc.variadic) {
      if (doc.poppedArgs) {
        title('h4', 'Pops');
        p('In popping order:')
        if (doc.poppedArgs.length > 0) {
          container('dl', () => {
            for (const poppedArg of doc.poppedArgs) {
              container('dt', `<code>${poppedArg.type}</code> ${poppedArg.label}`)
              container('dd', md(poppedArg.description))
            }
          })
        } else
          p('Does not pop anything off the stack');
      }
      if (doc.pushedResults) {
        title('h4', 'Pushes');
        if (doc.pushedResults.length > 0) {
          container('dl', () => {
            for (const pushedResult of doc.pushedResults) {
              container('dt', `<code>${pushedResult.type}</code> ${pushedResult.label}`)
              container('dd', md(pushedResult.description))
            }
          })
        } else
          p('Does not push anything onto the stack');
      }
    }
  }

  if (doc.staticInformation) {
    title('h3', 'Static Information (Optional)');
    table(['Name', 'Type', 'Description'], doc.staticInformation.map(x => [
      () => {
        anchor(`${opcode}_${x.name}`);
        text(x.name);
      },
      x.type,
      md(x.description)
    ]));
  }

  if (doc.bytecodeRepresentations) {
    title('h3', 'Bytecode Representations');
    table(['Format', 'Description'], doc.bytecodeRepresentations.map(bcr => [
      () => renderBytecodeFormat(bcr),
      () => {
        container(`span`, md(bcr.description))
          .style.textSize = '0.8em';
        container('dl', () => {
          for (const payload of bcr.payloads) {
            container('dt', `<code>${payload.type}</code> ${payload.name}`)
            container('dd', md(payload.description))
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

function container(tag, contents) {
  if (arguments.length < 2) {
    throw new Error('Expected 2 args');
  }
  if (!tag) {
    console.assert(typeof contents !== 'function');
    const element = document.createTextNode(contents);
    parent.appendChild(element);
    return;
  }
  const element = document.createElement(tag);
  currentElement.appendChild(element);
  const parent = currentElement;
  currentElement = element;

  renderNode(contents)

  currentElement = parent;

  return element;
}

function renderNode(contents) {
  if (typeof contents === 'function')
    contents(currentElement);
  else if (Array.isArray(contents)) {
    contents.forEach(renderNode);
  } else if (typeof contents === 'string') {
    html(contents);
  } else if (typeof contents === 'number') {
    text(contents.toString());
  }
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

  anchor(bcr.op);

  const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  currentElement.appendChild(svg);
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


  function renderBits(offsetBits, bitCount, value, signed, color, label, typeName) {
    for (let i = 0; i < bitCount; i++) {
      let bitValue;
      if (value === '.' && signed && i === 0) {
        bitValue = 's';
      } else if (value === '.')
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
    else if (bitValue === 's')
      label.textContent = '±';
    else
      label.textContent = bitValue ? '1' : '0';
  }
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

function md(input) {
  input = input.replace(/--/g, '&mdash;');
  return marked(normalizeIndentation(input));
}

function renderStackChange(instructionInfo) {
  const { poppedArgs, pushedResults } = instructionInfo;
  if (!poppedArgs || !pushedResults) throw new Error('poppedArgs and pushedResults need to both be specified');
  const stackHeightItems = Math.max(poppedArgs.length, pushedResults.length);
  const itemHeight = 30;
  const itemWidth = 120;
  const padding = 10;
  const spaceBetweenStacks = 200;
  const svgWidth = padding + itemWidth + spaceBetweenStacks + itemWidth + padding;

  return container => {
    const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
    container.appendChild(svg);
    svg.setAttribute('width', svgWidth);
    svg.setAttribute('height', itemHeight * (stackHeightItems + 1) + padding * 2);

    const stackBaseIndicator = document.createElementNS('http://www.w3.org/2000/svg', 'line');
    svg.appendChild(stackBaseIndicator);
    const stackBaseIndicatorY = padding + itemHeight * stackHeightItems;
    stackBaseIndicator.setAttribute('x1', 0);
    stackBaseIndicator.setAttribute('x2', svgWidth);
    stackBaseIndicator.setAttribute('y1', stackBaseIndicatorY);
    stackBaseIndicator.setAttribute('y2', stackBaseIndicatorY);
    stackBaseIndicator.setAttribute('stroke', 'rgba(0,0,0,0.1)');

    const stackBefore = renderStack(poppedArgs, true);
    svg.appendChild(stackBefore);
    stackBefore.setAttribute('transform', `translate(${padding},${padding + itemHeight * stackHeightItems})`);

    const stackAfter = renderStack(pushedResults);
    svg.appendChild(stackAfter);
    stackAfter.setAttribute('transform', `translate(${padding + itemWidth + spaceBetweenStacks},${padding + itemHeight * stackHeightItems})`);

    const arrow = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    svg.appendChild(arrow);
    arrow.setAttribute('d', 'm 0.77656374,21.906405 v 1.654163 H -2.2098172 v 3.307291 h 2.98638094 v 1.653129 L 4.4047658,25.213697 Z');
    arrow.setAttribute('stroke', 'none');
    arrow.setAttribute('fill', '#ccc');
    arrow.setAttribute('transform', `translate(${padding + itemWidth + spaceBetweenStacks / 2} ${stackHeightItems * itemHeight / 2}) scale(4,4) translate(2,-23)`);
    // arrow.setAttribute('transform', `scale(4,4) `);
  }

  function renderStack(stackItems, reverse) {
    const stackGroup = document.createElementNS('http://www.w3.org/2000/svg', 'g');
    stackGroup.setAttribute('transform', `translate(${padding},${padding + itemHeight * stackHeightItems})`);

    // const stackBase = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    // stackGroup.appendChild(stackBase);
    // stackBase.setAttribute('x', 0);
    // stackBase.setAttribute('y', 0);
    // stackBase.setAttribute('width', itemWidth);
    // stackBase.setAttribute('height', itemHeight);
    // stackBase.setAttribute('fill', 'none');
    // stackBase.setAttribute('stroke', 'gray');
    // stackBase.setAttribute('stroke-width', '1');
    // stackBase.setAttribute('stroke-dasharray', '2 2');

    const stackBaseLabel = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    stackGroup.appendChild(stackBaseLabel);
    stackBaseLabel.setAttribute('x', itemWidth / 2);
    stackBaseLabel.setAttribute('y', itemHeight / 2 + 1);
    stackBaseLabel.style.textAnchor = 'middle';
    stackBaseLabel.style.alignmentBaseline = 'middle';
    stackBaseLabel.textContent = '⋮';

    for (const [i, pushedResult] of stackItems.entries()) {
      const itemRect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
      stackGroup.appendChild(itemRect);
      itemRect.setAttribute('x', 0);
      const itemY = reverse
        ? (-stackItems.length + i) * itemHeight
        : (-1 - i) * itemHeight
      itemRect.setAttribute('y', itemY);
      itemRect.setAttribute('width', itemWidth);
      itemRect.setAttribute('height', itemHeight);
      itemRect.setAttribute('fill', colors.lightBlue.fill);
      itemRect.setAttribute('stroke', colors.lightBlue.stroke);
      itemRect.setAttribute('stroke-width', '1');

      const itemLabel = document.createElementNS('http://www.w3.org/2000/svg', 'text');
      stackGroup.appendChild(itemLabel);
      itemLabel.setAttribute('x', itemWidth / 2);
      itemLabel.setAttribute('y', itemY + itemHeight / 2);
      itemLabel.style.textAnchor = 'middle';
      itemLabel.style.alignmentBaseline = 'middle';
      itemLabel.style.fontSize = '0.8em';
      itemLabel.textContent = pushedResult.label;
    }

    const stackLevelIndicator = document.createElementNS('http://www.w3.org/2000/svg', 'line');
    stackGroup.appendChild(stackLevelIndicator);
    stackLevelIndicator.setAttribute('x1', -padding);
    stackLevelIndicator.setAttribute('x2', itemWidth + padding);
    stackLevelIndicator.setAttribute('y1', - stackItems.length * itemHeight);
    stackLevelIndicator.setAttribute('y2', - stackItems.length * itemHeight);
    stackLevelIndicator.setAttribute('stroke', 'black');

    return stackGroup;
  }
}

function normalizeIndentation(code) {
  if (!code) return '';
  // The rest of this function doesn't work well with empty strings
  if (/^\s*$/.test(code)) {
    return '';
  }
  code = code.replace(/\t/g, '  '); // Replace tabs
  code = code.replace(/^(\s*\n)+/, ''); // replace leading blank lines
  code = code.replace(/(\s*\n)+$/, ''); // replace trailing blank lines
  code = code.trimRight();
  const lines = code.split('\n');
  const indentOf = (line) => (line.match(/^ */))[0].length;
  const nonBlankLines = lines.filter(l => !(/^\s*$/g).test(l));
  const minIndent = ' '.repeat(Math.min.apply(Math, nonBlankLines.map(indentOf)));
  const matchIndent = new RegExp('^' + minIndent, 'gm');
  const normalized = code.replace(matchIndent, '');
  return normalized;
}

function anchor(id) {
  const anchor = document.createElement('a');
  anchor.style.display = 'block';
  anchor.style.height = '0';
  anchor.style.float = 'left';
  anchor.style.fontSize = '0.5em';
  anchor.style.marginLeft = '-12px';
  anchor.id = id;
  anchor.href = '#' + id;
  anchor.text = '🔗';
  anchor.style.opacity = 0.5;
  currentElement.appendChild(anchor);
}

function text(s) {
  const textNode = document.createTextNode(s);
  currentElement.appendChild(textNode);
}

function html(s) {
  if (currentElement.innerHTML) {
    currentElement.innerHTML += s;
  } else {
    currentElement.innerHTML = s;
  }
}

function p(s) {
  container('p', s);
}
