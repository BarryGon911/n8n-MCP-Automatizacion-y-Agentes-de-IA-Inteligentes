# Guia de Instalacion

Esta guia te ayudara a configurar el proyecto n8n Automatizacion y Agentes de IA en tu sistema.

## Prerequisitos

Antes de comenzar, asegurate de tener instalado lo siguiente:

- **Docker** (version 20.10 o superior)
- **Docker Compose** (version 2.0 o superior)
- **Git** (para clonar el repositorio)

## Requisitos del Sistema

- **RAM**: Minimo 4GB (8GB recomendados)
- **Espacio en Disco**: Al menos 10GB de espacio libre
- **Sistema Operativo**: Linux, macOS, o Windows con WSL2

## Pasos de Instalacion

### 1. Clonar el Repositorio

```bash
git clone https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes.git
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes

```

### 2. Configurar Variables de Entorno

Copia el archivo de ejemplo de entorno y configuralo:

```bash
cp .env.example .env

```

Edita el archivo `.env` con tu editor de texto preferido:

```bash
nano .env  # or vim, code, etc.

```

**Configuraciones requeridas:**

#### Configuracion Basica de n8n

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

- Descargara todas las imagenes Docker necesarias
- Creara y configurara la base de datos PostgreSQL
- Iniciara la plataforma de automatizacion n8n
- Iniciara el servicio de modelos AI Ollama

### 3. Iniciar los Servicios

Launch all services using Docker Compose:

```bash
docker-compose up -d

```

This command will:

- Download all required Docker images
- Create and configure the PostgreSQL database
- Iniciar la plataforma de automatizacion de workflows n8n
- Iniciara el servicio de modelos AI Ollama

### 4. Verificar Instalacion

Verifica que todos los servicios esten ejecutandose:

```bash
docker-compose ps

```

Deberias ver tres servicios ejecutandose:

- `postgres` (Base de datos PostgreSQL)
- `n8n` (Plataforma de automatizacion n8n)
- `ollama` (Servicio AI Ollama)

### 5. Acceder a n8n

Abre tu navegador web y navega a:

```sh
http://localhost:5678

```

Inicia sesion con las credenciales que configuraste en el archivo `.env`:

- __Nombre de Usuario__: El valor que configuraste para `N8N_BASIC_AUTH_USER`
- __Contrasena__: El valor que configuraste para `N8N_BASIC_AUTH_PASSWORD`

### 6. Inicializar Modelos Ollama

Para usar Ollama para inferencia de IA local, necesitas descargar los modelos:

```bash
# Descargar el modelo llama2
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull llama2

# Optional: Pull other models
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull mistral
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull codellama

```

### 7. Importar Workflows

Los workflows estan ubicados en el directorio `workflows/`. Para importarlos en n8n:

1. Inicia sesion en n8n en `http://localhost:5678`
2. Haz clic en **Workflows** en la barra lateral izquierda
3. Haz clic en el boton **Import from File**
4. Selecciona un archivo JSON de workflow del directorio `workflows/`
5. Repite para cada workflow que quieras usar

## Configuracion de Integraciones

### Configuracion de Bot de Telegram

1. Crea un bot con [@BotFather](https://t.me/botfather) en Telegram
2. Copia el token del bot
3. Agrega el token a tu archivo `.env` como `TELEGRAM_BOT_TOKEN`
4. En n8n, crea una nueva credencial de Telegram con tu token de bot
5. Activa el workflow "Telegram Bot with AI Agent"

### Configuracion de WhatsApp

Tienes dos opciones:

#### Opcion A: WhatsApp Business API (Meta)

1. Configura una [Cuenta de Negocio Meta](https://business.facebook.com/)
2. Crea una App de WhatsApp Business
3. Obten tu Phone Number ID y Access Token
4. Configura la URL del webhook en Meta Dashboard para que apunte a tu instancia n8n
5. Agrega las credenciales al archivo `.env`

#### Opcion B: Twilio WhatsApp

1. Crea una [cuenta Twilio](https://www.twilio.com/)
2. Configura el sandbox de WhatsApp u obten aprobacion para produccion
3. Configura las credenciales de Twilio en `.env`
4. Actualiza el workflow de WhatsApp para usar endpoints de Twilio

### Configuracion de Google Cloud

1. Crea un proyecto en [Google Cloud Console](https://console.cloud.google.com/)
2. Habilita las APIs requeridas (Cloud Storage, Cloud Functions, etc.)
3. Crea una cuenta de servicio y descarga la clave JSON
4. Coloca el archivo JSON en una ubicacion segura
5. Actualiza `GOOGLE_APPLICATION_CREDENTIALS` en `.env`

### Configuracion de OpenAI

1. Crea una cuenta en [OpenAI](https://platform.openai.com/)
2. Genera una clave API
3. Agregala a `.env` como `OPENAI_API_KEY`
4. En n8n, crea una credencial de OpenAI con tu clave API

### Configuracion de Gemini

1. Obten acceso a [Google AI Studio](https://makersuite.google.com/)
2. Genera una clave API
3. Agregala a `.env` como `GEMINI_API_KEY`

### Configuracion de ElevenLabs

1. Crea una cuenta en [ElevenLabs](https://elevenlabs.io/)
2. Obten tu clave API desde la configuracion de perfil
3. Elige una voz y copia su Voice ID
4. Agrega ambos a tu archivo `.env`

## Configuracion de Base de Datos

La base de datos PostgreSQL se inicializa automaticamente con el esquema definido en `database/init.sql`. Esto incluye:

- **documents**: Para almacenamiento RAG (Retrieval-Augmented Generation)
- **conversations**: Almacenamiento de historial de chat
- **users**: Perfiles de usuario y preferencias
- __scraped_data__: Resultados de web scraping
- __agent_tasks__: Cola de tareas de agente autonomo
- __workflows_log__: Logs de ejecucion de workflows

La base de datos usa la extension **pgvector** para busqueda de similitud vectorial, lo que habilita la funcionalidad RAG.

## Solucion de Problemas

### Los servicios no inician

```bash
# Check logs
docker-compose logs

# Restart services
docker-compose down
docker-compose up -d

```

### No puedo acceder a n8n

- Verifica que el servicio este ejecutandose: `docker-compose ps`
- Revisa la configuracion del firewall
- Asegurate de que el puerto 5678 no este en uso por otra aplicacion

### Errores de conexion a base de datos

- Verifica que PostgreSQL este saludable: `docker-compose ps postgres`
- Revisa las credenciales de base de datos en `.env`
- Visualiza los logs de PostgreSQL: `docker-compose logs postgres`

### Los modelos Ollama no cargan

```bash
# Check Ollama service
docker-compose logs ollama

# Verificar que el modelo esta descargado
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama list

```

## Proximos Pasos

Despues de la instalacion, consulta:

- **[Guia de Uso](USAGE.md)** - Aprende como usar los workflows
- **[Guia de Configuracion](CONFIGURATION.md)** - Opciones de configuracion avanzadas
- **[Documentacion de Workflows](workflows/README.md)** - Documentacion detallada de workflows

## Actualizacion

Para actualizar a la ultima version:

```bash
# Pull latest changes
git pull

# Reconstruir y reiniciar servicios
docker-compose down
docker-compose pull
docker-compose up -d

```

## Desinstalacion

Para eliminar completamente el proyecto:

```bash
# Detener y eliminar contenedores
docker-compose down

# Remove volumes (WARNING: This deletes all data)
docker-compose down -v

# Eliminar el directorio del proyecto
cd ..
rm -rf n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes

```
