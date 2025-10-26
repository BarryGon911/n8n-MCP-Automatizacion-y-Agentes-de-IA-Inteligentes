#!/bin/bash

# Setup script for n8n Automation & AI Agents project
# This script automates the initial setup process

set -e

echo "========================================="
echo "n8n Automation & AI Agents Setup"
echo "========================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed."
    echo "Please install Docker from https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "Error: Docker Compose is not installed."
    echo "Please install Docker Compose from https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✓ Docker and Docker Compose are installed"
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo "✓ .env file created"
    echo ""
    echo "⚠️  IMPORTANT: Please edit the .env file with your actual credentials"
    echo "   Required configurations:"
    echo "   - N8N_BASIC_AUTH_USER and N8N_BASIC_AUTH_PASSWORD"
    echo "   - DB_POSTGRESDB_PASSWORD"
    echo "   - API keys for services you plan to use (OpenAI, Gemini, etc.)"
    echo ""
    read -p "Press Enter to continue after editing .env file..."
else
    echo "✓ .env file already exists"
fi

echo ""
echo "Starting Docker services..."
docker-compose up -d

echo ""
echo "Waiting for services to be ready..."
sleep 10

# Check if services are running
if docker-compose ps | grep -q "Up"; then
    echo "✓ Services are running"
else
    echo "✗ Some services failed to start. Check logs with: docker-compose logs"
    exit 1
fi

echo ""
echo "========================================="
echo "Setup Complete!"
echo "========================================="
echo ""
echo "Access n8n at: http://localhost:5678"
echo ""
echo "⚠️  IMPORTANT: Update credentials in .env file before production use!"
echo "Default values (configured in .env):"
echo "  Username: Set in N8N_BASIC_AUTH_USER"
echo "  Password: Set in N8N_BASIC_AUTH_PASSWORD"
echo ""
echo "Next steps:"
echo "1. Open http://localhost:5678 in your browser"
echo "2. Log in with your credentials"
echo "3. Import workflows from the workflows/ directory"
echo "4. Configure credentials for each service you plan to use"
echo "5. Activate the workflows you need"
echo ""
echo "Optional: Pull Ollama models for local AI"
echo "  docker exec -it \$(docker-compose ps -q ollama) ollama pull llama2"
echo ""
echo "For detailed instructions, see docs/INSTALLATION.md"
echo ""
