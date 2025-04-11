# ---- Base image ----
  FROM node:20-alpine AS base
  WORKDIR /app
  
  # Accept Clerk-related envs as build-time args
  ARG NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
  ARG NEXT_PUBLIC_CLERK_SIGN_IN_URL
  ARG NEXT_PUBLIC_CLERK_SIGN_UP_URL
  ARG NEXT_PUBLIC_CLERK_SIGN_IN_FORCE_REDIRECT_URL
  ARG NEXT_PUBLIC_CLERK_SIGN_UP_FORCE_REDIRECT_URL
  
  # Inject into build-time env
  ENV NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=$NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY
  ENV NEXT_PUBLIC_CLERK_SIGN_IN_URL=$NEXT_PUBLIC_CLERK_SIGN_IN_URL
  ENV NEXT_PUBLIC_CLERK_SIGN_UP_URL=$NEXT_PUBLIC_CLERK_SIGN_UP_URL
  ENV NEXT_PUBLIC_CLERK_SIGN_IN_FORCE_REDIRECT_URL=$NEXT_PUBLIC_CLERK_SIGN_IN_FORCE_REDIRECT_URL
  ENV NEXT_PUBLIC_CLERK_SIGN_UP_FORCE_REDIRECT_URL=$NEXT_PUBLIC_CLERK_SIGN_UP_FORCE_REDIRECT_URL
  
  COPY package.json package-lock.json* bun.lockb* ./
  RUN npm install
  
  COPY . .
  RUN npm run build
  
  # ---- Runtime image ----
  FROM node:20-alpine AS runner
  WORKDIR /app
  
  COPY --from=base /app ./
  
  # Runtime env vars (used by @clerk/nextjs server-side auth)
  ENV NODE_ENV=production
  ENV PORT=8080
  
  # Also re-exporting publishable key in case needed at runtime
  ENV NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_c2VjdXJlLWR1Y2tsaW5nLTYxLmNsZXJrLmFjY291bnRzLmRldiQ
  
  EXPOSE 8080
  CMD ["npm", "run", "start"]
  