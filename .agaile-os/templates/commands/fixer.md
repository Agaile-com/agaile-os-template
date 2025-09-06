# Fixer - Intelligent Issue Resolution

## Description
Systematically diagnoses and fixes common development issues through intelligent error analysis and targeted solutions. Handles build errors, module resolution, cache issues, dependency conflicts, and runtime problems with automated diagnostic workflows.

## Usage
```
/fixer [options] [error-context]
```

## HIL (Human-in-the-Loop) Controls
- `--analyze-only` - **DEFAULT**: Analyze and recommend fixes without execution
- `--approve-fixes` - Interactive approval mode for applying fixes
- `--confidence-threshold <number>` - Minimum confidence for auto-execution (1-100, default: 70)
- `--explain` - Show detailed reasoning for diagnosis and fix recommendations
- `--plan` - Show fix execution plan without applying changes

## Diagnostic Options
- `--error <error-text>` - Paste specific error message for targeted analysis
- `--type <category>` - Focus on specific error type (build, module, cache, deps, runtime, config)
- `--deep` - Perform comprehensive system analysis before fixing
- `--verify` - Run verification tests after applying fixes

## Execution Options
- `--quick` - Apply high-confidence fixes with minimal analysis
- `--auto-execute` - Override analyze-only default (requires confidence threshold)
- `--cache-clear` - Force clear all caches during fix process
- `--deps-refresh` - Reinstall dependencies during fix process

## Usage Scenarios

### Module Resolution Errors
```bash
/fixer --error "Cannot find module './vendor-chunks/@opentelemetry+resources@2.0.1'"
```
**Fixes Applied**: Clear Next.js cache, rebuild, dependency refresh

### Build/Compilation Failures
```bash
/fixer --type build --verify
```
**Fixes Applied**: Type checking, cache clearing, incremental rebuilds

### Cache-Related Issues
```bash
/fixer --cache-clear --quick
```
**Fixes Applied**: Clear Next.js, Node, and package manager caches

### Dependency Conflicts
```bash
/fixer --type deps --deps-refresh
```
**Fixes Applied**: Clean install, lockfile repair, peer dependency resolution

### Runtime/Server Errors
```bash
/fixer --type runtime --deep
```
**Fixes Applied**: Environment validation, port conflicts, service dependencies

## Confidence-Based Diagnostic Engine

### Error Pattern Recognition
The fixer uses a confidence-based pattern matching system:
- **High Confidence (85-100%)**: Very specific patterns, auto-execution eligible
- **Medium Confidence (45-84%)**: Generic patterns, requires approval
- **Low Confidence (<45%)**: Ambiguous patterns, manual review required

Each pattern includes:
- Common causes analysis
- Fix strategies prioritized by success rate
- Alternative diagnoses when confidence is low
- Risk assessment for each fix approach

### System Health Check
- Node/PNPM Version Compatibility
- Port Availability (3000, 5432, etc.)
- Service Dependencies (Supabase, Redis)
- Environment Variables validation
- File Permissions verification

### Context-Aware Diagnosis
- Recent Git Changes analysis
- Package Changes tracking
- Build Artifacts examination
- Log Analysis across all levels

## Fix Strategy Categories

### Module Resolution Fixes
- Clear Next.js webpack cache
- Rebuild node_modules
- Fix symlink issues
- Reset package resolution

### Build/Compilation Fixes
- TypeScript and build repair
- Schema regeneration
- Asset optimization
- Bundle analysis

### Cache Management
- Selective cache clearing
- Progressive cache clearing
- Post-clear verification

### Dependency Resolution
- Peer dependency resolution
- Version conflict resolution
- Lockfile repair
- Package deduplication

### Runtime Issue Resolution
- Port conflict resolution
- Environment validation
- Service health checks
- Memory cleanup

### Configuration Fixes
- Environment variable validation
- Service connection testing
- API key verification
- Database schema synchronization

## Intelligent Fix Sequencing

### Quick Fix Sequence (Default)
1. Cache Clear (solves 80% of issues)
2. Dependency Refresh
3. Build Clean
4. Service Restart

### Deep Fix Sequence
1. System Analysis
2. Root Cause Identification
3. Targeted Resolution
4. Progressive Verification
5. System Validation

### Emergency Fix Sequence
1. Nuclear Option (complete reset)
2. Clean Rebuild from scratch
3. Configuration Reset
4. Service Restart

## Verification Framework

### Fix Verification Tests
- TypeScript validation
- Build verification
- Basic functionality tests
- Service health checks

### Health Check Categories
- Build System verification
- Database connection checks
- External services validation
- Runtime confirmation
- Frontend functionality

## Expected Output

### Success Report
```
✅ Fix Applied Successfully
- Issue Diagnosed: [specific error]
- Root Cause: [identified cause]
- Fixes Applied: [list of fixes]
- Verification Results: [all green checks]
- Prevention: [recommendations]
```

### Failure Report
```
❌ Fix Incomplete - Manual Intervention Required
- Issue: [error description]
- Attempted Fixes: [what worked/failed]
- Remaining Issues: [unresolved problems]
- Recommended Actions: [next steps]
- Logs: [debug log location]
```