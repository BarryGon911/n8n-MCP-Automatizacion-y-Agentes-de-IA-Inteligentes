const { Pool } = require('pg');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

async function runMigrations() {
  const pool = new Pool({
    host: process.env.DB_POSTGRESDB_HOST || 'localhost',
    port: parseInt(process.env.DB_POSTGRESDB_PORT || '5432'),
    database: process.env.DB_POSTGRESDB_DATABASE || 'n8n',
    user: process.env.DB_POSTGRESDB_USER || 'n8n_user',
    password: process.env.DB_POSTGRESDB_PASSWORD || 'changeme',
  });

  try {
    console.log('Connecting to database...');
    const client = await pool.connect();

    console.log('Running migrations...');
    const initSQL = fs.readFileSync(
      path.join(__dirname, 'init.sql'),
      'utf8'
    );

    await client.query(initSQL);
    console.log('Migrations completed successfully!');

    client.release();
  } catch (error) {
    console.error('Migration failed:', error);
    process.exit(1);
  } finally {
    await pool.end();
  }
}

runMigrations();
