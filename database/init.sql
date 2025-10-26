-- ================================================
-- Initialization Script for n8n Automation Platform
-- PostgreSQL 15 with pgvector extension for RAG
-- ================================================

-- Enable pgvector extension for vector similarity search
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ================================================
-- SCHEMA: Conversations & Messaging
-- ================================================

-- Table: users
-- Stores user profiles from different platforms (Telegram, WhatsApp)
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    platform VARCHAR(50) NOT NULL,  -- 'telegram', 'whatsapp', etc.
    platform_user_id VARCHAR(255) NOT NULL,
    username VARCHAR(255),
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    language_code VARCHAR(10) DEFAULT 'en',
    preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(platform, platform_user_id)
);

-- Table: conversations
-- Stores all message history across platforms
CREATE TABLE IF NOT EXISTS conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    platform VARCHAR(50) NOT NULL,
    message_type VARCHAR(50) DEFAULT 'text',  -- 'text', 'image', 'audio', etc.
    user_message TEXT,
    bot_response TEXT,
    context JSONB DEFAULT '{}',  -- Additional context (location, attachments, etc.)
    tokens_used INTEGER DEFAULT 0,
    model_used VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_conversations_user_id ON conversations(user_id);
CREATE INDEX idx_conversations_created_at ON conversations(created_at DESC);
CREATE INDEX idx_conversations_platform ON conversations(platform);

-- ================================================
-- SCHEMA: RAG (Retrieval-Augmented Generation)
-- ================================================

-- Table: documents
-- Stores text documents with vector embeddings for similarity search
CREATE TABLE IF NOT EXISTS documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(500),
    content TEXT NOT NULL,
    source_url VARCHAR(1000),
    metadata JSONB DEFAULT '{}',
    embedding vector(1536),  -- OpenAI text-embedding-ada-002 produces 1536-dimensional vectors
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_documents_embedding ON documents USING ivfflat (embedding vector_cosine_ops);
CREATE INDEX idx_documents_source_url ON documents(source_url);
CREATE INDEX idx_documents_created_at ON documents(created_at DESC);

-- Table: scraped_data
-- Queue table for web scraping tasks
CREATE TABLE IF NOT EXISTS scraped_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    url VARCHAR(1000) NOT NULL UNIQUE,
    title VARCHAR(500),
    content TEXT,
    html TEXT,
    status VARCHAR(50) DEFAULT 'pending',  -- 'pending', 'processing', 'completed', 'failed'
    is_processed BOOLEAN DEFAULT FALSE,
    error_message TEXT,
    scraped_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_scraped_data_status ON scraped_data(status);
CREATE INDEX idx_scraped_data_is_processed ON scraped_data(is_processed);
CREATE INDEX idx_scraped_data_url ON scraped_data(url);

-- ================================================
-- SCHEMA: AI Agent Tasks
-- ================================================

-- Table: agent_tasks
-- Queue for autonomous agent tasks
CREATE TABLE IF NOT EXISTS agent_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_type VARCHAR(100) NOT NULL,  -- 'web_scraping', 'ai_analysis', 'notification', etc.
    priority INTEGER DEFAULT 5,  -- 1 (highest) to 10 (lowest)
    status VARCHAR(50) DEFAULT 'pending',  -- 'pending', 'running', 'completed', 'failed'
    input_data JSONB NOT NULL,
    output_data JSONB DEFAULT '{}',
    error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    max_retries INTEGER DEFAULT 3,
    assigned_to VARCHAR(255),  -- Worker/agent identifier
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP,
    completed_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_agent_tasks_status ON agent_tasks(status);
CREATE INDEX idx_agent_tasks_task_type ON agent_tasks(task_type);
CREATE INDEX idx_agent_tasks_priority ON agent_tasks(priority);
CREATE INDEX idx_agent_tasks_created_at ON agent_tasks(created_at DESC);

-- ================================================
-- SCHEMA: Workflow Execution Logs
-- ================================================

-- Table: workflow_logs
-- Tracks workflow execution for debugging and analytics
CREATE TABLE IF NOT EXISTS workflow_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    workflow_name VARCHAR(255) NOT NULL,
    execution_id VARCHAR(255),
    status VARCHAR(50),  -- 'success', 'error', 'running'
    execution_time INTEGER,  -- in milliseconds
    input_data JSONB,
    output_data JSONB,
    error_details TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_workflow_logs_workflow_name ON workflow_logs(workflow_name);
CREATE INDEX idx_workflow_logs_status ON workflow_logs(status);
CREATE INDEX idx_workflow_logs_created_at ON workflow_logs(created_at DESC);

-- ================================================
-- FUNCTIONS: Automated Timestamps
-- ================================================

-- Function to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply auto-update triggers
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_documents_updated_at BEFORE UPDATE ON documents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_scraped_data_updated_at BEFORE UPDATE ON scraped_data
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_agent_tasks_updated_at BEFORE UPDATE ON agent_tasks
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================
-- SEED DATA: Sample Records for Testing
-- ================================================

-- Insert sample URLs for web scraping
INSERT INTO scraped_data (url, status) VALUES
    ('https://docs.n8n.io/', 'pending'),
    ('https://en.wikipedia.org/wiki/Artificial_intelligence', 'pending'),
    ('https://platform.openai.com/docs/', 'pending')
ON CONFLICT (url) DO NOTHING;

-- Insert sample agent task
INSERT INTO agent_tasks (task_type, priority, input_data) VALUES
    ('web_scraping', 3, '{"url": "https://docs.n8n.io/", "selector": "article"}')
ON CONFLICT DO NOTHING;

-- ================================================
-- VIEWS: Convenient Data Access
-- ================================================

-- View: Active conversations summary
CREATE OR REPLACE VIEW active_conversations AS
SELECT 
    u.platform,
    u.username,
    u.first_name,
    COUNT(c.id) as message_count,
    MAX(c.created_at) as last_message_at,
    SUM(c.tokens_used) as total_tokens
FROM users u
LEFT JOIN conversations c ON u.id = c.user_id
GROUP BY u.id, u.platform, u.username, u.first_name
HAVING COUNT(c.id) > 0
ORDER BY MAX(c.created_at) DESC;

-- View: Pending tasks summary
CREATE OR REPLACE VIEW pending_tasks_summary AS
SELECT 
    task_type,
    status,
    priority,
    COUNT(*) as task_count,
    MIN(created_at) as oldest_task,
    MAX(created_at) as newest_task
FROM agent_tasks
WHERE status IN ('pending', 'running')
GROUP BY task_type, status, priority
ORDER BY priority ASC, oldest_task ASC;

-- ================================================
-- GRANTS: Permissions
-- ================================================

-- Grant necessary permissions to n8n user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO n8n;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO n8n;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO n8n;

-- ================================================
-- COMPLETION MESSAGE
-- ================================================

DO $$
BEGIN
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Database initialization completed successfully!';
    RAISE NOTICE 'Tables created: users, conversations, documents, scraped_data, agent_tasks, workflow_logs';
    RAISE NOTICE 'Extensions enabled: vector, uuid-ossp';
    RAISE NOTICE 'Sample data inserted for testing';
    RAISE NOTICE '================================================';
END $$;
