#!/usr/bin/env node
// uvpln — merge de settings.json del usuario con el de uvpln.
// Idempotente: detecta hooks/statusLine de uvpln por filename y los reemplaza.
// Uso: node merge-settings.js <uvpln-settings.json> <user-settings.json> [--force-statusline]

const fs = require('fs')

const UVPLN_MARKERS = [
  'session-start.js',
  'session-end.js',
  'statusline.cjs',
  'active-agent.txt',
  'uvpln-track-agent-start.js',
  'uvpln-track-agent-end.js',
  'uvpln-check-colors.js',
  'uvpln-check-any.js',
  'uvpln:', // backwards-compat con instalaciones < hooks externalizados
]

const isUvplnCommand = (cmd) =>
  typeof cmd === 'string' && UVPLN_MARKERS.some((m) => cmd.includes(m))

const isUvplnHookGroup = (group) =>
  group && Array.isArray(group.hooks) &&
  group.hooks.some((h) => isUvplnCommand(h && h.command))

const isUvplnStatusLine = (sl) => sl && isUvplnCommand(sl.command)

const uniq = (arr) => [...new Set(arr)]

function mergeHooks(userHooks = {}, uvplnHooks = {}) {
  const out = { ...userHooks }
  for (const event of Object.keys(uvplnHooks)) {
    const userArr = Array.isArray(out[event]) ? out[event] : []
    const cleaned = userArr.filter((g) => !isUvplnHookGroup(g))
    out[event] = [...cleaned, ...uvplnHooks[event]]
  }
  return out
}

function mergePermissions(user = {}, uvpln = {}) {
  const out = { ...user }
  if (Array.isArray(uvpln.allow)) {
    out.allow = uniq([...(user.allow || []), ...uvpln.allow])
  }
  return out
}

function timestamp() {
  return new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19)
}

function main() {
  const argv = process.argv.slice(2)
  const force = argv.includes('--force-statusline')
  const positional = argv.filter((a) => !a.startsWith('--'))
  const [uvplnPath, userPath] = positional

  if (!uvplnPath || !userPath) {
    console.error('uso: merge-settings.js <uvpln-settings> <user-settings> [--force-statusline]')
    process.exit(1)
  }

  let uvpln
  try {
    uvpln = JSON.parse(fs.readFileSync(uvplnPath, 'utf8'))
  } catch (e) {
    console.error(`error leyendo ${uvplnPath}: ${e.message}`)
    process.exit(1)
  }

  const userExists = fs.existsSync(userPath)
  let user = {}
  if (userExists) {
    try {
      user = JSON.parse(fs.readFileSync(userPath, 'utf8'))
    } catch (e) {
      console.error(`error parseando ${userPath}: ${e.message}`)
      console.error('arregla el JSON o borra el archivo y reintenta')
      process.exit(1)
    }
  }

  const merged = { ...user }
  const changes = []
  const notes = []

  if (uvpln.hooks) {
    const before = JSON.stringify(user.hooks || {})
    merged.hooks = mergeHooks(user.hooks, uvpln.hooks)
    if (before !== JSON.stringify(merged.hooks)) changes.push('hooks')
  }

  if (uvpln.statusLine) {
    if (!user.statusLine) {
      merged.statusLine = uvpln.statusLine
      changes.push('statusLine (agregada)')
    } else if (isUvplnStatusLine(user.statusLine)) {
      merged.statusLine = uvpln.statusLine
      changes.push('statusLine (actualizada)')
    } else if (force) {
      merged.statusLine = uvpln.statusLine
      changes.push('statusLine (forzada con --force-statusline)')
    } else {
      notes.push('statusLine respetada — tenés una propia. Para usar la de uvpln: --force-statusline')
    }
  }

  if (uvpln.permissions) {
    const before = JSON.stringify(user.permissions || {})
    merged.permissions = mergePermissions(user.permissions, uvpln.permissions)
    if (before !== JSON.stringify(merged.permissions)) changes.push('permissions.allow')
  }

  if (userExists) {
    const backup = `${userPath}.backup-${timestamp()}`
    fs.copyFileSync(userPath, backup)
    console.log(`  backup: ${backup}`)
  }

  fs.writeFileSync(userPath, JSON.stringify(merged, null, 2) + '\n')

  if (changes.length) {
    console.log('  cambios:')
    for (const c of changes) console.log(`    - ${c}`)
  } else {
    console.log('  sin cambios (settings ya estaba al día)')
  }
  for (const n of notes) console.log(`  nota: ${n}`)
}

main()
