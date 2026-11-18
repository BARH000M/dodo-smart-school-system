import {copyFileSync} from 'node:fs';
copyFileSync(new URL('../contracts/modules.json',import.meta.url),new URL('../mobile/assets/modules.json',import.meta.url));
console.log('Mobile contract synchronized');
