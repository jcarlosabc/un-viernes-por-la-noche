#!/usr/bin/env node
const os   = require('os')
const path = require('path')
const fs   = require('fs')

const P = '\x1b[35m'; const G = '\x1b[32m'
const D = '\x1b[2m';  const R = '\x1b[0m'

const CLAUDE_DIR = path.join(os.homedir(), '.claude')
const project    = path.basename(process.cwd())
const dsFile     = path.join(CLAUDE_DIR, 'memory', 'design-systems', `${project}.md`)
const memDir     = path.join(CLAUDE_DIR, 'memory')

console.log('')
console.log(`  ${P}Un Viernes Por La Noche — cerrando sesion${R}`)
console.log('')

fs.mkdirSync(memDir, { recursive: true })
const now = new Date().toISOString().replace('T', ' ').slice(0, 16)
fs.writeFileSync(path.join(memDir, 'last-session.txt'), `${project} — ${now}`)

if (fs.existsSync(dsFile)) {
  const lines = fs.readFileSync(dsFile, 'utf8').split('\n').length
  console.log(`  ${G}Design system guardado: ${project} (${lines} lineas)${R}`)
} else {
  console.log(`  ${D}Sin design system para: ${project}${R}`)
  console.log(`  ${D}Tip: pedile a uvpln "guarda el design system de este proyecto"${R}`)
}

console.log('')
console.log(`  ${P}Hasta la proxima Amigo.${R}`)
console.log('')
