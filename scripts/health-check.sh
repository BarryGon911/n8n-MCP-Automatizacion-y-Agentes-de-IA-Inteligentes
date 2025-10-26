#!/bin/bash

# ============================================================
# PRODUCTION HEALTH CHECK & MONITORING
# Server: https://n8n.alekarpy.uk/
# ============================================================

set -e

COMPOSE_FILE="docker-compose.production.yml"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "============================================================"
echo "  🏥 n8n Production Health Check"
echo "  Time: $TIMESTAMP"
echo "============================================================"
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================
# Function: Check Service Health
# ============================================================
check_service() {
    local service=$1
    local container=$2
    
    if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        local health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "no-healthcheck")
        
        if [ "$health" = "healthy" ] || [ "$health" = "no-healthcheck" ]; then
            echo -e "  ${GREEN}✅${NC} $service: Running"
            return 0
        else
            echo -e "  ${RED}❌${NC} $service: Unhealthy (Status: $health)"
            return 1
        fi
    else
        echo -e "  ${RED}❌${NC} $service: Not running"
        return 1
    fi
}

# ============================================================
# Check Docker Services
# ============================================================
echo "📦 Docker Services:"
check_service "PostgreSQL" "n8n-postgres-prod" && POSTGRES_OK=1 || POSTGRES_OK=0
check_service "n8n" "n8n-app-prod" && N8N_OK=1 || N8N_OK=0
check_service "Ollama" "n8n-ollama-prod" && OLLAMA_OK=1 || OLLAMA_OK=0
check_service "Backup Service" "n8n-backup-prod" && BACKUP_OK=1 || BACKUP_OK=0

echo ""

# ============================================================
# Check Endpoints
# ============================================================
echo "🌐 Endpoint Health:"

# n8n healthcheck
if curl -f -s -o /dev/null https://n8n.alekarpy.uk/healthz 2>/dev/null; then
    echo -e "  ${GREEN}✅${NC} https://n8n.alekarpy.uk/healthz"
    ENDPOINT_OK=1
else
    echo -e "  ${RED}❌${NC} https://n8n.alekarpy.uk/healthz (Unreachable)"
    ENDPOINT_OK=0
fi

echo ""

# ============================================================
# Check Database Connection
# ============================================================
echo "🗄️  Database:"

if [ $POSTGRES_OK -eq 1 ]; then
    if docker exec n8n-postgres-prod pg_isready -U n8n_prod >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅${NC} PostgreSQL accepting connections"
        
        # Get database size
        DB_SIZE=$(docker exec n8n-postgres-prod psql -U n8n_prod -d n8n_production -t -c "SELECT pg_size_pretty(pg_database_size('n8n_production'));" 2>/dev/null | xargs)
        echo "  📊 Database size: $DB_SIZE"
        
        # Get table count
        TABLE_COUNT=$(docker exec n8n-postgres-prod psql -U n8n_prod -d n8n_production -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null | xargs)
        echo "  📋 Tables: $TABLE_COUNT"
        
        DB_CONN_OK=1
    else
        echo -e "  ${RED}❌${NC} PostgreSQL not accepting connections"
        DB_CONN_OK=0
    fi
else
    echo -e "  ${YELLOW}⏭️${NC}  PostgreSQL not running, skipping checks"
    DB_CONN_OK=0
fi

echo ""

# ============================================================
# Check Disk Usage
# ============================================================
echo "💾 Disk Usage:"

# Overall disk
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 80 ]; then
    echo -e "  ${GREEN}✅${NC} Root partition: ${DISK_USAGE}% used"
elif [ "$DISK_USAGE" -lt 90 ]; then
    echo -e "  ${YELLOW}⚠️${NC}  Root partition: ${DISK_USAGE}% used (Warning)"
else
    echo -e "  ${RED}❌${NC} Root partition: ${DISK_USAGE}% used (Critical!)"
fi

# Docker volumes
if [ -d "volumes" ]; then
    VOLUMES_SIZE=$(du -sh volumes 2>/dev/null | awk '{print $1}')
    echo "  📁 Volumes size: $VOLUMES_SIZE"
fi

# Backups
if [ -d "backups" ]; then
    BACKUP_SIZE=$(du -sh backups 2>/dev/null | awk '{print $1}')
    BACKUP_COUNT=$(find backups -name "*.sql" -type f 2>/dev/null | wc -l)
    echo "  💾 Backups: $BACKUP_COUNT files ($BACKUP_SIZE)"
fi

echo ""

