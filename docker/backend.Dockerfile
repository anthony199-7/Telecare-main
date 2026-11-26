FROM node:22-bookworm-slim

ENV NODE_ENV=production
WORKDIR /app

COPY backend/package.json backend/package-lock.json ./
RUN npm ci --omit=dev

COPY backend/ ./

EXPOSE 4000
CMD ["npm", "start"]
