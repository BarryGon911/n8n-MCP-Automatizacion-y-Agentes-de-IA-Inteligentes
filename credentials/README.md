# n8n Credentials Configuration

This directory contains credential templates for n8n workflows.

## Setup

1. Copy credential templates and fill in your actual values
2. Import credentials into n8n via the UI
3. Link credentials to your workflows

## Available Credential Templates

### OpenAI Credentials
```json
{
  "name": "OpenAI API",
  "type": "openAiApi",
  "data": {
    "apiKey": "sk-your-openai-api-key"
  }
}
```

### Telegram Credentials
```json
{
  "name": "Telegram Bot",
  "type": "telegramApi",
  "data": {
    "accessToken": "your-telegram-bot-token"
  }
}
```

### PostgreSQL Credentials
```json
{
  "name": "PostgreSQL Database",
  "type": "postgres",
  "data": {
    "host": "localhost",
    "port": 5432,
    "database": "n8n",
    "user": "n8n_user",
    "password": "changeme",
    "ssl": false
  }
}
```

### HTTP Request Credentials (for MCP Server)
```json
{
  "name": "MCP Server",
  "type": "httpHeaderAuth",
  "data": {
    "name": "Authorization",
    "value": "Bearer your-api-key"
  }
}
```

## Security Notes

- **Never commit actual credentials to version control**
- Use environment variables or secure vaults for production
- Rotate credentials regularly
- Use least privilege principle for database users
