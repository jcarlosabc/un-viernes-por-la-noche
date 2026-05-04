import { describe, test, expect, beforeEach, afterEach } from 'vitest'
import { spawnSync } from 'node:child_process'
import { writeFileSync, mkdtempSync, rmSync } from 'node:fs'
import { tmpdir } from 'node:os'
import { join, dirname } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))
const HOOK = join(__dirname, '..', '..', 'claude', 'hooks', 'uvpln-check-colors.js')

let dir
beforeEach(() => { dir = mkdtempSync(join(tmpdir(), 'uvpln-')) })
afterEach(() => { rmSync(dir, { recursive: true, force: true }) })

const run = (file) => spawnSync('node', [HOOK], {
  env: { ...process.env, CLAUDE_TOOL_INPUT_FILE_PATH: file || '' },
})

describe('check-colors', () => {
  test('bloquea text-[#... con exit 2', () => {
    const f = join(dir, 'bad.tsx')
    writeFileSync(f, '<div className="text-[#fff]" />')
    const r = run(f)
    expect(r.status).toBe(2)
    expect(r.stderr.toString()).toContain('color hardcodeado')
  })

  test('bloquea bg-[#...', () => {
    const f = join(dir, 'bad.tsx')
    writeFileSync(f, '<div className="bg-[#000]" />')
    expect(run(f).status).toBe(2)
  })

  test('bloquea border-[#...', () => {
    const f = join(dir, 'bad.tsx')
    writeFileSync(f, '<div className="border-[#abc]" />')
    expect(run(f).status).toBe(2)
  })

  test('deja pasar tokens del design system', () => {
    const f = join(dir, 'good.tsx')
    writeFileSync(f, '<div className="bg-primary text-foreground border-border" />')
    expect(run(f).status).toBe(0)
  })

  test('exit 0 cuando env vacío', () => {
    expect(run('').status).toBe(0)
  })

  test('exit 0 cuando file no existe', () => {
    expect(run(join(dir, 'no-existe.tsx')).status).toBe(0)
  })
})
