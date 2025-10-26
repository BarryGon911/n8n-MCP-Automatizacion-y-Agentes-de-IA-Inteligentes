# Workflows Documentation

This directory contains pre-built n8n workflows for various automation tasks involving AI agents, messaging platforms, and data processing.

## Available Workflows

### 1. Telegram Bot with AI Agent (`telegram-ai-bot.json`)

**Description**: An intelligent Telegram bot that uses RAG (Retrieval-Augmented Generation) to provide context-aware responses.

**Features**:
- Receives messages from Telegram users
- Stores conversation history in PostgreSQL
- Retrieves relevant context from the RAG database
- Generates AI responses using OpenAI or Ollama
- Supports conversation tracking and user profiling

**Nodes**:
- Telegram Trigger
- PostgreSQL (Save/Retrieve)
- OpenAI / Ollama
- Telegram Send Message

**Credentials Required**:
- Telegram Bot API
- PostgreSQL
- OpenAI API (or configure Ollama endpoint)

**Use Cases**:
- Customer support automation
- Knowledge base Q&A
- Personal AI assistant
- Educational chatbot

---

### 2. WhatsApp Bot with AI Agent (`whatsapp-ai-bot.json`)

**Description**: AI-powered WhatsApp bot using Meta's WhatsApp Business API and Google Gemini.

**Features**:
- Webhook-based message receiving
- WhatsApp Business API integration
- Gemini AI for response generation
- Message history tracking
- Multi-user support

**Nodes**:
- Webhook Trigger
- Data Validation
- Message Extraction
- PostgreSQL Storage
- Gemini AI
- WhatsApp API Response

**Credentials Required**:
- Meta WhatsApp Business API credentials
- PostgreSQL
- Google Gemini API

**Use Cases**:
- Business customer service
- Order notifications and tracking
- Appointment scheduling
- Product information queries

---

### 3. Web Scraping to RAG Database (`web-scraping-rag.json`)

**Description**: Automated web scraping workflow that extracts content from websites and stores it in the RAG database with vector embeddings.

**Features**:
- Scheduled execution (every 6 hours)
- Batch processing of URLs
- Content extraction with Cheerio
- OpenAI embedding generation
- Vector storage in PostgreSQL with pgvector

**Nodes**:
- Schedule Trigger
- PostgreSQL (Fetch URLs)
- HTTP Request (Scrape)
- Code Node (Cheerio extraction)
- OpenAI Embeddings
- PostgreSQL (Store embeddings)

**Credentials Required**:
- PostgreSQL
- OpenAI API

**Use Cases**:
- Building knowledge bases
- Competitive intelligence
- Content aggregation
- Documentation indexing
- News monitoring

---

### 4. Text-to-Speech with ElevenLabs (`elevenlabs-tts.json`)

**Description**: Convert text to natural-sounding speech using ElevenLabs API.

**Features**:
- Webhook-based text input
- High-quality voice synthesis
- Customizable voice settings
- Audio file generation

**Nodes**:
- Webhook Trigger
- HTTP Request (ElevenLabs API)
- Webhook Response

**Credentials Required**:
- ElevenLabs API

**Use Cases**:
- Podcast generation
- Accessibility features
- Voice notifications
- Content narration
- Language learning

---

### 5. AI Agent Task Executor (`ai-agent-executor.json`)

**Description**: Autonomous agent system that processes tasks from a queue, supporting multiple task types.

**Features**:
- Scheduled task polling (every 5 minutes)
- Task type routing (web scraping, AI analysis, notifications)
- Status tracking (pending, running, completed, failed)
- Result storage
- Error handling

**Nodes**:
- Schedule Trigger
- PostgreSQL (Task queue)
- Switch (Task type router)
- HTTP Request (Web scraping)
- OpenAI (AI analysis)
- PostgreSQL (Update status)

**Credentials Required**:
- PostgreSQL
- OpenAI API

**Use Cases**:
- Automated content analysis
- Batch processing
- Scheduled AI tasks
- Data pipeline automation
- Background job processing

---

## Workflow Import Instructions

### Method 1: Via n8n UI

1. Log in to n8n at `http://localhost:5678`
2. Click on **Workflows** in the left sidebar
3. Click the **Import from File** button
4. Select the desired workflow JSON file
5. Click **Import**
6. Configure credentials and settings
7. Activate the workflow

### Method 2: Via File System

1. Copy workflow files to n8n's workflows directory:
   ```bash
   cp workflows/*.json /path/to/n8n/.n8n/workflows/
   ```
2. Restart n8n
3. Workflows will appear in the workflows list

### Method 3: Via Docker Volume

If using Docker:

```bash
docker cp workflows/telegram-ai-bot.json n8n:/home/node/.n8n/workflows/
```

---

## Workflow Configuration

### Setting Up Credentials

Before activating workflows, configure the required credentials:

#### PostgreSQL

1. In n8n, go to **Credentials** → **New Credential**
2. Select **PostgreSQL**
3. Enter:
   - Host: `postgres` (or `localhost` if running locally)
   - Database: `n8n`
   - User: `n8n`
   - Password: (from your `.env` file)
   - Port: `5432`

