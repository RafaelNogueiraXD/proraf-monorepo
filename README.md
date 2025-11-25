# ProRAF - Sistema de Rastreabilidade Agrícola

Este projeto contém o sistema completo ProRAF com frontend React/Vite e backend FastAPI.

## 🚀 Execução Rápida

### Pré-requisitos
- Docker
- Docker Compose

### Executar em Produção
```bash
./run.sh start
```

### Executar em Desenvolvimento
```bash
./run.sh dev
```

## 📋 Estrutura do Projeto

```
proraf-interface/
├── proraf-agro-trace/          # Frontend React/Vite
│   ├── Dockerfile              # Build multi-stage para produção
│   ├── nginx.conf              # Configuração do Nginx
│   └── ...
├── proraf-backend/             # Backend FastAPI
│   ├── Dockerfile              # Build otimizado Python
│   ├── Dockerfile.dev          # Dockerfile para desenvolvimento
│   └── ...
├── docker-compose.yml          # Orquestração dos serviços
├── run.sh                      # Script de execução
└── README.md                   # Este arquivo
```

## 🔧 Comandos Disponíveis

O script `run.sh` fornece os seguintes comandos:

### Comandos Principais
```bash
./run.sh start      # Inicia em modo produção
./run.sh dev        # Inicia em modo desenvolvimento  
./run.sh stop       # Para todos os serviços
./run.sh restart    # Reinicia os serviços
```

### Comandos de Manutenção
```bash
./run.sh build      # Constrói as imagens Docker
./run.sh logs       # Mostra logs de todos os serviços
./run.sh logs backend   # Mostra logs apenas do backend
./run.sh status     # Mostra status dos serviços
./run.sh clean      # Remove containers e imagens não utilizados
```

### Ajuda
```bash
./run.sh help       # Mostra todos os comandos disponíveis
```

## 🌐 URLs de Acesso

### Modo Produção
- **Frontend**: http://localhost
- **Backend API**: http://localhost:8000
- **Documentação API**: http://localhost:8000/docs

### Modo Desenvolvimento
- **Frontend Dev**: http://localhost:8080
- **Backend Dev**: http://localhost:8001
- **Documentação API Dev**: http://localhost:8001/docs

## 🐳 Docker Compose

### Serviços Disponíveis

#### Produção
- **frontend**: Aplicação React com Nginx
- **backend**: API FastAPI

#### Desenvolvimento
- **frontend-dev**: Servidor de desenvolvimento Vite
- **backend-dev**: API com hot reload

### Profiles
- **default**: Serviços de produção
- **development**: Serviços de desenvolvimento

## 📝 Variáveis de Ambiente

### Backend
Crie um arquivo `.env` no diretório `proraf-backend/` com:

```env
DEBUG=False
DATABASE_URL=sqlite:///./proraf.db
CORS_ORIGINS=http://localhost,http://localhost:3000,http://localhost:80
SECRET_KEY=your-secret-key-here
```

### Frontend
Crie um arquivo `.env` no diretório `proraf-agro-trace/` com:

```env
VITE_API_URL=http://localhost:8000
```

## 🔧 Desenvolvimento

### Executar Individualmente

#### Backend
```bash
cd proraf-backend
docker-compose --profile development up backend-dev
```

#### Frontend
```bash
cd proraf-agro-trace
docker build -t proraf-frontend .
docker run -p 80:80 proraf-frontend
```

### Logs e Debug
```bash
# Ver logs em tempo real
./run.sh logs

# Ver logs de um serviço específico
./run.sh logs backend
./run.sh logs frontend

# Executar comando dentro do container
docker-compose exec backend bash
docker-compose exec frontend sh
```

## 🔄 Atualizações

Para atualizar após mudanças no código:

```bash
./run.sh restart
```

Para rebuild completo:
```bash
./run.sh stop
./run.sh clean
./run.sh start
```

## 🐛 Troubleshooting

### Porta já em uso
Se as portas 80, 8000, 8001 ou 8080 estiverem em uso:

```bash
# Parar todos os serviços
./run.sh stop

# Ver processos usando as portas
sudo lsof -i :80
sudo lsof -i :8000

# Matar processo específico
sudo kill -9 <PID>
```

### Problemas com permissões
```bash
# Recriar volumes com permissões corretas
./run.sh clean
./run.sh start
```

### Cache de build
```bash
# Rebuild sem cache
docker-compose build --no-cache
```

## 📦 Produção

Para deployment em produção:

1. Ajuste as variáveis de ambiente
2. Configure SSL/HTTPS no nginx.conf
3. Use um banco de dados externo (PostgreSQL)
4. Configure backup dos volumes

```bash
./run.sh start
```

## 🤝 Contribuição

1. Faça suas alterações nos arquivos fonte
2. Teste localmente com `./run.sh dev`
3. Faça commit das mudanças
4. Para produção use `./run.sh start`

## 📄 Licença

Este projeto é desenvolvido para o sistema ProRAF de rastreabilidade agrícola.