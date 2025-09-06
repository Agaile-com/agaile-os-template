# Getting Started for Developers

You know how to code. This guide shows you how to code 10x faster with AgAIle-OS.

## 🎯 What AgAIle-OS Actually Is

- **Not another framework** - It's a prompt engineering system
- **Not more dependencies** - It orchestrates AI to write code in YOUR stack
- **Not magic** - It's systematic automation with safety controls

Think of it as turning Claude/Cursor into a team of specialized developers who know your codebase.

## 🚀 Quick Setup (2 minutes)

```bash
# Clone AgAIle-OS into your project
git clone https://github.com/Agaile-com/agaile-os-template .agaile-os

# Run setup
cd .agaile-os && ./setup/install.sh

# Configure your AI model (Claude Opus recommended)
export ANTHROPIC_API_KEY="your-key-here"

# Test it works
/typescripter --analyze
```

## 🧠 The Mental Model

```typescript
// Traditional: You write code
function authenticateUser(email: string, password: string) {
  // 500 lines of auth logic...
}

// AgAIle: You describe intent
/create-feature "JWT authentication with refresh tokens, rate limiting, and 2FA"
// AI writes those 500 lines following YOUR patterns
```

## 🔧 Core Commands

### 1. Project Setup
```bash
# Define your project's architecture and patterns
/plan-product "SaaS platform with Next.js, Supabase, Stripe"

# AgAIle learns your preferences and maintains consistency
```

### 2. Feature Development
```bash
# From PRD to working code
/create-feature "Real-time collaborative editor with CRDT"

# Generates:
# - Database schema
# - API endpoints  
# - Frontend components
# - Tests
# - Documentation
```

### 3. Task Execution
```bash
# Break down and execute complex tasks
/create-tasks --from-spec features/active/editor/feature.md
/execute-tasks --parallel --confidence-threshold 85

# AI handles dependencies, validates outputs
```

### 4. Code Quality
```bash
# TypeScript/ESLint/Tests - all handled
/typescripter --auto-fix --strict

# Detects issues across:
# - Type errors
# - Missing imports
# - Circular dependencies
# - Test coverage
```

### 5. Database Operations
```bash
# Schema migrations with zero downtime
/db-migrate --generate-from-features
/db-migrate --apply --validate

# Handles:
# - Migration generation
# - Rollback procedures
# - Type generation
# - ORM synchronization
```

## 🎮 Advanced Patterns

### Confidence-Based Execution
```bash
# Start safe, increase automation over time
/execute-tasks --confidence-threshold 60  # Asks approval often
/execute-tasks --confidence-threshold 85  # More autonomous
/execute-tasks --confidence-threshold 95  # Nearly fully automated
```

### Multi-Agent Coordination
```bash
# Orchestrate multiple agents for complex tasks
/typescripter --coordinate-agents

# Automatically triggers:
# - Fixer Agent: Resolves dependencies
# - DB Agent: Syncs schema changes
# - Quality Agent: Ensures standards
# - CI-CD Agent: Validates deployment readiness
```

### Custom Workflows
```bash
# Define your own automation patterns
cat > .agaile-os/workflows/my-workflow.md << EOF
When building API endpoints:
1. Generate OpenAPI feature first
2. Create type-safe handlers
3. Add rate limiting
4. Generate client SDK
5. Write integration tests
EOF

/execute-workflow my-workflow "user management API"
```

## 🏗️ Real-World Examples

### Building a Complete Auth System
```bash
# 5 minutes vs 2 days
/create-feature "Complete authentication:
  - Email/password with validation
  - OAuth (Google, GitHub, Discord)  
  - JWT with refresh tokens
  - Rate limiting per IP/user
  - Password reset flow
  - Account verification
  - Session management
  - Security headers"

/execute-tasks --auto
/db-migrate --apply
/typescripter --verify
/ci-cd --deploy staging
```

### Adding Stripe Subscriptions
```bash
# 10 minutes vs 3 days
/create-feature "Stripe subscription system:
  - Product/price sync
  - Checkout sessions
  - Customer portal
  - Webhook handling with idempotency
  - Subscription lifecycle management
  - Usage-based billing
  - Invoice/receipt handling
  - Dunning emails"

# AI handles all the edge cases you'd spend days on
```

### Refactoring Legacy Code
```bash
# Safely modernize with AI assistance
/analyze-codebase --identify-patterns

/execute-tasks "Refactor user service:
  - Extract to clean architecture
  - Add dependency injection
  - Improve test coverage to 90%
  - Add OpenTelemetry tracing
  - Maintain backward compatibility"

# AI refactors while preserving business logic
```

