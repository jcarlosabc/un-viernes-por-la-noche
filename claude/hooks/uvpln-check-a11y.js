#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: detecta problemas básicos de accesibilidad en JSX/TSX.
// No bloquea — warning para que el a11y-expert pueda intervenir.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || (!file.endsWith('.tsx') && !file.endsWith('.jsx'))) process.exit(0)
if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')
const warnings = []

// <img> sin alt
const imgTags = content.match(/<img\b[^>]*\/?>/g) || []
imgTags.forEach((tag) => {
  if (!tag.includes('alt=')) {
    warnings.push('  <img> sin alt= — los screen readers no pueden describirla')
  }
})

// onClick en elementos no interactivos sin role ni tabIndex
const nonInteractive = content.match(/<(div|span|p|section|article|li)\b[^>]*onClick[^>]*>/g) || []
nonInteractive.forEach((tag) => {
  const el = tag.match(/<(\w+)/)?.[1]
  if (!tag.includes('role=') && !tag.includes('tabIndex')) {
    warnings.push(
      `  onClick en <${el}> sin role/tabIndex — no es accesible por teclado, usar <button>`
    )
  }
})

if (warnings.length) {
  console.warn(`uvpln a11y (${file}):\n${warnings.join('\n')}`)
}
