# API Documentation

## MCP Server API

### Base URL
```
http://localhost:3000
```

### Authentication
Currently no authentication required. Add JWT or API key authentication for production use.

---

## Endpoints

### Health Check

**GET** `/health`

Returns server health status.

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-26T00:00:00.000Z"
}
```

---

### Initialize MCP Connection

**POST** `/mcp/initialize`

Initialize MCP protocol connection.

**Request Body:**
```json
{
  "clientInfo": {
    "name": "client-name",
    "version": "1.0.0"
  },
  "capabilities": {
    "tools": true,
    "resources": true
  }
}
```

**Response:**
```json
{
  "protocolVersion": "1.0.0",
  "serverInfo": {
    "name": "n8n-mcp-automation-server",
    "version": "1.0.0"
  },
  "capabilities": {
    "tools": true,
    "resources": true,
    "prompts": true
  }
}
```

---

### List Tools

**POST** `/mcp/tools/list`

Get list of available MCP tools.

**Response:**
```json
{
  "tools": [
    {
      "name": "send_whatsapp_message",
      "description": "Send a WhatsApp message",
      "inputSchema": {
        "type": "object",
        "properties": {
          "recipient": { "type": "string" },
          "message": { "type": "string" }
        },
        "required": ["recipient", "message"]
      }
    }
  ]
}
```

---

### Execute Tool

**POST** `/mcp/tools/execute`

Execute an MCP tool.

**Request Body:**
```json
{
  "name": "send_whatsapp_message",
  "parameters": {
    "recipient": "+1234567890",
    "message": "Hello, World!"
  }
}
```

**Response:**
```json
{
  "success": true,
  "recipient": "+1234567890",
  "message": "Hello, World!",
  "timestamp": "2025-10-26T00:00:00.000Z"
}
```

---

### List Resources

**POST** `/mcp/resources/list`

Get list of available resources.

**Response:**
```json
{
  "resources": [
    {
      "uri": "db://conversations",
      "name": "Conversations Database",
      "description": "Access to conversation history",
      "mimeType": "application/json"
    }
  ]
}
```

---

### Read Resource

**POST** `/mcp/resources/read`

Read a specific resource.

**Request Body:**
```json
{
  "uri": "db://conversations"
}
```

**Response:**
```json
{
  "success": true,
  "rows": [...]
}
```

---

### Execute Agent

**POST** `/agents/execute`

Execute an AI agent.

**Request Body:**
```json
{
  "agentType": "conversational",
  "task": "Explain quantum computing in simple terms",
  "context": {
    "conversationHistory": []
  }
}
```

**Response:**
```json
{
  "success": true,
  "output": {
    "content": "Quantum computing is...",
    "model": "gpt-4-turbo-preview"
  },
  "metadata": {
    "agentType": "conversational",
    "timestamp": "2025-10-26T00:00:00.000Z"
  }
}
```

---

## Agent Types

### 1. Conversational Agent
**Type:** `conversational`

General-purpose conversational AI agent.

**Example:**
```json
{
  "agentType": "conversational",
  "task": "What is the weather like?",
  "context": {}
}
```

### 2. RAG Agent
**Type:** `rag`

Retrieval-Augmented Generation agent with knowledge base access.

**Example:**
```json
{
  "agentType": "rag",
  "task": "What are our company policies?",
  "context": {}
}
```

### 3. Web Scraper Agent
**Type:** `web-scraper`

Web scraping with AI analysis.

**Example:**
```json
{
  "agentType": "web-scraper",
  "task": "Summarize the main points",
  "context": {
    "url": "https://example.com",
    "selector": ".content"
  }
}
```

### 4. OpenAI Agent
**Type:** `openai`

Direct OpenAI GPT-4 agent.

**Example:**
```json
{
  "agentType": "openai",
  "task": "Generate a product description",
  "context": {}
}
```

### 5. Gemini Agent
**Type:** `gemini`

Google Gemini agent.

**Example:**
```json
{
  "agentType": "gemini",
  "task": "Analyze this data",
  "context": {}
}
```

### 6. Ollama Agent
**Type:** `ollama`

Local Ollama model agent.

**Example:**
```json
{
  "agentType": "ollama",
  "task": "Process this text",
  "context": {}
}
```

---

## MCP Tools Reference

### send_whatsapp_message
Send a WhatsApp message.

**Parameters:**
- `recipient` (string, required): Phone number or group ID
- `message` (string, required): Message text

### send_telegram_message
Send a Telegram message.

**Parameters:**
- `chatId` (string, required): Telegram chat ID
- `message` (string, required): Message text

### query_database
Execute SQL query on PostgreSQL.

**Parameters:**
- `query` (string, required): SQL query
- `params` (array, optional): Query parameters

### search_knowledge_base
Semantic search in knowledge base.

**Parameters:**
- `query` (string, required): Search query
- `limit` (number, optional): Max results (default: 5)

### scrape_website
Scrape content from website.

**Parameters:**
- `url` (string, required): URL to scrape
- `selector` (string, optional): CSS selector

### generate_ai_response
Generate AI response.

**Parameters:**
- `prompt` (string, required): Input prompt
- `model` (string, optional): Model type (openai, gemini, ollama)
- `context` (object, optional): Additional context

### text_to_speech
Convert text to speech using ElevenLabs.

**Parameters:**
- `text` (string, required): Text to convert
- `voiceId` (string, optional): ElevenLabs voice ID

---

## WebSocket API

Connect to WebSocket for real-time communication:

```javascript
const ws = new WebSocket('ws://localhost:3000');

ws.on('open', () => {
  ws.send(JSON.stringify({
    id: '1',
    method: 'tools/list',
    params: {}
  }));
});

ws.on('message', (data) => {
  const response = JSON.parse(data);
  console.log(response);
});
```

---

## Error Handling

All endpoints return errors in the following format:

```json
{
  "error": "Error message description"
}
```

Common HTTP status codes:
- `200`: Success
- `400`: Bad Request
- `500`: Internal Server Error
