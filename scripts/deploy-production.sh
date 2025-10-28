#!/bin/bash

# ============================================================
# SCRIPT DE DESPLIEGUE EN PRODUCCION
# Servidor: https://n8n.tudominio.com/
# ============================================================

set -e

echo "============================================================"
echo "  🚀 Despliegue de n8n en Produccion"
echo "  Servidor: https://n8n.tudominio.com/"
echo "============================================================"
echo ""

# ============================================================
# PASO 1: Verificaciones previas al despliegue
# ============================================================
echo "📋 Paso 1: Verificaciones previas..."

# Verificar si se ejecuta como root o con sudo
if [[ $EUID -ne 0 ]]; then
   echo "⚠️  Advertencia: No se ejecuta como root. Algunas operaciones pueden requerir sudo."
fi

# Verificar Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker no esta instalado"
    exit 1
fi
echo "✅ Docker instalado"

# Verificar Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: Docker Compose no esta instalado"
    exit 1
fi
echo "✅ Docker Compose instalado"

# ============================================================
# PASO 2: Configuracion del Entorno
# ============================================================
echo ""
echo "📝 Paso 2: Configurando entorno..."

if [ ! -f .env.production ]; then
    echo "❌ Error: archivo .env.production no encontrado"
    exit 1
fi

# Copiar entorno de produccion
cp .env.production .env
echo "✅ Entorno configurado"

# ============================================================
# PASO 3: Generar Claves de Seguridad
# ============================================================
echo ""
echo "🔐 Paso 3: Generando claves de seguridad..."

if ! grep -q "generate_with_openssl" .env; then
    echo "✅ Claves de seguridad ya configuradas"
else
    echo "Generando N8N_ENCRYPTION_KEY..."
    ENCRYPTION_KEY=$(openssl rand -base64 32)
    sed -i "s/N8N_ENCRYPTION_KEY=.*/N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY/" .env
    
    echo "Generando N8N_USER_MANAGEMENT_JWT_SECRET..."
    JWT_SECRET=$(openssl rand -base64 32)
    sed -i "s/N8N_USER_MANAGEMENT_JWT_SECRET=.*/N8N_USER_MANAGEMENT_JWT_SECRET=$JWT_SECRET/" .env
    
    echo "✅ Claves de seguridad generadas"
fi

# ============================================================
# PASO 4: Crear Directorios Requeridos
# ============================================================
echo ""
echo "📁 Paso 4: Creando directorios..."

mkdir -p volumes/postgres
mkdir -p volumes/n8n
mkdir -p volumes/logs
mkdir -p volumes/ollama
mkdir -p backups
mkdir -p credentials

chmod 700 volumes/postgres
chmod 755 volumes/n8n volumes/logs volumes/ollama backups

echo "✅ Directorios creados"

# ============================================================
# PASO 5: Verificacion de Inicializacion de Base de Datos
# ============================================================
echo ""
echo "🗄️  Paso 5: Verificando base de datos..."

if [ -d "volumes/postgres/base" ]; then
    echo "✅ Base de datos ya inicializada"
else
    echo "🔄 Base de datos se inicializara en el primer arranque"
fi

# ============================================================
# PASO 6: Descargar Ultimas Imagenes
# ============================================================
echo ""
echo "📦 Paso 6: Descargando imagenes de Docker..."

docker-compose -f docker-compose.production.yml pull

echo "✅ Imagenes descargadas"

# ============================================================
# PASO 7: Detener Contenedores Existentes
# ============================================================
echo ""
echo "🛑 Paso 7: Deteniendo contenedores existentes..."

docker-compose -f docker-compose.production.yml down

echo "✅ Contenedores detenidos"

# ============================================================
# PASO 8: Iniciar Servicios de Produccion
# ============================================================
echo ""
echo "🚀 Paso 8: Iniciando servicios de produccion..."

docker-compose -f docker-compose.production.yml up -d

echo "✅ Servicios iniciados"

# ============================================================
# PASO 9: Esperar a que los Servicios esten Listos
# ============================================================
echo ""
echo "⏳ Paso 9: Esperando a que los servicios esten listos..."

echo "Esperando PostgreSQL..."
sleep 10

echo "Esperando n8n..."
for i in {1..30}; do
    if docker exec n8n-app-prod wget -q --spider http://localhost:5678/healthz 2>/dev/null; then
        echo "✅ n8n esta listo!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "⚠️  Advertencia: n8n tardo mas de lo esperado en iniciar"
        echo "Verificar logs con: docker-compose -f docker-compose.production.yml logs n8n"
    fi
    echo "  Esperando... ($i/30)"
    sleep 2
done

# ============================================================
# PASO 10: Descargar Modelos de Ollama
# ============================================================
echo ""
echo "🤖 Paso 10: Descargando modelos de Ollama (opcional)..."

read -p "Descargar modelos de Ollama ahora? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Descargando llama2..."
    docker exec n8n-ollama-prod ollama pull llama2
    echo "✅ Modelos de Ollama descargados"
else
    echo "⏭️  Omitido. Puedes descargar mas tarde con:"
    echo "   docker exec n8n-ollama-prod ollama pull llama2"
fi

# ============================================================
# PASO 11: Mostrar Informacion
# ============================================================
echo ""
echo "============================================================"
echo "  ✅ DESPLIEGUE COMPLETADO EXITOSAMENTE!"
echo "============================================================"
echo ""
echo "📊 Estado de Servicios:"
docker-compose -f docker-compose.production.yml ps
echo ""
echo "🌐 Informacion de Acceso:"
echo "  URL:      https://n8n.tudominio.com/"
echo "  Usuario: $(grep N8N_BASIC_AUTH_USER .env | cut -d '=' -f2)"
echo "  Contrasena: [Revisar archivo .env]"
echo ""
echo "📝 Proximos Pasos Importantes:"
echo ""
echo "1. Configurar Claves API en archivo .env:"
echo "   - OPENAI_API_KEY"
echo "   - GEMINI_API_KEY"
echo "   - TELEGRAM_BOT_TOKEN"
echo "   - ELEVENLABS_API_KEY"
echo "   - etc."
echo ""
echo "2. Reiniciar servicios despues de actualizar .env:"
echo "   docker-compose -f docker-compose.production.yml restart n8n"
echo ""
echo "3. Importar workflows:"
echo "   - Acceder a n8n en https://n8n.tudominio.com/"
echo "   - Ir a Workflows > Import"
echo "   - Importar desde ./workflows/*.json"
echo ""
echo "4. Configurar credenciales en interfaz de n8n:"
echo "   - Settings > Credentials"
echo "   - Agregar credenciales para cada servicio"
echo ""
echo "5. Monitorear logs:"
echo "   docker-compose -f docker-compose.production.yml logs -f n8n"
echo ""
echo "6. Crear respaldo manual:"
echo "   ./scripts/backup.sh"
echo ""
echo "📚 Documentacion:"
echo "   - Guia de Produccion: docs/PRODUCTION.md"
echo "   - Solucion de Problemas: docs/FAQ.md"
echo ""
echo "============================================================"
echo ""