#!/usr/bin/env node
const os   = require('os')
const path = require('path')
const fs   = require('fs')

// Soporta tanto instalación oficial (~/.claude) como aislada (CLAUDE_CONFIG_DIR=~/.claude-uvpln).
const CLAUDE_DIR = process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude')

const PURPLE    = '\x1b[35m'
const MAGENTA   = '\x1b[95m'
const GREEN     = '\x1b[32m'
const WHITE     = '\x1b[97m'
const DIM       = '\x1b[2m'
const BOLD      = '\x1b[1m'
const BLINK     = '\x1b[5m'
const RESET     = '\x1b[0m'
const YELLOW    = '\x1b[33m'
const CYAN      = '\x1b[36m'
const BG_PURPLE = '\x1b[45m'

// Configuración compartida (íconos + categorías).
let CATEGORIES = []
let AGENT_ICONS = {}
try {
  const cfg = require(path.join(CLAUDE_DIR, 'agents-config.js'))
  CATEGORIES = cfg.CATEGORIES || []
  AGENT_ICONS = cfg.AGENT_ICONS || {}
} catch (_) {
  // Sin config compartida → fallback a lista plana sin categorías.
}

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

  // Agentes en disco
  const agentsDir = path.join(CLAUDE_DIR, 'agents')
  const onDisk = fs.existsSync(agentsDir)
    ? new Set(fs.readdirSync(agentsDir).filter(f => f.endsWith('.md')).map(f => f.replace('.md', '')))
    : new Set()

  // Hooks (los uvpln-*)
  const hooksDir = path.join(CLAUDE_DIR, 'hooks')
  const hookFiles = fs.existsSync(hooksDir)
    ? fs.readdirSync(hooksDir).filter(f => f.startsWith('uvpln-') && f.endsWith('.js'))
    : []
  const hooksCount = hookFiles.length
  const securityHooks = hookFiles.filter(f =>
    /uvpln-check-(secrets|target-blank|dangerous-html|localstorage-token)/.test(f)
  ).length

  // Agente activo + cuándo arrancó
  const activeFile = path.join(CLAUDE_DIR, 'memory', 'active-agent.txt')
  let activeAgent = null
  let activeElapsed = 0
  if (fs.existsSync(activeFile)) {
    activeAgent = fs.readFileSync(activeFile, 'utf8').trim().toLowerCase()
    const startedAt = fs.statSync(activeFile).mtimeMs
    activeElapsed = Math.max(0, Math.floor((Date.now() - startedAt) / 1000))
  }

  // Spinner discreto — gira un frame por cada refresh
  const SPINNER = ['⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏']
  const spinnerFrame = SPINNER[Math.floor(Date.now() / 200) % SPINNER.length]

  // Design system
  const dsFile = path.join(CLAUDE_DIR, 'memory', 'design-systems', `${project}.md`)
  const dsTag  = fs.existsSync(dsFile)
    ? `${GREEN}◉ ds${RESET}`
    : `${DIM}○ ds${RESET}`

  const ctxColor = ctxPct > 70 ? YELLOW : ctxPct > 40 ? CYAN : GREEN
  const ctxBar   = `${ctxColor}${ctxPct}% ctx${RESET}`

  // Tags de protección
  const agentsTag = `${GREEN}${onDisk.size}${RESET}${DIM} agentes${RESET}`
  const hooksTag = securityHooks > 0
    ? `${PURPLE}🔒${RESET} ${GREEN}${hooksCount}${RESET}${DIM} hooks${RESET}`
    : `${GREEN}${hooksCount}${RESET}${DIM} hooks${RESET}`

  // Cronómetro de sesión (lee mtime de memory/session-start.txt)
  const sessionFile = path.join(CLAUDE_DIR, 'memory', 'session-start.txt')
  let sessionTag = null
  if (fs.existsSync(sessionFile)) {
    const seconds = Math.max(0, Math.floor((Date.now() - fs.statSync(sessionFile).mtimeMs) / 1000))
    let label
    if (seconds < 60) label = `${seconds}s`
    else if (seconds < 3600) label = `${Math.floor(seconds / 60)}m`
    else label = `${Math.floor(seconds / 3600)}h ${Math.floor((seconds % 3600) / 60)}m`
    sessionTag = `${CYAN}⏰ ${label}${RESET}`
  }

  // Git branch + estado (rápido — lee .git/HEAD directo)
  const cwd = data.workspace?.current_dir || process.cwd()
  let gitTag = null
  let gitDir = cwd
  while (gitDir && gitDir !== path.dirname(gitDir)) {
    if (fs.existsSync(path.join(gitDir, '.git'))) break
    gitDir = path.dirname(gitDir)
  }
  if (gitDir && fs.existsSync(path.join(gitDir, '.git', 'HEAD'))) {
    try {
      const head = fs.readFileSync(path.join(gitDir, '.git', 'HEAD'), 'utf8').trim()
      const m = head.match(/^ref: refs\/heads\/(.+)$/)
      const branch = m ? m[1] : head.slice(0, 7)
      let dirty = false
      try {
        const { execSync } = require('child_process')
        const out = execSync('git status --porcelain', { cwd: gitDir, timeout: 500, stdio: ['ignore', 'pipe', 'ignore'] }).toString()
        dirty = out.trim().length > 0
      } catch (_) {}
      gitTag = `${GREEN}🌿 ${branch}${RESET} ${dirty ? `${YELLOW}●${RESET}` : `${DIM}○${RESET}`}`
    } catch (_) {}
  }

  // Línea 1 — resumen
  const line1 = [
    `${PURPLE}${BOLD}🐊 uvpln${RESET}`,
    `${WHITE}${project}${RESET}`,
    `${DIM}│${RESET}`,
    agentsTag,
    hooksTag,
    `${DIM}│${RESET}`,
    gitTag,
    sessionTag,
    `${DIM}│${RESET}`,
    dsTag,
    `${DIM}│${RESET}`,
    `${DIM}${model}${RESET}`,
    ctxBar,
    cost ? `${DIM}${cost}${RESET}` : '',
  ].filter(Boolean).join(' ')

  console.log(line1)

  // Barra prominente cuando hay agente corriendo
  if (activeAgent) {
    let activeIcon = '◈'
    let activeDisplayName = activeAgent
    for (const name of Object.keys(AGENT_ICONS)) {
      if (name.toLowerCase().includes(activeAgent)) {
        activeIcon = AGENT_ICONS[name]
        activeDisplayName = name
        break
      }
    }
    const bar = [
      `${BLINK}${MAGENTA}▶${RESET}`,
      `${BG_PURPLE}${WHITE}${BOLD} ACTIVO ${RESET}`,
      `${MAGENTA}${BOLD}${activeIcon} ${activeDisplayName}${RESET}`,
      `${DIM}│${RESET}`,
      `${CYAN}⏱ ${activeElapsed}s${RESET}`,
      `${MAGENTA}${spinnerFrame}${RESET}`,
    ].join(' ')
    console.log(bar)
  }

  // Render por categoría (si hay config) o flat (fallback)
  const renderAgent = (name, icon) => {
    const isActive = activeAgent && name.toLowerCase().includes(activeAgent)
    if (isActive) {
      return `${BLINK}${BG_PURPLE}${WHITE}${BOLD} ${icon} ${name} ${RESET}`
    }
    return `${icon} ${DIM}${name}${RESET}`
  }

  if (CATEGORIES.length > 0) {
    const categorized = new Set()
    CATEGORIES.forEach(cat => {
      const entries = Object.entries(cat.agents).filter(([name]) => onDisk.has(name))
      if (entries.length === 0) return
      const tokens = entries.map(([name, icon]) => {
        categorized.add(name)
        return renderAgent(name, icon)
      })
      const header = `${BOLD}${cat.icon} ${cat.name}${RESET}${DIM}│${RESET}`
      console.log(`${header} ${tokens.join('   ')}`)
    })

    // Agentes en disco sin categoría asignada
    const orphans = [...onDisk].filter(a => !categorized.has(a))
    if (orphans.length > 0) {
      const tokens = orphans.map(name => renderAgent(name, '◈'))
      console.log(`${BOLD}❓ Otros${RESET}${DIM}│${RESET} ${tokens.join('   ')}`)
    }
  } else {
    // Fallback: lista plana
    const tokens = [...onDisk].map(name => renderAgent(name, AGENT_ICONS[name] || '◈'))
    if (tokens.length > 0) console.log(tokens.join('  '))
  }
})
