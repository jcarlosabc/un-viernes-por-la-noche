#!/usr/bin/env bash
set -euo pipefail

UVPLN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
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

# Instalar settings.json
SETTINGS="$CLAUDE_DIR/settings.json"
if [ ! -f "$SETTINGS" ]; then
  cp "$UVPLN_DIR/claude/settings.json" "$SETTINGS"
  ok "settings.json instalado"
else
  warn "settings.json ya existe — no se sobreescribe"
  echo ""
  echo "  Para activar gráficas y hooks de uvpln, mergeá estas claves de"
  echo "  $UVPLN_DIR/claude/settings.json a $SETTINGS:"
  echo ""
  echo "    hooks.SessionStart    → banner al abrir Claude Code"
  echo "    hooks.SessionEnd      → cierre de sesión"
  echo "    hooks.PreToolUse      → bloqueo colores hardcodeados + tracking agente activo"
  echo "    hooks.PostToolUse     → aviso de any en TS + cleanup tracking"
  echo "    statusLine            → barra inferior con los 8 agentes"
  echo ""
fi

echo ""
echo "  ¡Listo parcero! uvpln está instalado."
echo ""
echo "  Agentes disponibles:"
for agent in "${AGENTS[@]}"; do
  echo "    - ${agent%.md}"
done
echo ""
echo "  Abrí Claude Code y arrancá a construir."
echo "  (Verificación rápida: bash install.sh --check)"
echo ""
