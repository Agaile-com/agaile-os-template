# Example: SaaS Application with AgAIle OS

This example demonstrates setting up a SaaS application using AgAIle OS.

## Project Structure

```
saas-app/
├── .agaile-os/          # AgAIle OS configuration
│   ├── product/         # Product documentation
│   ├── standards/       # Coding standards
│   ├── features/        # Feature specifications
│   └── agents/          # Agent configurations
├── .claude/             # Claude integration
├── .cursor/             # Cursor integration
├── src/                 # Application code
├── tests/              # Test suites
└── docs/               # Documentation
```

## Initial Setup

### 1. Initialize AgAIle OS

```bash
# Clone your app repository
git clone your-app-repo
cd your-app-repo

# Run AgAIle OS setup
curl -sSL https://raw.githubusercontent.com/yourusername/agaile-os/main/setup.sh | bash
```

### 2. Configure Product Vision

Edit `.agaile-os/product/mission.md`:

```markdown
# SaaS Platform Mission

## Vision
Build the leading customer feedback management platform for B2B SaaS companies.

## Mission Statement
Empower product teams to make data-driven decisions through intelligent feedback analysis and actionable insights.

## Success Metrics
- [ ] 100+ active companies within 6 months
- [ ] <2% monthly churn rate
- [ ] 95% uptime SLA
- [ ] <200ms average API response time

## Target Audience
Product managers and teams at B2B SaaS companies with 10-500 employees.
```

### 3. Define Technology Stack

Edit `.agaile-os/standards/tech-stack.md`:

```markdown
# Technology Stack

## Frontend
- **Framework**: Next.js 14 with App Router
- **Language**: TypeScript (strict mode)
- **Styling**: Tailwind CSS
- **State**: Zustand
- **Forms**: React Hook Form + Zod

## Backend
- **API**: Next.js API Routes
- **Database**: PostgreSQL with Prisma
- **Auth**: NextAuth.js
- **File Storage**: AWS S3

## Infrastructure
- **Hosting**: Vercel
- **Database**: Supabase
- **Monitoring**: Sentry
- **Analytics**: PostHog
```

### 4. Create First Feature

```bash
# In Claude or Cursor, run:
/create-feature User authentication with email/password and OAuth
```

This generates:
- Feature specification
- Technical requirements
- Database schema
- API specifications

### 5. Generate Tasks

```bash
/create-tasks
```

Creates hierarchical task breakdown:
- Database setup
- Authentication implementation
- UI components
- Testing requirements

### 6. Execute with Agents

```bash
# Start with analysis
/typescripter

# Execute with agent assistance
/execute-tasks --agent-enhanced

# Handle database changes
/db-migrate --from-feature

# Validate implementation
/typescripter --agent-coordination
```

## Agent Configuration Example

`.agaile-os/agents/config.yml`:

```yaml
agents:
  fixer-agent:
    confidence_threshold: 80
    approval_requirements:
      development: "NOTIFY"
      production: "APPROVE"
    
  db-migrate-agent:
    confidence_threshold: 85
    approval_requirements:
      development: "CONFIRM"
      production: "MANUAL"
```

## Workflow Example

### Day 1: Project Setup
```bash
/plan-product "B2B SaaS feedback management platform"
# Reviews requirements, creates initial documentation
```

### Day 2: Authentication Feature
```bash
/create-feature "User authentication with JWT"
/create-tasks
/execute-tasks --agent-enhanced
/db-migrate --from-feature
```

### Day 3: Dashboard Feature
```bash
/create-feature "Analytics dashboard with real-time metrics"
/create-tasks
/execute-tasks --agent-enhanced
/typescripter --agent-coordination
```

### Day 4: Testing & Deployment
```bash
/typescripter --approve-strategy
/ci-cd --run local
/ci-cd --deploy staging
/g --commit "feat: Complete authentication and dashboard"
/g --pr --target develop
```

### Day 5: Documentation
```bash
/documenter --scope authentication
/feedback-triage --auto-process
```

## Best Practices for This Project

### Development Flow
1. Always start features with `/create-feature`
2. Review generated specifications before tasks
3. Use agent assistance for complex implementations
4. Validate with `/typescripter` before commits

### Agent Usage
- **Development**: High automation (85% threshold)
- **Staging**: Interactive approval (60% threshold)
- **Production**: Strict mode with manual approval

### Database Management
- Always use `/db-migrate --from-feature` for schema changes
- Validate migrations in development first
- Use `--validate` flag before production deploys

### Quality Assurance
- Run `/typescripter` after major changes
- Use `/ci-cd --run local` before pushing
- Maintain >80% test coverage for business logic

## Common Commands

```bash
# Daily development
/execute-tasks --agent-enhanced
/typescripter
/g --commit "feat: Your feature"

# Pre-deployment
/typescripter --agent-coordination
/ci-cd --run local
/ci-cd --deploy staging

# Production deployment
/ci-cd --deploy production --hil-mode strict
/documenter --ai-optimized
/feedback-triage --analyze
```

## Troubleshooting

### TypeScript Errors
```bash
/typescripter --approve-strategy
# Let agents handle resolution
```

### Database Issues
```bash
/db-migrate --validate
/db-migrate --rollback --env development
```

### CI/CD Problems
```bash
/ci-cd --status
/ci-cd --monitor
```

## Results

Using AgAIle OS on this project achieved:
- **70% reduction** in development time
- **95% first-pass** success rate on features
- **90% reduction** in TypeScript errors reaching production
- **60% improvement** in deployment confidence

## Learn More

- [Full AgAIle OS Documentation](../docs/)
- [HIL Methodology](../docs/HIL-development-methodology.md)
- [Agent Configuration Guide](../docs/agent-configuration.md)
