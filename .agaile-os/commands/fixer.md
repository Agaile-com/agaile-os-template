# Fixer - Intelligent Issue Resolution

## Description
Systematically diagnoses and fixes common development issues through intelligent error analysis and targeted solutions. Handles build errors, module resolution, cache issues, dependency conflicts, and runtime problems with automated diagnostic workflows.

## Usage
```
/fixer [options] [error-context]
```

## Options

### HIL (Human-in-the-Loop) Controls
- `--analyze-only` - **DEFAULT**: Analyze and recommend fixes without execution
- `--approve-fixes` - Interactive approval mode for applying fixes
- `--confidence-threshold <number>` - Minimum confidence for auto-execution (1-100, default: 70)
- `--explain` - Show detailed reasoning for diagnosis and fix recommendations
- `--plan` - Show fix execution plan without applying changes

### Diagnostic Options
- `--error <error-text>` - Paste specific error message for targeted analysis
- `--type <category>` - Focus on specific error type (build, module, cache, deps, runtime, config)
- `--deep` - Perform comprehensive system analysis before fixing
- `--verify` - Run verification tests after applying fixes

### Execution Options
- `--quick` - Apply high-confidence fixes with minimal analysis
- `--auto-execute` - Override analyze-only default (requires confidence threshold)
- `--cache-clear` - Force clear all caches during fix process
- `--deps-refresh` - Reinstall dependencies during fix process

## Usage Scenarios

### **Module Resolution Errors**
```bash
/fixer --error "Cannot find module './vendor-chunks/@opentelemetry+resources@2.0.1'"
```
**Use Case**: Missing vendor chunks, webpack resolution issues
**Fixes Applied**: Clear Next.js cache, rebuild, dependency refresh

### **Build/Compilation Failures**
```bash
/fixer --type build --verify
```
**Use Case**: TypeScript errors, build process failures, asset issues
**Fixes Applied**: Type checking, cache clearing, incremental rebuilds

### **Cache-Related Issues**
```bash
/fixer --cache-clear --quick
```
**Use Case**: Stale cache causing inconsistent behavior
**Fixes Applied**: Clear Next.js, Node, and package manager caches

### **Dependency Conflicts**
```bash
/fixer --type deps --deps-refresh
```
**Use Case**: Version conflicts, missing packages, lockfile issues
**Fixes Applied**: Clean install, lockfile repair, peer dependency resolution

### **Runtime/Server Errors**
```bash
/fixer --type runtime --deep
```
**Use Case**: Server startup failures, API route issues
**Fixes Applied**: Environment validation, port conflicts, service dependencies

### **Configuration Issues**
```bash
/fixer --type config --verify
```
**Use Case**: Environment variables, Supabase config, API keys
**Fixes Applied**: Config validation, key verification, service health checks

### **General Quick Fix**
```bash
/fixer --quick
```
**Use Case**: Unknown issue, need comprehensive fix attempt
**Fixes Applied**: Standard fix sequence covering most common issues

@include shared/hil-patterns.yml#HIL_Framework

## Implementation

### HIL Integration

**Risk Assessment**: Cache operations (LOW), Dependency fixes (MEDIUM), Nuclear option (CRITICAL)
**Default Approval**: CONFIRM for fixes below 70% confidence threshold
**Pattern Confidence**: Required for all diagnoses with alternative suggestions
**Emergency Override**: Available for production incidents with approval audit

### Confidence-Based Diagnostic Engine

