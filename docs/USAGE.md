# Guia de Uso

Esta guia explica como usar los diversos workflows y caracteristicas del proyecto n8n Automatizacion & Agentes de IA.

## Tabla de Contenidos

1. [Comenzando](#comenzando)
2. [Bot de Telegram](#bot-de-telegram)
3. [Bot de WhatsApp](#bot-de-whatsapp)
4. [Web Scraping & RAG](#web-scraping--rag)
5. [Tareas de Agentes de IA](#tareas-de-agentes-de-ia)
6. [Text-to-Speech](#text-to-speech)
7. [Caracteristicas Avanzadas](#caracteristicas-avanzadas)

## Comenzando

Despues de la instalacion, asegurate de que todos los servicios esten ejecutandose:

```bash
docker-compose ps

```

Accede a n8n en `http://localhost:5678` e inicia sesion con tus credenciales.

## Bot de Telegram

El bot de Telegram proporciona una interfaz conversacional potenciada por IA usando RAG (Generacion Aumentada por Recuperacion).

### Activando el Bot

1. En n8n, abre el workflow "Telegram Bot with AI Agent"
2. Configura las credenciales de Telegram (token del bot)
3. Configura las credenciales de PostgreSQL y OpenAI
4. Haz clic en el interruptor **Active** para habilitar el workflow

### Usando el Bot

1. Abre Telegram y busca tu bot (usando el nombre de usuario que creaste con @BotFather)
2. Inicia una conversacion con `/start`
3. Envia cualquier mensaje para obtener una respuesta potenciada por IA

### Caracteristicas

- **Respuestas Contextuales**: Usa RAG para recuperar informacion relevante de tu base de conocimiento
- **Historial de Conversacion**: Almacena todas las conversaciones en PostgreSQL
- **Soporte Multi-Modelo**: Puede usar OpenAI GPT-4 o modelos locales de Ollama
- **Seguimiento de Usuarios**: Mantiene perfiles y preferencias de usuarios

### Ejemplos de Conversaciones

```html
Usuario: Que es n8n?
Bot: n8n es una plataforma de automatizacion de workflows que te permite conectar 
     diferentes servicios y automatizar tareas. Es una herramienta poderosa para 
     crear automatizaciones complejas sin programar.

Usuario: Como uso RAG?
Bot: RAG (Generacion Aumentada por Recuperacion) combina la recuperacion de documentos 
     relevantes con la generacion de modelos de lenguaje. Busca en tu base de conocimiento 
     informacion relevante y usa ese contexto para generar respuestas precisas.

```

## Bot de WhatsApp

El bot de WhatsApp proporciona capacidades de IA similares a traves de WhatsApp Business API.

### Requisitos de Configuracion
<VSCode.Cell id="#VSC-8735c6bc" language="markdown">
## Bot de WhatsApp

El bot de WhatsApp proporciona capacidades de IA similares a traves de WhatsApp Business API.

### Requisitos de Configuracion

- Cuenta de Meta Business o cuenta de Twilio
- Numero verificado de WhatsApp Business
- Webhook configurado para apuntar a tu instancia de n8n

### Activando el Bot

1. Abre el workflow "WhatsApp Bot with AI Agent"
2. Configura tus credenciales de WhatsApp en las variables de entorno
3. Configura el webhook en Meta Business Dashboard:

```md

## WhatsApp Bot

The WhatsApp bot provides similar AI capabilities through WhatsApp Business API.


- Meta Business Account or Twilio account
- Verified WhatsApp Business number
- Webhook configured to point to your n8n instance


1. Abre el workflow "WhatsApp Bot with AI Agent"
2. Configura tus credenciales de WhatsApp en las variables de entorno
3. Configura el webhook en Meta Business Dashboard:
   - Webhook URL: `http://your-domain.com:5678/webhook/whatsapp-webhook`
   - Verify Token: (como se establece en tu `.env`)

4. Activa el workflow


- **Integracion con Gemini AI**: Usa Gemini de Google para procesamiento de lenguaje natural
- **Historial de Mensajes**: Almacena todas las conversaciones de WhatsApp
- **Soporte Multi-Usuario**: Maneja multiples conversaciones simultaneamente


Envia un mensaje a tu numero de WhatsApp Business. El bot respondera con contenido generado por IA basado en tu mensaje.

## Web Scraping & RAG

Este workflow automaticamente extrae paginas web y agrega el contenido a tu base de conocimiento RAG.


1. Se ejecuta segun un horario (cada 6 horas por defecto)
2. Recupera URLs de la tabla `scraped_data`
3. Extrae el contenido usando solicitudes HTTP
4. Extrae el contenido de texto usando Cheerio
5. Crea embeddings usando OpenAI
6. Almacena todo en la tabla documents para RAG


Conectate a la base de datos PostgreSQL e inserta URLs:

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

### Viendo Contenido Extraido

```sql
SELECT title, url, scraped_at 
FROM scraped_data 
WHERE is_processed = true 
ORDER BY scraped_at DESC;

```

### Usando RAG en Conversaciones

Los bots de Telegram y WhatsApp usan automaticamente la base de datos RAG para proporcionar respuestas contextuales. El sistema:

1. Recibe un mensaje del usuario
2. Busca en la tabla documents contenido relevante
3. Usa el contenido recuperado como contexto para el modelo de IA
4. Genera una respuesta basada en el contexto y la pregunta

## Tareas de Agentes de IA

El Ejecutor de Tareas de Agentes de IA ejecuta tareas autonomas basadas en entradas en la tabla `agent_tasks`.

### Tipos de Tareas

1. __web_scraping__: Extraer una URL especifica
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

1. El trigger de programacion se ejecuta cada 5 minutos
2. Obtiene tareas pendientes
3. Las marca como en ejecucion
4. Ejecuta la accion apropiada basada en task_type
5. Guarda el resultado
6. Las marca como completadas

## Text-to-Speech

Convert text to speech using ElevenLabs.

### Usando el Workflow TTS

Activa el workflow "Text-to-Speech with ElevenLabs", luego envia una solicitud POST:

```bash
curl -X POST http://localhost:5678/webhook/tts-request \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello, this is a text to speech test."}'

```

### Integracion con Bots

Puedes extender los workflows de Telegram o WhatsApp para incluir TTS:

1. Agrega un nodo HTTP Request despues de la generacion de respuesta de IA
2. Apuntalo al webhook TTS
3. Envia el texto de respuesta de IA
4. El bot puede luego enviar el archivo de audio de vuelta al usuario

## Caracteristicas Avanzadas

### Modelos de IA Personalizados

#### Usando Diferentes Modelos de OpenAI

Modifica los nodos del workflow para usar diferentes modelos:

- `gpt-3.5-turbo` (mas rapido, mas economico)
- `gpt-4` (mas preciso, mas lento)

```yaml


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

Los bots soportan multiples idiomas de forma nativa ya que GPT-4, Gemini y otros modelos son multilingues.

### Contexto de Conversacion

Mejora las respuestas agregando historial de conversacion:

```sql
SELECT message, response 
FROM conversations 
WHERE user_id = 'user123' 
ORDER BY created_at DESC 
LIMIT 5;

```

Usa este contexto en tus prompts de IA para conversaciones mas coherentes.

### Analiticas

Rastrea estadisticas de uso:

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

## Mejores Practicas

### 1. Limitacion de Tasa

Monitorea tu uso de API para evitar alcanzar los limites de tasa:

- OpenAI: Revisa tu panel de uso
- Gemini: Monitorea la cuota en Google Cloud Console
- ElevenLabs: Rastrea el uso de caracteres

### 2. Manejo de Errores

Configura notificaciones de error en n8n:

1. Agrega un nodo "Error Trigger"
2. Conectalo a un servicio de notificacion (Email, Slack, etc.)
3. Recibe alertas cuando fallen los workflows

### 3. Respaldo

Respalda regularmente tu base de datos PostgreSQL:

```bash
docker exec -t postgres pg_dump -U n8n n8n > backup_$(date +%Y%m%d).sql

```

### 4. Seguridad

- Nunca subas tu archivo `.env`
- Usa contrasenas fuertes para n8n y PostgreSQL
- Manten seguras las claves de API
- Usa HTTPS en produccion
- Implementa validacion de webhook

### 5. Escalamiento

Para escenarios de alto trafico:

- Usa pooling de conexiones PostgreSQL
- Agrega limitacion de tasa a webhooks
- Considera usar sistemas de cola para procesamiento de tareas
- Escala n8n horizontalmente con multiples instancias

## Solucion de Problemas

### El Bot No Responde

1. Verifica si el workflow esta activo
2. Verifica que las credenciales de API sean correctas
3. Revisa los logs de ejecucion de n8n
4. Verifica que las URLs de webhook sean accesibles

### Errores de Base de Datos

1. Verifica que PostgreSQL este ejecutandose: `docker-compose ps postgres`
2. Verifica las credenciales de conexion
3. Revisa los logs de la base de datos: `docker-compose logs postgres`

### Respuestas de IA Lentas

1. Considera usar modelos mas rapidos (gpt-3.5-turbo en lugar de gpt-4)
2. Reduce los limites de tokens
3. Usa Ollama local para respuestas mas rapidas
4. Optimiza las consultas RAG

## Ejemplos y Casos de Uso

### Bot de Soporte al Cliente

Usa los bots de Telegram/WhatsApp para soporte al cliente automatizado:

1. Agrega la documentacion de tu producto a la base de datos RAG
2. Configura el bot para responder preguntas comunes
3. Registra todas las interacciones para analisis

### Monitoreo de Contenido

Usa web scraping para monitorear sitios web de competidores:

1. Agrega URLs de competidores a la lista de scraping
2. Programa scraping regular
3. Configura alertas para cambios significativos

### Creacion Automatizada de Contenido

Usa agentes de IA para generar contenido:

1. Crea tareas para resumir articulos
2. Genera publicaciones para redes sociales
3. Crea traducciones

### Asistentes de Voz

Combina los bots con TTS:

1. Recibe entrada de texto de usuarios
2. Genera respuestas de IA
3. Convierte a voz con ElevenLabs
4. Envia audio de vuelta a los usuarios

## Proximos Pasos

- Explora crear workflows personalizados
- Integra con servicios adicionales
- Optimiza el rendimiento para tu caso de uso
- unete a la comunidad de n8n para soporte e ideas
