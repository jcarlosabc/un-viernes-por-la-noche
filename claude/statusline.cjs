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

  // Hooks disponibles (los uvpln-*)
  const hooksDir = path.join(os.homedir(), '.claude', 'hooks')
  const hookFiles = fs.existsSync(hooksDir)
    ? fs.readdirSync(hooksDir).filter(f => f.startsWith('uvpln-') && f.endsWith('.js'))
    : []
  const hooksCount = hookFiles.length
  const securityHooks = hookFiles.filter(f =>
    /uvpln-check-(secrets|target-blank|dangerous-html|localstorage-token)/.test(f)
  ).length

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

  // Indicadores de protección
  const agentsTag = `${GREEN}${agents.length}${RESET}${DIM} agentes${RESET}`
  const hooksTag = securityHooks > 0
    ? `${PURPLE}🔒${RESET} ${GREEN}${hooksCount}${RESET}${DIM} hooks${RESET}`
    : `${GREEN}${hooksCount}${RESET}${DIM} hooks${RESET}`

  // Línea 1 — resumen
  const line1 = [
    `${PURPLE}${BOLD}🐊 uvpln${RESET}`,
    `${WHITE}${project}${RESET}`,
    `${DIM}│${RESET}`,
    agentsTag,
    hooksTag,
    `${DIM}│${RESET}`,
    dsTag,
    `${DIM}│${RESET}`,
    `${DIM}${model}${RESET}`,
    ctxBar,
    cost ? `${DIM}${cost}${RESET}` : '',
    `${DIM}│${RESET}`,
    `${PURPLE}Cartagena 🇨🇴${RESET}`,
  ].filter(Boolean).join(' ')

  // Iconos por agente (mapping)
  const AGENT_ICONS = {
    'ux-researcher':         '🔍',
    'design-bridge':         '🌉',
    'ui-designer':           '🎨',
    'ui-architect':          '🏗️',
    'ui-tester':             '🧪',
    'debugger':              '🐛',
    'a11y-expert':           '♿',
    'motion-designer':       '✨',
    'tokens-manager':        '🪙',
    'performance-ui':        '⚡',
    'code-reviewer':         '👁️',
    'refactoring-specialist':'🔧',
    'api-integrator':        '🔌',
    'form-specialist':       '📝',
    'state-manager':         '🧠',
    'security-frontend':     '🔒',
  }

  // Línea 2 — agentes con iconos, resaltando el activo
  const agentLine = agents.map(a => {
    const icon = AGENT_ICONS[a] || '◈'
    const isActive = activeAgent && a.toLowerCase().includes(activeAgent)
    if (isActive) {
      return `${PURPLE}${BOLD}${icon} ${a}${RESET}` // activo: morado brillante
    }
    return `${icon} ${DIM}${a}${RESET}` // inactivo: icono natural + nombre tenue
  }).join('  ')

  console.log(line1)
  if (agentLine) console.log(agentLine)
})
