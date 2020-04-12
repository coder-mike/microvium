import { VisualBufferHTMLContainer, HTMLFormat, BinaryFormat, Format, BinaryData } from "./visual-buffer";
import escapeHTML from 'escape-html';
import { stringifyStringLiteral } from "./utils";
import { SInt8, UInt16, SInt16, UInt32, SInt32 } from "./runtime-types";
import { Labelled } from "./binary-region-3";

export const tableContainer: VisualBufferHTMLContainer = (content, totalSize) => `
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
      ${content}
      ${
        // Final row to show the trailing address
        tableRow(() => '')(0, [], totalSize)
      }
    </tbody>
  </table>`

export const tableRow = <T>(formatValue: (v: T) => string): HTMLFormat<T> =>
  (value, binary, offset) => {
    const addressID = `address${offset.toString(16).padStart(4, '0').toUpperCase()}`;
    return `
      <tr>
        <td class="address">
          <a class="address-text" id="${addressID}" href="#${addressID}">
            ${offset.toString(16).padStart(4, '0').toUpperCase()}
          </a>
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
      </tr>`
  };

const placeholderRow: HTMLFormat<Labelled<any>> = (value, binary, offset) => {
  const addressID = `address${offset.toString(16).padStart(4, '0').toUpperCase()}`;
  return `
    <tr>
      <td class="address">
        <a class="address-text" id="${addressID}" href="#${addressID}">
          ${offset.toString(16).padStart(4, '0').toUpperCase()}
        </a>
      </td>
      <td class="data">
        ${binary
          .map(() => `<span class="byte pending"></span>`)
          .join('<wbr>')}
      </td>
      <td class="value pending-value">
        ${value.label ? value.label + ': ' : ''}Pending
      </td>
    </tr>`
}

class HTMLFormats {

  hex = (digits: number, add0x: boolean = true, addBaseSubscript: boolean = false): HTMLFormat<number> =>
    tableRow(value =>
      (add0x ? '0x' : '') +
      (value.toString(16).padStart(digits, '0').toUpperCase()) +
      (addBaseSubscript ? '<sub>16</sub>': ''));

  int: HTMLFormat<number> = tableRow(s => s.toFixed(0));

  double: HTMLFormat<number> = tableRow(s => s.toString());

  string: HTMLFormat<string> = tableRow(s => escapeHTML(stringifyStringLiteral(s)))
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

const renderInt = (s: number) => s.toFixed(0);
const renderHex = (digits: number) => (value: number) => `0x${value.toString(16).padStart(digits, '0').toUpperCase()}`;
const renderDouble = (value: number) => value.toString();
const renderString = (value: string) => escapeHTML(stringifyStringLiteral(value));
const renderBuffer = (value: Buffer) => '<Buffer>';

export const binaryFormats = new BinaryFormats();
export const htmlFormats = new HTMLFormats();

export const uHex8 = format(binaryFormats.uInt8, renderHex(2), 1);
export const uInt8 = format(binaryFormats.uInt8, renderInt, 1);
export const sInt8 = format(binaryFormats.sInt8, renderInt, 1);

export const uHex16LE = format(binaryFormats.uInt16LE, renderHex(4), 2);
export const uInt16LE = format(binaryFormats.uInt16LE, renderInt, 2);
export const sInt16LE = format(binaryFormats.sInt16LE, renderInt, 2);

export const uHex32LE = format(binaryFormats.uInt32LE, renderHex(8), 4);
export const uInt32LE = format(binaryFormats.uInt32LE, renderInt, 4);
export const sInt32LE = format(binaryFormats.sInt32LE, renderInt, 4);

export const doubleLE = format(binaryFormats.doubleLE, renderDouble, 8);

export const stringUtf8NT = format(binaryFormats.stringUtf8NT, renderString, 1);

export const buffer = format(b => BinaryData([...b]), renderBuffer, 1);

function format<T>(binaryFormat: BinaryFormat<T>, htmlFormat: (v: T) => string, sizeBytes: number): Format<Labelled<undefined | T>> {
  const placeholderData = zeros(sizeBytes);
  return {
    binaryFormat: value =>
      value.value === undefined ? placeholderData : binaryFormat(value.value),
    htmlFormat: (value: Labelled<undefined | T>, binary, offset) =>
      value.value === undefined
        ? placeholderRow(value, binary, offset)
        : tableRow<T>(v => (value.label ? value.label + ': ' : '') + htmlFormat(v))(value.value, binary, offset)
  }
}

function zeros(length: number): BinaryData {
  const result = [];
  while (length--) {
    result.push(0);
  }
  return result;
}
