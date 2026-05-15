#!/usr/bin/env bash
set -euo pipefail

# uvpln se instala APARTE de Claude Code vanilla.
# - Vanilla Claude vive en ~/.claude/        (no se toca)
# - uvpln vive en      ~/.claude-uvpln/      (todo lo nuestro va acá)
# - El usuario invoca:
#     claude   → Claude vanilla
#     uvpln    → Claude con CLAUDE_CONFIG_DIR=~/.claude-uvpln

UVPLN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude-uvpln"
AGENTS_DIR="$CLAUDE_DIR/agents"
HOOKS_DIR="$CLAUDE_DIR/hooks"
COMMANDS_DIR="$CLAUDE_DIR/commands"
TEMPLATES_DIR="$CLAUDE_DIR/templates"
EXAMPLES_DIR="$CLAUDE_DIR/examples"
MEMORY_DIR="$CLAUDE_DIR/memory/design-systems"
BIN_DIR="$HOME/.local/bin"
UVPLN_BIN="$BIN_DIR/uvpln"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
MAGENTA='\033[0;35m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; exit 1; }
hdr()  { echo -e "${MAGENTA}$1${NC}"; }

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
hdr "  Un Viernes Por La Noche — instalador"
echo "  Instalación aislada: no toca tu Claude Code vanilla."
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

# Crear estructura de directorios (aislada)
mkdir -p "$AGENTS_DIR"
mkdir -p "$HOOKS_DIR"
mkdir -p "$COMMANDS_DIR"
mkdir -p "$TEMPLATES_DIR"
mkdir -p "$EXAMPLES_DIR"
mkdir -p "$MEMORY_DIR"
mkdir -p "$BIN_DIR"
ok "Directorios creados en $CLAUDE_DIR"

# Instalar CLAUDE.md (con backup si ya existe — solo dentro de uvpln)
if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.backup"
  warn "CLAUDE.md de uvpln existente respaldado en CLAUDE.md.backup"
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

# Instalar scripts de sesión + statusline + config compartido (Node.js, cross-platform)
for script in session-start.js session-end.js statusline.cjs agents-config.js; do
  src="$UVPLN_DIR/claude/$script"
  dst="$CLAUDE_DIR/$script"
  if [ -f "$src" ]; then
    cp "$src" "$dst"
    ok "Script instalado: $script"
  else
    warn "No encontrado: $script — saltando"
  fi
done

# Instalar hooks (lista fija)
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

# Instalar / mergear settings.json (dentro de uvpln, NO vanilla)
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
    ok "settings.json mergeado (hooks de uvpln + config previa de uvpln)"
  else
    err "Falló el merge de settings.json — revisá el backup en $CLAUDE_DIR"
  fi
fi

# Crear comando 'uvpln' en ~/.local/bin
cat > "$UVPLN_BIN" <<'EOF'
#!/usr/bin/env bash
# uvpln launcher — corre Claude Code con CLAUDE_CONFIG_DIR=~/.claude-uvpln
export CLAUDE_CONFIG_DIR="$HOME/.claude-uvpln"
exec claude "$@"
EOF
chmod +x "$UVPLN_BIN"
ok "Comando 'uvpln' creado en $UVPLN_BIN"

# Detectar si ~/.local/bin está en PATH
PATH_OK=0
case ":$PATH:" in
  *":$BIN_DIR:"*) PATH_OK=1 ;;
esac

echo ""
hdr "  ¡Listo! uvpln instalado en modo aislado."
echo ""
echo "  Cómo usar:"
echo -e "    ${GREEN}claude${NC}   → Claude Code vanilla (sin uvpln, sin tocar)"
echo -e "    ${MAGENTA}uvpln${NC}    → Claude Code con uvpln (23 agentes, hooks, statusline)"
echo ""

if [ "$PATH_OK" -eq 0 ]; then
  warn "$BIN_DIR no está en tu PATH. Agregalo así:"
  echo ""
  if [ -f "$HOME/.zshrc" ]; then
    echo "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
  elif [ -f "$HOME/.bashrc" ]; then
    echo "    echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
  else
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
  fi
  echo ""
  echo "  Mientras tanto podés correr uvpln con la ruta completa:"
  echo "    $UVPLN_BIN"
  echo ""
else
  echo "  Probalo ahora:"
  echo -e "    ${MAGENTA}uvpln${NC}"
  echo ""
fi

echo "  Agentes incluidos:"
for agent in "${AGENTS[@]}"; do
  echo "    - ${agent%.md}"
done
echo ""
echo "  Verificación rápida: bash install.sh --check"
echo "  Desinstalar:         bash uninstall.sh"
echo ""
