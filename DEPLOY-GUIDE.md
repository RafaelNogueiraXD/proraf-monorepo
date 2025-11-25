# 🚀 Guia de Deploy - Servidor Hostinger KVM2

## 📋 Informações do Servidor

- **Host**: `ssh rafaelnogueira@2a02:4780:14:5b4f::1`
- **OS**: Ubuntu Server (recomendado 22.04 LTS)
- **IPv6**: `2a02:4780:14:5b4f::1`

## 🔧 Passo 1: Preparação do Servidor

### 1.1 Conectar ao Servidor
```bash
ssh rafaelnogueira@2a02:4780:14:5b4f::1
```

### 1.2 Atualizar Sistema
```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y curl wget git ufw
```

### 1.3 Criar usuário para deploy (opcional, mas recomendado)
```bash
# Se quiser criar um usuário específico para a aplicação
sudo adduser proraf
sudo usermod -aG sudo proraf
```

## 🐳 Passo 2: Instalar Docker

### 2.1 Instalar Docker Engine
```bash
# Remover versões antigas
sudo apt remove docker docker-engine docker.io containerd runc

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
sudo usermod -aG docker rafaelnogueira

# Habilitar Docker no boot
sudo systemctl enable docker
sudo systemctl start docker

# Verificar instalação
docker --version
```

### 2.2 Instalar Docker Compose
```bash
# Instalar Docker Compose (já vem com Docker Desktop, mas confirmar)
sudo apt install -y docker-compose-plugin

# Verificar
docker compose version
```

## 🔥 Passo 3: Configurar Firewall

```bash
# Resetar UFW (se necessário)
sudo ufw --force reset

# Configurar regras
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Permitir SSH (IMPORTANTE: fazer antes de habilitar!)
sudo ufw allow 22/tcp
sudo ufw allow ssh

# Permitir HTTP e HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Permitir API (temporário, depois será via reverse proxy)
sudo ufw allow 8000/tcp

# Habilitar UFW
sudo ufw enable

# Verificar status
sudo ufw status verbose
```

## 📦 Passo 4: Clonar Repositório

```bash
# Criar diretório para aplicações
sudo mkdir -p /var/www
sudo chown $USER:$USER /var/www
cd /var/www

# Clonar o repositório monorepo
git clone https://github.com/RafaelNogueiraXD/proraf-monorepo.git
cd proraf-monorepo

# Verificar estrutura
ls -la
```

## ⚙️ Passo 5: Configurar Variáveis de Ambiente

### 5.1 Criar arquivo .env principal
```bash
cp .env.example .env
nano .env
```

**Configurações importantes para produção:**
```env
# Backend
BACKEND_ENV=production
DEBUG=False
DATABASE_URL=sqlite:///./proraf.db
SECRET_KEY=$(openssl rand -hex 32)
API_KEY=$(openssl rand -hex 32)

# Frontend
VITE_API_BASE_URL=https://seu-dominio.com
VITE_GOOGLE_CLIENT_ID=seu-client-id-aqui

# Portas
FRONTEND_PORT=3000
BACKEND_PORT=8000
```

### 5.2 Configurar .env do Backend
```bash
cd proraf-backend
cp .env.example .env
nano .env
```

### 5.3 Configurar .env do Frontend
```bash
cd ../proraf-agro-trace
cp .env.example .env
nano .env
```

## 🏗️ Passo 6: Build e Deploy

```bash
# Voltar para raiz do projeto
cd /var/www/proraf-monorepo

# Tornar script executável (se necessário)
chmod +x run.sh

# Build das imagens
./run.sh build

# Iniciar em produção
./run.sh start

# Verificar status
./run.sh status
```

## 🔍 Passo 7: Verificar Deployment

```bash
# Ver logs
./run.sh logs

# Testar backend
curl http://localhost:8000/health

# Testar frontend
curl -I http://localhost:3000

# Verificar containers
docker ps
```

## 🌐 Passo 8: Configurar Nginx (Reverse Proxy)

### 8.1 Instalar Nginx
```bash
sudo apt install -y nginx
```

### 8.2 Criar configuração do site
```bash
sudo nano /etc/nginx/sites-available/proraf
```

