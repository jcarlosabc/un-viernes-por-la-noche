# uvpln session-end — Se ejecuta al cerrar Claude Code

$CLAUDE_DIR   = "$env:USERPROFILE\.claude"
$PROJECT_NAME = Split-Path -Leaf (Get-Location)
$DS_FILE      = "$CLAUDE_DIR\memory\design-systems\$PROJECT_NAME.md"

Write-Host ""
Write-Host "  Un Viernes Por La Noche — cerrando sesion" -ForegroundColor Magenta
Write-Host ""

# Registrar ultima sesion
$lastSession = "$CLAUDE_DIR\memory\last-session.txt"
New-Item -ItemType Directory -Force -Path "$CLAUDE_DIR\memory" | Out-Null
"$PROJECT_NAME — $(Get-Date -Format 'yyyy-MM-dd HH:mm')" | Set-Content $lastSession

if (Test-Path $DS_FILE) {
  $lines = (Get-Content $DS_FILE).Count
  Write-Host "  Design system guardado: $PROJECT_NAME ($lines lineas)" -ForegroundColor Green
} else {
  Write-Host "  Sin design system para: $PROJECT_NAME" -ForegroundColor DarkGray
  Write-Host "  Tip: pedile a uvpln 'guarda el design system de este proyecto'" -ForegroundColor DarkGray
}

Write-Host ""
Write-Host "  Hasta la proxima parcero." -ForegroundColor Magenta
Write-Host ""
