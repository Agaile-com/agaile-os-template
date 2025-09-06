# AgAIle-OS Commands Reference

## 🎯 Quick Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `/create-feature` | Build complete features | `/create-feature "user authentication"` |
| `/execute-tasks` | Run development tasks | `/execute-tasks --auto` |
| `/db-migrate` | Database operations | `/db-migrate --sync` |
| `/typescripter` | Fix TypeScript errors | `/typescripter --auto-fix` |
| `/ci-cd` | Deploy to environments | `/ci-cd --deploy prod` |

## 📚 Complete Command List

### Planning & Architecture

#### `/plan-product`
Define your product vision and architecture.
```bash
/plan-product "SaaS platform for team collaboration"

Options:
  --tech-stack    # Specify technology preferences
  --target-users  # Define user personas
  --mvp-scope    # Limit to MVP features
```

#### `/analyze-product`
Analyze existing codebase and extract patterns.
```bash
/analyze-product

Options:
  --extract-patterns  # Extract coding patterns
  --identify-debt     # Find technical debt
  --suggest-improvements  # Get optimization suggestions
```

### Feature Development

#### `/create-feature`
Generate complete features from descriptions.
```bash
/create-feature "Real-time chat with file sharing"

Options:
  --priority high|medium|low  # Set feature priority
  --estimate                   # Include time estimates
  --with-tests                # Generate tests (default: true)
  --with-docs                 # Generate documentation (default: true)
```

#### `/create-tasks`
Break down features into executable tasks.
```bash
/create-tasks --from-feature chat-feature

Options:
  --granularity fine|medium|coarse  # Task breakdown level
  --assign-agents                    # Auto-assign to agents
  --estimate-effort                  # Add time estimates
```

#### `/execute-tasks`
Execute tasks with AI assistance.
```bash
/execute-tasks --task-id 1,2,3

Options:
  --parallel              # Execute in parallel where possible
  --auto                  # Fully automated execution
  --confidence-threshold  # Minimum confidence for auto-execution (0-100)
  --hil-mode             # dev|staging|production|strict
  --dry-run              # Preview without executing
```

### Code Quality & Testing

#### `/typescripter`
Resolve TypeScript errors and improve type safety.
```bash
/typescripter

Options:
  --auto-fix           # Automatically fix errors
  --strict             # Apply strict type checking
  --analyze            # Analysis only, no changes
  --coordinate-agents  # Use multiple agents for complex fixes
```

#### `test-runner` (Agent)
**Note**: test-runner is an AGENT, not a command. It's automatically invoked by other commands and agents for testing tasks.

### Database Management

#### `/db-migrate`
Manage database schema and migrations.
```bash
/db-migrate

Options:
  --generate         # Generate migration from changes
  --apply            # Apply pending migrations
  --rollback         # Rollback last migration
  --sync             # Sync ORM with schema
  --validate         # Validate schema integrity
  --env dev|staging|prod  # Target environment
```


### Deployment & DevOps

#### `/ci-cd`
Manage deployments and CI/CD pipeline.
```bash
/ci-cd --deploy staging

Options:
  --deploy dev|staging|prod  # Deploy to environment
  --status                   # Check pipeline status
  --rollback                 # Rollback deployment
  --validate                 # Pre-deployment validation
  --monitor                  # Post-deployment monitoring
  --auto-execute            # Skip confirmations
```

#### `/verify-deployment`
Verify deployment readiness.
```bash
/verify-deployment

Options:
  --environment dev|staging|prod  # Target environment
  --checklist                     # Show deployment checklist
  --fix-issues                    # Auto-fix found issues
```

### Documentation

#### `/documenter`
Generate and maintain documentation.
```bash
/documenter

Options:
  --api-docs          # Generate API documentation
  --component-docs    # Generate component documentation
  --readme            # Update README files
  --changelog         # Generate changelog
  --missing-only      # Only document undocumented code
```


### Git & Version Control

#### `/git-workflow`
Smart git operations.
```bash
/git-workflow --commit "feat: add user authentication"

Options:
  --commit "message"   # Commit with conventional message
  --pr                # Create pull request
  --merge             # Merge current branch
  --release           # Create release
  --changelog         # Generate changelog
```


### Agent Control

#### `/agent`
Direct agent control.
```bash
/agent fixer --analyze

Agents:
  fixer       # Build and dependency resolution
  db-migrate  # Database operations
  quality     # Code quality enforcement
  ci-cd       # Deployment management
  docs        # Documentation generation

Options:
  --analyze      # Analysis mode only
  --execute      # Execute recommendations
  --confidence   # Show confidence scores
```


### HIL Control

#### `/hil-status`
Check HIL (Human-in-the-Loop) status.
```bash
/hil-status

Options:
  --show-decisions   # Show recent decisions
  --show-overrides   # Show manual overrides
  --set-mode        # Change HIL mode
```


## 🎮 Command Modifiers

### Global Options
Available for all commands:

```bash
--analyze          # Preview without execution
--approve          # Require approval for each step
--auto             # Fully automated execution
--confidence [0-100]  # Override confidence threshold
--dry-run          # Simulate execution
--explain          # Explain decisions
--hil-mode [mode]  # Override HIL mode
--verbose          # Detailed output
```

### Confidence Thresholds

| Level | Range | Behavior |
|-------|-------|----------|
| **Critical** | 0-29% | Manual only, AI assists |
| **Low** | 30-59% | Requires explicit approval |
| **Medium** | 60-84% | Asks for confirmation |
| **High** | 85-100% | Auto-executes with logging |

### HIL Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| **dev** | High automation, low oversight | Development environment |
| **staging** | Balanced automation and safety | Staging/QA environment |
| **production** | Conservative, high oversight | Production environment |
| **strict** | Maximum oversight, minimal automation | Critical operations |

## 🔥 Power User Tips

### Command Chaining
```bash
/create-feature "user auth" && /execute-tasks --auto && /db-migrate --apply
```

### Batch Operations
```bash
/execute-tasks --task-ids 1-10 --parallel --confidence-threshold 90
```

### Custom Workflows
```bash
/workflow --create "my-deploy-flow" --steps "typescripter,test-runner,ci-cd"
/workflow --run "my-deploy-flow"
```


## 🆘 Troubleshooting Commands

### When Things Go Wrong

```bash
# Rollback recent changes
/rollback --to-checkpoint

# Fix broken builds
/fixer --emergency

# Restore database
/db-migrate --emergency-rollback

# Cancel running operations
/abort --all

# System status check
/hil-status --diagnose
```

---

**Pro Tip**: Start with `--analyze` flag to understand what any command will do before executing it.

**Need Help?**: Use `/help [command]` for detailed information about any command.
