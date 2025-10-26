# Project Overview

## What is n8n-MCP-Automation?

This is a comprehensive automation platform that combines:
- **n8n**: Workflow automation platform
- **MCP (Model Context Protocol)**: Standard for AI agent communication
- **AI Agents**: Multiple AI model integrations (OpenAI, Gemini, Ollama)
- **Messaging Platforms**: WhatsApp, Telegram integration
- **RAG System**: Knowledge base with semantic search
- **Database**: PostgreSQL with vector support

## Architecture Overview

```
┌──────────────────────────────────────────┐
│         User Interfaces                  │
│  WhatsApp │ Telegram │ n8n UI │ API     │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│         n8n Workflow Engine              │
│  (Orchestrates automation workflows)     │
└──────────────────┬───────────────────────┘
                   │
┌──────────────────▼───────────────────────┐
│         MCP Server (Port 3000)           │
│  • REST API & WebSocket                  │
│  • Tool Execution                        │
│  • Agent Orchestration                   │
└──────────────────┬───────────────────────┘
                   │
        ┌──────────┼──────────┐
        │          │          │
┌───────▼────┐ ┌──▼──────┐ ┌▼─────────┐
│ AI Agents  │ │  Tools  │ │Resources │
│ OpenAI     │ │ WhatsApp│ │ Database │
│ Gemini     │ │ Telegram│ │ KnowBase │
│ Ollama     │ │ WebScrpr│ │ Files    │
└────────────┘ └─────────┘ └──────────┘
```

## Key Components

### 1. MCP Server (`src/mcp-server/`)
- Central hub for all operations
- Exposes REST API and WebSocket
- Manages tool execution and resources
- Coordinates AI agents

### 2. AI Agents (`src/agents/`)
- **Orchestrator**: Routes tasks to appropriate agents
- **OpenAI Agent**: Uses GPT-4 for complex reasoning
- **Gemini Agent**: Google's Gemini for multimodal tasks
- **Ollama Agent**: Local models for privacy/offline use
- Supports tool calling and function execution

### 3. Integrations (`src/integrations/`)
- **WhatsApp**: Full messaging support with media
- **Telegram**: Bot integration with rich commands
- **ElevenLabs**: High-quality text-to-speech

### 4. RAG System (`src/rag/`)
- Vector-based knowledge base
- Semantic search using embeddings
- Context-aware AI responses
- PostgreSQL with pgvector extension

### 5. Database (`src/database/`)
- Conversation history tracking
- Document storage with embeddings
- Agent execution logs
- Workflow management
- User preferences

### 6. Utilities (`src/utils/`)
- Web scraping (Puppeteer + Cheerio)
- Data processing helpers
- Error handling utilities

## Use Cases

### 1. Customer Support Bot
- Automated responses via WhatsApp/Telegram
- RAG-powered answers from knowledge base
- Escalation to human agents
- Multi-language support

### 2. Data Collection & Analysis
- Scheduled web scraping
- AI-powered data extraction
- Automated reports
- Database storage

### 3. Content Generation
- Social media posts
- Email campaigns
- Product descriptions
- Voice messages

### 4. Personal Assistant
- Task automation
- Information retrieval
- Schedule management
- Smart notifications

### 5. Research & Knowledge Management
- Document ingestion
- Semantic search
- Summarization
- Q&A system

## Technology Stack

### Backend
- **Runtime**: Node.js 18+
- **Language**: TypeScript
- **Framework**: Express.js
- **Database**: PostgreSQL 15
- **Vector DB**: pgvector extension

### AI & ML
- **OpenAI**: GPT-4 for language tasks
- **Google Gemini**: Multimodal AI
- **Ollama**: Local model runtime
- **LangChain**: AI framework
- **Embeddings**: text-embedding-ada-002

### Messaging
- **WhatsApp**: whatsapp-web.js
- **Telegram**: node-telegram-bot-api

### Infrastructure
- **Containerization**: Docker & Docker Compose
- **Automation**: n8n
- **Web Scraping**: Puppeteer, Cheerio

