# ContribPortal

This is a monorepo using Turborepo with:

Root package.json with workspaces pointing to apps/_ and packages/_
Frontend (Next.js app) in apps/frontend
Backend (Express API) in apps/backend
Shared ESLint config and TypeScript config in packages/
Current npm scripts at root level:

npm run build - runs turbo run build
npm run lint - runs turbo run lint
npm ci - installs dependencies
npm run dev - local development
Node.js version requirement: >=18
