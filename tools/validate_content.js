#!/usr/bin/env node
/**
 * Validates the bundled content:
 *  - stretches.json and routines.json parse
 *  - required fields exist on each stretch
 *  - assetFile matches assets/visuals/<id>.png
 *  - every routine stretchId resolves to a real stretch
 * Run: node tools/validate_content.js
 */
const fs = require('fs');
const path = require('path');

const root = path.join(__dirname, '..');
const read = (p) => JSON.parse(fs.readFileSync(path.join(root, p), 'utf8'));

let errors = 0;
const err = (m) => { console.error('  ✗ ' + m); errors++; };

const data = read('assets/data/stretches.json');
const routines = read('assets/data/routines.json');

const required = ['id', 'name', 'bodyPartId', 'bodyPart', 'props', 'level',
  'holdSeconds', 'sides', 'steps', 'breathingCue', 'safetyNote', 'assetFile'];
const validProps = new Set(['none', 'chair', 'wall', 'table', 'towel', 'bag']);
const validLevels = new Set(['gentle', 'standard', 'deeper']);

const ids = new Set();
const sections = {};

for (const s of data.stretches) {
  for (const f of required) {
    if (s[f] === undefined) err(`stretch "${s.id || '?'}" missing field "${f}"`);
  }
  if (ids.has(s.id)) err(`duplicate id "${s.id}"`);
  ids.add(s.id);
  sections[s.bodyPartId] = (sections[s.bodyPartId] || 0) + 1;
  if (!validLevels.has(s.level)) err(`stretch "${s.id}" bad level "${s.level}"`);
  for (const p of s.props || []) {
    if (!validProps.has(p)) err(`stretch "${s.id}" bad prop "${p}"`);
  }
  if (!new RegExp(`^assets/visuals/${s.id}\\.(png|gif|webp|mp4)$`).test(s.assetFile)) {
    err(`stretch "${s.id}" assetFile should be assets/visuals/${s.id}.{png|gif|webp|mp4}`);
  }
}

for (const r of routines.routines) {
  if (!r.stretchIds || r.stretchIds.length === 0) err(`routine "${r.id}" has no stretches`);
  for (const sid of r.stretchIds || []) {
    if (!ids.has(sid)) err(`routine "${r.id}" references missing stretch "${sid}"`);
  }
}

console.log(`Stretches: ${data.stretches.length}`);
console.log('Per section:', JSON.stringify(sections));
console.log(`Routines: ${routines.routines.length}`);
if (errors === 0) {
  console.log('\n✓ Content valid — all checks passed.');
  process.exit(0);
} else {
  console.error(`\n✗ ${errors} problem(s) found.`);
  process.exit(1);
}
