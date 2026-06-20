import { mkdir, copyFile, rm } from 'node:fs/promises';
import { join } from 'node:path';
await rm('dist', { recursive: true, force: true });
await mkdir('dist/src', { recursive: true });
for (const file of ['index.html', 'README.md']) await copyFile(file, join('dist', file));
for (const file of ['main.js', 'content.js', 'styles.css']) await copyFile(join('src', file), join('dist/src', file));
console.log('Built static app in dist/');
