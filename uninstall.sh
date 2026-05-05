#!/usr/bin/env bash
set -euo pipefail

CLAUDE_DIR="$HOME/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
HOOKS_DIR="$CLAUDE_DIR/hooks"
COMMANDS_DIR="$CLAUDE_DIR/commands"
TEMPLATES_DIR="$CLAUDE_DIR/templates"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; exit 1; }

# Flags
RESET_SETTINGS=0
PURGE_MEMORY=0
ASSUME_YES=0
for arg in "$@"; do
  case "$arg" in
    --reset-settings) RESET_SETTINGS=1 ;;
    --purge-memory)   PURGE_MEMORY=1 ;;
    -y|--yes)         ASSUME_YES=1 ;;
    -h|--help)
      cat <<EOF

  uvpln — desinstalador

  Borra uvpln de Claude Code. NO toca tus proyectos ni código.

  Uso:
    bash uninstall.sh                  desinstala (preguntará confirmación)
    bash uninstall.sh -y               sin confirmar
    bash uninstall.sh --reset-settings además borra ~/.claude/settings.json entero
    bash uninstall.sh --purge-memory   también borra ~/.claude/memory/design-systems/

EOF
      exit 0
      ;;
  esac
done

echo ""
echo "  uvpln — desinstalador"
echo "  Borra uvpln de Claude Code. Tus proyectos siguen intactos."
echo ""

if [ "$ASSUME_YES" -ne 1 ]; then
  read -r -p "  ¿Seguir? [y/N] " resp
  case "$resp" in
    [yY]|[yY][eE][sS]|[sS]) ;;
    *) err "Cancelado" ;;
  esac
fi

# 1. Agentes uvpln (lista fija — no toca otros agentes que tengas)
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
)
for agent in "${AGENTS[@]}"; do
  f="$AGENTS_DIR/$agent"
  if [ -f "$f" ]; then
    rm -f "$f"
    ok "Removido: agents/$agent"
  fi
done
if [ -d "$AGENTS_DIR" ] && [ -z "$(ls -A "$AGENTS_DIR" 2>/dev/null)" ]; then
  rmdir "$AGENTS_DIR"
  ok "Removido: agents/ (estaba vacío)"
fi

# 2. Scripts de sesión + statusline
for script in session-start.js session-end.js statusline.cjs; do
  f="$CLAUDE_DIR/$script"
  if [ -f "$f" ]; then
    rm -f "$f"
    ok "Removido: $script"
  fi
done

# 2b. Hooks de uvpln (lista fija — no toca otros hooks que tengas)
HOOKS=(
  "uvpln-track-agent-start.js"
  "uvpln-track-agent-end.js"
  "uvpln-check-colors.js"
  "uvpln-check-any.js"
  "uvpln-loop-trigger.js"
)
for hook in "${HOOKS[@]}"; do
  f="$HOOKS_DIR/$hook"
  if [ -f "$f" ]; then
    rm -f "$f"
    ok "Removido: hooks/$hook"
  fi
done
if [ -d "$HOOKS_DIR" ] && [ -z "$(ls -A "$HOOKS_DIR" 2>/dev/null)" ]; then
  rmdir "$HOOKS_DIR"
  ok "Removido: hooks/ (estaba vacío)"
fi

# 2c. Comandos slash de uvpln
for cmd in "uvpln-loop.md"; do
  f="$COMMANDS_DIR/$cmd"
  if [ -f "$f" ]; then
    rm -f "$f"
    ok "Removido: commands/$cmd"
  fi
done
if [ -d "$COMMANDS_DIR" ] && [ -z "$(ls -A "$COMMANDS_DIR" 2>/dev/null)" ]; then
  rmdir "$COMMANDS_DIR"
  ok "Removido: commands/ (estaba vacío)"
fi

# 2d. Plantillas de UI
for tpl in "README.md" "landing-page.md" "dashboard.md" "auth.md" "ecommerce.md"; do
  f="$TEMPLATES_DIR/$tpl"
  if [ -f "$f" ]; then
    rm -f "$f"
    ok "Removido: templates/$tpl"
  fi
done
if [ -d "$TEMPLATES_DIR" ] && [ -z "$(ls -A "$TEMPLATES_DIR" 2>/dev/null)" ]; then
  rmdir "$TEMPLATES_DIR"
  ok "Removido: templates/ (estaba vacío)"
fi

# 3. CLAUDE.md: si hay backup, lo restauramos; si no, borramos el de uvpln
if [ -f "$CLAUDE_DIR/CLAUDE.md.backup" ]; then
  mv "$CLAUDE_DIR/CLAUDE.md.backup" "$CLAUDE_DIR/CLAUDE.md"
  ok "CLAUDE.md.backup restaurado como CLAUDE.md"
elif [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  rm -f "$CLAUDE_DIR/CLAUDE.md"
  ok "CLAUDE.md removido"
fi

# 4. settings.json: por defecto NO lo tocamos (puede tener config tuya)
SETTINGS="$CLAUDE_DIR/settings.json"
if [ -f "$SETTINGS" ]; then
  if [ "$RESET_SETTINGS" -eq 1 ]; then
    rm -f "$SETTINGS"
    ok "settings.json removido (--reset-settings)"
  else
    warn "settings.json se queda intacto (puede tener config de otras herramientas)"
    echo ""
    echo "  Si querés sacar las claves de uvpln a mano, remové de $SETTINGS:"
    echo "    hooks.SessionStart"
    echo "    hooks.SessionEnd"
    echo "    hooks.PreToolUse  (los matchers Agent y Write|Edit)"
    echo "    hooks.PostToolUse (los matchers Agent y Write|Edit)"
    echo "    statusLine"
    echo ""
    echo "  O re-corré: bash uninstall.sh --reset-settings"
    echo ""
  fi
fi

# 5. Comando uvpln del PATH
for uvpln_bin in "$HOME/.local/bin/uvpln" "$HOME/.local/bin/uvpln.cmd"; do
  if [ -f "$uvpln_bin" ]; then
    rm -f "$uvpln_bin"
    ok "Removido: uvpln del PATH ($uvpln_bin)"
  fi
done

# 6. Memoria de design systems (solo si la persona lo pide)
DS="$CLAUDE_DIR/memory/design-systems"
if [ -d "$DS" ] && [ -n "$(ls -A "$DS" 2>/dev/null)" ]; then
  if [ "$PURGE_MEMORY" -eq 1 ]; then
    rm -rf "$DS"
    ok "memory/design-systems removido (--purge-memory)"
  else
    warn "memory/design-systems tiene tus tokens/decisiones por proyecto — NO se borra"
    echo "  Para borrarla: rm -rf $DS  (o usá --purge-memory)"
  fi
fi

echo ""
echo "  uvpln desinstalado. Tus proyectos siguen intactos."
echo ""
