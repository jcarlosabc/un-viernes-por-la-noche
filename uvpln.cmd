@echo off
if /i "%~1"=="uninstall" goto :uvpln_uninstall
set CLAUDE_CONFIG_DIR=%USERPROFILE%\.claude-uvpln
powershell -NoProfile -Command "Write-Host ''; Write-Host '  Un Viernes Por La Noche' -ForegroundColor Magenta; Write-Host '  Frontend AI Agent - Cartagena de Indias' -ForegroundColor Green; Write-Host ''"
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
echo.
echo   uvpln desinstalado.
echo.
