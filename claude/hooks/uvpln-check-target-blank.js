#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: detecta <a target="_blank"> sin rel="noopener noreferrer".
// Vulnerabilidad: tabnabbing — el sitio externo accede a window.opener y redirige tu pestaña.
// No bloquea — warning para fix rápido.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || (!file.endsWith('.tsx') && !file.endsWith('.jsx'))) process.exit(0)
if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')

// Match <a ... target="_blank" ... > completo (puede tener varias props)
const ANCHOR_BLANK = /<a\s[^>]*target=["']_blank["'][^>]*>/gi

const findings = []
let match
while ((match = ANCHOR_BLANK.exec(content)) !== null) {
  const tag = match[0]
  if (!/rel=["'][^"']*noopener/.test(tag)) {
    findings.push(`  ${tag.slice(0, 100)}${tag.length > 100 ? '...' : ''}`)
  }
}

if (findings.length === 0) process.exit(0)

console.warn(
  `uvpln security target=_blank (${file}):\n` +
  `  ${findings.length} link(s) <a target="_blank"> sin rel="noopener noreferrer".\n` +
  `  Vulnerabilidad: tabnabbing — el sitio externo puede redirigir tu pestaña a phishing.\n` +
  findings.join('\n') + '\n' +
  `  Fix: agregar rel="noopener noreferrer" a cada link externo.`
)
