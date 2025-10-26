# n8n MCP Automation - AI Intelligent Agents

A comprehensive automation platform built with n8n, integrating Model Context Protocol (MCP), AI agents, and various communication channels including WhatsApp, Telegram, and more.

## 🚀 Features

- **MCP Server Integration**: Full Model Context Protocol implementation for AI agent coordination
- **Multi-Platform Messaging**: 
  - WhatsApp integration using whatsapp-web.js
  - Telegram bot support
- **AI Agents**:
  - OpenAI GPT-4 integration
  - Google Gemini support
  - Local Ollama models
  - Conversational agents
  - RAG (Retrieval-Augmented Generation) agents
  - Web scraping agents
- **RAG System**: Vector-based knowledge base using PostgreSQL with pgvector
- **Text-to-Speech**: ElevenLabs integration
- **Web Scraping**: Intelligent content extraction with Puppeteer and Cheerio
- **Database**: PostgreSQL with comprehensive schema for conversations, documents, and workflows
- **Docker Support**: Complete containerized deployment with Docker Compose

## 📋 Prerequisites

- Node.js 18 or higher
- Docker and Docker Compose (for containerized deployment)
- PostgreSQL 15 (if running without Docker)
- API Keys for:
  - OpenAI (optional)
  - Google Gemini (optional)
  - Anthropic Claude (optional)
  - ElevenLabs (optional)
  - Telegram Bot Token (optional)

## 🛠️ Installation

### Option 1: Docker Deployment (Recommended)

1. Clone the repository:
```bash
git clone <repository-url>
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes
```

2. Copy environment configuration:
```bash
cp .env.example .env
```

3. Edit `.env` file with your API keys and configuration

4. Start all services:
```bash
docker-compose up -d
```

5. Access the services:
   - n8n: http://localhost:5678
   - MCP Server: http://localhost:3000
   - PostgreSQL: localhost:5432

### Option 2: Local Development

1. Clone and setup:
```bash
git clone <repository-url>
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes
cp .env.example .env
```

2. Install dependencies:
```bash
npm install
```

3. Setup PostgreSQL database:
```bash
# Create database and run migrations
psql -U postgres -c "CREATE DATABASE n8n;"
psql -U n8n_user -d n8n -f src/database/init.sql
```

4. Build TypeScript:
```bash
npm run build
```

5. Start services:
```bash
# Terminal 1: Start n8n
npm start

# Terminal 2: Start MCP Server
npm run mcp-server
```

## 🔧 Configuration

### Environment Variables

Edit `.env` file with your configuration:

```env
# n8n Configuration
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=your_secure_password

# Database
DB_POSTGRESDB_HOST=localhost
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_PASSWORD=your_db_password

# AI Services
OPENAI_API_KEY=sk-...
GEMINI_API_KEY=...
ANTHROPIC_API_KEY=...

# Messaging
TELEGRAM_BOT_TOKEN=...

# Other Services
ELEVENLABS_API_KEY=...
```

## 📚 Usage

### MCP Server API

The MCP server provides RESTful endpoints and WebSocket support:

#### Tools Execution
```bash
curl -X POST http://localhost:3000/mcp/tools/execute \
  -H "Content-Type: application/json" \
  -d '{
    "name": "send_whatsapp_message",
    "parameters": {
      "recipient": "+1234567890",
      "message": "Hello from MCP!"
    }
  }'
```

#### AI Agent Execution
```bash
curl -X POST http://localhost:3000/agents/execute \
  -H "Content-Type: application/json" \
  -d '{
    "agentType": "conversational",
    "task": "Explain quantum computing",
    "context": {}
  }'
```

#### Knowledge Base Search
```bash
curl -X POST http://localhost:3000/mcp/tools/execute \
  -H "Content-Type: application/json" \
  -d '{
    "name": "search_knowledge_base",
    "parameters": {
      "query": "What is AI?",
      "limit": 5
    }
  }'
```

### n8n Workflows

Pre-built workflows are available in the `workflows/` directory:

1. **WhatsApp AI Bot** (`whatsapp-ai-bot.json`): Automated WhatsApp responses using AI
2. **RAG Knowledge Base** (`rag-knowledge-base.json`): Query knowledge base with AI
3. **Web Scraping Analysis** (`web-scraping-analysis.json`): Scrape and analyze web content

Import these workflows into n8n via the UI.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────┐
│                   n8n Platform                   │
│  (Workflow Orchestration & Automation)          │
└─────────────────┬───────────────────────────────┘
                  │
                  ↓
┌─────────────────────────────────────────────────┐
│              MCP Server (Port 3000)              │
│  - Tool Execution                                │
│  - Resource Management                           │
│  - Agent Orchestration                           │
└─────────┬───────────────────────────────────────┘
          │
          ↓
┌─────────────────────────────────────────────────┐
│              Agent Layer                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │ OpenAI   │  │ Gemini   │  │ Ollama   │      │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────┬───────────────────────────────────────┘
          │
          ↓
┌─────────────────────────────────────────────────┐
│           Integration Layer                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐      │
│  │WhatsApp  │  │Telegram  │  │ElevenLabs│      │
│  └──────────┘  └──────────┘  └──────────┘      │
└─────────┬───────────────────────────────────────┘
          │
          ↓
┌─────────────────────────────────────────────────┐
│         Data Layer (PostgreSQL + pgvector)       │
│  - Conversations                                 │
│  - Knowledge Base (RAG)                          │
│  - Agent Executions                              │
│  - Workflows                                     │
└─────────────────────────────────────────────────┘
```

## 🤖 Available MCP Tools

1. **send_whatsapp_message**: Send WhatsApp messages
2. **send_telegram_message**: Send Telegram messages
3. **query_database**: Execute SQL queries
4. **search_knowledge_base**: Semantic search in knowledge base
5. **scrape_website**: Extract content from websites
6. **generate_ai_response**: Generate AI responses
7. **text_to_speech**: Convert text to speech

## 📦 Project Structure

```
.
├── src/
│   ├── agents/              # AI agent implementations
│   ├── database/            # Database service and schema
│   ├── integrations/        # External service integrations
│   │   ├── whatsapp/
│   │   ├── telegram/
│   │   └── elevenlabs/
│   ├── mcp-server/          # MCP server implementation
│   ├── rag/                 # RAG service
│   └── utils/               # Utility functions
├── workflows/               # n8n workflow templates
├── docker-compose.yml       # Docker orchestration
├── package.json            # Dependencies
└── README.md               # This file
```

## 🧪 Testing

Run tests:
```bash
npm test
```

## 🐛 Troubleshooting

### WhatsApp QR Code Not Appearing
- Check console logs for QR code
- Ensure puppeteer is properly installed
- Try running with `--no-sandbox` flag

### Database Connection Issues
- Verify PostgreSQL is running
- Check connection credentials in `.env`
- Ensure pgvector extension is installed

### MCP Server Not Starting
- Check port 3000 is available
- Verify all environment variables are set
- Check logs for specific errors

## 📝 License

MIT License - See LICENSE file for details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Support

For issues and questions, please open an issue on GitHub.
