# Architecture Overview

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                          External Services                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐   │
│  │ Telegram │  │ WhatsApp │  │  OpenAI  │  │   ElevenLabs     │   │
│  │   API    │  │   API    │  │   API    │  │      API         │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────────┬─────────┘   │
└───────┼─────────────┼─────────────┼──────────────────┼──────────────┘
        │             │             │                  │
        │ Webhooks    │ Webhooks    │ API Calls        │ API Calls
        │             │             │                  │
┌───────▼─────────────▼─────────────▼──────────────────▼──────────────┐
│                          n8n Platform                                │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                    Workflow Engine                              │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │ │
│  │  │   Telegram   │  │   WhatsApp   │  │  Text-to-Speech      │ │ │
│  │  │   AI Bot     │  │   AI Bot     │  │  (ElevenLabs)        │ │ │
│  │  └──────┬───────┘  └──────┬───────┘  └──────────────────────┘ │ │
│  │         │                 │                                     │ │
│  │  ┌──────▼─────────────────▼────────┐  ┌──────────────────────┐ │ │
│  │  │   Web Scraping & RAG Pipeline   │  │  AI Agent Executor   │ │ │
│  │  └──────┬──────────────────────────┘  └────────┬─────────────┘ │ │
│  └─────────┼──────────────────────────────────────┼────────────────┘ │
│            │                                       │                  │
│  ┌─────────▼───────────────────────────────────────▼────────────────┐ │
│  │                      AI Processing Layer                          │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────────────┐ │ │
│  │  │  OpenAI  │  │  Gemini  │  │  Ollama  │  │   Embeddings    │ │ │
│  │  │  GPT-4   │  │   API    │  │  Local   │  │   (OpenAI)      │ │ │
│  │  └──────────┘  └──────────┘  └────┬─────┘  └─────────────────┘ │ │
│  └───────────────────────────────────┼────────────────────────────┘ │
└────────────────────────────────────────┼──────────────────────────────┘
                                         │
                    ┌────────────────────▼────────────────────┐
                    │         Ollama Service (Local AI)       │
                    │  ┌──────────┐  ┌──────────────────────┐ │
                    │  │  Llama2  │  │  Mistral/CodeLlama  │ │
                    │  └──────────┘  └──────────────────────┘ │
                    └─────────────────────────────────────────┘
                                         │
        ┌────────────────────────────────┼────────────────────────────┐
        │                     PostgreSQL Database                      │
        │  ┌────────────┐  ┌──────────────┐  ┌────────────────────┐  │
        │  │    n8n     │  │      RAG     │  │   Vector Storage   │  │
        │  │ Workflows  │  │   Database   │  │    (pgvector)      │  │
        │  └────────────┘  └──────────────┘  └────────────────────┘  │
        │                                                              │
        │  ┌─────────────────┐  ┌──────────────┐  ┌───────────────┐ │
        │  │  Conversations  │  │    Users     │  │    Scraped    │ │
        │  │    History      │  │   Profiles   │  │     Data      │ │
        │  └─────────────────┘  └──────────────┘  └───────────────┘ │
        │                                                              │
        │  ┌─────────────────┐  ┌──────────────────────────────────┐ │
        │  │  Agent Tasks    │  │       Workflow Logs              │ │
        │  │     Queue       │  │    (Execution Tracking)          │ │
        │  └─────────────────┘  └──────────────────────────────────┘ │
        └──────────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. Messaging Bots (Telegram/WhatsApp)

```
User Message
    ↓
Webhook/Trigger → n8n Workflow
    ↓
Save to conversations table
    ↓
Retrieve context from RAG (vector search)
    ↓
Generate AI response (OpenAI/Gemini/Ollama)
    ↓
Save response to database
    ↓
Send reply to user
```

### 2. Web Scraping & RAG

