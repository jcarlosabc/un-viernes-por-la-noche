#!/usr/bin/env node
// uvpln — PostToolUse Write|Edit: detecta hooks de cliente sin "use client" en Next.js app/.
// Solo aplica a archivos dentro de app/ — no bloquea, solo avisa.

const fs = require('fs')

const file = process.env.CLAUDE_TOOL_INPUT_FILE_PATH || ''
if (!file || (!file.endsWith('.tsx') && !file.endsWith('.ts'))) process.exit(0)

// Solo archivos en el directorio app/ de Next.js
const inAppDir =
  file.includes('/app/') ||
  file.includes('\\app\\') ||
  file.includes('/src/app/') ||
  file.includes('\\src\\app\\')
if (!inAppDir) process.exit(0)

if (!fs.existsSync(file)) process.exit(0)

const content = fs.readFileSync(file, 'utf8')
const firstLine = content.trim().split('\n')[0].trim()
const hasUseClient =
  firstLine === '"use client"' || firstLine === "'use client'"
if (hasUseClient) process.exit(0)

const CLIENT_HOOKS = [
  'useState',
  'useEffect',
  'useRef',
  'useCallback',
  'useMemo',
  'useReducer',
  'useContext',
  'useId',
  'useTransition',
  'useDeferredValue',
]
const found = CLIENT_HOOKS.filter(
  (h) => content.includes(`${h}(`) || content.includes(`${h}<`)
)

if (found.length) {
  console.warn(
    `uvpln: ${file} usa ${found.join(', ')} pero no tiene "use client" — falta la directiva`
  )
}
