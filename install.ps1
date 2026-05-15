# uvpln - instalador para Windows
# Ejecutar: powershell -ExecutionPolicy Bypass -File install.ps1
# Preview sin instalar: powershell -ExecutionPolicy Bypass -File install.ps1 -Check
# Forzar statusLine de uvpln: powershell -ExecutionPolicy Bypass -File install.ps1 -ForceStatusline
#
# uvpln se instala APARTE de Claude Code vanilla:
#   - Vanilla Claude vive en %USERPROFILE%\.claude\        (no se toca)
#   - uvpln vive en       %USERPROFILE%\.claude-uvpln\     (todo lo nuestro va aca)
#   - El usuario invoca:
#       claude   -> Claude vanilla
#       uvpln    -> Claude con CLAUDE_CONFIG_DIR=~\.claude-uvpln

param(
    [switch]$Check,
    [switch]$ForceStatusline
)

$UVPLN_DIR      = Split-Path -Parent $MyInvocation.MyCommand.Path
$CLAUDE_DIR     = "$env:USERPROFILE\.claude-uvpln"
$AGENTS_DIR     = "$CLAUDE_DIR\agents"
$HOOKS_DIR      = "$CLAUDE_DIR\hooks"
$COMMANDS_DIR   = "$CLAUDE_DIR\commands"
$TEMPLATES_DIR  = "$CLAUDE_DIR\templates"
$EXAMPLES_DIR   = "$CLAUDE_DIR\examples"
$MEMORY_DIR     = "$CLAUDE_DIR\memory\design-systems"
$BIN_DIR        = "$env:USERPROFILE\.local\bin"
$UVPLN_BIN      = "$BIN_DIR\uvpln.cmd"

function ok   { param($msg); Write-Host "  [OK] $msg" -ForegroundColor Green }
function warn { param($msg); Write-Host "  [!]  $msg" -ForegroundColor Yellow }
function err  { param($msg); Write-Host "  [X]  $msg" -ForegroundColor Red; exit 1 }

# Modo -Check: preview de graficas sin instalar
if ($Check) {
    Write-Host ""
    Write-Host "  uvpln - preview de graficas (sin instalar)" -ForegroundColor Magenta
    Write-Host ""
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        err "Node.js no esta instalado. Las graficas necesitan Node 18+: https://nodejs.org"
    }
    $nodeVer = (node --version)
    ok "Node $nodeVer encontrado"
    Write-Host ""
    & node "$UVPLN_DIR\claude\session-start.js"
    Write-Host ""
    ok "Si viste el banner morado/verde, las graficas van a funcionar tras instalar."
    Write-Host ""
    Write-Host "  Para instalar: powershell -ExecutionPolicy Bypass -File install.ps1" -ForegroundColor White
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "  Un Viernes Por La Noche - instalador Windows" -ForegroundColor Magenta
Write-Host "  Instalacion aislada: no toca tu Claude Code vanilla." -ForegroundColor White
Write-Host ""

# Verificar Claude Code
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    err "Claude Code no esta instalado. Instalalo: https://claude.ai/code"
}
ok "Claude Code encontrado"

# Verificar Node.js (banner + statusline + hooks corren en Node)
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    err "Node.js no esta instalado. Las graficas y hooks lo necesitan. Instala Node 18+: https://nodejs.org"
}
$nodeVer = (node --version)
$nodeMajor = [int](($nodeVer -replace '^v', '') -split '\.')[0]
if ($nodeMajor -lt 18) {
    warn "Node $nodeVer detectado - recomendado Node 18+"
} else {
    ok "Node $nodeVer encontrado"
}

# Crear directorios (aislados)
New-Item -ItemType Directory -Force -Path $AGENTS_DIR    | Out-Null
New-Item -ItemType Directory -Force -Path $HOOKS_DIR     | Out-Null
New-Item -ItemType Directory -Force -Path $COMMANDS_DIR  | Out-Null
New-Item -ItemType Directory -Force -Path $TEMPLATES_DIR | Out-Null
New-Item -ItemType Directory -Force -Path $EXAMPLES_DIR  | Out-Null
New-Item -ItemType Directory -Force -Path $MEMORY_DIR    | Out-Null
New-Item -ItemType Directory -Force -Path $BIN_DIR       | Out-Null
ok "Directorios creados en $CLAUDE_DIR"

