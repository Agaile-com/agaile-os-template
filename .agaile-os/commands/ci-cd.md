# CI/CD Pipeline Management

**Purpose**: Comprehensive CI/CD pipeline orchestration for your project

---

@include shared/universal-constants.yml#Universal_Legend

## Command Execution

Execute: immediate. --plan→show plan first
Legend: Generated based on symbols used in command
Purpose: "[Action][Subject] in $ARGUMENTS"

Project-specific CI/CD management for your project, aligned with docs/ops/procedures/ci-cd-workflow.md.

@include shared/hil-patterns.yml#HIL_Framework
@include shared/flag-inheritance.yml#Universal_Always

Examples:

- `/ci-cd --status` - Show comprehensive CI/CD dashboard
- `/ci-cd --run local --scope all` - Run complete local CI pipeline
- `/ci-cd --deploy dev` - Deploy to development environment
- `/ci-cd --deploy staging --wait` - Deploy to staging and wait for completion
- `/ci-cd --deploy prod --approve` - Deploy to production with approval check
- `/ci-cd --monitor --env all` - Monitor all environment pipelines
- `/ci-cd --rollback-plan prod` - Generate production rollback plan (no execution)
- `/ci-cd --health` - Check CI/CD system health and configuration

Core Operations:

**--status:** Comprehensive CI/CD Dashboard

- GitHub Actions pipeline status (main/staging/develop)
- Vercel deployment status across environments
- Test coverage metrics and trends
- Security scan results summary
- Build performance metrics
- Environment health indicators

**--run:** Local CI Pipeline Execution

- `--scope lint`: ESLint + TypeScript typecheck
- `--scope test`: Jest with coverage reporting  
- `--scope build`: Next.js production build verification
- `--scope security`: npm audit + security header validation
- `--scope all`: Complete CI pipeline locally

**--deploy:** Environment Deployment Management

- `--deploy dev`: Deploy develop branch to development
- `--deploy staging`: Deploy develop → staging with promotion
- `--deploy prod`: Deploy staging → main with approval gates
- `--wait`: Block until deployment completes
- `--approve`: Handle production deployment approvals

**--monitor:** Pipeline Monitoring

- Real-time GitHub Actions status
- Vercel deployment progress tracking
- Build logs streaming and filtering
- Performance metrics collection
- Error detection and alerting

**--rollback:** Code Rollback Procedures (Database Excluded)

- `--rollback dev`: Quick rollback development deployment
- `--rollback staging`: Rollback staging to previous stable  
- `--rollback-plan prod`: **PRODUCTION**: Generate rollback plan only (no execution)
- ⚠️  **DATABASE ROLLBACKS DISABLED**: Manual procedures required for production
- Rollback impact assessment and compatibility validation

**--health:** System Health Checks

- GitHub Actions runner availability
- Vercel integration status
- Environment variable validation
- Database connectivity across environments
- Third-party service health (Supabase, V0 API)

@define project-ci-cd
environments:
  dev:
    branch: develop
    url: https://dev.yourproject.com
    auto_deploy: true
    tests_required: false
  staging:
    branch: staging  
    url: https://staging.yourproject.com
    auto_deploy: true
    tests_required: true
  prod:
    branch: main
    url: https://yourproject.com
    auto_deploy: true
    tests_required: true
    approval_required: true

quality_gates:
  coverage_threshold: 0%  # Current: building up to 70%
  security_scan: required
  build_success: required
  lint_clean: required
  typecheck_pass: required

@include shared/execution-patterns.yml#CI_CD_Integration_Patterns

### Implementation Details

@block status_dashboard

