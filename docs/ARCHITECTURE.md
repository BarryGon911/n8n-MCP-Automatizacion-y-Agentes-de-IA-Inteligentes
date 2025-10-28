# Resumen de Arquitectura

## Arquitectura del Sistema

```ini
┌─────────────────────────────────────────────────────────────────────┐
│                          External Services                           │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────────────┐   │
│  │ Telegram │  │ WhatsApp │  │  OpenAI  │  │   ElevenLabs     │   │
│  │   API    │  │   API    │  │   API    │  │      API         │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────────┬─────────┘   │
└───────┼─────────────┼─────────────┼──────────────────┼──────────────┘
        │             │             │                  │
        │ Webhooks    │ Webhooks    │ API Calls        │ API Calls
        │             │             │                  │
┌───────▼─────────────▼─────────────▼──────────────────▼──────────────┐
│                          n8n Platform                                │
│  ┌────────────────────────────────────────────────────────────────┐ │
│  │                    Workflow Engine                              │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────────────┐ │ │
│  │  │   Telegram   │  │   WhatsApp   │  │  Text-to-Speech      │ │ │
│  │  │   AI Bot     │  │   AI Bot     │  │  (ElevenLabs)        │ │ │
│  │  └──────┬───────┘  └──────┬───────┘  └──────────────────────┘ │ │
│  │         │                 │                                     │ │
│  │  ┌──────▼─────────────────▼────────┐  ┌──────────────────────┐ │ │
│  │  │   Web Scraping & RAG Pipeline   │  │  AI Agent Executor   │ │ │
│  │  └──────┬──────────────────────────┘  └────────┬─────────────┘ │ │
│  └─────────┼──────────────────────────────────────┼────────────────┘ │
│            │                                       │                  │
│  ┌─────────▼───────────────────────────────────────▼────────────────┐ │
│  │                      AI Processing Layer                          │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌─────────────────┐ │ │
│  │  │  OpenAI  │  │  Gemini  │  │  Ollama  │  │   Embeddings    │ │ │
│  │  │  GPT-4   │  │   API    │  │  Local   │  │   (OpenAI)      │ │ │
│  │  └──────────┘  └──────────┘  └────┬─────┘  └─────────────────┘ │ │
│  └───────────────────────────────────┼────────────────────────────┘ │
└────────────────────────────────────────┼──────────────────────────────┘
                                         │
                    ┌────────────────────▼────────────────────┐
                    │         Ollama Service (Local AI)       │
                    │  ┌──────────┐  ┌──────────────────────┐ │
                    │  │  Llama2  │  │  Mistral/CodeLlama  │ │
                    │  └──────────┘  └──────────────────────┘ │
                    └─────────────────────────────────────────┘
                                         │
        ┌────────────────────────────────┼────────────────────────────┐
        │                     PostgreSQL Database                      │
        │  ┌────────────┐  ┌──────────────┐  ┌────────────────────┐  │
        │  │    n8n     │  │      RAG     │  │   Vector Storage   │  │
        │  │ Workflows  │  │   Database   │  │    (pgvector)      │  │
        │  └────────────┘  └──────────────┘  └────────────────────┘  │
        │                                                              │
        │  ┌─────────────────┐  ┌──────────────┐  ┌───────────────┐ │
        │  │  Conversations  │  │    Users     │  │    Scraped    │ │
        │  │    History      │  │   Profiles   │  │     Data      │ │
        │  └─────────────────┘  └──────────────┘  └───────────────┘ │
        │                                                              │
        │  ┌─────────────────┐  ┌──────────────────────────────────┐ │
        │  │  Agent Tasks    │  │       Workflow Logs              │ │
        │  │     Queue       │  │    (Execution Tracking)          │ │
        │  └─────────────────┘  └──────────────────────────────────┘ │
        └──────────────────────────────────────────────────────────────┘

```

## Data Flow

### 1. Messaging Bots (Telegram/WhatsApp)

## Flujo de Datos

### 1. Bots de Mensajeria (Telegram/WhatsApp)

```ini
Mensaje del Usuario
    ↓
Webhook/Trigger → Workflow n8n
    ↓
Guardar en tabla conversations
    ↓
Recuperar contexto de RAG (busqueda vectorial)
    ↓
Generar respuesta de IA (OpenAI/Gemini/Ollama)
    ↓
Guardar respuesta en base de datos
    ↓
Enviar respuesta al usuario

```

### 2. Web Scraping & RAG

```ini
Trigger Programado (cada 6 horas)
    ↓
Obtener URLs no procesadas de scraped_data
    ↓
HTTP Request → Extraer sitio web
    ↓
Extraer contenido con Cheerio
    ↓
```
```

### 2. Web Scraping & RAG

```ini
Trigger Programado (cada 6 horas)
    ↓
Obtener URLs no procesadas de scraped_data
    ↓
HTTP Request → Extraer sitio web
    ↓
Extraer contenido con Cheerio
    ↓
Generar embeddings (OpenAI)
    ↓
Almacenar en tabla documents con vector
    ↓
Marcar URL como procesada

