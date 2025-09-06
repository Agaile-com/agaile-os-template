# CLAUDE.md - Agaile-OS Project Configuration

## ⚠️ IMPORTANT: AgAIle OS System Check

**ALWAYS check the following files FIRST when determining "what's next":**

1. **Master Tracking**: `/.agaile-os/MASTER_TRACKING.md`
   - **THE CENTERPIECE** for all project planning and progress tracking
   - Current release progress and epic status
   - Active PRDs, features, and strategic initiatives
   - Resource allocation and success metrics

2. **Agaile-OS Directory**: `/.agaile-os/`
   - `product/roadmap.md` - Current roadmap priorities
   - `features/active/` - Active feature development
   - `prds/active/` - Current product requirements
   - `tasks/` - Active task tracking

**Never assume project priorities from this CLAUDE.md file alone** - always verify current status from the agaile-os tracking system first.

## Project Overview

This project is powered by **Agaile-OS** - an Agent-Enhanced Development Operating System that transforms your AI assistants into an intelligent development team. The system provides structured workflows, specialized agents, and Human-in-the-Loop methodology for accelerated development.

## Core Mission

Transform software development by providing:

- **60-70% faster development** through agent-orchestrated workflows
- **95% first-pass success rate** with specialized AI agents
- **Confidence-based automation** with human oversight at critical points
- **Production-grade safety** through HIL methodology

## Development Methodology - HIL (Human-in-the-Loop)

This project operates using the **Human-in-the-Loop (HIL) development methodology** documented in `/.agaile-os/docs/HIL-development-methodology.md`. This comprehensive workflow covers the entire development lifecycle from Product Requirements Documents (PRD) through deployment and feedback collection.

**Key HIL Workflow Phases:**

1. **Requirements & Specification** (`/create-feature`) - Feature creation from roadmap
2. **Task Planning & Execution** (`/create-tasks`, `/execute-tasks`) - Structured task breakdown and implementation
3. **Database Migration** (`/db-migrate --from-feature`) - Schema management with automatic type generation
4. **Quality Assurance & Validation** (`/typescripter`) - Agent-orchestrated error resolution with 60-70% faster resolution times
5. **Pre-Deployment Verification** (`/ci-cd --validate`) - Comprehensive validation preventing deployment failures
6. **CI/CD Pipeline Management** (`/ci-cd`) - Unified deployment orchestration across environments
7. **Version Control & Deployment** (`/git-workflow`) - Git operations with automated deployment integration
8. **Documentation & Knowledge Management** (`/documenter`) - AI-optimized documentation consolidation
9. **Feedback Collection & Intelligent Triage** (`/hil-status`) - Automated feedback processing with critical issue escalation

## Agent-Enhanced Architecture

The HIL workflow leverages **5 specialized AI agents** configured in `.agaile-os/agents/config.yml`:

### 🔧 **Fixer Agent** (87-92% confidence)
- Build errors and module resolution
- Cache management and dependency conflicts  
- Runtime server errors

### 🗄️ **DB-Migrate Agent** (88-90% confidence)
- Database schema synchronization
- ORM integration and type generation
- Migration safety validation

### 🎯 **Quality Agent** (70-85% confidence)
- Code quality and linting
- Test orchestration and coverage
- Accessibility compliance

### 🚀 **CI-CD Agent** (95-100% confidence)
- Deployment validation
- Pipeline orchestration
- Environment management

### 📚 **Docs Agent** (75-90% confidence)
- Documentation consolidation
- Knowledge extraction
- API documentation generation

## Available Commands

All HIL workflow commands are available and provide specialized automation:

- **`/create-feature [description]`** - Generate comprehensive feature specifications
- **`/create-tasks`** - Break down features into executable tasks
- **`/execute-tasks [--agent-enhanced]`** - Execute tasks with agent assistance
- **`/db-migrate [--from-feature]`** - Handle database schema changes
- **`/typescripter [--agent-coordination]`** - Resolve TypeScript/build errors
- **`/ci-cd [--validate|--deploy]`** - Manage deployments and CI/CD
- **`/git-workflow`** - Handle version control operations
- **`/documenter`** - Generate and maintain documentation
- **`/hil-status`** - Monitor HIL system status and confidence levels

Reference the HIL methodology document at `/.agaile-os/docs/HIL-development-methodology.md` for detailed usage instructions and best practices.

## AgAIle OS Integration

The workflow seamlessly integrates with the AgAIle OS system in `.agaile-os/`:

- **Features**: `.agaile-os/features/active/` - Technical specifications and implementation details
- **PRDs**: `.agaile-os/prds/active/` - Customer problem consolidation and requirements  
- **Epics**: `.agaile-os/epics/active/` - Strategic coordination of related features
- **Product**: `.agaile-os/product/` - Roadmap and strategic context
- **Standards**: `.agaile-os/standards/` - Coding standards and practices

## Technology Stack Template

Update this section with your specific technology choices:

### Frontend
- Framework: [e.g., Next.js, React, Vue]
- Styling: [e.g., Tailwind CSS, CSS Modules] 
- State Management: [e.g., Redux, Zustand]

### Backend  
- Runtime: [e.g., Node.js, Deno, Bun]
- Framework: [e.g., Express, Fastify, Hono]
- Database: [e.g., PostgreSQL, MongoDB]
- ORM: [e.g., Prisma, TypeORM]

