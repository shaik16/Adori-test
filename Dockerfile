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
  
  # Accept build args and expose them as environment variables
  ARG NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
  ARG CLERK_SECRET_KEY
  ARG NEXT_PUBLIC_CLERK_SIGN_IN_URL
  ARG NEXT_PUBLIC_CLERK_SIGN_UP_URL
  ARG NEXT_PUBLIC_CLERK_SIGN_IN_FORCE_REDIRECT_URL
  ARG NEXT_PUBLIC_CLERK_SIGN_UP_FORCE_REDIRECT_URL
  
  ENV NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=$NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
  ENV CLERK_SECRET_KEY=$CLERK_SECRET_KEY
  ENV NEXT_PUBLIC_CLERK_SIGN_IN_URL=$NEXT_PUBLIC_CLERK_SIGN_IN_URL
  ENV NEXT_PUBLIC_CLERK_SIGN_UP_URL=$NEXT_PUBLIC_CLERK_SIGN_UP_URL
  ENV NEXT_PUBLIC_CLERK_SIGN_IN_FORCE_REDIRECT_URL=$NEXT_PUBLIC_CLERK_SIGN_IN_FORCE_REDIRECT_URL
  ENV NEXT_PUBLIC_CLERK_SIGN_UP_FORCE_REDIRECT_URL=$NEXT_PUBLIC_CLERK_SIGN_UP_FORCE_REDIRECT_URL
  
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
  ENV PORT=8080
  EXPOSE 8080
  
  CMD ["node", "server.js"]