# Instalar CLAUDE.md (con backup si ya existe - dentro de uvpln)
$src = "$UVPLN_DIR\claude\CLAUDE.md"
$dst = "$CLAUDE_DIR\CLAUDE.md"
if (Test-Path $dst) {
    Copy-Item $dst "$CLAUDE_DIR\CLAUDE.md.backup" -Force
    warn "CLAUDE.md de uvpln existente respaldado en CLAUDE.md.backup"
}
Copy-Item $src $dst -Force
ok "CLAUDE.md instalado"

# Instalar agentes
$agents = @(
    "ui-architect.md",
    "ui-tester.md",
    "a11y-expert.md",
    "motion-designer.md",
    "tokens-manager.md",
    "performance-ui.md",
    "code-reviewer.md",
    "refactoring-specialist.md",
    "design-bridge.md",
    "ui-designer.md",
    "ux-researcher.md",
    "debugger.md",
    "api-integrator.md",
    "form-specialist.md",
    "state-manager.md"
)

foreach ($agent in $agents) {
    $src = "$UVPLN_DIR\claude\agents\$agent"
    $dst = "$AGENTS_DIR\$agent"
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        ok "Agente instalado: $agent"
    } else {
        warn "No encontrado: $agent - saltando"
    }
}

# Instalar scripts de sesion + statusline + config compartido (Node.js, cross-platform)
$scripts = @("session-start.js", "session-end.js", "statusline.cjs", "agents-config.js")
foreach ($script in $scripts) {
    $src = "$UVPLN_DIR\claude\$script"
    $dst = "$CLAUDE_DIR\$script"
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        ok "Script instalado: $script"
    } else {
        warn "No encontrado: $script - saltando"
    }
}

# Instalar hooks (lista fija)
$hooks = @(
    "uvpln-track-agent-start.js",
    "uvpln-track-agent-end.js",
    "uvpln-check-colors.js",
    "uvpln-check-any.js",
    "uvpln-loop-trigger.js",
    "uvpln-check-console.js",
    "uvpln-check-a11y.js",
    "uvpln-check-use-client.js"
)
foreach ($hook in $hooks) {
    $src = "$UVPLN_DIR\claude\hooks\$hook"
    $dst = "$HOOKS_DIR\$hook"
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        ok "Hook instalado: hooks\$hook"
    } else {
        warn "No encontrado: $hook - saltando"
    }
}

# Instalar comandos slash (loop de calidad)
$commands = @("uvpln-loop.md", "uvpln-audit.md", "uvpln-handoff.md")
foreach ($cmd in $commands) {
    $src = "$UVPLN_DIR\claude\commands\$cmd"
    $dst = "$COMMANDS_DIR\$cmd"
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        ok "Comando instalado: commands\$cmd"
    } else {
        warn "No encontrado: $cmd - saltando"
    }
}

# Instalar plantillas de UI
$templates = @("README.md", "landing-page.md", "dashboard.md", "auth.md", "ecommerce.md")
foreach ($tpl in $templates) {
    $src = "$UVPLN_DIR\claude\templates\$tpl"
    $dst = "$TEMPLATES_DIR\$tpl"
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        ok "Plantilla instalada: templates\$tpl"
    } else {
        warn "No encontrado: $tpl - saltando"
    }
}

# Instalar examples de codigo (patrones TS + JS)
$examples = @(
    "button-variants.md",
    "form-validation.md",
    "data-table.md",
    "modal-pattern.md",
    "theme-tokens.md",
    "api-fetch.md",
    "card-grid.md",
    "navigation.md",
    "toast-notifications.md"
)
foreach ($ex in $examples) {
    $src = "$UVPLN_DIR\claude\examples\$ex"
    $dst = "$EXAMPLES_DIR\$ex"
    if (Test-Path $src) {
        Copy-Item $src $dst -Force
        ok "Example instalado: examples\$ex"
    } else {
        warn "No encontrado: $ex - saltando"
    }
}

# Instalar / mergear settings.json (dentro de uvpln, NO vanilla)
$settingsSrc = "$UVPLN_DIR\claude\settings.json"
$settingsDst = "$CLAUDE_DIR\settings.json"
$mergeScript = "$UVPLN_DIR\claude\install\merge-settings.js"

