# Deployment Guide

## Prerequisites

- Docker and Docker Compose installed
- Domain name (optional, for production)
- SSL certificate (optional, for HTTPS)

## Local Development Deployment

### Using Docker Compose

1. Clone the repository:
```bash
git clone <repository-url>
cd n8n-MCP-Automatizaci-n---Agentes-de-IA-Inteligentes
```

2. Configure environment:
```bash
cp .env.example .env
nano .env  # Edit with your settings
```

3. Start services:
```bash
docker-compose up -d
```

4. Check logs:
```bash
docker-compose logs -f
```

5. Access services:
- n8n: http://localhost:5678
- MCP Server: http://localhost:3000

### Manual Deployment

1. Install PostgreSQL:
```bash
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
```

2. Create database:
```bash
sudo -u postgres psql
CREATE DATABASE n8n;
CREATE USER n8n_user WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE n8n TO n8n_user;
\q
```

3. Install pgvector:
```bash
cd /tmp
git clone https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install
```

4. Initialize database:
```bash
psql -U n8n_user -d n8n -f src/database/init.sql
```

5. Install dependencies and build:
```bash
npm install
npm run build
```

6. Start services with PM2:
```bash
npm install -g pm2

# Start n8n
pm2 start n8n --name n8n-server

# Start MCP server
pm2 start dist/mcp-server/index.js --name mcp-server

pm2 save
pm2 startup
```

## Production Deployment

### Using Docker with Nginx Reverse Proxy

1. Install Nginx:
```bash
sudo apt-get install nginx certbot python3-certbot-nginx
```

2. Configure Nginx (`/etc/nginx/sites-available/n8n-mcp`):
```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 80;
    server_name mcp.your-domain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

3. Enable site and get SSL:
```bash
sudo ln -s /etc/nginx/sites-available/n8n-mcp /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
sudo certbot --nginx -d your-domain.com -d mcp.your-domain.com
```

4. Update `.env` for production:
```env
N8N_HOST=0.0.0.0
N8N_PROTOCOL=https
WEBHOOK_URL=https://your-domain.com/
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=strong_password_here
```

5. Start with production compose:
```bash
docker-compose -f docker-compose.prod.yml up -d
```

### Kubernetes Deployment

1. Create namespace:
```bash
kubectl create namespace n8n-mcp
```

2. Create secrets:
```bash
kubectl create secret generic n8n-secrets \
  --from-literal=db-password=your_db_password \
  --from-literal=openai-api-key=your_openai_key \
  -n n8n-mcp
```

3. Apply Kubernetes manifests:
```bash
kubectl apply -f k8s/postgres.yaml -n n8n-mcp
kubectl apply -f k8s/n8n.yaml -n n8n-mcp
kubectl apply -f k8s/mcp-server.yaml -n n8n-mcp
kubectl apply -f k8s/ingress.yaml -n n8n-mcp
```

### AWS Deployment

#### Using EC2

1. Launch EC2 instance (t3.medium or larger)
2. Install Docker and Docker Compose
3. Clone repository and configure
4. Setup security groups:
   - Port 80 (HTTP)
   - Port 443 (HTTPS)
   - Port 5678 (n8n)
   - Port 3000 (MCP)
5. Use Elastic IP for static IP
6. Follow production deployment steps above

#### Using ECS

1. Build and push Docker images:
```bash
aws ecr create-repository --repository-name n8n-mcp
docker build -t n8n-mcp:latest .
docker tag n8n-mcp:latest <account-id>.dkr.ecr.region.amazonaws.com/n8n-mcp:latest
docker push <account-id>.dkr.ecr.region.amazonaws.com/n8n-mcp:latest
```

2. Create ECS task definition
3. Create ECS service
4. Setup Application Load Balancer

### Google Cloud Deployment

#### Using Cloud Run

1. Build container:
```bash
gcloud builds submit --tag gcr.io/PROJECT_ID/mcp-server
```

2. Deploy to Cloud Run:
```bash
gcloud run deploy mcp-server \
  --image gcr.io/PROJECT_ID/mcp-server \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

#### Using GKE

1. Create GKE cluster:
```bash
gcloud container clusters create n8n-mcp-cluster \
  --num-nodes=3 \
  --zone=us-central1-a
```

2. Apply Kubernetes manifests as shown above

## Monitoring and Logging

### Using PM2

```bash
pm2 logs
pm2 monit
pm2 status
```

### Using Docker

```bash
docker-compose logs -f
docker stats
```

### Setup Log Aggregation

Use services like:
- CloudWatch (AWS)
- Stackdriver (GCP)
- ELK Stack
- Grafana + Loki

## Backup Strategy

### Database Backup

```bash
# Daily backup script
pg_dump -U n8n_user n8n > backup_$(date +%Y%m%d).sql

# Automated with cron
0 2 * * * /usr/bin/pg_dump -U n8n_user n8n > /backups/n8n_$(date +\%Y\%m\%d).sql
```

### Full Backup

```bash
# Backup volumes
docker run --rm \
  -v n8n-data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/n8n-data.tar.gz /data
```

## Security Best Practices

1. **Use strong passwords** for all services
2. **Enable HTTPS** in production
3. **Restrict database access** to localhost or VPC
4. **Use secrets management** (AWS Secrets Manager, Vault)
5. **Regular updates** of dependencies
6. **Monitor logs** for suspicious activity
7. **Implement rate limiting** on public endpoints
8. **Use API keys** for MCP server access
9. **Regular backups** and disaster recovery testing
10. **Network segmentation** using VPC/subnets

## Scaling

### Horizontal Scaling

1. Use load balancer (Nginx, HAProxy)
2. Run multiple MCP server instances
3. Use Redis for session management
4. Database read replicas for heavy read workloads

### Vertical Scaling

Upgrade instance types:
- CPU: For AI agent processing
- Memory: For large context windows
- Storage: For knowledge base growth

## Troubleshooting Production Issues

### Service not responding
```bash
docker-compose restart
pm2 restart all
```

### Database connection issues
```bash
docker-compose logs postgres
netstat -tlnp | grep 5432
```

### High memory usage
```bash
docker stats
pm2 monit
```

### SSL certificate renewal
```bash
sudo certbot renew --dry-run
sudo certbot renew
```
