#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: detecta OKLCH inline en componentes.
// El color en OKLCH debe vivir en globals.css/tokens.css, no en .tsx/.jsx.
// No bloquea — warning para que el tokens-manager mueva el valor a token.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || (!file.endsWith('.tsx') && !file.endsWith('.jsx'))) process.exit(0)
if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')

// Detecta oklch(...) en cualquier parte del archivo de componente
// Match: bg-[oklch(58%_0.18_265)], style={{ color: 'oklch(...)' }}, className con oklch
const OKLCH_INLINE = /oklch\s*\(/gi

const count = (content.match(OKLCH_INLINE) || []).length
if (count === 0) process.exit(0)

console.warn(
  `uvpln oklch (${file}):\n` +
  `  ${count} uso(s) de oklch() inline detectado(s).\n` +
  `  El color OKLCH debe vivir en tokens (globals.css/tokens.css), no en componentes.\n` +
  `  Movélo a un token semántico (--primary, --accent, etc.) y referenciálo con bg-primary, text-accent, etc.`
)
