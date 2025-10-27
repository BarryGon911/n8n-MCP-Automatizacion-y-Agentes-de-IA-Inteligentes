# Guia de Inicio Rapido

Configura y ejecuta n8n Automatizacion y Agentes de IA en 10 minutos!

## 🚀 Requisitos Previos

Antes de comenzar, asegurate de tener:

- [Docker](https://docs.docker.com/get-docker/) instalado
- [Docker Compose](https://docs.docker.com/compose/install/) instalado
- Al menos 4GB de RAM disponible
- 10GB de espacio libre en disco

## ⚡ Configuracion en 5 Minutos

### Paso 1: Clonar el Repositorio

```bash
git clone https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes.git
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes

```

### Paso 2: Configurar el Entorno

```bash
# Copiar plantilla de entorno
cp .env.example .env

# Editar con tu editor preferido
nano .env

```

**Cambios minimos requeridos:**

```env
N8N_BASIC_AUTH_USER=tuusuario
N8N_BASIC_AUTH_PASSWORD=tucontrasena
DB_POSTGRESDB_PASSWORD=contrasenasegura

```

### Paso 3: Iniciar Servicios

```bash
docker-compose up -d

```

Espera aproximadamente 30 segundos para que los servicios se inicialicen.

### Paso 4: Acceder a n8n

Abre tu navegador y ve a:

```sh
http://localhost:5678

```

Inicia sesion con las credenciales que configuraste en el Paso 2.

**🎉 Felicitaciones! Ahora estas ejecutando n8n con capacidades de IA!**

---

## 🤖 Prueba tu Primer Bot (Telegram)

### 1. Crear un Bot de Telegram

1. Abre Telegram y envia un mensaje a [@BotFather](https://t.me/botfather)
2. Envia `/newbot`
3. Sigue las indicaciones para nombrar tu bot
4. Copia el token del bot (se ve como `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

### 2. Agregar el Token del Bot

Edita tu archivo `.env`:

```env
TELEGRAM_BOT_TOKEN=your-token-here

```

Reiniciar n8n:

```bash
docker-compose restart n8n

```

### 3. Obtener una Clave API de OpenAI

1. Registrate en [OpenAI](https://platform.openai.com/)
2. Genera una clave API
3. Agregala a `.env`:

```env
OPENAI_API_KEY=sk-tu-clave-aqui

```

4. Reiniciar: `docker-compose restart n8n`

### 4. Importar el Workflow de Telegram

1. En n8n, haz clic en **Workflows** → **Import from File**
2. Selecciona `workflows/telegram-ai-bot.json`
3. Haz clic en **Import**

### 5. Configurar Credenciales

**PostgreSQL:**

1. Ve a **Settings** → **Credentials** → **New**
2. Selecciona **PostgreSQL**
3. Completa:

   - Host: `postgres`
   - Database: `n8n`
   - User: `n8n`
   - Password: (de tu archivo `.env`)
   - Port: `5432`

4. Haz clic en **Save**

**OpenAI:**

1. **Settings** → **Credentials** → **New**
2. Selecciona **OpenAI**
3. Ingresa tu clave API
4. Haz clic en **Save**

**Telegram:**

1. **Settings** → **Credentials** → **New**
2. Selecciona **Telegram**
3. Ingresa el token de tu bot
4. Haz clic en **Save**

### 6. Activar el Workflow

1. Abre el workflow "Telegram AI Bot"
2. Conecta las credenciales a cada nodo
3. Haz clic en el interruptor **Active**
4. Prueba enviando un mensaje a tu bot en Telegram!

---

## 🌐 Opcional: IA Local con Ollama

Quieres usar IA sin costos de API? Configura Ollama:

### 1. Descargar un Modelo

```bash
docker exec -it $(docker-compose ps -q ollama) ollama pull llama2

```

Esto descarga el modelo Llama2 (~4GB).

### 2. Actualizar el Workflow

En tu workflow de Telegram:

1. Deshabilita el nodo OpenAI
2. Habilita el nodo HTTP Request de Ollama
3. Guarda y prueba

Ahora tu bot usa IA local - sin costos de API!

---

## 📚 Agregar Conocimiento a tu Bot (RAG)

### 1. Agregar Documentos de Muestra

Conecta a la base de datos:

```bash
docker-compose exec postgres psql -U n8n -d n8n

```

Insertar conocimiento:

```sql
INSERT INTO documents (content, metadata) VALUES 
  ('n8n es una herramienta de automatizacion de workflows que conecta diferentes servicios.', 
   '{"source": "documentacion", "category": "general"}'),
  ('Para crear un webhook en n8n, usa el nodo Webhook y activa el workflow.', 
   '{"source": "documentacion", "category": "tutorial"}');

```

Sal con `\q`

### 2. Probar RAG

Envia un mensaje a tu bot de Telegram:

```sh
Que es n8n?

```

El bot usara tu base de conocimiento para responder!

---

## 🎯 Proximos Pasos

### Explorar Mas Caracteristicas

1. **Bot de WhatsApp**: Configura mensajeria empresarial

   - Ver [docs/INSTALLATION.md](docs/INSTALLATION.md#whatsapp-setup)

2. **Web Scraping**: Recopila contenido automaticamente

   - Importa `workflows/web-scraping-rag.json`
   - Agrega URLs para scraping

3. **Texto a Voz**: Genera audio

   - Obten clave API de ElevenLabs
   - Importa `workflows/elevenlabs-tts.json`

4. **Agentes Autonomos**: Procesamiento de tareas en segundo plano

   - Importa `workflows/ai-agent-executor.json`

### Aprende Mas

- **[Guia Completa de Instalacion](docs/INSTALLATION.md)** - Configuracion detallada
- **[Guia de Uso](docs/USAGE.md)** - Como usar todas las funciones
- **[FAQ](docs/FAQ.md)** - Preguntas frecuentes
- **[Workflows](workflows/README.md)** - Documentacion de workflows

### Obtener Claves API

Necesitaras estas para funcionalidad completa:

| Servicio | Para que es | Consiguelo aqui |

## 📚 Agregar Conocimiento a tu Bot (RAG)

### 1. Add Sample Documents

Connect to the database:

```bash
docker-compose exec postgres psql -U n8n -d n8n

```

Insert knowledge:

```sql
INSERT INTO documents (content, metadata) VALUES 
  ('n8n is a workflow automation tool that connects different services.', 
   '{"source": "documentation", "category": "general"}'),
  ('To create a webhook in n8n, use the Webhook node and activate the workflow.', 
   '{"source": "documentation", "category": "tutorial"}');

```

Exit with `\q`

### 2. Probar RAG

Message your Telegram bot:

```sh
What is n8n?

```

The bot will use your knowledge base to answer!

---

## 🎯 Next Steps

### Explorar Mas Funcionalidades

1. **WhatsApp Bot**: Set up business messaging

   - See [docs/INSTALLATION.md](docs/INSTALLATION.md#whatsapp-setup)

2. **Web Scraping**: Automatically gather content

   - Import `workflows/web-scraping-rag.json`
   - Add URLs to scrape

3. **Text-to-Speech**: Generate audio

   - Get ElevenLabs API key
   - Import `workflows/elevenlabs-tts.json`

4. **Autonomous Agents**: Background task processing

   - Import `workflows/ai-agent-executor.json`

### Aprender Mas

- **[Full Installation Guide](docs/INSTALLATION.md)** - Detailed setup
- **[Usage Guide](docs/USAGE.md)** - How to use all features
- **[FAQ](docs/FAQ.md)** - Common questions
- **[Workflows](workflows/README.md)** - Workflow documentation

### Get API Keys

You'll need these for full functionality:


| Servicio | Para que es | Consiguelo aqui |
|---------|---------------|-------------|
| OpenAI | Respuestas de IA | [platform.openai.com](https://platform.openai.com/) |
| Gemini | IA alternativa | [makersuite.google.com](https://makersuite.google.com/) |
| ElevenLabs | Texto a voz | [elevenlabs.io](https://elevenlabs.io/) |
| Telegram | Bot de Telegram | [@BotFather](https://t.me/botfather) |
| WhatsApp | Bot de WhatsApp | [business.facebook.com](https://business.facebook.com/) |

---

## 🔧 Solucion de Problemas

### Los Servicios No Inician

```bash
# Verificar que esta mal
docker-compose logs

# Reiniciar todo
docker-compose down
docker-compose up -d

```

### No Puedo Acceder a n8n

- Verifica si esta ejecutandose: `docker-compose ps`
- Prueba `http://127.0.0.1:5678` en su lugar
- Verifica la configuracion del firewall

### El Bot No Responde

1. Esta activo el workflow? (el interruptor debe estar ON)
2. Estan configuradas las credenciales?

---

### Necesitas Ayuda?

- Consulta el [FAQ](docs/FAQ.md)
- Revisa la [seccion de solucion de problemas](docs/INSTALLATION.md#troubleshooting)

---

## 📊 Uso de Recursos

Consumo tipico de recursos:

| Servicio | RAM | CPU | Disco |
|---------|-----|-----|------|
| n8n | 200MB | 5% | 500MB |
| PostgreSQL | 100MB | 2% | 1GB+ |
| Ollama (con modelo) | 2GB+ | 10%+ | 4GB+ |

**Consejo**: Si no usas Ollama, puedes eliminarlo de `docker-compose.yml` para ahorrar recursos.

---

## 🎓 Aprende con Ejemplos

### Ejemplo 1: Bot de Soporte al Cliente

1. Importa el workflow de Telegram
2. Agrega FAQs de la empresa a la base de datos RAG
3. Entrena con preguntas comunes
4. Activa y prueba

### Ejemplo 2: Agregador de Contenido

1. Importa el workflow de web scraping
2. Agrega URLs de sitios de noticias a la tabla `scraped_data`
3. Programa ejecuciones cada 6 horas
4. Visualiza el contenido agregado en la base de datos RAG

### Ejemplo 3: Asistente de IA Personal

1. Importa el workflow de Telegram
2. Agrega notas personales y documentos al RAG
3. Usa Ollama local para privacidad
4. Haz preguntas sobre tus notas

---

## 💡 Consejos Pro

1. **Empieza Pequeno**: Comienza con un workflow, luego expande
2. **Usa IA Local**: Ollama es gratuito y privado
3. **Respaldos Regulares**: Ejecuta `./scripts/backup.sh` semanalmente
4. **Monitorea Costos**: Rastrea el uso de API en los dashboards del proveedor
5. **Aseguralo**: Cambia las contrasenas predeterminadas de inmediato
6. **Lee Logs**: Verifica `docker-compose logs` cuando depures

---

**Listo para construir algo increible? Vamos! 🚀**

Para documentacion detallada, consulta el directorio [docs/](docs/).
