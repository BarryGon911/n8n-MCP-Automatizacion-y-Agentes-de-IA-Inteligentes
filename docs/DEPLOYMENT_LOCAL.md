# Guia de Deployment Local - n8n + Agentes de IA

Documentacion completa para instalacion local en tu computadora.

Ver documentacion completa en: https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes

## Tabla de Contenidos

1. [Requisitos Previos](#requisitos-previos)
2. [Instalacion Paso a Paso](#instalacion-paso-a-paso)
3. [Configuracion Segura de Credenciales](#configuracion-segura-de-credenciales)
4. [Iniciar Servicios](#iniciar-servicios)
5. [Importar Workflows](#importar-workflows)
6. [Verificar Instalacion](#verificar-instalacion)
7. [Solucion de Problemas](#solucion-de-problemas)

## Requisitos Previos

### Software Necesario

Antes de empezar, asegurate de tener instalado:

- **Docker** (version 20.10 o superior)
- **Docker Compose** (version 2.0 o superior)
- **Git** (para clonar el repositorio)
- **Editor de texto** (VS Code, Nano, Vim, etc.)

### Recursos del Sistema

Requisitos minimos:
- **RAM**: 4GB (recomendado 8GB)
- **Disco**: 10GB libres
- **CPU**: 2 cores (recomendado 4 cores)

### Instalar Docker

Si no tienes Docker instalado:

```bash
# Windows: Descarga Docker Desktop
# https://www.docker.com/products/docker-desktop

# Mac: Descarga Docker Desktop
# https://www.docker.com/products/docker-desktop

# Linux Ubuntu/Debian:
sudo apt update
sudo apt install docker.io docker-compose -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER

# Verifica la instalacion
docker --version
docker-compose --version

```

## Instalacion Paso a Paso

### Paso 1: Clonar el Repositorio

```bash
# Clona el repositorio
git clone https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes.git

# Entra al directorio
cd n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes

# Verifica que tienes todos los archivos
ls -la

```

## Configuracion Segura de Credenciales

### IMPORTANTE: Manejo Seguro de Credenciales

**NUNCA** edites el archivo `.env.example` directamente. Este archivo es una plantilla publica.

**SIEMPRE** crea tu propio archivo `.env` que NO se subira a Git (protegido por `.gitignore`).

### Paso 2: Crear Archivo .env

```bash
# Copia el archivo de ejemplo
cp .env.example .env

# Edita el archivo con tus credenciales
# En Windows (PowerShell):
notepad .env

# En Linux/Mac:
nano .env
# o
code .env

```

### Paso 3: Configurar Variables Criticas

Edita estas variables en tu archivo `.env`:

```bash
# 1. Password de PostgreSQL (crea una segura)
DB_POSTGRESDB_PASSWORD=crea_una_password_fuerte_aqui

# 2. Clave de encriptacion de n8n (32 caracteres aleatorios)
N8N_ENCRYPTION_KEY=genera_clave_aleatoria_32_caracteres

# 3. API Keys (obten las tuyas en los portales de cada servicio)
OPENAI_API_KEY=sk-tu-clave-openai
GEMINI_API_KEY=tu-clave-gemini
ELEVENLABS_API_KEY=tu-clave-elevenlabs

# 4. Token de Telegram Bot (obten de @BotFather)
TELEGRAM_BOT_TOKEN=tu-token-telegram

# 5. WhatsApp (opcional, solo si usaras WhatsApp)
WHATSAPP_VERIFY_TOKEN=crea-token-verificacion
WHATSAPP_ACCESS_TOKEN=tu-access-token-meta

```

### Generar Clave de Encriptacion Segura

```bash
# En Linux/Mac:
openssl rand -hex 32

# En PowerShell (Windows):
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})

# En Git Bash (Windows):
openssl rand -hex 32

# Copia el resultado y pegalo en N8N_ENCRYPTION_KEY en tu archivo .env

```

### Donde Obtener API Keys

- **OpenAI**: https://platform.openai.com/api-keys
- **Google Gemini**: https://makersuite.google.com/app/apikey
- **ElevenLabs**: https://elevenlabs.io/ → Profile Settings
- **Telegram Bot**: Envia `/newbot` a [@BotFather](https://t.me/botfather)
- **WhatsApp**: https://developers.facebook.com/apps/

## Iniciar Servicios

### Paso 4: Ejecutar Script de Setup (Opcional)

```bash
# En Linux/Mac:
chmod +x scripts/setup.sh
./scripts/setup.sh

# En Windows (PowerShell):
# El script es para Linux/Mac, en Windows salta al siguiente paso

```

### Paso 5: Iniciar Docker Compose

```bash
# Inicia todos los servicios en segundo plano
docker-compose up -d

# Ver logs en tiempo real
docker-compose logs -f

# Ver estado de los contenedores
docker-compose ps

```

### Servicios que se Inician

- **n8n** - Puerto 5678 (interfaz web)
- **PostgreSQL** - Puerto 5432 (base de datos)
- **Ollama** - Puerto 11434 (modelos de IA locales)
- **pgAdmin** - Puerto 5050 (opcional, administracion de DB)

### Paso 6: Acceder a n8n

Abre tu navegador y ve a:

**http://localhost:5678**

En el primer acceso:
1. Crea tu usuario administrador
2. Configura tu email y password
3. ¡Listo! Ya puedes usar n8n

## Importar Workflows

### Paso 7: Importar Workflows de Ejemplo

1. En n8n, haz clic en el menu hamburguesa (≡)
2. Selecciona **Workflows** → **Import from File**
3. Navega a la carpeta `workflows/` del proyecto
4. Importa los workflows que necesites:
   - `telegram-ai-bot.json` - Bot de Telegram con IA
   - `whatsapp-ai-bot.json` - Bot de WhatsApp con IA
   - `web-scraping-rag.json` - Web scraping y RAG
   - `ai-agent-executor.json` - Ejecutor de tareas de agentes
   - `elevenlabs-tts.json` - Text-to-Speech

### Paso 8: Configurar Credenciales en n8n

Despues de importar workflows:

1. Abre cada workflow importado
2. Veras nodos con iconos de advertencia (sin credenciales)
3. Haz clic en cada nodo con advertencia
4. Selecciona **Create New Credential**
5. Ingresa los datos segun `credentials/CREDENTIALS.md`

**Importante**: Las credenciales usan las variables de tu archivo `.env`

Ver guia completa: [credentials/CREDENTIALS.md](../credentials/CREDENTIALS.md)

## Verificar Instalacion

### Verificar que Todo Funciona

```bash
# 1. Verifica que todos los contenedores esten corriendo
docker-compose ps

# Debes ver todos los servicios con estado "Up" o "running"

# 2. Verifica logs de n8n
docker-compose logs n8n

# 3. Verifica conexion a PostgreSQL
docker-compose exec postgres psql -U n8n -d n8n -c "\dt"

# 4. Verifica Ollama (opcional)
curl http://localhost:11434/api/tags

```

### Probar un Workflow

1. Abre el workflow `telegram-ai-bot.json`
2. Configura las credenciales de Telegram
3. Activa el workflow (toggle en la esquina superior derecha)
4. Envia un mensaje a tu bot de Telegram
5. Verifica que responda correctamente

## Solucion de Problemas

### Error: Puerto 5678 Ya en Uso

```bash
# Verifica que proceso esta usando el puerto
# Linux/Mac:
lsof -i :5678

# Windows (PowerShell):
Get-NetTCPConnection -LocalPort 5678

# Opcion 1: Detener el proceso que usa el puerto
# Opcion 2: Cambiar el puerto en docker-compose.yml
# Busca la linea: "5678:5678" y cambiala a "5679:5678"

```

### Error: Docker No Encuentra la Imagen

```bash
# Descarga las imagenes manualmente
docker-compose pull

# Reinicia los servicios
docker-compose down
docker-compose up -d

```

### Error: n8n No Puede Conectar a PostgreSQL

```bash
# 1. Verifica que PostgreSQL este corriendo
docker-compose ps postgres

# 2. Verifica los logs de PostgreSQL
docker-compose logs postgres

# 3. Reinicia PostgreSQL
docker-compose restart postgres

# 4. Verifica que la password en .env sea correcta
grep DB_POSTGRESDB_PASSWORD .env

```

### Error: Permisos en Linux

```bash
# Da permisos al usuario actual para Docker
sudo usermod -aG docker $USER

# Cierra sesion y vuelve a iniciar sesion
# O ejecuta:
newgrp docker

# Reinicia Docker
sudo systemctl restart docker

```

### Reiniciar desde Cero

```bash
# ADVERTENCIA: Esto borrara todos los datos

# Detener y eliminar contenedores
docker-compose down

# Eliminar volumenes (borra la base de datos)
docker-compose down -v

# Eliminar imagenes
docker-compose down --rmi all

# Iniciar desde cero
docker-compose up -d

```

## Comandos Utiles

```bash
# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un servicio especifico
docker-compose logs -f n8n

# Reiniciar un servicio
docker-compose restart n8n

# Detener todos los servicios
docker-compose stop

# Iniciar servicios detenidos
docker-compose start

# Ver uso de recursos
docker stats

# Entrar a un contenedor
docker-compose exec n8n sh

# Backup de base de datos
docker-compose exec postgres pg_dump -U n8n n8n > backup.sql

```

## Siguientes Pasos

Ahora que tienes n8n corriendo localmente:

1. **Explora Workflows**: Lee [docs/USAGE.md](USAGE.md) para aprender a usar cada workflow
2. **Crea tus Bots**: Configura tu bot de Telegram o WhatsApp
3. **Aprende RAG**: Implementa busqueda semantica con tus propios datos
4. **Desarrolla**: Crea tus propios workflows personalizados
5. **Produccion**: Cuando estes listo, sigue [docs/DEPLOYMENT_CLOUD.md](DEPLOYMENT_CLOUD.md)

## Soporte

- **Documentacion**: Lee todos los archivos en `/docs/`
- **Issues**: Reporta problemas en GitHub Issues
- **Contribuciones**: Pull requests son bienvenidos

**Repositorio**: https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes
