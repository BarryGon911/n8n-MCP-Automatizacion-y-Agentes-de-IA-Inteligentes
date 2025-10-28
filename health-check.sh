#!/bin/bash

echo "🔍 Checking n8n-MCP Automation Health..."
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if docker-compose is running
echo "Checking Docker services..."
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓${NC} Docker services are running"
else
    echo -e "${RED}✗${NC} Docker services are not running"
    echo "  Run: docker-compose up -d"
    exit 1
fi

# Check n8n
echo ""
echo "Checking n8n..."
if curl -s http://localhost:5678 > /dev/null; then
    echo -e "${GREEN}✓${NC} n8n is accessible at http://localhost:5678"
else
    echo -e "${RED}✗${NC} n8n is not accessible"
fi

# Check MCP Server
echo ""
echo "Checking MCP Server..."
HEALTH=$(curl -s http://localhost:3000/health)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} MCP Server is healthy"
    echo "  Response: $HEALTH"
else
    echo -e "${RED}✗${NC} MCP Server is not responding"
fi

# Check PostgreSQL
echo ""
echo "Checking PostgreSQL..."
if docker-compose exec -T postgres pg_isready -U n8n_user > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} PostgreSQL is running"
else
    echo -e "${RED}✗${NC} PostgreSQL is not accessible"
fi

# Check Ollama
echo ""
echo "Checking Ollama..."
if curl -s http://localhost:11434/api/tags > /dev/null; then
    echo -e "${GREEN}✓${NC} Ollama is running"
    echo "  Available at http://localhost:11434"
else
    echo -e "${YELLOW}⚠${NC} Ollama is not responding (optional)"
fi

echo ""
echo "Health check complete!"
