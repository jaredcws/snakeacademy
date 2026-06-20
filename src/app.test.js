import test from 'node:test';
import assert from 'node:assert/strict';
import { modules, quiz } from './content.js';

test('course library contains complete Snake Academy paths', () => {
  assert.equal(modules.length, 4);
  assert.ok(modules.every((module) => module.title && module.summary && module.progress >= 0));
});

test('first quiz reinforces safe distance', () => {
  assert.match(quiz[0].choices[quiz[0].answer], /space/i);
});
