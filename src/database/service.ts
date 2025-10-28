import { Pool } from 'pg';
import dotenv from 'dotenv';

dotenv.config();

export class DatabaseService {
  private pool: Pool;

  constructor() {
    this.pool = new Pool({
      host: process.env.DB_POSTGRESDB_HOST || 'localhost',
      port: parseInt(process.env.DB_POSTGRESDB_PORT || '5432'),
      database: process.env.DB_POSTGRESDB_DATABASE || 'n8n',
      user: process.env.DB_POSTGRESDB_USER || 'n8n_user',
      password: process.env.DB_POSTGRESDB_PASSWORD || 'changeme',
    });
  }

  async query(text: string, params?: any[]): Promise<any> {
    const client = await this.pool.connect();
    try {
      const result = await client.query(text, params);
      return {
        success: true,
        rows: result.rows,
        rowCount: result.rowCount,
      };
    } catch (error) {
      return {
        success: false,
        error: (error as Error).message,
      };
    } finally {
      client.release();
    }
  }

  async insert(table: string, data: any): Promise<any> {
    const keys = Object.keys(data);
    const values = Object.values(data);
    const placeholders = keys.map((_, i) => `$${i + 1}`).join(', ');
    
    const query = `INSERT INTO ${table} (${keys.join(', ')}) VALUES (${placeholders}) RETURNING *`;
    
    return await this.query(query, values);
  }

  async update(table: string, id: number, data: any): Promise<any> {
    const keys = Object.keys(data);
    const values = Object.values(data);
    const setClause = keys.map((key, i) => `${key} = $${i + 1}`).join(', ');
    
    const query = `UPDATE ${table} SET ${setClause} WHERE id = $${keys.length + 1} RETURNING *`;
    
    return await this.query(query, [...values, id]);
  }

  async delete(table: string, id: number): Promise<any> {
    const query = `DELETE FROM ${table} WHERE id = $1 RETURNING *`;
    return await this.query(query, [id]);
  }

  async close(): Promise<void> {
    await this.pool.end();
  }
}
