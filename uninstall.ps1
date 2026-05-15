# uvpln - desinstalador para Windows
# Ejecutar: powershell -ExecutionPolicy Bypass -File uninstall.ps1
#
# uvpln vive en %USERPROFILE%\.claude-uvpln\ (aislado).
# Vanilla Claude (%USERPROFILE%\.claude\) NUNCA se toca por este script.

param(
    [switch]$PurgeMemory,
    [switch]$Full,
    [switch]$Yes,
    [switch]$Help
)

$CLAUDE_DIR     = "$env:USERPROFILE\.claude-uvpln"
$BIN_DIR        = "$env:USERPROFILE\.local\bin"
$AGENTS_DIR     = "$CLAUDE_DIR\agents"
$HOOKS_DIR      = "$CLAUDE_DIR\hooks"
$COMMANDS_DIR   = "$CLAUDE_DIR\commands"
$TEMPLATES_DIR  = "$CLAUDE_DIR\templates"
$EXAMPLES_DIR   = "$CLAUDE_DIR\examples"

function ok   { param($msg); Write-Host "  [OK] $msg" -ForegroundColor Green }
function warn { param($msg); Write-Host "  [!]  $msg" -ForegroundColor Yellow }
function err  { param($msg); Write-Host "  [X]  $msg" -ForegroundColor Red; exit 1 }

if ($Help) {
    Write-Host ""
    Write-Host "  uvpln - desinstalador" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  Borra uvpln aislado (~\.claude-uvpln\) y el comando 'uvpln' del PATH."
    Write-Host "  Tu Claude vanilla (~\.claude\) NO se toca, jamas."
    Write-Host ""
    Write-Host "  Uso:"
    Write-Host "    powershell -ExecutionPolicy Bypass -File uninstall.ps1"
    Write-Host "    powershell -ExecutionPolicy Bypass -File uninstall.ps1 -Yes"
    Write-Host "    powershell -ExecutionPolicy Bypass -File uninstall.ps1 -PurgeMemory"
    Write-Host "    powershell -ExecutionPolicy Bypass -File uninstall.ps1 -Full"
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "  uvpln - desinstalador" -ForegroundColor Magenta
Write-Host "  Borra uvpln aislado. Tu Claude vanilla queda intacto." -ForegroundColor White
Write-Host ""

if (-not (Test-Path $CLAUDE_DIR)) {
    warn "$CLAUDE_DIR no existe - uvpln ya estaba desinstalado."
    # Igual borramos el binario si quedo suelto
    foreach ($b in @("$BIN_DIR\uvpln", "$BIN_DIR\uvpln.cmd")) {
        if (Test-Path $b) {
            Remove-Item $b -Force
            ok "Removido: $b"
        }
    }
    exit 0
}

if (-not $Yes) {
    Write-Host "  Se va a borrar: $CLAUDE_DIR"
    Write-Host "  Comando 'uvpln' del PATH: $BIN_DIR\uvpln.cmd"
    if ($Full) {
        warn "MODO -Full: incluye proyectos, sesiones, memoria. Irreversible."
    }
    $resp = Read-Host "  Seguir? [y/N]"
    if ($resp -notmatch '^(y|Y|s|S|yes|si)$') {
        err "Cancelado"
    }
}

# 1. Comando 'uvpln' del PATH
foreach ($b in @("$BIN_DIR\uvpln", "$BIN_DIR\uvpln.cmd")) {
    if (Test-Path $b) {
        Remove-Item $b -Force
        ok "Removido: $b"
    }
}

# 2. Modo -Full: nuke entero
if ($Full) {
    Remove-Item $CLAUDE_DIR -Recurse -Force
    ok "Removido: $CLAUDE_DIR (todo)"
    Write-Host ""
    Write-Host "  uvpln desinstalado por completo." -ForegroundColor Magenta
    Write-Host ""
    exit 0
}

# 3. Modo normal: borrar archivos uvpln, conservar memoria/proyectos

# Agentes uvpln (lista fija)
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
    $f = "$AGENTS_DIR\$agent"
    if (Test-Path $f) {
        Remove-Item $f -Force
        ok "Removido: agents\$agent"
    }
}
if ((Test-Path $AGENTS_DIR) -and -not (Get-ChildItem $AGENTS_DIR -Force)) {
    Remove-Item $AGENTS_DIR -Force
    ok "agents\ vacio removido"
}

