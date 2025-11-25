#!/bin/bash

# Script para inicializar o monorepo Git ProRAF
# Este script prepara o repositório para hospedar ambos os projetos

set -e

echo "🚀 Inicializando Monorepo ProRAF..."
echo ""

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se estamos no diretório correto
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${YELLOW}⚠️  docker-compose.yml não encontrado. Execute este script na raiz do projeto.${NC}"
    exit 1
fi

echo -e "${BLUE}📦 Etapa 1: Verificando estrutura...${NC}"
if [ ! -d "proraf-agro-trace" ] || [ ! -d "proraf-backend" ]; then
    echo -e "${YELLOW}⚠️  Diretórios proraf-agro-trace ou proraf-backend não encontrados!${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Estrutura OK${NC}"
echo ""

echo -e "${BLUE}🔧 Etapa 2: Inicializando Git...${NC}"
if [ ! -d ".git" ]; then
    git init
    echo -e "${GREEN}✓ Repositório Git inicializado${NC}"
else
    echo -e "${YELLOW}ℹ️  Repositório Git já existe${NC}"
fi
echo ""

echo -e "${BLUE}📝 Etapa 3: Configurando .gitignore...${NC}"
# O .gitignore já foi criado anteriormente
if [ -f ".gitignore" ]; then
    echo -e "${GREEN}✓ .gitignore configurado${NC}"
else
    echo -e "${YELLOW}⚠️  .gitignore não encontrado!${NC}"
fi
echo ""

echo -e "${BLUE}📄 Etapa 4: Preparando arquivos...${NC}"
# Criar README principal se não existir
if [ ! -f "README.md" ]; then
    cp README-MONOREPO.md README.md
    echo -e "${GREEN}✓ README.md criado${NC}"
else
    echo -e "${YELLOW}ℹ️  README.md já existe${NC}"
fi
echo ""

echo -e "${BLUE}🔐 Etapa 5: Verificando arquivos sensíveis...${NC}"
# Listar arquivos que não devem ser commitados
sensitive_files=()
[ -f ".env" ] && sensitive_files+=(".env")
[ -f "proraf-backend/.env" ] && sensitive_files+=("proraf-backend/.env")
[ -f "proraf-agro-trace/.env" ] && sensitive_files+=("proraf-agro-trace/.env")
[ -f "proraf-backend/client_secret.json" ] && sensitive_files+=("proraf-backend/client_secret.json")

if [ ${#sensitive_files[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Arquivos sensíveis encontrados (não serão commitados):${NC}"
    for file in "${sensitive_files[@]}"; do
        echo "   - $file"
    done
else
    echo -e "${GREEN}✓ Nenhum arquivo sensível encontrado${NC}"
fi
echo ""

echo -e "${BLUE}📦 Etapa 6: Adicionando arquivos ao Git...${NC}"
git add .gitignore
git add README.md
git add docker-compose.yml
git add run.sh
git add .env.example
git add DEPLOY-GUIDE.md
git add proraf-agro-trace/
git add proraf-backend/

# Verificar status
echo ""
echo -e "${BLUE}📊 Status do Git:${NC}"
git status
echo ""

echo -e "${GREEN}✅ Monorepo preparado com sucesso!${NC}"
echo ""
echo -e "${BLUE}Próximos passos:${NC}"
echo "1. Revisar os arquivos adicionados: git status"
echo "2. Fazer o primeiro commit: git commit -m \"Initial commit: ProRAF monorepo\""
echo "3. Adicionar repositório remoto: git remote add origin <URL>"
echo "4. Enviar para GitHub: git push -u origin main"
echo ""
echo -e "${YELLOW}Importante:${NC}"
echo "- Verifique se todos os arquivos .env estão no .gitignore"
echo "- Não commite credenciais ou chaves de API"
echo "- Use .env.example como referência"
echo ""
echo -e "${BLUE}Para criar o repositório no GitHub:${NC}"
echo "1. Acesse: https://github.com/new"
echo "2. Nome: proraf-monorepo"
echo "3. Descrição: Sistema completo de rastreabilidade agrícola"
echo "4. Mantenha como Privado (recomendado)"
echo "5. NÃO inicialize com README, .gitignore ou licença"
echo "6. Crie o repositório"
echo "7. Execute os comandos sugeridos para 'push an existing repository'"