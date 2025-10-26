import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

export class OllamaAgent {
  private baseUrl: string;
  private model: string;

  constructor() {
    this.baseUrl = process.env.OLLAMA_BASE_URL || 'http://localhost:11434';
    this.model = process.env.OLLAMA_MODEL || 'llama2';
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

    const response = await axios.post(`${this.baseUrl}/api/generate`, {
      model: this.model,
      prompt,
      stream: false,
      options: {
        temperature: 0.7,
        num_predict: 2000,
      },
    });

    return {
      content: response.data.response,
      model: this.model,
      context: response.data.context,
    };
  }

  async chat(messages: any[]): Promise<any> {
    const response = await axios.post(`${this.baseUrl}/api/chat`, {
      model: this.model,
      messages,
      stream: false,
    });

    return {
      content: response.data.message.content,
      model: this.model,
    };
  }
}
