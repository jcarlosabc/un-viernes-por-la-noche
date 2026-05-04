import { describe, test, expect, beforeEach, afterEach } from 'vitest'
import { spawnSync } from 'node:child_process'
import { mkdtempSync, rmSync, existsSync, readFileSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const ROOT = join(__dirname, '..', '..')
const START = join(ROOT, 'claude', 'hooks', 'uvpln-track-agent-start.js')
const END = join(ROOT, 'claude', 'hooks', 'uvpln-track-agent-end.js')

let home
beforeEach(() => { home = mkdtempSync(join(tmpdir(), 'uvpln-home-')) })
afterEach(() => { rmSync(home, { recursive: true, force: true }) })

const activePath = () => join(home, '.claude', 'memory', 'active-agent.txt')
const env = () => ({ ...process.env, HOME: home, USERPROFILE: home })

describe('track-agent-start', () => {
  test('escribe subagent_type', () => {
    const r = spawnSync('node', [START], { env: env(), input: JSON.stringify({ subagent_type: 'ui-architect' }) })
    expect(r.status).toBe(0)
    expect(existsSync(activePath())).toBe(true)
    expect(readFileSync(activePath(), 'utf8')).toBe('ui-architect')
  })

  test('fallback a description', () => {
    spawnSync('node', [START], { env: env(), input: JSON.stringify({ description: 'mi tarea' }) })
    expect(readFileSync(activePath(), 'utf8')).toBe('mi tarea')
  })

  test('silencio en JSON inválido (no falla)', () => {
    const r = spawnSync('node', [START], { env: env(), input: 'no-json-aqui' })
    expect(r.status).toBe(0)
    expect(existsSync(activePath())).toBe(false)
  })
})

describe('track-agent-end', () => {
  test('borra active-agent.txt', () => {
    spawnSync('node', [START], { env: env(), input: JSON.stringify({ subagent_type: 'x' }) })
    expect(existsSync(activePath())).toBe(true)
    spawnSync('node', [END], { env: env() })
    expect(existsSync(activePath())).toBe(false)
  })

  test('no falla si el archivo no existe', () => {
    const r = spawnSync('node', [END], { env: env() })
    expect(r.status).toBe(0)
  })
})
