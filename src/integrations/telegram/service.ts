import TelegramBot from 'node-telegram-bot-api';
import dotenv from 'dotenv';

dotenv.config();

export class TelegramService {
  private bot: TelegramBot | null = null;

  constructor() {
    this.initialize();
  }

  private async initialize() {
    const token = process.env.TELEGRAM_BOT_TOKEN;
    
    if (!token) {
      console.warn('Telegram bot token not configured');
      return;
    }

    this.bot = new TelegramBot(token, { polling: true });

    this.bot.on('message', async (msg) => {
      await this.handleIncomingMessage(msg);
    });

    this.bot.on('polling_error', (error) => {
      console.error('Telegram polling error:', error);
    });

    console.log('Telegram bot initialized');
  }

  async sendMessage(chatId: string, message: string, options?: any): Promise<any> {
    if (!this.bot) {
      throw new Error('Telegram bot is not initialized');
    }

    try {
      const result = await this.bot.sendMessage(chatId, message, options);
      return {
        success: true,
        chatId,
        messageId: result.message_id,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  async sendPhoto(chatId: string, photo: string, caption?: string): Promise<any> {
    if (!this.bot) {
      throw new Error('Telegram bot is not initialized');
    }

    try {
      const result = await this.bot.sendPhoto(chatId, photo, { caption });
      return {
        success: true,
        chatId,
        messageId: result.message_id,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  async sendDocument(chatId: string, document: string, caption?: string): Promise<any> {
    if (!this.bot) {
      throw new Error('Telegram bot is not initialized');
    }

    try {
      const result = await this.bot.sendDocument(chatId, document, { caption });
      return {
        success: true,
        chatId,
        messageId: result.message_id,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  async sendAudio(chatId: string, audio: string, caption?: string): Promise<any> {
    if (!this.bot) {
      throw new Error('Telegram bot is not initialized');
    }

    try {
      const result = await this.bot.sendAudio(chatId, audio, { caption });
      return {
        success: true,
        chatId,
        messageId: result.message_id,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  private async handleIncomingMessage(msg: TelegramBot.Message) {
    console.log('Received Telegram message:', {
      chatId: msg.chat.id,
      from: msg.from?.username,
      text: msg.text,
      timestamp: msg.date,
    });

    // Here you can add logic to process incoming messages
    // For example, trigger n8n workflows or AI agent responses
  }

  getBot(): TelegramBot | null {
    return this.bot;
  }
}
