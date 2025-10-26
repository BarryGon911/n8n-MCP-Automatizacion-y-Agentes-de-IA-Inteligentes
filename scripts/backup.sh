#!/bin/bash

# Backup script for n8n database
# Creates a timestamped backup of the PostgreSQL database

set -e

BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/n8n_backup_$TIMESTAMP.sql"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "Creating backup of n8n database..."

# Backup main n8n database
docker-compose exec -T postgres pg_dump -U n8n n8n > "$BACKUP_FILE"

# Backup RAG database
docker-compose exec -T postgres pg_dump -U n8n rag_database > "$BACKUP_DIR/rag_backup_$TIMESTAMP.sql"

echo "Backup completed successfully!"
echo "Files saved to:"
echo "  - $BACKUP_FILE"
echo "  - $BACKUP_DIR/rag_backup_$TIMESTAMP.sql"

# Remove backups older than 30 days
find "$BACKUP_DIR" -name "*.sql" -mtime +30 -delete
echo "Old backups (>30 days) removed"