```

### 3. Tareas de Agentes Autonomos

```ini
Trigger Programado (cada 5 minutos)
    ↓
Obtener tareas pendientes de agent_tasks
    ↓
Actualizar estado a 'running'
    ↓
Enrutar por task_type:
    ├─ web_scraping → HTTP Request
    ├─ ai_analysis → OpenAI
    └─ notification → Enviar mensaje
    ↓
Almacenar output_data
    ↓
Actualizar estado a 'completed'

```

## Stack Tecnologico

### Plataforma Principal

- **n8n**: Motor de automatizacion de workflows
- **Docker**: Contenedorizacion
- **Docker Compose**: Orquestacion multi-contenedor

### Base de Datos

- **PostgreSQL 15**: Base de datos relacional
- **pgvector**: Extension de busqueda por similitud vectorial

### Modelos de IA

- **OpenAI GPT-4/3.5**: Modelos de lenguaje basados en la nube
- **Google Gemini**: IA multimodal de Google
- **Ollama**: Modelos locales auto-hospedados (Llama2, Mistral)

### Plataformas de Mensajeria

- **Telegram Bot API**: Integracion con Telegram
- **Meta WhatsApp Business API**: Integracion con WhatsApp
- **Twilio**: Integracion alternativa con WhatsApp

### Servicios Adicionales

- **ElevenLabs**: Sintesis de texto a voz
- **Google Cloud**: Integracion de servicios en la nube
- **Cheerio**: Analisis HTML para web scraping

## Arquitectura de Seguridad

```ini
┌─────────────────────────────────────────────────────────────┐
│                     Capas de Seguridad                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Seguridad de Red                                         │
│     ├─ Aislamiento de red Docker                            │
│     ├─ Control de exposicion de puertos                     │
````
```

## Security Architecture

```ini
┌─────────────────────────────────────────────────────────────┐
│                     Capas de Seguridad                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Seguridad de Red                                         │
│     ├─ Aislamiento de red Docker                            │
│     ├─ Control de exposicion de puertos                     │
│     └─ HTTPS en produccion (proxy inverso)                  │
│                                                              │
│  2. Autenticacion & Autorizacion                             │
│     ├─ Autenticacion basica de n8n                          │
│     ├─ Credenciales de base de datos                        │
│     ├─ Validacion de firma de webhook                       │
│     └─ Gestion de claves API                                │
│                                                              │
│  3. Seguridad de Datos                                       │
│     ├─ Aislamiento de variables de entorno                  │
│     ├─ Sin credenciales hardcodeadas                        │
│     ├─ Control de acceso a base de datos                    │
│     └─ Comunicacion cifrada (HTTPS/SSL)                     │
│                                                              │
│  4. Seguridad de Aplicacion                                  │
│     ├─ Validacion de entrada                                │
│     ├─ Limitacion de tasa                                   │
│     ├─ Manejo de errores                                    │
│     └─ Registro de auditoria                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘

```

## Consideraciones de Escalabilidad

### Escalamiento Vertical

- Aumentar recursos de contenedores Docker
- Actualizar instancia de base de datos
- Agregar mas RAM para modelos Ollama

### Escalamiento Horizontal

- Multiples instancias de n8n con balanceador de carga
- Replicas de lectura de PostgreSQL
- Redis para cache (mejora futura)
- Cola de mensajes para distribucion de tareas (mejora futura)

### Optimizacion de Rendimiento

- Indexacion de base de datos (implementado)
- Pooling de conexiones
- Procesamiento por lotes
- Estrategias de cache
- CDN para assets estaticos (si es necesario)

## Opciones de Despliegue

### 1. Desarrollo (Configuracion Actual)

- Docker Compose en maquina local
- Todos los servicios en un solo host
- Perfecto para pruebas y desarrollo

### 2. Produccion (Recomendado)

- Hosting en la nube (AWS, GCP, Azure, DigitalOcean)
- Base de datos PostgreSQL administrada
- HTTPS con certificados SSL
- Nombre de dominio con DNS
- Firewall y grupos de seguridad
- Respaldos regulares
- Monitoreo y alertas

### 3. Empresarial

- Cluster Kubernetes
- Configuracion de alta disponibilidad
- Auto-escalamiento
- Despliegue multi-region
- Monitoreo avanzado (Prometheus, Grafana)
- Pipeline CI/CD
- Plan de recuperacion ante desastres

## Monitoreo & Observabilidad

### Metricas a Rastrear

- Tiempos de ejecucion de workflows
- Tiempos de respuesta de API
- Rendimiento de consultas de base de datos
- Tasas de error
- Uso y costos de API
- Utilizacion de recursos (CPU, RAM, disco)
- Conteo de usuarios activos
- Volumen de mensajes

### Registro (Logging)

- Logs de ejecucion de n8n
- Logs de consultas de base de datos
- Logs de errores de aplicacion
- Logs de actividad de webhook
- Logs de auditoria de seguridad

### Herramientas (Mejora Futura)

- Prometheus para recoleccion de metricas
- Grafana para visualizacion
- Stack ELK para agregacion de logs
- Servicios de monitoreo de uptime
- Dashboards de seguimiento de costos
