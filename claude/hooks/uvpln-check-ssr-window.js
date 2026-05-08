#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: detecta uso de window/document en render inicial.
// Causa hydration mismatch en Next.js. Solo es válido dentro de useEffect/useLayoutEffect
// o tras chequeo "typeof window !== 'undefined'" en branches con render condicional seguro.
// No bloquea — warning para que el ui-architect refactore con CSS o useEffect.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || (!file.endsWith('.tsx') && !file.endsWith('.jsx'))) process.exit(0)
if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')

// Patterns que indican uso problemático en render
// window.innerWidth, window.matchMedia, document.cookie, navigator.userAgent en JSX expressions
const RISKY = [
  /\bwindow\.innerWidth\b/,
  /\bwindow\.innerHeight\b/,
  /\bwindow\.matchMedia\b/,
  /\bnavigator\.userAgent\b/,
  /\bdocument\.cookie\b/,
  /\blocalStorage\.getItem\b/,
]

const findings = []
const lines = content.split('\n')

lines.forEach((line, idx) => {
  // Skip si la línea está dentro de un comentario obvio
  if (line.trim().startsWith('//') || line.trim().startsWith('*')) return

  RISKY.forEach((pattern) => {
    if (!pattern.test(line)) return

    // Heurística: ¿está dentro de useEffect / useLayoutEffect en las 10 líneas previas?
    const prevContext = lines.slice(Math.max(0, idx - 10), idx).join('\n')
    const inEffect =
      /useEffect\s*\(|useLayoutEffect\s*\(|useInsertionEffect\s*\(/.test(prevContext) &&
      // Y no se cerró el effect antes de esta línea
      (prevContext.match(/useEffect\s*\(|useLayoutEffect\s*\(|useInsertionEffect\s*\(/g) || []).length >
        (prevContext.match(/^\s*\}\s*,\s*\[/gm) || []).length

    // Heurística: ¿hay guard "typeof window !== 'undefined'" cercano?
    const guarded = /typeof\s+window\s*!==\s*['"]undefined['"]/.test(prevContext)

    if (!inEffect && !guarded) {
      findings.push(`  línea ${idx + 1}: ${line.trim().slice(0, 100)}`)
    }
  })
})

if (findings.length === 0) process.exit(0)

console.warn(
  `uvpln ssr (${file}):\n` +
  `  Uso de window/document/navigator en render inicial — rompe SSR/hidratación en Next.js.\n` +
  findings.join('\n') + '\n' +
  `  Fix: moverlo a useEffect, o reemplazar por CSS (container queries, media queries).`
)
