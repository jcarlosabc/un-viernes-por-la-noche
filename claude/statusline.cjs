#!/usr/bin/env node
const os   = require('os')
const path = require('path')
const fs   = require('fs')

const PURPLE = '\x1b[35m'
const GREEN  = '\x1b[32m'
const WHITE  = '\x1b[97m'
const DIM    = '\x1b[2m'
const BOLD   = '\x1b[1m'
const RESET  = '\x1b[0m'
const YELLOW = '\x1b[33m'
const CYAN   = '\x1b[36m'

let input = ''
process.stdin.on('data', chunk => input += chunk)
process.stdin.on('end', () => {
  let data = {}
  try { data = JSON.parse(input) } catch (_) {}

  const project = path.basename(data.workspace?.current_dir || process.cwd())
  const model   = (data.model?.display_name || 'sonnet').replace('claude-', '')
  const ctxPct  = Math.floor(data.context_window?.used_percentage || 0)
  const cost    = data.cost?.total_cost_usd != null
    ? `$${data.cost.total_cost_usd.toFixed(3)}`
    : ''

  // Agentes disponibles
  const agentsDir = path.join(os.homedir(), '.claude', 'agents')
  const agents = fs.existsSync(agentsDir)
    ? fs.readdirSync(agentsDir).filter(f => f.endsWith('.md')).map(f => f.replace('.md', ''))
    : []

  // Agente activo (si hay uno corriendo)
  const activeFile  = path.join(os.homedir(), '.claude', 'memory', 'active-agent.txt')
  const activeAgent = fs.existsSync(activeFile)
    ? fs.readFileSync(activeFile, 'utf8').trim().toLowerCase()
    : null

  // Design system
  const dsFile = path.join(os.homedir(), '.claude', 'memory', 'design-systems', `${project}.md`)
  const dsTag  = fs.existsSync(dsFile)
    ? `${GREEN}◉ ds${RESET}`
    : `${DIM}○ ds${RESET}`

  const ctxColor = ctxPct > 70 ? YELLOW : ctxPct > 40 ? CYAN : GREEN
  const ctxBar   = `${ctxColor}${ctxPct}% ctx${RESET}`

  // Línea 1 — resumen
  const line1 = [
    `${PURPLE}${BOLD}🐊 uvpln${RESET}`,
    `${WHITE}${project}${RESET}`,
    `${DIM}│${RESET}`,
    dsTag,
    `${DIM}│${RESET}`,
    `${DIM}${model}${RESET}`,
    ctxBar,
    cost ? `${DIM}${cost}${RESET}` : '',
    `${DIM}│${RESET}`,
    `${PURPLE}Cartagena 🇨🇴${RESET}`,
  ].filter(Boolean).join(' ')

  // Línea 2 — agentes, resaltando el activo
  const agentLine = agents.map(a => {
    const isActive = activeAgent && a.toLowerCase().includes(activeAgent)
    if (isActive) {
      return `${PURPLE}${BOLD}◈ ${a}${RESET}` // activo: morado brillante
    }
    return `${GREEN}◈${RESET} ${DIM}${a}${RESET}` // inactivo: verde tenue
  }).join('  ')

  console.log(line1)
  if (agentLine) console.log(agentLine)
})
