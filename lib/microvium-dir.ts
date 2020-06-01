import path from 'path';

export const microviumDir = __filename.endsWith('.ts')
  ? path.resolve(__dirname, '../') // Escape ./lib
  : path.resolve(__dirname, '../../') // Escape ./lib/dist