#### OpenAI

1. Go to **Credentials** → **New Credential**
2. Select **OpenAI API**
3. Enter your API key from `.env`

#### Telegram

1. Go to **Credentials** → **New Credential**
2. Select **Telegram API**
3. Enter your bot token from @BotFather

#### Gemini (Generic HTTP Request)

Configure via HTTP Request node with header authentication:
- Header Name: `x-goog-api-key`
- Header Value: Your Gemini API key

#### ElevenLabs (Generic HTTP Request)

Configure via HTTP Request node with header authentication:
- Header Name: `xi-api-key`
- Header Value: Your ElevenLabs API key

---

## Customization Guide

### Modifying AI Models

#### Change OpenAI Model

In any OpenAI node, modify the `model` parameter:
- `gpt-3.5-turbo` - Fast and cost-effective
- `gpt-4` - Most capable
- `gpt-4-turbo` - Balanced performance

#### Switch to Ollama

Replace OpenAI nodes with HTTP Request nodes:
```json
{
  "url": "http://ollama:11434/api/generate",
  "method": "POST",
  "body": {
    "model": "llama2",
    "prompt": "Your prompt here",
    "stream": false
  }
}
```

### Adjusting Schedules

Modify Schedule Trigger nodes to change execution frequency:
- **Minutes**: For frequent updates (1-59 minutes)
- **Hours**: For regular intervals (1-23 hours)
- **Days**: For daily tasks
- **Cron Expression**: For complex schedules

### Adding Error Handling

1. Add an **Error Trigger** node to workflows
2. Connect to notification services (Email, Slack, Telegram)
3. Configure retry logic in node settings
4. Set up error logging to database

---

## Workflow Best Practices

### 1. Testing

Always test workflows before activating:
- Use the **Execute Workflow** button
- Test with sample data
- Verify all credentials
- Check error handling

### 2. Monitoring

Set up monitoring:
- Enable execution logging
- Configure error notifications
- Track execution times
- Monitor API usage

### 3. Optimization

Improve performance:
- Use batch processing where possible
- Implement caching for frequently accessed data
- Optimize database queries
- Use webhooks instead of polling when available

### 4. Security

Secure your workflows:
- Use environment variables for sensitive data
- Implement webhook verification
- Add rate limiting
- Validate input data

### 5. Documentation

Document your customizations:
- Add notes to nodes
- Use descriptive node names
- Comment complex logic
- Keep a changelog

---

## Troubleshooting

### Workflow Won't Activate

**Possible causes**:
- Missing credentials
- Invalid configuration
- Node compatibility issues

**Solutions**:
- Check all credential connections
- Verify node settings
- Review error messages in the UI

### Webhook Not Receiving Data

**Possible causes**:
- Incorrect webhook URL
- Firewall blocking requests
- Webhook not activated

**Solutions**:
- Verify webhook URL in external service
- Check n8n logs: `docker-compose logs n8n`
- Ensure workflow is active
- Test with curl or Postman

### Database Connection Errors

**Possible causes**:
- PostgreSQL not running
- Incorrect credentials
- Network issues

**Solutions**:
- Verify PostgreSQL is running: `docker-compose ps postgres`
- Check credentials in n8n
- Test connection from command line

### AI Responses Too Slow

**Solutions**:
- Use faster models (gpt-3.5-turbo)
- Reduce max tokens
- Switch to Ollama for local inference
- Implement caching

---

## Advanced Workflows

### Creating Custom Workflows

To create your own workflow:

1. Start with a trigger (Webhook, Schedule, or Manual)
2. Add data processing nodes
3. Integrate AI services
4. Store results in database
5. Add notifications or responses
6. Test thoroughly
7. Export as JSON for version control

### Combining Workflows

Link workflows together:
- Use **Execute Workflow** node to call other workflows
- Share data via PostgreSQL
- Use webhooks for asynchronous communication
- Implement event-driven architecture

---

## Example Workflow Combinations

### 1. Complete Customer Support System

**Workflows**:
- Telegram Bot + WhatsApp Bot
- Web Scraping (for knowledge base updates)
- AI Agent Executor (for background tasks)

**Flow**:
1. Users message via Telegram/WhatsApp
2. RAG retrieves relevant documentation
3. AI generates response
4. Conversation logged
5. Complex queries queued as agent tasks

### 2. Content Automation Pipeline

**Workflows**:
- Web Scraping (content discovery)
- AI Agent Executor (content analysis)
- Text-to-Speech (audio creation)

**Flow**:
1. Scrape websites for new content
2. AI analyzes and summarizes
3. Generate audio versions
4. Store and distribute

---

## Contributing

To contribute new workflows:

1. Create and test your workflow in n8n
2. Export as JSON
3. Add documentation
4. Submit a pull request
5. Include use case examples

---

## Support

For workflow-specific issues:
- Check the [USAGE.md](../docs/USAGE.md) guide
- Review [INSTALLATION.md](../docs/INSTALLATION.md)
- Consult [n8n documentation](https://docs.n8n.io/)
- Open an issue on GitHub
