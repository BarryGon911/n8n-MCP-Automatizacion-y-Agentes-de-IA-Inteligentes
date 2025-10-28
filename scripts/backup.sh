#!/bin/bash

# Script de respaldo para base de datos n8n
# Crea un respaldo con marca de tiempo de la base de datos PostgreSQL

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/n8n_backup_$TIMESTAMP.sql"

# Crear directorio de respaldo si no existe
mkdir -p "$BACKUP_DIR"

echo "Creando respaldo de base de datos n8n..."

# Respaldar base de datos n8n (incluye todas las tablas: workflows n8n + datos RAG)
docker-compose exec -T postgres pg_dump -U n8n n8n > "$BACKUP_FILE"

echo "Respaldo completado exitosamente!"
echo "Archivo guardado en: $BACKUP_FILE"

# Eliminar respaldos mayores a 60 dias
find "$BACKUP_DIR" -name "*.sql" -mtime +60 -delete
echo "Respaldos antiguos (>60 dias) eliminados"