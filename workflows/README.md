# Documentacion de Workflows

Este directorio contiene workflows pre-construidos de n8n para diversas tareas de automatizacion que involucran agentes de IA, plataformas de mensajeria y procesamiento de datos.

## Workflows Disponibles

### 1. Bot de Telegram con Agente de IA (`telegram-ai-bot.json`)

**Descripcion**: Un bot inteligente de Telegram que usa RAG (Generacion Aumentada por Recuperacion) para proporcionar respuestas contextuales.

**Caracteristicas**:

- Recibe mensajes de usuarios de Telegram
- Almacena historial de conversacion en PostgreSQL
- Recupera contexto relevante de la base de datos RAG
- Genera respuestas de IA usando OpenAI u Ollama
- Soporta seguimiento de conversacion y perfiles de usuario

**Nodos**:

- Telegram Trigger
- PostgreSQL (Guardar/Recuperar)
- OpenAI / Ollama
- Telegram Send Message

**Credenciales Requeridas**:

- Telegram Bot API
- PostgreSQL
- OpenAI API (o configurar endpoint de Ollama)

**Casos de Uso**:

- Automatizacion de soporte al cliente
- Preguntas y respuestas de base de conocimiento
- Asistente personal de IA
- Chatbot educativo

---

### 2. Bot de WhatsApp con Agente de IA (`whatsapp-ai-bot.json`)

**Descripcion**: Bot de WhatsApp potenciado por IA usando WhatsApp Business API de Meta y Google Gemini.

**Caracteristicas**:

- Recepcion de mensajes basada en webhook
- Integracion con WhatsApp Business API
- Gemini AI para generacion de respuestas
- Seguimiento de historial de mensajes
- Soporte multi-usuario

**Nodos**:

- Webhook Trigger
- Data Validation
- Message Extraction
- PostgreSQL Storage
- Gemini AI
- WhatsApp API Response

**Credenciales Requeridas**:

- Credenciales de Meta WhatsApp Business API
- PostgreSQL
- Google Gemini API

**Casos de Uso**:

- Servicio al cliente empresarial
- Notificaciones y seguimiento de pedidos
- Programacion de citas
- Consultas de informacion de productos

---

### 3. Web Scraping a Base de Datos RAG (`web-scraping-rag.json`)

**Descripcion**: Workflow automatizado de web scraping que extrae contenido de sitios web y lo almacena en la base de datos RAG con embeddings vectoriales.

**Caracteristicas**:

- Ejecucion programada (cada 6 horas)
- Procesamiento por lotes de URLs
- Extraccion de contenido con Cheerio
- Generacion de embeddings de OpenAI
- Almacenamiento vectorial en PostgreSQL con pgvector

**Nodos**:

- Schedule Trigger
- PostgreSQL (Obtener URLs)
- HTTP Request (Scraping)
- Code Node (extraccion Cheerio)
- OpenAI Embeddings
- PostgreSQL (Almacenar embeddings)

**Credenciales Requeridas**:

- PostgreSQL
- OpenAI API

**Casos de Uso**:

- Construccion de bases de conocimiento
- Inteligencia competitiva
- Agregacion de contenido
- Indexacion de documentacion
- Monitoreo de noticias

---

### 4. Text-to-Speech con ElevenLabs (`elevenlabs-tts.json`)

**Descripcion**: Convierte texto a voz con sonido natural usando la API de ElevenLabs.

**Caracteristicas**:

- Entrada de texto basada en webhook
- Sintesis de voz de alta calidad
- Configuracion de voz personalizable
- Generacion de archivos de audio

**Nodos**:

- Webhook Trigger
- HTTP Request (ElevenLabs API)
- Webhook Response

**Credenciales Requeridas**:

- ElevenLabs API

**Casos de Uso**:

- Generacion de podcasts
- Caracteristicas de accesibilidad
- Notificaciones de voz
- Narracion de contenido
- Aprendizaje de idiomas

---

### 5. Ejecutor de Tareas de Agentes de IA (`ai-agent-executor.json`)

**Descripcion**: Sistema de agentes autonomos que procesa tareas desde una cola, soportando multiples tipos de tareas.

**Caracteristicas**:

