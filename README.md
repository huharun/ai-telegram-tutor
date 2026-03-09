# AI English Tutor Telegram Bot

A fully **local**, **private** AI English tutor that lives in your Telegram. It corrects your grammar, explains mistakes, and remembers your conversation history - all running on your own machine for free.

> Built with: n8n · Ollama (gemma3:4b) · PostgreSQL · Docker · Ngrok · Telegram

---

## How It Works

![n8n Workflow](json%20workflow.png)

![Telegram Output](telegram%20output.png)

You send a message, the bot corrects your English, asks a follow-up question, and remembers everything.

---

## Prerequisites

Install all of these before starting:

| Tool | Link | Why |
|------|------|-----|
| Docker Desktop | https://www.docker.com/products/docker-desktop | Runs PostgreSQL and n8n |
| Ollama | https://ollama.com/download | Runs the AI model locally |
| Ngrok | https://ngrok.com/download | Connects Telegram to your machine |
| Git | https://git-scm.com/download/win | Clone this repo |

---

## First Time Setup

### Step 1 - Clone this repo

```powershell
git clone https://github.com/huharun/ai-telegram-tutor.git
cd ai-telegram-tutor
```

### Step 2 - Pull the AI model

```powershell
ollama pull gemma3:4b
```

Downloads ~3GB. Wait for it to finish.

### Step 3 - Set up Ngrok

1. Create a free account at https://ngrok.com
2. Go to https://dashboard.ngrok.com/authtokens and copy your token
3. Run:

```powershell
ngrok config add-authtoken YOUR_NGROK_TOKEN_HERE
```

### Step 4 - Create your Telegram Bot

1. Open Telegram and search **@BotFather** (blue checkmark)
2. Send `/newbot`
3. Follow the steps and save the token it gives you

### Step 5 - Create your .env file

```powershell
copy .env.example .env
notepad .env
```

Replace `your_telegram_bot_token_here` with your actual token. Save and close.

### Step 6 - Start everything

```powershell
.\start.bat
```

This single script automatically starts PostgreSQL, Ngrok, sets the Telegram webhook, starts n8n, and opens your browser. Wait 20 seconds.

### Step 7 - Set up n8n (first time only)

1. Log in with any email/password (local only)
2. Click top right menu -> **Import from file**
3. Select `n8n-workflows/english-tutor.json`
4. Set up 3 credentials:

**Telegram Trigger node:**
| Field | Value |
|-------|-------|
| Access Token | Your BotFather token |
| Base URL | `https://api.telegram.org` |

**Ollama Chat Model node:**
| Field | Value |
|-------|-------|
| Base URL | `http://host.docker.internal:11434` |
| Model | `gemma3:4b` |

**Postgres Chat Memory node:**
| Field | Value |
|-------|-------|
| Host | `my-postgres` |
| Database | `postgres` |
| User | `postgres` |
| Password | `123456` |
| Port | `5432` |
| SSL | Off |

5. Click **Save** then **Publish**

### Step 8 - Test it

Send this to your bot in Telegram:

```
i goed to store yesterday and buyed some apple
```

Your bot should reply with corrections within 10-30 seconds.

---

## Daily Use

Just double-click `start.bat`. That is it.

> Ngrok gives a new URL every time on the free plan. The script handles this automatically.

---

## Project Structure

```
ai-telegram-tutor/
├── start.bat                  <- Run this every time
├── .env                       <- Your secrets (gitignored)
├── .env.example               <- Template for .env
├── n8n-workflows/
│   └── english-tutor.json     <- Import into n8n on first run
├── n8n-data/                  <- Auto-created, gitignored
└── README.md
```

---

## Privacy

- `.env` is gitignored - your token never goes to GitHub
- Everything runs 100% locally on your machine
- No data sent to any cloud service

---

## Troubleshooting

**Bot not responding?**
- Make sure workflow is Published (green) in n8n
- Re-run `start.bat`

**n8n cant connect to Postgres?**
- Host must be exactly `my-postgres` not `localhost`

**n8n cant connect to Ollama?**
- Run `ollama serve` in a new terminal
- Base URL must be `http://host.docker.internal:11434`

**Port already in use?**
- Run `docker ps` then `docker stop CONTAINER_ID`

---

## Tech Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Chat interface | Telegram | Where you chat |
| Workflow engine | n8n | Connects everything |
| AI brain | Ollama + gemma3:4b | Corrects your English |
| Memory | PostgreSQL | Stores conversation history |
| Infrastructure | Docker | Runs containers |
| Tunnel | Ngrok | Lets Telegram reach your machine |

---

MIT License - free to use, modify, and share.