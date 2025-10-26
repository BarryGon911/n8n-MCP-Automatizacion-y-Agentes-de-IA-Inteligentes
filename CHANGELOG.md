# Registro de Cambios

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Versionado Semántico](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-10-26

### Added

- **database/init.sql**: Archivo de inicialización completo de PostgreSQL
  - Extensiones: `vector` (pgvector para RAG) y `uuid-ossp`
  - Tablas: `users`, `conversations`, `documents`, `scraped_data`, `agent_tasks`, `workflow_logs`
  - Índices optimizados para búsquedas vectoriales y consultas frecuentes
  - Triggers automáticos para actualización de timestamps
  - Vistas útiles: `active_conversations`, `pending_tasks_summary`
  - Datos de prueba iniciales para web scraping
  - Permisos configurados correctamente para usuario n8n

### Fixed

- Actualizado `.gitignore` para excluir archivos sensibles pero permitir `database/init.sql`
- Añadidas exclusiones para volúmenes de Docker y archivos IDE

## [1.0.0] - 2025-01-26

### Added

#### Core Infrastructure

- Docker Compose setup with n8n, PostgreSQL, and Ollama
- PostgreSQL database with pgvector extension for RAG
- Automated database initialization with schema creation
- Environment configuration template (.env.example)
- Comprehensive .gitignore for security

#### Workflows

- **Telegram AI Bot**: Intelligent chatbot with RAG support

   - Message handling and response generation
   - Conversation history storage
   - OpenAI and Ollama integration
   - User tracking and profiling

- **WhatsApp AI Bot**: Business messaging automation

   - Meta WhatsApp Business API integration
   - Gemini AI for response generation
   - Webhook-based message handling
   - Multi-user conversation support

- **Web Scraping & RAG**: Automated content extraction

   - Scheduled web scraping (6-hour intervals)
   - Cheerio-based content extraction
   - OpenAI embedding generation
   - Vector storage in PostgreSQL

- **Text-to-Speech**: ElevenLabs integration

   - High-quality voice synthesis
   - Webhook API for easy integration
   - Customizable voice settings

- **AI Agent Task Executor**: Autonomous task processing

   - Task queue system with PostgreSQL
   - Multiple task types support
   - Background job processing
   - Status tracking and error handling

#### Database Schema

- `documents` table for RAG with vector embeddings
- `conversations` table for chat history
- `users` table for user profiles and preferences
- `scraped_data` table for web scraping results
- `agent_tasks` table for autonomous agent tasks
- `workflows_log` table for execution tracking
- Triggers for automatic timestamp updates

#### Documentation

- **INSTALLATION.md**: Complete setup guide

   - Prerequisites and requirements
   - Step-by-step installation
   - Service configuration
   - Integration setup (Telegram, WhatsApp, etc.)
   - Troubleshooting section

- **USAGE.md**: Comprehensive usage guide

   - Getting started instructions
   - Bot usage examples
   - RAG system explanation
   - Web scraping workflows
   - Advanced features and best practices

- **Workflows README**: Detailed workflow documentation

   - Individual workflow descriptions
   - Feature lists and use cases
   - Import instructions
   - Customization guide
   - Troubleshooting tips

- **FAQ.md**: Frequently asked questions

   - General questions
   - Installation help
   - AI model guidance
   - Bot configuration
   - Security tips

- **CREDENTIALS.md**: Credential setup templates

   - Step-by-step credential configuration
   - API key acquisition guides
   - Security recommendations

- **CONTRIBUTING.md**: Contribution guidelines

   - How to contribute
   - Code style standards
   - Workflow contribution process
   - Testing requirements

- **SECURITY.md**: Security policy

   - Vulnerability reporting
   - Security best practices
   - Compliance considerations
   - Incident response procedures

#### Scripts

- **setup.sh**: Automated installation script

   - Docker verification
   - Environment setup
   - Service initialization
   - User guidance

- **backup.sh**: Database backup utility

   - Automated backup creation
   - Timestamp-based file naming
   - Old backup cleanup (30-day retention)
   - Support for multiple databases

#### Database Utilities

- **sample-queries.sql**: Ready-to-use SQL queries
   - RAG database queries
   - Conversation analytics
   - User management
   - Web scraping operations
   - Agent task management
   - Workflow logging
   - Maintenance queries
   - Performance monitoring

#### Features

- Multi-model AI support (OpenAI, Gemini, Ollama)
- RAG with vector similarity search
- Conversation history and context management
- Automated web scraping and indexing
- Text-to-speech generation
- Autonomous agent task processing
- User profiling and preferences
- Comprehensive logging and monitoring
- Error handling and retry mechanisms
- Scalable architecture

### Security

- Environment variable-based configuration
- No hardcoded credentials
- .gitignore protection for sensitive files
- Webhook signature validation support
- Database access controls
- API key rotation support

### Performance

- PostgreSQL with connection pooling
- Efficient vector similarity search with pgvector
- Batch processing capabilities
- Scheduled task execution
- Resource-optimized Docker containers

### Compatibility

- Docker 20.10+
- Docker Compose 2.0+
- PostgreSQL 15 with pgvector
- n8n latest version
- Linux, macOS, Windows (WSL2)

## [Unreleased]

### Planned Features

- Additional AI model integrations (Anthropic Claude, Cohere)
- Advanced RAG techniques (hybrid search, re-ranking)
- Discord bot integration
- Voice message support for messaging bots
- Web interface for workflow management
- Conversation analytics dashboard
- Mobile app integration examples
- Multi-language documentation
- Performance optimization guides
- CI/CD pipeline templates

---

## Version History Legend

- **Added**: New features
- **Changed**: Changes in existing functionality
- **Deprecated**: Soon-to-be removed features
- **Removed**: Removed features
- **Fixed**: Bug fixes
- **Security**: Security improvements

---

For more information about upcoming features, see the project [Roadmap in README.md](README.md#-roadmap).
