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

echo ""
echo "  Un Viernes Por La Noche — instalador"
echo "  Cartagena de Indias, Colombia"
echo ""

# Verificar que Claude Code existe
if ! command -v claude &>/dev/null; then
  err "Claude Code no está instalado. Instalalo primero: https://claude.ai/code"
fi
ok "Claude Code encontrado"

# Crear estructura de directorios
mkdir -p "$AGENTS_DIR"
mkdir -p "$MEMORY_DIR"
ok "Directorios creados en $CLAUDE_DIR"

# Instalar CLAUDE.md
# Si ya existe uno, hacer backup antes de reemplazar
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

# Instalar scripts de sesión
for script in session-start.sh session-end.sh statusline.cjs; do
  src="$UVPLN_DIR/claude/$script"
  dst="$CLAUDE_DIR/$script"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    chmod +x "$dst"
    ok "Script instalado: $script"
  fi
done

# Instalar settings.json si no existe
SETTINGS="$CLAUDE_DIR/settings.json"
if [ ! -f "$SETTINGS" ]; then
  cp "$UVPLN_DIR/claude/settings.json" "$SETTINGS"
  ok "settings.json instalado"
else
  warn "settings.json ya existe — revisá manualmente si querés agregar los hooks de uvpln"
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
echo ""
