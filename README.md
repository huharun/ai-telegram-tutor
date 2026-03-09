# 🤖 AI English Tutor Telegram Bot

A fully **local**, **private** AI English tutor that lives in your Telegram. It corrects your grammar, explains mistakes, and remembers your conversation history — all running on your own machine for free.

> Built with: n8n · Ollama (gemma3:4b) · PostgreSQL · Docker · Ngrok · Telegram

---

## 📸 How It Works

You send a message → Bot corrects your English → Asks a follow-up question → Remembers everything.

```
You:  "i goed to store yesterday and buyed some apple"
Bot:  Great effort! A couple of corrections:
      ✏️ "goed" → "went" (irregular past tense)
      ✏️ "buyed" → "bought" (irregular past tense)
      ✏️ "some apple" → "some apples" (plural)
      What did you buy at the store? 🛒
```

---

## ✅ Prerequisites

Install all of these before starting:

| Tool | Link | Why |
|------|------|-----|
| Docker Desktop | https://www.docker.com/products/docker-desktop | Runs PostgreSQL and n8n |
| Ollama | https://ollama.com/download | Runs the AI model locally |
| Ngrok | https://ngrok.com/download | Connects Telegram to your machine |
| Git | https://git-scm.com/download/win | Clone this repo |

---

## 🚀 First Time Setup

### Step 1 — Clone this repo

Open PowerShell and run:

```powershell
git clone https://github.com/huharun/ai-telegram-tutor.git
cd ai-telegram-tutor
```

---

### Step 2 — Pull the AI model

```powershell
ollama pull gemma3:4b
```

This downloads ~3GB. Wait for it to finish.

---

### Step 3 — Set up Ngrok

1. Create a free account at https://ngrok.com
2. Go to https://dashboard.ngrok.com/authtokens
3. Copy your authtoken
4. Run this (replace with your actual token):

```powershell
ngrok config add-authtoken YOUR_NGROK_TOKEN_HERE
```

---

### Step 4 — Create your Telegram Bot

1. Open Telegram → search **@BotFather** (must have blue ✓ checkmark)
2. Send: `/newbot`
3. Enter a name: `My English Tutor`
4. Enter a username ending in `bot`: e.g. `MyEnglishTutor_bot`
5. BotFather will give you a token that looks like:
   ```
   1234567890:AAFabcdefGHIjklmnoPQRsTUvwxyz
   ```
   **Save this token — you need it in the next step.**

---

### Step 5 — Create your .env file

In your project folder, copy the example file:

```powershell
copy .env.example .env
notepad .env
```

The file looks like this — just replace the token:

```
TELEGRAM_BOT_TOKEN=paste_your_token_here
POSTGRES_PASSWORD=123456
OLLAMA_MODEL=gemma3:4b
```

Save and close Notepad.

---

### Step 6 — Start everything

```powershell
.\start.bat
```

This single script automatically:
- Creates Docker network
- Starts PostgreSQL
- Starts Ngrok and gets the public URL
- Sets Telegram webhook
- Starts n8n
- Opens your browser

Wait ~20 seconds for everything to load.

---

### Step 7 — Set up n8n (first time only)

When the browser opens:

1. Create a local account (any email/password — this is local only)
2. Click **"+"** → top right **⋮ menu** → **"Import from file"**
3. Select `n8n-workflows/english-tutor.json`
4. Set up 3 credentials by clicking each node:

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

5. Click **Save** → Click **Publish**

---

### Step 8 — Test it!

Go to Telegram, find your bot, send:

```
i goed to store yesterday and buyed some apple
```

Your bot should reply with corrections within 10–30 seconds. 🎉

---

## ▶️ Daily Use (After First Setup)

Just run:

```powershell
.\start.bat
```

That's it. Everything starts automatically. No terminals to manage.

> ⚠️ Ngrok gives a new URL every time on the free plan. The script handles this automatically.

---

## 📁 Project Structure

```
ai-telegram-tutor/
├── start.bat                  ← Run this every time
├── .env                       ← Your secrets (gitignored, not on GitHub)
├── .env.example               ← Template showing what goes in .env
├── n8n-workflows/
│   └── english-tutor.json     ← Import this into n8n on first run
├── n8n-data/                  ← Auto-created, stores n8n data (gitignored)
└── README.md                  ← This file
```

---

## 🔒 Privacy & Security

- `.env` is **gitignored** — your Telegram token never goes to GitHub
- Everything runs **100% locally** on your machine
- No data sent to OpenAI or any cloud service

---

## 🔧 Troubleshooting

**Bot not responding?**
- Make sure workflow is **Published** (green) in n8n
- Re-run `start.bat`

**n8n can't connect to Postgres?**
- Host must be exactly `my-postgres` not `localhost`

**n8n can't connect to Ollama?**
- Run `ollama serve` in a new terminal
- Base URL must be `http://host.docker.internal:11434`

**Port already in use?**
- Run `docker ps` then `docker stop CONTAINER_ID`

---

## 🧩 Tech Stack

| Layer | Tool | Purpose |
|-------|------|---------|
| Chat interface | Telegram | Where you chat |
| Workflow engine | n8n | Connects everything |
| AI brain | Ollama + gemma3:4b | Corrects your English |
| Memory | PostgreSQL | Stores conversation history |
| Infrastructure | Docker | Runs containers |
| Tunnel | Ngrok | Lets Telegram reach your machine |

---

## 📝 License

MIT — free to use, modify, and share.