# 📊 Documentacion de Base de Datos

Este directorio contiene la configuracion e inicializacion de la base de datos PostgreSQL con extension **pgvector** para el sistema RAG (Retrieval-Augmented Generation).

## 📋 Contenido

- **`init.sql`**: Script de inicializacion de la base de datos que crea todas las tablas necesarias
- **`README.md`**: Este archivo de documentacion

## 🗄️ Esquema de Base de Datos

La base de datos `n8n` contiene las siguientes tablas principales:

### 1. **users** - Gestion de Usuarios
Almacena informacion de usuarios de diferentes plataformas (Telegram, WhatsApp, etc.)

### 2. **conversations** - Historial de Conversaciones
Registra todas las conversaciones con contexto y metadatos.

### 3. **documents** - Documentos RAG
Almacena documentos procesados para el sistema RAG con embeddings vectoriales.

### 4. **scraped_data** - Datos de Web Scraping
Datos extraidos de sitios web para analisis y procesamiento.

### 5. **agent_tasks** - Tareas de Agentes IA
Seguimiento de tareas ejecutadas por agentes de IA.

### 6. **workflow_logs** - Logs de Workflows
Registro de ejecuciones de workflows de n8n.

## 🔍 indices para Busqueda Vectorial

El script crea indices **HNSW** (Hierarchical Navigable Small World) para busqueda eficiente de vectores.

## 🔧 Mantenimiento

### Crear Backup

```bash
# Desde el directorio raiz del proyecto
./scripts/backup.sh
```

### Restaurar desde Backup

```bash
docker-compose exec -T postgres psql -U n8n n8n < ./backups/n8n_backup_TIMESTAMP.sql
```

## 📚 Referencias

- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [pgvector Extension](https://github.com/pgvector/pgvector)
- [n8n Database Configuration](https://docs.n8n.io/hosting/configuration/database/)

---

**Necesitas ayuda?** Consulta la [documentacion completa](../docs/) o abre un issue en GitHub.
