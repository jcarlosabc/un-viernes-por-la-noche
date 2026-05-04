# uvpln session-start — Se ejecuta al abrir Claude Code

$CLAUDE_DIR   = "$env:USERPROFILE\.claude"
$PROJECT_DIR  = Get-Location
$PROJECT_NAME = Split-Path -Leaf $PROJECT_DIR
$DS_FILE      = "$CLAUDE_DIR\memory\design-systems\$PROJECT_NAME.md"

Write-Host ""
Write-Host "  ██╗   ██╗██╗   ██╗██████╗ ██╗     ███╗   ██╗" -ForegroundColor Magenta
Write-Host "  ██║   ██║██║   ██║██╔══██╗██║     ████╗  ██║" -ForegroundColor Magenta
Write-Host "  ██║   ██║██║   ██║██████╔╝██║     ██╔██╗ ██║" -ForegroundColor Magenta
Write-Host "  ██║   ██║╚██╗ ██╔╝██╔═══╝ ██║     ██║╚██╗██║" -ForegroundColor Magenta
Write-Host "  ╚██████╔╝ ╚████╔╝ ██║     ███████╗██║ ╚████║" -ForegroundColor Magenta
Write-Host "   ╚═════╝   ╚═══╝  ╚═╝     ╚══════╝╚═╝  ╚═══╝" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Un Viernes Por La Noche" -NoNewline -ForegroundColor Green
Write-Host " — Frontend AI Agent" -ForegroundColor DarkGray
Write-Host "  UI bonita. Codigo limpio. Deploy y a dormir." -ForegroundColor DarkGray
Write-Host ""
Write-Host "  ─────────────────────────────────────────────" -ForegroundColor DarkGray

Write-Host "  Proyecto:      " -NoNewline -ForegroundColor White
Write-Host $PROJECT_NAME -ForegroundColor Green

if (Test-Path $DS_FILE) {
  $lines = (Get-Content $DS_FILE).Count
  Write-Host "  Design system: " -NoNewline -ForegroundColor White
  Write-Host "cargado ($lines lineas)" -ForegroundColor Green
} else {
  Write-Host "  Design system: " -NoNewline -ForegroundColor White
  Write-Host "sin registrar todavia" -ForegroundColor DarkGray
}

$agentCount = 0
if (Test-Path "$CLAUDE_DIR\agents") {
  $agentCount = (Get-ChildItem "$CLAUDE_DIR\agents" -Filter "*.md").Count
}
Write-Host "  Agentes:       " -NoNewline -ForegroundColor White
Write-Host "$agentCount disponibles" -ForegroundColor Green

Write-Host "  ─────────────────────────────────────────────" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Hola parcero, que haremos hoy?" -ForegroundColor Magenta
Write-Host ""
