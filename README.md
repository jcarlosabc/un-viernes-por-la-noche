<p align="center">
  <img src="banner.png" alt="Un Viernes Por La Noche — Frontend AI Agent" width="100%" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Frontend_AI_Agent-Claude_Code-7C3AED?style=for-the-badge&logoColor=white" />
  <img src="https://img.shields.io/badge/100%25-Colombiano-22C55E?style=for-the-badge&logoColor=white" />
  <img src="https://img.shields.io/badge/Cartagena_de_Indias-🇨🇴-7C3AED?style=for-the-badge" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/React-19-22C55E?style=flat-square&logo=react&logoColor=white" />
  <img src="https://img.shields.io/badge/Next.js-15-7C3AED?style=flat-square&logo=next.js&logoColor=white" />
  <img src="https://img.shields.io/badge/Tailwind-4-22C55E?style=flat-square&logo=tailwindcss&logoColor=white" />
  <img src="https://img.shields.io/badge/TypeScript-strict-7C3AED?style=flat-square&logo=typescript&logoColor=white" />
  <img src="https://img.shields.io/badge/shadcn%2Fui-✓-22C55E?style=flat-square&logoColor=white" />
  <img src="https://img.shields.io/badge/Framer_Motion-✓-7C3AED?style=flat-square&logo=framer&logoColor=white" />
</p>

<br/>

<p align="center">
  <strong>El ecosistema de agentes de IA especializado en frontend y UI.</strong><br/>
  UI bonita. Codigo limpio. Deploy y a dormir.
</p>

---

## Que es uvpln?

