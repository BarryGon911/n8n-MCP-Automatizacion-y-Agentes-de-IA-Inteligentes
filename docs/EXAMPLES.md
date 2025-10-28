# Usage Examples

## Example 1: WhatsApp AI Bot

This example shows how to create an AI-powered WhatsApp bot that responds to messages.

### Setup

1. Start the services:
```bash
docker-compose up -d
```

2. Scan the WhatsApp QR code from the console logs:
```bash
docker-compose logs mcp-server | grep -A 5 "WhatsApp QR Code"
```

3. Import the workflow `workflows/whatsapp-ai-bot.json` into n8n

### Test

Send a WhatsApp message to the connected number, and the bot will respond using AI.

---

## Example 2: Telegram Weather Bot

### Setup MCP Tool Call

```javascript
const axios = require('axios');

async function getWeatherAndNotify(city, telegramChatId) {
  // Get weather data (example)
  const weatherData = await axios.get(`https://api.openweathermap.org/data/2.5/weather?q=${city}`);
  
  // Use AI to format the response
  const aiResponse = await axios.post('http://localhost:3000/agents/execute', {
    agentType: 'conversational',
    task: `Summarize this weather data in a friendly way: ${JSON.stringify(weatherData.data)}`,
  });
  
  // Send via Telegram
  await axios.post('http://localhost:3000/mcp/tools/execute', {
    name: 'send_telegram_message',
    parameters: {
      chatId: telegramChatId,
      message: aiResponse.data.output.content,
    },
  });
}

getWeatherAndNotify('New York', 'YOUR_CHAT_ID');
```

---

## Example 3: RAG Knowledge Base

### Add Documents to Knowledge Base

```javascript
const axios = require('axios');

async function addDocuments() {
  const documents = [
    {
      title: 'Company Policy',
      content: 'Our company values integrity, innovation, and customer satisfaction...',
      source: 'HR Department',
    },
    {
      title: 'Product Guide',
      content: 'Our flagship product features include...',
      source: 'Product Team',
    },
  ];
  
  for (const doc of documents) {
    const response = await axios.post('http://localhost:3000/rag/documents', doc);
    console.log('Document added:', response.data);
  }
}

addDocuments();
```

### Query Knowledge Base

```javascript
async function queryKnowledgeBase(question) {
  const response = await axios.post('http://localhost:3000/mcp/tools/execute', {
    name: 'search_knowledge_base',
    parameters: {
      query: question,
      limit: 3,
    },
  });
  
  console.log('Search results:', response.data);
  
  // Generate AI response with context
  const aiResponse = await axios.post('http://localhost:3000/agents/execute', {
    agentType: 'rag',
    task: question,
    context: {
      retrievedDocuments: response.data.results,
    },
  });
  
  console.log('AI Answer:', aiResponse.data.output.content);
}

queryKnowledgeBase('What are the company policies?');
```

---

## Example 4: Web Scraping with AI Analysis

```javascript
async function scrapeAndAnalyze(url, analysisTask) {
  // Scrape website
  const scrapeResponse = await axios.post('http://localhost:3000/mcp/tools/execute', {
    name: 'scrape_website',
    parameters: {
      url: url,
    },
  });
  
  // Analyze with AI
  const analysisResponse = await axios.post('http://localhost:3000/agents/execute', {
    agentType: 'openai',
    task: analysisTask,
    context: {
      scrapedContent: scrapeResponse.data.content,
    },
  });
  
  console.log('Analysis:', analysisResponse.data.output.content);
  return analysisResponse.data;
}

scrapeAndAnalyze(
  'https://news.ycombinator.com',
  'Summarize the top 5 trending topics'
);
```

---

## Example 5: Multi-Agent Workflow

This example demonstrates coordinating multiple agents for a complex task.

```javascript
async function complexWorkflow(userRequest) {
  // Step 1: Use web scraper to gather information
  console.log('Step 1: Gathering information...');
  const webData = await axios.post('http://localhost:3000/agents/execute', {
    agentType: 'web-scraper',
    task: 'Extract main content',
    context: {
      url: 'https://example.com/data',
    },
  });
  
  // Step 2: Search knowledge base for related information
  console.log('Step 2: Searching knowledge base...');
  const kbResults = await axios.post('http://localhost:3000/mcp/tools/execute', {
    name: 'search_knowledge_base',
    parameters: {
      query: userRequest,
      limit: 3,
    },
  });
  
  // Step 3: Combine and analyze with RAG agent
  console.log('Step 3: Generating comprehensive response...');
  const finalResponse = await axios.post('http://localhost:3000/agents/execute', {
    agentType: 'rag',
    task: userRequest,
    context: {
      webData: webData.data.output,
      retrievedDocuments: kbResults.data.results,
    },
  });
  
  // Step 4: Convert to speech
  console.log('Step 4: Converting to speech...');
  const audioResponse = await axios.post('http://localhost:3000/mcp/tools/execute', {
    name: 'text_to_speech',
    parameters: {
      text: finalResponse.data.output.content,
    },
  });
  
  return {
    text: finalResponse.data.output.content,
    audio: audioResponse.data.audio,
  };
}

complexWorkflow('What are the latest AI trends and how do they relate to our products?');
```

---

## Example 6: Conversational AI with Memory

```javascript
class ConversationalBot {
  constructor() {
    this.conversationHistory = [];
  }
  
