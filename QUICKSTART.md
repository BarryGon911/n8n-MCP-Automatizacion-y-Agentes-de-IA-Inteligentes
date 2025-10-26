# Quick Start Guide

Get up and running with n8n-MCP Automation in minutes!

## ⚡ Quick Start (Docker)

### 1. Prerequisites
- Docker and Docker Compose installed
- At least one API key (OpenAI, Gemini, or none for Ollama)

### 2. Setup

```bash
# Clone the repository
git clone https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes.git
cd n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes

# Create environment file
cp .env.example .env

# Edit .env with your API keys (optional)
nano .env
```

### 3. Start Services

```bash
# Start all services
docker-compose up -d

# Check logs
docker-compose logs -f
```

### 4. Access Services

- **n8n**: http://localhost:5678
  - Username: admin
  - Password: changeme (change in .env)
  
- **MCP Server**: http://localhost:3000
  - Health check: http://localhost:3000/health

- **PostgreSQL**: localhost:5432
  - Database: n8n
  - User: n8n_user

### 5. Test the Installation

```bash
# Test MCP Server
curl http://localhost:3000/health

# Test AI Agent
curl -X POST http://localhost:3000/agents/execute \
  -H "Content-Type: application/json" \
  -d '{
    "agentType": "conversational",
    "task": "Say hello!",
    "context": {}
  }'
```

## 🎯 Your First Workflow

### Option 1: Use Pre-built Workflows

1. Open n8n at http://localhost:5678
2. Click "Import from File"
3. Import `workflows/whatsapp-ai-bot.json`
4. Activate the workflow

### Option 2: Create Your Own

1. Open n8n
2. Create new workflow
3. Add "HTTP Request" node
4. Configure:
   - Method: POST
   - URL: http://mcp-server:3000/agents/execute
   - Body:
   ```json
   {
     "agentType": "conversational",
     "task": "Your question here"
   }
   ```
5. Execute and see the AI response!

## 🤖 Using AI Agents

### Conversational Agent
```bash
curl -X POST http://localhost:3000/agents/execute \
  -H "Content-Type: application/json" \
  -d '{
    "agentType": "conversational",
    "task": "Explain quantum computing in simple terms"
  }'
```

### RAG Agent (with Knowledge Base)
```bash
# First, add documents (see full documentation)
# Then query:
curl -X POST http://localhost:3000/mcp/tools/execute \
  -H "Content-Type: application/json" \
  -d '{
    "name": "search_knowledge_base",
    "parameters": {
      "query": "What is AI?",
      "limit": 3
    }
  }'
```

### Web Scraper Agent
```bash
curl -X POST http://localhost:3000/agents/execute \
  -H "Content-Type: application/json" \
  -d '{
    "agentType": "web-scraper",
    "task": "Summarize the main content",
    "context": {
      "url": "https://news.ycombinator.com"
    }
  }'
```

## 📱 Setting Up Messaging

### WhatsApp

1. Check MCP server logs for QR code:
```bash
docker-compose logs mcp-server | grep -A 10 "WhatsApp QR"
```

2. Scan the QR code with WhatsApp
3. Wait for "WhatsApp client is ready!" message

### Telegram

1. Create a bot with [@BotFather](https://t.me/botfather)
2. Get your bot token
3. Add token to `.env`:
```env
TELEGRAM_BOT_TOKEN=your_token_here
```
4. Restart services:
```bash
docker-compose restart mcp-server
```

## 🎨 Customization

### Add Your Own API Keys

Edit `.env`:
```env
OPENAI_API_KEY=sk-your-key-here
GEMINI_API_KEY=your-key-here
ELEVENLABS_API_KEY=your-key-here
```

Restart:
```bash
docker-compose restart
```

### Use Different AI Models

The system automatically selects the best available model:
1. OpenAI (if API key provided)
2. Gemini (if API key provided)
3. Ollama (always available, runs locally)

Specify explicitly:
```json
{
  "agentType": "gemini",  // or "openai" or "ollama"
  "task": "Your task"
}
```

## 🔍 Troubleshooting

### Services won't start
```bash
# Check logs
docker-compose logs

# Restart
docker-compose down
docker-compose up -d
```

### Can't access n8n
- Check if port 5678 is available
- Try: http://127.0.0.1:5678
- Check firewall settings

### Database errors
```bash
# Recreate database
docker-compose down -v
docker-compose up -d
```

### WhatsApp QR not showing
```bash
# Check logs
docker-compose logs mcp-server -f

# Restart MCP server
docker-compose restart mcp-server
```

## 📚 Next Steps

1. **Read the Documentation**
   - [Full README](README.md)
   - [API Documentation](docs/API.md)
   - [Examples](docs/EXAMPLES.md)

2. **Import Sample Workflows**
   - WhatsApp AI Bot
   - RAG Knowledge Base
   - Web Scraping Analysis

3. **Build Your First Agent**
   - Create custom workflows
   - Integrate with your tools
   - Deploy to production

4. **Join the Community**
   - Report issues
   - Share your workflows
   - Contribute improvements

## 🆘 Getting Help

- Check [docs/](docs/) for detailed guides
- Review [EXAMPLES.md](docs/EXAMPLES.md) for code samples
- Open an issue on GitHub
- Read [CONTRIBUTING.md](CONTRIBUTING.md) to contribute

## 🚀 Production Deployment

For production deployment, see [DEPLOYMENT.md](docs/DEPLOYMENT.md).

**Important**: Change default passwords before deploying to production!

---

Happy Automating! 🎉
