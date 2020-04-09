import { SmartBuffer } from 'smart-buffer';
import * as _ from 'lodash';
import { notUndefined, invalidOperation, stringifyStringLiteral } from './utils';

export type BinaryFormat<T> = (b: SmartBuffer, value: T, offset: number | undefined) => void;
type HTMLSegment = { value: any, format: HTMLFormat<any> };

export class VisualBuffer {
  private smartBuffer = new SmartBuffer();
  private htmlSegments = new Map<number, HTMLSegment>();
  private writeSizes = new Map<number, number>();
  private appendOffset = 0;

  append<T>(value: T, format: Format<T>) {
    const startOffset = this.appendOffset;
    this.smartBuffer.writeOffset = startOffset;
    format.binaryFormat(this.smartBuffer, value, undefined);
    const endOffset = this.smartBuffer.writeOffset;
    this.appendOffset = endOffset;
    const size = endOffset - startOffset;
    this.writeSizes.set(startOffset, size);
    this.htmlSegments.set(startOffset, {
      value, format: format.htmlFormat
    })
  }

  overwrite<T>(value: T, format: Format<T>, offset: number) {
    const expectedSize = this.writeSizes.get(offset);
    if (expectedSize === undefined) {
      return invalidOperation('Can only overwrite a region that exactly matches of the offset of a previous `append`')
    }
    format.binaryFormat(this.smartBuffer, value, offset);
    const endOffset = this.smartBuffer.writeOffset;
    const size = endOffset - offset;
    if (size !== expectedSize) {
      return invalidOperation('An `overwrite` must have exactly the same size as the original `append`')
    }
    this.htmlSegments.set(offset, {
      value, format: format.htmlFormat
    })
  }

  toBuffer() {
    return this.smartBuffer.toBuffer();
  }

  toHTML(): string {
    const offsets = _.sortBy([...this.htmlSegments.keys()], o => o);
    return `<div class="visual-buffer">\n${offsets
      .map(offset => notUndefined(this.htmlSegments.get(offset)))
      .map(renderHtmlSegment)
      .join('\n')
    }\n</div>`

    function renderHtmlSegment({ value, format }: HTMLSegment) {
      const innerHTML = format.innerHTML(value);
      const cssClasses = ['segment', ...format.cssClasses];
      if (format.htmlContainer) {
        return `<${format.htmlContainer} class="${cssClasses.join(' ')}">${innerHTML}</${format.htmlContainer}>`;
      } else {
        return innerHTML;
      }
    }
  }
}

export interface Format<T> {
  binaryFormat: BinaryFormat<T>;
  htmlFormat: HTMLFormat<T>;
}

interface HTMLFormat<T> {
  htmlContainer: 'div' | 'span' | undefined;
  cssClasses: string[];
  innerHTML: (value: T) => string;
}

// Null terminated string
export const stringNTBinaryFormat: BinaryFormat<string> = (b: SmartBuffer, value: string, offset: number | undefined) =>
  b.writeStringNT(value, offset)

class BinaryFormats {
  // UTF8, null-terminated string
  stringUtf8NT: BinaryFormat<string> = (b, v, o) => b.writeStringNT(v, o, 'utf8');
  // 8-bit unsigned integer
  uInt8: BinaryFormat<number> = (b, v, o) => b.writeUInt8(v, o);
  // 8-bit signed integer
  sInt8: BinaryFormat<number> = (b, v, o) => b.writeInt8(v, o);
  // Little-endian 16-bit unsigned integer
  uInt16LE: BinaryFormat<number> = (b, v, o) => b.writeUInt16LE(v, o);
  // Little-endian 16-bit signed integer
  sInt16LE: BinaryFormat<number> = (b, v, o) => b.writeInt16LE(v, o);
  // Little-endian 32-bit unsigned integer
  uInt32LE: BinaryFormat<number> = (b, v, o) => b.writeUInt32LE(v, o);
  // Little-endian 32-bit signed integer
  sInt32LE: BinaryFormat<number> = (b, v, o) => b.writeInt32LE(v, o);
  // Little-endian 64-bit floating point
  doubleLE: BinaryFormat<number> = (b, v, o) => b.writeDoubleLE(v, o);
}

class HTMLFormats {
  hex = (digits: number, add0x: boolean = true, addBaseSubscript: boolean = false): HTMLFormat<number> => ({
    cssClasses: ['number', 'hex'],
    htmlContainer: 'span',
    innerHTML: n =>
      (add0x ? '0x' : '') +
      (n.toString(16).padStart(digits, '0')) +
      (addBaseSubscript ? '<sub>16</sub>': '')
  });

  int: HTMLFormat<number> = {
    cssClasses: ['int'],
    htmlContainer: 'span',
    innerHTML: s => s.toFixed(0)
  };

  double: HTMLFormat<number> = {
    cssClasses: ['double'],
    htmlContainer: 'span',
    innerHTML: s => s.toString()
  };

  string: HTMLFormat<string> = {
    cssClasses: ['string'],
    htmlContainer: 'span',
    innerHTML: s => stringifyStringLiteral(s)
  };
}

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