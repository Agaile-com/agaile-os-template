# Git Workflow - Version Control & CI/CD Integration

## Description
Comprehensive git version control workflow with intelligent branch management, automated PR creation, and CI/CD pipeline integration. Provides conventional commits, branch flow patterns, and deployment coordination.

## Usage
```
/g [options]
```

## Core Operations

### Commit Operations
```bash
/g --commit "feat(auth): add OAuth login"  # Conventional commit with staged files
/g --commit "feat: preview changes" --branch preview  # Commit and push to preview branch
```
- Stage appropriate files respecting .gitignore
- Enforce conventional commits format
- Branch-aware workflow with automatic push
- Co-author support with `--co "Name <email>"`

### Pull Request Management
```bash
/g --pr --from preview --to develop --reviewers alice,bob  # Create PR with reviewers
/g --pr --to main  # Create hotfix PR to main (auto-detects current branch)
```
- Auto-generate PR descriptions with CI/CD status
- Include deployment URLs and health checks
- Apply reviewers, labels, and draft status
- Link related issues automatically

### Git Flow Patterns
```bash
/g --flow feature "semantic-search"  # Start feature branch from develop
/g --flow feature "api-update" --base preview  # Start feature from preview branch
/g --flow preview --sync  # Sync preview branch with current changes
/g --flow hotfix "critical-fix"  # Create hotfix from main
```

**Feature Flow**: Create feature branches with proper tracking
**Hotfix Flow**: Auto-merge to both main and develop branches
**Preview Flow**: Dedicated preview branch for testing
**Release Flow**: Coordinate release preparation with CI/CD validation

### Push Operations
```bash
/g --push --branch develop  # Push current changes to develop
/g --push --force  # Force push with safety checks
```
- Branch-aware push with upstream tracking
- Validate CI/CD requirements for protected branches
- Force push protection and confirmation

### Merge Operations
```bash
/g --merge staging main --strategy squash  # Squash merge staging into main
```
- Multiple merge strategies (squash, merge, rebase)
- Pre-merge CI/CD validation
- Cross-branch health checks
- Post-merge cleanup and notifications

### Sync Operations
```bash
/g --sync --branch main  # Sync main branch with upstream
/g --sync --all  # Sync all tracked branches
```
- Branch synchronization with upstream
- Conflict detection and resolution guidance
- Coordinate with CI/CD for stable deployments

## Options

### Branch Control
- `--branch <branch>` - Target branch for operations
- `--from <source>` - Source branch for PR creation
- `--to <target>` - Target branch for PR/merge
- `--base <branch>` - Base branch for feature creation

### PR Options
- `--reviewers a,b` - Assign PR reviewers
- `--labels x,y` - Apply PR labels
- `--draft` - Create as draft PR
- `--title <title>` - Custom PR title

### Merge Options
- `--strategy <type>` - Merge strategy (squash|merge|rebase)
- `--force` - Force operation with safety checks

### Sync Options
- `--sync` - Sync branch with changes
- `--all` - Apply to all relevant branches

## Branch Strategy

### Protected Branches
- **main**: Production (requires PR, CI/CD validation)
- **staging**: Pre-production (requires PR, testing)
- **develop**: Development (default for features)
- **preview**: Testing/preview environment

### Branch Patterns
- **feature/***: New features → develop
- **hotfix/***: Critical fixes → main + develop
- **release/***: Release preparation → main
- **preview**: Testing branch → develop

## CI/CD Integration

### Pre-Operation Validation
- Check CI/CD pipeline status
- Validate no pending deployments
- Ensure branches are up-to-date
- Quality gate verification

### PR Automation
- Auto-include CI/CD dashboard links
- Environment deployment URLs
- Coverage reports and test results
- Deployment status indicators

### Post-Operation Actions
- Trigger appropriate pipelines
- Update deployment tracking
- Clean up merged branches
- Notify relevant channels

## Conventional Commits

### Format
```
type(scope): subject

[optional body]

[optional footer(s)]
```

### Types
- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation
- **style**: Formatting
- **refactor**: Code restructuring
- **perf**: Performance improvement
- **test**: Adding tests
- **chore**: Maintenance

## Safeguards

### Branch Protection
- Block direct commits to protected branches
- Require PR for main, staging, preview
- Force push confirmation required
- Up-to-date validation before merge

### CI/CD Validation
- Check pipeline status before operations
- Validate deployment stability
- Quality gate enforcement
- Test coverage requirements

### Conflict Prevention
- Automatic conflict detection
- Resolution guidance provided
- Upstream synchronization checks
- Branch freshness validation

## Examples

### Complete Feature Workflow
```bash
# Start feature
/g --flow feature "user-dashboard"

# Make changes and commit
/g --commit "feat(dashboard): add user statistics widget"

# Create PR when ready
/g --pr --to develop --reviewers john,jane --labels enhancement

# After review, merge
/g --merge feature/user-dashboard develop --strategy squash
```

### Hotfix Workflow
```bash
# Create hotfix from main
/g --flow hotfix "payment-fix"

# Fix and commit
/g --commit "fix(payment): resolve stripe webhook issue"

# Create PR to main
/g --pr --to main --reviewers lead-dev --labels hotfix,urgent

# Auto-merges to both main and develop after approval
```

### Preview Testing
```bash
# Create or sync preview branch
/g --flow preview --sync

# Push changes for preview deployment
/g --push --branch preview

# After testing, create PR to develop
/g --pr --from preview --to develop
```