if (-not (Test-Path $settingsDst)) {
    Copy-Item $settingsSrc $settingsDst -Force
    ok "settings.json instalado"
} else {
    $mergeArgs = @($mergeScript, $settingsSrc, $settingsDst)
    if ($ForceStatusline) { $mergeArgs += "--force-statusline" }
    & node @mergeArgs
    if ($LASTEXITCODE -eq 0) {
        ok "settings.json mergeado (hooks de uvpln + config previa de uvpln)"
    } else {
        err "Fallo el merge de settings.json - revisa el backup en $CLAUDE_DIR"
    }
}

# Crear comando 'uvpln.cmd' en ~\.local\bin
$batContent = @'
@echo off
REM uvpln launcher - Para desinstalar: uvpln uninstall
if /i "%~1"=="uninstall" goto :uvpln_uninstall
set CLAUDE_CONFIG_DIR=%USERPROFILE%\.claude-uvpln
claude %*
set CLAUDE_CONFIG_DIR=
goto :eof

:uvpln_uninstall
echo.
echo   Un Viernes Por La Noche - desinstalador
echo   Borra uvpln aislado. Tu Claude vanilla queda intacto.
echo.
set UVPLN_CLAUDE=%USERPROFILE%\.claude-uvpln
set VANILLA=%USERPROFILE%\.claude
if exist "%UVPLN_CLAUDE%" (
    rmdir /s /q "%UVPLN_CLAUDE%"
    echo   [OK] .claude-uvpln eliminado
) else (
    echo   [!]  .claude-uvpln no encontrado - ya estaba eliminado
)
for %%F in ("%VANILLA%\commands\uvpln-*.md") do (
    del /q "%%F" 2>nul
    echo   [!]  Limpiado de .claude\commands: %%~nxF
)
for %%F in ("%VANILLA%\hooks\uvpln-*.js") do (
    del /q "%%F" 2>nul
    echo   [!]  Limpiado de .claude\hooks: %%~nxF
)
if exist "%VANILLA%\memory\active-agent.txt" del /q "%VANILLA%\memory\active-agent.txt"
echo   [OK] %~f0 eliminado
echo.
echo   uvpln desinstalado.
echo.
del /q "%~f0"
'@
Set-Content -Path $UVPLN_BIN -Value $batContent -Encoding ASCII
ok "Comando 'uvpln' creado en $UVPLN_BIN"

# Detectar si ~\.local\bin esta en PATH (User scope)
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathOk = $false
if ($userPath -and ($userPath.Split(';') -contains $BIN_DIR)) {
    $pathOk = $true
}

# Agregar al PATH automaticamente si falta
if (-not $pathOk) {
    try {
        $newPath = if ($userPath) { "$userPath;$BIN_DIR" } else { $BIN_DIR }
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        ok "$BIN_DIR agregado a tu PATH (User)"
        warn "Reinicia tu terminal para que el comando 'uvpln' funcione en cualquier directorio."
        $pathOk = $true
    } catch {
        warn "No se pudo agregar $BIN_DIR al PATH automaticamente."
        Write-Host "    Agregalo manualmente: System Properties -> Environment Variables -> Path" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "  Listo! uvpln instalado en modo aislado." -ForegroundColor Magenta
Write-Host ""
Write-Host "  Como usar:" -ForegroundColor White
Write-Host "    claude   -> Claude Code vanilla (sin uvpln, sin tocar)" -ForegroundColor Green
Write-Host "    uvpln    -> Claude Code con uvpln (23 agentes, hooks, statusline)" -ForegroundColor Magenta
Write-Host ""

if ($pathOk) {
    Write-Host "  Probalo en una terminal nueva:" -ForegroundColor White
    Write-Host "    uvpln" -ForegroundColor Magenta
    Write-Host ""
}

Write-Host "  Agentes incluidos:" -ForegroundColor White
foreach ($agent in $agents) {
    $name = $agent -replace "\.md", ""
    Write-Host "    -> $name" -ForegroundColor Green
}
Write-Host ""
Write-Host "  Verificacion rapida: powershell -ExecutionPolicy Bypass -File install.ps1 -Check" -ForegroundColor White
Write-Host "  Desinstalar:         powershell -ExecutionPolicy Bypass -File uninstall.ps1" -ForegroundColor White
Write-Host ""
