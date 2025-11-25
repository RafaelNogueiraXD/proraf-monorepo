# ProRAF - Sistema Completo de Rastreabilidade Agrícola

Sistema integrado de rastreabilidade agrícola com frontend React/Vite e backend FastAPI.

## 📁 Estrutura do Projeto

```
proraf-monorepo/
├── proraf-agro-trace/          # Frontend React/Vite
├── proraf-backend/             # Backend FastAPI
├── docker-compose.yml          # Orquestração Docker
├── run.sh                      # Script de execução
├── .env.example                # Exemplo de variáveis de ambiente
├── .gitignore                  # Arquivos ignorados pelo Git
└── README.md                   # Este arquivo
```

## 🚀 Deploy Rápido com Docker

### Pré-requisitos
- Docker 20.10+
- Docker Compose 2.0+
- Git

### Instalação e Execução

```bash
# Clone o repositório
git clone <URL_DO_REPOSITORIO>
cd proraf-monorepo

# Configure as variáveis de ambiente
cp .env.example .env
# Edite o .env com suas configurações

# Execute em produção
./run.sh start

# Ou em desenvolvimento
./run.sh dev
```

## 🌐 URLs de Acesso

### Produção
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **Documentação API**: http://localhost:8000/docs

### Desenvolvimento
- **Frontend Dev**: http://localhost:8080
- **Backend Dev**: http://localhost:8001
- **Documentação API Dev**: http://localhost:8001/docs

## 🔧 Comandos Disponíveis

O script `run.sh` fornece os seguintes comandos:

```bash
./run.sh start      # Inicia em modo produção
./run.sh dev        # Inicia em modo desenvolvimento  
./run.sh stop       # Para todos os serviços
./run.sh restart    # Reinicia os serviços
./run.sh build      # Constrói as imagens Docker
./run.sh logs       # Mostra logs de todos os serviços
./run.sh status     # Mostra status dos serviços
./run.sh clean      # Remove containers e imagens não utilizados
./run.sh help       # Mostra todos os comandos disponíveis
```

## 📦 Repositórios

Este é um monorepo que integra:

- **proraf-agro-trace**: Frontend em React/Vite com TypeScript
  - Repository: https://github.com/RafaelNogueiraXD/proraf-agro-trace
  
- **proraf-backend**: Backend em FastAPI com Python
  - Repository: (URL do repositório backend)

## 🔐 Variáveis de Ambiente

### Backend (.env no diretório proraf-backend/)
```env
DEBUG=False
DATABASE_URL=sqlite:///./proraf.db
SECRET_KEY=your-secret-key-here
API_KEY=your-api-key-here
```

### Frontend (.env no diretório proraf-agro-trace/)
```env
VITE_API_BASE_URL=http://localhost:8000
VITE_GOOGLE_CLIENT_ID=your-google-client-id
VITE_API_KEY=your-api-key-here
VITE_ERC=erc721
```

## 🏗️ Arquitetura

### Backend (FastAPI)
- **Linguagem**: Python 3.11
- **Framework**: FastAPI
- **ORM**: SQLAlchemy
- **Banco**: SQLite (desenvolvimento) / PostgreSQL (produção)
- **Autenticação**: JWT + Google OAuth

### Frontend (React)
- **Linguagem**: TypeScript
- **Framework**: React 18 + Vite
- **UI**: Shadcn/ui + Tailwind CSS
- **Build**: Bun
- **Deploy**: Nginx

## 🚢 Deploy em Produção

### 1. Servidor
```bash
# Conectar ao servidor
ssh rafaelnogueira@2a02:4780:14:5b4f::1

# Clonar repositório
git clone <URL_DO_REPOSITORIO>
cd proraf-monorepo
```

### 2. Configuração
```bash
# Instalar Docker e Docker Compose
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Configurar variáveis de ambiente
cp .env.example .env
nano .env  # Editar com configurações de produção
```

### 3. Deploy
```bash
# Build e start
./run.sh start

# Verificar status
./run.sh status
./run.sh logs
```

## 🔒 Segurança

### Firewall
```bash
# Configurar UFW
sudo ufw allow 22/tcp   # SSH
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

### SSL/HTTPS
```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# Obter certificado
sudo certbot --nginx -d seu-dominio.com
```

## 📊 Monitoramento

```bash
# Ver logs em tempo real
./run.sh logs

# Ver logs de serviço específico
docker-compose logs -f backend
docker-compose logs -f frontend

# Status dos containers
docker-compose ps
```

## 🔄 Atualização

```bash
# Pull das atualizações
git pull origin main

# Rebuild e restart
./run.sh restart
```

## 🐛 Troubleshooting

### Porta já em uso
```bash
# Verificar processos usando as portas
sudo lsof -i :80
sudo lsof -i :8000

# Parar serviços conflitantes
sudo systemctl stop apache2  # Se Apache estiver rodando
```

### Problemas com Docker
```bash
# Limpar tudo e recomeçar
./run.sh clean
docker system prune -a
./run.sh start
```

### Logs de erro
```bash
# Backend
docker-compose logs backend --tail=50

# Frontend
docker-compose logs frontend --tail=50
```

## 📝 Licença

Este projeto é desenvolvido para o sistema ProRAF de rastreabilidade agrícola.

## 👥 Equipe

- **Desenvolvedor**: Rafael Nogueira
- **Instituição**: UNIPAMPA

## 📞 Suporte

Para suporte técnico, entre em contato através de:
- Email: rafaelnogueira.aluno@unipampa.edu.br
- GitHub Issues: (URL do repositório)/issues