### Development Tools
- **Linting**: ESLint
- **Testing**: Jest
- **Type Checking**: TypeScript
- **Version Control**: Git

## Project Structure

```
.
├── src/
│   ├── agents/              # AI agent implementations
│   │   ├── orchestrator.ts  # Agent routing
│   │   ├── openai-agent.ts  # GPT-4 integration
│   │   ├── gemini-agent.ts  # Gemini integration
│   │   ├── ollama-agent.ts  # Local models
│   │   └── tools.ts         # Agent utilities
│   ├── mcp-server/          # MCP protocol server
│   │   ├── index.ts         # Main server
│   │   └── handler.ts       # Request handling
│   ├── integrations/        # External services
│   │   ├── whatsapp/        # WhatsApp service
│   │   ├── telegram/        # Telegram service
│   │   └── elevenlabs/      # Text-to-speech
│   ├── database/            # Database layer
│   │   ├── service.ts       # DB operations
│   │   ├── init.sql         # Schema
│   │   └── migrate.js       # Migrations
│   ├── rag/                 # RAG system
│   │   └── service.ts       # Vector search
│   └── utils/               # Utilities
│       └── web-scraper.ts   # Web scraping
├── workflows/               # n8n templates
├── docs/                    # Documentation
├── docker-compose.yml       # Container orchestration
├── package.json            # Dependencies
└── tsconfig.json           # TypeScript config
```

## Data Flow Examples

### Example 1: WhatsApp Message Processing
1. User sends WhatsApp message
2. WhatsApp service receives message
3. Message forwarded to MCP server
4. Agent processes with context
5. Response generated
6. Sent back via WhatsApp

### Example 2: RAG Query
1. User asks question
2. Question embedded using OpenAI
3. Vector search in PostgreSQL
4. Relevant docs retrieved
5. Context + question sent to AI
6. AI generates answer
7. Response returned to user

### Example 3: Web Scraping Workflow
1. n8n triggers scraping task
2. MCP server receives request
3. Web scraper fetches content
4. AI analyzes scraped data
5. Results stored in database
6. Notifications sent

## Configuration

### Environment Variables
All configuration in `.env` file:
- API keys for AI services
- Database credentials
- Service ports
- Feature flags

### Customization
- Add new agents in `src/agents/`
- Add new tools in MCP handler
- Create custom workflows in n8n
- Extend database schema

## Security Considerations

1. **API Keys**: Store securely, never commit
2. **Database**: Use strong passwords
3. **Network**: Firewall configuration
4. **HTTPS**: SSL/TLS in production
5. **Authentication**: Add auth layer
6. **Rate Limiting**: Prevent abuse
7. **Input Validation**: Sanitize all inputs
8. **Logging**: Monitor for anomalies

## Performance Optimization

1. **Caching**: Redis for frequent queries
2. **Database**: Proper indexing
3. **Connection Pooling**: Reuse connections
4. **Batch Processing**: Group operations
5. **Async Operations**: Non-blocking I/O
6. **Load Balancing**: Multiple instances

## Monitoring & Maintenance

### Health Checks
```bash
./health-check.sh
```

### Logs
```bash
docker-compose logs -f
```

### Backups
```bash
pg_dump n8n > backup.sql
```

### Updates
```bash
docker-compose pull
docker-compose up -d
```

## Future Enhancements

- [ ] Authentication & authorization
- [ ] More AI model integrations
- [ ] Advanced RAG features
- [ ] Real-time collaboration
- [ ] Analytics dashboard
- [ ] Mobile app
- [ ] Plugin system
- [ ] Multi-tenancy

## Learning Resources

- [n8n Documentation](https://docs.n8n.io/)
- [MCP Protocol](https://modelcontextprotocol.io/)
- [OpenAI API](https://platform.openai.com/docs)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [Docker](https://docs.docker.com/)

## Support & Community

- GitHub Issues: Bug reports and features
- Discussions: Questions and ideas
- Wiki: Community knowledge
- Examples: Share your workflows

---

Built with ❤️ for automation enthusiasts
