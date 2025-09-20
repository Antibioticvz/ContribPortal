# ContribPortal

🚀 **AI-Powered Open Source Contribution Platform**

## Introduction

ContribPortal is an innovative platform that connects open-source contributors with relevant projects using the power of artificial intelligence. Our mission is to make open-source contribution more accessible, efficient, and rewarding by intelligently matching developers with projects that align with their skills, interests, and experience level.

Whether you're a beginner looking for your first contribution or an experienced developer seeking meaningful projects to support, ContribPortal uses AI to analyze project requirements, contributor profiles, and task complexity to provide personalized recommendations that accelerate your open-source journey.

## Key Features

### 🎯 **AI-Powered Project Analysis**
- Advanced machine learning algorithms analyze repository structures, code complexity, and contribution patterns
- Intelligent difficulty scoring helps match contributors with appropriate challenges
- Smart categorization of issues by type, priority, and skill requirements

### 🎪 **Personalized Task Recommendations**
- Customized project suggestions based on your skills, experience level, and interests
- Dynamic filtering by programming languages, frameworks, and project types
- Real-time matching with projects that need your specific expertise

### ⚡ **Streamlined Contribution Process**
- Seamless integration with GitHub for project discovery and issue tracking
- Direct links to contribute with clear guidance on getting started
- Progress tracking and contribution history management

### 🤝 **Community-Driven Features**
- Connect with like-minded contributors and maintainers
- Share knowledge through project insights and contribution experiences
- Build your developer profile and showcase your open-source impact

## Technology Stack

Our modern, scalable architecture leverages cutting-edge technologies:

- **🏗️ Monorepo Management:** [Turborepo](https://turbo.build/) for efficient build orchestration and caching
- **⚛️ Frontend Framework:** [Next.js](https://nextjs.org/) with TypeScript for server-side rendering and optimal performance
- **🚀 Backend Framework:** [NestJS](https://nestjs.com/) for scalable, enterprise-grade API development
- **🗄️ Database & Auth:** [Supabase](https://supabase.com/) for PostgreSQL database, authentication, and real-time features
- **🤖 AI/ML Integration:** [Hugging Face](https://huggingface.co/) for natural language processing and project analysis
- **🔧 API Integration:** [GitHub API](https://docs.github.com/en/rest) for seamless repository and issue management
- **🎨 Styling:** Tailwind CSS for rapid, responsive UI development
- **📦 Package Management:** npm with workspace support for dependency management

## Getting Started

### Prerequisites

- **Node.js** >= 18.0.0
- **npm** >= 9.0.0
- **Git** for version control

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Antibioticvz/ContribPortal.git
   cd ContribPortal
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   
   Copy the environment template and configure your settings:
   ```bash
   cp .env.example .env
   ```
   
   Fill in the required environment variables:
   ```env
   # Supabase Configuration
   SUPABASE_URL=your-supabase-project-url
   SUPABASE_ANON_KEY=your-supabase-anon-key
   SUPABASE_SERVICE_KEY=your-supabase-service-key
   
   # GitHub API
   GITHUB_TOKEN=your-github-personal-access-token
   
   # Hugging Face API
   HUGGINGFACE_TOKEN=your-huggingface-api-token
   
   # Backend Configuration
   PORT=3001
   ```

4. **Set up the database**
   
   Execute the database schema in your Supabase project:
   ```bash
   # Upload packages/db/schema.sql to your Supabase SQL Editor and execute
   ```

5. **Start development servers**
   ```bash
   npm run dev
   ```
   
   This will start:
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3001

### Available Scripts

- `npm run dev` - Start all development servers concurrently
- `npm run build` - Build all packages for production
- `npm run lint` - Run ESLint across all packages
- `npm run type-check` - Run TypeScript type checking

## Monorepo Structure

Our project is organized as a Turborepo monorepo with the following structure:

```
ContribPortal/
├── apps/
│   ├── frontend/          # Next.js web application
│   │   ├── src/
│   │   │   ├── app/       # App Router pages and layouts
│   │   │   ├── components/ # Reusable React components
│   │   │   └── lib/       # Utility functions and configurations
│   │   └── public/        # Static assets
│   │
│   └── backend/           # Express.js API server
│       ├── src/
│       │   ├── routes/    # API route handlers
│       │   ├── services/  # Business logic and external integrations
│       │   ├── middleware/ # Custom middleware functions
│       │   └── types/     # TypeScript type definitions
│       └── dist/          # Compiled JavaScript output
│
├── packages/
│   ├── db/                # Database schema and migrations
│   │   └── schema.sql     # PostgreSQL database schema
│   │
│   ├── eslint-config-custom/  # Shared ESLint configuration
│   │   └── index.js       # ESLint rules and presets
│   │
│   └── typescript-config/     # Shared TypeScript configuration
│       ├── base.json      # Base TypeScript config
│       └── package.json   # Package configuration
│
├── .github/               # GitHub Actions and templates
├── turbo.json            # Turborepo configuration
└── package.json          # Root package.json with workspaces
```

### Package Purposes

- **`apps/frontend`**: Next.js application serving the user interface, including project discovery, user profiles, and contribution tracking
- **`apps/backend`**: Express.js API providing authentication, project analysis, recommendation engine, and GitHub integration
- **`packages/db`**: Database schema definitions and migration scripts for PostgreSQL/Supabase
- **`packages/eslint-config-custom`**: Shared ESLint rules ensuring consistent code quality across all packages
- **`packages/typescript-config`**: Shared TypeScript configurations for consistent type checking and compilation

## Contributing

We welcome contributions from developers of all skill levels! Please see our [Contributing Guide](CONTRIBUTING.md) for details on how to get started.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: support@contribportal.com
- 💬 Discord: [Join our community](https://discord.gg/contribportal)
- 🐛 Issues: [GitHub Issues](https://github.com/Antibioticvz/ContribPortal/issues)
- 📖 Documentation: [docs.contribportal.com](https://docs.contribportal.com)

---

**Made with ❤️ by the ContribPortal team**
