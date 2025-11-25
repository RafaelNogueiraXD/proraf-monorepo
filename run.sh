#!/bin/bash

# ProRAF - Script de Deploy e Execução
# Author: GitHub Copilot
# Description: Script para fazer build e executar as aplicações ProRAF

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado. Por favor, instale o Docker primeiro."
        exit 1
    fi

    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        print_error "Docker Compose não está instalado. Por favor, instale o Docker Compose primeiro."
        exit 1
    fi

    print_success "Docker e Docker Compose encontrados"
}

# Build images
build_images() {
    print_info "Construindo as imagens Docker..."
    
    if docker compose build; then
        print_success "Imagens construídas com sucesso"
    else
        print_error "Falha ao construir as imagens"
        exit 1
    fi
}

# Start services in production mode
start_production() {
    print_info "Iniciando serviços em modo produção..."
    
    docker compose down --remove-orphans 2>/dev/null || true
    
    if docker compose up -d backend frontend; then
        print_success "Serviços iniciados com sucesso"
        print_info "Frontend disponível em: http://localhost"
        print_info "Backend API disponível em: http://localhost:8000"
        print_info "Documentação da API: http://localhost:8000/docs"
    else
        print_error "Falha ao iniciar os serviços"
        exit 1
    fi
}

# Start services in development mode
start_development() {
    print_info "Iniciando serviços em modo desenvolvimento..."
    
    docker compose down --remove-orphans 2>/dev/null || true
    
    if docker compose --profile development up -d backend-dev frontend-dev; then
        print_success "Serviços de desenvolvimento iniciados com sucesso"
        print_info "Frontend Dev disponível em: http://localhost:8080"
        print_info "Backend Dev disponível em: http://localhost:8001"
        print_info "Documentação da API: http://localhost:8001/docs"
    else
        print_error "Falha ao iniciar os serviços de desenvolvimento"
        exit 1
    fi
}

# Stop all services
stop_services() {
    print_info "Parando todos os serviços..."
    
    docker compose down --remove-orphans
    print_success "Serviços parados com sucesso"
}

# Show logs
show_logs() {
    local service=${1:-""}
    
    if [ -z "$service" ]; then
        docker compose logs -f
    else
        docker compose logs -f "$service"
    fi
}

# Check service status
check_status() {
    print_info "Status dos serviços:"
    docker compose ps
}

# Clean up
cleanup() {
    print_info "Limpando containers, imagens e volumes não utilizados..."
    
    docker compose down --remove-orphans --volumes
    docker system prune -f
    
    print_success "Limpeza concluída"
}

# Show help
show_help() {
    echo -e "${BLUE}ProRAF - Sistema de Rastreabilidade Agrícola${NC}"
    echo ""
    echo -e "${YELLOW}Uso:${NC} $0 [comando] [opções]"
    echo ""
    echo -e "${YELLOW}Comandos:${NC}"
    echo "  build                 Constrói as imagens Docker"
    echo "  start, up, prod      Inicia os serviços em modo produção"
    echo "  dev                  Inicia os serviços em modo desenvolvimento"
    echo "  stop, down           Para todos os serviços"
    echo "  restart              Reinicia os serviços"
    echo "  logs [service]       Mostra logs dos serviços"
    echo "  status               Mostra status dos serviços"
    echo "  clean                Remove containers, imagens e volumes não utilizados"
    echo "  help, -h, --help     Mostra esta ajuda"
    echo ""
    echo -e "${YELLOW}Exemplos:${NC}"
    echo "  $0 start             # Inicia em modo produção"
    echo "  $0 dev               # Inicia em modo desenvolvimento"
    echo "  $0 logs backend      # Mostra logs do backend"
    echo "  $0 restart           # Reinicia os serviços"
}

# Main logic
main() {
    case "${1:-help}" in
        "build")
            check_docker
            build_images
            ;;
        "start"|"up"|"prod")
            check_docker
            build_images
            start_production
            ;;
        "dev"|"development")
            check_docker
            build_images
            start_development
            ;;
        "stop"|"down")
            stop_services
            ;;
        "restart")
            check_docker
            stop_services
            build_images
            start_production
            ;;
        "logs")
            show_logs "$2"
            ;;
        "status")
            check_status
            ;;
        "clean"|"cleanup")
            cleanup
            ;;
        "help"|"-h"|"--help"|*)
            show_help
            ;;
    esac
}

# Run main function
main "$@"