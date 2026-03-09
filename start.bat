@'
@echo off
setlocal enabledelayedexpansion
title AI English Tutor Bot

for /f "usebackq tokens=1,* delims==" %%a in ("%~dp0.env") do (
    if not "%%a"=="" if not "%%b"=="" (
        set "%%a=%%b"
    )
)

echo [1/5] Setting up Docker network...
docker network create n8n-network >nul 2>&1

echo [2/5] Starting PostgreSQL...
docker start my-postgres >nul 2>&1
if errorlevel 1 (
    docker run --name my-postgres --network n8n-network -e POSTGRES_PASSWORD=%POSTGRES_PASSWORD% -e POSTGRES_DB=postgres -p 5432:5432 -d postgres >nul 2>&1
)
timeout /t 3 >nul

echo [3/5] Starting Ngrok...
taskkill /f /im ngrok.exe >nul 2>&1
start /min "" ngrok http 5678
timeout /t 8 >nul

echo [4/5] Getting URL and setting webhook...
for /f "delims=" %%u in ('powershell -Command "(Invoke-RestMethod http://127.0.0.1:4040/api/tunnels).tunnels | Where-Object{$_.proto -eq 'https'} | Select-Object -First 1 -ExpandProperty public_url"') do set NGROK_URL=%%u
powershell -Command "Invoke-RestMethod 'https://api.telegram.org/bot%TELEGRAM_BOT_TOKEN%/setWebhook?url=%NGROK_URL%/webhook/telegram-trigger'" >nul 2>&1
echo  URL: %NGROK_URL%

echo [5/5] Starting n8n...
if not exist "%~dp0n8n-data" mkdir "%~dp0n8n-data"
start /min "" docker run --network n8n-network --rm -p 5678:5678 -v "%~dp0n8n-data:/home/node/.n8n" -e WEBHOOK_URL=%NGROK_URL% -e N8N_BASIC_AUTH_ACTIVE=false -e N8N_DIAGNOSTICS_ENABLED=false n8nio/n8n
timeout /t 20 >nul

echo.
echo  ================================
echo   OPEN IN BROWSER: %NGROK_URL%
echo  ================================
start "" "%NGROK_URL%"
pause
endlocal
'@ | Out-File "start.bat" -Encoding ASCII