# Frequently Asked Questions (FAQ)

## General Questions

### What is this project?

This is a comprehensive automation platform built on n8n that integrates AI models, messaging platforms (Telegram, WhatsApp), RAG (Retrieval-Augmented Generation), web scraping, and autonomous agents. It's designed to help you build intelligent automation workflows without extensive coding.

### Do I need programming knowledge?

No, most workflows can be configured through n8n's visual interface. However, basic understanding of JSON and SQL can be helpful for customization.

### Is this free to use?

The platform itself is free and open-source. However, some integrated services (OpenAI, ElevenLabs, etc.) require paid API subscriptions.

### Can I use this in production?

Yes, but ensure you:
- Use strong authentication
- Implement HTTPS
- Follow security best practices
- Have proper backups
- Monitor resource usage

## Installation & Setup

### What are the system requirements?

- Docker 20.10+
- Docker Compose 2.0+
- 4GB RAM minimum (8GB recommended)
- 10GB free disk space
- Linux, macOS, or Windows with WSL2

### Why won't Docker services start?

Common causes:
- Port conflicts (5678, 5432, 11434)
- Insufficient resources
- Docker not running
- Corrupted volumes

Solution: Check logs with `docker-compose logs` and ensure ports are available.

### How do I change the default port?

Edit `docker-compose.yml` and change the port mapping:
```yaml
ports:
  - "8080:5678"  # Change 5678 to your preferred port
```

### Can I run this without Docker?

Yes, but it's more complex. You'll need to:
- Install PostgreSQL with pgvector extension
- Install n8n manually
- Install and configure Ollama
- Manually configure all services

## AI Models

### Which AI model should I use?

Depends on your needs:
- **OpenAI GPT-4**: Most accurate, expensive
- **GPT-3.5-turbo**: Fast, cost-effective
- **Gemini**: Good balance, Google ecosystem
- **Ollama (Llama2)**: Free, private, runs locally

### How do I use local Ollama models?

1. Pull the model:
   ```bash
   docker exec -it $(docker-compose ps -q ollama) ollama pull llama2
   ```
2. Update workflows to use HTTP Request to `http://ollama:11434/api/generate`

### Can I use multiple AI models together?

Yes! You can:
- Use different models for different workflows
- Implement fallback mechanisms
- Compare outputs from multiple models
- Route based on task complexity

### How much do API calls cost?

Costs vary by provider:
- **OpenAI**: ~$0.002-0.06 per 1K tokens
- **Gemini**: Free tier available, then ~$0.00025-0.0005 per 1K characters
- **ElevenLabs**: ~$0.30 per 1K characters
- **Ollama**: Free (self-hosted)

## Messaging Bots

### How do I create a Telegram bot?

