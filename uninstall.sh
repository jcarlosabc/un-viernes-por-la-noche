#!/usr/bin/env bash
set -euo pipefail

# uvpln vive en ~/.claude-uvpln/ (aislado).
# Vanilla Claude (~/.claude/) NUNCA se toca por este script.

CLAUDE_DIR="$HOME/.claude-uvpln"
BIN_DIR="$HOME/.local/bin"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✓${NC} $1"; }
warn() { echo -e "${YELLOW}!${NC} $1"; }
err()  { echo -e "${RED}✗${NC} $1"; exit 1; }

# Elimina archivos uvpln que pudieron haber quedado en ~/.claude/ (vanilla).
# Corre siempre al final de cualquier modo de desinstalación.
cleanup_vanilla() {
  local VANILLA="$HOME/.claude"
  local leaked=0

  for f in "$VANILLA/commands/uvpln-"*.md; do
    [ -f "$f" ] || continue
    rm -f "$f"
    ok "Limpiado de ~/.claude/: commands/$(basename "$f")"
    leaked=$((leaked + 1))
  done

  for f in "$VANILLA/hooks/uvpln-"*.js; do
    [ -f "$f" ] || continue
    rm -f "$f"
    ok "Limpiado de ~/.claude/: hooks/$(basename "$f")"
    leaked=$((leaked + 1))
  done

  rm -f "$VANILLA/memory/active-agent.txt" 2>/dev/null || true

  if [ "$leaked" -gt 0 ]; then
    warn "$leaked archivo(s) de uvpln removidos de ~/.claude/ (estaban en el directorio vanilla)"
  fi
}

# Flags
PURGE_MEMORY=0
ASSUME_YES=0
FULL=0
for arg in "$@"; do
  case "$arg" in
    --purge-memory) PURGE_MEMORY=1 ;;
    --full)         FULL=1 ;;
    -y|--yes)       ASSUME_YES=1 ;;
    -h|--help)
      cat <<EOF

  uvpln — desinstalador

  Borra uvpln aislado (~/.claude-uvpln/) y el comando 'uvpln' del PATH.
  Tu Claude Code vanilla (~/.claude/) NO se toca, jamás.

  Uso:
    bash uninstall.sh                  desinstala uvpln (preguntará confirmación)
    bash uninstall.sh -y               sin confirmar
    bash uninstall.sh --purge-memory   también borra tus design systems (memory/)
    bash uninstall.sh --full           borra TODO ~/.claude-uvpln/ incluyendo
                                       proyectos, sesiones, memoria. Irreversible.

EOF
      exit 0
      ;;
  esac
done

echo ""
echo "  uvpln — desinstalador"
echo "  Borra uvpln aislado. Tu Claude vanilla queda intacto."
echo ""

if [ ! -d "$CLAUDE_DIR" ]; then
  warn "$CLAUDE_DIR no existe — uvpln ya estaba desinstalado."
  # Igual borramos el binario si quedó suelto
  for uvpln_bin in "$BIN_DIR/uvpln" "$BIN_DIR/uvpln.cmd"; do
    if [ -f "$uvpln_bin" ]; then
      rm -f "$uvpln_bin"
      ok "Removido: $uvpln_bin"
    fi
  done
  exit 0
fi

if [ "$ASSUME_YES" -ne 1 ]; then
  echo "  Se va a borrar: $CLAUDE_DIR"
  echo "  Comando 'uvpln' del PATH: $BIN_DIR/uvpln"
  if [ "$FULL" -eq 1 ]; then
    warn "MODO --full: incluye proyectos, sesiones, memoria. Irreversible."
  fi
  read -r -p "  ¿Seguir? [y/N] " resp
  case "$resp" in
    [yY]|[yY][eE][sS]|[sS]) ;;
    *) err "Cancelado" ;;
  esac
fi

# 1. Comando 'uvpln' del PATH (~/.local/bin)
for uvpln_bin in "$BIN_DIR/uvpln" "$BIN_DIR/uvpln.cmd"; do
  if [ -f "$uvpln_bin" ]; then
    rm -f "$uvpln_bin"
    ok "Removido: $uvpln_bin"
  fi
done

# 2. Modo --full: nuke entero
if [ "$FULL" -eq 1 ]; then
  rm -rf "$CLAUDE_DIR"
  ok "Removido: $CLAUDE_DIR (todo)"
  cleanup_vanilla
  echo ""
  echo "  uvpln desinstalado por completo."
  echo ""
  exit 0
fi

