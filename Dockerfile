# ---- Base image ----
FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# ---- Install dependencies ----
COPY package.json package-lock.json* bun.lockb* ./
RUN npm install

# ---- Copy rest of the app and build ----

  FROM base AS builder  
  WORKDIR /app
  COPY --from=deps /app/node_modules ./node_modules
  COPY . .

  RUN npm install
RUN npm run build

# ---- Final image for runtime ----

  FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# Copy additional files that might be needed
COPY --from=builder /app/next.config.ts ./
COPY --from=builder /app/package.json ./

USER nextjs
ENV PORT=3000
EXPOSE 3000

CMD ["npm", "run", "start"]
