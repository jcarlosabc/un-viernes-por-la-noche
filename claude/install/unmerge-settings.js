#!/usr/bin/env node
// uvpln — limpieza selectiva de settings.json.
// Elimina solo las entradas de uvpln; preserva toda la config del usuario.
// Uso: node unmerge-settings.js <user-settings.json>

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
  'uvpln-loop-trigger.js',
  'uvpln:',
]

const isUvplnCommand = (cmd) =>
  typeof cmd === 'string' && UVPLN_MARKERS.some((m) => cmd.includes(m))

const isUvplnHookGroup = (group) =>
  group && Array.isArray(group.hooks) &&
  group.hooks.some((h) => isUvplnCommand(h && h.command))

const isUvplnStatusLine = (sl) => sl && isUvplnCommand(sl.command)

function unmergeHooks(hooks = {}) {
  const out = {}
  for (const event of Object.keys(hooks)) {
    const cleaned = (hooks[event] || []).filter((g) => !isUvplnHookGroup(g))
    if (cleaned.length > 0) out[event] = cleaned
  }
  return out
}

function unmergePermissions(perms = {}, uvplnAllow = []) {
  if (!Array.isArray(perms.allow) || uvplnAllow.length === 0) return perms
  const out = { ...perms }
  out.allow = perms.allow.filter((p) => !uvplnAllow.includes(p))
  if (out.allow.length === 0) delete out.allow
  return out
}

function timestamp() {
  return new Date().toISOString().replace(/[:.]/g, '-').slice(0, 19)
}

function main() {
  const [, , userPath] = process.argv
  if (!userPath) {
    console.error('uso: unmerge-settings.js <user-settings.json>')
    process.exit(1)
  }

  if (!fs.existsSync(userPath)) {
    console.log('  settings.json no existe — nada que limpiar')
    process.exit(0)
  }

  let user
  try {
    user = JSON.parse(fs.readFileSync(userPath, 'utf8'))
  } catch (e) {
    console.error(`error parseando ${userPath}: ${e.message}`)
    process.exit(1)
  }

  const backup = `${userPath}.backup-${timestamp()}`
  fs.copyFileSync(userPath, backup)
  console.log(`  backup: ${backup}`)

  const out = { ...user }
  const changes = []

  if (user.hooks) {
    const cleaned = unmergeHooks(user.hooks)
    if (JSON.stringify(cleaned) !== JSON.stringify(user.hooks)) {
      out.hooks = Object.keys(cleaned).length > 0 ? cleaned : undefined
      if (out.hooks === undefined) delete out.hooks
      changes.push('hooks de uvpln removidos')
    }
  }

  if (user.statusLine && isUvplnStatusLine(user.statusLine)) {
    delete out.statusLine
    changes.push('statusLine de uvpln removida')
  }

  // Remueve solo los permisos que uvpln agrega por defecto
  const uvplnDefaultAllow = ['Read', 'Write', 'Edit', 'Glob', 'Grep']
  if (user.permissions) {
    const cleaned = unmergePermissions(user.permissions, uvplnDefaultAllow)
    if (JSON.stringify(cleaned) !== JSON.stringify(user.permissions)) {
      out.permissions = Object.keys(cleaned).length > 0 ? cleaned : undefined
      if (out.permissions === undefined) delete out.permissions
      changes.push('permissions de uvpln removidos')
    }
  }

  if (changes.length === 0) {
    console.log('  sin cambios (no se encontraron entradas de uvpln)')
    fs.unlinkSync(backup)
    process.exit(0)
  }

  const isEmpty = Object.keys(out).length === 0
  if (isEmpty) {
    fs.unlinkSync(userPath)
    console.log('  settings.json estaba solo con config de uvpln — archivo removido')
  } else {
    fs.writeFileSync(userPath, JSON.stringify(out, null, 2) + '\n')
  }

  console.log('  cambios:')
  for (const c of changes) console.log(`    - ${c}`)
}

main()
