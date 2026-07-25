# Estágio 1: Build
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Estágio 2: Produção
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app ./
# Cria a pasta do SQLite e dá permissão ao usuário não-root ANTES de trocar de user
RUN mkdir -p /etc/todos && chown -R node:node /app /etc/todos
USER node
EXPOSE 3000
CMD ["node", "src/index.js"]
