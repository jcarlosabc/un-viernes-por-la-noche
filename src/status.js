// src/status.js — muestra el estado de la instalación

const fs = require('fs')
const path = require('path')
const pkg = require('../package.json')
const { COLORS, ok, warn, hdr, paths } = require('./util')

function countFiles(dir, ext) {
  if (!fs.existsSync(dir)) return 0
  return fs.readdirSync(dir).filter((f) => f.endsWith(ext)).length
}

function statusCmd() {
  hdr(`\n  uvpln v${pkg.version} — estado de la instalación`)
  console.log()

  const DST = paths.claudeDir

  if (!fs.existsSync(DST)) {
    warn('uvpln NO está instalado.')
    console.log()
    console.log(`  Para instalar: ${COLORS.cyan}uvpln install${COLORS.reset}`)
    console.log()
    return
  }

  console.log(`  ${COLORS.dim}Ubicación:${COLORS.reset}  ${DST}`)
  console.log(`  ${COLORS.dim}Vanilla:${COLORS.reset}    ${path.join(paths.home, '.claude')} ${COLORS.dim}(no tocado)${COLORS.reset}`)
  console.log()

  const counts = {
    agentes:   countFiles(path.join(DST, 'agents'), '.md'),
    hooks:     countFiles(path.join(DST, 'hooks'), '.js'),
    comandos:  countFiles(path.join(DST, 'commands'), '.md'),
    templates: countFiles(path.join(DST, 'templates'), '.md'),
    examples:  countFiles(path.join(DST, 'examples'), '.md'),
  }

  for (const [name, n] of Object.entries(counts)) {
    const color = n > 0 ? COLORS.green : COLORS.dim
    const pad = name.padEnd(10)
    console.log(`  ${pad} ${color}${n}${COLORS.reset}`)
  }

  // Scripts top-level
  const scripts = ['session-start.js', 'session-end.js', 'statusline.cjs', 'agents-config.js']
  const presentScripts = scripts.filter((s) => fs.existsSync(path.join(DST, s)))
  console.log(`  ${'scripts'.padEnd(10)} ${COLORS.green}${presentScripts.length}${COLORS.reset}${COLORS.dim}/${scripts.length}${COLORS.reset}`)

  // Settings
  console.log(`  ${'settings'.padEnd(10)} ${fs.existsSync(path.join(DST, 'settings.json')) ? COLORS.green + 'sí' : COLORS.red + 'no'}${COLORS.reset}`)
  console.log(`  ${'CLAUDE.md'.padEnd(10)} ${fs.existsSync(path.join(DST, 'CLAUDE.md')) ? COLORS.green + 'sí' : COLORS.red + 'no'}${COLORS.reset}`)

  // Memoria de design systems
  console.log()
  const dsDir = path.join(DST, 'memory', 'design-systems')
  if (fs.existsSync(dsDir)) {
    const projects = fs.readdirSync(dsDir).filter((f) => f.endsWith('.md'))
    console.log(`  ${COLORS.dim}Design systems guardados:${COLORS.reset} ${projects.length}`)
    if (projects.length > 0 && projects.length <= 8) {
      for (const p of projects) {
        console.log(`    ${COLORS.dim}-${COLORS.reset} ${p.replace('.md', '')}`)
      }
    }
  }

  console.log()
  ok('uvpln instalado correctamente.')
  console.log()
}

module.exports = { statusCmd }
