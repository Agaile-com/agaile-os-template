# Pre-flight Checklist

## Context Validation
- [ ] Current working directory confirmed as project root
- [ ] `.agaile-os/MASTER_TRACKING.md` accessible and current
- [ ] User permissions validated for requested operations

## Feature Status Check
- [ ] Target feature identified in MASTER_TRACKING.md
- [ ] Current HIL phase status confirmed
- [ ] Dependencies and blockers assessed
- [ ] Required approvals obtained (if applicable)

## System Readiness
- [ ] Required MCP servers available and responsive
- [ ] Database connection validated (if database operations required)
- [ ] Version control status clean (no uncommitted changes blocking operation)
- [ ] Build system functional (if compilation required)

## Integration Points
- [ ] Supabase connection validated (for database operations)
- [ ] Vercel deployment pipeline accessible (for deployment operations)
- [ ] Required API keys and credentials available
- [ ] TypeScript compilation successful (if code changes involved)

## Risk Assessment
- [ ] Operation impact level assessed (LOW/MEDIUM/HIGH)
- [ ] Rollback procedures identified and documented
- [ ] Stakeholder notifications planned (if required)
- [ ] Backup verification completed (for destructive operations)

## HIL Workflow Compliance
- [ ] Current phase prerequisites satisfied
- [ ] Next phase requirements understood
- [ ] Progress tracking mechanism confirmed
- [ ] Quality gates identified and planned