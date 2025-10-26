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

# Backup n8n database (includes all tables: n8n workflows + RAG data)
docker-compose exec -T postgres pg_dump -U n8n n8n > "$BACKUP_FILE"

echo "Backup completed successfully!"
echo "File saved to: $BACKUP_FILE"

# Remove backups older than 30 days
find "$BACKUP_DIR" -name "*.sql" -mtime +30 -delete
echo "Old backups (>30 days) removed"
