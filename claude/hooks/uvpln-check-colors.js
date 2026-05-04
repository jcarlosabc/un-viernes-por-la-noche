#!/usr/bin/env node
// uvpln — PreToolUse Write|Edit: bloquea colores hardcodeados en clases Tailwind.
// Sale con código 2 para que Claude Code aborte la escritura del archivo.

const fs = require('fs')

const PATTERNS = ['text-[#', 'bg-[#', 'border-[#']

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || !fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')
const found = PATTERNS.filter((p) => content.includes(p))

if (found.length) {
  console.error('uvpln: color hardcodeado -- usa un token del design system')
  process.exit(2)
}
