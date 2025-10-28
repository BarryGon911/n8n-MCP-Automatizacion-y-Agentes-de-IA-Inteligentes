#!/bin/bash

# ============================================================
# VERIFICACION DE SALUD Y MONITOREO DE PRODUCCION
# Servidor: https://n8n.tudominio.com/
# ============================================================

set -e

COMPOSE_FILE="docker-compose.production.yml"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "============================================================"
echo "  🏥 Verificacion de Salud de n8n en Produccion"
echo "  Hora: $TIMESTAMP"
echo "============================================================"
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sin Color

# ============================================================
# Funcion: Verificar Salud del Servicio
# ============================================================
check_service() {
    local service=$1
    local container=$2
    
    if docker ps --format '{{.Names}}' | grep -q "^${container}$"; then
        local health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null || echo "no-healthcheck")
        
        if [ "$health" = "healthy" ] || [ "$health" = "no-healthcheck" ]; then
            echo -e "  ${GREEN}✅${NC} $service: En ejecucion"
            return 0
        else
            echo -e "  ${RED}❌${NC} $service: No saludable (Estado: $health)"
            return 1
        fi
    else
        echo -e "  ${RED}❌${NC} $service: No esta ejecutandose"
        return 1
    fi
}

# ============================================================
# Verificar Servicios de Docker
# ============================================================
echo "📦 Servicios de Docker:"
check_service "PostgreSQL" "n8n-postgres-prod" && POSTGRES_OK=1 || POSTGRES_OK=0
check_service "n8n" "n8n-app-prod" && N8N_OK=1 || N8N_OK=0
check_service "Ollama" "n8n-ollama-prod" && OLLAMA_OK=1 || OLLAMA_OK=0
check_service "Servicio de Respaldo" "n8n-backup-prod" && BACKUP_OK=1 || BACKUP_OK=0

echo ""

# ============================================================
# Verificar Endpoints
# ============================================================
echo "🌐 Salud de Endpoints:"

# Verificacion de salud de n8n
if curl -f -s -o /dev/null https://n8n.tudominio.com/healthz 2>/dev/null; then
    echo -e "  ${GREEN}✅${NC} https://n8n.tudominio.com/healthz"
    ENDPOINT_OK=1
else
    echo -e "  ${RED}❌${NC} https://n8n.tudominio.com/healthz (Inalcanzable)"
    ENDPOINT_OK=0
fi

echo ""

# ============================================================
# Verificar Conexion a Base de Datos
# ============================================================
echo "🗄️  Base de Datos:"

if [ $POSTGRES_OK -eq 1 ]; then
    if docker exec n8n-postgres-prod pg_isready -U n8n_prod >/dev/null 2>&1; then
        echo -e "  ${GREEN}✅${NC} PostgreSQL aceptando conexiones"
        
        # Obtener tamano de base de datos
        DB_SIZE=$(docker exec n8n-postgres-prod psql -U n8n_prod -d n8n_production -t -c "SELECT pg_size_pretty(pg_database_size('n8n_production'));" 2>/dev/null | xargs)
        echo "  📊 Tamano de base de datos: $DB_SIZE"
        
        # Obtener cantidad de tablas
        TABLE_COUNT=$(docker exec n8n-postgres-prod psql -U n8n_prod -d n8n_production -t -c "SELECT count(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null | xargs)
        echo "  📋 Tablas: $TABLE_COUNT"
        
        DB_CONN_OK=1
    else
        echo -e "  ${RED}❌${NC} PostgreSQL no acepta conexiones"
        DB_CONN_OK=0
    fi
else
    echo -e "  ${YELLOW}⏭️${NC}  PostgreSQL no esta ejecutandose, omitiendo verificaciones"
    DB_CONN_OK=0
fi

echo ""

# ============================================================
# Verificar Uso de Disco
# ============================================================
echo "💾 Uso de Disco:"

# Disco general
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 80 ]; then
    echo -e "  ${GREEN}✅${NC} Particion raiz: ${DISK_USAGE}% usado"
elif [ "$DISK_USAGE" -lt 90 ]; then
    echo -e "  ${YELLOW}⚠️${NC}  Particion raiz: ${DISK_USAGE}% usado (Advertencia)"
else
    echo -e "  ${RED}❌${NC} Particion raiz: ${DISK_USAGE}% usado (Critico!)"
fi

# Volumenes de Docker
if [ -d "volumes" ]; then
    VOLUMES_SIZE=$(du -sh volumes 2>/dev/null | awk '{print $1}')
    echo "  📁 Tamano de volumenes: $VOLUMES_SIZE"
