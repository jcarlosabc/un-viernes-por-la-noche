#!/usr/bin/env node
// uvpln — PostToolUse Agent (blocking): cuando ui-architect termina, instruye a Claude
// para invocar ui-tester. El stdout de un hook blocking se inyecta al contexto de Claude.

let data = ''
process.stdin.on('data', (chunk) => (data += chunk))
process.stdin.on('end', () => {
  try {
    const payload = JSON.parse(data)
    // PostToolUse stdin puede ser { tool_input: {...}, ... } o el input directo
    const input = payload.tool_input || payload
    const agentName = input.subagent_type || input.description || ''

    if (agentName === 'ui-architect') {
      console.log(
        '[uvpln-loop] ui-architect terminó. ' +
          'El loop de calidad de uvpln requiere que ahora invoques el agente ui-tester ' +
          'para validar el componente construido. ' +
          'Pasale el mismo contexto: qué componente es, qué hace, y el código generado.'
      )
    }
  } catch (_) {
    // silencio — el hook no debe interrumpir el flujo
  }
})