Display format:
```
🚀 CI/CD Pipeline Dashboard
========================================

📊 ENVIRONMENTS STATUS
┌─────────────┬─────────────────────────┬─────────────┬─────────────┬─────────────────┐
│ Environment │ Branch                  │ Build       │ Deploy      │ Last Updated    │
├─────────────┼─────────────────────────┼─────────────┼─────────────┼─────────────────┤
│ 🟢 Prod     │ main (47e4887)         │ ✅ Success  │ ✅ Live     │ 2h ago         │
│ 🟡 Staging  │ staging (1db7520)      │ 🔄 Running  │ 🔄 Deploy   │ 15m ago        │
│ 🟢 Dev      │ develop (9d8b10c)      │ ✅ Success  │ ✅ Live     │ 5m ago         │
└─────────────┴─────────────────────────┴─────────────┴─────────────┴─────────────────┘

⚡ GITHUB ACTIONS STATUS
┌─────────────────────────┬─────────────┬───────────┬─────────────────┐
│ Workflow               │ Status      │ Duration  │ Last Run        │
├─────────────────────────┼─────────────┼───────────┼─────────────────┤
│ CI Pipeline            │ ✅ Success   │ 3m 24s   │ 5 minutes ago   │
│ Deploy Production      │ ✅ Success   │ 2m 15s   │ 2 hours ago     │
│ Security Scan          │ ✅ Success   │ 1m 45s   │ 1 hour ago      │
└─────────────────────────┴─────────────┴───────────┴─────────────────┘

🎯 QUALITY METRICS
┌──────────────────┬─────────────┬─────────────┬─────────────────────┐
│ Metric           │ Current     │ Target      │ Trend               │
├──────────────────┼─────────────┼─────────────┼─────────────────────┤
│ Test Coverage    │ 0%         │ 70%        │ 📈 Building        │
│ Build Time       │ 3m 24s     │ <5m        │ 📊 Stable          │
│ Deploy Time      │ 2m 15s     │ <3m        │ 📊 Stable          │
│ Security Score   │ A          │ A+         │ 📈 Improving       │
└──────────────────┴─────────────┴─────────────┴─────────────────────┘
```

@block local_ci_runner

Execute comprehensive local CI pipeline:
1. **Environment Validation**
   - Verify Node.js version (18+)
   - Check PNPM installation and lockfile integrity
   - Validate environment variables (.env.local)
   
2. **Code Quality Pipeline**
   - Run ESLint with JSON output for detailed reporting
   - Execute TypeScript compiler with strict checking
   - Generate code quality metrics and suggestions

3. **Testing Pipeline**
   - Execute Jest test suite with coverage reporting
   - Generate coverage reports (lcov, html, json)
   - Validate coverage thresholds (future: 70% target)

4. **Build Pipeline**
   - Create Next.js production build
   - Validate build output and bundle analysis
   - Check for build warnings and optimization opportunities

5. **Security Pipeline**
   - Run npm audit for dependency vulnerabilities
   - Validate security headers configuration
   - Check for exposed secrets or sensitive data

@block deployment_orchestration

Development Deployment:
- Verify develop branch is current
- Run local CI checks (non-blocking warnings)
- Push to trigger Vercel auto-deployment
- Monitor deployment progress and report URL

Staging Deployment:  
- Merge develop → staging with conflict resolution
- Wait for CI pipeline completion (required)
- Trigger staging deployment with validation
- Run integration tests against staging environment

Production Deployment:
- Validate staging environment stability
- Merge staging → main with approval checks
- Execute production deployment with monitoring
- Validate post-deployment health and rollback readiness

@block monitoring_system

Real-time Pipeline Monitoring:
- Poll GitHub Actions API for workflow status
- Stream Vercel deployment logs and progress
- Aggregate performance metrics across environments
- Alert on failures or performance degradation
- Generate deployment success/failure reports

Health Monitoring:
- Environment connectivity checks
- Database health across all environments  
- Third-party service integration status
- Resource utilization and performance metrics

@block rollback_procedures

Safe Code-Only Rollback Implementation:
1. **Impact Assessment**
   - Analyze changes between current and previous deployment
   - **⚠️ CHECK FOR DATABASE MIGRATION DEPENDENCIES**
   - Validate code rollback compatibility
   - **HALT IF DATABASE CHANGES DETECTED**