# 3. Modo normal: borrar archivos uvpln, conservar memoria/proyectos
AGENTS_DIR="$CLAUDE_DIR/agents"
HOOKS_DIR="$CLAUDE_DIR/hooks"
COMMANDS_DIR="$CLAUDE_DIR/commands"
TEMPLATES_DIR="$CLAUDE_DIR/templates"
EXAMPLES_DIR="$CLAUDE_DIR/examples"

# Agentes uvpln (lista fija)
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
  f="$AGENTS_DIR/$agent"
  if [ -f "$f" ]; then
    rm -f "$f"
    ok "Removido: agents/$agent"
  fi
done
[ -d "$AGENTS_DIR" ] && [ -z "$(ls -A "$AGENTS_DIR" 2>/dev/null)" ] && rmdir "$AGENTS_DIR" && ok "agents/ vacío removido"

# Scripts de sesión + statusline + config
for script in session-start.js session-end.js statusline.cjs agents-config.js; do
  f="$CLAUDE_DIR/$script"
  [ -f "$f" ] && rm -f "$f" && ok "Removido: $script"
done

# Hooks uvpln
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
  f="$HOOKS_DIR/$hook"
  [ -f "$f" ] && rm -f "$f" && ok "Removido: hooks/$hook"
done
[ -d "$HOOKS_DIR" ] && [ -z "$(ls -A "$HOOKS_DIR" 2>/dev/null)" ] && rmdir "$HOOKS_DIR" && ok "hooks/ vacío removido"

# Comandos slash
for cmd in "uvpln-loop.md" "uvpln-audit.md" "uvpln-handoff.md"; do
  f="$COMMANDS_DIR/$cmd"
  [ -f "$f" ] && rm -f "$f" && ok "Removido: commands/$cmd"
done
[ -d "$COMMANDS_DIR" ] && [ -z "$(ls -A "$COMMANDS_DIR" 2>/dev/null)" ] && rmdir "$COMMANDS_DIR" && ok "commands/ vacío removido"

# Plantillas
for tpl in "README.md" "landing-page.md" "dashboard.md" "auth.md" "ecommerce.md"; do
  f="$TEMPLATES_DIR/$tpl"
  [ -f "$f" ] && rm -f "$f" && ok "Removido: templates/$tpl"
done
[ -d "$TEMPLATES_DIR" ] && [ -z "$(ls -A "$TEMPLATES_DIR" 2>/dev/null)" ] && rmdir "$TEMPLATES_DIR" && ok "templates/ vacío removido"

# Examples
for ex in "button-variants.md" "form-validation.md" "data-table.md" "modal-pattern.md" "theme-tokens.md" "api-fetch.md" "card-grid.md" "navigation.md" "toast-notifications.md"; do
  f="$EXAMPLES_DIR/$ex"
  [ -f "$f" ] && rm -f "$f" && ok "Removido: examples/$ex"
done
[ -d "$EXAMPLES_DIR" ] && [ -z "$(ls -A "$EXAMPLES_DIR" 2>/dev/null)" ] && rmdir "$EXAMPLES_DIR" && ok "examples/ vacío removido"

# CLAUDE.md (dentro de uvpln — restaurar backup o borrar)
if [ -f "$CLAUDE_DIR/CLAUDE.md.backup" ]; then
  mv "$CLAUDE_DIR/CLAUDE.md.backup" "$CLAUDE_DIR/CLAUDE.md"
  ok "CLAUDE.md.backup restaurado como CLAUDE.md (uvpln)"
elif [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  rm -f "$CLAUDE_DIR/CLAUDE.md"
  ok "CLAUDE.md removido"
fi

# settings.json (dentro de uvpln — no afecta vanilla)
SETTINGS="$CLAUDE_DIR/settings.json"
if [ -f "$SETTINGS" ]; then
  rm -f "$SETTINGS"
  ok "settings.json removido"
fi

# Memoria de design systems (solo si la persona lo pide)
DS="$CLAUDE_DIR/memory/design-systems"
if [ -d "$DS" ] && [ -n "$(ls -A "$DS" 2>/dev/null)" ]; then
  if [ "$PURGE_MEMORY" -eq 1 ]; then
    rm -rf "$DS"
    ok "memory/design-systems removido (--purge-memory)"
  else
    warn "memory/design-systems tiene tus tokens/decisiones — NO se borra"
    echo "  Para borrarla: rm -rf $DS  (o usá --purge-memory)"
  fi
fi

# Si ~/.claude-uvpln/ quedó sólo con runtime state (memory/sessions/projects), lo dejamos.
# El usuario puede borrarlo con --full si quiere.

cleanup_vanilla

echo ""
echo "  uvpln desinstalado. Tu Claude Code vanilla sigue intacto."
echo "  Si querés borrar TODO (proyectos, sesiones, memoria): bash uninstall.sh --full"
echo ""
