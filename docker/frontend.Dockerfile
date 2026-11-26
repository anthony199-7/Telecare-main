FROM node:22-bookworm-slim AS build

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

COPY index.html vite.config.js Tailwind.config.js ./
COPY src ./src
COPY public ./public

ARG VITE_BACKEND_URL=http://localhost:4000
ENV VITE_BACKEND_URL=${VITE_BACKEND_URL}
RUN npm run build

FROM nginx:alpine
COPY docker/nginx-frontend.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html/Telecare
EXPOSE 80
