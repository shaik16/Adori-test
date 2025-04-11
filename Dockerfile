# ---- Base image ----
  FROM node:20-alpine AS base

  # ---- Dependencies layer ----
  FROM base AS deps
  RUN apk add --no-cache libc6-compat
  WORKDIR /app
  COPY package.json package-lock.json* ./
  RUN npm install
  
  # ---- Builder layer ----
  FROM base AS builder
  WORKDIR /app
  COPY --from=deps /app/node_modules ./node_modules
  COPY . .
  RUN npm run build
  
  # ---- Runtime image ----
  FROM base AS runner
  WORKDIR /app
  ENV NODE_ENV=production
  
  RUN addgroup --system --gid 1001 nodejs
  RUN adduser --system --uid 1001 nextjs
  
  COPY --from=builder /app/public ./public
  COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
  COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
  COPY --from=builder /app/next.config.ts ./
  COPY --from=builder /app/package.json ./
  
  USER nextjs
  ENV PORT=3000
  EXPOSE 3000
  
  CMD ["node", "server.js"]
  