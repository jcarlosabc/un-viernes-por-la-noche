#!/usr/bin/env bash
# E2E test del flow install + reinstall + uninstall sobre HOME fake.
# Cero efecto sobre tu ~/.claude/ real.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
PASS=0
FAIL=0

assert_file() {
  local f="$1" desc="$2"
  if [ -f "$f" ]; then
    echo -e "${GREEN}✓${NC} $desc"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}✗${NC} $desc (no existe: $f)"
    FAIL=$((FAIL + 1))
  fi
}

assert_eq() {
  local actual="$1" expected="$2" desc="$3"
  if [ "$actual" = "$expected" ]; then
    echo -e "${GREEN}✓${NC} $desc"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}✗${NC} $desc — esperaba '$expected', actual '$actual'"
    FAIL=$((FAIL + 1))
  fi
}

assert_not_exists() {
  local p="$1" desc="$2"
  if [ ! -e "$p" ]; then
    echo -e "${GREEN}✓${NC} $desc"
    PASS=$((PASS + 1))
  else
    echo -e "${RED}✗${NC} $desc (sigue existiendo: $p)"
    FAIL=$((FAIL + 1))
  fi
}

# ─────────────────────────────────────────────────────────
echo "=== install sobre HOME limpio ==="
FAKE=$(mktemp -d)
HOME="$FAKE" bash "$ROOT/install.sh" >/dev/null

assert_file "$FAKE/.claude/CLAUDE.md" "CLAUDE.md instalado"
assert_file "$FAKE/.claude/settings.json" "settings.json instalado"
assert_file "$FAKE/.claude/agents/ui-architect.md" "agente ui-architect instalado"
assert_file "$FAKE/.claude/hooks/uvpln-check-colors.js" "hook check-colors instalado"
assert_file "$FAKE/.claude/hooks/uvpln-check-any.js" "hook check-any instalado"
assert_file "$FAKE/.claude/hooks/uvpln-track-agent-start.js" "hook track-agent-start instalado"
assert_file "$FAKE/.claude/hooks/uvpln-track-agent-end.js" "hook track-agent-end instalado"
assert_file "$FAKE/.claude/session-start.js" "session-start.js instalado"
assert_file "$FAKE/.claude/statusline.cjs" "statusline.cjs instalado"
rm -rf "$FAKE"

# ─────────────────────────────────────────────────────────
echo ""
echo "=== reinstalación idempotente (5x) ==="
FAKE=$(mktemp -d)
for _ in 1 2 3 4 5; do
  HOME="$FAKE" bash "$ROOT/install.sh" >/dev/null
done
SS=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$FAKE/.claude/settings.json','utf8')).hooks.SessionStart.length)")
assert_eq "$SS" "1" "SessionStart no se duplica tras 5 instalaciones"

PT=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$FAKE/.claude/settings.json','utf8')).hooks.PreToolUse.length)")
assert_eq "$PT" "2" "PreToolUse no se duplica tras 5 instalaciones"

PO=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$FAKE/.claude/settings.json','utf8')).hooks.PostToolUse.length)")
assert_eq "$PO" "2" "PostToolUse no se duplica tras 5 instalaciones"
rm -rf "$FAKE"

# ─────────────────────────────────────────────────────────
echo ""
echo "=== install respeta hooks ajenos ==="
FAKE=$(mktemp -d)
mkdir -p "$FAKE/.claude"
cat > "$FAKE/.claude/settings.json" <<'EOF'
{"model":"claude-opus-4-7","hooks":{"PreToolUse":[{"matcher":"Bash","hooks":[{"type":"command","command":"echo mi-hook"}]}]},"statusLine":{"type":"command","command":"mi-statusline-propia"}}
EOF
HOME="$FAKE" bash "$ROOT/install.sh" >/dev/null

MODEL=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$FAKE/.claude/settings.json','utf8')).model)")
assert_eq "$MODEL" "claude-opus-4-7" "model del usuario preservado"

PRESERVED=$(node -e "
const j=JSON.parse(require('fs').readFileSync('$FAKE/.claude/settings.json','utf8'));
console.log(j.hooks.PreToolUse.some(g=>g.hooks[0].command.includes('mi-hook')) ? 'yes' : 'no')
")
assert_eq "$PRESERVED" "yes" "hook ajeno preservado"

SL=$(node -e "console.log(JSON.parse(require('fs').readFileSync('$FAKE/.claude/settings.json','utf8')).statusLine.command)")
assert_eq "$SL" "mi-statusline-propia" "statusLine del usuario respetada"
rm -rf "$FAKE"

# ─────────────────────────────────────────────────────────
echo ""
echo "=== uninstall limpia uvpln ==="
FAKE=$(mktemp -d)
HOME="$FAKE" bash "$ROOT/install.sh" >/dev/null
HOME="$FAKE" bash "$ROOT/uninstall.sh" -y >/dev/null

assert_not_exists "$FAKE/.claude/agents/ui-architect.md" "agente ui-architect removido"
assert_not_exists "$FAKE/.claude/hooks/uvpln-check-colors.js" "hook check-colors removido"
assert_not_exists "$FAKE/.claude/agents" "dir agents/ removido (vacío)"
assert_not_exists "$FAKE/.claude/hooks" "dir hooks/ removido (vacío)"
rm -rf "$FAKE"

# ─────────────────────────────────────────────────────────
echo ""
echo "=== resumen ==="
echo "PASS: $PASS  FAIL: $FAIL"
[ "$FAIL" -eq 0 ]