1. Message [@BotFather](https://t.me/botfather)
2. Send `/newbot`
3. Follow prompts to name your bot
4. Copy the provided token
5. Add token to `.env` file

### Why isn't my Telegram bot responding?

Check:
- Workflow is activated in n8n
- Telegram credentials are correct
- Bot token is valid
- n8n is accessible (no firewall blocking)
- Check n8n execution logs

### How do I set up WhatsApp Business API?

Two options:

**Option 1: Meta Business API** (Recommended for production)
1. Create Meta Business Account
2. Create WhatsApp Business app
3. Configure webhook
4. Get access token

**Option 2: Twilio** (Easier for testing)
1. Create Twilio account
2. Enable WhatsApp sandbox
3. Configure credentials

### Can I use the same workflow for multiple bots?

Yes, you can:
- Duplicate the workflow
- Use different credentials
- Modify as needed for each bot

## RAG (Retrieval-Augmented Generation)

### What is RAG?

RAG combines document retrieval with AI generation. It searches your knowledge base for relevant information and uses that context to generate accurate, informed responses.

### How do I add documents to the RAG database?

Several methods:
1. **Web scraping**: Use the scraping workflow
2. **Manual insertion**: Use SQL INSERT statements
3. **API**: Create a workflow with HTTP webhook
4. **CSV import**: Create an import workflow

### What is pgvector?

pgvector is a PostgreSQL extension that enables vector similarity search, essential for RAG. It allows finding similar documents based on semantic meaning, not just keywords.

### How accurate is RAG?

Accuracy depends on:
- Quality of your knowledge base
- Relevance of retrieved documents
- AI model quality
- Embedding model effectiveness

Typically 70-90% accurate with good data.

## Web Scraping

### Is web scraping legal?

It depends:
- Check website's Terms of Service
- Review robots.txt
- Respect rate limits
- Don't scrape personal data without permission
- Consider copyright implications

### How do I add websites to scrape?

Insert URLs into the database:
```sql
INSERT INTO scraped_data (url, is_processed)
VALUES ('https://example.com', false);
```

### Why is scraping failing?

Common issues:
- Website blocking automated requests
- Invalid URL
- JavaScript-rendered content (needs browser)
- Rate limiting
- Authentication required

### How often should I scrape?

Depends on:
- Content update frequency
- Website rate limits
- Your storage capacity
- API cost considerations

Typical: Every 6-24 hours

## Database

### How do I access the database?

```bash
docker-compose exec postgres psql -U n8n -d n8n
```

Or use a GUI tool like pgAdmin with:
- Host: localhost
- Port: 5432
- Database: n8n
- User: n8n
- Password: (from .env)

### How do I backup the database?

Use the backup script:
```bash
./scripts/backup.sh
```

Or manually:
```bash
docker-compose exec -T postgres pg_dump -U n8n n8n > backup.sql
```

### Can I use an external PostgreSQL server?

Yes, update `docker-compose.yml`:
```yaml
environment:
  - DB_POSTGRESDB_HOST=your-postgres-host
  - DB_POSTGRESDB_PORT=5432
  # ... other settings
```

Remove the postgres service from docker-compose.yml.

### How do I clean up old data?

Run maintenance queries:
```sql
DELETE FROM conversations WHERE created_at < NOW() - INTERVAL '6 months';
DELETE FROM workflows_log WHERE executed_at < NOW() - INTERVAL '3 months';
VACUUM ANALYZE;
```

## Performance

### n8n is running slowly

Solutions:
- Increase Docker memory allocation
- Optimize workflows (reduce polling)
- Use webhooks instead of polling
- Implement caching
- Upgrade hardware

### Database is getting large

Solutions:
- Implement data retention policies
- Archive old data
- Delete unnecessary logs
- Vacuum the database regularly

### API calls are too slow

Solutions:
- Use faster AI models
- Reduce token limits
- Switch to local Ollama
- Implement response caching
- Use batch processing

## Security

### How do I secure my installation?

1. Change default credentials
2. Use HTTPS (with reverse proxy)
3. Implement firewall rules
4. Use strong passwords
5. Rotate API keys
6. Keep Docker images updated
7. Implement rate limiting

### Are my API keys safe?

Yes, if you:
- Use environment variables
- Never commit .env to git
- Restrict file permissions
- Use secret management tools
- Monitor for unauthorized access

### Should I expose n8n to the internet?

For webhooks (Telegram, WhatsApp), yes, but:
- Use HTTPS
- Implement authentication
- Use a reverse proxy (nginx)
- Implement rate limiting
- Monitor access logs

## Troubleshooting

### Workflows aren't executing

Check:
- Workflow is activated
- Credentials are configured
- Trigger is set up correctly
- No errors in execution log
- Services are running

### Webhook isn't receiving data

Check:
- Correct webhook URL
- Workflow is active
- Firewall allows incoming requests
- External service is configured correctly
- Test with curl or Postman

### Out of memory errors

Solutions:
- Increase Docker memory limit
- Reduce concurrent executions
- Process data in batches
- Clean up old data
- Upgrade system resources

### Container keeps restarting

Check:
- `docker-compose logs [service]`
- Resource constraints
- Configuration errors
- Port conflicts
- Volume permissions

## Advanced Usage

### Can I create custom workflows?

Absolutely! Use n8n's visual workflow editor to:
- Combine existing nodes
- Add custom code nodes
- Integrate new services
- Build complex automations

### How do I integrate other services?

n8n supports 300+ integrations:
- Use built-in nodes
- HTTP Request for APIs
- Webhooks for events
- Database nodes for data
- Custom code for logic

### Can I schedule workflows?

Yes, use:
- Schedule Trigger node
- Cron expressions
- Interval triggers
- Webhook triggers

### How do I monitor workflows?

Methods:
- n8n execution logs
- Database workflow_logs table
- Error notifications (email, Slack)
- External monitoring tools
- Custom dashboards

## Support

### Where can I get help?

- Check documentation in `docs/`
- Review workflow README files
- Search GitHub issues
- Visit [n8n community](https://community.n8n.io/)
- Create a GitHub issue

### How do I report bugs?

Create a GitHub issue with:
- Clear description
- Steps to reproduce
- Expected vs actual behavior
- Environment details
- Logs and screenshots

### Can I request features?

Yes! Create a GitHub issue with:
- Feature description
- Use case
- Potential implementation
- Examples

### Is commercial support available?

This is a community project. For commercial support:
- Hire n8n experts
- Contact project maintainers
- Consider n8n Cloud (official)

---

**Didn't find your question? Create an issue on GitHub!**
