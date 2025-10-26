# Credentials Template

This file provides templates for setting up credentials in n8n. After importing workflows, configure these credentials in the n8n UI.

## PostgreSQL

**Type**: PostgreSQL  
**Name**: PostgreSQL

```
Host: postgres
Database: n8n
User: n8n
Password: [from .env: DB_POSTGRESDB_PASSWORD]
Port: 5432
SSL: false
```

For RAG database:
```
Host: postgres
Database: rag_database
User: n8n
Password: [from .env: DB_POSTGRESDB_PASSWORD]
Port: 5432
SSL: false
```

---

## OpenAI

**Type**: OpenAI API  
**Name**: OpenAI

```
API Key: [from .env: OPENAI_API_KEY]
```

---

## Telegram

**Type**: Telegram API  
**Name**: Telegram Bot

```
Access Token: [from .env: TELEGRAM_BOT_TOKEN]
```

To get a Telegram bot token:
1. Message [@BotFather](https://t.me/botfather) on Telegram
2. Send `/newbot` command
3. Follow the prompts to create your bot
4. Copy the provided token

---

## Google Gemini (HTTP Header Auth)

**Type**: Header Auth  
**Name**: Gemini API

```
Name: x-goog-api-key
Value: [from .env: GEMINI_API_KEY]
```

To get a Gemini API key:
1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Create a new API key
3. Copy the key

---

## ElevenLabs (HTTP Header Auth)

**Type**: Header Auth  
**Name**: ElevenLabs

```
Name: xi-api-key
Value: [from .env: ELEVENLABS_API_KEY]
```

To get ElevenLabs credentials:
1. Sign up at [ElevenLabs](https://elevenlabs.io/)
2. Go to Profile Settings
3. Copy your API key
4. Go to Voices to find your Voice ID

---

## WhatsApp Business API (HTTP Header Auth)

**Type**: Header Auth  
**Name**: WhatsApp API

```
Name: Authorization
Value: Bearer [from .env: WHATSAPP_ACCESS_TOKEN]
```

To get WhatsApp Business API credentials:
1. Create a [Meta Business Account](https://business.facebook.com/)
2. Set up a WhatsApp Business app
3. Get your Phone Number ID
4. Generate an access token
5. Set up webhook with verify token

---

## Google Cloud (JSON Auth)

**Type**: Google Cloud Platform API  
**Name**: Google Cloud

```
Service Account Email: [from service account JSON]
Private Key: [from service account JSON]
```

To create a service account:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to IAM & Admin > Service Accounts
3. Create a new service account
4. Generate and download JSON key
5. Enable required APIs for your project

---

## Twilio (for alternative WhatsApp)

**Type**: HTTP Header Auth  
**Name**: Twilio

```
Username: [TWILIO_ACCOUNT_SID]
Password: [TWILIO_AUTH_TOKEN]
```

Or use Basic Auth:
```
Account SID: [from .env: TWILIO_ACCOUNT_SID]
Auth Token: [from .env: TWILIO_AUTH_TOKEN]
```

---

## Setting Up Credentials in n8n

1. Log in to n8n at `http://localhost:5678`
2. Click on **Settings** (gear icon) in the bottom left
3. Select **Credentials**
4. Click **Add Credential**
5. Choose the credential type
6. Fill in the required information
7. Click **Save**
8. Use the credential in your workflows

## Testing Credentials

After setting up credentials:

1. Open a workflow that uses the credential
2. Click on a node using that credential
3. Click **Test step** or **Execute node**
4. Verify the connection works
5. Check for any error messages

## Security Notes

- Never share your credentials or commit them to version control
- Rotate API keys regularly
- Use environment variables for sensitive data
- Restrict API key permissions to minimum required
- Monitor API usage for unusual activity
- Use separate credentials for development and production
