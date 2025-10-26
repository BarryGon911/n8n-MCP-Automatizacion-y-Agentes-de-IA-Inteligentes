# Guía de Instalación

Esta guía te ayudará a configurar el proyecto n8n Automatización y Agentes de IA en tu sistema.

## Prerequisitos

Antes de comenzar, asegúrate de tener instalado lo siguiente:

- **Docker** (versión 20.10 o superior)
- **Docker Compose** (versión 2.0 o superior)
- **Git** (para clonar el repositorio)

## Requisitos del Sistema

- **RAM**: Mínimo 4GB (8GB recomendados)
- **Espacio en Disco**: Al menos 10GB de espacio libre
- **Sistema Operativo**: Linux, macOS, o Windows con WSL2

## Pasos de Instalación

### 1. Clonar el Repositorio

```bash
git clone https://github.com/BarryGon911/n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes.git
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes

```

### 2. Configurar Variables de Entorno

Copia el archivo de ejemplo de entorno y configúralo:

```bash
cp .env.example .env

```

Edita el archivo `.env` con tu editor de texto preferido:

```bash
nano .env  # or vim, code, etc.

```

**Configuraciones requeridas:**

#### Configuración Básica de n8n

```env
N8N_BASIC_AUTH_USER=your_username
N8N_BASIC_AUTH_PASSWORD=your_secure_password

```

#### Base de Datos

```env
DB_POSTGRESDB_PASSWORD=your_secure_database_password

```

#### Claves API (configura las que planeas usar)

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

**Bot de Telegram:**

```env
TELEGRAM_BOT_TOKEN=your-telegram-bot-token

```

**WhatsApp (Meta Business API):**

```env
WHATSAPP_PHONE_NUMBER_ID=your-phone-number-id
WHATSAPP_ACCESS_TOKEN=your-access-token
WHATSAPP_VERIFY_TOKEN=your-custom-verify-token

```

### 3. Iniciar los Servicios

Inicia todos los servicios usando Docker Compose:

```bash
docker-compose up -d

```

Este comando:

- Descargará todas las imágenes Docker necesarias
- Creará y configurará la base de datos PostgreSQL
- Iniciará la plataforma de automatización n8n
- Iniciará el servicio de modelos AI Ollama

### 3. Start the Services

Launch all services using Docker Compose:

```bash
docker-compose up -d

```

This command will:

- Download all required Docker images
- Create and configure the PostgreSQL database
- Start the n8n workflow automation platform
- Iniciará el servicio de modelos AI Ollama

### 4. Verificar Instalación

Verifica que todos los servicios estén ejecutándose:

```bash
docker-compose ps

```

Deberías ver tres servicios ejecutándose:

- `postgres` (Base de datos PostgreSQL)
- `n8n` (Plataforma de automatización n8n)
- `ollama` (Servicio AI Ollama)

### 5. Acceder a n8n

Abre tu navegador web y navega a:

```sh
http://localhost:5678

```

Inicia sesión con las credenciales que configuraste en el archivo `.env`:

- __Nombre de Usuario__: El valor que configuraste para `N8N_BASIC_AUTH_USER`
- __Contraseña__: El valor que configuraste para `N8N_BASIC_AUTH_PASSWORD`

### 6. Inicializar Modelos Ollama

Para usar Ollama para inferencia de IA local, necesitas descargar los modelos:

```bash
# Pull the llama2 model
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull llama2

# Optional: Pull other models
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull mistral
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull codellama

```

### 7. Importar Workflows

Los workflows están ubicados en el directorio `workflows/`. Para importarlos en n8n:

1. Inicia sesión en n8n en `http://localhost:5678`
2. Haz clic en **Workflows** en la barra lateral izquierda
3. Haz clic en el botón **Import from File**
4. Selecciona un archivo JSON de workflow del directorio `workflows/`
5. Repite para cada workflow que quieras usar

## Configuración de Integraciones

### Configuración de Bot de Telegram

