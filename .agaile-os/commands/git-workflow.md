**Purpose**: Git version control workflow for your project (project-scoped)

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution

Execute: immediate. --plan→show plan first
Legend: Generated based on symbols used in command
Purpose: "[Action][Subject] in $ARGUMENTS"

Project-specific git version control for your project, coordinating with /ci-cd for deployment pipeline management.

@include shared/flag-inheritance.yml#Universal_Always

Examples:

- `/g --commit "feat(auth): add OAuth login"` - Conventional commit with staged files
- `/g --commit "feat: preview changes" --branch preview` - Commit and push to preview branch
- `/g --pr --from preview --to develop --reviewers alice,bob` - Create PR from preview to develop
- `/g --pr --to main` - Create hotfix PR to main (auto-detects current branch)
- `/g --flow feature "semantic-search"` - Start feature branch from develop
- `/g --flow feature "api-update" --base preview` - Start feature branch from preview
- `/g --flow preview --sync` - Sync preview branch with current changes
- `/g --push --branch develop` - Push current changes to develop branch
- `/g --merge staging main --strategy squash` - Squash merge staging into main
- `/g --sync --branch main` - Sync main branch with upstream

Git operations:

**--commit:** Stage appropriate files | Conventional commit | Co-author support | Branch-aware push

- `--branch TARGET`: Switch to branch before commit, or create if doesn't exist
- Auto-detects appropriate upstream target for push
- Validates CI/CD status via `/ci-cd` integration before protected branch commits

**--pr:** Create pull request | Generate PR description | Set reviewers & labels | Link CI/CD status

- `--from SOURCE --to TARGET`: Explicit source and target branch control
- `--to TARGET`: Auto-detect source from current branch
- Auto-includes CI/CD dashboard links and deployment URLs from `/ci-cd --status`
- Intelligent target defaulting: feature/* → develop, hotfix/* → main, preview → develop

**--flow:** Enhanced Git workflow patterns with multi-branch support

- `feature NAME [--base BRANCH]`: Create feature branch from develop or specified base
- `hotfix NAME`: Create hotfix branch from main, auto-merges to main and develop
- `preview [--sync]`: Create or sync preview branch for testing
- `release`: Coordinate release preparation (integrates with `/ci-cd` validation)

**--push:** Branch-aware push operations

- `--branch TARGET`: Push to specific branch (creates if doesn't exist)
- `--force`: Force push with safety checks
- Validates CI/CD requirements before pushing to protected branches

**--merge:** Enhanced merge operations with strategy support

- `--strategy squash|merge|rebase`: Merge strategy selection
- Cross-branch validation (checks `/ci-cd --status` for target branch health)
- Automatic conflict detection and resolution guidance

**--sync:** Branch synchronization helpers

- `--branch BRANCH`: Sync specific branch with upstream
- `--all`: Sync all tracked branches
- Handles merge conflicts and provides resolution guidance

@define refreshify
root: /Users/ivo/Development/refreshify
repo: Agaile-com/refreshify
branches:
  main: production
  staging: pre-production
  develop: development
  preview: preview/testing
urls:
  preview: https://preview.your-project.com
  dev: https://dev.yourproject.com
  staging: https://staging.yourproject.com
  prod: https://yourproject.com

@include shared/execution-patterns.yml#Git_Integration_Patterns

### Implementation Details

@block commit

- Detect changed files and stage intelligently (respect .gitignore)
- Enforce conventional commits; if message not provided, prompt template: `type(scope): subject`
- Append co-author if `--co "Name <email>"`
- Branch-aware commit workflow:
  - `--branch TARGET`: Switch to target branch before commit (create if doesn't exist)
  - Validate CI/CD status for protected branches via `/ci-cd --status` integration
  - Push to appropriate upstream (respects branch protection rules)
  - Auto-tag preview commits for easy identification

@block pr

- Enhanced source/target control:
  - `--from SOURCE --to TARGET`: Explicit branch specification
  - `--to TARGET`: Auto-detect source from current branch
  - Smart defaults: feature/* → develop, hotfix/* → main, preview → develop
- Create PR with title from latest commit or `--title`
- Body auto-includes:
  - CI/CD dashboard links from `/ci-cd --status`
  - Environment URLs for deployments (preview/dev/staging)
  - Deployment status and health checks
  - Quality gate status and coverage reports
  - Checklist from docs (CI pass, review, conflicts, up-to-date)
- Apply `--reviewers`, `--labels`, `--draft` if provided
- Link related issues and include deployment previews

@block flow

- `feature NAME [--base BRANCH]`:
  - Default: `git checkout develop && git pull` (or specified base branch)
  - `git checkout -b feature/NAME`
  - Set upstream tracking and initial push
- `hotfix NAME`:
  - `git checkout main && git pull`
  - `git checkout -b hotfix/NAME`
  - Auto-configure for merge to both main and develop
- `preview [--sync]`:
  - Create or switch to preview branch
  - `--sync`: Merge current branch changes into preview
  - Set up tracking for preview environment deployment
- `release`:
  - Validate all CI/CD pipelines via `/ci-cd --status`
  - Prepare release branch or coordinate staging → main merge
  - Check quality gates and deployment readiness

@block push

- `--branch TARGET`: 
  - Switch to target branch (create if doesn't exist)
  - Push current changes with upstream tracking
  - Validate CI/CD requirements for protected branches
- `--force`: 
  - Force push with safety checks (protect against data loss)
  - Require confirmation for protected branches
- Auto-detect appropriate remote and upstream configuration

@block merge

- `--strategy squash|merge|rebase`: Select merge strategy
- Pre-merge validation:
  - Check CI/CD status via `/ci-cd --status` for both branches
  - Validate no pending deployments that would conflict
  - Ensure branches are up-to-date with their upstreams
- Post-merge actions:
  - Update related branches (e.g., hotfix merges to both main and develop)
  - Trigger appropriate CI/CD notifications
  - Clean up merged feature branches

@block sync

- `--branch BRANCH`: Sync specific branch with its upstream
- `--all`: Sync all tracked branches
- Conflict resolution:
  - Detect merge conflicts and provide resolution guidance
  - Suggest appropriate merge strategies
  - Coordinate with `/ci-cd` to ensure deployments are stable

@include shared/pre-commit-patterns.yml#Pre_Commit_Setup

### Flags

- `--branch <branch>`: Target branch for commit/push operations
- `--from <source>`: Source branch for PR creation
- `--to <target>`: Target branch for PR creation  
- `--base <branch>`: Base branch for feature creation (default: develop)
- `--strategy <squash|merge|rebase>`: Merge strategy selection
- `--reviewers a,b`: PR reviewers
- `--labels x,y`: PR labels
- `--draft`: PR as draft
- `--co "Name <email>"`: Co-author for commits
- `--sync`: Sync branch with current changes
- `--force`: Force push with safety checks
- `--all`: Apply operation to all relevant branches

### Safeguards

- Block direct commits to protected branches without PR (main, staging, preview) unless `--force`
- Verify branch up-to-date before merges (`git fetch; git status --porcelain -b`)
- Validate CI/CD pipeline status via `/ci-cd --status` before operations on protected branches
- Coordinate with `/ci-cd` to ensure deployments are stable before merges
- Surface links to environment deployments and CI/CD dashboards in PRs
- Prevent force pushes to main/staging without explicit confirmation
- Auto-validate preview branch deployments before promoting to develop

@include shared/docs-patterns.yml#Standard_Notifications

@include shared/universal-constants.yml#Standard_Messages_Templates
