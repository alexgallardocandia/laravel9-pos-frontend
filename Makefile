# Makefile para Laravel9-POS-Frontend
# Comandos útiles para desarrollo y Docker

.PHONY: help install dev build start stop clean docker-build docker-dev docker-prod docker-build-only logs shell

# Variables
COMPOSE_FILE = docker-compose.yml
SERVICE_NAME = nuxt-dev
PROD_SERVICE = nuxt-prod

# Comando por defecto
help: ## Muestra esta ayuda
	@echo "Comandos disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Comandos locales (sin Docker)
install: ## Instala dependencias localmente
	npm install

dev: ## Ejecuta el servidor de desarrollo localmente
	npm run dev

build: ## Construye la aplicación localmente
	npm run build

start: ## Inicia la aplicación en modo producción localmente
	npm start

# Comandos de Docker
docker-build: ## Construye todas las imágenes de Docker
	docker-compose -f $(COMPOSE_FILE) build

docker-dev: ## Inicia el entorno de desarrollo con Docker
	docker-compose -f $(COMPOSE_FILE) --profile dev up -d

docker-prod: ## Inicia el entorno de producción con Docker
	docker-compose -f $(COMPOSE_FILE) --profile prod up -d

docker-build-only: ## Solo construye la aplicación (sin iniciar servicios)
	docker-compose -f $(COMPOSE_FILE) --profile build up --build

docker-stop: ## Detiene todos los servicios de Docker
	docker-compose -f $(COMPOSE_FILE) down

docker-restart: ## Reinicia los servicios de Docker
	$(MAKE) docker-stop
	$(MAKE) docker-dev

# Comandos de utilidad
logs: ## Muestra los logs del servicio
	docker-compose -f $(COMPOSE_FILE) logs -f $(SERVICE_NAME)

logs-prod: ## Muestra los logs del servicio de producción
	docker-compose -f $(COMPOSE_FILE) logs -f $(PROD_SERVICE)

shell: ## Abre una shell en el contenedor de desarrollo
	docker-compose -f $(COMPOSE_FILE) exec $(SERVICE_NAME) sh

shell-prod: ## Abre una shell en el contenedor de producción
	docker-compose -f $(COMPOSE_FILE) exec $(PROD_SERVICE) sh

# Comandos de limpieza
clean: ## Limpia archivos temporales y contenedores
	docker-compose -f $(COMPOSE_FILE) down -v
	docker system prune -f
	docker volume prune -f

clean-all: ## Limpieza completa (incluye imágenes)
	$(MAKE) clean
	docker image prune -a -f

# Comandos de desarrollo rápido
quick-dev: ## Inicio rápido del entorno de desarrollo
	$(MAKE) docker-build
	$(MAKE) docker-dev

quick-prod: ## Inicio rápido del entorno de producción
	$(MAKE) docker-build
	$(MAKE) docker-prod

# Comandos de monitoreo
status: ## Muestra el estado de los servicios
	docker-compose -f $(COMPOSE_FILE) ps

top: ## Muestra el uso de recursos de los contenedores
	docker stats

# Comandos de backup y restore (si es necesario)
backup: ## Crea un backup de los archivos estáticos
	tar -czf backup-$(shell date +%Y%m%d-%H%M%S).tar.gz static/ .nuxt/

# Comandos de testing (si tienes tests)
test: ## Ejecuta tests (si están configurados)
	@echo "Tests no configurados aún"

# Comandos de linting (si tienes ESLint)
lint: ## Ejecuta linting (si está configurado)
	@echo "Linting no configurado aún"

# Comandos de CI/CD
deploy: ## Despliega la aplicación (ejemplo)
	$(MAKE) docker-build
	$(MAKE) docker-prod
	@echo "Aplicación desplegada en http://localhost:3000"