# ============================================================
# Check Memory Usage
# ============================================================
echo "🧠 Memory Usage:"

# Get container memory usage
if command -v docker &> /dev/null; then
    docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}" | grep -E "n8n-|NAME" || echo "  Unable to retrieve memory stats"
fi

echo ""

# ============================================================
# Check Recent Logs for Errors
# ============================================================
echo "📝 Recent Errors (last 10 minutes):"

ERROR_COUNT=0
if [ $N8N_OK -eq 1 ]; then
    ERROR_COUNT=$(docker logs --since 10m n8n-app-prod 2>&1 | grep -i "error" | wc -l)
    if [ "$ERROR_COUNT" -eq 0 ]; then
        echo -e "  ${GREEN}✅${NC} No errors in n8n logs"
    else
        echo -e "  ${YELLOW}⚠️${NC}  Found $ERROR_COUNT error(s) in n8n logs"
        echo ""
        echo "  Recent errors:"
        docker logs --since 10m n8n-app-prod 2>&1 | grep -i "error" | tail -3 | sed 's/^/    /'
    fi
fi

echo ""

# ============================================================
# Check Last Backup
# ============================================================
echo "💾 Backup Status:"

if [ -d "backups" ]; then
    LAST_BACKUP=$(find backups -name "*.sql" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | awk '{print $2}')
    
    if [ -n "$LAST_BACKUP" ]; then
        LAST_BACKUP_TIME=$(stat -c %y "$LAST_BACKUP" 2>/dev/null | cut -d'.' -f1)
        LAST_BACKUP_SIZE=$(du -h "$LAST_BACKUP" 2>/dev/null | awk '{print $1}')
        echo -e "  ${GREEN}✅${NC} Last backup: $LAST_BACKUP_TIME"
        echo "  📦 Size: $LAST_BACKUP_SIZE"
        echo "  📄 File: $(basename "$LAST_BACKUP")"
    else
        echo -e "  ${YELLOW}⚠️${NC}  No backups found"
    fi
else
    echo -e "  ${RED}❌${NC} Backup directory not found"
fi

echo ""

# ============================================================
# Overall Health Summary
# ============================================================
echo "============================================================"
echo "  📊 OVERALL HEALTH SUMMARY"
echo "============================================================"

TOTAL_CHECKS=6
PASSED_CHECKS=0

[ $POSTGRES_OK -eq 1 ] && ((PASSED_CHECKS++))
[ $N8N_OK -eq 1 ] && ((PASSED_CHECKS++))
[ $OLLAMA_OK -eq 1 ] && ((PASSED_CHECKS++))
[ $ENDPOINT_OK -eq 1 ] && ((PASSED_CHECKS++))
[ $DB_CONN_OK -eq 1 ] && ((PASSED_CHECKS++))
[ "$DISK_USAGE" -lt 80 ] && ((PASSED_CHECKS++))

HEALTH_PERCENT=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))

echo ""
echo "  Health Score: $PASSED_CHECKS/$TOTAL_CHECKS ($HEALTH_PERCENT%)"
echo ""

if [ $HEALTH_PERCENT -ge 80 ]; then
    echo -e "  ${GREEN}✅ System Status: HEALTHY${NC}"
    EXIT_CODE=0
elif [ $HEALTH_PERCENT -ge 50 ]; then
    echo -e "  ${YELLOW}⚠️  System Status: DEGRADED${NC}"
    EXIT_CODE=1
else
    echo -e "  ${RED}❌ System Status: CRITICAL${NC}"
    EXIT_CODE=2
fi

echo ""
echo "============================================================"
echo ""

# ============================================================
# Quick Actions
# ============================================================
if [ $EXIT_CODE -gt 0 ]; then
    echo "🔧 Suggested Actions:"
    
    [ $POSTGRES_OK -eq 0 ] && echo "  - Restart PostgreSQL: docker-compose -f $COMPOSE_FILE restart postgres"
    [ $N8N_OK -eq 0 ] && echo "  - Restart n8n: docker-compose -f $COMPOSE_FILE restart n8n"
    [ $ENDPOINT_OK -eq 0 ] && echo "  - Check nginx/caddy configuration"
    [ "$DISK_USAGE" -gt 80 ] && echo "  - Free up disk space: docker system prune -a"
    [ "$ERROR_COUNT" -gt 10 ] && echo "  - Check logs: docker-compose -f $COMPOSE_FILE logs n8n"
    
    echo ""
fi

exit $EXIT_CODE
