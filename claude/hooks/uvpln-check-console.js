#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: avisa de console.log en archivos JS/TS.
// No bloquea — warning antes del merge.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
const EXT = ['.js', '.jsx', '.ts', '.tsx']
if (!file || !EXT.some((e) => file.endsWith(e))) process.exit(0)

// Ignorar archivos de test
const isTest =
  file.includes('/test/') ||
  file.includes('\\test\\') ||
  file.includes('/__tests__/') ||
  file.includes('\\_tests_\\') ||
  file.includes('.test.') ||
  file.includes('.spec.')
if (isTest) process.exit(0)

if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')
const matches = content.match(/console\.(log|warn|error|debug|info)\(/g) || []

if (matches.length) {
  console.warn(
    `uvpln: ${matches.length} console.log(s) en ${file} — borrar antes del merge`
  )
}
