#!/bin/bash

# ============================================================
# PRODUCTION DEPLOYMENT SCRIPT
# Server: https://n8n.alekarpy.uk/
# ============================================================

set -e

echo "============================================================"
echo "  🚀 n8n Production Deployment"
echo "  Server: https://n8n.alekarpy.uk/"
echo "============================================================"
echo ""

# ============================================================
# STEP 1: Pre-deployment Checks
# ============================================================
echo "📋 Step 1: Pre-deployment checks..."

# Check if running as root or with sudo
if [[ $EUID -ne 0 ]]; then
   echo "⚠️  Warning: Not running as root. Some operations may require sudo."
fi

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed"
    exit 1
fi
echo "✅ Docker installed"

# Check Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Error: Docker Compose is not installed"
    exit 1
fi
echo "✅ Docker Compose installed"

# ============================================================
# STEP 2: Environment Configuration
# ============================================================
echo ""
echo "📝 Step 2: Configuring environment..."

if [ ! -f .env.production ]; then
    echo "❌ Error: .env.production file not found"
    exit 1
fi

# Copy production env
cp .env.production .env
echo "✅ Environment configured"

# ============================================================
# STEP 3: Generate Security Keys
# ============================================================
echo ""
echo "🔐 Step 3: Generating security keys..."

if ! grep -q "generate_with_openssl" .env; then
    echo "✅ Security keys already configured"
else
    echo "Generating N8N_ENCRYPTION_KEY..."
    ENCRYPTION_KEY=$(openssl rand -base64 32)
    sed -i "s/N8N_ENCRYPTION_KEY=.*/N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY/" .env
    
    echo "Generating N8N_USER_MANAGEMENT_JWT_SECRET..."
    JWT_SECRET=$(openssl rand -base64 32)
    sed -i "s/N8N_USER_MANAGEMENT_JWT_SECRET=.*/N8N_USER_MANAGEMENT_JWT_SECRET=$JWT_SECRET/" .env
    
    echo "✅ Security keys generated"
fi

# ============================================================
# STEP 4: Create Required Directories
# ============================================================
echo ""
echo "📁 Step 4: Creating directories..."

mkdir -p volumes/postgres
mkdir -p volumes/n8n
mkdir -p volumes/logs
mkdir -p volumes/ollama
mkdir -p backups
mkdir -p credentials

chmod 700 volumes/postgres
chmod 755 volumes/n8n volumes/logs volumes/ollama backups

echo "✅ Directories created"

# ============================================================
# STEP 5: Database Initialization Check
# ============================================================
echo ""
echo "🗄️  Step 5: Checking database..."

if [ -d "volumes/postgres/base" ]; then
    echo "✅ Database already initialized"
else
    echo "🔄 Database will be initialized on first run"
fi

# ============================================================
# STEP 6: Pull Latest Images
# ============================================================
echo ""
echo "📦 Step 6: Pulling Docker images..."

docker-compose -f docker-compose.production.yml pull

echo "✅ Images pulled"

# ============================================================
# STEP 7: Stop Existing Containers
# ============================================================
echo ""
echo "🛑 Step 7: Stopping existing containers..."

docker-compose -f docker-compose.production.yml down

echo "✅ Containers stopped"

# ============================================================
# STEP 8: Start Production Services
# ============================================================
echo ""
echo "🚀 Step 8: Starting production services..."

docker-compose -f docker-compose.production.yml up -d

echo "✅ Services started"

# ============================================================
# STEP 9: Wait for Services
# ============================================================
echo ""
echo "⏳ Step 9: Waiting for services to be ready..."

echo "Waiting for PostgreSQL..."
sleep 10

echo "Waiting for n8n..."
for i in {1..30}; do
    if docker exec n8n-app-prod wget -q --spider http://localhost:5678/healthz 2>/dev/null; then
        echo "✅ n8n is ready!"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "⚠️  Warning: n8n took longer than expected to start"
        echo "Check logs with: docker-compose -f docker-compose.production.yml logs n8n"
    fi
    echo "  Waiting... ($i/30)"
    sleep 2
done

# ============================================================
# STEP 10: Download Ollama Models
# ============================================================
echo ""
echo "🤖 Step 10: Downloading Ollama models (optional)..."

read -p "Download Ollama models now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Downloading llama2..."
    docker exec n8n-ollama-prod ollama pull llama2
    echo "✅ Ollama models downloaded"
else
    echo "⏭️  Skipped. You can download later with:"
    echo "   docker exec n8n-ollama-prod ollama pull llama2"
fi

# ============================================================
# STEP 11: Display Information
# ============================================================
echo ""
echo "============================================================"
echo "  ✅ DEPLOYMENT COMPLETED SUCCESSFULLY!"
echo "============================================================"
echo ""
echo "📊 Service Status:"
docker-compose -f docker-compose.production.yml ps
echo ""
echo "🌐 Access Information:"
echo "  URL:      https://n8n.alekarpy.uk/"
echo "  Username: $(grep N8N_BASIC_AUTH_USER .env | cut -d '=' -f2)"
echo "  Password: [Check .env file]"
echo ""
echo "📝 Important Next Steps:"
echo ""
echo "1. Configure API Keys in .env file:"
echo "   - OPENAI_API_KEY"
echo "   - GEMINI_API_KEY"
echo "   - TELEGRAM_BOT_TOKEN"
echo "   - ELEVENLABS_API_KEY"
echo "   - etc."
echo ""
echo "2. Restart services after updating .env:"
echo "   docker-compose -f docker-compose.production.yml restart n8n"
echo ""
echo "3. Import workflows:"
echo "   - Access n8n at https://n8n.alekarpy.uk/"
echo "   - Go to Workflows > Import"
echo "   - Import from ./workflows/*.json"
echo ""
echo "4. Configure credentials in n8n UI:"
echo "   - Settings > Credentials"
echo "   - Add credentials for each service"
echo ""
echo "5. Monitor logs:"
echo "   docker-compose -f docker-compose.production.yml logs -f n8n"
echo ""
echo "6. Create manual backup:"
echo "   ./scripts/backup.sh"
echo ""
echo "📚 Documentation:"
echo "   - Production Guide: docs/PRODUCTION.md"
echo "   - Troubleshooting: docs/FAQ.md"
echo ""
echo "============================================================"
echo ""
