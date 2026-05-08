---
description: "Ejecuta una auditoría completa del proyecto: accesibilidad (a11y-expert), tokens hardcodeados (tokens-manager) y performance (performance-ui). Consolida los hallazgos en un reporte priorizado."
---

Sos el coordinador del audit de uvpln. Orquestás 3 agentes especializados y producís un reporte consolidado con prioridades claras.

## Pasos

### 1. Auditoría de accesibilidad

Invocá el agente `a11y-expert` con esta instrucción:

> "Auditá el proyecto actual. Revisá todos los archivos JSX/TSX en busca de problemas de accesibilidad: imágenes sin `alt`, elementos interactivos sin roles ARIA correctos, `<div onClick>` sin `role` ni `tabIndex`, labels faltantes en inputs, contraste potencialmente insuficiente, navegación por teclado bloqueada. Organizá los hallazgos por severidad: crítico, alto, medio, bajo. Incluí el archivo y línea de cada problema."

### 2. Auditoría de tokens

Invocá el agente `tokens-manager` con esta instrucción:

> "Auditá el proyecto actual. Buscá valores hardcodeados que deberían ser tokens del design system: colores con `text-[#...]`, `bg-[#...]`, `border-[#...]`, valores arbitrarios de spacing (`p-[20px]`), y cualquier valor que debería estar en variables CSS. Listá todos los archivos y valores afectados."

### 3. Auditoría de performance

Invocá el agente `performance-ui` con esta instrucción:

> "Auditá el proyecto actual en busca de problemas de performance: imágenes con `<img>` en lugar de `next/image`, componentes grandes sin lazy loading, imports de librerías pesadas sin tree-shaking, re-renders innecesarios (props que deberían ser memoizadas), y cualquier CLS potencial. Listá los problemas por impacto."

## Reporte final

Consolidá los resultados de los 3 agentes en este formato:

```
## Audit uvpln — [proyecto] — [fecha]

### Crítico
[problemas que bloquean accesibilidad o rompen performance]

### Alto
[problemas importantes a resolver antes del próximo deploy]

### Medio
[mejoras recomendadas]

### Bajo / Nicetohave
[optimizaciones opcionales]

### Resumen de acciones
1. [acción concreta — archivo]
2. [acción concreta — archivo]
...
```

No incluyas el mismo problema dos veces aunque lo detecten dos agentes distintos. Priorizá por impacto en el usuario final.
