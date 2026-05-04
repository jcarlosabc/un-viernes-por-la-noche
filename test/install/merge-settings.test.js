const { describe, test, expect, beforeEach, afterEach } = require('vitest')
const { spawnSync } = require('child_process')
const { mkdtempSync, rmSync, writeFileSync, readFileSync, copyFileSync } = require('fs')
const { tmpdir } = require('os')
const { join } = require('path')

const ROOT = join(__dirname, '..', '..')
const MERGE = join(ROOT, 'claude', 'install', 'merge-settings.js')
const UVPLN = join(ROOT, 'claude', 'settings.json')

let dir
beforeEach(() => { dir = mkdtempSync(join(tmpdir(), 'uvpln-merge-')) })
afterEach(() => { rmSync(dir, { recursive: true, force: true }) })

const run = (target, ...flags) => spawnSync('node', [MERGE, UVPLN, target, ...flags])
const read = (p) => JSON.parse(readFileSync(p, 'utf8'))

describe('merge-settings', () => {
  test('crea settings nuevo cuando no existe', () => {
    const t = join(dir, 'new.json')
    expect(run(t).status).toBe(0)
    const j = read(t)
    expect(Object.keys(j.hooks)).toEqual(
      expect.arrayContaining(['SessionStart', 'SessionEnd', 'PreToolUse', 'PostToolUse'])
    )
    expect(j.statusLine).toBeDefined()
  })

  test('preserva claves del usuario (theme, model, etc.)', () => {
    const t = join(dir, 'with-other.json')
    writeFileSync(t, JSON.stringify({ theme: 'dark', model: 'claude-opus-4-7' }))
    run(t)
    const j = read(t)
    expect(j.theme).toBe('dark')
    expect(j.model).toBe('claude-opus-4-7')
  })

  test('preserva hooks ajenos en el mismo evento', () => {
    const t = join(dir, 'mixed.json')
    writeFileSync(t, JSON.stringify({
      hooks: {
        PreToolUse: [{ matcher: 'Bash', hooks: [{ type: 'command', command: 'echo hook-propio' }] }],
      },
    }))
    run(t)
    const j = read(t)
    expect(j.hooks.PreToolUse.some((g) => g.hooks[0].command.includes('hook-propio'))).toBe(true)
    expect(j.hooks.PreToolUse.length).toBe(3) // 1 ajeno + 2 uvpln
  })

  test('respeta statusLine del usuario por default', () => {
    const t = join(dir, 'sl.json')
    writeFileSync(t, JSON.stringify({ statusLine: { type: 'command', command: 'mi-statusline' } }))
    run(t)
    expect(read(t).statusLine.command).toBe('mi-statusline')
  })

  test('--force-statusline pisa la del usuario', () => {
    const t = join(dir, 'sl.json')
    writeFileSync(t, JSON.stringify({ statusLine: { type: 'command', command: 'mi-statusline' } }))
    run(t, '--force-statusline')
    expect(read(t).statusLine.command).toContain('statusline.cjs')
  })

  test('idempotente — 5 instalaciones consecutivas', () => {
    const t = join(dir, 'idem.json')
    copyFileSync(UVPLN, t)
    for (let i = 0; i < 5; i++) run(t)
    const j = read(t)
    expect(j.hooks.SessionStart.length).toBe(1)
    expect(j.hooks.SessionEnd.length).toBe(1)
    expect(j.hooks.PreToolUse.length).toBe(2)
    expect(j.hooks.PostToolUse.length).toBe(2)
  })

  test('migra commands inline viejos (backwards-compat)', () => {
    const t = join(dir, 'old.json')
    writeFileSync(t, JSON.stringify({
      hooks: {
        PreToolUse: [{
          matcher: 'Write|Edit',
          hooks: [{ type: 'command', command: "node -e \"console.error('uvpln: x'); process.exit(2);\"" }],
        }],
      },
    }))
    run(t)
    const cmd = read(t).hooks.PreToolUse.find((g) => g.matcher === 'Write|Edit').hooks[0].command
    expect(cmd).toContain('uvpln-check-colors.js')
  })

  test('genera backup con timestamp', () => {
    const t = join(dir, 'bk.json')
    writeFileSync(t, '{}')
    const r = run(t)
    expect(r.stdout.toString()).toMatch(/backup:.*\.backup-\d{4}-\d{2}-\d{2}/)
  })

  test('falla con exit 1 si JSON inválido', () => {
    const t = join(dir, 'broken.json')
    writeFileSync(t, '{ esto no es json')
    const r = run(t)
    expect(r.status).toBe(1)
    expect(r.stderr.toString()).toMatch(/parseando|JSON/)
  })
})
