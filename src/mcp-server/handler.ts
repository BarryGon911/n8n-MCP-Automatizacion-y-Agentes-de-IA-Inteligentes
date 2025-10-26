import { AgentTools } from '../agents/tools';
import { DatabaseService } from '../database/service';
import { RAGService } from '../rag/service';
import { WebScraperService } from '../utils/web-scraper';

interface MCPTool {
  name: string;
  description: string;
  inputSchema: {
    type: string;
    properties: Record<string, any>;
    required: string[];
  };
}

interface MCPResource {
  uri: string;
  name: string;
  description: string;
  mimeType: string;
}

export class MCPHandler {
  private agentTools: AgentTools;
  private dbService: DatabaseService;
  private ragService: RAGService;
  private scraperService: WebScraperService;

  constructor() {
    this.agentTools = new AgentTools();
    this.dbService = new DatabaseService();
    this.ragService = new RAGService();
    this.scraperService = new WebScraperService();
  }

  async initialize(clientInfo: any, capabilities: any) {
    return {
      protocolVersion: '1.0.0',
      serverInfo: {
        name: 'n8n-mcp-automation-server',
        version: '1.0.0',
      },
      capabilities: {
        tools: true,
        resources: true,
        prompts: true,
      },
    };
  }

  async listTools(): Promise<MCPTool[]> {
    return [
      {
        name: 'send_whatsapp_message',
        description: 'Send a WhatsApp message to a contact or group',
        inputSchema: {
          type: 'object',
          properties: {
            recipient: { type: 'string', description: 'Phone number or group ID' },
            message: { type: 'string', description: 'Message to send' },
          },
          required: ['recipient', 'message'],
        },
      },
      {
        name: 'send_telegram_message',
        description: 'Send a Telegram message to a chat',
        inputSchema: {
          type: 'object',
          properties: {
            chatId: { type: 'string', description: 'Chat ID' },
            message: { type: 'string', description: 'Message to send' },
          },
          required: ['chatId', 'message'],
        },
      },
      {
        name: 'query_database',
        description: 'Execute a SQL query on the PostgreSQL database',
        inputSchema: {
          type: 'object',
          properties: {
            query: { type: 'string', description: 'SQL query to execute' },
            params: { type: 'array', description: 'Query parameters' },
          },
          required: ['query'],
        },
      },
      {
        name: 'search_knowledge_base',
        description: 'Search the RAG knowledge base using semantic search',
        inputSchema: {
          type: 'object',
          properties: {
            query: { type: 'string', description: 'Search query' },
            limit: { type: 'number', description: 'Maximum number of results' },
          },
          required: ['query'],
        },
      },
      {
        name: 'scrape_website',
        description: 'Scrape content from a website',
        inputSchema: {
          type: 'object',
          properties: {
            url: { type: 'string', description: 'URL to scrape' },
            selector: { type: 'string', description: 'CSS selector (optional)' },
          },
          required: ['url'],
        },
      },
      {
        name: 'generate_ai_response',
        description: 'Generate AI response using LLM',
        inputSchema: {
          type: 'object',
          properties: {
            prompt: { type: 'string', description: 'Prompt for the AI' },
            model: { type: 'string', description: 'Model to use (openai, gemini, ollama)' },
            context: { type: 'object', description: 'Additional context' },
          },
          required: ['prompt'],
        },
      },
      {
        name: 'text_to_speech',
        description: 'Convert text to speech using ElevenLabs',
        inputSchema: {
          type: 'object',
          properties: {
            text: { type: 'string', description: 'Text to convert' },
            voiceId: { type: 'string', description: 'Voice ID' },
          },
          required: ['text'],
        },
      },
    ];
  }

  async executeTool(name: string, parameters: any): Promise<any> {
    switch (name) {
      case 'send_whatsapp_message':
        return await this.agentTools.sendWhatsAppMessage(parameters.recipient, parameters.message);
      case 'send_telegram_message':
        return await this.agentTools.sendTelegramMessage(parameters.chatId, parameters.message);
      case 'query_database':
        return await this.dbService.query(parameters.query, parameters.params);
      case 'search_knowledge_base':
        return await this.ragService.search(parameters.query, parameters.limit || 5);
      case 'scrape_website':
        return await this.scraperService.scrape(parameters.url, parameters.selector);
      case 'generate_ai_response':
        return await this.agentTools.generateAIResponse(parameters.prompt, parameters.model, parameters.context);
      case 'text_to_speech':
        return await this.agentTools.textToSpeech(parameters.text, parameters.voiceId);
      default:
        throw new Error(`Unknown tool: ${name}`);
    }
  }

  async listResources(): Promise<MCPResource[]> {
    return [
      {
        uri: 'db://conversations',
        name: 'Conversations Database',
        description: 'Access to conversation history',
        mimeType: 'application/json',
      },
      {
        uri: 'kb://documents',
        name: 'Knowledge Base Documents',
        description: 'RAG knowledge base documents',
        mimeType: 'text/plain',
      },
      {
        uri: 'config://agents',
        name: 'Agent Configurations',
        description: 'AI agent configuration files',
        mimeType: 'application/json',
      },
    ];
  }

  async readResource(uri: string): Promise<any> {
    if (uri.startsWith('db://')) {
      const table = uri.split('://')[1];
      return await this.dbService.query(`SELECT * FROM ${table} LIMIT 100`);
    } else if (uri.startsWith('kb://')) {
      return await this.ragService.getAllDocuments();
    } else if (uri.startsWith('config://')) {
      return { message: 'Configuration loading not implemented yet' };
    }
    throw new Error(`Unknown resource URI: ${uri}`);
  }
}
