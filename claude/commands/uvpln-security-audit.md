---
description: "Ejecuta una auditoría completa de seguridad del proyecto con security-frontend: XSS, secrets, auth patterns, CSP, headers, dependencias vulnerables, open redirects, iframes, click-jacking. Reporte por severidad con fixes accionables."
---

Sos el coordinador del audit de seguridad de uvpln. Invocás `security-frontend` y consolidás un reporte priorizado.

## Pasos

### 1. Auditoría completa de seguridad

Invocá el agente `security-frontend` con esta instrucción:

> "Auditá el proyecto actual con el checklist completo de seguridad cliente. Cubrí en orden: (1) Secrets y credenciales hardcodeados — escanear todos los `.ts`, `.tsx`, `.js`, `.jsx`, `.json` excepto lockfiles. Buscar API keys, tokens, passwords. (2) XSS — todos los usos de `dangerouslySetInnerHTML` y verificar si tienen sanitización con DOMPurify. (3) Auth patterns — buscar `localStorage.setItem` con keys que contengan token/jwt/auth/session, verificar manejo de cookies en API routes, validación server-side de auth. (4) CSP y headers de seguridad — revisar `next.config.js` y `middleware.ts` por headers configurados. (5) Links externos — `<a target=\"_blank\">` sin `rel=\"noopener noreferrer\"`. (6) Iframes — verificar atributo `sandbox` en cada `<iframe>`. (7) Open redirect — buscar `router.push` con valores de query params no validados. (8) Validación de inputs — verificar que cada API route valide con Zod o similar. (9) Dependencias — correr `npm audit` (o `pnpm audit`) y reportar vulnerabilidades CRITICAL y HIGH. Reportá cada hallazgo con archivo:línea + fix sugerido. Organizá por severidad."

### 2. Reporte consolidado

Producí el siguiente formato:

```
🔒 SECURITY AUDIT — [proyecto] — [fecha YYYY-MM-DD]

═══════════════════════════════════════════════════════════
CRÍTICO — bloquea merge ([N] hallazgos)
═══════════════════════════════════════════════════════════

[para cada hallazgo:]
🔴 [tipo] en [archivo]:[línea]
   Problema: [descripción específica]
   Riesgo: [qué puede pasar si se explota]
   Fix:
     [código o pasos concretos]

═══════════════════════════════════════════════════════════
ALTO — bloquea release ([N] hallazgos)
═══════════════════════════════════════════════════════════

[mismo formato]

═══════════════════════════════════════════════════════════
MEDIO — corregir en sprint ([N] hallazgos)
═══════════════════════════════════════════════════════════

[mismo formato]

═══════════════════════════════════════════════════════════
BAJO — mejora ([N] hallazgos)
═══════════════════════════════════════════════════════════

[mismo formato]

═══════════════════════════════════════════════════════════
DEPENDENCIAS
═══════════════════════════════════════════════════════════

npm audit: [X critical / Y high / Z moderate]

Paquetes a actualizar urgentemente:
- [paquete] [versión actual] → [versión segura] (CVE-XXXX-XXXX)

═══════════════════════════════════════════════════════════
HEADERS DE SEGURIDAD
═══════════════════════════════════════════════════════════

✅ Configurados: [lista]
❌ Faltantes: [lista con sugerencia de valor]

═══════════════════════════════════════════════════════════
ACCIÓN INMEDIATA
═══════════════════════════════════════════════════════════

1. [acción concreta más urgente]
2. [siguiente acción]
3. ...

Estado del proyecto:
🟢 OK para merge | 🟡 Requiere fixes ALTOS | 🔴 BLOQUEADO por críticos
```

## Reglas

- No reportes el mismo hallazgo dos veces
- Si una vulnerabilidad CRÍTICA aparece, marcá el proyecto como 🔴 BLOQUEADO
- Cada fix debe ser accionable (código concreto o paquete a instalar)
- Si `npm audit` reporta vulnerabilidades de subdependencias que no se pueden actualizar, mencionarlo y sugerir `npm audit --force` solo si no rompe APIs
- Si CSP no está configurada, dar el bloque de código completo para `next.config.js` listo para pegar
- Priorizá por impacto en usuarios reales, no por "es interesante de arreglar"
