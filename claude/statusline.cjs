#!/usr/bin/env node
// uvpln statusline — Un Viernes Por La Noche

const os = require('os')
const path = require('path')
const fs = require('fs')

const PURPLE = '\x1b[35m'
const GREEN  = '\x1b[32m'
const WHITE  = '\x1b[97m'
const DIM    = '\x1b[2m'
const BOLD   = '\x1b[1m'
const RESET  = '\x1b[0m'

let input = ''
process.stdin.on('data', chunk => input += chunk)
process.stdin.on('end', () => {
  let data = {}
  try { data = JSON.parse(input) } catch (_) {}

  const project  = path.basename(data.workspace?.current_dir || process.cwd())
  const model    = (data.model?.display_name || 'sonnet').replace('claude-', '')
  const ctxPct   = Math.floor(data.context_window?.used_percentage || 0)
  const cost     = data.cost?.total_cost_usd != null
    ? `$${data.cost.total_cost_usd.toFixed(3)}`
    : ''

  const agentsDir  = path.join(os.homedir(), '.claude', 'agents')
  const agentCount = fs.existsSync(agentsDir)
    ? fs.readdirSync(agentsDir).filter(f => f.endsWith('.md')).length
    : 0

  const dsFile = path.join(os.homedir(), '.claude', 'memory', 'design-systems', `${project}.md`)
  const dsTag  = fs.existsSync(dsFile)
    ? `${GREEN}◉ design system${RESET}`
    : `${DIM}○ sin design system${RESET}`

  const ctxColor = ctxPct > 70 ? '\x1b[33m' : ctxPct > 40 ? '\x1b[36m' : GREEN
  const ctxBar   = `${ctxColor}${ctxPct}% ctx${RESET}`

  const parts = [
    `${PURPLE}${BOLD}🐊 uvpln${RESET}`,
    `${WHITE}${project}${RESET}`,
    `${DIM}│${RESET}`,
    `${GREEN}${agentCount} agentes${RESET}`,
    `${DIM}│${RESET}`,
    dsTag,
    `${DIM}│${RESET}`,
    `${DIM}${model}${RESET}`,
    ctxBar,
    cost ? `${DIM}${cost}${RESET}` : '',
    `${DIM}│${RESET}`,
    `${PURPLE}Cartagena 🇨🇴${RESET}`,
  ].filter(Boolean).join(' ')

  console.log(parts)
})
