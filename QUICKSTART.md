# Quick Start Guide

Get up and running with n8n Automation & AI Agents in 10 minutes!

## 🚀 Prerequisites

Before you begin, ensure you have:
- [Docker](https://docs.docker.com/get-docker/) installed
- [Docker Compose](https://docs.docker.com/compose/install/) installed
- At least 4GB of available RAM
- 10GB of free disk space

## ⚡ 5-Minute Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/BarryGon911/n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes.git
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes
```

### Step 2: Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit with your preferred editor
nano .env
```

**Minimum required changes:**
```env
N8N_BASIC_AUTH_USER=yourusername
N8N_BASIC_AUTH_PASSWORD=yourpassword
DB_POSTGRESDB_PASSWORD=securepassword
```

### Step 3: Start Services

```bash
docker-compose up -d
```

Wait about 30 seconds for services to initialize.

### Step 4: Access n8n

Open your browser and go to:
```
http://localhost:5678
```

Login with the credentials you set in Step 2.

**🎉 Congratulations! You're now running n8n with AI capabilities!**

---

## 🤖 Try Your First Bot (Telegram)

### 1. Create a Telegram Bot

1. Open Telegram and message [@BotFather](https://t.me/botfather)
2. Send `/newbot`
3. Follow prompts to name your bot
4. Copy the bot token (looks like `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

### 2. Add Bot Token

Edit your `.env` file:
```env
TELEGRAM_BOT_TOKEN=your-token-here
```

Restart n8n:
```bash
docker-compose restart n8n
```

### 3. Get an OpenAI API Key

1. Sign up at [OpenAI](https://platform.openai.com/)
2. Generate an API key
3. Add to `.env`:
   ```env
   OPENAI_API_KEY=sk-your-key-here
   ```
4. Restart: `docker-compose restart n8n`

### 4. Import the Telegram Workflow

1. In n8n, click **Workflows** → **Import from File**
2. Select `workflows/telegram-ai-bot.json`
3. Click **Import**

### 5. Configure Credentials

**PostgreSQL:**
1. Go to **Settings** → **Credentials** → **New**
2. Select **PostgreSQL**
3. Fill in:
   - Host: `postgres`
   - Database: `n8n`
   - User: `n8n`
   - Password: (from your `.env`)
   - Port: `5432`
4. Click **Save**

**OpenAI:**
1. **Settings** → **Credentials** → **New**
2. Select **OpenAI**
3. Enter your API key
4. Click **Save**

**Telegram:**
1. **Settings** → **Credentials** → **New**
2. Select **Telegram**
3. Enter your bot token
4. Click **Save**

### 6. Activate the Workflow

1. Open the "Telegram AI Bot" workflow
2. Connect credentials to each node
3. Click the **Active** toggle switch
4. Test by messaging your bot on Telegram!

---

## 🌐 Optional: Local AI with Ollama

Want to use AI without API costs? Set up Ollama:

### 1. Pull a Model

```bash
docker exec -it $(docker-compose ps -q ollama) ollama pull llama2
```

This downloads the Llama2 model (~4GB).

### 2. Update Workflow

In your Telegram workflow:
1. Disable the OpenAI node
2. Enable the Ollama HTTP Request node
3. Save and test

Now your bot uses local AI - no API costs!

---

## 📚 Add Knowledge to Your Bot (RAG)

### 1. Add Sample Documents

Connect to the database:
```bash
docker-compose exec postgres psql -U n8n -d rag_database
```

Insert knowledge:
```sql
INSERT INTO documents (content, metadata) VALUES 
  ('n8n is a workflow automation tool that connects different services.', 
   '{"source": "documentation", "category": "general"}'),
  ('To create a webhook in n8n, use the Webhook node and activate the workflow.', 
   '{"source": "documentation", "category": "tutorial"}');
```

Exit with `\q`

### 2. Test RAG

Message your Telegram bot:
```
What is n8n?
```

The bot will use your knowledge base to answer!

---

## 🎯 Next Steps

### Explore More Features

1. **WhatsApp Bot**: Set up business messaging
   - See [docs/INSTALLATION.md](docs/INSTALLATION.md#whatsapp-setup)

2. **Web Scraping**: Automatically gather content
   - Import `workflows/web-scraping-rag.json`
   - Add URLs to scrape

3. **Text-to-Speech**: Generate audio
   - Get ElevenLabs API key
   - Import `workflows/elevenlabs-tts.json`

4. **Autonomous Agents**: Background task processing
   - Import `workflows/ai-agent-executor.json`

### Learn More

- **[Full Installation Guide](docs/INSTALLATION.md)** - Detailed setup
- **[Usage Guide](docs/USAGE.md)** - How to use all features
- **[FAQ](docs/FAQ.md)** - Common questions
- **[Workflows](workflows/README.md)** - Workflow documentation

### Get API Keys

You'll need these for full functionality:

| Service | What it's for | Get it here |
|---------|---------------|-------------|
| OpenAI | AI responses | [platform.openai.com](https://platform.openai.com/) |
| Gemini | Alternative AI | [makersuite.google.com](https://makersuite.google.com/) |
| ElevenLabs | Text-to-speech | [elevenlabs.io](https://elevenlabs.io/) |
| Telegram | Telegram bot | [@BotFather](https://t.me/botfather) |
| WhatsApp | WhatsApp bot | [business.facebook.com](https://business.facebook.com/) |

---

## 🔧 Troubleshooting

### Services Won't Start

```bash
# Check what's wrong
docker-compose logs

# Restart everything
docker-compose down
docker-compose up -d
```

### Can't Access n8n

- Check if it's running: `docker-compose ps`
- Try `http://127.0.0.1:5678` instead
- Check firewall settings

### Bot Not Responding

1. Is the workflow active? (toggle should be ON)
2. Are credentials configured?
3. Check execution logs in n8n
4. Verify bot token is correct

### Need Help?

- Check [FAQ](docs/FAQ.md)
- Review [troubleshooting section](docs/INSTALLATION.md#troubleshooting)
- Open an issue on GitHub

---

## 📊 Resource Usage

Typical resource consumption:

| Service | RAM | CPU | Disk |
|---------|-----|-----|------|
| n8n | 200MB | 5% | 500MB |
| PostgreSQL | 100MB | 2% | 1GB+ |
| Ollama (with model) | 2GB+ | 10%+ | 4GB+ |

**Tip**: If not using Ollama, you can remove it from `docker-compose.yml` to save resources.

---

## 🎓 Learn by Example

### Example 1: Customer Support Bot

1. Import Telegram workflow
2. Add company FAQs to RAG database
3. Train with common questions
4. Activate and test

### Example 2: Content Aggregator

1. Import web scraping workflow
2. Add news website URLs to `scraped_data` table
3. Schedule runs every 6 hours
4. View aggregated content in RAG database

### Example 3: Personal AI Assistant

1. Import Telegram workflow
2. Add personal notes and documents to RAG
3. Use local Ollama for privacy
4. Ask questions about your notes

---

## 💡 Pro Tips

1. **Start Small**: Begin with one workflow, then expand
2. **Use Local AI**: Ollama is free and private
3. **Backup Regularly**: Run `./scripts/backup.sh` weekly
4. **Monitor Costs**: Track API usage in provider dashboards
5. **Secure It**: Change default passwords immediately
6. **Read Logs**: Check `docker-compose logs` when debugging

---

**Ready to build something amazing? Let's go! 🚀**

For detailed documentation, see [docs/](docs/) directory.