- Sondeo programado de tareas (cada 5 minutos)
- Enrutamiento por tipo de tarea (web scraping, analisis de IA, notificaciones)
- Seguimiento de estado (pendiente, ejecutando, completado, fallido)
- Almacenamiento de resultados
- Manejo de errores

**Nodos**:

- Schedule Trigger
- PostgreSQL (Cola de tareas)
- Switch (Enrutador de tipo de tarea)
- HTTP Request (Web scraping)
- OpenAI (Analisis de IA)
- PostgreSQL (Actualizar estado)

**Credenciales Requeridas**:

- PostgreSQL
- OpenAI API

**Casos de Uso**:

- Analisis automatizado de contenido
- Procesamiento por lotes
- Tareas de IA programadas
- Automatizacion de pipeline de datos
- Procesamiento de trabajos en segundo plano

---

## Instrucciones de Importacion de Workflows

### Metodo 1: Via Interfaz de n8n

1. Inicia sesion en n8n en `http://localhost:5678`
2. Haz clic en **Workflows** en la barra lateral izquierda
3. Haz clic en el boton **Import from File**
4. Selecciona el archivo JSON del workflow deseado
5. Haz clic en **Import**
6. Configura credenciales y ajustes
7. Activa el workflow

### Metodo 2: Via Sistema de Archivos

1. Copia los archivos de workflow al directorio de workflows de n8n:

```bash
cp workflows/*.json /path/to/n8n/.n8n/workflows/

```

2. Reinicia n8n
3. Los workflows apareceran en la lista de workflows

### Metodo 3: Via Volumen Docker

Si usas Docker:

```bash
docker cp workflows/telegram-ai-bot.json n8n:/home/node/.n8n/workflows/

```

---

## Configuracion de Workflows

### Configurando Credenciales

Antes de activar workflows, configura las credenciales requeridas:

#### PostgreSQL

1. En n8n, ve a **Credentials** → **New Credential**
2. Selecciona **PostgreSQL**
3. Ingresa:
   - Host: `postgres` (o `localhost` si se ejecuta localmente)
   - Database: `n8n`
   - User: `n8n`
   - Password: (de tu archivo `.env`)
   - Port: `5432`

#### OpenAI

1. Ve a **Credentials** → **New Credential**
2. Selecciona **OpenAI API**
3. Ingresa tu clave API desde `.env`

#### Telegram

1. Ve a **Credentials** → **New Credential**
2. Selecciona **Telegram API**
3. Ingresa tu token de bot desde @BotFather

#### Gemini (HTTP Request Generico)

Configura via nodo HTTP Request con autenticacion de encabezado:

- Header Name: `x-goog-api-key`
- Header Value: Tu clave API de Gemini

#### ElevenLabs (HTTP Request Generico)

Configura via nodo HTTP Request con autenticacion de encabezado:

- Header Name: `xi-api-key`
- Header Value: Tu clave API de ElevenLabs

---

## Guia de Personalizacion

### Modificando Modelos de IA

#### Cambiar Modelo de OpenAI

En cualquier nodo OpenAI, modifica el parametro `model`:

- `gpt-3.5-turbo` - Rapido y economico
- `gpt-4` - Mas capaz
- `gpt-4-turbo` - Rendimiento balanceado

#### Cambiar a Ollama

Reemplaza nodos OpenAI con nodos HTTP Request:

```json
{
  "url": "http://ollama:11434/api/generate",
  "method": "POST",
  "body": {
    "model": "llama2",
    "prompt": "Your prompt here",
    "stream": false
  }
}

```

### Ajustando Horarios

Modifica los nodos Schedule Trigger para cambiar la frecuencia de ejecucion:

- **Minutos**: Para actualizaciones frecuentes (1-59 minutos)
- **Horas**: Para intervalos regulares (1-23 horas)
- **Dias**: Para tareas diarias
- **Expresion Cron**: Para horarios complejos

### Agregando Manejo de Errores

1. Agrega un nodo **Error Trigger** a los workflows
2. Conectalo a servicios de notificacion (Email, Slack, Telegram)
3. Configura logica de reintentos en ajustes de nodo
4. Configura registro de errores en base de datos

---

## Workflow Best Practices

### 1. Testing

Siempre prueba los workflows antes de activarlos:

