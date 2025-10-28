import OpenAI from 'openai';
import dotenv from 'dotenv';

dotenv.config();

export class OpenAIAgent {
  private client: OpenAI;
  private model: string;

  constructor() {
    this.client = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
    this.model = process.env.OPENAI_MODEL || 'gpt-4-turbo-preview';
  }

  async execute(task: string, context?: any): Promise<any> {
    const messages: any[] = [
      {
        role: 'system',
        content: 'You are a helpful AI assistant integrated into an automation platform. You help users with various tasks including answering questions, processing data, and coordinating with other services.',
      },
    ];

    if (context?.retrievedDocuments) {
      messages.push({
        role: 'system',
        content: `Relevant context from knowledge base:\n${JSON.stringify(context.retrievedDocuments, null, 2)}`,
      });
    }

    if (context?.conversationHistory) {
      messages.push(...context.conversationHistory);
    }

    messages.push({
      role: 'user',
      content: task,
    });

    const response = await this.client.chat.completions.create({
      model: this.model,
      messages,
      temperature: 0.7,
      max_tokens: 2000,
    });

    return {
      content: response.choices[0].message.content,
      model: this.model,
      usage: response.usage,
    };
  }

  async executeWithTools(task: string, tools: any[], context?: any): Promise<any> {
    const messages: any[] = [
      {
        role: 'system',
        content: 'You are a helpful AI assistant with access to various tools. Use the tools to help users accomplish their tasks.',
      },
      {
        role: 'user',
        content: task,
      },
    ];

    const response = await this.client.chat.completions.create({
      model: this.model,
      messages,
      tools,
      tool_choice: 'auto',
    });

    return response.choices[0].message;
  }
}
