# Registro de Cambios

Todos los cambios notables de este proyecto seran documentados en este archivo.

El formato esta basado en [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
y este proyecto adhiere a [Versionado Semantico](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-10-26

### Agregado

- **database/init.sql**: Archivo de inicializacion completo de PostgreSQL
  - Extensiones: `vector` (pgvector para RAG) y `uuid-ossp`
  - Tablas: `users`, `conversations`, `documents`, `scraped_data`, `agent_tasks`, `workflow_logs`
  - indices optimizados para busquedas vectoriales y consultas frecuentes
  - Triggers automaticos para actualizacion de timestamps
  - Vistas utiles: `active_conversations`, `pending_tasks_summary`
  - Datos de prueba iniciales para web scraping
  - Permisos configurados correctamente para usuario n8n

### Corregido

- Actualizado `.gitignore` para excluir archivos sensibles pero permitir `database/init.sql`
- Anadidas exclusiones para volumenes de Docker y archivos IDE

## [1.0.0] - 2025-01-26

### Agregado

#### Infraestructura Principal

- Configuracion de Docker Compose con n8n, PostgreSQL y Ollama
- Base de datos PostgreSQL con extension pgvector para RAG
- Inicializacion automatizada de base de datos con creacion de schema
- Plantilla de configuracion de entorno (.env.example)
- .gitignore comprensivo para seguridad

#### Workflows

- **Bot de IA Telegram**: Chatbot inteligente con soporte RAG

   - Manejo de mensajes y generacion de respuestas
   - Almacenamiento de historial de conversacion
   - Integracion con OpenAI y Ollama
   - Seguimiento y perfilado de usuarios

- **Bot de IA WhatsApp**: Automatizacion de mensajeria empresarial

   - Integracion con Meta WhatsApp Business API
   - Gemini AI para generacion de respuestas
   - Manejo de mensajes basado en webhook
   - Soporte de conversacion multi-usuario

- **Web Scraping & RAG**: Extraccion automatizada de contenido

   - Web scraping programado (intervalos de 6 horas)
   - Extraccion de contenido basada en Cheerio
   - Generacion de embeddings de OpenAI
   - Almacenamiento vectorial en PostgreSQL

- **Text-to-Speech**: Integracion con ElevenLabs

   - Sintesis de voz de alta calidad
   - API webhook para facil integracion
   - Configuracion de voz personalizable

- **Ejecutor de Tareas de Agentes de IA**: Procesamiento autonomo de tareas

   - Sistema de cola de tareas con PostgreSQL
   - Soporte de multiples tipos de tareas
   - Procesamiento de trabajos en segundo plano
   - Seguimiento de estado y manejo de errores

#### Schema de Base de Datos

- Tabla `documents` para RAG con embeddings vectoriales
- Tabla `conversations` para historial de chat
- Tabla `users` para perfiles y preferencias de usuario
- Tabla `scraped_data` para resultados de web scraping
- Tabla `agent_tasks` para tareas de agentes autonomos
- Tabla `workflows_log` para seguimiento de ejecucion
- Triggers para actualizacion automatica de timestamps

#### Documentacion

- **INSTALLATION.md**: Guia completa de configuracion

   - Requisitos previos y requerimientos
   - Instalacion paso a paso
   - Configuracion de servicios
   - Configuracion de integraciones (Telegram, WhatsApp, etc.)
   - Seccion de solucion de problemas

- **USAGE.md**: Guia comprensiva de uso

   - Instrucciones de inicio
   - Ejemplos de uso de bots
   - Explicacion del sistema RAG
   - Workflows de web scraping
   - Caracteristicas avanzadas y mejores practicas

- **Workflows README**: Documentacion detallada de workflows

   - Descripciones individuales de workflows
   - Listas de caracteristicas y casos de uso
   - Instrucciones de importacion
   - Guia de personalizacion
   - Consejos de solucion de problemas

- **FAQ.md**: Preguntas frecuentes

   - Preguntas generales
   - Ayuda de instalacion
   - Orientacion sobre modelos de IA
   - Configuracion de bots
   - Consejos de seguridad

- **CREDENTIALS.md**: Plantillas de configuracion de credenciales

   - Configuracion paso a paso de credenciales
   - Guias de adquisicion de claves API
   - Recomendaciones de seguridad

- **CONTRIBUTING.md**: Pautas de contribucion

   - Como contribuir
   - Estandares de estilo de codigo
   - Proceso de contribucion de workflows
   - Requisitos de pruebas

- **SECURITY.md**: Politica de seguridad

   - Reporte de vulnerabilidades
   - Mejores practicas de seguridad
   - Consideraciones de cumplimiento
   - Procedimientos de respuesta a incidentes

#### Scripts

- **setup.sh**: Script de instalacion automatizado

   - Verificacion de Docker
   - Configuracion de entorno
   - Inicializacion de servicios
   - Orientacion al usuario

- **backup.sh**: Utilidad de respaldo de base de datos

   - Creacion automatizada de respaldos
   - Nombres de archivo basados en timestamp
   - Limpieza de respaldos antiguos (retencion de 30 dias)
   - Soporte para multiples bases de datos

#### Utilidades de Base de Datos

- **sample-queries.sql**: Consultas SQL listas para usar
   - Consultas de base de datos RAG
   - Analiticas de conversacion
   - Gestion de usuarios
   - Operaciones de web scraping
   - Gestion de tareas de agentes
   - Registro de workflows
   - Consultas de mantenimiento
   - Monitoreo de rendimiento

#### Caracteristicas

- Soporte multi-modelo de IA (OpenAI, Gemini, Ollama)
- RAG con busqueda de similitud vectorial
- Historial de conversacion y gestion de contexto
- Web scraping e indexacion automatizados
- Generacion de texto a voz
- Procesamiento autonomo de tareas de agentes
- Perfilado y preferencias de usuarios
- Registro y monitoreo comprensivo
- Mecanismos de manejo de errores y reintentos
- Arquitectura escalable

### Seguridad

- Configuracion basada en variables de entorno
- Sin credenciales hardcodeadas
- Proteccion .gitignore para archivos sensibles
- Soporte de validacion de firma de webhook
- Controles de acceso a base de datos
- Soporte de rotacion de claves API

### Rendimiento

- PostgreSQL con pooling de conexiones
- Busqueda eficiente de similitud vectorial con pgvector
- Capacidades de procesamiento por lotes
- Ejecucion programada de tareas
- Contenedores Docker optimizados en recursos

### Compatibilidad

- Docker 20.10+
- Docker Compose 2.0+
- PostgreSQL 15 con pgvector
- n8n ultima version
- Linux, macOS, Windows (WSL2)

## [No Publicado]

### Caracteristicas Planeadas

- Integraciones adicionales de modelos de IA (Anthropic Claude, Cohere)
- Tecnicas avanzadas de RAG (busqueda hibrida, re-ranking)
- Integracion de bot de Discord
- Soporte de mensajes de voz para bots de mensajeria
- Interfaz web para gestion de workflows
- Dashboard de analiticas de conversacion
- Ejemplos de integracion de app movil
- Documentacion multi-idioma
- Guias de optimizacion de rendimiento
- Plantillas de pipeline CI/CD

---

## Leyenda de Historial de Versiones

- **Agregado**: Nuevas caracteristicas
- **Cambiado**: Cambios en funcionalidad existente
- **Deprecado**: Caracteristicas que pronto seran removidas
- **Removido**: Caracteristicas removidas
- **Corregido**: Correcciones de bugs
- **Seguridad**: Mejoras de seguridad

---

Para mas informacion sobre caracteristicas futuras, consulta la [Hoja de Ruta en README.md](README.md#-roadmap).
