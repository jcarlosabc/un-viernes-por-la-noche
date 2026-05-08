#!/usr/bin/env node
// uvpln — PostToolUse Agent: recuerda registrar una lesson cuando termina ui-tester.
// Si hubo iteración (bug → fix → aprobado), ese par es una lesson valiosa.
// El propio ui-tester escribe la lesson en ~/.claude/memory/lessons/[proyecto].md
// usando su tool Write. Este hook solo recuerda hacerlo.
// No bloquea — es un nudge.

const fs = require('fs')
const path = require('path')
const os = require('os')

// Leer agente activo (lo escribe uvpln-track-agent-start.js)
const activeFile = path.join(os.homedir(), '.claude', 'memory', 'active-agent.txt')
if (!fs.existsSync(activeFile)) process.exit(0)

const agent = fs.readFileSync(activeFile, 'utf8').trim().toLowerCase()

// Solo nos interesa el ui-tester
if (!agent.includes('ui-tester') && !agent.includes('ui_tester')) process.exit(0)

// Identificar el proyecto activo (cwd)
const project = path.basename(process.cwd())

// Asegurar que existe el directorio de lessons
const lessonsDir = path.join(os.homedir(), '.claude', 'memory', 'lessons')
if (!fs.existsSync(lessonsDir)) {
  try { fs.mkdirSync(lessonsDir, { recursive: true }) } catch (_) {}
}

const lessonsFile = path.join(lessonsDir, `${project}.md`)
const exists = fs.existsSync(lessonsFile)
const lessonsCount = exists
  ? (fs.readFileSync(lessonsFile, 'utf8').match(/^## /gm) || []).length
  : 0

console.warn(
  `\n📚 uvpln lessons (${project}): ui-tester terminó.\n` +
  `   Si hubo iteración bug → fix antes de aprobar, registrá la lesson en:\n` +
  `   ${lessonsFile}\n` +
  `   (lessons actuales: ${lessonsCount})\n` +
  `   Formato: ## YYYY-MM-DD — [Componente] / Bug: ... / Fix: ... / Patrón: ...\n`
)
