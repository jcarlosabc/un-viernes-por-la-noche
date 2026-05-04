#!/usr/bin/env bash
# Se ejecuta automáticamente al abrir Claude Code (SessionStart hook)

CLAUDE_DIR="$HOME/.claude"
MEMORY_DIR="$CLAUDE_DIR/memory/design-systems"
PROJECT_DIR="$(pwd)"
PROJECT_NAME="$(basename "$PROJECT_DIR")"
DESIGN_SYSTEM_FILE="$MEMORY_DIR/$PROJECT_NAME.md"

PURPLE='\033[0;35m'
GREEN='\033[0;32m'
WHITE='\033[1;37m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

echo ""
echo -e "${PURPLE}${BOLD}"
echo "  ██╗   ██╗██╗   ██╗██████╗ ██╗     ███╗   ██╗"
echo "  ██║   ██║██║   ██║██╔══██╗██║     ████╗  ██║"
echo "  ██║   ██║██║   ██║██████╔╝██║     ██╔██╗ ██║"
echo "  ██║   ██║╚██╗ ██╔╝██╔═══╝ ██║     ██║╚██╗██║"
echo "  ╚██████╔╝ ╚████╔╝ ██║     ███████╗██║ ╚████║"
echo "   ╚═════╝   ╚═══╝  ╚═╝     ╚══════╝╚═╝  ╚═══╝"
echo -e "${NC}"
echo -e "  ${GREEN}${BOLD}Un Viernes Por La Noche${NC} ${DIM}— Frontend AI Agent${NC}"
echo -e "  ${DIM}UI bonita. Código limpio. Deploy y a dormir.${NC}"
echo ""
echo -e "  ${DIM}─────────────────────────────────────────────${NC}"

# Proyecto activo
echo -e "  ${WHITE}Proyecto:${NC}  ${GREEN}$PROJECT_NAME${NC}"

# Design system
if [ -f "$DESIGN_SYSTEM_FILE" ]; then
  LINES=$(wc -l < "$DESIGN_SYSTEM_FILE")
  echo -e "  ${WHITE}Design system:${NC} ${GREEN}cargado ($LINES líneas)${NC}"
else
  echo -e "  ${WHITE}Design system:${NC} ${DIM}sin registrar todavía${NC}"
fi

# Agentes disponibles
AGENT_COUNT=0
if [ -d "$CLAUDE_DIR/agents" ]; then
  AGENT_COUNT=$(ls "$CLAUDE_DIR/agents"/*.md 2>/dev/null | wc -l)
fi
echo -e "  ${WHITE}Agentes:${NC}       ${GREEN}$AGENT_COUNT disponibles${NC}"

echo -e "  ${DIM}─────────────────────────────────────────────${NC}"
echo ""
echo -e "  ${PURPLE}Hola parcero, ¿qué haremos hoy?${NC}"
echo ""
