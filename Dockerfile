FROM node:20-alpine

WORKDIR /app

# Install deps first (better layer caching)
COPY package*.json ./
RUN npm ci --omit=dev

# Copy app code
COPY . .

EXPOSE 3000

# Drop to non-root for safety
USER node

CMD ["node", "index.js"]
