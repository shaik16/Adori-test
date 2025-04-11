# ---- Base image ----
  FROM node:20-alpine AS base
  WORKDIR /app
  
  # ---- Install dependencies ----
  COPY package.json package-lock.json* bun.lockb* ./
  RUN npm install
  
  # ---- Copy rest of the app and build ----
  COPY . .
  RUN npm run build
  ENV NODE_ENV=production
  
  # ---- Final image for runtime ----
  FROM node:20-alpine AS runner
  WORKDIR /app
  
  COPY --from=base /app ./
  
  ENV PORT=8080
  EXPOSE 8080
  
  CMD ["npm", "run", "start"]
  