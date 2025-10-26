import { WhatsAppService } from '../integrations/whatsapp/service';
import { TelegramService } from '../integrations/telegram/service';
import { ElevenLabsService } from '../integrations/elevenlabs/service';
import { OpenAIAgent } from './openai-agent';
import { GeminiAgent } from './gemini-agent';
import { OllamaAgent } from './ollama-agent';

export class AgentTools {
  private whatsappService: WhatsAppService;
  private telegramService: TelegramService;
  private elevenLabsService: ElevenLabsService;
  private openaiAgent: OpenAIAgent;
  private geminiAgent: GeminiAgent;
  private ollamaAgent: OllamaAgent;

  constructor() {
    this.whatsappService = new WhatsAppService();
    this.telegramService = new TelegramService();
    this.elevenLabsService = new ElevenLabsService();
    this.openaiAgent = new OpenAIAgent();
    this.geminiAgent = new GeminiAgent();
    this.ollamaAgent = new OllamaAgent();
  }

  async sendWhatsAppMessage(recipient: string, message: string): Promise<any> {
    return await this.whatsappService.sendMessage(recipient, message);
  }

  async sendTelegramMessage(chatId: string, message: string): Promise<any> {
    return await this.telegramService.sendMessage(chatId, message);
  }

  async generateAIResponse(prompt: string, model?: string, context?: any): Promise<any> {
    const selectedModel = model || 'openai';

    switch (selectedModel) {
      case 'openai':
        return await this.openaiAgent.execute(prompt, context);
      case 'gemini':
        return await this.geminiAgent.execute(prompt, context);
      case 'ollama':
        return await this.ollamaAgent.execute(prompt, context);
      default:
        return await this.openaiAgent.execute(prompt, context);
    }
  }

  async textToSpeech(text: string, voiceId?: string): Promise<any> {
    return await this.elevenLabsService.textToSpeech(text, voiceId);
  }
}
