# Guia de Deployment en Cloud - n8n + Agentes de IA

Documentacion completa para deployment en servidor cloud.

Ver documentacion completa en: https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes

## Contenido

- Requisitos del servidor
- Preparacion del servidor
- Instalacion de Docker
- Configuracion de SSL/HTTPS
- Seguridad (firewall, fail2ban)
- Backups automaticos
- Monitoreo

## Proveedores Cloud Recomendados

- DigitalOcean
- AWS EC2 (t3.small o t3.medium)
- Google Cloud Platform (e2-small o e2-medium)
- Linode ($10-20/mes)
- Vultr ($6-12/mes)
- Hetzner ($5-15/mes)

## Requisitos del Servidor

### Especificaciones Minimas

- **CPU**: 2 vCPUs (recomendado 4)
- **RAM**: 4GB (recomendado 8GB)
- **Disco**: 20GB SSD (recomendado 50GB)
- **Sistema Operativo**: Ubuntu 22.04 LTS o Debian 11
- **IP Publica**: Si (para HTTPS y webhooks)
- **Dominio**: Necesario para SSL/HTTPS (ej: n8n.tudominio.com)

## Preparacion del Servidor

### Paso 1: Conectar al Servidor

```bash
# Conectar via SSH
ssh root@TU_IP_SERVIDOR

# O si usas un usuario diferente:
ssh usuario@TU_IP_SERVIDOR

```

### Paso 2: Actualizar Sistema

```bash
# Actualizar paquetes
sudo apt update && sudo apt upgrade -y

# Instalar paquetes basicos
sudo apt install -y curl git wget nano ufw fail2ban

```

### Paso 3: Instalar Docker y Docker Compose

```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar instalacion
docker --version
docker-compose --version

# Iniciar Docker al boot
sudo systemctl enable docker
sudo systemctl start docker

```

### Paso 4: Clonar Repositorio

```bash
# Crear directorio para la aplicacion
cd /opt
sudo git clone https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes.git n8n

# Dar permisos
sudo chown -R $USER:$USER /opt/n8n
cd /opt/n8n

```

## CRITICO: Configuracion Segura de Credenciales

### IMPORTANTE: Seguridad en Produccion

**NUNCA** uses credenciales de ejemplo en produccion.
**NUNCA** subas tu archivo `.env` a Git.
**SIEMPRE** usa claves fuertes y unicas.

El archivo `.env` ya esta protegido por `.gitignore` automaticamente.

### Paso 5: Crear Archivo .env Seguro

```bash
# Copiar plantilla
cp .env.example .env

# Editar con nano (o vim)
nano .env

# IMPORTANTE: Configura TODAS estas variables

```

### Variables Criticas de Produccion

Edita tu archivo `.env` con estos valores:

```bash
# ====== SEGURIDAD CRITICA ======

# 1. Password de PostgreSQL (usa una password MUY fuerte)
DB_POSTGRESDB_PASSWORD=genera_password_fuerte_minimo_32_caracteres

# 2. Clave de encriptacion de n8n (32+ caracteres aleatorios)
N8N_ENCRYPTION_KEY=genera_clave_aleatoria_segura_32_caracteres_minimo

# ====== CONFIGURACION DE PRODUCCION ======

# 3. URL publica de tu servidor (IMPORTANTE)
N8N_HOST=n8n.tudominio.com
N8N_PROTOCOL=https
N8N_PORT=443
WEBHOOK_URL=https://n8n.tudominio.com

# 4. Configuracion de n8n
N8N_LOG_LEVEL=info
N8N_LOG_OUTPUT=console,file

# ====== API KEYS ======

# 5. OpenAI (obten en https://platform.openai.com/api-keys)
OPENAI_API_KEY=sk-tu-clave-real-de-openai

# 6. Google Gemini (obten en https://makersuite.google.com/app/apikey)
GEMINI_API_KEY=tu-clave-real-gemini

# 7. ElevenLabs (obten en https://elevenlabs.io/)
ELEVENLABS_API_KEY=tu-clave-real-elevenlabs

# 8. Telegram Bot (obten de @BotFather)
TELEGRAM_BOT_TOKEN=tu-token-real-telegram

# 9. WhatsApp (opcional)
WHATSAPP_VERIFY_TOKEN=tu-token-verificacion-seguro
WHATSAPP_ACCESS_TOKEN=tu-access-token-meta

```

