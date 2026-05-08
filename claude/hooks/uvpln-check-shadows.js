#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: detecta sombras planas en componentes.
// Sugiere usar tokens compuestos (--shadow-card, --shadow-card-hover) en lugar de shadow-md.
// No bloquea — warning para que el ui-architect tokenice la profundidad correctamente.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || (!file.endsWith('.tsx') && !file.endsWith('.jsx'))) process.exit(0)
if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')

// Detecta clases Tailwind de sombra plana (no las del propio token uvpln)
// Match: className="... shadow-md ..." o className={... shadow-lg ...}
// No match: shadow-(--shadow-card) ni shadow-none
const FLAT_SHADOWS = /\bshadow-(sm|md|lg|xl|2xl|inner)\b/g

const matches = content.match(FLAT_SHADOWS)
if (!matches) process.exit(0)

const unique = [...new Set(matches)]
console.warn(
  `uvpln shadows (${file}):\n` +
  `  Sombra plana detectada: ${unique.join(', ')}\n` +
  `  Usá tokens compuestos: shadow-(--shadow-card), shadow-(--shadow-card-hover), shadow-(--shadow-popover).\n` +
  `  Si no existen, delegá a tokens-manager para crearlos en globals.css.`
)
