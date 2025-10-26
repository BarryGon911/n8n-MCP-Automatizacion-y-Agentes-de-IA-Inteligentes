# Installation Guide

This guide will help you set up the n8n Automation & AI Agents project on your system.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Docker** (version 20.10 or higher)
- **Docker Compose** (version 2.0 or higher)
- **Git** (for cloning the repository)

## System Requirements

- **RAM**: Minimum 4GB (8GB recommended)
- **Disk Space**: At least 10GB free space
- **Operating System**: Linux, macOS, or Windows with WSL2

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/BarryGon911/n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes.git
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes
```

### 2. Configure Environment Variables

Copy the example environment file and configure it:

```bash
cp .env.example .env
```

Edit the `.env` file with your preferred text editor:

```bash
nano .env  # or vim, code, etc.
```

**Required configurations:**

#### n8n Basic Setup
```env
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_secure_password
```

#### Database
```env
DB_POSTGRESDB_PASSWORD=your_secure_database_password
```

#### API Keys (configure the ones you plan to use)

**OpenAI:**
```env
OPENAI_API_KEY=sk-your-openai-api-key
```

**Gemini:**
```env
GEMINI_API_KEY=your-gemini-api-key
```

**ElevenLabs:**
```env
ELEVENLABS_API_KEY=your-elevenlabs-api-key
ELEVENLABS_VOICE_ID=your-preferred-voice-id
```

**Telegram Bot:**
```env
TELEGRAM_BOT_TOKEN=your-telegram-bot-token
```

**WhatsApp (Meta Business API):**
```env
WHATSAPP_PHONE_NUMBER_ID=your-phone-number-id
WHATSAPP_ACCESS_TOKEN=your-access-token
WHATSAPP_VERIFY_TOKEN=your-custom-verify-token
```

### 3. Start the Services

Launch all services using Docker Compose:

```bash
docker-compose up -d
```

This command will:
- Download all required Docker images
- Create and configure the PostgreSQL database
- Start the n8n workflow automation platform
- Start the Ollama AI model service

### 4. Verify Installation

Check that all services are running:

```bash
docker-compose ps
```

You should see three services running:
- `postgres` (PostgreSQL database)
- `n8n` (n8n automation platform)
- `ollama` (Ollama AI service)

### 5. Access n8n

Open your web browser and navigate to:

```
http://localhost:5678
```

Login with the credentials you set in the `.env` file:
- **Username**: The value you set for `N8N_BASIC_AUTH_USER`
- **Password**: The value you set for `N8N_BASIC_AUTH_PASSWORD`

### 6. Initialize Ollama Models

To use Ollama for local AI inference, you need to pull the models:

```bash
# Pull the llama2 model
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull llama2

# Optional: Pull other models
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull mistral
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull codellama
```

### 7. Import Workflows

The workflows are located in the `workflows/` directory. To import them into n8n:

1. Log in to n8n at `http://localhost:5678`
2. Click on **Workflows** in the left sidebar
3. Click the **Import from File** button
4. Select a workflow JSON file from the `workflows/` directory
5. Repeat for each workflow you want to use

## Setting Up Integrations

### Telegram Bot Setup

1. Create a bot with [@BotFather](https://t.me/botfather) on Telegram
2. Copy the bot token
3. Add the token to your `.env` file as `TELEGRAM_BOT_TOKEN`
4. In n8n, create a new Telegram credential with your bot token
5. Activate the "Telegram Bot with AI Agent" workflow

### WhatsApp Setup

You have two options:

#### Option A: WhatsApp Business API (Meta)

1. Set up a [Meta Business Account](https://business.facebook.com/)
2. Create a WhatsApp Business App
3. Get your Phone Number ID and Access Token
4. Configure the webhook URL in Meta Dashboard to point to your n8n instance
5. Add credentials to `.env` file

#### Option B: Twilio WhatsApp

1. Create a [Twilio account](https://www.twilio.com/)
2. Set up WhatsApp sandbox or get approval for production
3. Configure Twilio credentials in `.env`
4. Update the WhatsApp workflow to use Twilio endpoints

### Google Cloud Setup

1. Create a project in [Google Cloud Console](https://console.cloud.google.com/)
2. Enable required APIs (Cloud Storage, Cloud Functions, etc.)
3. Create a service account and download the JSON key
4. Place the JSON file in a secure location
5. Update `GOOGLE_APPLICATION_CREDENTIALS` in `.env`

### OpenAI Setup

1. Create an account at [OpenAI](https://platform.openai.com/)
2. Generate an API key
3. Add it to `.env` as `OPENAI_API_KEY`
4. In n8n, create an OpenAI credential with your API key

### Gemini Setup

1. Get access to [Google AI Studio](https://makersuite.google.com/)
2. Generate an API key
3. Add it to `.env` as `GEMINI_API_KEY`

### ElevenLabs Setup

1. Create an account at [ElevenLabs](https://elevenlabs.io/)
2. Get your API key from the profile settings
3. Choose a voice and copy its Voice ID
4. Add both to your `.env` file

## Database Setup

The PostgreSQL database is automatically initialized with the schema defined in `database/init.sql`. This includes:

- **documents**: For RAG (Retrieval-Augmented Generation) storage
- **conversations**: Chat history storage
- **users**: User profiles and preferences
- **scraped_data**: Web scraping results
- **agent_tasks**: Autonomous agent task queue
- **workflows_log**: Workflow execution logs

The database uses the **pgvector** extension for vector similarity search, which enables RAG functionality.

## Troubleshooting

### Services won't start

```bash
# Check logs
docker-compose logs

# Restart services
docker-compose down
docker-compose up -d
```

### Can't access n8n

- Verify the service is running: `docker-compose ps`
- Check firewall settings
- Ensure port 5678 is not in use by another application

### Database connection errors

- Verify PostgreSQL is healthy: `docker-compose ps postgres`
- Check database credentials in `.env`
- View PostgreSQL logs: `docker-compose logs postgres`

### Ollama models not loading

```bash
# Check Ollama service
docker-compose logs ollama

# Verify model is pulled
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama list
```

## Next Steps

After installation, refer to:

- **[Usage Guide](USAGE.md)** - Learn how to use the workflows
- **[Configuration Guide](CONFIGURATION.md)** - Advanced configuration options
- **[Workflows Documentation](workflows/README.md)** - Detailed workflow documentation

## Updating

To update to the latest version:

```bash
# Pull latest changes
git pull

# Rebuild and restart services
docker-compose down
docker-compose pull
docker-compose up -d
```

## Uninstallation

To completely remove the project:

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: This deletes all data)
docker-compose down -v

# Remove the project directory
cd ..
rm -rf n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes
```
