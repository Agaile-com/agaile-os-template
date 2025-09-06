# Verify Deployment - Phase 3.5 Pre-Deployment Verification

## Description

Comprehensive pre-deployment verification that prevents deployment issues by validating deployment-environment-specific requirements. Part of HIL Workflow Phase 3.5.

## Usage

```
/verify-deployment [options]
```

## Options

### HIL (Human-in-the-Loop) Controls

- `--analyze-only` - **DEFAULT MODE**: Only analyze without executing fixes
- `--auto-execute` - Enable autonomous fix execution (overrides analyze-only default)
- `--approve-strategy` - Interactive fix approval mode (analyze + approve + execute)
- `--plan` - Show detailed execution plan without execution
- `--hil-mode [strict|standard|minimal]` - Set HIL strictness level (default: standard)

### Verification Options

- `--env [dev|staging|preview|production]` - Target deployment environment (default: staging)
- `--preview` - **PREVIEW MODE**: Optimized for Vercel preview deployments (combines --env=preview --skip-env-vars --verify-vercel)
- `--skip-build` - Skip production build test for faster validation
- `--skip-env-vars` - Skip local environment variable validation (useful for CI/CD)
- `--verify-vercel` - Validate Vercel configuration and deployment settings
- `--fix` - Attempt to auto-fix issues where possible (requires approval in HIL mode)
- `--verbose` - Show detailed output from all validation steps

### Focus Options

- `--suspense-only` - Only validate Suspense boundaries
- `--translations-only` - Only validate translation completeness
- `--build-only` - Only run production build test
- `--exports-only` - Only validate TypeScript exports

## What It Checks

### Critical Deployment Issues (Blocks Deployment)

1. **useSearchParams Suspense Boundaries** - Prevents Next.js hydration failures
2. **Translation Completeness** - Ensures all locale keys present (en.json, de.json)
3. **TypeScript Export Validation** - Prevents build-time export errors
4. **Production Build Test** - Validates full build with production config
5. **Environment Variables** - Verifies required configuration

### Warning Issues (Manual Review)

1. **Edge Runtime Compatibility** - Middleware compatibility warnings
2. **Performance Regressions** - Build size and performance warnings
3. **Accessibility Violations** - WCAG compliance issues
4. **Placeholder Content** - Translation placeholder detection

## Implementation Strategy

The command executes validation in the following order:

1. **Environment Setup**
   - Validate Node.js and pnpm availability
   - Check project structure and dependencies
   - Set up validation environment

2. **Core Validations**

   ```bash
   # Run comprehensive validation suite
   npm run verify:deployment [options]

   # Individual validations if comprehensive fails
   npm run verify:suspense
   npm run verify:translations
   npm run typecheck
   npm run lint
   npm run build
   ```

3. **Results Analysis**
   - Categorize issues by severity (Critical/Warning)
   - Generate actionable fix recommendations
   - Create deployment readiness assessment
   - Export detailed verification report

4. **Fix Execution** (if approved)
   - Auto-fix missing translation keys
   - Add missing Suspense boundaries where possible
   - Fix TypeScript export issues
   - Update environment configuration

## Output Format

```
🚀 Running Pre-Deployment Verification Suite
================================================

🔍 Running TypeScript Compilation...
✅ TypeScript Compilation completed (1,245ms)

🔍 Running Suspense Boundaries...
❌ Suspense Boundaries failed: Missing Suspense in auth/verify-email (892ms)

🔍 Running Translation Completeness...
❌ Translation Completeness failed: 3 missing keys in de.json (456ms)

📊 PRE-DEPLOYMENT VERIFICATION SUMMARY
================================================
📈 RESULTS BREAKDOWN:
   ✅ Passed: 5
   ❌ Failed: 2
   ⚠️ Warnings: 1
   ⏱️ Total time: 8,456ms

🔴 CRITICAL ISSUES (BLOCKS DEPLOYMENT):
   1. Suspense Boundaries: useSearchParams without Suspense in src/app/[locale]/auth/verify-email/page.tsx:23
   2. Translation Completeness: Missing keys in de.json: agencies.billing.title, agencies.billing.subtitle, agencies.billing.cta

💡 RECOMMENDED FIXES:
   1. Wrap useSearchParams in <Suspense fallback={<div>Loading...</div>}>
   2. Add missing translation keys to src/messages/de.json

🚦 DEPLOYMENT STATUS: ❌ BLOCKED - Fix critical issues before deployment
```

