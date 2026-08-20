# ---- Etapa 1: generar las filminas HTML con Marp ----
FROM node:20-alpine AS build
ENV PUPPETEER_SKIP_DOWNLOAD=true
WORKDIR /app
RUN npm install -g @marp-team/marp-cli@4
COPY . .
RUN sh scripts/build.sh

# ---- Etapa 2: sitio estático servido por nginx ----
FROM nginx:alpine
COPY --from=build /app /usr/share/nginx/html
EXPOSE 80
