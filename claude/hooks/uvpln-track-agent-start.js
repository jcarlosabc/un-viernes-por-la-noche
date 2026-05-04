#!/usr/bin/env node
// uvpln — PreToolUse Agent: registra el subagente activo en active-agent.txt
// para que la statusline lo resalte. Lee el tool input por stdin.

const fs = require('fs')
const os = require('os')
const path = require('path')

let data = ''
process.stdin.on('data', (chunk) => (data += chunk))
process.stdin.on('end', () => {
  try {
    const tool = JSON.parse(data)
    const name = tool.subagent_type || tool.description || ''
    const file = path.join(os.homedir(), '.claude', 'memory', 'active-agent.txt')
    fs.mkdirSync(path.dirname(file), { recursive: true })
    fs.writeFileSync(file, name)
  } catch (_) {
    // hook no-bloqueante: silencio si algo falla
  }
})
