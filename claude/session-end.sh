#!/usr/bin/env bash
# Se ejecuta automáticamente al cerrar Claude Code (SessionEnd hook)

CLAUDE_DIR="$HOME/.claude"
MEMORY_DIR="$CLAUDE_DIR/memory/design-systems"
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
DESIGN_SYSTEM_FILE="$MEMORY_DIR/$PROJECT_NAME.md"

mkdir -p "$MEMORY_DIR"

echo ""
echo "  Un Viernes Por La Noche — cerrando sesión"
echo ""

# Registrar fecha de última sesión
LAST_SESSION_FILE="$CLAUDE_DIR/memory/last-session.txt"
echo "$PROJECT_NAME — $(date '+%Y-%m-%d %H:%M')" > "$LAST_SESSION_FILE"

# Si existe memoria del design system, confirmar que está guardada
if [ -f "$DESIGN_SYSTEM_FILE" ]; then
  SIZE=$(wc -l < "$DESIGN_SYSTEM_FILE")
  echo "  Design system guardado: $PROJECT_NAME ($SIZE líneas)"
else
  echo "  Sin design system registrado para: $PROJECT_NAME"
  echo "  Tip: pedile a uvpln que guarde los tokens y patrones del proyecto"
  echo "  con: 'guardá el design system de este proyecto'"
fi

echo ""
echo "  Hasta la próxima parcero."
echo ""
