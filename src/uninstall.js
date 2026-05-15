// src/uninstall.js — desinstala uvpln (no toca Claude vanilla)

const fs = require('fs')
const path = require('path')
const readline = require('readline')
const { execSync } = require('child_process')
const { COLORS, ok, warn, hdr, paths } = require('./util')

// Limpia archivos uvpln que pudieron haber quedado en ~/.claude/ (vanilla).
// Pasa sin error si no hay nada que borrar.
function cleanupVanilla() {
  const vanilla = path.join(paths.home, '.claude')
  const targets = [
    { dir: path.join(vanilla, 'commands'), pattern: /^uvpln-.*\.md$/ },
    { dir: path.join(vanilla, 'hooks'),    pattern: /^uvpln-.*\.js$/ },
  ]
  let leaked = 0
  for (const { dir, pattern } of targets) {
    if (!fs.existsSync(dir)) continue
    for (const f of fs.readdirSync(dir)) {
      if (!pattern.test(f)) continue
      fs.rmSync(path.join(dir, f), { force: true })
      warn(`Limpiado de ~/.claude/: ${path.relative(vanilla, path.join(dir, f))}`)
      leaked++
    }
  }
  const activeAgent = path.join(vanilla, 'memory', 'active-agent.txt')
  if (fs.existsSync(activeAgent)) fs.rmSync(activeAgent, { force: true })
  if (leaked > 0) warn(`${leaked} archivo(s) de uvpln removidos de ~/.claude/ (estaban en vanilla)`)
}

function ask(question) {
  return new Promise((resolve) => {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout })
    rl.question(question, (answer) => {
      rl.close()
      resolve(answer)
    })
  })
}

async function uninstallCmd(opts = {}) {
  hdr('\n  uvpln — desinstalador')
  console.log(`  ${COLORS.dim}Tu Claude Code vanilla NUNCA se toca por este comando.${COLORS.reset}\n`)

  const DST = paths.claudeDir

  if (!fs.existsSync(DST)) {
    warn(`${DST} no existe — uvpln ya estaba desinstalado.`)
    cleanupVanilla()
    return
  }

  if (!opts.yes) {
    const answer = await ask(`  Se va a borrar ${DST} por completo. ¿Seguir? [y/N] `)
    if (!/^(y|yes|s|si)$/i.test(answer.trim())) {
      console.log('  Cancelado.')
      return
    }
  }

  fs.rmSync(DST, { recursive: true, force: true })
  ok(`~/.claude-uvpln/ eliminado`)
  cleanupVanilla()

  console.log()
  hdr('  uvpln desinstalado. Tu Claude Code vanilla sigue intacto.')
  console.log()
}

module.exports = { uninstallCmd }
