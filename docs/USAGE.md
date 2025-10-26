# Usage Guide

This guide explains how to use the various workflows and features of the n8n Automation & AI Agents project.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Telegram Bot](#telegram-bot)
3. [WhatsApp Bot](#whatsapp-bot)
4. [Web Scraping & RAG](#web-scraping--rag)
5. [AI Agent Tasks](#ai-agent-tasks)
6. [Text-to-Speech](#text-to-speech)
7. [Advanced Features](#advanced-features)

## Getting Started

After installation, ensure all services are running:

```bash
docker-compose ps
```

Access n8n at `http://localhost:5678` and log in with your credentials.

## Telegram Bot

The Telegram bot provides an AI-powered conversational interface using RAG (Retrieval-Augmented Generation).

### Activating the Bot

1. In n8n, open the "Telegram Bot with AI Agent" workflow
2. Configure the Telegram credentials (bot token)
3. Configure the PostgreSQL and OpenAI credentials
4. Click the **Active** toggle to enable the workflow

### Using the Bot

1. Open Telegram and search for your bot (using the username you created with @BotFather)
2. Start a conversation with `/start`
3. Send any message to get an AI-powered response

### Features

- **Context-Aware Responses**: Uses RAG to retrieve relevant information from your knowledge base
- **Conversation History**: Stores all conversations in PostgreSQL
- **Multi-Model Support**: Can use OpenAI GPT-4 or local Ollama models
- **User Tracking**: Maintains user profiles and preferences

### Example Conversations

```
User: What is n8n?
Bot: n8n is a workflow automation platform that allows you to connect 
     different services and automate tasks. It's a powerful tool for 
     creating complex automations without coding.

User: How do I use RAG?
Bot: RAG (Retrieval-Augmented Generation) combines retrieval of relevant 
     documents with language model generation. It searches your knowledge 
     base for relevant information and uses that context to generate 
     accurate responses.
```

## WhatsApp Bot

The WhatsApp bot provides similar AI capabilities through WhatsApp Business API.

### Setup Requirements

- Meta Business Account or Twilio account
- Verified WhatsApp Business number
- Webhook configured to point to your n8n instance

### Activating the Bot

1. Open the "WhatsApp Bot with AI Agent" workflow
2. Configure your WhatsApp credentials in the environment variables
3. Set up the webhook in Meta Business Dashboard:
   - Webhook URL: `http://your-domain.com:5678/webhook/whatsapp-webhook`
   - Verify Token: (as set in your `.env`)
4. Activate the workflow

### Features

- **Gemini AI Integration**: Uses Google's Gemini for natural language processing
- **Message History**: Stores all WhatsApp conversations
- **Multi-User Support**: Handles multiple conversations simultaneously

### Testing the Bot

Send a message to your WhatsApp Business number. The bot will respond with AI-generated content based on your message.

## Web Scraping & RAG

This workflow automatically scrapes web pages and adds the content to your RAG knowledge base.

### How It Works

1. Runs on a schedule (every 6 hours by default)
2. Retrieves URLs from the `scraped_data` table
3. Scrapes the content using HTTP requests
4. Extracts text content using Cheerio
5. Creates embeddings using OpenAI
6. Stores everything in the documents table for RAG

### Adding URLs to Scrape

Connect to the PostgreSQL database and insert URLs:

```sql
INSERT INTO scraped_data (url, is_processed) 
VALUES 
  ('https://docs.n8n.io/', false),
  ('https://en.wikipedia.org/wiki/Artificial_intelligence', false);
```

Or use the n8n workflow:

1. Create a simple workflow with an HTTP Request node
2. Add a PostgreSQL node to insert the URL
3. Let the scraping workflow process it

### Viewing Scraped Content

```sql
SELECT title, url, scraped_at 
FROM scraped_data 
WHERE is_processed = true 
ORDER BY scraped_at DESC;
```

### Using RAG in Conversations

The Telegram and WhatsApp bots automatically use the RAG database to provide context-aware responses. The system:

1. Receives a user message
2. Searches the documents table for relevant content
3. Uses the retrieved content as context for the AI model
4. Generates a response based on the context and question

## AI Agent Tasks

The AI Agent Task Executor runs autonomous tasks based on entries in the `agent_tasks` table.

### Task Types

1. **web_scraping**: Scrape a specific URL
2. **ai_analysis**: Analyze content with AI
3. **notification**: Send notifications

### Creating a Task

Insert a task into the database:

```sql
INSERT INTO agent_tasks (task_name, task_type, input_data, status)
VALUES (
  'Analyze Article',
  'ai_analysis',
  '{"prompt": "Summarize the main points of this article: [article text]"}',
  'pending'
);
```

### Monitoring Tasks

Check task status:

```sql
SELECT id, task_name, status, created_at, completed_at
FROM agent_tasks
ORDER BY created_at DESC
LIMIT 10;
```

### Task Workflow

1. Schedule trigger runs every 5 minutes
2. Fetches pending tasks
3. Marks them as running
4. Executes the appropriate action based on task_type
5. Saves the output
6. Marks as completed

## Text-to-Speech

Convert text to speech using ElevenLabs.

### Using the TTS Workflow

Activate the "Text-to-Speech with ElevenLabs" workflow, then send a POST request:

```bash
curl -X POST http://localhost:5678/webhook/tts-request \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello, this is a text to speech test."}'
```

### Integration with Bots

You can extend the Telegram or WhatsApp workflows to include TTS:

1. Add an HTTP Request node after AI response generation
2. Point it to the TTS webhook
3. Send the AI response text
4. The bot can then send the audio file back to the user

## Advanced Features

### Custom AI Models

#### Using Different OpenAI Models

Modify the workflow nodes to use different models:
- `gpt-3.5-turbo` (faster, cheaper)
- `gpt-4` (more accurate, slower)
- `gpt-4-turbo` (balanced)

#### Using Local Ollama Models

Switch to Ollama for privacy and cost savings:

1. Pull the desired model:
   ```bash
   docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull mistral
   ```

2. Update the workflow to use the HTTP Request node pointing to:
   ```
   http://ollama:11434/api/generate
   ```

### Multi-Language Support

The bots support multiple languages out of the box since GPT-4, Gemini, and other models are multilingual.

### Conversation Context

Enhance responses by adding conversation history:

```sql
SELECT message, response 
FROM conversations 
WHERE user_id = 'user123' 
ORDER BY created_at DESC 
LIMIT 5;
```

Use this context in your AI prompts for more coherent conversations.

### Analytics

Track usage statistics:

```sql
-- Messages per platform
SELECT platform, COUNT(*) as message_count
FROM conversations
GROUP BY platform;

-- Most active users
SELECT user_id, COUNT(*) as interactions
FROM conversations
GROUP BY user_id
ORDER BY interactions DESC
LIMIT 10;

-- Workflow execution stats
SELECT workflow_name, status, COUNT(*) as count
FROM workflows_log
GROUP BY workflow_name, status;
```

## Best Practices

### 1. Rate Limiting

Monitor your API usage to avoid hitting rate limits:
- OpenAI: Check your usage dashboard
- Gemini: Monitor quota in Google Cloud Console
- ElevenLabs: Track character usage

### 2. Error Handling

Set up error notifications in n8n:
1. Add an "Error Trigger" node
2. Connect it to a notification service (Email, Slack, etc.)
3. Get alerts when workflows fail

### 3. Backup

Regularly backup your PostgreSQL database:

```bash
docker exec -t postgres pg_dump -U n8n n8n > backup_$(date +%Y%m%d).sql
```

### 4. Security

- Never commit your `.env` file
- Use strong passwords for n8n and PostgreSQL
- Keep API keys secure
- Use HTTPS in production
- Implement webhook validation

### 5. Scaling

For high-traffic scenarios:
- Use PostgreSQL connection pooling
- Add rate limiting to webhooks
- Consider using queue systems for task processing
- Scale n8n horizontally with multiple instances

## Troubleshooting

### Bot Not Responding

1. Check if the workflow is active
2. Verify API credentials are correct
3. Check n8n execution logs
4. Verify webhook URLs are accessible

### Database Errors

1. Check PostgreSQL is running: `docker-compose ps postgres`
2. Verify connection credentials
3. Check database logs: `docker-compose logs postgres`

### Slow AI Responses

1. Consider using faster models (gpt-3.5-turbo instead of gpt-4)
2. Reduce token limits
3. Use local Ollama for faster responses
4. Optimize RAG queries

## Examples and Use Cases

### Customer Support Bot

Use the Telegram/WhatsApp bots for automated customer support:
1. Add your product documentation to the RAG database
2. Configure the bot to answer common questions
3. Log all interactions for analysis

### Content Monitoring

Use web scraping to monitor competitor websites:
1. Add competitor URLs to the scraping list
2. Schedule regular scraping
3. Set up alerts for significant changes

### Automated Content Creation

Use AI agents to generate content:
1. Create tasks for article summarization
2. Generate social media posts
3. Create translations

### Voice Assistants

Combine the bots with TTS:
1. Receive text input from users
2. Generate AI responses
3. Convert to speech with ElevenLabs
4. Send audio back to users

## Next Steps

- Explore creating custom workflows
- Integrate with additional services
- Optimize performance for your use case
- Join the n8n community for support and ideas