### Infrastructure
- Hosting: [e.g., Vercel, AWS, Railway]
- Database Host: [e.g., Supabase, PlanetScale] 
- CDN: [e.g., Cloudflare, Fastly]

## Development Guidelines

### Package Management
- Use your preferred package manager consistently
- Commands depend on your choice (npm, yarn, pnpm)
- Avoid mixing package managers in the same project

### Code Style
- Use TypeScript with strict type checking
- Follow your framework's conventions
- Implement consistent component structure
- Use your chosen styling approach consistently

### API Design Patterns
- Implement proper error handling
- Return consistent response formats
- Use validation libraries (e.g., Zod)
- Follow RESTful principles

### Database Operations
- Use your chosen ORM consistently
- Implement soft deletes where appropriate
- Use transactions for related operations
- Maintain referential integrity

### Security Standards
- Never expose API keys in client code
- Validate all user inputs
- Implement proper authentication checks
- Use environment variables for secrets
- Follow OWASP security guidelines

### Testing Requirements
- Write unit tests for utilities
- Integration tests for API routes
- E2E tests for critical user flows
- Maintain >80% code coverage target
- Test error scenarios

## Feature Development Workflow

1. **Plan**: Review PRD in `.agaile-os/prds/` and feature in `.agaile-os/features/`
2. **Create**: Use `/create-feature [description]` to generate specifications
3. **Break Down**: Use `/create-tasks` to create executable tasks
4. **Implement**: Use `/execute-tasks --agent-enhanced` for development
5. **Migrate**: Use `/db-migrate --from-feature` for schema changes
6. **Quality**: Use `/typescripter --agent-coordination` for error resolution
7. **Deploy**: Use `/ci-cd --validate` then `/ci-cd --deploy` for deployment
8. **Document**: Use `/documenter` to maintain documentation

## HIL Confidence Thresholds

The system operates with confidence-based automation:

- **HIGH (85-100%)**: Auto-execute with logging
- **MEDIUM (60-84%)**: Interactive approval required
- **LOW (30-59%)**: Manual review required

Configure these in `.agaile-os/hil-config.yml` based on your risk tolerance.

## Environment Configuration

### Development
- Higher automation threshold (85% confidence)
- Extensive logging enabled
- All agents active

### Staging  
- Moderate automation (70% confidence)
- Interactive approval for deployments
- Performance monitoring active

### Production
- Conservative automation (95% confidence)
- Manual approval for all deployments
- Maximum safety protocols

## Common Tasks

### Starting a New Feature
```bash
# Check current priorities first
cat .agaile-os/product/roadmap.md

# Create the feature specification  
/create-feature "Your feature description"

# Break down into tasks
/create-tasks

# Begin implementation with agent assistance
/execute-tasks --agent-enhanced
```

### Handling Database Changes
```bash
# Generate migration from feature spec
/db-migrate --from-feature

# Validate before applying
/db-migrate --validate

# Apply with agent assistance  
/db-migrate --agent-enhanced
```

### Resolving Build Issues
```bash
# Comprehensive error analysis and resolution
/typescripter --agent-coordination

# For specific error types
/typescripter --error "your specific error message"

# With automatic execution for high-confidence fixes
/typescripter --auto-execute --confidence-threshold 85
```

### Managing Deployments
```bash
# Validate deployment readiness
/ci-cd --validate

# Deploy to staging
/ci-cd --deploy staging

# Deploy to production (requires approval)
/ci-cd --deploy production --approve-all
```

## Monitoring and Status

### HIL System Status
```bash
# Check overall system health
/hil-status

# Check specific command confidence levels  
/hil-status --command create-feature

# Review agent performance
/hil-status --agents
```

### Project Status
```bash
# View active features
ls .agaile-os/features/active/

# Check task progress
ls .agaile-os/tasks/

# Review roadmap priorities
cat .agaile-os/product/roadmap.md
```

## Troubleshooting

### Agent Issues
1. Check agent configuration in `.agaile-os/agents/config.yml`
2. Review confidence thresholds in `.agaile-os/hil-config.yml`
3. Use `/hil-status --agents` for diagnostics

### Command Issues
1. Verify command templates in `.agaile-os/commands/`
2. Check instruction files in `.agaile-os/instructions/core/`
3. Use `/hil-status --command [command-name]` for specific diagnostics

### Performance Issues
1. Review agent confidence levels
2. Adjust automation thresholds
3. Check system resource usage

## Resources

- **HIL Methodology**: `.agaile-os/docs/HIL-development-methodology.md`
- **MCP Setup**: `.agaile-os/docs/MCP-Setup.md`
- **Example Usage**: `.agaile-os/examples/saas-application.md`
- **Command Reference**: `.agaile-os/commands/`
- **Agent Configuration**: `.agaile-os/agents/config.yml`

## Project Information

- **Framework**: Agaile-OS v1.0
- **Methodology**: Human-in-the-Loop (HIL)
- **Agent Architecture**: 5 specialized AI agents
- **Automation Level**: Confidence-based with human oversight

---

**Ready to accelerate your development with intelligent agents?**

Start with: `/create-feature "Your first feature description"`

---

_This configuration activates the Agaile-OS system for your project. All commands and agents are ready for use._