#### **1. Confidence-Based Error Analysis**
```typescript
interface ErrorPattern {
  pattern: RegExp
  category: 'module' | 'build' | 'runtime' | 'config' | 'cache' | 'deps'
  severity: 'low' | 'medium' | 'high' | 'critical'
  confidence: number  // 0-100 confidence in pattern match
  commonCauses: string[]
  fixStrategies: FixStrategy[]
  alternativeDiagnoses: AlternativeDiagnosis[]  // When confidence is low
}

interface AlternativeDiagnosis {
  pattern: RegExp
  confidence: number
  reasoning: string
  recommendedAction: 'manual_review' | 'try_alternative' | 'gather_more_info'
}

interface FixConfidenceAssessment {
  patternMatchConfidence: number    // How well error matches known patterns
  successProbability: number       // Historical success rate of this fix
  riskAssessment: number           // Potential negative impact
  overallConfidence: number        // Combined confidence score
  requiresApproval: boolean        // Below threshold - needs user approval
  alternativeApproaches: string[]  // When confidence is low
}

// Example patterns with confidence scoring
const ERROR_PATTERNS: ErrorPattern[] = [
  {
    pattern: /Cannot find module.*vendor-chunks/,
    category: 'module',
    severity: 'high',
    confidence: 85, // High confidence - very specific pattern
    commonCauses: ['stale cache', 'incomplete build', 'dependency mismatch'],
    fixStrategies: ['cache_clear', 'rebuild', 'deps_refresh'],
    alternativeDiagnoses: [
      {
        pattern: /Cannot find module.*node_modules/,
        confidence: 60,
        reasoning: 'Could be general dependency issue',
        recommendedAction: 'try_alternative'
      }
    ]
  },
  {
    pattern: /Type.*is not assignable to type/,
    category: 'build', 
    severity: 'medium',
    confidence: 45, // Lower confidence - very generic pattern
    commonCauses: ['type definition updates', 'schema changes', 'API changes'],
    fixStrategies: ['type_gen', 'schema_sync', 'build_clean'],
    alternativeDiagnoses: [
      {
        pattern: /Property.*does not exist on type/,
        confidence: 70,
        reasoning: 'More specific property access error',
        recommendedAction: 'manual_review'
      }
    ]
  },
  {
    pattern: /ENOENT.*no such file or directory/,
    category: 'runtime',
    severity: 'high',
    confidence: 90, // Very high confidence - specific OS error
    commonCauses: ['missing file', 'incorrect path', 'permission issues'],
    fixStrategies: ['file_check', 'path_validation', 'permission_fix'],
    alternativeDiagnoses: []
  }
]
```

#### **2. System Health Check**
- **Node/PNPM Version Compatibility**: Verify versions match project requirements
- **Port Availability**: Check for port conflicts (3000, 5432, etc.)
- **Service Dependencies**: Validate Supabase, Redis connections
- **Environment Variables**: Verify required env vars are set
- **File Permissions**: Check read/write access to critical directories

#### **3. Context-Aware Diagnosis**
- **Recent Git Changes**: Analyze recent commits for clues
- **Package Changes**: Check lockfile modifications
- **Build Artifacts**: Examine .next, dist directories for corruption
- **Log Analysis**: Parse console, build, and server logs

### Fix Strategy Categories

#### **Module Resolution Fixes**
```bash
# Standard module resolution sequence
rm -rf .next node_modules/.cache
pnpm install --frozen-lockfile
pnpm run build
```

**Advanced Module Fixes:**
- Clear Next.js webpack cache: `rm -rf .next/cache`
- Rebuild node_modules: `rm -rf node_modules && pnpm install`
- Fix symlink issues: `pnpm install --no-symlinks`
- Reset package resolution: `rm pnpm-lock.yaml && pnpm install`

#### **Build/Compilation Fixes**
```bash
# TypeScript and build repair
pnpm run typecheck --force
rm -rf .next dist
pnpm run build --clean
```

**Build Enhancement:**
- Incremental type checking: `pnpm tsc --incremental`
- Schema regeneration: `pnpm db:generate`
- Asset optimization: Clear image cache, rebuild static assets
- Bundle analysis: Check for circular dependencies

#### **Cache Management**
```bash
# Comprehensive cache clearing
rm -rf .next/cache node_modules/.cache ~/.npm/_cacache
pnpm store prune
```

**Cache Strategies:**
- **Selective Cache**: Clear only problematic cache directories
- **Progressive Clear**: Clear caches in order of likelihood
- **Verification**: Test functionality after each cache clear

#### **Dependency Resolution**
```bash
# Dependency repair sequence
rm -rf node_modules pnpm-lock.yaml
pnpm install
pnpm audit fix
```

**Dependency Fixes:**
- Peer dependency resolution: `pnpm install --shamefully-hoist`
- Version conflict resolution: Analyze dependency tree
- Lockfile repair: Validate and regenerate lockfile
- Package deduplication: `pnpm dedupe`

