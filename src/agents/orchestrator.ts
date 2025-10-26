import { OpenAIAgent } from './openai-agent';
import { GeminiAgent } from './gemini-agent';
import { OllamaAgent } from './ollama-agent';

export interface AgentTask {
  type: string;
  input: string;
  context?: any;
}

export interface AgentResult {
  success: boolean;
  output: any;
  metadata?: any;
}

export class AgentOrchestrator {
  private openaiAgent: OpenAIAgent;
  private geminiAgent: GeminiAgent;
  private ollamaAgent: OllamaAgent;

  constructor() {
    this.openaiAgent = new OpenAIAgent();
    this.geminiAgent = new GeminiAgent();
    this.ollamaAgent = new OllamaAgent();
  }

  async executeAgent(agentType: string, task: string, context?: any): Promise<AgentResult> {
    try {
      let result;
      
      switch (agentType) {
        case 'openai':
          result = await this.openaiAgent.execute(task, context);
          break;
        case 'gemini':
          result = await this.geminiAgent.execute(task, context);
          break;
        case 'ollama':
          result = await this.ollamaAgent.execute(task, context);
          break;
        case 'conversational':
          result = await this.executeConversationalAgent(task, context);
          break;
        case 'rag':
          result = await this.executeRAGAgent(task, context);
          break;
        case 'web-scraper':
          result = await this.executeWebScraperAgent(task, context);
          break;
        default:
          throw new Error(`Unknown agent type: ${agentType}`);
      }

      return {
        success: true,
        output: result,
        metadata: {
          agentType,
          timestamp: new Date().toISOString(),
        },
      };
    } catch (error) {
      return {
        success: false,
        output: null,
        metadata: {
          error: (error as Error).message,
          agentType,
          timestamp: new Date().toISOString(),
        },
      };
    }
  }

  private async executeConversationalAgent(task: string, context?: any): Promise<any> {
    // Use the best available model for conversation
    if (process.env.OPENAI_API_KEY) {
      return await this.openaiAgent.execute(task, context);
    } else if (process.env.GEMINI_API_KEY) {
      return await this.geminiAgent.execute(task, context);
    } else {
      return await this.ollamaAgent.execute(task, context);
    }
  }

  private async executeRAGAgent(task: string, context?: any): Promise<any> {
    // RAG agent combines retrieval with generation
    const { RAGService } = await import('../rag/service');
    const ragService = new RAGService();
    
    const relevantDocs = await ragService.search(task, 3);
    const augmentedContext = {
      ...context,
      retrievedDocuments: relevantDocs,
    };

    return await this.openaiAgent.execute(task, augmentedContext);
  }

  private async executeWebScraperAgent(task: string, context?: any): Promise<any> {
    const { WebScraperService } = await import('../utils/web-scraper');
    const scraper = new WebScraperService();
    
    const { url, selector } = context || {};
    if (!url) {
      throw new Error('URL is required for web scraper agent');
    }

    const scrapedContent = await scraper.scrape(url, selector);
    
    // Use AI to process the scraped content based on the task
    return await this.openaiAgent.execute(task, { scrapedContent });
  }
}
