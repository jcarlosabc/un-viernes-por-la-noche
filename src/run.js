// src/run.js — comportamiento default: lanzar Claude Code con CLAUDE_CONFIG_DIR=~/.claude-uvpln

const { spawn } = require('child_process')
const { paths, err } = require('./util')

function runDefault(args = []) {
  const env = { ...process.env, CLAUDE_CONFIG_DIR: paths.claudeDir }

  // shell: true es necesario en Windows para resolver 'claude.cmd' / 'claude.ps1'
  const isWin = process.platform === 'win32'
  const child = spawn('claude', args, {
    stdio: 'inherit',
    env,
    shell: isWin,
  })

  child.on('error', (e) => {
    if (e.code === 'ENOENT') {
      err('Claude Code no está instalado o no está en el PATH.')
      err('Instalalo desde: https://claude.ai/code')
    } else {
      err(`Error al lanzar claude: ${e.message}`)
    }
    process.exit(1)
  })

  child.on('exit', (code) => process.exit(code ?? 0))
}

module.exports = { runDefault }
