#!/bin/bash

# Script de configuracion para proyecto n8n Automatizacion y Agentes de IA
# Este script automatiza el proceso de configuracion inicial

set -e

echo "========================================="
echo "Configuracion de n8n Automatizacion y Agentes de IA"
echo "========================================="
echo ""

# Verificar si Docker esta instalado
if ! command -v docker &> /dev/null; then
    echo "Error: Docker no esta instalado."
    echo "Por favor instale Docker desde https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar si Docker Compose esta instalado
if ! command -v docker-compose &> /dev/null; then
    echo "Error: Docker Compose no esta instalado."
    echo "Por favor instale Docker Compose desde https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✓ Docker y Docker Compose estan instalados"
echo ""

# Verificar si archivo .env existe
if [ ! -f .env ]; then
    echo "Creando archivo .env desde .env.example..."
    cp .env.example .env
    echo "✓ Archivo .env creado"
    echo ""
    echo "⚠️  IMPORTANTE: Por favor edite el archivo .env con sus credenciales reales"
    echo "   Configuraciones requeridas:"
    echo "   - N8N_BASIC_AUTH_USER y N8N_BASIC_AUTH_PASSWORD"
    echo "   - DB_POSTGRESDB_PASSWORD"
    echo "   - Claves API para servicios que planea usar (OpenAI, Gemini, etc.)"
    echo ""
    read -p "Presione Enter para continuar despues de editar el archivo .env..."
else
    echo "✓ El archivo .env ya existe"
fi

echo ""
echo "Iniciando servicios de Docker..."
docker-compose up -d

echo ""
echo "Esperando a que los servicios esten listos..."
sleep 10

# Verificar si los servicios estan ejecutandose
if docker-compose ps | grep -q "Up"; then
    echo "✓ Los servicios estan ejecutandose"
else
    echo "✗ Algunos servicios fallaron al iniciar. Revisar logs con: docker-compose logs"
    exit 1
fi

echo ""
echo "========================================="
echo "Configuracion Completa!"
echo "========================================="
echo ""
echo "Acceder a n8n en: http://localhost:5678"
echo ""
echo "⚠️  IMPORTANTE: Actualizar credenciales en archivo .env antes de uso en produccion!"
echo "Valores por defecto (configurados en .env):"
echo "  Usuario: Establecido en N8N_BASIC_AUTH_USER"
echo "  Contrasena: Establecido en N8N_BASIC_AUTH_PASSWORD"
echo ""
echo "Proximos pasos:"
echo "1. Abrir http://localhost:5678 en su navegador"
echo "2. Iniciar sesion con sus credenciales"
echo "3. Importar workflows desde el directorio workflows/"
echo "4. Configurar credenciales para cada servicio que planea usar"
echo "5. Activar los workflows que necesite"
echo ""
echo "Optional: Pull Ollama models for local AI"
echo "  docker exec -it \$(docker-compose ps -q ollama) ollama pull llama2"
echo ""
echo "For detailed instructions, see docs/INSTALLATION.md"
echo ""
