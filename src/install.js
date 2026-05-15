// src/install.js — instala uvpln en ~/.claude-uvpln/ (aislado, no toca vanilla)

const fs = require('fs')
const path = require('path')
const { execFileSync } = require('child_process')
const { COLORS, ok, warn, err, hdr, paths, copyDir } = require('./util')

function installCmd(opts = {}) {
  hdr('\n  uvpln — instalador (modo aislado)')
  console.log(`  ${COLORS.dim}No toca tu Claude Code vanilla. Todo va a ~/.claude-uvpln/${COLORS.reset}\n`)

  const SRC = paths.srcDir
  const DST = paths.claudeDir

  if (!fs.existsSync(SRC)) {
    err(`No encuentro la carpeta claude/ en el paquete (${SRC}).`)
    err('Si instalaste desde npm, esto sería un bug. Reportá: https://github.com/jcarlosabc/un-viernes-por-la-noche/issues')
    process.exit(1)
  }

  // 1. Crear estructura de directorios
  const subdirs = ['agents', 'hooks', 'commands', 'templates', 'examples', 'memory/design-systems']
  for (const d of subdirs) {
    fs.mkdirSync(path.join(DST, d), { recursive: true })
  }
  ok(`Estructura creada en ${DST}`)

  // 2. CLAUDE.md (con backup si ya existe)
  const claudeMdDst = path.join(DST, 'CLAUDE.md')
  if (fs.existsSync(claudeMdDst)) {
    fs.copyFileSync(claudeMdDst, path.join(DST, 'CLAUDE.md.backup'))
    warn('CLAUDE.md existente respaldado en CLAUDE.md.backup')
  }
  fs.copyFileSync(path.join(SRC, 'CLAUDE.md'), claudeMdDst)
  ok('CLAUDE.md instalado')

  // 3. Carpetas con archivos (agents, hooks, commands, templates, examples)
  for (const folder of ['agents', 'hooks', 'commands', 'templates', 'examples']) {
    const srcFolder = path.join(SRC, folder)
    const dstFolder = path.join(DST, folder)
    if (!fs.existsSync(srcFolder)) {
      warn(`Carpeta ${folder}/ no existe en el paquete — saltando`)
      continue
    }
    const files = fs.readdirSync(srcFolder)
    for (const f of files) {
      fs.copyFileSync(path.join(srcFolder, f), path.join(dstFolder, f))
    }
    ok(`${folder}/ — ${files.length} archivo${files.length === 1 ? '' : 's'}`)
  }

  // 4. Scripts top-level (session-start, session-end, statusline, agents-config)
  const scripts = ['session-start.js', 'session-end.js', 'statusline.cjs', 'agents-config.js']
  for (const f of scripts) {
    const src = path.join(SRC, f)
    if (!fs.existsSync(src)) {
      warn(`${f} no existe — saltando`)
      continue
    }
    fs.copyFileSync(src, path.join(DST, f))
  }
  ok(`Scripts: ${scripts.join(', ')}`)

  // 5. settings.json — instalar limpio o mergear con existente
  const settingsDst = path.join(DST, 'settings.json')
  const settingsSrc = path.join(SRC, 'settings.json')
  const mergeScript = path.join(SRC, 'install', 'merge-settings.js')

  if (!fs.existsSync(settingsDst)) {
    fs.copyFileSync(settingsSrc, settingsDst)
    ok('settings.json instalado')
  } else if (fs.existsSync(mergeScript)) {
    try {
      const out = execFileSync('node', [mergeScript, settingsSrc, settingsDst], { encoding: 'utf8' })
      if (out.trim()) console.log(out.trimEnd())
      ok('settings.json mergeado (preservó tu config previa)')
    } catch (e) {
      err(`Falló el merge de settings.json: ${e.message}`)
      err(`Backup automático en ${settingsDst}.backup-*`)
    }
  } else {
    warn('merge-settings.js no encontrado — sobrescribiendo settings.json (backup en .backup)')
    fs.copyFileSync(settingsDst, settingsDst + '.backup')
    fs.copyFileSync(settingsSrc, settingsDst)
  }

  // 6. Mensaje final
  console.log()
  hdr('  ¡Listo! uvpln instalado en modo aislado.')
  console.log()
  console.log('  Cómo usar:')
  console.log(`    ${COLORS.green}claude${COLORS.reset}   → Claude Code vanilla (intacto)`)
  console.log(`    ${COLORS.magenta}uvpln${COLORS.reset}    → Claude Code con uvpln (23 agentes, hooks, statusline)`)
  console.log()
  console.log('  Probalo ahora:')
  console.log(`    ${COLORS.magenta}uvpln${COLORS.reset}`)
  console.log()
  console.log('  Otros comandos útiles:')
  console.log(`    ${COLORS.dim}uvpln status${COLORS.reset}    Ver qué está instalado`)
  console.log(`    ${COLORS.dim}uvpln uninstall${COLORS.reset} Desinstalar uvpln`)
  console.log(`    ${COLORS.dim}uvpln --help${COLORS.reset}    Ver todos los comandos`)
  console.log()
}

module.exports = { installCmd }