**Conteúdo:**
```nginx
server {
    listen 80;
    server_name seu-dominio.com www.seu-dominio.com;

    # Frontend
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Backend API
    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Docs da API
    location /docs {
        proxy_pass http://localhost:8000/docs;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /openapi.json {
        proxy_pass http://localhost:8000/openapi.json;
        proxy_set_header Host $host;
    }
}
```

### 8.3 Ativar site
```bash
# Criar link simbólico
sudo ln -s /etc/nginx/sites-available/proraf /etc/nginx/sites-enabled/

# Remover site default (opcional)
sudo rm /etc/nginx/sites-enabled/default

# Testar configuração
sudo nginx -t

# Reiniciar Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

## 🔒 Passo 9: Configurar SSL/HTTPS

```bash
# Instalar Certbot
sudo apt install -y certbot python3-certbot-nginx

# Obter certificado SSL
sudo certbot --nginx -d seu-dominio.com -d www.seu-dominio.com

# Testar renovação automática
sudo certbot renew --dry-run
```

## 📊 Passo 10: Configurar Monitoramento

### 10.1 Instalar htop e netdata (opcional)
```bash
sudo apt install -y htop

# Netdata para monitoramento avançado
bash <(curl -Ss https://my-netdata.io/kickstart.sh)
```

### 10.2 Configurar logs
```bash
# Ver logs do sistema
sudo journalctl -u docker -f

# Ver logs da aplicação
cd /var/www/proraf-monorepo
./run.sh logs
```

## 🔄 Passo 11: Configurar Backup

### 11.1 Criar script de backup
```bash
sudo nano /usr/local/bin/backup-proraf.sh
```

**Conteúdo:**
```bash
#!/bin/bash
BACKUP_DIR="/backups/proraf"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup do banco de dados
docker exec proraf-backend cp /app/proraf.db /tmp/proraf_$DATE.db
docker cp proraf-backend:/tmp/proraf_$DATE.db $BACKUP_DIR/

# Backup dos volumes
docker run --rm -v proraf-backend-data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/backend-data_$DATE.tar.gz /data

# Limpar backups antigos (manter últimos 7 dias)
find $BACKUP_DIR -name "*.db" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup concluído: $DATE"
```

### 11.2 Tornar executável e agendar
```bash
sudo chmod +x /usr/local/bin/backup-proraf.sh

# Adicionar ao crontab (backup diário às 2h da manhã)
sudo crontab -e
# Adicionar linha:
0 2 * * * /usr/local/bin/backup-proraf.sh >> /var/log/proraf-backup.log 2>&1
```

## ✅ Passo 12: Verificação Final

```bash
# Verificar todos os serviços
sudo systemctl status docker
sudo systemctl status nginx
docker ps

# Testar aplicação
curl -I https://seu-dominio.com
curl https://seu-dominio.com/api/health

# Verificar logs
./run.sh logs | tail -50
```

## 🚨 Troubleshooting

### Container não inicia
```bash
# Ver logs específicos
docker logs proraf-backend
docker logs proraf-frontend

# Reiniciar containers
./run.sh restart
```

### Porta já em uso
```bash
# Verificar o que está usando a porta
sudo lsof -i :80
sudo lsof -i :8000

# Parar serviço conflitante
sudo systemctl stop apache2  # se aplicável
```

### Problemas com permissões
```bash
# Ajustar permissões do projeto
sudo chown -R $USER:$USER /var/www/proraf-monorepo

# Ajustar permissões do Docker
sudo chmod 666 /var/run/docker.sock
```

## 📝 Comandos Úteis

```bash
# Atualizar aplicação
cd /var/www/proraf-monorepo
git pull origin main
./run.sh restart

# Ver uso de recursos
docker stats

# Limpar sistema Docker
./run.sh clean
docker system prune -a

# Backup manual
/usr/local/bin/backup-proraf.sh
```

## 🔗 Links Úteis

- **Aplicação**: https://seu-dominio.com
- **API Docs**: https://seu-dominio.com/docs
- **Monitoramento**: http://seu-ip:19999 (se Netdata instalado)

## 📞 Suporte

Em caso de problemas, verificar:
1. Logs dos containers: `./run.sh logs`
2. Status do Docker: `sudo systemctl status docker`
3. Status do Nginx: `sudo systemctl status nginx`
4. Logs do sistema: `sudo journalctl -xe`