# TypeScripter - Agent-Orchestrated Error Resolution

Intelligent TypeScript error resolution through specialized agent coordination.

## Available Modes

### 1. Analysis Only (Default)
```
/typescripter
```
Analyzes errors and provides agent strategy recommendations without execution.

### 2. Interactive Approval
```
/typescripter --approve-strategy
```
User approves each agent phase individually.

### 3. Confidence-Based Automation
```
/typescripter --auto-execute --confidence-threshold 85
```
Automatically executes strategies with confidence ≥ 85%.

### 4. Multi-Agent Coordination
```
/typescripter --agent-coordination
```
Enables coordinated multi-agent approach for complex issues.

### 5. Strict HIL Mode
```
/typescripter --hil-mode strict
```
Maximum oversight for production-critical operations.

## Agent Specializations

| Agent | Specialization | Confidence | Use Cases |
|-------|---------------|------------|-----------|
| 🔧 **Fixer** | Build & Modules | 87-92% | Cache issues, module resolution, build errors |
| 🗄️ **DB-Migrate** | Database Schema | 88-90% | Prisma sync, type generation, migrations |
| 🎯 **Quality** | Code Quality | 70-85% | ESLint, testing, accessibility |
| 🚀 **CI-CD** | Deployment | 95-100% | Build validation, deployment checks |
| 📚 **Docs** | Documentation | 75-90% | Documentation updates, knowledge extraction |

## Coordination Patterns

### TypeScript Resolution Pattern
```
Phase 1: db-migrate-agent (if schema errors)
Phase 2: fixer-agent (if build errors)
Phase 3: quality-agent (if linting errors)
Phase 4: ci-cd-agent (validation)
```

## Confidence Thresholds

- **HIGH (85-100%)**: Auto-execute with logging
- **MEDIUM (60-84%)**: Interactive approval required
- **LOW (30-59%)**: Manual review mandatory
- **CRITICAL (<30%)**: Human intervention only

## Usage Examples

### Beginner: Explore Capabilities
```
/typescripter
```
Review recommendations without execution risk.

### Intermediate: Controlled Execution
```
/typescripter --approve-strategy --primary-agent fixer
```
Execute specific agent with full oversight.

### Advanced: Efficient Automation
```
/typescripter --auto-execute --confidence-threshold 90
```
Automate high-confidence operations.

### Production: Maximum Safety
```
/typescripter --hil-mode strict --confidence-threshold 95
```
Production-safe with expert assistance.

## Output Format

```
🤖 TypeScript Agent Analysis Report
=====================================

📊 ERROR ANALYSIS
┌──────────┬───────┬────────────┬────────────┐
│ Category │ Count │ Agent      │ Confidence │
├──────────┼───────┼────────────┼────────────┤
│ Build    │   12  │ fixer      │ 87%        │
│ Database │    3  │ db-migrate │ 92%        │
│ Quality  │   15  │ quality    │ 64%        │
└──────────┴───────┴────────────┴────────────┘

🎯 RECOMMENDED STRATEGY
Coordination: typescript_resolution
Estimated Time: 8-12 minutes
Risk Level: MEDIUM

💡 EXECUTION OPTIONS
1. Approve Strategy (--approve-strategy)
2. Auto-Execute High Confidence (--auto-execute)
3. Manual Review (--hil-mode strict)
```

## Performance Metrics

- **60-70% faster** than manual resolution
- **95% first-pass success** rate
- **90% reduction** in missed dependencies

## Emergency Controls

- `CTRL+C` to abort execution
- `--abort` flag for immediate stop
- Automatic rollback on critical failures

## Instructions Location

Agent configuration: `.agaile-os/agents/config.yml`
Workflow instructions: `.agaile-os/instructions/core/typescripter.md`
