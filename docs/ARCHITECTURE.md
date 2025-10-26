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

### 1. Bots de Mensajería (Telegram/WhatsApp)

```ini
Mensaje del Usuario
    ↓
Webhook/Trigger → Workflow n8n
    ↓
Guardar en tabla conversations
    ↓
Recuperar contexto de RAG (búsqueda vectorial)
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

### 3. Tareas de Agentes Autónomos

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

## Stack Tecnológico

### Plataforma Principal

- **n8n**: Motor de automatización de workflows
- **Docker**: Contenedorización
- **Docker Compose**: Orquestación multi-contenedor

### Base de Datos

- **PostgreSQL 15**: Base de datos relacional
- **pgvector**: Extensión de búsqueda por similitud vectorial

### Modelos de IA

- **OpenAI GPT-4/3.5**: Modelos de lenguaje basados en la nube
- **Google Gemini**: IA multimodal de Google
- **Ollama**: Modelos locales auto-hospedados (Llama2, Mistral)

### Plataformas de Mensajería

- **Telegram Bot API**: Integración con Telegram
- **Meta WhatsApp Business API**: Integración con WhatsApp
- **Twilio**: Integración alternativa con WhatsApp

### Servicios Adicionales

- **ElevenLabs**: Síntesis de texto a voz
- **Google Cloud**: Integración de servicios en la nube
- **Cheerio**: Análisis HTML para web scraping

## Arquitectura de Seguridad

```ini
┌─────────────────────────────────────────────────────────────┐
│                     Capas de Seguridad                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. Seguridad de Red                                         │
│     ├─ Aislamiento de red Docker                            │
│     ├─ Control de exposición de puertos                     │
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
│     ├─ Control de exposición de puertos                     │
│     └─ HTTPS en producción (proxy inverso)                  │
│                                                              │
│  2. Autenticación & Autorización                             │
│     ├─ Autenticación básica de n8n                          │
│     ├─ Credenciales de base de datos                        │
│     ├─ Validación de firma de webhook                       │
│     └─ Gestión de claves API                                │
│                                                              │
│  3. Seguridad de Datos                                       │
│     ├─ Aislamiento de variables de entorno                  │
│     ├─ Sin credenciales hardcodeadas                        │
│     ├─ Control de acceso a base de datos                    │
│     └─ Comunicación cifrada (HTTPS/SSL)                     │
│                                                              │
│  4. Seguridad de Aplicación                                  │
│     ├─ Validación de entrada                                │
│     ├─ Limitación de tasa                                   │
│     ├─ Manejo de errores                                    │
│     └─ Registro de auditoría                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘

```

## Consideraciones de Escalabilidad

### Escalamiento Vertical

- Aumentar recursos de contenedores Docker
- Actualizar instancia de base de datos
- Agregar más RAM para modelos Ollama

### Escalamiento Horizontal

- Múltiples instancias de n8n con balanceador de carga
- Réplicas de lectura de PostgreSQL
- Redis para caché (mejora futura)
- Cola de mensajes para distribución de tareas (mejora futura)

### Optimización de Rendimiento

- Indexación de base de datos (implementado)
- Pooling de conexiones
- Procesamiento por lotes
- Estrategias de caché
- CDN para assets estáticos (si es necesario)

## Opciones de Despliegue

### 1. Desarrollo (Configuración Actual)

- Docker Compose en máquina local
- Todos los servicios en un solo host
- Perfecto para pruebas y desarrollo

### 2. Producción (Recomendado)

- Hosting en la nube (AWS, GCP, Azure, DigitalOcean)
- Base de datos PostgreSQL administrada
- HTTPS con certificados SSL
- Nombre de dominio con DNS
- Firewall y grupos de seguridad
- Respaldos regulares
- Monitoreo y alertas

### 3. Empresarial

- Clúster Kubernetes
- Configuración de alta disponibilidad
- Auto-escalamiento
- Despliegue multi-región
- Monitoreo avanzado (Prometheus, Grafana)
- Pipeline CI/CD
- Plan de recuperación ante desastres

## Monitoreo & Observabilidad

### Métricas a Rastrear

- Tiempos de ejecución de workflows
- Tiempos de respuesta de API
- Rendimiento de consultas de base de datos
- Tasas de error
- Uso y costos de API
- Utilización de recursos (CPU, RAM, disco)
- Conteo de usuarios activos
- Volumen de mensajes

### Registro (Logging)

- Logs de ejecución de n8n
- Logs de consultas de base de datos
- Logs de errores de aplicación
- Logs de actividad de webhook
- Logs de auditoría de seguridad

### Herramientas (Mejora Futura)

- Prometheus para recolección de métricas
- Grafana para visualización
- Stack ELK para agregación de logs
- Servicios de monitoreo de uptime
- Dashboards de seguimiento de costos
