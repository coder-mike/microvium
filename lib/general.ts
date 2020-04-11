import * as fs from 'fs-extra';

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