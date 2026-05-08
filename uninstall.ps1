# uvpln - desinstalador para Windows
# Ejecutar: powershell -ExecutionPolicy Bypass -File uninstall.ps1
# Borra uvpln de Claude Code. NO toca tus proyectos.

param(
    [switch]$ResetSettings,
    [switch]$PurgeMemory,
    [switch]$Yes,
    [switch]$Help
)

$UVPLN_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

$CLAUDE_DIR     = "$env:USERPROFILE\.claude"
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
    Write-Host "  Borra uvpln de Claude Code. NO toca tus proyectos ni codigo."
    Write-Host ""
    Write-Host "  Uso:"
    Write-Host "    powershell -ExecutionPolicy Bypass -File uninstall.ps1"
    Write-Host "    powershell -ExecutionPolicy Bypass -File uninstall.ps1 -Yes"
    Write-Host "    powershell -ExecutionPolicy Bypass -File uninstall.ps1 -ResetSettings"
    Write-Host "    powershell -ExecutionPolicy Bypass -File uninstall.ps1 -PurgeMemory"
    Write-Host ""
    exit 0
}

Write-Host ""
Write-Host "  uvpln - desinstalador" -ForegroundColor Magenta
Write-Host "  Borra uvpln de Claude Code. Tus proyectos siguen intactos." -ForegroundColor White
Write-Host ""

if (-not $Yes) {
    $resp = Read-Host "  Seguir? [y/N]"
    if ($resp -notmatch '^(y|Y|s|S|yes|si)$') {
        err "Cancelado"
    }
}

# 1. Agentes uvpln (lista fija)
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
    ok "Removido: agents\ (estaba vacio)"
}

# 2. Scripts Node
$scripts = @("session-start.js", "session-end.js", "statusline.cjs")
foreach ($script in $scripts) {
    $f = "$CLAUDE_DIR\$script"
    if (Test-Path $f) {
        Remove-Item $f -Force
        ok "Removido: $script"
    }
}

# 2b. Hooks de uvpln (lista fija)
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
    ok "Removido: hooks\ (estaba vacio)"
}

# 2c. Comandos slash de uvpln
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
    ok "Removido: commands\ (estaba vacio)"
}

# 2d. Plantillas de UI
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
    ok "Removido: templates\ (estaba vacio)"
}

# 2e. Examples de código
$exs = @("button-variants.md", "form-validation.md", "data-table.md", "modal-pattern.md", "theme-tokens.md", "api-fetch.md", "card-grid.md", "navigation.md", "toast-notifications.md")
foreach ($ex in $exs) {
    $f = "$EXAMPLES_DIR\$ex"
    if (Test-Path $f) {
        Remove-Item $f -Force
        ok "Removido: examples\$ex"
    }
}
if ((Test-Path $EXAMPLES_DIR) -and -not (Get-ChildItem $EXAMPLES_DIR -Force)) {
    Remove-Item $EXAMPLES_DIR -Force
    ok "Removido: examples\ (estaba vacio)"
}

# 3. CLAUDE.md: restaurar backup o borrar
$claudeMd = "$CLAUDE_DIR\CLAUDE.md"
$claudeBackup = "$CLAUDE_DIR\CLAUDE.md.backup"
if (Test-Path $claudeBackup) {
    Move-Item $claudeBackup $claudeMd -Force
    ok "CLAUDE.md.backup restaurado como CLAUDE.md"
} elseif (Test-Path $claudeMd) {
    Remove-Item $claudeMd -Force
    ok "CLAUDE.md removido"
}

# 4. settings.json: limpiar entradas de uvpln preservando config del usuario
$settings = "$CLAUDE_DIR\settings.json"
$unmergeScript = "$UVPLN_DIR\claude\install\unmerge-settings.js"
if (Test-Path $settings) {
    if ($ResetSettings) {
        Remove-Item $settings -Force
        ok "settings.json removido (-ResetSettings)"
    } elseif ((Get-Command node -ErrorAction SilentlyContinue) -and (Test-Path $unmergeScript)) {
        & node $unmergeScript $settings
        if ($LASTEXITCODE -eq 0) {
            ok "settings.json: entradas de uvpln removidas"
        } else {
            warn "No se pudo limpiar settings.json automaticamente"
            Write-Host "  Entradas a remover manualmente de ${settings}:" -ForegroundColor White
            Write-Host "    hooks.SessionStart, hooks.SessionEnd" -ForegroundColor Gray
            Write-Host "    hooks.PreToolUse  (matchers Agent y Write|Edit)" -ForegroundColor Gray
            Write-Host "    hooks.PostToolUse (matchers Agent y Write|Edit)" -ForegroundColor Gray
            Write-Host "    statusLine" -ForegroundColor Gray
        }
    } else {
        warn "Node.js no disponible - settings.json no pudo limpiarse automaticamente"
        Write-Host "  Entradas a remover manualmente de ${settings}:" -ForegroundColor White
        Write-Host "    hooks.SessionStart, hooks.SessionEnd" -ForegroundColor Gray
        Write-Host "    hooks.PreToolUse  (matchers Agent y Write|Edit)" -ForegroundColor Gray
        Write-Host "    hooks.PostToolUse (matchers Agent y Write|Edit)" -ForegroundColor Gray
        Write-Host "    statusLine" -ForegroundColor Gray
    }
}

# 5. Comando uvpln del PATH
$uvplnCmd = "$env:USERPROFILE\.local\bin\uvpln.cmd"
if (Test-Path $uvplnCmd) {
    Remove-Item $uvplnCmd -Force
    ok "Removido: uvpln.cmd ($uvplnCmd)"
}

# 6. memory/design-systems
$ds = "$CLAUDE_DIR\memory\design-systems"
if ((Test-Path $ds) -and (Get-ChildItem $ds -Force)) {
    if ($PurgeMemory) {
        Remove-Item $ds -Recurse -Force
        ok "memory\design-systems removido (-PurgeMemory)"
    } else {
        warn "memory\design-systems tiene tus tokens/decisiones por proyecto - NO se borra"
        Write-Host "  Para borrarla: Remove-Item -Recurse -Force $ds  (o usa -PurgeMemory)" -ForegroundColor White
    }
}

Write-Host ""
Write-Host "  uvpln desinstalado. Tus proyectos siguen intactos." -ForegroundColor Magenta
Write-Host ""
