#!/usr/bin/env node
// Valida frontmatter YAML de los agentes en claude/agents/
// Errores: frontmatter ausente o campos requeridos faltantes
// Warnings: description muy larga (ideal <500 chars para que el router de Claude Code elija bien)

const fs = require('fs')
const path = require('path')

const AGENTS_DIR = path.join(__dirname, '..', 'claude', 'agents')
const REQUIRED = ['name', 'description', 'tools', 'model']
const DESC_MAX = 500

const files = fs.readdirSync(AGENTS_DIR).filter((f) => f.endsWith('.md'))
let errors = 0
let warnings = 0

for (const file of files) {
  const content = fs.readFileSync(path.join(AGENTS_DIR, file), 'utf8')
  const match = content.match(/^---\n([\s\S]*?)\n---/)
  if (!match) {
    console.error(`✗ ${file}: sin frontmatter`)
    errors++
    continue
  }
  const fm = match[1]
  const missing = REQUIRED.filter((field) => !fm.match(new RegExp(`^${field}:`, 'm')))
  if (missing.length) {
    console.error(`✗ ${file}: faltan campos [${missing.join(', ')}]`)
    errors++
    continue
  }
  const descMatch = fm.match(/^description:\s*"?(.*?)"?$/m)
  const desc = descMatch ? descMatch[1] : ''
  if (desc.length > DESC_MAX) {
    console.warn(`! ${file}: description ${desc.length} chars (ideal <${DESC_MAX})`)
    warnings++
  } else {
    console.log(`✓ ${file}`)
  }
}

console.log('')
console.log(`${files.length} agentes · ${errors} errores · ${warnings} warnings`)
if (errors) process.exit(1)
