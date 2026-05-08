#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: detecta tokens de auth guardados en localStorage/sessionStorage.
// Vulnerabilidad: XSS roba el token. Auth tokens deben ir en cookies httpOnly + Secure + SameSite.
// No bloquea — warning para que el security-frontend revise el flujo auth.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file) process.exit(0)
if (!/\.(tsx?|jsx?|mjs|cjs)$/.test(file)) process.exit(0)
if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')

// Patrones: localStorage.setItem('token'|'jwt'|'auth'|'session', ...) — case insensitive
const RISKY = /(?:local|session)Storage\.setItem\s*\(\s*["'`]([^"'`]*?(?:token|jwt|auth|session|access|refresh|bearer|api[_-]?key)[^"'`]*?)["'`]/gi

const findings = []
let match
while ((match = RISKY.exec(content)) !== null) {
  findings.push(`  Storage key: "${match[1]}"`)
}

if (findings.length === 0) process.exit(0)

console.warn(
  `uvpln security auth (${file}):\n` +
  `  ${findings.length} uso(s) de localStorage/sessionStorage para guardar credenciales.\n` +
  findings.join('\n') + '\n' +
  `  Vulnerabilidad: cualquier XSS lee el token y suplanta al usuario.\n` +
  `  Fix: usar cookie httpOnly + Secure + SameSite=Lax desde el server (Set-Cookie en response).\n` +
  `       En Next.js: cookies().set('token', value, { httpOnly: true, secure: true, sameSite: 'lax' })\n` +
  `       NextAuth, Auth.js y Clerk lo manejan por default.`
)
