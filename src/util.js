// src/util.js — colores, helpers, paths compartidos

const path = require('path')
const os = require('os')

const COLORS = {
  green:   '\x1b[32m',
  yellow:  '\x1b[33m',
  red:     '\x1b[31m',
  magenta: '\x1b[35m',
  cyan:    '\x1b[36m',
  white:   '\x1b[97m',
  bold:    '\x1b[1m',
  dim:     '\x1b[2m',
  reset:   '\x1b[0m',
}

const ok   = (msg) => console.log(`  ${COLORS.green}✓${COLORS.reset} ${msg}`)
const warn = (msg) => console.log(`  ${COLORS.yellow}!${COLORS.reset} ${msg}`)
const err  = (msg) => console.error(`  ${COLORS.red}✗${COLORS.reset} ${msg}`)
const hdr  = (msg) => console.log(`${COLORS.magenta}${COLORS.bold}${msg}${COLORS.reset}`)

// Paths estándar de uvpln (todo aislado en ~/.claude-uvpln/)
const paths = {
  home:       os.homedir(),
  claudeDir:  path.join(os.homedir(), '.claude-uvpln'),
  // Carpeta del paquete instalado (donde están los archivos fuente)
  pkgDir:     path.resolve(__dirname, '..'),
  // Carpeta claude/ dentro del paquete (la fuente para copiar)
  srcDir:     path.resolve(__dirname, '..', 'claude'),
}

// Copia recursiva simple (sin dependencias externas)
function copyDir(src, dst) {
  const fs = require('fs')
  fs.mkdirSync(dst, { recursive: true })
  for (const entry of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, entry.name)
    const d = path.join(dst, entry.name)
    if (entry.isDirectory()) {
      copyDir(s, d)
    } else {
      fs.copyFileSync(s, d)
    }
  }
}

module.exports = { COLORS, ok, warn, err, hdr, paths, copyDir }
