# uvpln — instalador para Windows
# Ejecutar: powershell -ExecutionPolicy Bypass -File install.ps1

$UVPLN_DIR  = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAUDE_DIR = "$env:USERPROFILE\.claude"
$AGENTS_DIR = "$CLAUDE_DIR\agents"
$MEMORY_DIR = "$CLAUDE_DIR\memory\design-systems"

function ok($msg)   { Write-Host "  [OK] $msg" -ForegroundColor Green }
function warn($msg) { Write-Host "  [!]  $msg" -ForegroundColor Yellow }
function err($msg)  { Write-Host "  [X]  $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "  Un Viernes Por La Noche - instalador Windows" -ForegroundColor Magenta
Write-Host "  Cartagena de Indias, Colombia" -ForegroundColor Green
Write-Host ""

# Verificar Claude Code
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
  err "Claude Code no esta instalado. Instalalo primero: https://claude.ai/code"
}
ok "Claude Code encontrado"

# Crear directorios
New-Item -ItemType Directory -Force -Path $AGENTS_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $MEMORY_DIR | Out-Null
ok "Directorios creados en $CLAUDE_DIR"

# Instalar CLAUDE.md
$src = "$UVPLN_DIR\claude\CLAUDE.md"
$dst = "$CLAUDE_DIR\CLAUDE.md"
if (Test-Path $dst) {
  Copy-Item $dst "$CLAUDE_DIR\CLAUDE.md.backup" -Force
  warn "CLAUDE.md existente respaldado en CLAUDE.md.backup"
}
Copy-Item $src $dst -Force
ok "CLAUDE.md instalado"

# Instalar agentes
$agents = @(
  "ui-architect.md"
  "ui-tester.md"
  "a11y-expert.md"
  "motion-designer.md"
  "tokens-manager.md"
  "performance-ui.md"
  "code-reviewer.md"
  "refactoring-specialist.md"
)

foreach ($agent in $agents) {
  $src = "$UVPLN_DIR\claude\agents\$agent"
  $dst = "$AGENTS_DIR\$agent"
  if (Test-Path $src) {
    Copy-Item $src $dst -Force
    ok "Agente instalado: $agent"
  } else {
    warn "No encontrado: $agent — saltando"
  }
}

# Instalar scripts
foreach ($script in @("session-start.ps1", "session-end.ps1", "statusline.cjs")) {
  $src = "$UVPLN_DIR\claude\$script"
  $dst = "$CLAUDE_DIR\$script"
  if (Test-Path $src) {
    Copy-Item $src $dst -Force
    ok "Script instalado: $script"
  }
}

# Instalar settings.json (version Windows)
$settingsSrc = "$UVPLN_DIR\claude\settings-windows.json"
$settingsDst = "$CLAUDE_DIR\settings.json"
if (-not (Test-Path $settingsDst)) {
  Copy-Item $settingsSrc $settingsDst -Force
  ok "settings.json instalado"
} else {
  warn "settings.json ya existe — revisa manualmente si queres agregar los hooks de uvpln"
}

Write-Host ""
Write-Host "  Listo parcero! uvpln esta instalado." -ForegroundColor Magenta
Write-Host ""
Write-Host "  Agentes disponibles:" -ForegroundColor White
foreach ($agent in $agents) {
  Write-Host "    -> $($agent -replace '\.md','')" -ForegroundColor Green
}
Write-Host ""
Write-Host "  Abri Claude Code en tu proyecto: claude" -ForegroundColor White
Write-Host ""
