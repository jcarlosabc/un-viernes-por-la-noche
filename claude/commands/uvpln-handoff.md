---
description: "Genera un documento de handoff de la sesión actual: componentes construidos, decisiones tomadas, endpoints mapeados y tareas pendientes. Útil para cambio de turno o cierre de sprint."
---

Generás el documento de handoff de la sesión de trabajo. Tu objetivo es que cualquier dev pueda retomar donde se dejó sin necesidad de preguntar.

## Pasos

### 1. Leer contexto del proyecto

- Leé `~/.claude/memory/design-systems/[nombre-proyecto].md` si existe
- Explorá los archivos modificados recientemente con `Glob` y `Read`
- Revisá el historial de la conversación actual para identificar lo que se hizo

### 2. Producir el documento

Formato de salida:

```markdown
## Handoff — [nombre-proyecto] — [fecha]

### Qué se hizo en esta sesión
[2-3 líneas: resumen ejecutivo de lo construido]

### Componentes construidos o modificados

| Componente | Ubicación | Descripción |
|-----------|-----------|-------------|
| [nombre] | [ruta/al/archivo] | [qué hace, variantes, props clave] |

### Decisiones técnicas tomadas

| Decisión | Razón |
|----------|-------|
| [decisión] | [por qué se tomó] |

### Endpoints mapeados en esta sesión

| Método | Ruta | Para qué |
|--------|------|----------|
| GET | /api/... | ... |

### Stack del proyecto

- Lenguaje: [TypeScript / JavaScript]
- Framework: [React / Next.js]
- Gestor de paquetes: [npm / yarn / pnpm]
- Librerías nuevas instaladas: [lista o "ninguna"]

### Pendiente

- [ ] [tarea pendiente con contexto]
- [ ] [tarea pendiente con contexto]

### Para el próximo dev

[Contexto que NO está en el código: decisiones de diseño, cosas que se intentaron y no funcionaron, restricciones del cliente, advertencias sobre partes del código]
```

### 3. Guardar si el usuario lo pide

Si el usuario quiere guardar el handoff, escribilo en `~/.claude/memory/design-systems/[proyecto]-handoff-[fecha].md`.

## Notas

- Ser específico en "Pendiente" — no "terminar el dashboard", sino "agregar paginación a la tabla de usuarios en `/app/admin/users/page.tsx`"
- Si no hay endpoints mapeados, omitir esa sección
- Si no hay decisiones técnicas relevantes, omitir esa sección
- Máximo 1 página — si hay más, es que hay demasiadas cosas sin documentar