fi

# Respaldos
if [ -d "backups" ]; then
    BACKUP_SIZE=$(du -sh backups 2>/dev/null | awk '{print $1}')
    BACKUP_COUNT=$(find backups -name "*.sql" -type f 2>/dev/null | wc -l)
    echo "  💾 Respaldos: $BACKUP_COUNT archivos ($BACKUP_SIZE)"
fi

echo ""

# ============================================================
# Verificar Uso de Memoria
# ============================================================
echo "🧠 Uso de Memoria:"

# Obtener uso de memoria de contenedores
if command -v docker &> /dev/null; then
    docker stats --no-stream --format "table {{.Name}}\t{{.MemUsage}}" | grep -E "n8n-|NAME" || echo "  No se puede obtener estadisticas de memoria"
fi

echo ""

# ============================================================
# Verificar Logs Recientes en Busca de Errores
# ============================================================
echo "📝 Errores Recientes (ultimos 10 minutos):"

ERROR_COUNT=0
if [ $N8N_OK -eq 1 ]; then
    ERROR_COUNT=$(docker logs --since 10m n8n-app-prod 2>&1 | grep -i "error" | wc -l)
    if [ "$ERROR_COUNT" -eq 0 ]; then
        echo -e "  ${GREEN}✅${NC} Sin errores en logs de n8n"
    else
        echo -e "  ${YELLOW}⚠️${NC}  Se encontraron $ERROR_COUNT error(es) en logs de n8n"
        echo ""
        echo "  Errores recientes:"
        docker logs --since 10m n8n-app-prod 2>&1 | grep -i "error" | tail -3 | sed 's/^/    /'
    fi
fi

echo ""

# ============================================================
# Verificar Ultimo Respaldo
# ============================================================
echo "💾 Estado de Respaldos:"

if [ -d "backups" ]; then
    LAST_BACKUP=$(find backups -name "*.sql" -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -1 | awk '{print $2}')
    
    if [ -n "$LAST_BACKUP" ]; then
        LAST_BACKUP_TIME=$(stat -c %y "$LAST_BACKUP" 2>/dev/null | cut -d'.' -f1)
        LAST_BACKUP_SIZE=$(du -h "$LAST_BACKUP" 2>/dev/null | awk '{print $1}')
        echo -e "  ${GREEN}✅${NC} Ultimo respaldo: $LAST_BACKUP_TIME"
        echo "  📦 Tamano: $LAST_BACKUP_SIZE"
        echo "  📄 Archivo: $(basename "$LAST_BACKUP")"
    else
        echo -e "  ${YELLOW}⚠️${NC}  No se encontraron respaldos"
    fi
else
    echo -e "  ${RED}❌${NC} Directorio de respaldos no encontrado"
fi

echo ""

# ============================================================
# Resumen General de Salud
# ============================================================
echo "============================================================"
echo "  📊 RESUMEN GENERAL DE SALUD"
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
echo "  Puntuacion de Salud: $PASSED_CHECKS/$TOTAL_CHECKS ($HEALTH_PERCENT%)"
echo ""

if [ $HEALTH_PERCENT -ge 80 ]; then
    echo -e "  ${GREEN}✅ Estado del Sistema: SALUDABLE${NC}"
    EXIT_CODE=0
elif [ $HEALTH_PERCENT -ge 50 ]; then
    echo -e "  ${YELLOW}⚠️  Estado del Sistema: DEGRADADO${NC}"
    EXIT_CODE=1
else
    echo -e "  ${RED}❌ Estado del Sistema: CRITICO${NC}"
    EXIT_CODE=2
fi

echo ""
echo "============================================================"
echo ""

# ============================================================
# Acciones Rapidas
# ============================================================
if [ $EXIT_CODE -gt 0 ]; then
    echo "🔧 Acciones Sugeridas:"
    
    [ $POSTGRES_OK -eq 0 ] && echo "  - Reiniciar PostgreSQL: docker-compose -f $COMPOSE_FILE restart postgres"
    [ $N8N_OK -eq 0 ] && echo "  - Reiniciar n8n: docker-compose -f $COMPOSE_FILE restart n8n"
    [ $ENDPOINT_OK -eq 0 ] && echo "  - Verificar configuracion de nginx/caddy"
    [ "$DISK_USAGE" -gt 80 ] && echo "  - Liberar espacio en disco: docker system prune -a"
    [ "$ERROR_COUNT" -gt 10 ] && echo "  - Verificar logs: docker-compose -f $COMPOSE_FILE logs n8n"
    
    echo ""
fi

exit $EXIT_CODE