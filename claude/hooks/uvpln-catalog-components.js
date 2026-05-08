#!/usr/bin/env node
// uvpln — SessionStart: escanea src/components/**/*.tsx del proyecto activo
// y genera ~/.claude/memory/catalog/[proyecto].md con un índice.
// ui-architect lo lee antes de crear un componente nuevo (evita duplicación).
// No bloquea — silencioso si no hay src/components.

const fs = require('fs')
const path = require('path')
const os = require('os')

const project = path.basename(process.cwd())
const componentsDir = path.join(process.cwd(), 'src', 'components')

// Si no hay src/components, intentar variantes comunes
const candidates = [
  componentsDir,
  path.join(process.cwd(), 'components'),
  path.join(process.cwd(), 'app', 'components'),
]
const dir = candidates.find(d => fs.existsSync(d))
if (!dir) process.exit(0)

// Walker recursivo simple
function walk(d, base = d) {
  const out = []
  let entries = []
  try { entries = fs.readdirSync(d, { withFileTypes: true }) } catch (_) { return out }
  for (const e of entries) {
    const full = path.join(d, e.name)
    if (e.isDirectory()) {
      // Skip node_modules y .next por si acaso
      if (['node_modules', '.next', 'dist', 'build'].includes(e.name)) continue
      out.push(...walk(full, base))
    } else if (/\.(tsx|jsx)$/.test(e.name) && !e.name.endsWith('.test.tsx') && !e.name.endsWith('.test.jsx')) {
      out.push(path.relative(base, full))
    }
  }
  return out
}

const files = walk(dir)
if (files.length === 0) process.exit(0)

// Agrupar por subdirectorio del primer nivel
const groups = {}
for (const f of files) {
  const segments = f.split(path.sep)
  const group = segments.length > 1 ? segments[0] : '(root)'
  if (!groups[group]) groups[group] = []
  // Extraer nombre del componente del nombre de archivo (PascalCase típico)
  const base = path.basename(f, path.extname(f))
  groups[group].push({ name: base, file: f })
}

// Generar markdown
const lines = [
  `# Catálogo de componentes — ${project}`,
  '',
  `_Auto-generado al iniciar la sesión. Total: ${files.length} componentes._`,
  '',
  '> **ui-architect**: consultá esta lista antes de crear un componente nuevo. Si existe algo similar, extender o reutilizar en lugar de duplicar.',
  '',
]

for (const group of Object.keys(groups).sort()) {
  lines.push(`## ${group}/`)
  lines.push('')
  for (const c of groups[group]) {
    lines.push(`- **${c.name}** — \`${c.file}\``)
  }
  lines.push('')
}

// Asegurar directorio
const catalogDir = path.join(os.homedir(), '.claude', 'memory', 'catalog')
if (!fs.existsSync(catalogDir)) {
  try { fs.mkdirSync(catalogDir, { recursive: true }) } catch (_) {}
}

const outFile = path.join(catalogDir, `${project}.md`)
fs.writeFileSync(outFile, lines.join('\n'), 'utf8')
