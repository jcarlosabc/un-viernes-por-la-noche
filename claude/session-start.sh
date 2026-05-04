#!/usr/bin/env bash
# Se ejecuta automáticamente al abrir Claude Code (SessionStart hook)

CLAUDE_DIR="$HOME/.claude"
MEMORY_DIR="$CLAUDE_DIR/memory/design-systems"
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
DESIGN_SYSTEM_FILE="$MEMORY_DIR/$PROJECT_NAME.md"

echo ""
echo "  Un Viernes Por La Noche — listo parcero"
echo ""

# Mostrar memoria del design system si existe para este proyecto
if [ -f "$DESIGN_SYSTEM_FILE" ]; then
  echo "  Design system cargado: $PROJECT_NAME"
  echo "  ────────────────────────────────────────"
  cat "$DESIGN_SYSTEM_FILE"
  echo "  ────────────────────────────────────────"
else
  echo "  Proyecto nuevo: $PROJECT_NAME"
  echo "  No hay design system guardado todavía."
  echo "  Cuando identifiques tokens, colores o patrones, los guardo en:"
  echo "  $DESIGN_SYSTEM_FILE"
fi

echo ""

# Mostrar agentes disponibles
echo "  Agentes disponibles:"
if [ -d "$CLAUDE_DIR/agents" ]; then
  for agent in "$CLAUDE_DIR/agents"/*.md; do
    name=$(basename "$agent" .md)
    echo "    → $name"
  done
fi

echo ""