- Usa el boton **Execute Workflow**
- Prueba con datos de ejemplo
- Verifica todas las credenciales
- Revisa el manejo de errores

### 2. Monitoring

Set up monitoring:

- Enable execution logging
- Configure error notifications
- Track execution times
- Monitor API usage

### 3. Optimization

Improve performance:

- Use batch processing where possible
- Implement caching for frequently accessed data
- Optimize database queries
- Use webhooks instead of polling when available

### 4. Security

Asegura tus workflows:

- Usa variables de entorno para datos sensibles
- Implementa verificacion de webhook
- Agrega limitacion de tasa
- Valida datos de entrada

### 5. Documentacion

Documenta tus personalizaciones:

- Agrega notas a los nodos
- Usa nombres de nodos descriptivos
- Comenta logica compleja
- Manten un changelog

---

## Solucion de Problemas

### El Workflow No Se Activa

**Posibles causas**:

- Credenciales faltantes
- Configuracion invalida
- Problemas de compatibilidad de nodos

**Soluciones**:

- Verifica todas las conexiones de credenciales
- Verifica ajustes de nodos
- Revisa mensajes de error en la interfaz

### El Webhook No Recibe Datos

**Posibles causas**:

- URL de webhook incorrecta
- Firewall bloqueando solicitudes
- Webhook no activado

**Soluciones**:

- Verifica URL de webhook en servicio externo
- Revisa logs de n8n: `docker-compose logs n8n`
- Asegurate de que el workflow este activo
- Prueba con curl o Postman

### Errores de Conexion a Base de Datos

**Posibles causas**:

- PostgreSQL no esta ejecutandose
- Credenciales incorrectas
- Problemas de red

**Soluciones**:

- Verifica que PostgreSQL este ejecutandose: `docker-compose ps postgres`
- Revisa credenciales en n8n
- Prueba la conexion desde linea de comandos

### Respuestas de IA Muy Lentas

**Soluciones**:

- Usa modelos mas rapidos (gpt-3.5-turbo)
- Reduce tokens maximos
- Cambia a Ollama para inferencia local
- Implementa cache

---

## Workflows Avanzados

### Creando Workflows Personalizados

Para crear tu propio workflow:

1. Comienza con un trigger (Webhook, Schedule o Manual)
2. Agrega nodos de procesamiento de datos
3. Integra servicios de IA
4. Almacena resultados en base de datos
5. Agrega notificaciones o respuestas
6. Prueba exhaustivamente
7. Exporta como JSON para control de versiones

### Combinando Workflows

Enlaza workflows juntos:

- Usa el nodo **Execute Workflow** para llamar otros workflows
- Comparte datos via PostgreSQL
- Usa webhooks para comunicacion asincrona
- Implementa arquitectura basada en eventos

---

## Ejemplos de Combinaciones de Workflows

### 1. Sistema Completo de Soporte al Cliente

**Workflows**:

- Bot de Telegram + Bot de WhatsApp
- Web Scraping (para actualizaciones de base de conocimiento)
- Ejecutor de Agentes de IA (para tareas en segundo plano)

**Flujo**:

1. Usuarios envian mensajes via Telegram/WhatsApp
2. RAG recupera documentacion relevante
3. IA genera respuesta
4. Conversacion registrada
5. Consultas complejas encoladas como tareas de agente

### 2. Pipeline de Automatizacion de Contenido

**Workflows**:

- Web Scraping (descubrimiento de contenido)
- Ejecutor de Agentes de IA (analisis de contenido)
- Text-to-Speech (creacion de audio)

**Flujo**:

1. Extraer sitios web para nuevo contenido
2. IA analiza y resume
3. Generar versiones de audio
4. Almacenar y distribuir

---

## Contribuyendo

Para contribuir nuevos workflows:

1. Crea y prueba tu workflow en n8n
2. Exporta como JSON
3. Agrega documentacion
4. Envia un pull request
5. Incluye ejemplos de casos de uso

---

## Soporte

Para problemas especificos de workflows:

- Revisa la guia [USAGE.md](../docs/USAGE.md)
- Consulta [INSTALLATION.md](../docs/INSTALLATION.md)
- Consulta la [documentacion de n8n](https://docs.n8n.io/)
