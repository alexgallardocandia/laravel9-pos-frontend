# Dockerfile para Nuxt.js v2
FROM node:16-alpine AS base

# Instalar dependencias del sistema
RUN apk add --no-cache git

# Directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci --only=production && npm cache clean --force

# Etapa de desarrollo
FROM base AS development
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

# Etapa de build
FROM base AS build
COPY . .
RUN npm run build

# Etapa de producción
FROM node:16-alpine AS production
WORKDIR /app

# Instalar solo dependencias de producción
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force

# Copiar archivos construidos
COPY --from=build /app/.nuxt ./.nuxt
COPY --from=build /app/static ./static
COPY --from=build /app/nuxt.config.js ./

# Usuario no-root para seguridad
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nuxtjs -u 1001
USER nuxtjs

EXPOSE 3000
CMD ["npm", "start"]
