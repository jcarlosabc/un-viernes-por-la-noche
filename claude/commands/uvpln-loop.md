---
description: Loop de calidad uvpln — ui-architect diseña, ui-tester valida, repite hasta aprobación.
---

# Loop de calidad uvpln

Requerimiento: $ARGUMENTS

Ejecutá estos pasos en orden sin saltarte ninguno:

**Paso 1 — ui-architect construye**
Invocá el agente `ui-architect` con el requerimiento completo. Esperá a que termine.

**Paso 2 — ui-tester valida**
Invocá el agente `ui-tester` con el componente que construyó ui-architect. El tester debe probar: estados, responsive, a11y, edge cases.

**Paso 3 — Evaluá el resultado**
- Bugs **críticos o altos** → volvé al Paso 1. Pasale a ui-architect el reporte del tester como contexto.
- Solo mejoras menores o sin bugs → el loop terminó. Reportá: "Componente aprobado por ui-tester. Loop completo."

**Límite:** Máximo 3 iteraciones. Si al tercero aún hay bugs críticos, escalá al usuario con el reporte completo y esperá instrucciones.

**Regla no negociable:** No reportes ningún componente como "listo" hasta que ui-tester lo apruebe explícitamente.