`uvpln` es un equipo de **8 agentes especializados** para [Claude Code](https://claude.ai/code) enfocados exclusivamente en frontend. No es un agente generico que hace de todo — es un especialista que conoce profundo el stack moderno y habla como la gente.

<p align="center">
  <img src="uvpln.png" alt="uvpln en accion" width="480" />
</p>

> *UI bonita. Codigo limpio. Deploy y a dormir.*

---

## Los agentes

<table>
  <thead>
    <tr>
      <th>Agente</th>
      <th>Especialidad</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><img src="https://img.shields.io/badge/ui--architect-7C3AED?style=flat-square&logoColor=white" /></td>
      <td>Arquitectura de componentes, React 19, Next.js 15, Tailwind 4, shadcn/ui</td>
    </tr>
    <tr>
      <td><img src="https://img.shields.io/badge/ui--tester-22C55E?style=flat-square&logoColor=white" /></td>
      <td>Testing exhaustivo con browser real, responsive, estados, edge cases</td>
    </tr>
    <tr>
      <td><img src="https://img.shields.io/badge/a11y--expert-7C3AED?style=flat-square&logoColor=white" /></td>
      <td>Accesibilidad WCAG 2.2, ARIA, gestion de foco, semantica</td>
    </tr>
    <tr>
      <td><img src="https://img.shields.io/badge/motion--designer-22C55E?style=flat-square&logoColor=white" /></td>
      <td>Animaciones, Framer Motion, transiciones, micro-interacciones</td>
    </tr>
    <tr>
      <td><img src="https://img.shields.io/badge/tokens--manager-7C3AED?style=flat-square&logoColor=white" /></td>
      <td>Design tokens, variables CSS, dark mode, theming</td>
    </tr>
    <tr>
      <td><img src="https://img.shields.io/badge/performance--ui-22C55E?style=flat-square&logoColor=white" /></td>
      <td>Core Web Vitals, bundle size, lazy loading, optimizacion visual</td>
    </tr>
    <tr>
      <td><img src="https://img.shields.io/badge/code--reviewer-7C3AED?style=flat-square&logoColor=white" /></td>
      <td>Revision de TypeScript/React — seguridad, calidad, patrones</td>
    </tr>
    <tr>
      <td><img src="https://img.shields.io/badge/refactoring--specialist-22C55E?style=flat-square&logoColor=white" /></td>
      <td>Refactor de componentes sin cambiar comportamiento</td>
    </tr>
  </tbody>
</table>

---

## El loop de calidad

El diferenciador de uvpln. Ningun componente es **listo** hasta que pasa el loop completo:

```
╔══════════════════════════════════════════════╗
║                                              ║
║   ui-architect  →  diseña el componente      ║
║         ↓                                    ║
║   ui-tester     →  lo rompe con browser real ║
║         ↓                                    ║
║   ui-architect  →  corrige con el reporte    ║
║         ↓                                    ║
║   ui-tester     →  APROBADO ✓                ║
║                                              ║
╚══════════════════════════════════════════════╝
```

---

## Experiencia al abrir Claude Code

uvpln personaliza Claude Code con una pantalla de bienvenida y una statusline en tiempo real.

**Banner al iniciar:**
```
  ██╗   ██╗██╗   ██╗██████╗ ██╗     ███╗   ██╗
  ██║   ██║██║   ██║██╔══██╗██║     ████╗  ██║
  ...

  Un Viernes Por La Noche — Frontend AI Agent
  UI bonita. Codigo limpio. Deploy y a dormir.

  Proyecto:      mi-proyecto
  Design system: cargado (48 lineas)
  Agentes:       8 disponibles

  Hola parcero, que haremos hoy?
```

**Statusline en tiempo real** (barra inferior):
```
🐊 uvpln · mi-proyecto │ 8 agentes │ ◉ design system │ sonnet-4.6 · 12% ctx · $0.023 │ Cartagena 🇨🇴
```

---

## Hooks de calidad

uvpln vigila el codigo mientras escribis:

| Hook | Que hace |
|------|----------|
| `PreToolUse` | Bloquea si detecta colores hardcodeados (`text-[#fff]`) — usa tokens |
| `PostToolUse` | Avisa si hay usos de `any` en TypeScript |

---

## Instalacion

### Windows

```powershell
git clone https://github.com/jcarlosabc/un-viernes-por-la-noche.git
cd un-viernes-por-la-noche
powershell -ExecutionPolicy Bypass -File install.ps1
```

Despues escribi `uvpln` en cualquier terminal para abrir Claude Code con identidad uvpln.

### Linux / macOS / WSL

```bash
git clone https://github.com/jcarlosabc/un-viernes-por-la-noche.git
cd un-viernes-por-la-noche
bash install.sh
```

Los agentes quedan en `~/.claude/agents/` listos para usar con Claude Code.

### Requisitos

<p>
  <img src="https://img.shields.io/badge/Claude_Code-requerido-7C3AED?style=flat-square&logoColor=white" />
  <img src="https://img.shields.io/badge/Claude_Pro_o_Max-requerido-22C55E?style=flat-square&logoColor=white" />
  <img src="https://img.shields.io/badge/Node.js_18+-requerido-22C55E?style=flat-square&logo=node.js&logoColor=white" />
</p>

- **Claude Code** y suscripcion **Claude Pro o Max**
- **Node.js 18+** — el banner, la statusline y los hooks corren en Node (cross-platform)

Sin Docker, sin Python, sin infraestructura. El instalador valida que todo este antes de copiar nada.

---

## Verificar la instalacion

Las graficas de uvpln (banner + statusline) son scripts Node.js que Claude Code dispara por hooks. Antes y despues de instalar podes confirmar que se ven igual que en las capturas.

### Antes de instalar — preview sin tocar nada

```bash
# Linux / macOS / WSL
bash install.sh --check
```

```powershell
# Windows
powershell -ExecutionPolicy Bypass -File install.ps1 -Check
```

Si ves el banner ASCII morado/verde con el texto `Hola parcero, que haremos hoy?`, las graficas van a funcionar despues de instalar. Si sale `node: command not found`, instala Node 18+ primero.

### Despues de instalar — verificacion real

Abri Claude Code:

```bash
claude     # Linux / macOS / WSL
uvpln      # Windows (claude tambien sirve)
```

En los primeros 2 segundos tenes que ver:

1. Banner ASCII `UVPLN` morado con texto verde
2. Linea `Agentes: 8 disponibles`
3. Statusline abajo: `🐊 uvpln · <proyecto> │ ◈ ui-architect ◈ ui-tester ...`
4. `/agents` lista los 8 con su descripcion

Probalo:

> "ui-architect, dame un componente Button con shadcn/ui"

Si entra en personaje costeño y devuelve `.tsx` con tokens (sin `text-[#fff]`), uvpln esta funcionando. Probalo escribiendo `text-[#ff0000]` en un archivo — el hook `PreToolUse` lo bloquea.

### Si algo falla

| Sintoma | Causa probable | Fix |
|---------|----------------|-----|
| `claude: command not found` | Claude Code no instalado | https://claude.ai/code |
| Sin banner ni statusline | Node.js no instalado o <18 | Instalar Node 18+ |
| Banner sale en `--check` pero no al abrir Claude | Ya tenias `~/.claude/settings.json` previo | Mergear `hooks` y `statusLine` desde `claude/settings.json` (el instalador te dice que claves) |
| No sale el banner pero si la statusline | Tu `~/.claude/CLAUDE.md` previo no se reemplazo | Revisar `CLAUDE.md.backup` y aplicar manual |
| Agentes no aparecen en `/agents` | Sesion vieja en cache | Cerrar y reabrir Claude Code |

---

## Desinstalacion

uvpln se desinstala limpio sin tocar tus proyectos ni codigo.

### Linux / macOS / WSL

```bash
bash uninstall.sh           # con confirmacion
bash uninstall.sh -y        # sin preguntar
bash uninstall.sh --help    # opciones avanzadas
```

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File uninstall.ps1
powershell -ExecutionPolicy Bypass -File uninstall.ps1 -Yes
powershell -ExecutionPolicy Bypass -File uninstall.ps1 -Help
```

### Que borra y que conserva

| | Comportamiento |
|---|---|
| **Borra** los 8 agentes uvpln en `~/.claude/agents/` | Lista fija — no toca otros agentes que tengas |
| **Borra** `session-start.js`, `session-end.js`, `statusline.cjs` | Solo los archivos de uvpln |
| **Restaura** `~/.claude/CLAUDE.md.backup` si existe | Te devuelve tu CLAUDE.md previo |
| **NO borra** `~/.claude/settings.json` por defecto | Puede tener config de otras herramientas. Te dice que claves remover, o usa `--reset-settings` para borrarlo |
| **NO borra** `~/.claude/memory/design-systems/` por defecto | Tu memoria de tokens/decisiones por proyecto sigue ahi. Para borrarla: `--purge-memory` |
| **NO toca** `~/.claude/` global ni nada fuera de eso | Cero impacto en tus proyectos |

---

## Estructura del proyecto

```
un-viernes-por-la-noche/
├── install.sh                  → instalador Linux/macOS/WSL
├── install.ps1                 → instalador Windows
├── uninstall.sh                → desinstalador Linux/macOS/WSL
├── uninstall.ps1               → desinstalador Windows
├── uvpln.cmd                   → comando uvpln para Windows
├── claude/
│   ├── CLAUDE.md               → personalidad y reglas globales
│   ├── settings.json           → hooks cross-platform (Windows + Linux)
│   ├── session-start.js        → banner de bienvenida (Node.js)
│   ├── session-end.js          → cierre de sesion (Node.js)
│   ├── statusline.cjs          → barra inferior en tiempo real
│   └── agents/
│       ├── ui-architect.md
│       ├── ui-tester.md
│       ├── a11y-expert.md
│       ├── motion-designer.md
│       ├── tokens-manager.md
│       ├── performance-ui.md
│       ├── code-reviewer.md
│       └── refactoring-specialist.md
```

---

## Por que uvpln y no otros

| | Helix | Engram | **uvpln** |
|--|:-----:|:------:|:---------:|
| Especializacion frontend | ✗ | ✗ | ✅ |
| Loop diseno → testing | ✗ | ✗ | ✅ |
| React 19 / Next.js 15 | ✗ | ✗ | ✅ |
| Sin dependencias extra | ✗ | Parcial | ✅ |
| Memoria de design system | ✗ | Parcial | ✅ |
| Statusline personalizada | ✗ | ✗ | ✅ |
| Soporte Windows nativo | ✗ | ✗ | ✅ |
| Personalidad propia | ✗ | ✗ | ✅ |

---

## Stack de referencia

<p>
  <img src="https://img.shields.io/badge/React-19-22C55E?style=for-the-badge&logo=react&logoColor=white" />
  <img src="https://img.shields.io/badge/Next.js-15-7C3AED?style=for-the-badge&logo=next.js&logoColor=white" />
  <img src="https://img.shields.io/badge/Tailwind_CSS-4-22C55E?style=for-the-badge&logo=tailwindcss&logoColor=white" />
  <img src="https://img.shields.io/badge/TypeScript-strict-7C3AED?style=for-the-badge&logo=typescript&logoColor=white" />
</p>
<p>
  <img src="https://img.shields.io/badge/shadcn/ui-components-22C55E?style=for-the-badge&logoColor=white" />
  <img src="https://img.shields.io/badge/Radix_UI-primitives-7C3AED?style=for-the-badge&logoColor=white" />
  <img src="https://img.shields.io/badge/Framer_Motion-animations-22C55E?style=for-the-badge&logo=framer&logoColor=white" />
  <img src="https://img.shields.io/badge/WCAG-2.2_AA-7C3AED?style=for-the-badge&logoColor=white" />
</p>

---

## Changelog

<details>
<summary><img src="https://img.shields.io/badge/v1.5.0-7C3AED?style=flat-square&logoColor=white" /> &nbsp; Onboarding de backend + decisiones de stack</summary>

<br/>

Cuando llega a un proyecto nuevo, uvpln ahora:

1. **Lee el backend** — explora `package.json`, rutas, controladores y README para entender los endpoints disponibles
2. **Pregunta el stack** — antes de escribir una linea de codigo, pregunta TypeScript o JavaScript, React o Next.js
3. **Guarda las decisiones** — escribe la config en `~/.claude/memory/design-systems/[proyecto].md`
4. **Mapea endpoints** — va registrando los endpoints del backend a medida que los descubre

Todos los agentes (ui-architect, tokens-manager, ui-tester) usan ese contexto guardado para trabajar en el lenguaje y framework que el equipo decidio.

</details>

<details>
<summary><img src="https://img.shields.io/badge/v1.4.0-7C3AED?style=flat-square&logoColor=white" /> &nbsp; Statusline de dos lineas con agentes</summary>

<br/>

La statusline ahora muestra dos lineas: resumen general arriba y cada agente listado individualmente abajo.

```
🐊 uvpln · mi-proyecto │ ○ ds │ Sonnet 4.6 · 12% ctx · $0.023 │ Cartagena 🇨🇴
◈ ui-architect  ◈ ui-tester  ◈ a11y-expert  ◈ motion-designer  ◈ tokens-manager  ◈ performance-ui  ◈ code-reviewer  ◈ refactoring-specialist
```

- Los agentes se leen dinamicamente del directorio `~/.claude/agents/`
- Si agregas o quitas un agente, la statusline se actualiza sola

</details>

<details>
<summary><img src="https://img.shields.io/badge/v1.3.0-7C3AED?style=flat-square&logoColor=white" /> &nbsp; Hooks cross-platform con Node.js + comando uvpln</summary>

<br/>

- **Hooks reescritos en Node.js** — los scripts de sesion pasaron de `.ps1` a `.js` para funcionar igual en Windows, Linux y macOS sin depender de variables de entorno que se corrompian en Claude Code
- **Comando `uvpln`** — se puede abrir Claude Code escribiendo `uvpln` en lugar de `claude`, igual que `helix`
- **`settings.json` unificado** — un solo archivo de configuracion para todas las plataformas

**Cambios:**
- `session-start.ps1` / `session-end.ps1` → `session-start.js` / `session-end.js`
- `settings-windows.json` eliminado — ya no es necesario

</details>

<details>
<summary><img src="https://img.shields.io/badge/v1.2.0-22C55E?style=flat-square&logoColor=white" /> &nbsp; Statusline, banner de bienvenida y soporte Windows</summary>

<br/>

- **Statusline** — barra inferior en tiempo real con proyecto activo, design system, modelo, % contexto y costo
- **Banner ASCII** — pantalla de bienvenida morada con verde al abrir Claude Code
- **Soporte Windows nativo** — `install.ps1` para instalar sin WSL ni Git Bash
- **Hooks de calidad** — bloquea colores hardcodeados y avisa sobre `any` en TypeScript

**Archivos nuevos:**
- `statusline.cjs` — barra inferior
- `session-start.js` / `session-end.js` — banner de inicio y cierre
- `install.ps1` — instalador Windows
- `uvpln.cmd` — comando `uvpln` para Windows

</details>

<details>
<summary><img src="https://img.shields.io/badge/v1.1.0-22C55E?style=flat-square&logoColor=white" /> &nbsp; Agentes de calidad de codigo + frontmatter</summary>

<br/>

- **`code-reviewer`** — revision de TypeScript/React con severidades (bloqueante, alto, medio, bajo) antes de hacer merge
- **`refactoring-specialist`** — refactor de componentes sin cambiar comportamiento: extraer hooks, dividir componentes, eliminar prop drilling, CVA para variantes
- **Frontmatter en todos los agentes** — Claude Code ahora sabe exactamente cuando invocar cada agente, que herramientas tiene y que modelo usar

**Agentes con frontmatter:**

| Agente | Modelo |
|--------|--------|
| `code-reviewer` | Opus (mas razonamiento para detectar issues sutiles) |
| Resto de agentes | Sonnet |

</details>

<details>
<summary><img src="https://img.shields.io/badge/v1.0.0-7C3AED?style=flat-square&logoColor=white" /> &nbsp; Release inicial — 6 agentes + loop de calidad</summary>

<br/>

Primera version de uvpln. El ecosistema de agentes especializado en frontend para Claude Code.

**6 agentes especializados:**
- `ui-architect` — React 19, Next.js 15, Tailwind 4, shadcn/ui
- `ui-tester` — testing exhaustivo con browser real
- `a11y-expert` — accesibilidad WCAG 2.2
- `motion-designer` — Framer Motion y animaciones
- `tokens-manager` — design tokens y dark mode
- `performance-ui` — Core Web Vitals y bundle size

**El loop de calidad:**
```
ui-architect diseña → ui-tester rompe → ui-architect corrige → ui-tester aprueba
```

**Personalidad:** colombiano costeño de Cartagena de Indias. Habla como la gente.

</details>

---

<p align="center">
  Hecho con berraquera desde Cartagena de Indias, Colombia 🇨🇴
</p>
