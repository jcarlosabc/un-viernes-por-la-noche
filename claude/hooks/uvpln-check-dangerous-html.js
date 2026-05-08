#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: detecta dangerouslySetInnerHTML sin DOMPurify cerca.
// XSS via HTML directo es la vulnerabilidad #1 de frontend. Sin sanitización es regalo a atacantes.
// No bloquea — warning para que el security-frontend o ui-architect agreguen DOMPurify.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || (!file.endsWith('.tsx') && !file.endsWith('.jsx'))) process.exit(0)
if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')

// Detectar dangerouslySetInnerHTML
const DANGER = /dangerouslySetInnerHTML\s*=\s*\{[^}]*\}/g
const matches = content.match(DANGER) || []

if (matches.length === 0) process.exit(0)

// Heurística: ¿hay DOMPurify importado o usado en el archivo?
const hasDOMPurify = /\b(DOMPurify|sanitizeHtml|sanitize)\b/.test(content)
const hasImport = /from\s+["'](isomorphic-)?dompurify["']/.test(content) ||
                  /from\s+["']sanitize-html["']/.test(content)

if (hasDOMPurify && hasImport) process.exit(0)

console.warn(
  `uvpln security XSS (${file}):\n` +
  `  ${matches.length} uso(s) de dangerouslySetInnerHTML detectado(s).\n` +
  `  No se detecta DOMPurify ni sanitize-html importados — XSS es muy probable.\n` +
  `  Fix: import DOMPurify from "isomorphic-dompurify"\n` +
  `       const safe = DOMPurify.sanitize(userContent, { ALLOWED_TAGS: [...] })\n` +
  `       <div dangerouslySetInnerHTML={{ __html: safe }} />\n` +
  `  Si el HTML viene de fuente 100% confiable (no input de usuario), documentalo en comentario.`
)
