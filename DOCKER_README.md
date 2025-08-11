# 🐳 Dockerización del Proyecto Nuxt.js POS

Este proyecto ha sido dockerizado para facilitar el desarrollo y despliegue.

## 📋 Prerrequisitos

- Docker Desktop instalado
- Docker Compose instalado
- Make (opcional, pero recomendado)

## 🚀 Comandos Rápidos

### Con Makefile (recomendado)
```bash
# Ver todos los comandos disponibles
make help

# Inicio rápido del entorno de desarrollo
make quick-dev

# Inicio rápido del entorno de producción
make quick-prod

# Detener servicios
make docker-stop

# Ver logs
make logs
```

### Con Docker Compose directamente
```bash
# Desarrollo
docker-compose --profile dev up -d

# Producción
docker-compose --profile prod up -d

# Construir solo
docker-compose --profile build up --build
```

## 🏗️ Estructura de Docker

### Dockerfile
- **Multi-stage build** para optimizar el tamaño de la imagen
- **Etapa de desarrollo**: Incluye todas las dependencias y hot-reload
- **Etapa de build**: Construye la aplicación
- **Etapa de producción**: Imagen ligera solo con lo necesario

### Docker Compose
- **Perfil dev**: Entorno de desarrollo con hot-reload
- **Perfil prod**: Entorno de producción optimizado
- **Perfil build**: Solo para construir la aplicación

## 🔧 Configuración

### Variables de Entorno
Copia `.env.example` a `.env` y ajusta según tu entorno:

```bash
NODE_ENV=development
HOST=0.0.0.0
PORT=3000
```

### Puertos
- **3000**: Aplicación Nuxt.js
- **3000**: Puerto expuesto en el host

## 📁 Volúmenes

- **Desarrollo**: El código fuente se monta como volumen para hot-reload
- **Producción**: Solo se copian los archivos construidos

## 🛠️ Comandos Útiles

### Desarrollo
```bash
# Iniciar entorno de desarrollo
make docker-dev

# Ver logs en tiempo real
make logs

# Abrir shell en el contenedor
make shell

# Reiniciar servicios
make docker-restart
```

### Producción
```bash
# Construir e iniciar en producción
make quick-prod

# Ver logs de producción
make logs-prod

# Shell en contenedor de producción
make shell-prod
```

### Mantenimiento
```bash
# Ver estado de servicios
make status

# Monitorear recursos
make top

# Limpieza básica
make clean

# Limpieza completa
make clean-all
```

## 🔍 Troubleshooting

### Problemas Comunes

1. **Puerto 3000 ocupado**
   ```bash
   # Cambiar puerto en docker-compose.yml
   ports:
     - "3001:3000"
   ```

2. **Permisos de archivos**
   ```bash
   # En Windows, asegúrate de que Docker tenga acceso al directorio
   # En Linux/Mac, verifica permisos de usuario
   ```

3. **Memoria insuficiente**
   ```bash
   # Aumentar memoria en Docker Desktop
   # O usar contenedores más ligeros
   ```

### Logs y Debugging
```bash
# Ver logs detallados
make logs

# Ver logs de un servicio específico
docker-compose logs -f nuxt-dev

# Debuggear con shell
make shell
```

## 🚀 Despliegue

### Desarrollo Local
```bash
make quick-dev
# Aplicación disponible en http://localhost:3000
```

### Producción
```bash
make quick-prod
# Aplicación optimizada en http://localhost:3000
```

### CI/CD
```bash
# Construir imagen
make docker-build

# Desplegar
make deploy
```

## 📊 Monitoreo

### Estado de Servicios
```bash
make status
```

### Uso de Recursos
```bash
make top
```

### Logs en Tiempo Real
```bash
make logs
```

## 🔒 Seguridad

- Usuario no-root en contenedores de producción
- Imágenes Alpine Linux para menor superficie de ataque
- Variables de entorno para configuración sensible

## 📚 Recursos Adicionales

- [Documentación de Docker](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Nuxt.js Docker](https://nuxtjs.org/docs/deployment/docker)

## 🤝 Contribución

Para contribuir al proyecto:

1. Usa `make quick-dev` para desarrollo
2. Ejecuta `make test` antes de commit
3. Usa `make clean` para limpiar antes de push
