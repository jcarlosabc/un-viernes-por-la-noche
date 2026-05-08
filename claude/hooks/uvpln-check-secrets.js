#!/usr/bin/env node
// uvpln — PreToolUse Write|Edit: BLOQUEA secrets hardcodeados en código.
// Detecta API keys, tokens, passwords con patterns de proveedores conocidos + asignaciones obvias.
// Sale con código 2 para que Claude Code aborte la escritura del archivo.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || !fs.existsSync(file)) process.exit(0)

// No chequear lockfiles ni .env.example
const SKIP = ['package-lock.json', 'pnpm-lock.yaml', 'yarn.lock', '.env.example', '.env.sample']
if (SKIP.some(s => file.endsWith(s))) process.exit(0)

const content = fs.readFileSync(file, 'utf8')

// Patterns de proveedores conocidos (alta confianza)
const PROVIDER_PATTERNS = [
  { name: 'AWS Access Key', pattern: /AKIA[0-9A-Z]{16}/ },
  { name: 'Stripe Live Key', pattern: /sk_live_[0-9a-zA-Z]{24,}/ },
  { name: 'Stripe Test Key', pattern: /sk_test_[0-9a-zA-Z]{24,}/ },
  { name: 'GitHub Token', pattern: /ghp_[0-9a-zA-Z]{36}/ },
  { name: 'GitHub OAuth', pattern: /gho_[0-9a-zA-Z]{36}/ },
  { name: 'Google API Key', pattern: /AIza[0-9A-Za-z\-_]{35}/ },
  { name: 'Slack Token', pattern: /xox[baprs]-[0-9a-zA-Z\-]{10,}/ },
  { name: 'OpenAI Key', pattern: /sk-[a-zA-Z0-9]{40,}/ },
  { name: 'Anthropic Key', pattern: /sk-ant-[a-zA-Z0-9\-_]{40,}/ },
  { name: 'Private Key (PEM)', pattern: /-----BEGIN (RSA |EC |DSA |OPENSSH |PGP )?PRIVATE KEY-----/ },
]

// Patterns de asignaciones sospechosas (media confianza)
// Ejemplo: const API_KEY = "abc123..."  con string >= 20 chars
const ASSIGNMENT_PATTERNS = [
  /\b(api[_-]?key|secret[_-]?key|access[_-]?token|auth[_-]?token|password|passwd)\s*[:=]\s*["'`]([^"'`\s]{20,})["'`]/gi,
]

const findings = []

PROVIDER_PATTERNS.forEach(({ name, pattern }) => {
  const match = content.match(pattern)
  if (match) findings.push(`  ${name} detectado: ${match[0].slice(0, 20)}...`)
})

ASSIGNMENT_PATTERNS.forEach(pattern => {
  let match
  while ((match = pattern.exec(content)) !== null) {
    // Excluir placeholders obvios
    const value = match[2]
    if (/^(your[_-]|xxx+|placeholder|example|<.*>)/i.test(value)) continue
    if (/^(process\.env|import\.meta|env\.)/.test(value)) continue
    findings.push(`  Posible secret hardcodeado: ${match[1]} = "${value.slice(0, 20)}..."`)
  }
})

if (findings.length === 0) process.exit(0)

console.error(
  `uvpln SECURITY (${file}):\n` +
  `  Secrets/credenciales detectados — NUNCA commitees esto.\n` +
  findings.join('\n') + '\n' +
  `  Fix: mover a variable de entorno (process.env.X), agregar .env al .gitignore.`
)
process.exit(2)
