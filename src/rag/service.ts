import OpenAI from 'openai';
import { DatabaseService } from '../database/service';
import dotenv from 'dotenv';

dotenv.config();

export interface Document {
  id?: number;
  title?: string;
  content: string;
  source?: string;
  metadata?: any;
}

export class RAGService {
  private openai: OpenAI;
  private db: DatabaseService;
  private embeddingModel: string;

  constructor() {
    this.openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY,
    });
    this.db = new DatabaseService();
    this.embeddingModel = process.env.EMBEDDING_MODEL || 'text-embedding-ada-002';
  }

  async addDocument(document: Document): Promise<any> {
    try {
      // Generate embedding for the document
      const embedding = await this.generateEmbedding(document.content);

      // Store document with embedding
      const result = await this.db.query(
        `INSERT INTO documents (title, content, source, embedding, metadata) 
         VALUES ($1, $2, $3, $4, $5) RETURNING *`,
        [
          document.title || 'Untitled',
          document.content,
          document.source || 'manual',
          JSON.stringify(embedding),
          JSON.stringify(document.metadata || {}),
        ]
      );

      return {
        success: true,
        document: result.rows[0],
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  async search(query: string, limit: number = 5): Promise<any> {
    try {
      // Generate embedding for the query
      const queryEmbedding = await this.generateEmbedding(query);

      // Search for similar documents using cosine similarity
      const result = await this.db.query(
        `SELECT id, title, content, source, metadata, 
                1 - (embedding <=> $1::vector) as similarity
         FROM documents
         ORDER BY embedding <=> $1::vector
         LIMIT $2`,
        [JSON.stringify(queryEmbedding), limit]
      );

      return {
        success: true,
        results: result.rows,
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  async getAllDocuments(): Promise<any> {
    try {
      const result = await this.db.query(
        'SELECT id, title, content, source, metadata, created_at FROM documents ORDER BY created_at DESC'
      );

      return {
        success: true,
        documents: result.rows,
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  async deleteDocument(id: number): Promise<any> {
    try {
      await this.db.query('DELETE FROM documents WHERE id = $1', [id]);
      return {
        success: true,
        message: `Document ${id} deleted successfully`,
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  private async generateEmbedding(text: string): Promise<number[]> {
    const response = await this.openai.embeddings.create({
      model: this.embeddingModel,
      input: text,
    });

    return response.data[0].embedding;
  }

  async generateRAGResponse(query: string, context?: any): Promise<any> {
    try {
      // Search for relevant documents
      const searchResults = await this.search(query, 3);

      if (!searchResults.success) {
        throw new Error('Failed to search knowledge base');
      }

      // Combine retrieved documents into context
      const retrievedContext = searchResults.results
        .map((doc: any) => `${doc.title}:\n${doc.content}`)
        .join('\n\n');

      // Generate response using retrieved context
      const completion = await this.openai.chat.completions.create({
        model: 'gpt-4-turbo-preview',
        messages: [
          {
            role: 'system',
            content: `You are a helpful assistant. Use the following context to answer the user's question. If the context doesn't contain relevant information, say so.\n\nContext:\n${retrievedContext}`,
          },
          {
            role: 'user',
            content: query,
          },
        ],
      });

      return {
        success: true,
        response: completion.choices[0].message.content,
        sources: searchResults.results.map((doc: any) => ({
          id: doc.id,
          title: doc.title,
          similarity: doc.similarity,
        })),
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }
}