  async chat(message) {
    // Add user message to history
    this.conversationHistory.push({
      role: 'user',
      content: message,
    });
    
    // Get AI response
    const response = await axios.post('http://localhost:3000/agents/execute', {
      agentType: 'conversational',
      task: message,
      context: {
        conversationHistory: this.conversationHistory,
      },
    });
    
    // Add AI response to history
    this.conversationHistory.push({
      role: 'assistant',
      content: response.data.output.content,
    });
    
    return response.data.output.content;
  }
  
  clearHistory() {
    this.conversationHistory = [];
  }
}

// Usage
const bot = new ConversationalBot();

async function demo() {
  console.log(await bot.chat('Hello, what can you help me with?'));
  console.log(await bot.chat('Tell me about quantum computing'));
  console.log(await bot.chat('Can you simplify that explanation?'));
}

demo();
```

---

## Example 7: n8n Workflow Integration

### Create a Scheduled Report Workflow

1. **Schedule Trigger**: Daily at 9 AM
2. **Scrape Data**: Use MCP scrape_website tool
3. **Analyze with AI**: Process the scraped data
4. **Store in Database**: Save results to PostgreSQL
5. **Send Notifications**: Send summary via WhatsApp and Telegram

```json
{
  "nodes": [
    {
      "parameters": {
        "rule": {
          "interval": [{ "field": "cronExpression", "expression": "0 9 * * *" }]
        }
      },
      "name": "Schedule",
      "type": "n8n-nodes-base.scheduleTrigger"
    },
    {
      "parameters": {
        "url": "http://mcp-server:3000/mcp/tools/execute",
        "method": "POST",
        "bodyParameters": {
          "parameters": [
            { "name": "name", "value": "scrape_website" },
            { "name": "parameters", "value": "={{ { url: 'https://example.com/data' } }}" }
          ]
        }
      },
      "name": "Scrape Data",
      "type": "n8n-nodes-base.httpRequest"
    }
  ]
}
```

---

## Example 8: Database Queries with AI

```javascript
async function naturalLanguageQuery(question) {
  // Use AI to convert natural language to SQL
  const sqlGeneration = await axios.post('http://localhost:3000/agents/execute', {
    agentType: 'openai',
    task: `Convert this question to a SQL query for a conversations table with columns: id, platform, chat_id, message_text, created_at. Question: ${question}`,
  });
  
  // Extract SQL from response
  const sqlQuery = extractSQL(sqlGeneration.data.output.content);
  
  // Execute query
  const queryResult = await axios.post('http://localhost:3000/mcp/tools/execute', {
    name: 'query_database',
    parameters: {
      query: sqlQuery,
    },
  });
  
  // Format results with AI
  const formattedResults = await axios.post('http://localhost:3000/agents/execute', {
    agentType: 'openai',
    task: `Format these database results in a user-friendly way: ${JSON.stringify(queryResult.data.rows)}`,
  });
  
  return formattedResults.data.output.content;
}

function extractSQL(text) {
  const match = text.match(/SELECT.*?;/is);
  return match ? match[0] : text;
}

naturalLanguageQuery('How many messages did we receive yesterday?');
```

---

## Example 9: Voice Messages with ElevenLabs

```javascript
async function createVoiceMessage(text, recipient, platform = 'whatsapp') {
  // Convert text to speech
  const audioResponse = await axios.post('http://localhost:3000/mcp/tools/execute', {
    name: 'text_to_speech',
    parameters: {
      text: text,
    },
  });
  
  // Save audio file
  const fs = require('fs');
  const audioPath = '/tmp/voice_message.mp3';
  fs.writeFileSync(audioPath, audioResponse.data.audio);
  
  // Send via messaging platform
  if (platform === 'whatsapp') {
    // Send WhatsApp voice message
    console.log('Voice message created at:', audioPath);
    // You would need to implement media sending for WhatsApp
  } else if (platform === 'telegram') {
    // Send Telegram voice message
    console.log('Voice message created at:', audioPath);
    // You would need to implement media sending for Telegram
  }
  
  return audioPath;
}

createVoiceMessage('Hello! This is an automated voice message.', '+1234567890', 'whatsapp');
```

---

## Example 10: Error Handling and Retries

```javascript
async function robustAgentExecution(agentType, task, maxRetries = 3) {
  let lastError;
  
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await axios.post('http://localhost:3000/agents/execute', {
        agentType,
        task,
      });
      
      if (response.data.success) {
        return response.data;
      }
      
      lastError = new Error('Agent execution failed');
    } catch (error) {
      console.log(`Attempt ${attempt} failed:`, error.message);
      lastError = error;
      
      if (attempt < maxRetries) {
        // Exponential backoff
        await new Promise(resolve => setTimeout(resolve, 1000 * Math.pow(2, attempt)));
      }
    }
  }
  
  throw lastError;
}

// Usage
robustAgentExecution('openai', 'Explain machine learning')
  .then(result => console.log('Success:', result))
  .catch(error => console.error('All retries failed:', error));
```

---

## Tips for Production Use

1. **Rate Limiting**: Implement rate limiting for API endpoints
2. **Caching**: Cache frequently accessed data and AI responses
3. **Monitoring**: Set up monitoring and alerting
4. **Error Handling**: Always implement proper error handling
5. **Authentication**: Add authentication for production deployments
6. **Logging**: Log all important operations for debugging
7. **Testing**: Write tests for critical workflows
8. **Backup**: Regular backups of database and configurations
