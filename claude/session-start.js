#!/usr/bin/env node
const os   = require('os')
const path = require('path')
const fs   = require('fs')

const P = '\x1b[35m'; const G = '\x1b[32m'
const W = '\x1b[97m'; const D = '\x1b[2m'; const R = '\x1b[0m'; const B = '\x1b[1m'

const CLAUDE_DIR = path.join(os.homedir(), '.claude')
const project    = path.basename(process.cwd())
const dsFile     = path.join(CLAUDE_DIR, 'memory', 'design-systems', `${project}.md`)

console.log('')
console.log(`${P}${B}  ██╗   ██╗██╗   ██╗██████╗ ██╗     ███╗   ██╗${R}`)
console.log(`${P}${B}  ██║   ██║██║   ██║██╔══██╗██║     ████╗  ██║${R}`)
console.log(`${P}${B}  ██║   ██║██║   ██║██████╔╝██║     ██╔██╗ ██║${R}`)
console.log(`${P}${B}  ██║   ██║╚██╗ ██╔╝██╔═══╝ ██║     ██║╚██╗██║${R}`)
console.log(`${P}${B}  ╚██████╔╝ ╚████╔╝ ██║     ███████╗██║ ╚████║${R}`)
console.log(`${P}${B}   ╚═════╝   ╚═══╝  ╚═╝     ╚══════╝╚═╝  ╚═══╝${R}`)
console.log('')
console.log(`  ${G}${B}Un Viernes Por La Noche${R} ${D}— Frontend AI Agent${R}`)
console.log(`  ${D}UI bonita. Codigo limpio. Deploy y a dormir.${R}`)
console.log('')
console.log(`  ${D}─────────────────────────────────────────────${R}`)
console.log(`  ${W}Proyecto:     ${R} ${G}${project}${R}`)

if (fs.existsSync(dsFile)) {
  const lines = fs.readFileSync(dsFile, 'utf8').split('\n').length
  console.log(`  ${W}Design system:${R} ${G}cargado (${lines} lineas)${R}`)
} else {
  console.log(`  ${W}Design system:${R} ${D}sin registrar todavia${R}`)
}

let agentCount = 0
const agentsDir = path.join(CLAUDE_DIR, 'agents')
if (fs.existsSync(agentsDir)) {
  agentCount = fs.readdirSync(agentsDir).filter(f => f.endsWith('.md')).length
}
console.log(`  ${W}Agentes:      ${R} ${G}${agentCount} disponibles${R}`)
console.log(`  ${D}─────────────────────────────────────────────${R}`)
console.log('')
console.log(`  ${P}Hola parcero, que haremos hoy?${R}`)
console.log('')