# Scripts de sesion + statusline + config
$scripts = @("session-start.js", "session-end.js", "statusline.cjs", "agents-config.js")
foreach ($script in $scripts) {
    $f = "$CLAUDE_DIR\$script"
    if (Test-Path $f) {
        Remove-Item $f -Force
        ok "Removido: $script"
    }
}

# Hooks uvpln
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
    $f = "$HOOKS_DIR\$hook"
    if (Test-Path $f) {
        Remove-Item $f -Force
        ok "Removido: hooks\$hook"
    }
}
if ((Test-Path $HOOKS_DIR) -and -not (Get-ChildItem $HOOKS_DIR -Force)) {
    Remove-Item $HOOKS_DIR -Force
    ok "hooks\ vacio removido"
}

# Comandos slash
$cmds = @("uvpln-loop.md", "uvpln-audit.md", "uvpln-handoff.md")
foreach ($cmd in $cmds) {
    $f = "$COMMANDS_DIR\$cmd"
    if (Test-Path $f) {
        Remove-Item $f -Force
        ok "Removido: commands\$cmd"
    }
}
if ((Test-Path $COMMANDS_DIR) -and -not (Get-ChildItem $COMMANDS_DIR -Force)) {
    Remove-Item $COMMANDS_DIR -Force
    ok "commands\ vacio removido"
}

# Plantillas
$tpls = @("README.md", "landing-page.md", "dashboard.md", "auth.md", "ecommerce.md")
foreach ($tpl in $tpls) {
    $f = "$TEMPLATES_DIR\$tpl"
    if (Test-Path $f) {
        Remove-Item $f -Force
        ok "Removido: templates\$tpl"
    }
}
if ((Test-Path $TEMPLATES_DIR) -and -not (Get-ChildItem $TEMPLATES_DIR -Force)) {
    Remove-Item $TEMPLATES_DIR -Force
    ok "templates\ vacio removido"
}

# Examples
$exs = @(
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
foreach ($ex in $exs) {
    $f = "$EXAMPLES_DIR\$ex"
    if (Test-Path $f) {
        Remove-Item $f -Force
        ok "Removido: examples\$ex"
    }
}
if ((Test-Path $EXAMPLES_DIR) -and -not (Get-ChildItem $EXAMPLES_DIR -Force)) {
    Remove-Item $EXAMPLES_DIR -Force
    ok "examples\ vacio removido"
}

# CLAUDE.md (dentro de uvpln)
$claudeMd     = "$CLAUDE_DIR\CLAUDE.md"
$claudeBackup = "$CLAUDE_DIR\CLAUDE.md.backup"
if (Test-Path $claudeBackup) {
    Move-Item $claudeBackup $claudeMd -Force
    ok "CLAUDE.md.backup restaurado como CLAUDE.md (uvpln)"
} elseif (Test-Path $claudeMd) {
    Remove-Item $claudeMd -Force
    ok "CLAUDE.md removido"
}

# settings.json (dentro de uvpln - no afecta vanilla)
$settings = "$CLAUDE_DIR\settings.json"
if (Test-Path $settings) {
    Remove-Item $settings -Force
    ok "settings.json removido"
}

# Memoria de design systems (solo si la persona lo pide)
$ds = "$CLAUDE_DIR\memory\design-systems"
if ((Test-Path $ds) -and (Get-ChildItem $ds -Force)) {
    if ($PurgeMemory) {
        Remove-Item $ds -Recurse -Force
        ok "memory\design-systems removido (-PurgeMemory)"
    } else {
        warn "memory\design-systems tiene tus tokens/decisiones - NO se borra"
        Write-Host "  Para borrarla: Remove-Item -Recurse -Force $ds  (o usa -PurgeMemory)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "  uvpln desinstalado. Tu Claude Code vanilla sigue intacto." -ForegroundColor Magenta
Write-Host "  Si queres borrar TODO (proyectos, sesiones, memoria): -Full" -ForegroundColor White
Write-Host ""