### Generar Credenciales Seguras

```bash
# En tu servidor, genera claves aleatorias fuertes:

# Para N8N_ENCRYPTION_KEY (32 caracteres hexadecimales)
openssl rand -hex 32

# Para DB_POSTGRESDB_PASSWORD (64 caracteres alfanumericos)
openssl rand -base64 48

# Para WHATSAPP_VERIFY_TOKEN (token personalizado)
openssl rand -hex 16

# Copia cada resultado y pegalo en tu archivo .env

```

### Proteger Archivo .env

```bash
# Hacer que solo el propietario pueda leer/escribir .env
chmod 600 .env

# Verificar permisos (debe mostrar -rw-------)
ls -la .env

# NUNCA compartas este archivo ni lo subas a Git

```

## Configuracion de SSL/HTTPS

### Paso 6: Configurar DNS

En tu proveedor de dominios (GoDaddy, Namecheap, Cloudflare, etc.):

1. Crea un registro **A** apuntando a la IP de tu servidor:
   - **Nombre**: `n8n` (o el subdominio que quieras)
   - **Tipo**: A
   - **Valor**: IP_DE_TU_SERVIDOR
   - **TTL**: 300 (5 minutos)

2. Espera 5-15 minutos para que se propague el DNS

3. Verifica que funcione:

```bash
# Verifica que el dominio apunte a tu servidor
ping n8n.tudominio.com

# Debe mostrar la IP de tu servidor

```

### Paso 7: Instalar Certbot (Let's Encrypt)

```bash
# Instalar Certbot
sudo apt install -y certbot python3-certbot-nginx

# Obtener certificado SSL GRATUITO
sudo certbot certonly --standalone -d n8n.tudominio.com --email tu@email.com --agree-tos --no-eff-email

# Los certificados se guardan en:
# /etc/letsencrypt/live/n8n.tudominio.com/fullchain.pem
# /etc/letsencrypt/live/n8n.tudominio.com/privkey.pem

```

### Paso 8: Configurar Nginx (Proxy Inverso)

```bash
# Instalar Nginx
sudo apt install -y nginx

# Crear configuracion para n8n
sudo nano /etc/nginx/sites-available/n8n

```

```nginx
# Pega esta configuracion en /etc/nginx/sites-available/n8n

server {
    listen 80;
    listen [::]:80;
    server_name n8n.tudominio.com;

    # Redirigir HTTP a HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name n8n.tudominio.com;

    # Certificados SSL
    ssl_certificate /etc/letsencrypt/live/n8n.tudominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/n8n.tudominio.com/privkey.pem;

    # Configuracion SSL segura
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256';

    # Headers de seguridad
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Proxy a n8n
    location / {
        proxy_pass http://localhost:5678;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Timeouts para webhooks largos
        proxy_read_timeout 300;
        proxy_connect_timeout 300;
        proxy_send_timeout 300;
    }
}

```

```bash
# Habilitar el sitio
sudo ln -s /etc/nginx/sites-available/n8n /etc/nginx/sites-enabled/

# Verificar configuracion
sudo nginx -t

# Si todo esta OK, reinicia Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx

```

## Configuracion de Firewall

### Paso 9: Configurar UFW (Firewall)

```bash
# Permitir SSH (IMPORTANTE: no te bloquees)
sudo ufw allow 22/tcp

# Permitir HTTP y HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Habilitar firewall
sudo ufw enable

# Verificar estado
sudo ufw status

```

### Paso 10: Configurar fail2ban (Proteccion anti-ataques)

```bash
# fail2ban ya esta instalado, configurarlo:
sudo nano /etc/fail2ban/jail.local

```

```ini
# Pega esta configuracion en /etc/fail2ban/jail.local

[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 5
ignoreip = 127.0.0.1/8

[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
backend = %(sshd_backend)s

[nginx-http-auth]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log

```

