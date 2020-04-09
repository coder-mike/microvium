import { assert } from 'chai';
import fs from 'fs-extra';
import { assertSameCode } from "../../lib/utils";
import { VisualBuffer, formats } from '../../lib/visual-buffer';
import * as path from 'path';
import { visualBufferFilenames } from './filenames';

suite('VisualBuffer', function () {
  test('empty', () => {
    const buffer = new VisualBuffer();
    const binary = buffer.toBuffer();
    const html = buffer.toHTML();
    assert.deepEqual(binary, Buffer.from([]));
    assertSameCode(html, `
      <div class="visual-buffer">
      </div>`);
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
    buffer.append(5, formats.double);
    buffer.append(0.5, formats.double);
    buffer.append(-0.5, formats.double);
    buffer.append('Hello, World!', formats.stringUtf8NT);

    const binary = buffer.toBuffer();
    const outputHTML = htmlTemplate(buffer.toHTML());
    fs.writeFileSync(visualBufferFilenames.append.output, outputHTML);
    assert.deepEqual(bufferToHexString(binary), '01 01 02 fe 03 00 03 00 03 00 fd ff 04 00 00 00 04 00 00 00 04 00 00 00 fc ff ff ff 00 00 00 00 00 00 14 40 00 00 00 00 00 00 e0 3f 00 00 00 00 00 00 e0 bf 48 65 6c 6c 6f 2c 20 57 6f 72 6c 64 21 00');
    const expectedHTML = fs.readFileSync(visualBufferFilenames.append.expected, 'utf8');
    assertSameCode(outputHTML, expectedHTML);
  });
});

function bufferToHexString(b: Buffer) {
  // Hex string with spaces between bytes
  return b.toString('hex').replace(/([0-9a-fA-F]{2})/g, (_, v) => v + ' ').trim();
}

function htmlTemplate(contents: string) {
  return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <link rel="stylesheet" href="style.css">
    </head>
    <body>
      ${contents}
    </body>
    </html>`
}