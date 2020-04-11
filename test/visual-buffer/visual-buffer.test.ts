import { assert } from 'chai';
import fs from 'fs-extra';
import { assertSameCode } from "../../lib/utils";
import { VisualBuffer, formats } from '../../lib/visual-buffer';
import { visualBufferFilenames } from './filenames';
import { bufferToHexString } from '../common';
import { htmlTemplate } from '../../lib/general';

suite(VisualBuffer.name, function () {
  test('empty', () => {
    const buffer = new VisualBuffer();
    const binary = buffer.toBuffer();
    const outputHTML = htmlTemplate(buffer.toHTML());
    fs.writeFileSync(visualBufferFilenames.empty.output, outputHTML);
    assert.deepEqual(binary, Buffer.from([]));
    const expectedHTML = fs.readFileSync(visualBufferFilenames.empty.expected, 'utf8');
    assertSameCode(outputHTML, expectedHTML);
  });

  test('append', () => {
    const buffer = new VisualBuffer();

    buffer.append(1, formats.uInt8);
    buffer.append(1, formats.uHex8);
    buffer.append(2, formats.sInt8);
    buffer.append(-2, formats.sInt8);
    buffer.append(3, formats.uInt16LE);
    buffer.append(3, formats.uHex16LE);
    buffer.append(3, formats.sInt16LE);
    buffer.append(-3, formats.sInt16LE);
    buffer.append(4, formats.uInt32LE);
    buffer.append(4, formats.uHex32LE);
    buffer.append(4, formats.sInt32LE);
    buffer.append(-4, formats.sInt32LE);
    buffer.append(5, formats.doubleLE);
    buffer.append(0.5, formats.doubleLE);
    buffer.append(-0.5, formats.doubleLE);
    buffer.append('Hello, World!', formats.stringUtf8NT);

    const binary = buffer.toBuffer();
    const outputHTML = htmlTemplate(buffer.toHTML());
    fs.writeFileSync(visualBufferFilenames.append.output, outputHTML);
    assert.deepEqual(bufferToHexString(binary), '01 01 02 fe 03 00 03 00 03 00 fd ff 04 00 00 00 04 00 00 00 04 00 00 00 fc ff ff ff 00 00 00 00 00 00 14 40 00 00 00 00 00 00 e0 3f 00 00 00 00 00 00 e0 bf 48 65 6c 6c 6f 2c 20 57 6f 72 6c 64 21 00');
    const expectedHTML = fs.readFileSync(visualBufferFilenames.append.expected, 'utf8');
    assertSameCode(outputHTML, expectedHTML);
  });


});