```bash
# Reiniciar fail2ban
sudo systemctl restart fail2ban
sudo systemctl enable fail2ban

# Verificar estado
sudo fail2ban-client status

```

## Deployment en Produccion

### Paso 11: Usar docker-compose.production.yml

```bash
# Usar el archivo de produccion (optimizado)
docker-compose -f docker-compose.production.yml up -d

# Ver logs
docker-compose -f docker-compose.production.yml logs -f

# Verificar que todo este corriendo
docker-compose -f docker-compose.production.yml ps

```

### Paso 12: Verificar Deployment

```bash
# 1. Verifica que n8n responda localmente
curl http://localhost:5678

# 2. Verifica que HTTPS funcione
curl https://n8n.tudominio.com

# 3. Abre en navegador
# https://n8n.tudominio.com

```

## Backups Automaticos

### Paso 13: Configurar Backups

```bash
# Hacer ejecutable el script de backup
chmod +x scripts/backup.sh

# Editar crontab
crontab -e

# Agregar linea para backup diario a las 2am
0 2 * * * /opt/n8n/scripts/backup.sh

# Verificar cron
crontab -l

```

## Monitoreo

### Script de Health Check

```bash
# Hacer ejecutable el health check
chmod +x scripts/health-check.sh

# Ejecutar manualmente
./scripts/health-check.sh

# Configurar monitoreo cada 5 minutos
crontab -e

# Agregar:
*/5 * * * * /opt/n8n/scripts/health-check.sh

```

## Renovacion Automatica de SSL

```bash
# Certbot configura renovacion automatica
# Verifica que este activo:
sudo systemctl status certbot.timer

# Prueba renovacion (dry-run)
sudo certbot renew --dry-run

# La renovacion automatica se ejecuta 2 veces al dia

```

## Mantenimiento

```bash
# Ver logs en tiempo real
docker-compose -f docker-compose.production.yml logs -f n8n

# Reiniciar servicio
docker-compose -f docker-compose.production.yml restart n8n

# Actualizar proyecto
cd /opt/n8n
git pull
docker-compose -f docker-compose.production.yml pull
docker-compose -f docker-compose.production.yml up -d

# Backup manual
./scripts/backup.sh

# Restaurar backup
./scripts/restore.sh backups/backup-YYYY-MM-DD.sql

# Ver uso de disco
df -h

# Ver uso de recursos
docker stats

```

## Checklist de Seguridad Final

Antes de poner en produccion, verifica:

- [ ] Archivo `.env` con credenciales fuertes (no las de ejemplo)
- [ ] Archivo `.env` con permisos 600 (chmod 600 .env)
- [ ] N8N_ENCRYPTION_KEY generada aleatoriamente (32+ caracteres)
- [ ] DB_POSTGRESDB_PASSWORD fuerte (32+ caracteres)
- [ ] Todas las API keys son reales (no las de ejemplo)
- [ ] SSL/HTTPS configurado y funcionando
- [ ] Firewall UFW habilitado
- [ ] fail2ban activo y configurado
- [ ] Nginx con headers de seguridad
- [ ] Backups automaticos configurados
- [ ] Health check monitoring activo
- [ ] DNS apuntando correctamente
- [ ] Certbot auto-renewal activo

## Siguientes Pasos

Ahora que tienes n8n en produccion:

1. **Importa Workflows**: Sigue [docs/USAGE.md](USAGE.md)
2. **Configura Credenciales**: Ver [credentials/CREDENTIALS.md](../credentials/CREDENTIALS.md)
3. **Hardening Extra**: Revisa [docs/SECURITY_PRODUCTION.md](SECURITY_PRODUCTION.md)
4. **Monitoreo Avanzado**: Considera Uptime Kuma o Grafana
5. **CDN**: Opcional - Cloudflare para DDoS protection

## Soporte y Recursos

- **Documentacion**: https://docs.n8n.io
- **Comunidad**: https://community.n8n.io
- **GitHub**: https://github.com/BarryGon911/n8n-MCP-Automatizacion-y-Agentes-de-IA-Inteligentes
- **Issues**: Reporta problemas en GitHub Issues

**Tu servidor esta listo para produccion!** 🚀