```
Schedule Trigger (every 6 hours)
    ↓
Fetch unprocessed URLs from scraped_data
    ↓
HTTP Request → Scrape website
    ↓
Extract content with Cheerio
    ↓
Generate embeddings (OpenAI)
    ↓
Store in documents table with vector
    ↓
Mark URL as processed
```

### 3. Autonomous Agent Tasks

```
Schedule Trigger (every 5 minutes)
    ↓
Fetch pending tasks from agent_tasks
    ↓
Update status to 'running'
    ↓
Route by task_type:
    ├─ web_scraping → HTTP Request
    ├─ ai_analysis → OpenAI
    └─ notification → Send message
    ↓
Store output_data
    ↓
Update status to 'completed'
```

## Technology Stack

### Core Platform
- **n8n**: Workflow automation engine
- **Docker**: Containerization
- **Docker Compose**: Multi-container orchestration

### Database
- **PostgreSQL 15**: Relational database
- **pgvector**: Vector similarity search extension

### AI Models
- **OpenAI GPT-4/3.5**: Cloud-based language models
- **Google Gemini**: Google's multimodal AI
- **Ollama**: Self-hosted local models (Llama2, Mistral)

### Messaging Platforms
- **Telegram Bot API**: Telegram integration
- **Meta WhatsApp Business API**: WhatsApp integration
- **Twilio**: Alternative WhatsApp integration

### Additional Services
- **ElevenLabs**: Text-to-speech synthesis
- **Google Cloud**: Cloud services integration
- **Cheerio**: HTML parsing for web scraping

## Security Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Security Layers                          │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Network Security                                         │
│     ├─ Docker network isolation                             │
│     ├─ Port exposure control                                │
│     └─ HTTPS in production (reverse proxy)                  │
│                                                              │
│  2. Authentication & Authorization                           │
│     ├─ n8n basic auth                                       │
│     ├─ Database credentials                                 │
│     ├─ Webhook signature validation                         │
│     └─ API key management                                   │
│                                                              │
│  3. Data Security                                            │
│     ├─ Environment variable isolation                       │
│     ├─ No hardcoded credentials                             │
│     ├─ Database access control                              │
│     └─ Encrypted communication (HTTPS/SSL)                  │
│                                                              │
│  4. Application Security                                     │
│     ├─ Input validation                                     │
│     ├─ Rate limiting                                        │
│     ├─ Error handling                                       │
│     └─ Audit logging                                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Scalability Considerations

### Vertical Scaling
- Increase Docker container resources
- Upgrade database instance
- Add more RAM for Ollama models

### Horizontal Scaling
- Multiple n8n instances with load balancer
- PostgreSQL read replicas
- Redis for caching (future enhancement)
- Message queue for task distribution (future enhancement)

### Performance Optimization
- Database indexing (implemented)
- Connection pooling
- Batch processing
- Caching strategies
- CDN for static assets (if needed)

## Deployment Options

### 1. Development (Current Setup)
- Docker Compose on local machine
- All services on single host
- Perfect for testing and development

### 2. Production (Recommended)
- Cloud hosting (AWS, GCP, Azure, DigitalOcean)
- Managed PostgreSQL database
- HTTPS with SSL certificates
- Domain name with DNS
- Firewall and security groups
- Regular backups
- Monitoring and alerting

### 3. Enterprise
- Kubernetes cluster
- High availability setup
- Auto-scaling
- Multi-region deployment
- Advanced monitoring (Prometheus, Grafana)
- CI/CD pipeline
- Disaster recovery plan

## Monitoring & Observability

### Metrics to Track
- Workflow execution times
- API response times
- Database query performance
- Error rates
- API usage and costs
- Resource utilization (CPU, RAM, disk)
- Active user count
- Message volume

### Logging
- n8n execution logs
- Database query logs
- Application error logs
- Webhook activity logs
- Security audit logs

### Tools (Future Enhancement)
- Prometheus for metrics collection
- Grafana for visualization
- ELK stack for log aggregation
- Uptime monitoring services
- Cost tracking dashboards