## 🛡️ Safety & Control

### HIL (Human-in-the-Loop) Modes

```bash
# Development: High automation
/execute-tasks --hil-mode dev --auto-approve

# Staging: Balanced oversight  
/execute-tasks --hil-mode staging --confidence-threshold 75

# Production: Maximum safety
/execute-tasks --hil-mode production --require-approval
```

### Rollback & Recovery
```bash
# Every operation is reversible
/db-migrate --rollback
/git-restore --from-checkpoint
/ci-cd --rollback-deployment
```

### Audit Trail
```bash
# Complete visibility
/hil-status --show-decisions
/audit-log --last-24h
/explain-changes --since yesterday
```

## 🔥 Performance Tips

### 1. Stack Declaration
```javascript
// .agaile-os/stack.config.js
module.exports = {
  framework: 'next@14',
  database: 'supabase',
  auth: 'lucia',
  styling: 'tailwind',
  testing: 'vitest',
  deployment: 'vercel'
}
// AI maintains consistency across all generated code
```

### 2. Pattern Library
```bash
# Train AI on your patterns
/analyze-codebase --extract-patterns
/save-patterns --name "my-team-standards"

# AI follows YOUR conventions, not generic ones
```

### 3. Incremental Adoption
```bash
# Start with low-risk, high-value tasks
/typescripter --fix-only    # Just fix errors
/documenter --missing-only   # Just add missing docs
/test-writer --uncovered     # Just increase coverage

# Graduate to feature generation as confidence builds
```

## 📊 Metrics & ROI

Track your improvement:
```bash
/metrics --compare-before-after

# Typical results:
# - 60-70% reduction in development time
# - 95% first-pass success rate
# - 90% reduction in boilerplate writing
# - 80% reduction in debugging time
```

## 🚫 Anti-Patterns to Avoid

### ❌ Don't: Blindly trust high-complexity operations
```bash
/execute-tasks "Rewrite entire backend" --auto  # Dangerous!
```

### ✅ Do: Break down and validate incrementally
```bash
/create-tasks "Rewrite entire backend"  # Plan first
/execute-tasks --task-id 1 --analyze    # Validate approach
/execute-tasks --task-id 1 --step-by-step  # Execute carefully
```

### ❌ Don't: Skip the learning phase
```bash
/ci-cd --deploy production --auto  # On day 1? No!
```

### ✅ Do: Build confidence gradually
```bash
/ci-cd --deploy dev --analyze      # Understand first
/ci-cd --deploy staging --approve  # Test with oversight
/ci-cd --deploy production --hil-mode strict  # Production safety
```

## 🔗 Integration Points

### With Your Existing Tools

```yaml
# .agaile-os/integrations.yml
github:
  pr_template: true
  ci_workflows: true
  
vscode:
  settings_sync: true
  snippets: true
  
monitoring:
  sentry: true
  datadog: true
  
testing:
  jest: true
  cypress: true
```

### With Your Team

```bash
# Share patterns and workflows
/export-patterns --team-config
git commit -m "feat: team AgAIle patterns"

# Everyone benefits from accumulated knowledge
```

## 🎓 Leveling Up

### Week 1: Analysis & Learning
- Run commands with `--analyze` flag
- Understand agent decision-making
- Build pattern library

### Week 2: Guided Automation
- Use `--approve` mode
- Set confidence thresholds at 60%
- Focus on routine tasks

### Week 3: Selective Automation
- Increase confidence to 75%
- Automate repetitive work
- Keep critical paths manual

### Week 4: Intelligent Automation
- Run at 85% confidence
- Trust verified patterns
- Focus on architecture, not implementation

## 💬 Real Developer Questions

**Q: "How does this compare to Copilot?"**
Copilot: Line-by-line completion
AgAIle: Feature-by-feature implementation with testing, deployment, and documentation

**Q: "What about code quality?"**
AgAIle enforces YOUR standards via patterns, not generic ones. Plus, the Quality Agent validates everything.

**Q: "Can I trust it with production?"**
Start with dev/staging. The HIL system ensures nothing deploys without meeting your confidence threshold.

**Q: "What's the learning curve?"**
Day 1: You're productive
Week 1: You're 2x faster
Month 1: You're architecting, not implementing

## 🚀 Next Steps

1. **Run the analyzer**: `/typescripter --analyze`
2. **Create your first feature**: `/create-feature "something you need"`
3. **Join the community**: Share patterns, get help
4. **Contribute back**: Your patterns help everyone

---

**Remember**: AgAIle-OS amplifies your expertise, it doesn't replace it. You architect, AI implements.
