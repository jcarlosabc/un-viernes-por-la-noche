#!/usr/bin/env bash
set -euo pipefail

UVPLN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
HOOKS_DIR="$CLAUDE_DIR/hooks"
COMMANDS_DIR="$CLAUDE_DIR/commands"
TEMPLATES_DIR="$CLAUDE_DIR/templates"
EXAMPLES_DIR="$CLAUDE_DIR/examples"
MEMORY_DIR="$CLAUDE_DIR/memory/design-systems"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; exit 1; }

# Modo --check: preview de gráficas sin instalar
if [ "${1:-}" = "--check" ]; then
  echo ""
  echo "  uvpln — preview de gráficas (sin instalar)"
  echo ""
  if ! command -v node &>/dev/null; then
    err "Node.js no está instalado. Las gráficas necesitan Node 18+: https://nodejs.org"
  fi
  ok "Node $(node --version) encontrado"
  echo ""
  node "$UVPLN_DIR/claude/session-start.js"
  echo ""
  ok "Si viste el banner morado/verde, las gráficas van a funcionar tras instalar."
  echo ""
  echo "  Para instalar: bash install.sh"
  echo ""
  exit 0
fi

echo ""
echo "  Un Viernes Por La Noche — instalador"
echo "  Cartagena de Indias, Colombia"
echo ""

# Verificar Claude Code
if ! command -v claude &>/dev/null; then
  err "Claude Code no está instalado. Instalalo primero: https://claude.ai/code"
fi
ok "Claude Code encontrado"

# Verificar Node.js (banner + statusline + hooks corren en Node)
if ! command -v node &>/dev/null; then
  err "Node.js no está instalado. Las gráficas y hooks lo necesitan. Instalá Node 18+: https://nodejs.org"
fi
NODE_MAJOR=$(node -p "process.versions.node.split('.')[0]")
if [ "$NODE_MAJOR" -lt 18 ]; then
  warn "Node $(node --version) detectado — recomendado Node 18+"
else
  ok "Node $(node --version) encontrado"
fi

# Crear estructura de directorios
mkdir -p "$AGENTS_DIR"
mkdir -p "$HOOKS_DIR"
mkdir -p "$COMMANDS_DIR"
mkdir -p "$TEMPLATES_DIR"
mkdir -p "$EXAMPLES_DIR"
mkdir -p "$MEMORY_DIR"
ok "Directorios creados en $CLAUDE_DIR"

# Instalar CLAUDE.md (con backup si ya existe)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup"
  warn "CLAUDE.md existente respaldado en CLAUDE.md.backup"
fi
cp "$UVPLN_DIR/claude/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
ok "CLAUDE.md instalado"

# Instalar agentes
AGENTS=(
  "ui-architect.md"
  "ui-tester.md"
  "a11y-expert.md"
  "motion-designer.md"
  "tokens-manager.md"
  "performance-ui.md"
  "code-reviewer.md"
  "refactoring-specialist.md"
  "design-bridge.md"
  "ui-designer.md"
  "ux-researcher.md"
  "debugger.md"
  "api-integrator.md"
  "form-specialist.md"
  "state-manager.md"
)

for agent in "${AGENTS[@]}"; do
  src="$UVPLN_DIR/claude/agents/$agent"
  dst="$AGENTS_DIR/$agent"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    ok "Agente instalado: $agent"
  else
    warn "No encontrado: $agent — saltando"
  fi
done

# Instalar scripts de sesión + statusline (Node.js, cross-platform)
for script in session-start.js session-end.js statusline.cjs; do
  src="$UVPLN_DIR/claude/$script"
  dst="$CLAUDE_DIR/$script"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    ok "Script instalado: $script"
  else
    warn "No encontrado: $script — saltando"
  fi
done

# Instalar hooks (lista fija — no toca otros hooks que tengas)
HOOKS=(
  "uvpln-track-agent-start.js"
  "uvpln-track-agent-end.js"
  "uvpln-check-colors.js"
  "uvpln-check-any.js"
  "uvpln-loop-trigger.js"
  "uvpln-check-console.js"
  "uvpln-check-a11y.js"
  "uvpln-check-use-client.js"
)
for hook in "${HOOKS[@]}"; do
  src="$UVPLN_DIR/claude/hooks/$hook"
  dst="$HOOKS_DIR/$hook"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    ok "Hook instalado: hooks/$hook"
  else
    warn "No encontrado: $hook — saltando"
  fi
done

# Instalar comandos slash (loop de calidad)
for cmd in "uvpln-loop.md" "uvpln-audit.md" "uvpln-handoff.md"; do
  src="$UVPLN_DIR/claude/commands/$cmd"
  dst="$COMMANDS_DIR/$cmd"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    ok "Comando instalado: commands/$cmd"
  else
    warn "No encontrado: $cmd — saltando"
  fi
done

# Instalar plantillas de UI
for tpl in "README.md" "landing-page.md" "dashboard.md" "auth.md" "ecommerce.md"; do
  src="$UVPLN_DIR/claude/templates/$tpl"
  dst="$TEMPLATES_DIR/$tpl"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    ok "Plantilla instalada: templates/$tpl"
  else
    warn "No encontrado: $tpl — saltando"
  fi
done

# Instalar examples de código (patrones TS + JS)
for ex in "button-variants.md" "form-validation.md" "data-table.md" "modal-pattern.md" "theme-tokens.md" "api-fetch.md" "card-grid.md" "navigation.md" "toast-notifications.md"; do
  src="$UVPLN_DIR/claude/examples/$ex"
  dst="$EXAMPLES_DIR/$ex"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    ok "Example instalado: examples/$ex"
  else
    warn "No encontrado: $ex — saltando"
  fi
done

# Instalar / mergear settings.json
SETTINGS="$CLAUDE_DIR/settings.json"
MERGE_SCRIPT="$UVPLN_DIR/claude/install/merge-settings.js"
FORCE_FLAG=""
for arg in "$@"; do
  [ "$arg" = "--force-statusline" ] && FORCE_FLAG="--force-statusline"
done

if [ ! -f "$SETTINGS" ]; then
  cp "$UVPLN_DIR/claude/settings.json" "$SETTINGS"
  ok "settings.json instalado"
else
  if node "$MERGE_SCRIPT" "$UVPLN_DIR/claude/settings.json" "$SETTINGS" $FORCE_FLAG; then
    ok "settings.json mergeado (hooks de uvpln + tu config previa)"
  else
    err "Falló el merge de settings.json — revisá el backup en $CLAUDE_DIR"
  fi
fi

echo ""
echo "  ¡Listo Amigo! uvpln está instalado."
echo ""
echo "  Agentes disponibles:"
for agent in "${AGENTS[@]}"; do
  echo "    - ${agent%.md}"
done
echo ""
echo "  Abrí Claude Code y arrancá a construir."
echo "  (Verificación rápida: bash install.sh --check)"
echo ""
