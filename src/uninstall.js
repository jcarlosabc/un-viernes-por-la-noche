// src/uninstall.js — desinstala uvpln (no toca Claude vanilla)

const fs = require('fs')
const path = require('path')
const readline = require('readline')
const { execSync } = require('child_process')
const { COLORS, ok, warn, hdr, paths } = require('./util')

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
    return
  }

  // Confirmación (a menos que --yes)
  if (!opts.yes) {
    const msg = opts.full
      ? `  Se va a borrar TODO ${DST} y desinstalar el paquete npm. Irreversible. ¿Seguir? [y/N] `
      : `  Se va a borrar ${DST} (preserva tu memory/design-systems/). ¿Seguir? [y/N] `
    const answer = await ask(msg)
    if (!/^(y|yes|s|si)$/i.test(answer.trim())) {
      console.log('  Cancelado.')
      return
    }
  }

  if (opts.full) {
    fs.rmSync(DST, { recursive: true, force: true })
    ok(`Removido: ${DST} (todo)`)
    console.log()
    console.log(`  Desinstalando paquete npm...`)
    try {
      execSync('npm uninstall -g uvpln', { stdio: 'inherit' })
    } catch {
      warn('No se pudo desinstalar el paquete npm automáticamente.')
      warn(`Corre manualmente: npm uninstall -g uvpln`)
    }
  } else {
    // Borrar archivos uvpln pero preservar memory/ y runtime state
    const toRemove = [
      'agents', 'hooks', 'commands', 'templates', 'examples', 'install',
      'session-start.js', 'session-end.js', 'session-start.ps1', 'session-end.ps1',
      'statusline.cjs', 'agents-config.js',
      'settings.json', 'CLAUDE.md', 'CLAUDE.md.backup',
    ]
    let removed = 0
    for (const item of toRemove) {
      const p = path.join(DST, item)
      if (fs.existsSync(p)) {
        fs.rmSync(p, { recursive: true, force: true })
        ok(`Removido: ${item}`)
        removed++
      }
    }
    if (removed === 0) {
      warn('No había nada de uvpln para remover.')
    } else {
      warn(`memory/, sessions/, projects/ preservados (tu data personal queda).`)
      console.log(`  Para borrar TODO incluyendo memoria: ${COLORS.cyan}uvpln uninstall --full${COLORS.reset}`)
    }
  }

  console.log()
  hdr('  uvpln desinstalado. Tu Claude Code vanilla sigue intacto.')
  console.log()
}

module.exports = { uninstallCmd }