#### **Runtime Issue Resolution**
```bash
# Server and runtime fixes
pkill -f "node.*next"
pnpm run dev --clean-cache
```

**Runtime Strategies:**
- Port conflict resolution: Find and kill conflicting processes
- Environment validation: Check all required env vars
- Service health: Verify database, Redis, external API connections
- Memory cleanup: Clear Node.js memory leaks

#### **Configuration Fixes**
```bash
# Config validation and repair
cp .env.example .env.local
pnpm validate-env
```

**Configuration Repair:**
- Environment variable validation
- Supabase connection testing
- API key verification
- Database schema synchronization

### Intelligent Fix Sequencing

#### **Quick Fix Sequence** (Default)
1. **Cache Clear**: Remove stale caches that cause 80% of issues
2. **Dependency Refresh**: Ensure packages are correctly installed
3. **Build Clean**: Force clean rebuild of artifacts
4. **Service Restart**: Restart development server with clean state

#### **Deep Fix Sequence**
1. **System Analysis**: Comprehensive health check and diagnosis
2. **Root Cause Identification**: Analyze logs, git history, config changes
3. **Targeted Resolution**: Apply specific fixes based on analysis
4. **Progressive Verification**: Test each fix before proceeding
5. **System Validation**: Comprehensive functionality testing

#### **Emergency Fix Sequence**
1. **Nuclear Option**: Complete reset of all caches and dependencies
2. **Clean Rebuild**: Full project rebuild from scratch
3. **Configuration Reset**: Restore all configs to known good state
4. **Service Restart**: Restart all related services

### Verification Framework

#### **Fix Verification Tests**
```bash
# Standard verification sequence
pnpm run typecheck     # TypeScript validation
pnpm run build        # Build verification
pnpm run test:quick   # Basic functionality tests
curl localhost:3000/api/health  # Service health check
```

#### **Health Check Categories**
- **Build System**: Verify TypeScript, Next.js, bundling works
- **Database**: Check Supabase connection, schema sync
- **Services**: Validate all external service connections
- **Runtime**: Confirm server starts and responds correctly
- **Frontend**: Basic UI functionality and routing

### Error Pattern Database

#### **Common Next.js Issues**
- **Module Resolution**: `Cannot find module`, vendor chunks missing
- **Build Failures**: TypeScript errors, asset compilation issues
- **Runtime Errors**: Server startup failures, API route issues
- **Cache Problems**: Stale builds, inconsistent behavior

#### **Database-Related Issues**
- **Connection Failures**: Invalid credentials, network issues
- **Schema Mismatches**: Prisma schema out of sync
- **Migration Issues**: Failed migrations, constraint violations
- **Performance Problems**: Slow queries, connection pool exhaustion

#### **Dependency Issues**
- **Version Conflicts**: Peer dependency warnings, incompatible versions
- **Missing Packages**: Import errors, build failures
- **Lockfile Problems**: Corrupted lockfile, inconsistent installs
- **Package Manager Issues**: PNPM vs NPM conflicts, cache corruption

### Integration Points

#### **CI/CD Integration**
- Check build status before applying fixes
- Coordinate with `/ci-cd` command for deployment impacts
- Verify fixes don't break production builds

#### **Database Integration**
- Use Supabase MCP for database health checks
- Coordinate schema changes with migration system
- Validate database connections during fixes

#### **Git Integration**
- Check recent commits for breaking changes
- Create fix commits with conventional commit format
- Coordinate with `/g` command for version control

### Fix Result Reporting

#### **Success Report Format**
```markdown
✅ **Fix Applied Successfully**

**Issue Diagnosed**: Module resolution error - vendor chunks missing
**Root Cause**: Stale Next.js cache after dependency update
**Fixes Applied**: 
  - Cleared .next/cache directory
  - Reinstalled dependencies with --frozen-lockfile
  - Rebuilt project with clean cache

**Verification Results**:
  - ✅ Build: Successful (2.3s)
  - ✅ TypeScript: No errors
  - ✅ Server: Started successfully on port 3000
  - ✅ Health Check: All services responding

**Prevention**: Clear cache after dependency updates
```

