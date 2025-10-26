# Registro de Cambios

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Versionado Semántico](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-10-26

### Agregado

- **database/init.sql**: Archivo de inicialización completo de PostgreSQL
  - Extensiones: `vector` (pgvector para RAG) y `uuid-ossp`
  - Tablas: `users`, `conversations`, `documents`, `scraped_data`, `agent_tasks`, `workflow_logs`
  - Índices optimizados para búsquedas vectoriales y consultas frecuentes
  - Triggers automáticos para actualización de timestamps
  - Vistas útiles: `active_conversations`, `pending_tasks_summary`
  - Datos de prueba iniciales para web scraping
  - Permisos configurados correctamente para usuario n8n

### Corregido

- Actualizado `.gitignore` para excluir archivos sensibles pero permitir `database/init.sql`
- Añadidas exclusiones para volúmenes de Docker y archivos IDE

## [1.0.0] - 2025-01-26

### Agregado

#### Infraestructura Principal

- Configuración de Docker Compose con n8n, PostgreSQL y Ollama
- Base de datos PostgreSQL con extensión pgvector para RAG
- Inicialización automatizada de base de datos con creación de schema
- Plantilla de configuración de entorno (.env.example)
- .gitignore comprensivo para seguridad

#### Workflows

- **Bot de IA Telegram**: Chatbot inteligente con soporte RAG

   - Manejo de mensajes y generación de respuestas
   - Almacenamiento de historial de conversación
   - Integración con OpenAI y Ollama
   - Seguimiento y perfilado de usuarios

- **Bot de IA WhatsApp**: Automatización de mensajería empresarial

   - Integración con Meta WhatsApp Business API
   - Gemini AI para generación de respuestas
   - Manejo de mensajes basado en webhook
   - Soporte de conversación multi-usuario

- **Web Scraping & RAG**: Extracción automatizada de contenido

   - Web scraping programado (intervalos de 6 horas)
   - Extracción de contenido basada en Cheerio
   - Generación de embeddings de OpenAI
   - Almacenamiento vectorial en PostgreSQL

- **Text-to-Speech**: Integración con ElevenLabs

   - Síntesis de voz de alta calidad
   - API webhook para fácil integración
   - Configuración de voz personalizable

- **Ejecutor de Tareas de Agentes de IA**: Procesamiento autónomo de tareas

   - Sistema de cola de tareas con PostgreSQL
   - Soporte de múltiples tipos de tareas
   - Procesamiento de trabajos en segundo plano
   - Seguimiento de estado y manejo de errores

#### Schema de Base de Datos

- Tabla `documents` para RAG con embeddings vectoriales
- Tabla `conversations` para historial de chat
- Tabla `users` para perfiles y preferencias de usuario
- Tabla `scraped_data` para resultados de web scraping
- Tabla `agent_tasks` para tareas de agentes autónomos
- Tabla `workflows_log` para seguimiento de ejecución
- Triggers para actualización automática de timestamps

#### Documentación

- **INSTALLATION.md**: Guía completa de configuración

   - Requisitos previos y requerimientos
   - Instalación paso a paso
   - Configuración de servicios
   - Configuración de integraciones (Telegram, WhatsApp, etc.)
   - Sección de solución de problemas

- **USAGE.md**: Guía comprensiva de uso

   - Instrucciones de inicio
   - Ejemplos de uso de bots
   - Explicación del sistema RAG
   - Workflows de web scraping
   - Características avanzadas y mejores prácticas

- **Workflows README**: Documentación detallada de workflows

   - Descripciones individuales de workflows
   - Listas de características y casos de uso
   - Instrucciones de importación
   - Guía de personalización
   - Consejos de solución de problemas

- **FAQ.md**: Preguntas frecuentes

   - Preguntas generales
   - Ayuda de instalación
   - Orientación sobre modelos de IA
   - Configuración de bots
   - Consejos de seguridad

- **CREDENTIALS.md**: Plantillas de configuración de credenciales

   - Configuración paso a paso de credenciales
   - Guías de adquisición de claves API
   - Recomendaciones de seguridad

- **CONTRIBUTING.md**: Pautas de contribución

   - Cómo contribuir
   - Estándares de estilo de código
   - Proceso de contribución de workflows
   - Requisitos de pruebas

- **SECURITY.md**: Política de seguridad

   - Reporte de vulnerabilidades
   - Mejores prácticas de seguridad
   - Consideraciones de cumplimiento
   - Procedimientos de respuesta a incidentes

#### Scripts

- **setup.sh**: Script de instalación automatizado

   - Verificación de Docker
   - Configuración de entorno
   - Inicialización de servicios
   - Orientación al usuario

- **backup.sh**: Utilidad de respaldo de base de datos

   - Creación automatizada de respaldos
   - Nombres de archivo basados en timestamp
   - Limpieza de respaldos antiguos (retención de 30 días)
   - Soporte para múltiples bases de datos

#### Utilidades de Base de Datos

- **sample-queries.sql**: Consultas SQL listas para usar
   - Consultas de base de datos RAG
   - Analíticas de conversación
   - Gestión de usuarios
   - Operaciones de web scraping
   - Gestión de tareas de agentes
   - Registro de workflows
   - Consultas de mantenimiento
   - Monitoreo de rendimiento

#### Características

- Soporte multi-modelo de IA (OpenAI, Gemini, Ollama)
- RAG con búsqueda de similitud vectorial
- Historial de conversación y gestión de contexto
- Web scraping e indexación automatizados
- Generación de texto a voz
- Procesamiento autónomo de tareas de agentes
- Perfilado y preferencias de usuarios
- Registro y monitoreo comprensivo
- Mecanismos de manejo de errores y reintentos
- Arquitectura escalable

### Seguridad

- Configuración basada en variables de entorno
- Sin credenciales hardcodeadas
- Protección .gitignore para archivos sensibles
- Soporte de validación de firma de webhook
- Controles de acceso a base de datos
- Soporte de rotación de claves API

### Rendimiento

- PostgreSQL con pooling de conexiones
- Búsqueda eficiente de similitud vectorial con pgvector
- Capacidades de procesamiento por lotes
- Ejecución programada de tareas
- Contenedores Docker optimizados en recursos

### Compatibilidad

- Docker 20.10+
- Docker Compose 2.0+
- PostgreSQL 15 con pgvector
- n8n última versión
- Linux, macOS, Windows (WSL2)

## [No Publicado]

### Características Planeadas

- Integraciones adicionales de modelos de IA (Anthropic Claude, Cohere)
- Técnicas avanzadas de RAG (búsqueda híbrida, re-ranking)
- Integración de bot de Discord
- Soporte de mensajes de voz para bots de mensajería
- Interfaz web para gestión de workflows
- Dashboard de analíticas de conversación
- Ejemplos de integración de app móvil
- Documentación multi-idioma
- Guías de optimización de rendimiento
- Plantillas de pipeline CI/CD

---

## Leyenda de Historial de Versiones

- **Agregado**: Nuevas características
- **Cambiado**: Cambios en funcionalidad existente
- **Deprecado**: Características que pronto serán removidas
- **Removido**: Características removidas
- **Corregido**: Correcciones de bugs
- **Seguridad**: Mejoras de seguridad

---

Para más información sobre características futuras, consulta la [Hoja de Ruta en README.md](README.md#-roadmap).
