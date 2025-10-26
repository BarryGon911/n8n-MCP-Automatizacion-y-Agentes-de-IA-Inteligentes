import { Client, LocalAuth } from 'whatsapp-web.js';
import qrcode from 'qrcode-terminal';
import dotenv from 'dotenv';

dotenv.config();

export class WhatsAppService {
  private client: Client | null = null;
  private isReady: boolean = false;

  constructor() {
    this.initialize();
  }

  private async initialize() {
    this.client = new Client({
      authStrategy: new LocalAuth({
        clientId: process.env.WHATSAPP_SESSION_NAME || 'whatsapp-session',
      }),
      puppeteer: {
        headless: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
      },
    });

    this.client.on('qr', (qr) => {
      console.log('WhatsApp QR Code:');
      qrcode.generate(qr, { small: true });
    });

    this.client.on('ready', () => {
      console.log('WhatsApp client is ready!');
      this.isReady = true;
    });

    this.client.on('authenticated', () => {
      console.log('WhatsApp client authenticated');
    });

    this.client.on('auth_failure', (msg) => {
      console.error('WhatsApp authentication failed:', msg);
    });

    this.client.on('message', async (message) => {
      await this.handleIncomingMessage(message);
    });

    await this.client.initialize();
  }

  async sendMessage(recipient: string, message: string): Promise<any> {
    if (!this.client || !this.isReady) {
      throw new Error('WhatsApp client is not ready');
    }

    const chatId = recipient.includes('@c.us') ? recipient : `${recipient}@c.us`;
    
    try {
      await this.client.sendMessage(chatId, message);
      return {
        success: true,
        recipient,
        message,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  async sendMediaMessage(recipient: string, mediaUrl: string, caption?: string): Promise<any> {
    if (!this.client || !this.isReady) {
      throw new Error('WhatsApp client is not ready');
    }

    const chatId = recipient.includes('@c.us') ? recipient : `${recipient}@c.us`;

    try {
      const { MessageMedia } = await import('whatsapp-web.js');
      const media = await MessageMedia.fromUrl(mediaUrl);
      
      await this.client.sendMessage(chatId, media, { caption });
      
      return {
        success: true,
        recipient,
        mediaUrl,
        timestamp: new Date().toISOString(),
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  private async handleIncomingMessage(message: any) {
    console.log('Received WhatsApp message:', {
      from: message.from,
      body: message.body,
      timestamp: message.timestamp,
    });

    // Here you can add logic to process incoming messages
    // For example, trigger n8n workflows or AI agent responses
  }

  getClient(): Client | null {
    return this.client;
  }
}