1. Crea un bot con [@BotFather](https://t.me/botfather) en Telegram
2. Copia el token del bot
3. Agrega el token a tu archivo `.env` como `TELEGRAM_BOT_TOKEN`
4. En n8n, crea una nueva credencial de Telegram con tu token de bot
5. Activa el workflow "Telegram Bot with AI Agent"

### Configuración de WhatsApp

Tienes dos opciones:

#### Opción A: WhatsApp Business API (Meta)

1. Configura una [Cuenta de Negocio Meta](https://business.facebook.com/)
2. Crea una App de WhatsApp Business
3. Obtén tu Phone Number ID y Access Token
4. Configura la URL del webhook en Meta Dashboard para que apunte a tu instancia n8n
5. Agrega las credenciales al archivo `.env`

#### Opción B: Twilio WhatsApp

1. Crea una [cuenta Twilio](https://www.twilio.com/)
2. Configura el sandbox de WhatsApp u obtén aprobación para producción
3. Configura las credenciales de Twilio en `.env`
4. Actualiza el workflow de WhatsApp para usar endpoints de Twilio

### Configuración de Google Cloud

1. Crea un proyecto en [Google Cloud Console](https://console.cloud.google.com/)
2. Habilita las APIs requeridas (Cloud Storage, Cloud Functions, etc.)
3. Crea una cuenta de servicio y descarga la clave JSON
4. Coloca el archivo JSON en una ubicación segura
5. Actualiza `GOOGLE_APPLICATION_CREDENTIALS` en `.env`

### Configuración de OpenAI

1. Crea una cuenta en [OpenAI](https://platform.openai.com/)
2. Genera una clave API
3. Agrégala a `.env` como `OPENAI_API_KEY`
4. En n8n, crea una credencial de OpenAI con tu clave API

### Configuración de Gemini

1. Obtén acceso a [Google AI Studio](https://makersuite.google.com/)
2. Genera una clave API
3. Agrégala a `.env` como `GEMINI_API_KEY`

### Configuración de ElevenLabs

1. Crea una cuenta en [ElevenLabs](https://elevenlabs.io/)
2. Obtén tu clave API desde la configuración de perfil
3. Elige una voz y copia su Voice ID
4. Agrega ambos a tu archivo `.env`

## Configuración de Base de Datos

La base de datos PostgreSQL se inicializa automáticamente con el esquema definido en `database/init.sql`. Esto incluye:

- **documents**: Para almacenamiento RAG (Retrieval-Augmented Generation)
- **conversations**: Almacenamiento de historial de chat
- **users**: Perfiles de usuario y preferencias
- __scraped_data__: Resultados de web scraping
- __agent_tasks__: Cola de tareas de agente autónomo
- __workflows_log__: Logs de ejecución de workflows

La base de datos usa la extensión **pgvector** para búsqueda de similitud vectorial, lo que habilita la funcionalidad RAG.

## Solución de Problemas

### Los servicios no inician

```bash
# Check logs
docker-compose logs

# Restart services
docker-compose down
docker-compose up -d

```

### No puedo acceder a n8n

- Verifica que el servicio esté ejecutándose: `docker-compose ps`
- Revisa la configuración del firewall
- Asegúrate de que el puerto 5678 no esté en uso por otra aplicación

### Errores de conexión a base de datos

- Verifica que PostgreSQL esté saludable: `docker-compose ps postgres`
- Revisa las credenciales de base de datos en `.env`
- Visualiza los logs de PostgreSQL: `docker-compose logs postgres`

### Los modelos Ollama no cargan

```bash
# Check Ollama service
docker-compose logs ollama

# Verify model is pulled
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama list

```

## Próximos Pasos

Después de la instalación, consulta:

- **[Guía de Uso](USAGE.md)** - Aprende cómo usar los workflows
- **[Guía de Configuración](CONFIGURATION.md)** - Opciones de configuración avanzadas
- **[Documentación de Workflows](workflows/README.md)** - Documentación detallada de workflows

## Actualización

Para actualizar a la última versión:

```bash
# Pull latest changes
git pull

# Rebuild and restart services
docker-compose down
docker-compose pull
docker-compose up -d

```

## Desinstalación

Para eliminar completamente el proyecto:

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: This deletes all data)
docker-compose down -v

# Remove the project directory
cd ..
rm -rf n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes

```