## Fix Strategies

### Auto-Fixable Issues

1. **Missing Translation Keys** - Generate template entries in target locale
2. **TypeScript Export Issues** - Add missing export statements
3. **Environment Variables** - Prompt for missing required values
4. **Linting Issues** - Apply ESLint auto-fixes

### Manual Fix Required

1. **Suspense Boundaries** - Requires component architecture decisions
2. **Performance Issues** - Needs developer optimization choices
3. **Complex Type Errors** - Requires understanding business logic
4. **Security Issues** - Needs security expert review

## Integration Points

### HIL Workflow Integration

- **Phase 3.5**: Mandatory gate between QA and CI/CD
- **Blocks**: `/ci-cd --deploy` until verification passes
- **Updates**: Deployment readiness checklist status
- **Triggers**: Automatic execution in `predeploy` npm script

### CI/CD Integration

- **GitHub Actions**: Integrated in enhanced CI workflow
- **Vercel**: Blocks deployment if verification fails
- **Artifact Generation**: Creates verification reports for review

### Development Integration

- **Pre-commit**: Optional integration with git hooks
- **IDE Integration**: Can be triggered from development environment
- **Continuous**: Run on file changes during development

## Files Created/Modified

### Validation Scripts

- `scripts/validation/pre-deployment-check.ts` - Main verification logic
- `scripts/validation/verify-suspense-boundaries.ts` - Suspense validation
- `scripts/validation/verify-translations.ts` - Translation validation

### Configuration

- `package.json` - Added verification npm scripts
- `.agent-os/checklists/deployment-readiness.md` - Manual checklist
- `.github/workflows/ci-enhanced.yml` - GitHub Actions integration

### Documentation

- Updated `docs/workflows/HIL-workflow.md` with Phase 3.5

## Examples

```bash
# Default staging verification
/verify-deployment

# Preview deployment verification (recommended for Vercel previews)
/verify-deployment --preview

# Production environment verification
/verify-deployment --env production

# Quick verification (skip build)
/verify-deployment --skip-build

# Focus on specific issue type
/verify-deployment --suspense-only

# CI/CD friendly (skip local env vars)
/verify-deployment --skip-env-vars --verify-vercel

# Auto-fix mode (with approval)
/verify-deployment --fix --approve-strategy

# Verbose output for debugging
/verify-deployment --verbose --plan
```

## Preview Deployment Mode

The `--preview` flag is specifically designed for Vercel preview deployments and automatically:

1. **Skips Local Environment Variables** - Since preview deployments use Vercel-managed environment variables
2. **Validates Vercel Configuration** - Checks `vercel.json` and deployment settings
3. **Optimizes for CI/CD Context** - Detects and adapts to CI/CD pipeline execution
4. **Focuses on Build Readiness** - Prioritizes checks that matter for Vercel deployments

### Preview Mode Output Example:

```
🚀 Running Pre-Deployment Verification Suite
================================================
🎯 Target Environment: PREVIEW
📦 Context: CI/CD Pipeline
📋 Preview Mode: Vercel-optimized validation

🔍 Running TypeScript Compilation...
✅ TypeScript Compilation completed (1,245ms)

🔍 Running Vercel Configuration...
✅ Vercel Configuration completed (156ms)

📊 PREVIEW DEPLOYMENT STATUS: ✅ READY
```

## Success Criteria

The command successfully prevents deployment issues by:

1. **Catching the exact errors** that caused recent Vercel deployment failures
2. **Providing actionable feedback** for quick resolution
3. **Integrating seamlessly** with existing HIL workflow
4. **Blocking problematic deployments** automatically
5. **Reducing debugging time** by catching issues locally

---

_Part of HIL Workflow Phase 3.5 - Preventing deployment issues through comprehensive pre-deployment verification_
