const { describe, test, expect, beforeEach, afterEach } = require('vitest')
const { spawnSync } = require('child_process')
const { writeFileSync, mkdtempSync, rmSync } = require('fs')
const { tmpdir } = require('os')
const { join } = require('path')

const HOOK = join(__dirname, '..', '..', 'claude', 'hooks', 'uvpln-check-any.js')

let dir
beforeEach(() => { dir = mkdtempSync(join(tmpdir(), 'uvpln-')) })
afterEach(() => { rmSync(dir, { recursive: true, force: true }) })

const run = (file) => spawnSync('node', [HOOK], {
  env: { ...process.env, CLAUDE_TOOL_INPUT_FILE_PATH: file || '' },
})

describe('check-any', () => {
  test('warn con N usos en .ts', () => {
    const f = join(dir, 'file.ts')
    writeFileSync(f, 'const a: any = 1\nfunction b(x: any): any { return x }\n')
    const r = run(f)
    expect(r.status).toBe(0) // never blocks
    expect(r.stderr.toString()).toContain('3 uso(s) de any')
  })

  test('warn en .tsx', () => {
    const f = join(dir, 'comp.tsx')
    writeFileSync(f, 'const x: any = 1')
    expect(run(f).stderr.toString()).toContain('1 uso(s) de any')
  })

  test('silencio en .js (no es TS)', () => {
    const f = join(dir, 'plain.js')
    writeFileSync(f, 'const a = 1')
    expect(run(f).stderr.toString()).toBe('')
  })

  test('silencio cuando no hay any', () => {
    const f = join(dir, 'clean.ts')
    writeFileSync(f, 'const x: number = 1')
    expect(run(f).stderr.toString()).toBe('')
  })

  test('siempre exit 0 (no bloquea)', () => {
    const f = join(dir, 'lots.ts')
    writeFileSync(f, 'const x: any = null'.repeat(20))
    expect(run(f).status).toBe(0)
  })
})