#### **Failure Report Format**
```markdown
❌ **Fix Incomplete - Manual Intervention Required**

**Issue**: Cannot resolve TypeScript compilation errors
**Attempted Fixes**: 
  - ✅ Cache cleared
  - ✅ Dependencies refreshed  
  - ❌ Build still failing

**Remaining Issues**:
  - Type definition conflicts in authentication module
  - Circular dependency in user management system

**Recommended Actions**:
1. Review recent changes to auth types
2. Check for circular imports in user management
3. Consider reverting to last known good commit
4. Manual review of TypeScript configuration

**Logs**: Available in `.fixer/debug-TIMESTAMP.log`
```

### Command Execution Flow

#### **Default Flow** (Analysis + Recommendations)
1. **Error Analysis**: Parse provided error or scan recent logs
2. **Confidence-Based Pattern Matching**: Score pattern matches and alternatives
3. **Risk Assessment**: Evaluate potential impact of proposed fixes
4. **Recommendation Generation**: Present fixes with confidence scores
5. **User Guidance**: Show approval options based on confidence levels
6. **No Execution**: Safe by default - requires explicit approval

#### **Interactive Approval Flow** (--approve-fixes)
1. **Complete Analysis**: Confidence scoring and risk assessment
2. **Present Options**: Show all potential fixes with confidence levels
3. **User Selection**: Allow user to approve/reject individual fixes
4. **Progressive Execution**: Apply approved fixes with real-time feedback
5. **Verification**: Test each fix before proceeding to next
6. **Learning Integration**: Update confidence based on outcomes

#### **High-Confidence Auto Mode** (--auto-execute --confidence-threshold 85)
1. **Filter by Confidence**: Only execute fixes above specified threshold
2. **Risk Validation**: Double-check risk levels for auto-execution
3. **Progressive Application**: Apply high-confidence fixes sequentially
4. **Continuous Monitoring**: Watch for unexpected failures
5. **Abort on Low Confidence**: Stop if confidence drops below threshold
6. **Emergency Fallback**: Provide manual options if automation fails

#### **Nuclear Option Flow** (Requires APPROVE level)
1. **Complete System Reset**: Clear all caches, reinstall dependencies
2. **Risk Warning**: Show comprehensive impact assessment
3. **Manual Approval Required**: Cannot be automated due to high risk
4. **Backup Verification**: Ensure ability to restore if needed
5. **Progressive Reset**: Apply nuclear fixes with checkpoints
6. **Full System Validation**: Comprehensive testing after reset

### Configuration

#### **Fix Preferences**
```yaml
# .fixer/config.yml
preferences:
  default_mode: quick
  auto_verify: true
  preserve_logs: true
  backup_before_nuclear: true
  
fix_sequences:
  module_resolution:
    - cache_clear
    - deps_refresh
    - build_clean
  
  build_errors:
    - type_check
    - schema_sync
    - incremental_build
    
  runtime_issues:
    - env_validate
    - port_check
    - service_restart
```

#### **Project-Specific Overrides**
```yaml
# your project-specific configurations
refreshify:
  required_services: [supabase, redis]
  critical_env_vars: [SUPABASE_URL, SUPABASE_ANON_KEY, V0_API_KEY]
  build_commands: [typecheck, build, lint]
  health_endpoints: [/api/health, /api/health/database]
```

## Expected Output

The fixer command will:
- **Diagnose Issues**: Intelligent analysis of error messages and system state
- **Apply Targeted Fixes**: Context-aware solutions based on error patterns
- **Verify Resolution**: Test that fixes actually resolved the problem
- **Provide Clear Reporting**: Detailed success/failure reports with next steps
- **Learn from Patterns**: Build knowledge base of effective fix strategies

### Success Scenarios
- Module resolution errors cleared with cache refresh
- Build failures resolved through clean rebuild
- Runtime issues fixed with service restart
- Configuration problems corrected with validation

### Escalation Scenarios
- Complex issues requiring manual analysis
- Multiple interconnected problems
- System-level configuration issues
- Critical production environment problems