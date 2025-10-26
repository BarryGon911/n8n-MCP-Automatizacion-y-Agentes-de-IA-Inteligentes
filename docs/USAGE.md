# Guía de Uso

Esta guía explica cómo usar los diversos workflows y características del proyecto n8n Automatización & Agentes de IA.

## Tabla de Contenidos

1. [Comenzando](#comenzando)
2. [Bot de Telegram](#bot-de-telegram)
3. [Bot de WhatsApp](#bot-de-whatsapp)
4. [Web Scraping & RAG](#web-scraping--rag)
5. [Tareas de Agentes de IA](#tareas-de-agentes-de-ia)
6. [Text-to-Speech](#text-to-speech)
7. [Características Avanzadas](#características-avanzadas)

## Comenzando

Después de la instalación, asegúrate de que todos los servicios estén ejecutándose:

```bash
docker-compose ps

```

Accede a n8n en `http://localhost:5678` e inicia sesión con tus credenciales.

## Bot de Telegram

El bot de Telegram proporciona una interfaz conversacional potenciada por IA usando RAG (Generación Aumentada por Recuperación).

### Activando el Bot

1. En n8n, abre el workflow "Telegram Bot with AI Agent"
2. Configura las credenciales de Telegram (token del bot)
3. Configura las credenciales de PostgreSQL y OpenAI
4. Haz clic en el interruptor **Active** para habilitar el workflow

### Usando el Bot

1. Abre Telegram y busca tu bot (usando el nombre de usuario que creaste con @BotFather)
2. Inicia una conversación con `/start`
3. Envía cualquier mensaje para obtener una respuesta potenciada por IA

### Características

- **Respuestas Contextuales**: Usa RAG para recuperar información relevante de tu base de conocimiento
- **Historial de Conversación**: Almacena todas las conversaciones en PostgreSQL
- **Soporte Multi-Modelo**: Puede usar OpenAI GPT-4 o modelos locales de Ollama
- **Seguimiento de Usuarios**: Mantiene perfiles y preferencias de usuarios

### Ejemplos de Conversaciones

```html
Usuario: ¿Qué es n8n?
Bot: n8n es una plataforma de automatización de workflows que te permite conectar 
     diferentes servicios y automatizar tareas. Es una herramienta poderosa para 
     crear automatizaciones complejas sin programar.

Usuario: ¿Cómo uso RAG?
Bot: RAG (Generación Aumentada por Recuperación) combina la recuperación de documentos 
     relevantes con la generación de modelos de lenguaje. Busca en tu base de conocimiento 
     información relevante y usa ese contexto para generar respuestas precisas.

```

## Bot de WhatsApp

El bot de WhatsApp proporciona capacidades de IA similares a través de WhatsApp Business API.

### Requisitos de Configuración

- Cuenta de Meta Business o cuenta de Twilio
- Número verificado de WhatsApp Business
- Webhook configurado para apuntar a tu instancia de n8n

### Activando el Bot

1. Abre el workflow "WhatsApp Bot with AI Agent"
2. Configura tus credenciales de WhatsApp en las variables de entorno
3. Configura el webhook en Meta Business Dashboard:
```

## WhatsApp Bot

The WhatsApp bot provides similar AI capabilities through WhatsApp Business API.

### Setup Requirements

- Meta Business Account or Twilio account
- Verified WhatsApp Business number
- Webhook configured to point to your n8n instance

### Activando el Bot

1. Abre el workflow "WhatsApp Bot with AI Agent"
2. Configura tus credenciales de WhatsApp en las variables de entorno
3. Configura el webhook en Meta Business Dashboard:
   - Webhook URL: `http://your-domain.com:5678/webhook/whatsapp-webhook`
   - Verify Token: (como se establece en tu `.env`)

4. Activa el workflow

### Características

- **Integración con Gemini AI**: Usa Gemini de Google para procesamiento de lenguaje natural
- **Historial de Mensajes**: Almacena todas las conversaciones de WhatsApp
- **Soporte Multi-Usuario**: Maneja múltiples conversaciones simultáneamente

### Probando el Bot

Envía un mensaje a tu número de WhatsApp Business. El bot responderá con contenido generado por IA basado en tu mensaje.

## Web Scraping & RAG

Este workflow automáticamente extrae páginas web y agrega el contenido a tu base de conocimiento RAG.

### Cómo Funciona

1. Se ejecuta según un horario (cada 6 horas por defecto)
2. Recupera URLs de la tabla `scraped_data`
3. Extrae el contenido usando solicitudes HTTP
4. Extrae el contenido de texto usando Cheerio
5. Crea embeddings usando OpenAI
6. Almacena todo en la tabla documents para RAG

### Agregando URLs para Extraer

Conéctate a la base de datos PostgreSQL e inserta URLs:

```sql
INSERT INTO scraped_data (url, is_processed) 
VALUES 
  ('https://docs.n8n.io/', false),
  ('https://en.wikipedia.org/wiki/Artificial_intelligence', false);

```

O usa el workflow de n8n:

1. Crea un workflow simple con un nodo HTTP Request
2. Agrega un nodo PostgreSQL para insertar la URL
3. Deja que el workflow de scraping lo procese

### Viendo Contenido Extraído

```sql
SELECT title, url, scraped_at 
FROM scraped_data 
WHERE is_processed = true 
ORDER BY scraped_at DESC;

```

### Usando RAG en Conversaciones

Los bots de Telegram y WhatsApp usan automáticamente la base de datos RAG para proporcionar respuestas contextuales. El sistema:

1. Recibe un mensaje del usuario
2. Busca en la tabla documents contenido relevante
3. Usa el contenido recuperado como contexto para el modelo de IA
4. Genera una respuesta basada en el contexto y la pregunta

## Tareas de Agentes de IA

El Ejecutor de Tareas de Agentes de IA ejecuta tareas autónomas basadas en entradas en la tabla `agent_tasks`.

### Tipos de Tareas

1. __web_scraping__: Extraer una URL específica
2. __ai_analysis__: Analizar contenido con IA
3. **notification**: Enviar notificaciones

### Creando una Tarea

Inserta una tarea en la base de datos:

```sql
INSERT INTO agent_tasks (task_name, task_type, input_data, status)
VALUES (
  'Analyze Article',
  'ai_analysis',
  '{"prompt": "Summarize the main points of this article: [article text]"}',
  'pending'
);

```

### Monitoreando Tareas

Verifica el estado de las tareas:

```sql
SELECT id, task_name, status, created_at, completed_at
FROM agent_tasks
ORDER BY created_at DESC
LIMIT 10;

```

### Flujo de Trabajo de Tareas

1. El trigger de programación se ejecuta cada 5 minutos
2. Obtiene tareas pendientes
3. Las marca como en ejecución
4. Ejecuta la acción apropiada basada en task_type
5. Guarda el resultado
6. Las marca como completadas

## Text-to-Speech

Convert text to speech using ElevenLabs.

### Usando el Workflow TTS

Activa el workflow "Text-to-Speech with ElevenLabs", luego envía una solicitud POST:

```bash
curl -X POST http://localhost:5678/webhook/tts-request \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello, this is a text to speech test."}'

```

### Integración con Bots

Puedes extender los workflows de Telegram o WhatsApp para incluir TTS:

1. Agrega un nodo HTTP Request después de la generación de respuesta de IA
2. Apúntalo al webhook TTS
3. Envía el texto de respuesta de IA
4. El bot puede luego enviar el archivo de audio de vuelta al usuario

## Características Avanzadas

### Modelos de IA Personalizados

#### Usando Diferentes Modelos de OpenAI

Modifica los nodos del workflow para usar diferentes modelos:

- `gpt-3.5-turbo` (más rápido, más económico)
- `gpt-4` (más preciso, más lento)
```

### Usando Modelos Locales de Ollama

Cambia a Ollama para privacidad y ahorro de costos:

1. Descarga el modelo deseado:

2. Actualiza el workflow para usar el nodo HTTP Request apuntando a:

- `gpt-4-turbo` (balanceado)

2. Actualiza el workflow para usar el nodo HTTP Request apuntando a:

Cambia a Ollama para privacidad y ahorro de costos:

1. Descarga el modelo deseado:

```bash
docker exec -it n8n-mcp-automatizaci-n---agentes-de-ia-inteligentes-ollama-1 ollama pull mistral

```

2. Actualiza el workflow para usar el nodo HTTP Request apuntando a:

```ini
http://ollama:11434/api/generate

```

### Soporte Multi-Idioma

Los bots soportan múltiples idiomas de forma nativa ya que GPT-4, Gemini y otros modelos son multilingües.

### Contexto de Conversación

Mejora las respuestas agregando historial de conversación:

```sql
SELECT message, response 
FROM conversations 
WHERE user_id = 'user123' 
ORDER BY created_at DESC 
LIMIT 5;

```

Usa este contexto en tus prompts de IA para conversaciones más coherentes.

### Analíticas

Rastrea estadísticas de uso:

```sql
-- Messages per platform
SELECT platform, COUNT(*) as message_count
FROM conversations
GROUP BY platform;

-- Most active users
SELECT user_id, COUNT(*) as interactions
FROM conversations
GROUP BY user_id
ORDER BY interactions DESC
LIMIT 10;

-- Workflow execution stats
SELECT workflow_name, status, COUNT(*) as count
FROM workflows_log
GROUP BY workflow_name, status;

```

## Mejores Prácticas

### 1. Limitación de Tasa

Monitorea tu uso de API para evitar alcanzar los límites de tasa:

- OpenAI: Revisa tu panel de uso
- Gemini: Monitorea la cuota en Google Cloud Console
- ElevenLabs: Rastrea el uso de caracteres

### 2. Manejo de Errores

Configura notificaciones de error en n8n:

1. Agrega un nodo "Error Trigger"
2. Conéctalo a un servicio de notificación (Email, Slack, etc.)
3. Recibe alertas cuando fallen los workflows

### 3. Respaldo

Respalda regularmente tu base de datos PostgreSQL:

```bash
docker exec -t postgres pg_dump -U n8n n8n > backup_$(date +%Y%m%d).sql

```

### 4. Seguridad

- Nunca subas tu archivo `.env`
- Usa contraseñas fuertes para n8n y PostgreSQL
- Mantén seguras las claves de API
- Usa HTTPS en producción
- Implementa validación de webhook

### 5. Escalamiento

Para escenarios de alto tráfico:

- Usa pooling de conexiones PostgreSQL
- Agrega limitación de tasa a webhooks
- Considera usar sistemas de cola para procesamiento de tareas
- Escala n8n horizontalmente con múltiples instancias

## Solución de Problemas

### El Bot No Responde

1. Verifica si el workflow está activo
2. Verifica que las credenciales de API sean correctas
3. Revisa los logs de ejecución de n8n
4. Verifica que las URLs de webhook sean accesibles

### Errores de Base de Datos

1. Verifica que PostgreSQL esté ejecutándose: `docker-compose ps postgres`
2. Verifica las credenciales de conexión
3. Revisa los logs de la base de datos: `docker-compose logs postgres`

### Respuestas de IA Lentas

1. Considera usar modelos más rápidos (gpt-3.5-turbo en lugar de gpt-4)
2. Reduce los límites de tokens
3. Usa Ollama local para respuestas más rápidas
4. Optimiza las consultas RAG

## Ejemplos y Casos de Uso

### Bot de Soporte al Cliente

Usa los bots de Telegram/WhatsApp para soporte al cliente automatizado:

1. Agrega la documentación de tu producto a la base de datos RAG
2. Configura el bot para responder preguntas comunes
3. Registra todas las interacciones para análisis

### Monitoreo de Contenido

Usa web scraping para monitorear sitios web de competidores:

1. Agrega URLs de competidores a la lista de scraping
2. Programa scraping regular
3. Configura alertas para cambios significativos

### Creación Automatizada de Contenido

Usa agentes de IA para generar contenido:

1. Crea tareas para resumir artículos
2. Genera publicaciones para redes sociales
3. Crea traducciones

### Asistentes de Voz

Combina los bots con TTS:

1. Recibe entrada de texto de usuarios
2. Genera respuestas de IA
3. Convierte a voz con ElevenLabs
4. Envía audio de vuelta a los usuarios

## Próximos Pasos

- Explora crear workflows personalizados
- Integra con servicios adicionales
- Optimiza el rendimiento para tu caso de uso
- Únete a la comunidad de n8n para soporte e ideas
