import { SmartBuffer } from 'smart-buffer';
import * as _ from 'lodash';
import { notUndefined, invalidOperation, stringifyStringLiteral, assert } from './utils';
import { isUInt8, SInt8, SInt16, SInt32, UInt16, UInt32 } from './runtime-types';
import escapeHTML from 'escape-html';

export type BinaryFormat<T> = (value: T) => BinaryData;
export type HTMLFormat<T> = (value: T, binary: BinaryData, offset: number) => HTML;

export type HTML = string;

interface Segment<T = any> {
  value: T;
  binaryData: BinaryData;
  htmlFormat: HTMLFormat<T>;
}

export type Byte = number;
export const Byte = (b: number) => (assert(isUInt8(b)), b);

export type BinaryData = readonly Byte[];
export const BinaryData = (bytes: readonly Byte[]): BinaryData => Object.freeze(bytes.map(Byte));

export class VisualBuffer {
  private segments = new Map<number, Segment>();
  private totalSize = 0;

  get writeOffset() { return this.totalSize; }

  append<T>(value: T, format: Format<T>) {
    const offset = this.totalSize;
    const binaryData = BinaryData(format.binaryFormat(value));
    this.totalSize += binaryData.length;
    this.segments.set(offset, {
      value, binaryData, htmlFormat: format.htmlFormat
    });
  }

  overwrite<T>(value: T, format: Format<T>, offset: number) {
    const segment = this.segments.get(offset);
    if (segment === undefined) {
      return invalidOperation('Can only overwrite a region that exactly matches of the offset of a previous `append`')
    }
    const binaryData = BinaryData(format.binaryFormat(value));
    if (binaryData.length !== segment.binaryData.length) {
      return invalidOperation('An `overwrite` must have exactly the same size as the original `append`')
    }
    this.segments.set(offset, {
      value, binaryData, htmlFormat: format.htmlFormat
    });
  }

  toBuffer() {
    const buffer = new SmartBuffer();
    const segments = _.sortBy([...this.segments.entries()], s => s[0]);
    for (const [offset, segment] of segments) {
      segment.binaryData.forEach(b => buffer.writeUInt8(b));
    }
    return buffer.toBuffer();
  }

  toHTML(): string {
    const offsets = _.sortBy([...this.segments.keys()], o => o);
    return `
      <table class="visual-buffer">
        <colgroup>
          <col>
          <col>
          <col>
        </colgroup>
        <!--<thead>
          <tr>
            <th>Address</th>
            <th>Data</th>
            <th>Value</th>
          </tr>
        </thead>-->
        <tbody>
          ${offsets
            .map(offset => renderHtmlSegment(notUndefined(this.segments.get(offset)), offset))
            .join('\n')}
          ${
            tableRow(v => '')(0, [], this.totalSize)
          }
        </tbody>
      </table>`

    function renderHtmlSegment({ value, htmlFormat, binaryData }: Segment, offset: number) {
      return htmlFormat(value, binaryData, offset);
    }
  }
}

export interface Format<T> {
  binaryFormat: BinaryFormat<T>;
  htmlFormat: HTMLFormat<T>;
}

class BinaryFormats {
  // 8-bit unsigned integer
  uInt8: BinaryFormat<number> = v => [v];
  // 8-bit signed integer
  sInt8: BinaryFormat<number> = v => [SInt8(v) & 0xFF];
  // Little-endian 16-bit unsigned integer
  uInt16LE: BinaryFormat<number> = v => (UInt16(v), [v & 0xFF, (v >> 8) & 0xFF]);
  // Little-endian 16-bit signed integer
  sInt16LE: BinaryFormat<number> = v => (SInt16(v), [v & 0xFF, (v >> 8) & 0xFF]);
  // Little-endian 32-bit unsigned integer
  uInt32LE: BinaryFormat<number> = v => (UInt32(v), [v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF]);
  // Little-endian 32-bit signed integer
  sInt32LE: BinaryFormat<number> = v => (SInt32(v), [v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF]);
  // Little-endian 64-bit floating point
  doubleLE: BinaryFormat<number> = v => { const b = Buffer.allocUnsafe(8); b.writeDoubleLE(v); return [...b] };
  // UTF8, null-terminated string
  stringUtf8NT: BinaryFormat<string> = v => [...Buffer.from(v, 'utf8'), 0];
}

class HTMLFormats {
  // These formats all assume that the elements are being rendered as rows in a table. If this isn't true, make your own formats

  hex = (digits: number, add0x: boolean = true, addBaseSubscript: boolean = false): HTMLFormat<number> =>
    tableRow(value =>
      (add0x ? '0x' : '') +
      (value.toString(16).padStart(digits, '0').toUpperCase()) +
      (addBaseSubscript ? '<sub>16</sub>': ''));

  int: HTMLFormat<number> = tableRow(s => s.toFixed(0));

  double: HTMLFormat<number> = tableRow(s => s.toString());

  string: HTMLFormat<string> = tableRow(s => escapeHTML(stringifyStringLiteral(s)))
}

export const tableRow = <T>(formatValue: (v: T) => string): HTMLFormat<T> =>
  (value, binary, offset) => `
    <tr>
      <td class="address">
        <span class="address-text">
          ${offset.toString(16).padStart(4, '0').toUpperCase()}
        </span>
      </td>
      <td class="data">
        ${binary
          .map(b => b.toString(16).padStart(2, '0').toUpperCase())
          .map(s => `<span class="byte">${s}</span>`)
          .join('<wbr>')}
      </td>
      <td class="value">
        ${formatValue(value)}
      </td>
    </tr>`;

export const binaryFormats = new BinaryFormats();
export const htmlFormats = new HTMLFormats();

class Formats {
  uHex8: Format<number> = { binaryFormat: binaryFormats.uInt8, htmlFormat: htmlFormats.hex(2) };
  uInt8: Format<number> = { binaryFormat: binaryFormats.uInt8, htmlFormat: htmlFormats.int };
  sInt8: Format<number> = { binaryFormat: binaryFormats.sInt8, htmlFormat: htmlFormats.int };

  uHex16LE: Format<number> = { binaryFormat: binaryFormats.uInt16LE, htmlFormat: htmlFormats.hex(2) };
  uInt16LE: Format<number> = { binaryFormat: binaryFormats.uInt16LE, htmlFormat: htmlFormats.int };
  sInt16LE: Format<number> = { binaryFormat: binaryFormats.sInt16LE, htmlFormat: htmlFormats.int };

  uHex32LE: Format<number> = { binaryFormat: binaryFormats.uInt32LE, htmlFormat: htmlFormats.hex(2) };
  uInt32LE: Format<number> = { binaryFormat: binaryFormats.uInt32LE, htmlFormat: htmlFormats.int };
  sInt32LE: Format<number> = { binaryFormat: binaryFormats.sInt32LE, htmlFormat: htmlFormats.int };

  double: Format<number> = { binaryFormat: binaryFormats.doubleLE, htmlFormat: htmlFormats.double }

  stringUtf8NT: Format<string> = { binaryFormat: binaryFormats.stringUtf8NT, htmlFormat: htmlFormats.string }
}

export const formats = new Formats();
