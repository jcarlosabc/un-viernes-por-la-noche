#!/usr/bin/env node
// uvpln — PostToolUse Agent: limpia active-agent.txt cuando termina el subagente.

const fs = require('fs')
const os = require('os')
const path = require('path')

try {
  fs.unlinkSync(path.join(os.homedir(), '.claude', 'memory', 'active-agent.txt'))
} catch (_) {
  // si no existe, no pasa nada
}
