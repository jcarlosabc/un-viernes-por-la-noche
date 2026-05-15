#!/usr/bin/env node
const os   = require('os')
const path = require('path')
const fs   = require('fs')

if (process.platform === 'win32') {
  try { process.stdout.reconfigure({ encoding: 'utf8' }) } catch (_) {}
}

const P = '\x1b[35m'; const G = '\x1b[32m'
const W = '\x1b[97m'; const D = '\x1b[2m'; const R = '\x1b[0m'; const B = '\x1b[1m'

const CLAUDE_DIR = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude')
const project    = path.basename(process.cwd())
const dsFile     = path.join(CLAUDE_DIR, 'memory', 'design-systems', `${project}.md`)

// Marcar inicio de sesión para el cronómetro del statusline
const sessionStartFile = path.join(CLAUDE_DIR, 'memory', 'session-start.txt')
try {
  fs.mkdirSync(path.dirname(sessionStartFile), { recursive: true })
  fs.writeFileSync(sessionStartFile, new Date().toISOString())
} catch (_) {}

// Íconos compartidos con statusline.cjs
let AGENT_ICONS = {}
try { AGENT_ICONS = require(path.join(CLAUDE_DIR, 'agents-config.js')).AGENT_ICONS || {} } catch (_) {}

const agentsDir   = path.join(CLAUDE_DIR, 'agents')
const hooksDir    = path.join(CLAUDE_DIR, 'hooks')
const commandsDir = path.join(CLAUDE_DIR, 'commands')

const agents = fs.existsSync(agentsDir)
  ? fs.readdirSync(agentsDir).filter(f => f.endsWith('.md')).map(f => f.replace('.md', ''))
  : []

let hooksCount = 0
if (fs.existsSync(hooksDir)) {
  hooksCount = fs.readdirSync(hooksDir).filter(f => f.startsWith('uvpln-') && f.endsWith('.js')).length
}
if (hooksCount === 0) {
  try {
    const settings = JSON.parse(fs.readFileSync(path.join(CLAUDE_DIR, 'settings.json'), 'utf8'))
    if (settings.hooks) {
      Object.values(settings.hooks).forEach(events => {
        events.forEach(event => { if (event.hooks) hooksCount += event.hooks.length })
      })
    }
  } catch (_) {}
}

const commandsCount = fs.existsSync(commandsDir)
  ? fs.readdirSync(commandsDir).filter(f => f.endsWith('.md')).length
  : 0

const ROW_SIZE = 6
const rows = []
for (let i = 0; i < agents.length; i += ROW_SIZE) {
  rows.push(agents.slice(i, i + ROW_SIZE))
}

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

console.log(`  ${W}Agentes:      ${R} ${G}${agents.length} disponibles${R}`)
console.log(`  ${W}Hooks:        ${R} ${G}${hooksCount} activos${R}`)
console.log(`  ${W}Comandos:     ${R} ${G}${commandsCount} slash commands${R}`)
console.log(`  ${D}─────────────────────────────────────────────${R}`)

if (agents.length > 0) {
  console.log('')
  rows.forEach(row => {
    const line = row.map(a => {
      const icon = AGENT_ICONS[a] || '◈'
      return `${icon} ${D}${a}${R}`
    }).join('   ')
    console.log(`  ${line}`)
  })
}

console.log('')
console.log(`  ${P}¿Qué construimos hoy?${R}`)
console.log('')
