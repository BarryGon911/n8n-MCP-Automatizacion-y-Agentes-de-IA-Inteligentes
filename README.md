# Plataforma de Automatización n8n y Agentes de IA

Una plataforma integral de automatización construida con n8n, que incluye agentes de IA inteligentes, bots de mensajería, RAG (Generación Aumentada por Recuperación) y capacidades de web scraping.

![n8n](https://img.shields.io/badge/n8n-Automatización%20de%20Workflows-orange)
![Docker](https://img.shields.io/badge/Docker-Compose-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue)
![License](https://img.shields.io/badge/licencia-MIT-green)

## 🌟 Características

### 🤖 Chatbots Potenciados por IA

- **Bot de Telegram**: Bot conversacional inteligente con soporte RAG
- **Bot de WhatsApp**: Mensajería empresarial con capacidades de IA
- Soporte multiidioma
- Historial de conversaciones y perfilado de usuarios

### 🧠 Integración de Modelos de IA

- **OpenAI**: GPT-4, GPT-3.5-turbo para comprensión avanzada del lenguaje
- **Google Gemini**: El modelo de IA más reciente de Google
- **Ollama**: Modelos de IA locales (Llama2, Mistral, CodeLlama)
- Cambio flexible de modelos y opciones de respaldo

### 📚 RAG (Generación Aumentada por Recuperación)

- Base de datos vectorial con pgvector
- Generación automática de embeddings
- Respuestas de IA con contexto
- Gestión de base de conocimiento

### 🌐 Web Scraping y Procesamiento de Datos

- Extracción automatizada de contenido
- Workflows de scraping programados
- Indexación de contenido para RAG
- Análisis HTML basado en Cheerio

### 🎙️ Conversión de Texto a Voz

- Integración con ElevenLabs
- Síntesis de voz de alta calidad
- Múltiples opciones de voz
- API basada en webhooks

### 🔄 Agentes Autónomos

- Sistema de cola de tareas
- Múltiples tipos de tareas (scraping, análisis, notificaciones)
- Procesamiento de trabajos en segundo plano
- Seguimiento de estado y registro

### 💾 Gestión de Datos

- Base de datos PostgreSQL con soporte vectorial
- Almacenamiento de historial de conversaciones
- Perfilado y preferencias de usuarios
- Registros de ejecución de workflows

## 🚀 Inicio Rápido

### Requisitos Previos

- Docker (versión 20.10+)
- Docker Compose (versión 2.0+)
- Git

### Instalación

1. **Clonar el repositorio**

```bash
git clone https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes.git
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes


```

2. **Ejecutar el script de configuración**

```bash
./scripts/setup.sh


```

3. **Configurar las variables de entorno**

```bash
cp .env.example .env
nano .env  # Editar con tus credenciales


```

4. **Iniciar los servicios**

```bash
docker-compose up -d


```

5. **Acceder a n8n**

   Abre tu navegador y navega a: `http://localhost:5678`

   Credenciales por defecto:

   - Usuario: `admin`
   - Contraseña: `admin` (cámbiala en `.env`)

Para instrucciones detalladas de instalación, consulta [docs/INSTALLATION.md](docs/INSTALLATION.md).

## 📖 Documentación

- **[Guía de Instalación](docs/INSTALLATION.md)** - Instrucciones completas de configuración
- **[Guía de Uso](docs/USAGE.md)** - Cómo usar los workflows y funciones
- **[Documentación de Workflows](workflows/README.md)** - Explicaciones detalladas de workflows

## 🏗️ Arquitectura

```ini
┌─────────────────────────────────────────────────────────────┐
│                         n8n Platform                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │   Telegram   │  │   WhatsApp   │  │  Web Scraper │      │
│  │     Bot      │  │     Bot      │  │              │      │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘      │
│         │                 │                 │               │
│         └─────────────────┼─────────────────┘               │
│                           │                                 │
│  ┌────────────────────────┼────────────────────────┐       │
│  │         AI Agent Task Executor                   │       │
│  │  ┌─────────┐  ┌─────────┐  ┌──────────────┐   │       │
│  │  │ OpenAI  │  │ Gemini  │  │   Ollama     │   │       │
│  │  └─────────┘  └─────────┘  └──────────────┘   │       │
│  └──────────────────────┬───────────────────────────┘       │
│                         │                                   │
└─────────────────────────┼───────────────────────────────────┘
                          │
        ┌─────────────────┴─────────────────┐
        │      PostgreSQL Database          │
        │  ┌──────────┐  ┌──────────────┐  │
        │  │   RAG    │  │ Conversations │  │
        │  │ (Vector) │  │   & Users     │  │
        │  └──────────┘  └──────────────┘  │
        └───────────────────────────────────┘


```

## 🔧 Configuración

### Variables de Entorno

Variables de entorno clave a configurar en `.env`:

```env
# n8n
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_password

# Database
DB_POSTGRESDB_PASSWORD=your_db_password

# OpenAI
OPENAI_API_KEY=sk-your-key

# Gemini
GEMINI_API_KEY=your-gemini-key

# Telegram
TELEGRAM_BOT_TOKEN=your-bot-token

# WhatsApp
WHATSAPP_ACCESS_TOKEN=your-access-token

# ElevenLabs
ELEVENLABS_API_KEY=your-elevenlabs-key


```

Para una lista completa de opciones de configuración, consulta [.env.example](.env.example).

## 📦 Workflows Incluidos

| Workflow | Descripción | Características Clave |
|----------|-------------|----------------------|
| **Bot de IA Telegram** | Chatbot inteligente de Telegram | RAG, OpenAI/Ollama, historial de conversaciones |
| **Bot de IA WhatsApp** | Bot de WhatsApp Business | Gemini AI, basado en webhooks, registro de mensajes |
| **Web Scraping y RAG** | Extracción automatizada de contenido | Scraping programado, generación de embeddings, almacenamiento vectorial |
| **Texto a Voz** | Convertir texto a audio | ElevenLabs, múltiples voces, API webhook |
| **Ejecutor de Agentes IA** | Procesamiento autónomo de tareas | Cola de tareas, múltiples tipos de tareas, procesamiento en segundo plano |

Consulta [workflows/README.md](workflows/README.md) para documentación detallada de workflows.

## 🛠️ Desarrollo

### Estructura del Proyecto

```ini
.
├── docker-compose.yml      # Configuración de servicios Docker
├── .env.example           # Plantilla de variables de entorno
├── database/
│   └── init.sql          # Script de inicialización de base de datos
├── workflows/            # Archivos JSON de workflows n8n
│   ├── telegram-ai-bot.json
│   ├── whatsapp-ai-bot.json
│   ├── web-scraping-rag.json
│   ├── elevenlabs-tts.json
│   ├── ai-agent-executor.json
│   └── README.md
├── scripts/              # Scripts de utilidad
│   ├── setup.sh         # Script de configuración inicial
│   └── backup.sh        # Script de respaldo de base de datos
└── docs/                # Documentación
    ├── INSTALLATION.md
    └── USAGE.md


```

### Agregar Nuevos Workflows

1. Crear workflow en la interfaz de n8n
2. Exportar como JSON
3. Agregar al directorio `workflows/`
4. Documentar en `workflows/README.md`
5. Actualizar este README

### Database Schema

El proyecto incluye un esquema completo de PostgreSQL con:

- **pgvector**: Extensión para búsquedas vectoriales RAG
- __6 Tablas__: users, conversations, documents, scraped_data, agent_tasks, workflow_logs
- **Índices optimizados**: Para búsquedas rápidas y similitud vectorial
- __Vistas útiles__: active_conversations, pending_tasks_summary
- **Triggers automáticos**: Actualización de timestamps

Ver [database/README.md](database/README.md) para documentación detallada del esquema.

### Respaldo de Base de Datos

Ejecuta el script de respaldo regularmente:

```bash
./scripts/backup.sh


```

Esto crea respaldos con marca de tiempo en el directorio `backups/`.

## 🔐 Mejores Prácticas de Seguridad

1. **Cambia las credenciales por defecto** en el archivo `.env`
2. **Nunca hagas commit** del archivo `.env` en control de versiones
3. **Usa HTTPS** en entornos de producción
4. **Implementa limitación de tasa** en webhooks
5. **Valida las firmas de webhooks** para servicios externos
6. **Mantén las claves API seguras** y rótalas regularmente
7. **Actualiza las imágenes Docker** regularmente para parches de seguridad

## 🚦 Monitoreo y Mantenimiento

### Verificar Estado de Servicios

```bash
docker-compose ps


```

### Ver Registros (Logs)

```bash
# Todos los servicios
docker-compose logs

# Servicio específico
docker-compose logs n8n
docker-compose logs postgres
docker-compose logs ollama


```

### Reiniciar Servicios

```bash
docker-compose restart


```

### Acceso a la Base de Datos

```bash
docker-compose exec postgres psql -U n8n -d n8n


```

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Por favor:

1. Haz un fork del repositorio
2. Crea una rama de funcionalidad
3. Realiza tus cambios
4. Agrega documentación
5. Envía un pull request

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- [n8n](https://n8n.io/) - Plataforma de automatización de workflows
- [OpenAI](https://openai.com/) - Modelos GPT
- [Google](https://ai.google.dev/) - Gemini AI
- [Ollama](https://ollama.ai/) - Modelos de IA locales
- [ElevenLabs](https://elevenlabs.io/) - Conversión de texto a voz
- [PostgreSQL](https://www.postgresql.org/) - Base de datos
- [pgvector](https://github.com/pgvector/pgvector) - Búsqueda de similitud vectorial

## 📞 Soporte

Para problemas, preguntas o sugerencias:

- Consulta la [documentación](docs/)
- Visita la [comunidad de n8n](https://community.n8n.io/)

## 🗺️ Hoja de Ruta

- [ ] Agregar soporte para más modelos de IA (Anthropic Claude, Cohere)
- [ ] Implementar técnicas avanzadas de RAG (búsqueda híbrida, re-ranking)
- [ ] Agregar integración con bot de Discord
- [ ] Crear interfaz web para gestión de workflows
- [ ] Agregar soporte para más idiomas
- [ ] Implementar panel de análisis de conversaciones
- [ ] Agregar soporte de mensajes de voz para bots
- [ ] Crear ejemplos de integración con aplicaciones móviles

## 🌍 Casos de Uso

- **Soporte al Cliente**: Sistemas de respuesta automatizados para empresas
- **Gestión del Conocimiento**: Crear bases de conocimiento consultables con RAG
- **Automatización de Contenido**: Creación y distribución automatizada de contenido
- **Asistente Personal**: Herramientas de productividad personal potenciadas por IA
- **Bots Educativos**: Asistentes de aprendizaje interactivos
- **Inteligencia de Negocios**: Recopilación y análisis automatizado de datos
- **Sistemas de Notificaciones**: Entrega inteligente de alertas y notificaciones

---

**Construido con ❤️ usando n8n e IA**

<!-- Banner centrado -->

<div align="center">

# 🚀 n8n + MCP - Automatización y Agentes de IA Inteligentes

**WhatsApp · Telegram · Bots de Voz · Ollama · Gemini · OpenAI · Google Cloud · ElevenLabs · RAG · PostgreSQL · Web Scraping**

---

<!-- Badges -->

<img src="https://img.shields.io/badge/n8n-Automation-00B2FF?logo=n8n&style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/MCP-Model%20Context%20Protocol-6C63FF?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/RAG-Retrieval%20Augmented%20Generation-FF7A59?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/DB-PostgreSQL-336791?logo=postgresql&style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/Models-Ollama%20|%20OpenAI%20|%20Gemini-22CC88?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/Messaging-WhatsApp%20|%20Telegram-25D366?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/Voice-ElevenLabs-8A2BE2?style=for-the-badge&labelColor=0D1117" />
<img src="https://img.shields.io/badge/License-MIT-black?style=for-the-badge&labelColor=0D1117" />

</div>

---

## ✨ ¿Qué aprenderás?

- Diseñar y automatizar **flujos de trabajo completos** en **n8n** integrando **Google Sheets, Gmail, APIs externas y bases de datos**.
- Construir **agentes de IA con MCP**, conectados a **herramientas personalizadas** y servicios como **Google Calendar**, correo y **modelos**.
- Implementar **casos prácticos avanzados**: **chatbots**, **scraping**, **bots de Telegram/WhatsApp** y **agentes de voz** con datos en tiempo real.
- Crear y administrar **sistemas RAG** para consultar **bases de conocimiento** usando **PostgreSQL** y **Google Drive**.

> Enfoque 100% práctico y orientado a productos.

---

## 🧩 Casos de uso (reales y vendibles)

| Caso | Descripción | Stack recomendado |
|---|---|---|
| Chatbot FAQ empresarial | Responde políticas, soporte y ventas | n8n + RAG (PostgreSQL/Drive) + OpenAI/Ollama |
| Bot de WhatsApp | Atención 24/7 y seguimiento de leads | n8n + WhatsApp API + RAG |
| Bot de Telegram | Notificaciones operativas y comandos | n8n + Telegram Bot API |
| Agente de voz | Recepcionista/IVR con contexto | ElevenLabs/Retell + n8n + RAG |
| Web Scraping | Recolección de precios/noticias | n8n + HTTP/Code + Parse + DB |
| Automatización ofimática | Reportes/recordatorios desde Gmail/Sheets | n8n + Google APIs |

---

## 🛠️ Integraciones clave del proyecto

- **Modelos**: **Ollama**, **OpenAI**, **Gemini**
- **Mensajería**: **WhatsApp**, **Telegram**
- **Voz**: **ElevenLabs**
- **Cloud & Datos**: **Google Cloud**, **PostgreSQL**, **Google Drive**
- **Patrones IA**: **RAG**, **Agentes con MCP**

---

## 🌇️ Arquitectura de alto nivel

```text
Usuarios ──> Canales (WhatsApp/Telegram/Voz)
                │
                ▼
             n8n Orchestrator  ──┬── Conectores (Google, HTTP, DB)
                │                 ├── MCP Tools (acciones externas)
                ▼                 └── Scrapers / Cron Jobs
          Capa de IA (Ollama/OpenAI/Gemini)
                │
                ▼
           RAG: Index + Store (PostgreSQL/Drive)


```

---

## ⚡ Quickstart (modo local)

1. **Requisitos**

- Node.js LTS, Docker (opcional), cuenta(s) de las APIs necesarias.

2. **n8n**

- Auto-hospedaje (Docker) o npx: `npx n8n`

3. **Variables de entorno**

- Agrega tus claves: `OPENAI_API_KEY`, `TELEGRAM_BOT_TOKEN`, `ELEVENLABS_API_KEY`, etc.

4. **Flujos base**

- Importa plantillas de: **Telegram Bot**, **WhatsApp webhook**, **RAG index/query**, **Gmail/Sheets automations**.

5. **Prueba**

- Ejecuta nodos por sección, verifica logs y tokens de rate limit.

> Tip: empieza por un **flujo mínimo** (canal → IA → respuesta) y luego añade **RAG** y **MCP**.

---

## 📂 Estructura sugerida

```ini
/flows
  ├─ messaging/
  ├─ voice/
  ├─ rag/
  └─ ops/
 /docs
  ├─ HOWTOs.md
  └─ env.example.md


```

---

## ✅ Buenas prácticas

- **Desacopla** conectores (mensajería/voz) de la **lógica IA**.
- **Versiona** tus flujos (export JSON) y documenta triggers/webhooks.
- **RAG**: controla tamaño de chunk, embeddings y políticas de refresco.
- **MCP**: define herramientas idempotentes, con validación de input/output.

---

## 📚 Referencias

- Aún por definir

---

<div align="center">

**© Erick S. Ruiz — 2025** · MIT

</div>
