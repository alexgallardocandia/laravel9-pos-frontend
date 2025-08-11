#!/bin/bash

# Script de inicio rápido para Laravel9-POS-Frontend
# Alternativa al Makefile para usuarios que no tienen Make instalado

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar mensajes
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Laravel9-POS-Frontend${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Función de ayuda
show_help() {
    print_header
    echo ""
    echo "Comandos disponibles:"
    echo ""
    echo "  dev          - Inicia entorno de desarrollo"
    echo "  prod         - Inicia entorno de producción"
    echo "  build        - Construye la aplicación"
    echo "  stop         - Detiene todos los servicios"
    echo "  restart      - Reinicia los servicios"
    echo "  logs         - Muestra logs del desarrollo"
    echo "  logs-prod    - Muestra logs de producción"
    echo "  shell        - Abre shell en contenedor dev"
    echo "  shell-prod   - Abre shell en contenedor prod"
    echo "  status       - Muestra estado de servicios"
    echo "  clean        - Limpia contenedores y volúmenes"
    echo "  help         - Muestra esta ayuda"
    echo ""
    echo "Ejemplo: ./start.sh dev"
}

# Función para verificar Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker no está instalado. Por favor instala Docker Desktop."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose no está instalado. Por favor instala Docker Compose."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker no está ejecutándose. Por favor inicia Docker Desktop."
        exit 1
    fi
}

# Función para desarrollo
start_dev() {
    print_message "Iniciando entorno de desarrollo..."
    docker-compose --profile dev up -d
    print_message "Entorno de desarrollo iniciado en http://localhost:3000"
}

# Función para producción
start_prod() {
    print_message "Iniciando entorno de producción..."
    docker-compose --profile prod up -d
    print_message "Entorno de producción iniciado en http://localhost:3000"
}

# Función para construir
build_app() {
    print_message "Construyendo aplicación..."
    docker-compose --profile build up --build
    print_message "Aplicación construida exitosamente"
}

# Función para detener
stop_services() {
    print_message "Deteniendo servicios..."
    docker-compose down
    print_message "Servicios detenidos"
}

# Función para reiniciar
restart_services() {
    print_message "Reiniciando servicios..."
    stop_services
    start_dev
}

# Función para logs
show_logs() {
    print_message "Mostrando logs de desarrollo..."
    docker-compose logs -f nuxt-dev
}

# Función para logs de producción
show_logs_prod() {
    print_message "Mostrando logs de producción..."
    docker-compose logs -f nuxt-prod
}

# Función para shell
open_shell() {
    print_message "Abriendo shell en contenedor de desarrollo..."
    docker-compose exec nuxt-dev sh
}

# Función para shell de producción
open_shell_prod() {
    print_message "Abriendo shell en contenedor de producción..."
    docker-compose exec nuxt-prod sh
}

# Función para estado
show_status() {
    print_message "Mostrando estado de servicios..."
    docker-compose ps
}

# Función para limpiar
clean_up() {
    print_warning "¿Estás seguro de que quieres limpiar todo? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_message "Limpiando contenedores y volúmenes..."
        docker-compose down -v
        docker system prune -f
        docker volume prune -f
        print_message "Limpieza completada"
    else
        print_message "Limpieza cancelada"
    fi
}

# Función principal
main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi
    
    check_docker
    
    case "$1" in
        "dev")
            start_dev
            ;;
        "prod")
            start_prod
            ;;
        "build")
            build_app
            ;;
        "stop")
            stop_services
            ;;
        "restart")
            restart_services
            ;;
        "logs")
            show_logs
            ;;
        "logs-prod")
            show_logs_prod
            ;;
        "shell")
            open_shell
            ;;
        "shell-prod")
            open_shell_prod
            ;;
        "status")
            show_status
            ;;
        "clean")
            clean_up
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Comando desconocido: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
