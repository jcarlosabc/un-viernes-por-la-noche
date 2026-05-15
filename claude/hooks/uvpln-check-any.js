#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: avisa de usos de `any` en archivos TS/TSX.
// No bloquea — solo emite warning a stderr.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || (!file.endsWith('.tsx') && !file.endsWith('.ts'))) process.exit(0)
if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')
const matches = content.match(/:\s*any/g) || []

if (matches.length) {
  console.warn(`uvpln: ${matches.length} uso(s) de any en ${file}`)
}
