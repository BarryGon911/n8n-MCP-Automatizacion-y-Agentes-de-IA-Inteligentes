# Plantilla de Credenciales

Esta guia explica como manejar credenciales de forma segura sin filtrar informacion sensible.

## IMPORTANTE: Seguridad de Credenciales

**NUNCA** subas credenciales reales a Git. Este repositorio ya tiene configurado `.gitignore` para proteger:

- Archivos `.env*` (variables de entorno)
- Archivos `.json`, `.key`, `.pem` en `/credentials/`
- Certificados SSL
- Archivos temporales y backups

## Paso 1: Configurar Variables de Entorno

Las credenciales SIEMPRE deben ir en el archivo `.env` (que NO se sube a Git):

```bash
# Copia el archivo de ejemplo
cp .env.example .env

# Edita el archivo .env con tus credenciales reales
nano .env  # o usa tu editor preferido

```

### Variables Criticas de Seguridad

Edita estas variables en tu archivo `.env`:

```bash
# Base de Datos PostgreSQL
DB_POSTGRESDB_PASSWORD=TU_PASSWORD_SEGURA_AQUI

# n8n Encryption Key (genera una clave unica)
N8N_ENCRYPTION_KEY=genera_una_clave_segura_de_32_caracteres

# APIs de IA
OPENAI_API_KEY=sk-tu-clave-openai-aqui
GEMINI_API_KEY=tu-clave-gemini-aqui
ELEVENLABS_API_KEY=tu-clave-elevenlabs-aqui

# Telegram Bot
TELEGRAM_BOT_TOKEN=tu-bot-token-de-botfather

# WhatsApp Business (opcional)
WHATSAPP_VERIFY_TOKEN=tu-token-verificacion
WHATSAPP_ACCESS_TOKEN=tu-access-token-whatsapp

```

### Generar Claves Seguras

Para generar claves aleatorias seguras:

```bash
# En Linux/Mac - Generar clave de 32 caracteres
openssl rand -hex 32

# En PowerShell (Windows)
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})

# Copia el resultado y pegalo en N8N_ENCRYPTION_KEY

```

## Paso 2: Configurar Credenciales en n8n

Despues de iniciar n8n, configura las credenciales en la interfaz web.
Las credenciales en n8n se almacenan ENCRIPTADAS en la base de datos usando N8N_ENCRYPTION_KEY.

## PostgreSQL

**Tipo**: PostgreSQL  
**Nombre**: PostgreSQL

```yaml
Host: postgres
Database: n8n
User: n8n
Password: [from .env: DB_POSTGRESDB_PASSWORD]
Port: 5432
SSL: false

```

Para base de datos RAG:

```yaml
Host: postgres
Database: n8n
User: n8n
Password: [from .env: DB_POSTGRESDB_PASSWORD]
Port: 5432
SSL: false

```

---

## OpenAI

**Tipo**: OpenAI API  
**Nombre**: OpenAI

```sh
API Key: [from .env: OPENAI_API_KEY]

```

---

## Telegram

**Tipo**: Telegram API  
**Nombre**: Telegram Bot

```sh
Access Token: [from .env: TELEGRAM_BOT_TOKEN]

```

Para obtener un token de bot de Telegram:

1. Envia mensaje a [@BotFather](https://t.me/botfather) en Telegram
2. Envia el comando `/newbot`
3. Sigue las instrucciones para crear tu bot
4. Copia el token proporcionado

---

## Google Gemini (Autenticacion por Encabezado HTTP)

**Tipo**: Header Auth  
**Nombre**: Gemini API

```html
Name: x-goog-api-key
Value: [from .env: GEMINI_API_KEY]

```

Para obtener una clave API de Gemini:

1. Visita [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Crea una nueva clave API
3. Copia la clave

---

## ElevenLabs (Autenticacion por Encabezado HTTP)

**Tipo**: Header Auth  
**Nombre**: ElevenLabs

```sh
Name: xi-api-key
Value: [from .env: ELEVENLABS_API_KEY]

```

Para obtener credenciales de ElevenLabs:

1. Registrate en [ElevenLabs](https://elevenlabs.io/)
2. Ve a Configuracion de Perfil
3. Copia tu clave API
4. Ve a Voices para encontrar tu Voice ID

---

## WhatsApp Business API (Autenticacion por Encabezado HTTP)

**Tipo**: Header Auth  
**Nombre**: WhatsApp API

```html
Name: Authorization
Value: Bearer [from .env: WHATSAPP_ACCESS_TOKEN]

```

Para obtener credenciales de WhatsApp Business API:

1. Crea una [Cuenta de Negocio de Meta](https://business.facebook.com/)
2. Configura una app de WhatsApp Business
3. Obten tu Phone Number ID
4. Genera un token de acceso
5. Configura webhook con token de verificacion

---

## Google Cloud (Autenticacion JSON)

**Tipo**: Google Cloud Platform API  
**Nombre**: Google Cloud

```ini
Service Account Email: [from service account JSON]
Private Key: [from service account JSON]

```

Para crear una cuenta de servicio:

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Navega a IAM & Admin > Service Accounts
3. Crea una nueva cuenta de servicio
4. Genera y descarga la clave JSON
5. Habilita las APIs requeridas para tu proyecto

---

## Twilio (para WhatsApp alternativo)

**Tipo**: HTTP Header Auth  
**Nombre**: Twilio

```html
Username: [TWILIO_ACCOUNT_SID]
Password: [TWILIO_AUTH_TOKEN]

```

O usa Basic Auth:

```sh
Account SID: [from .env: TWILIO_ACCOUNT_SID]
Auth Token: [from .env: TWILIO_AUTH_TOKEN]

```

---

## Configurando Credenciales en n8n

1. Inicia sesion en n8n en `http://localhost:5678`
2. Haz clic en **Settings** (icono de engranaje) en la esquina inferior izquierda
3. Selecciona **Credentials**
4. Haz clic en **Add Credential**
5. Elige el tipo de credencial
6. Completa la informacion requerida
7. Haz clic en **Save**
8. Usa la credencial en tus workflows

## Probando Credenciales

Despues de configurar credenciales:

1. Abre un workflow que use la credencial
2. Haz clic en un nodo que use esa credencial
3. Haz clic en **Test step** o **Execute node**
4. Verifica que la conexion funcione
5. Revisa cualquier mensaje de error

## Notas de Seguridad

- Nunca compartas tus credenciales o las subas a control de versiones
- Rota las claves API regularmente
- Usa variables de entorno para datos sensibles
- Restringe permisos de claves API al minimo requerido
- Monitorea el uso de API por actividad inusual
- Usa credenciales separadas para desarrollo y produccion
