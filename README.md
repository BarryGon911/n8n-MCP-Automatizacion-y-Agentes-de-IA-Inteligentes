# n8n Automation & AI Agents Platform

A comprehensive automation platform built with n8n, featuring intelligent AI agents, messaging bots, RAG (Retrieval-Augmented Generation), and web scraping capabilities.

![n8n](https://img.shields.io/badge/n8n-Workflow%20Automation-orange)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)
![License](https://img.shields.io/badge/license-MIT-green)

## 🌟 Features

### 🤖 AI-Powered Chatbots
- **Telegram Bot**: Intelligent conversational bot with RAG support
- **WhatsApp Bot**: Business messaging with AI capabilities
- Multi-language support
- Conversation history and user profiling

### 🧠 AI Model Integration
- **OpenAI**: GPT-4, GPT-3.5-turbo for advanced language understanding
- **Google Gemini**: Google's latest AI model
- **Ollama**: Local AI models (Llama2, Mistral, CodeLlama)
- Flexible model switching and fallback options

### 📚 RAG (Retrieval-Augmented Generation)
- Vector database with pgvector
- Automatic embedding generation
- Context-aware AI responses
- Knowledge base management

### 🌐 Web Scraping & Data Processing
- Automated content extraction
- Scheduled scraping workflows
- Content indexing for RAG
- Cheerio-based HTML parsing

### 🎙️ Text-to-Speech
- ElevenLabs integration
- High-quality voice synthesis
- Multiple voice options
- Webhook-based API

### 🔄 Autonomous Agents
- Task queue system
- Multiple task types (scraping, analysis, notifications)
- Background job processing
- Status tracking and logging

### 💾 Data Management
- PostgreSQL database with vector support
- Conversation history storage
- User profiling and preferences
- Workflow execution logs

## 🚀 Quick Start

### Prerequisites

- Docker (version 20.10+)
- Docker Compose (version 2.0+)
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/BarryGon911/n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes.git
   cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes
   ```

2. **Run the setup script**
   ```bash
   ./scripts/setup.sh
   ```

3. **Configure environment variables**
   ```bash
   cp .env.example .env
   nano .env  # Edit with your credentials
   ```

4. **Start the services**
   ```bash
   docker-compose up -d
   ```

5. **Access n8n**
   
   Open your browser and navigate to: `http://localhost:5678`
   
   Default credentials:
   - Username: `admin`
   - Password: `admin` (change this in `.env`)

For detailed installation instructions, see [docs/INSTALLATION.md](docs/INSTALLATION.md).

## 📖 Documentation

- **[Installation Guide](docs/INSTALLATION.md)** - Complete setup instructions
- **[Usage Guide](docs/USAGE.md)** - How to use the workflows and features
- **[Workflows Documentation](workflows/README.md)** - Detailed workflow explanations

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         n8n Platform                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Telegram   │  │   WhatsApp   │  │  Web Scraper │      │
│  │     Bot      │  │     Bot      │  │              │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                 │                 │               │
│         └─────────────────┼─────────────────┘               │
│                           │                                 │
│  ┌────────────────────────┼────────────────────────┐       │
│  │         AI Agent Task Executor                   │       │
│  │  ┌─────────┐  ┌─────────┐  ┌──────────────┐   │       │
│  │  │ OpenAI  │  │ Gemini  │  │   Ollama     │   │       │
│  │  └─────────┘  └─────────┘  └──────────────┘   │       │
│  └──────────────────────┬───────────────────────────┘       │
│                         │                                   │
└─────────────────────────┼───────────────────────────────────┘
                          │
        ┌─────────────────┴─────────────────┐
        │      PostgreSQL Database          │
        │  ┌──────────┐  ┌──────────────┐  │
        │  │   RAG    │  │ Conversations │  │
        │  │ (Vector) │  │   & Users     │  │
        │  └──────────┘  └──────────────┘  │
        └───────────────────────────────────┘
```

## 🔧 Configuration

### Environment Variables

Key environment variables to configure in `.env`:

```env
# n8n
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_password

# Database
DB_POSTGRESDB_PASSWORD=your_db_password

# OpenAI
OPENAI_API_KEY=sk-your-key

# Gemini
GEMINI_API_KEY=your-gemini-key

# Telegram
TELEGRAM_BOT_TOKEN=your-bot-token

# WhatsApp
WHATSAPP_ACCESS_TOKEN=your-access-token

# ElevenLabs
ELEVENLABS_API_KEY=your-elevenlabs-key
```

For a complete list of configuration options, see [.env.example](.env.example).

## 📦 Included Workflows

| Workflow | Description | Key Features |
|----------|-------------|--------------|
| **Telegram AI Bot** | Intelligent Telegram chatbot | RAG, OpenAI/Ollama, conversation history |
| **WhatsApp AI Bot** | WhatsApp Business bot | Gemini AI, webhook-based, message logging |
| **Web Scraping & RAG** | Automated content extraction | Scheduled scraping, embedding generation, vector storage |
| **Text-to-Speech** | Convert text to audio | ElevenLabs, multiple voices, webhook API |
| **AI Agent Executor** | Autonomous task processing | Task queue, multiple task types, background processing |

See [workflows/README.md](workflows/README.md) for detailed workflow documentation.

## 🛠️ Development

### Project Structure

```
.
├── docker-compose.yml      # Docker services configuration
├── .env.example           # Environment variables template
├── database/
│   └── init.sql          # Database initialization script
├── workflows/            # n8n workflow JSON files
│   ├── telegram-ai-bot.json
│   ├── whatsapp-ai-bot.json
│   ├── web-scraping-rag.json
│   ├── elevenlabs-tts.json
│   ├── ai-agent-executor.json
│   └── README.md
├── scripts/              # Utility scripts
│   ├── setup.sh         # Initial setup script
│   └── backup.sh        # Database backup script
└── docs/                # Documentation
    ├── INSTALLATION.md
    └── USAGE.md
```

### Adding New Workflows

1. Create workflow in n8n UI
2. Export as JSON
3. Add to `workflows/` directory
4. Document in `workflows/README.md`
5. Update this README

### Database Backup

Run the backup script regularly:

```bash
./scripts/backup.sh
```

This creates timestamped backups in the `backups/` directory.

## 🔐 Security Best Practices

1. **Change default credentials** in `.env` file
2. **Never commit** `.env` file to version control
3. **Use HTTPS** in production environments
4. **Implement rate limiting** on webhooks
5. **Validate webhook signatures** for external services
6. **Keep API keys secure** and rotate them regularly
7. **Update Docker images** regularly for security patches

## 🚦 Monitoring & Maintenance

### Check Service Status

```bash
docker-compose ps
```

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs n8n
docker-compose logs postgres
docker-compose logs ollama
```

### Restart Services

```bash
docker-compose restart
```

### Database Access

```bash
docker-compose exec postgres psql -U n8n -d n8n
```

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add documentation
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [n8n](https://n8n.io/) - Workflow automation platform
- [OpenAI](https://openai.com/) - GPT models
- [Google](https://ai.google.dev/) - Gemini AI
- [Ollama](https://ollama.ai/) - Local AI models
- [ElevenLabs](https://elevenlabs.io/) - Text-to-speech
- [PostgreSQL](https://www.postgresql.org/) - Database
- [pgvector](https://github.com/pgvector/pgvector) - Vector similarity search

## 📞 Support

For issues, questions, or suggestions:

- Open an [issue](https://github.com/BarryGon911/n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes/issues)
- Check the [documentation](docs/)
- Visit the [n8n community](https://community.n8n.io/)

## 🗺️ Roadmap

- [ ] Add support for more AI models (Anthropic Claude, Cohere)
- [ ] Implement advanced RAG techniques (hybrid search, re-ranking)
- [ ] Add Discord bot integration
- [ ] Create web interface for workflow management
- [ ] Add support for more languages
- [ ] Implement conversation analytics dashboard
- [ ] Add voice message support for bots
- [ ] Create mobile app integration examples

## 🌍 Use Cases

- **Customer Support**: Automated response systems for businesses
- **Knowledge Management**: Build searchable knowledge bases with RAG
- **Content Automation**: Automated content creation and distribution
- **Personal Assistant**: AI-powered personal productivity tools
- **Educational Bots**: Interactive learning assistants
- **Business Intelligence**: Automated data collection and analysis
- **Notification Systems**: Smart alert and notification delivery

---

**Built with ❤️ using n8n and AI**