2. **Code Rollback Execution** (Development/Staging Only)
   - Trigger Vercel rollback to previous deployment
   - Validate rollback completion and system stability
   - **DATABASE CHANGES REQUIRE MANUAL INTERVENTION**

3. **Production Rollback Planning** (No Execution)
   - Generate detailed rollback impact assessment
   - Create manual database rollback checklist
   - Document required manual steps for database changes
   - **REQUIRES MANUAL DATABASE MIGRATION ROLLBACK**
   - Provide step-by-step rollback instructions

**⚠️ CRITICAL: Production database rollbacks are NEVER automated due to:**
- Risk of data corruption from code/database state mismatch
- Complexity of coordinating Vercel and Supabase rollbacks
- Potential for cascading failures across services
- Need for manual verification of data integrity

### Integration with HIL Workflow

@block workflow_integration

Command Chain Position:
```
/db-migrate → /typescripter → /ci-cd → /g → /documenter
```

Pre-CI/CD Requirements:
- Database migrations completed and validated
- TypeScript compilation errors resolved
- Code meets quality standards

Post-CI/CD Handoff:
- All environments deployed successfully
- Quality gates satisfied  
- Ready for version control operations via `/g`

@block quality_gates

Automated Quality Enforcement:
- Block deployments if tests fail
- Require security scan passage
- Enforce build success across environments
- Validate coverage thresholds (when implemented)
- Check for breaking changes in API contracts

Manual Quality Gates:
- Staging environment validation
- Performance regression testing
- Security review for production deployments
- Business stakeholder approval for major releases

### Error Handling & Recovery

@block error_scenarios

Common Failure Scenarios:
| Scenario | Detection | Recovery Action |
|----------|-----------|----------------|
| Build failure | CI pipeline red | Fix build errors, retry deployment |
| Test failures | Coverage reports | Address failing tests, re-run CI |
| Security vulnerabilities | npm audit | Update dependencies, security patches |
| Deployment timeout | Vercel monitoring | Rollback, investigate performance |
| Environment connectivity | Health checks | Verify network, credentials, services |

Automated Recovery (Non-Production):
- Retry failed deployments with exponential backoff
- Auto-rollback on critical dev/staging failures (code-only)
- Alert stakeholders on persistent issues
- Generate incident reports for post-mortem analysis

**Production Recovery** (Manual Only):
- Alert incident response team immediately
- Generate rollback plan with manual database procedures
- Require approval for all production rollback operations
- Document all recovery actions for audit compliance

### Flags and Options

#### Environment and Scope
- `--env <dev|staging|prod|all>`: Target environment(s)
- `--scope <lint|test|build|security|all>`: CI pipeline scope

#### HIL and Safety Controls
- `--plan`: Show deployment/rollback plan without execution
- `--approve`: Handle manual approval steps (required for production)
- `--confirm`: Confirm destructive operations
- `--rollback-plan`: Generate rollback plan only (no execution for production)
- `--emergency-override`: Emergency bypass for critical incidents (audit required)

#### Execution Control
- `--wait`: Block until operation completes
- `--verbose`: Detailed logging and output
- `--dry-run`: Simulation mode without actual changes

### Safeguards

- Production deployment requires explicit confirmation
- Rollback procedures include impact assessment
- Quality gates prevent broken code deployment
- Monitoring alerts on system degradation
- Audit logging for compliance and debugging

### Integration Points

- **GitHub Actions**: Pipeline status and execution control
- **Vercel**: Deployment management and monitoring  
- **Supabase**: Database health and connectivity
- **npm**: Dependency management and security scanning
- **Next.js**: Build optimization and bundle analysis

@include shared/docs-patterns.yml#Standard_Notifications

@include shared/universal-constants.yml#Standard_Messages_Templates

---

*This command centralizes CI/CD operations that were previously scattered across multiple tools, providing unified pipeline management for the your project platform's development lifecycle.*