import { GoogleGenerativeAI } from '@google/generative-ai';
import dotenv from 'dotenv';

dotenv.config();

export class GeminiAgent {
  private client: GoogleGenerativeAI;
  private model: any;

  constructor() {
    this.client = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || '');
    const modelName = process.env.GEMINI_MODEL || 'gemini-pro';
    this.model = this.client.getGenerativeModel({ model: modelName });
  }

  async execute(task: string, context?: any): Promise<any> {
    let prompt = task;

    if (context?.retrievedDocuments) {
      prompt = `Context from knowledge base:\n${JSON.stringify(context.retrievedDocuments, null, 2)}\n\nTask: ${task}`;
    }

    if (context?.conversationHistory) {
      const history = context.conversationHistory
        .map((msg: any) => `${msg.role}: ${msg.content}`)
        .join('\n');
      prompt = `${history}\n\nUser: ${task}`;
    }

    const result = await this.model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    return {
      content: text,
      model: 'gemini-pro',
    };
  }

  async executeWithChat(task: string, history?: any[]): Promise<any> {
    const chat = this.model.startChat({
      history: history || [],
      generationConfig: {
        maxOutputTokens: 2000,
        temperature: 0.7,
      },
    });

    const result = await chat.sendMessage(task);
    const response = await result.response;
    
    return {
      content: response.text(),
      model: 'gemini-pro',
    };
  }
}
