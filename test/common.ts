import * as fs from 'fs-extra';

export interface TestFilenames {
  [key: string]: TestFilenamePair;
};

export interface TestFilenamePair {
  output: string;
  expected: string;
}

export function bufferToHexString(b: Buffer) {
  // Hex string with spaces between bytes
  return b.toString('hex').replace(/([0-9a-fA-F]{2})/g, (_, v) => v + ' ').trim();
}

export function htmlTemplate(contents: string) {
  return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <style>${fs.readFileSync('./lib/visual-buffer-styles.css', 'utf8')}</style>
    </head>
    <body>
      ${contents}
    </body>
    </html>`
}