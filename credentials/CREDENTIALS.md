# Plantilla de Credenciales

Este archivo proporciona plantillas para configurar credenciales en n8n. Después de importar workflows, configura estas credenciales en la interfaz de n8n.

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
Database: rag_database
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

1. Envía mensaje a [@BotFather](https://t.me/botfather) en Telegram
2. Envía el comando `/newbot`
3. Sigue las instrucciones para crear tu bot
4. Copia el token proporcionado

---

## Google Gemini (Autenticación por Encabezado HTTP)

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

## ElevenLabs (Autenticación por Encabezado HTTP)

**Tipo**: Header Auth  
**Nombre**: ElevenLabs

```sh
Name: xi-api-key
Value: [from .env: ELEVENLABS_API_KEY]

```

Para obtener credenciales de ElevenLabs:

1. Regístrate en [ElevenLabs](https://elevenlabs.io/)
2. Ve a Configuración de Perfil
3. Copia tu clave API
4. Ve a Voices para encontrar tu Voice ID

---

## WhatsApp Business API (Autenticación por Encabezado HTTP)

**Tipo**: Header Auth  
**Nombre**: WhatsApp API

```html
Name: Authorization
Value: Bearer [from .env: WHATSAPP_ACCESS_TOKEN]

```

Para obtener credenciales de WhatsApp Business API:

1. Crea una [Cuenta de Negocio de Meta](https://business.facebook.com/)
2. Configura una app de WhatsApp Business
3. Obtén tu Phone Number ID
4. Genera un token de acceso
5. Configura webhook con token de verificación

---

## Google Cloud (Autenticación JSON)

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

1. Inicia sesión en n8n en `http://localhost:5678`
2. Haz clic en **Settings** (ícono de engranaje) en la esquina inferior izquierda
3. Selecciona **Credentials**
4. Haz clic en **Add Credential**
5. Elige el tipo de credencial
6. Completa la información requerida
7. Haz clic en **Save**
8. Usa la credencial en tus workflows

## Probando Credenciales

Después de configurar credenciales:

1. Abre un workflow que use la credencial
2. Haz clic en un nodo que use esa credencial
3. Haz clic en **Test step** o **Execute node**
4. Verifica que la conexión funcione
5. Revisa cualquier mensaje de error

## Notas de Seguridad

- Nunca compartas tus credenciales o las subas a control de versiones
- Rota las claves API regularmente
- Usa variables de entorno para datos sensibles
- Restringe permisos de claves API al mínimo requerido
- Monitorea el uso de API por actividad inusual
- Usa credenciales separadas para desarrollo y producción
