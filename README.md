@"
# AI English Tutor Telegram Bot

Local AI English tutor running in Telegram. Built with n8n + Ollama + PostgreSQL + Docker.

## Prerequisites
- Docker Desktop: https://www.docker.com/products/docker-desktop
- Ollama: https://ollama.com/download
- Ngrok: https://ngrok.com/download (authenticate with: ngrok config add-authtoken YOUR_TOKEN)
- Git: https://git-scm.com/download/win

## First Time Setup

### 1. Clone
``powershell
git clone https://github.com/huharun/ai-telegram-tutor.git
cd ai-telegram-tutor
``

### 2. Pull AI model
``powershell
ollama pull gemma3:4b
``

### 3. Create .env file
Copy .env.example to .env and fill in your Telegram bot token.
Get your bot token from @BotFather on Telegram.

### 4. Run
Double-click start.bat — it handles everything automatically:
- Starts PostgreSQL
- Starts Ngrok and gets URL
- Sets Telegram webhook
- Starts n8n
- Opens browser

### 5. First time in browser only
- Log in with any email/password
- Import n8n-workflows/english-tutor.json
- Set credentials (Telegram token, Ollama, Postgres)
- Click Publish

## Daily Use
Just double-click start.bat. That is it.

## Credentials for n8n
- Telegram: your bot token, base URL https://api.telegram.org
- Ollama: base URL http://host.docker.internal:11434, model gemma3:4b
- Postgres: host my-postgres, db postgres, user postgres, password 123456, port 5432, SSL off
"@ | Out-File "README.md" -Encoding UTF8