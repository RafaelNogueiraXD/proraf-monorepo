#!/bin/bash
# Script de Deploy Rápido para Servidor Hostinger
# Execute este script NO SERVIDOR após conectar via SSH

set -e

echo "🚀 ProRAF - Deploy Rápido"
echo "=========================="
echo ""

# Atualizar sistema
echo "📦 Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar dependências básicas
echo "🔧 Instalando dependências..."
sudo apt install -y git curl wget

# Instalar Docker se não estiver instalado
if ! command -v docker &> /dev/null; then
    echo "🐳 Instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    echo "✅ Docker instalado!"
else
    echo "✅ Docker já instalado"
fi

# Verificar Docker Compose
if ! docker compose version &> /dev/null; then
    echo "📦 Instalando Docker Compose..."
    sudo apt install -y docker-compose-plugin
else
    echo "✅ Docker Compose já instalado"
fi

# Criar diretório para aplicação
echo "📁 Criando diretório..."
sudo mkdir -p /var/www
sudo chown $USER:$USER /var/www
cd /var/www

# Clonar repositório (se ainda não existe)
if [ ! -d "proraf-interface" ]; then
    echo "📥 Clonando repositório..."
    git clone https://github.com/RafaelNogueiraXD/proraf-agro-trace.git proraf-interface
    cd proraf-interface
else
    echo "📥 Atualizando repositório..."
    cd proraf-interface
    git pull origin main
fi

echo ""
echo "✅ Preparação concluída!"
echo ""
echo "Próximos passos:"
echo "1. Configurar arquivo .env (copiar de .env.example)"
echo "2. Executar: ./run.sh build"
echo "3. Executar: ./run.sh start"
echo ""
echo "Comandos úteis:"
echo "  ./run.sh status  - Ver status dos containers"
echo "  ./run.sh logs    - Ver logs"
echo "  ./run.sh stop    - Parar containers"