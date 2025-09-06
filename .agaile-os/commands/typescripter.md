# TypeScripter - Advanced TypeScript & Linter Error Analysis

## Description
Comprehensive analysis of TypeScript compilation errors and ESLint issues with intelligent categorization, severity assessment, and actionable reporting.

## Usage
```
/typescripter [options]
```

## Options

### HIL (Human-in-the-Loop) Controls
- `--analyze-only` - **DEFAULT MODE**: Only analyze errors without executing fixes
- `--auto-execute` - Enable autonomous strategy execution (overrides analyze-only default)
- `--approve-strategy` - Interactive strategy approval mode (analyze + approve + execute)
- `--plan` - Show detailed execution plan without execution
- `--hil-mode [strict|standard|minimal]` - Set HIL strictness level (default: standard)
- `--confidence-threshold <number>` - Minimum confidence for auto-execution (1-100, default: 85)

### Analysis Options  
- `--detailed` - Include file paths and line numbers in output
- `--fix-suggestions` - Include automated fix suggestions where possible
- `--exclude-warnings` - Focus only on errors, exclude warnings
- `--by-file` - Group results by file instead of by error type
- `--export-json` - Export results to JSON for external processing

@include shared/hil-patterns.yml#HIL_Framework

## Implementation

### HIL Integration

**Risk Assessment**: Database operations (HIGH), Build fixes (MEDIUM), Linting (LOW)
**Default Approval**: CONFIRM for all strategies exceeding confidence threshold
**Environment Multiplier**: Production operations require APPROVE level
**Emergency Override**: Available via `--emergency-override` with incident tracking

### Core Analysis Process

1. **TypeScript Compilation Check**
   - Run `npx tsc --noEmit` to get type checking errors
   - Parse and categorize TypeScript errors by type and severity
   
2. **ESLint Analysis**  
   - Run `npx eslint . --format json` to get linting issues
   - Categorize by rule type and severity level

3. **Error Classification**
   - **Critical**: Compilation blockers, type safety violations
   - **High**: Logic errors, unused imports, missing types
   - **Medium**: Style inconsistencies, deprecated usage
   - **Low**: Formatting, minor code quality issues

4. **Intelligent Grouping**
   - Group similar errors (same error code/rule)
   - Identify patterns across files
   - Detect cascading errors from common root causes

5. **Actionable Reporting**
   - Summary table with counts and percentages
   - Top error types with fix suggestions
   - Files needing immediate attention
   - Estimated fix effort and priority

6. **HIL-Controlled Resolution Execution**
   - **Default**: Analysis-only mode with strategy recommendations
   - **Approval Required**: User must approve execution strategies via `--approve-strategy`
   - **Confidence-Based**: Only high-confidence strategies (≥85%) eligible for auto-execution
   - **Multi-phase Resolution**: Specialized commands with checkpoint approvals
   - **Real-time Progress**: User can abort/modify during execution

### Output Format

```
🔍 TypeScript & Linter Analysis Report
======================================

📊 SUMMARY
┌─────────────┬───────┬────────────┬─────────────┐
│ Severity    │ Count │ Percentage │ Avg/File    │
├─────────────┼───────┼────────────┼─────────────┤
│ 🔴 Critical │   15  │    25.4%   │     0.8     │
│ 🟠 High     │   28  │    47.5%   │     1.5     │
│ 🟡 Medium   │   12  │    20.3%   │     0.6     │
│ 🟢 Low      │    4  │     6.8%   │     0.2     │
├─────────────┼───────┼────────────┼─────────────┤
│ 📊 TOTAL    │   59  │   100.0%   │     3.1     │
└─────────────┴───────┴────────────┴─────────────┘

🎯 TOP ERROR TYPES
┌──────────────────────────────────────┬───────┬─────────┬──────────────┐
│ Error Type                           │ Count │ Severity│ Fix Priority │
├──────────────────────────────────────┼───────┼─────────┼──────────────┤
│ TS2339: Property does not exist      │   12  │ 🔴 Crit │     HIGH     │
│ TS2345: Argument type mismatch       │    8  │ 🔴 Crit │     HIGH     │
│ @typescript-eslint/no-unused-vars    │    6  │ 🟡 Med  │   MEDIUM     │
│ TS2322: Type not assignable          │    5  │ 🟠 High │     HIGH     │
└──────────────────────────────────────┴───────┴─────────┴──────────────┘

🏥 FILES NEEDING ATTENTION
┌─────────────────────────────────────┬───────┬─────────────────────────┐
│ File                                │ Issues│ Dominant Issue Type     │
├─────────────────────────────────────┼───────┼─────────────────────────┤
│ src/api/invoices/[id]/pdf/route.ts  │   8   │ Missing Prisma types    │
│ src/lib/services/retry-queue.ts     │   5   │ Type safety violations  │
│ src/components/billing/*            │   4   │ Props type mismatches   │
└─────────────────────────────────────┴───────┴─────────────────────────┘

💡 HIL STRATEGY RECOMMENDATION
🎯 Analysis complete - strategies recommended based on error patterns and confidence scoring

⚠️  **APPROVAL REQUIRED** - Strategy execution requires user confirmation

🤖 RECOMMENDED STRATEGIES
┌─────────────────────────────────────┬────────────┬─────────────┬──────────────┐
│ Strategy                            │ Confidence │ Matched Errs│ Est. Time    │
├─────────────────────────────────────┼────────────┼─────────────┼──────────────┤
│ Database Schema Synchronization     │    92%     │     12      │   3-5 min    │
│ Build & Configuration Fixes         │    87%     │     29      │   5-10 min   │
│ Code Quality & Linting              │    64%     │     47      │   2-5 min    │
│ Pipeline & Deployment Validation    │    100%    │     Auto    │   3-7 min    │
└─────────────────────────────────────┴────────────┴─────────────┴──────────────┘

🛡️  HIL APPROVAL WORKFLOW

**Risk Assessment:**
┌─────────────────────────────────────┬─────────────┬───────────────┬─────────────────┐
│ Strategy                            │ Risk Level  │ Approval Req. │ Confidence      │
├─────────────────────────────────────┼─────────────┼───────────────┼─────────────────┤
│ Database Schema Synchronization     │ HIGH (78)   │ ⚠️  APPROVE   │ 92% (Execute)   │
│ Build & Configuration Fixes         │ MEDIUM (45) │ ⚡ CONFIRM    │ 87% (Execute)   │
│ Code Quality & Linting              │ LOW (25)    │ ℹ️  NOTIFY    │ 64% (Manual)    │
│ Pipeline & Deployment Validation    │ HIGH (82)   │ ⚠️  APPROVE   │ 100% (Execute)  │
└─────────────────────────────────────┴─────────────┴───────────────┴─────────────────┘

**Execution Options:**

1️⃣  **Approve All High-Confidence Strategies** (Recommended)
   └─ Command: `/typescripter --approve-strategy`
   └─ Will execute: Database sync, Build fixes, Pipeline validation
   └─ Skip: Code quality (low confidence - requires manual review)

2️⃣  **Review Strategy Details**
   └─ Command: `/typescripter --plan`
   └─ Shows detailed execution plan for each strategy

3️⃣  **Execute Specific Strategy**
   └─ Command: `/typescripter --approve-strategy --strategy database`
   └─ Execute only selected strategy with approval

4️⃣  **Emergency Override** (High-Risk)
   └─ Command: `/typescripter --auto-execute --emergency-override`
   └─ Requires incident reference and post-execution review

**Next Steps:**
• Use `--approve-strategy` to begin interactive approval process
• Review individual strategy details with `--plan`
• For production environments, consider `--hil-mode strict`
```

### Implementation Code

```typescript
interface ErrorAnalysis {
  severity: 'critical' | 'high' | 'medium' | 'low';
  count: number;
  percentage: number;
  avgPerFile: number;
  examples: string[];
  fixSuggestions: string[];
  estimatedEffort: number; // in minutes
}

interface FileIssue {
  path: string;
  issues: number;
  dominantType: string;
  severity: string;
}

class TypeScripterAnalyzer {
  async analyze(options: AnalysisOptions): Promise<AnalysisReport> {
    // Run TypeScript compilation
    const tscResults = await this.runTypeScript();
    
    // Run ESLint analysis
    const eslintResults = await this.runESLint();
    
    // Categorize and analyze
    const categorized = this.categorizeErrors(tscResults, eslintResults);
    
    // Generate insights
    const insights = this.generateInsights(categorized);
    
    // Create actionable report
    return this.generateReport(categorized, insights, options);
  }
  
  private categorizeErrors(tsc: any[], eslint: any[]): CategorizedErrors {
    // Intelligent error categorization logic
  }
  
  private generateInsights(errors: CategorizedErrors): Insights {
    // Pattern detection and fix suggestion logic
  }
}
```

### Error Severity Matrix

| Error Code/Rule | Severity | Reasoning | Auto-fixable |
|-----------------|----------|-----------|--------------|
| TS2339 | Critical | Runtime crashes likely | ❌ |
| TS2345 | Critical | Type safety violation | ❌ |  
| TS2322 | High | Logic errors possible | ❌ |
| unused-vars | Medium | Code quality issue | ✅ |
| no-console | Low | Development artifact | ✅ |

### Integration Points

- **CI/CD**: Export JSON for build pipeline integration
- **IDE**: Generate `.vscode/settings.json` with error suppression
- **Git Hooks**: Pre-commit error threshold checking
- **Monitoring**: Track error trends over time

### Intelligent Subagent Orchestration Engine

#### **Multi-Phase Resolution Strategy**

The typescripter now automatically executes a proven 4-phase resolution strategy using specialized subagents:

```typescript
interface ResolutionPhase {
  name: string;
  subagent: string;
  command: string;
  targetErrors: string[];
  estimatedTime: string;
  successMetrics: string[];
}

// Adaptive Resolution Strategy - dynamically selected based on error patterns
const AVAILABLE_RESOLUTION_STRATEGIES: ResolutionStrategy[] = [
  {
    name: "Database Schema Synchronization",
    subagent: "db-migrate",
    commands: ["--generate-only", "--status", "--sync"],
    triggers: [
      { pattern: /TS2339.*Property.*does not exist/, weight: 0.9 },
      { pattern: /Missing.*database.*properties/, weight: 0.8 },
      { pattern: /Prisma.*Client.*generation/, weight: 0.7 },
      { pattern: /Cannot find name.*Prisma/, weight: 0.6 }
    ],
    estimatedTime: "3-5 minutes",
    successMetrics: ["schema_sync", "type_generation", "db_connectivity"]
  },
  {
    name: "Build & Configuration Fixes",
    subagent: "fixer", 
    commands: ["--type build --deep", "--type config", "--quick"],
    triggers: [
      { pattern: /TS2345.*Argument.*not assignable/, weight: 0.9 },
      { pattern: /TS2322.*Type.*not assignable/, weight: 0.8 },
      { pattern: /Configuration.*error/, weight: 0.7 },
      { pattern: /Module resolution.*error/, weight: 0.6 },
      { pattern: /Cannot find module/, weight: 0.5 }
    ],
    estimatedTime: "5-10 minutes",
    successMetrics: ["build_success", "type_safety", "config_validation"]
  },
  {
    name: "Code Quality & Linting",
    subagent: "eslint-fixer",
    commands: ["eslint . --fix", "remove problematic files", "code cleanup"],
    triggers: [
      { pattern: /no-unused-vars/, weight: 0.7 },
      { pattern: /no-console/, weight: 0.6 },
      { pattern: /sonarjs.*duplicate-string/, weight: 0.5 },
      { pattern: /max-nested-callbacks/, weight: 0.4 }
    ],
    estimatedTime: "2-5 minutes",
    successMetrics: ["lint_reduction", "code_quality", "style_consistency"]
  },
  {
    name: "Dependency & Package Management",
    subagent: "fixer",
    commands: ["--type deps --deps-refresh", "--cache-clear"],
    triggers: [
      { pattern: /Cannot resolve dependency/, weight: 0.8 },
      { pattern: /Module.*not found/, weight: 0.7 },
      { pattern: /npm.*audit.*vulnerabilities/, weight: 0.6 },
      { pattern: /pnpm.*lockfile.*issues/, weight: 0.5 }
    ],
    estimatedTime: "3-8 minutes", 
    successMetrics: ["dependency_resolution", "package_integrity", "security_check"]
  },
  {
    name: "Environment & Configuration",
    subagent: "fixer",
    commands: ["--type config --verify", "env validation"],
    triggers: [
      { pattern: /Environment.*variable.*missing/, weight: 0.9 },
      { pattern: /Configuration.*invalid/, weight: 0.8 },
      { pattern: /Connection.*failed/, weight: 0.7 }
    ],
    estimatedTime: "2-4 minutes",
    successMetrics: ["env_validation", "service_connectivity", "config_integrity"]
  },
  {
    name: "Pipeline & Deployment Validation", 
    subagent: "ci-cd",
    commands: ["--run local --scope affected", "--health"],
    triggers: [
      { pattern: /always_run_if_other_phases_executed/, weight: 1.0 }
    ],
    estimatedTime: "3-7 minutes",
    successMetrics: ["build_pipeline", "deployment_readiness", "system_health"]
  }
];
```

#### **Execution Logic**

```typescript
interface ErrorPattern {
  pattern: RegExp;
  weight: number;
}

interface ResolutionStrategy {
  name: string;
  subagent: string;
  commands: string[];
  triggers: ErrorPattern[];
  estimatedTime: string;
  successMetrics: string[];
}

interface StrategyScore {
  strategy: ResolutionStrategy;
  score: number;
  matchedErrors: string[];
  confidence: number;
}

class AdaptiveOrchestrator {
  async executeResolution(analysisReport: AnalysisReport): Promise<ResolutionResult> {
    // Dynamically select strategies based on error analysis
    const selectedStrategies = this.selectOptimalStrategies(analysisReport);
    const executionPlan = this.createExecutionPlan(selectedStrategies);
    
    console.log(`🎯 Adaptive Resolution Plan: ${executionPlan.length} phases selected`);
    
    const results: PhaseResult[] = [];
    
    for (const strategy of executionPlan) {
      console.log(`🤖 Executing: ${strategy.name} (Confidence: ${strategy.confidence}%)`);
      
      const result = await this.executeStrategy(strategy);
      results.push(result);
      
      // Adaptive failure handling
      if (!result.success) {
        const recovery = await this.attemptRecovery(strategy, result);
        if (!recovery.success) {
          return this.escalateWithContext(strategy, result, recovery);
        }
      }
      
      // Re-analyze after each phase for dynamic adjustment
      const updatedReport = await this.reAnalyzeErrors();
      if (this.shouldAdjustStrategy(updatedReport, strategy)) {
        const adjustedStrategies = this.adjustRemainingStrategies(
          executionPlan, 
          updatedReport
        );
        executionPlan.splice(executionPlan.indexOf(strategy) + 1, 0, ...adjustedStrategies);
      }
    }
    
    return this.generateAdaptiveReport(results);
  }
  
  private selectOptimalStrategies(report: AnalysisReport): StrategyScore[] {
    const strategies: StrategyScore[] = [];
    
    for (const strategy of AVAILABLE_RESOLUTION_STRATEGIES) {
      const score = this.calculateStrategyScore(strategy, report);
      
      if (score.score > 0.3) { // Minimum relevance threshold
        strategies.push(score);
      }
    }
    
    // Sort by score (highest first) and filter overlapping strategies
    return strategies
      .sort((a, b) => b.score - a.score)
      .filter((strategy, index, array) => 
        !this.hasStrategyOverlap(strategy, array.slice(0, index))
      );
  }
  
  private calculateStrategyScore(
    strategy: ResolutionStrategy, 
    report: AnalysisReport
  ): StrategyScore {
    let totalScore = 0;
    const matchedErrors: string[] = [];
    
    // Analyze TypeScript errors
    for (const error of report.typescriptErrors) {
      for (const trigger of strategy.triggers) {
        if (trigger.pattern.test(error.message)) {
          totalScore += trigger.weight * error.severity;
          matchedErrors.push(error.message);
        }
      }
    }
    
    // Analyze ESLint errors  
    for (const error of report.eslintErrors) {
      for (const trigger of strategy.triggers) {
        if (trigger.pattern.test(error.ruleId + ": " + error.message)) {
          totalScore += trigger.weight * this.getSeverityWeight(error.severity);
          matchedErrors.push(`${error.ruleId}: ${error.message}`);
        }
      }
    }
    
    // Special case: Always include validation if other strategies selected
    if (strategy.name.includes("Validation") && matchedErrors.length === 0) {
      totalScore = 0.5; // Moderate score for validation
    }
    
    const confidence = Math.min(Math.round(totalScore * 100), 100);
    
    return {
      strategy,
      score: totalScore,
      matchedErrors,
      confidence
    };
  }
  
  private createExecutionPlan(strategies: StrategyScore[]): StrategyScore[] {
    // Order strategies by optimal execution sequence
    const orderedStrategies = [...strategies];
    
    // Database/schema changes should come first
    const dbIndex = orderedStrategies.findIndex(s => s.strategy.name.includes("Database"));
    if (dbIndex > 0) {
      const dbStrategy = orderedStrategies.splice(dbIndex, 1)[0];
      orderedStrategies.unshift(dbStrategy);
    }
    
    // Validation should come last (if not already)
    const validationIndex = orderedStrategies.findIndex(s => 
      s.strategy.name.includes("Validation")
    );
    if (validationIndex >= 0 && validationIndex < orderedStrategies.length - 1) {
      const validationStrategy = orderedStrategies.splice(validationIndex, 1)[0];
      orderedStrategies.push(validationStrategy);
    }
    
    return orderedStrategies;
  }
  
  private async reAnalyzeErrors(): Promise<AnalysisReport> {
    // Quick re-analysis to check current state
    const tscErrors = await this.runTypeScriptCheck();
    const eslintErrors = await this.runESLintCheck();
    return this.categorizeErrors(tscErrors, eslintErrors);
  }
  
  private shouldAdjustStrategy(
    updatedReport: AnalysisReport, 
    executedStrategy: StrategyScore
  ): boolean {
    // Check if new error patterns emerged that require different strategies
    const newPatterns = this.detectNewErrorPatterns(updatedReport);
    return newPatterns.length > 0;
  }
}
```

#### **Success Metrics & Validation**

Each phase includes automatic validation:

- **Phase 1**: Verify database schema sync, type generation success
- **Phase 2**: Confirm build compilation, validate type fixes
- **Phase 3**: Check ESLint error reduction, file cleanup success  
- **Phase 4**: Validate full CI pipeline, production readiness

#### **Failure Handling & Recovery**

```typescript
interface FailureRecovery {
  phase: string;
  commonFailures: FailurePattern[];
  recoveryActions: string[];
  escalationCriteria: string[];
}

const RECOVERY_STRATEGIES = {
  "Database Schema Sync": {
    commonFailures: ["Connection timeout", "Schema conflicts"],
    recoveryActions: ["Retry with fresh connection", "Manual schema review"],
    escalationCriteria: ["Multiple connection failures", "Schema corruption"]
  }
  // ... additional recovery strategies
};
```

### Advanced Features

- **Smart Batching**: Group related errors for efficient fixing
- **Impact Analysis**: Predict which fixes will resolve multiple errors
- **Regression Detection**: Compare with previous runs
- **Team Metrics**: Track error introduction/resolution by contributor
- **Auto-fix Pipeline**: Safe automated corrections where possible
- **Intelligent Orchestration**: Automated multi-phase resolution using specialized subagents
- **Real-time Validation**: Continuous success verification throughout execution
- **Recovery Strategies**: Intelligent failure handling and escalation procedures

### Command Execution Modes

#### **Default Mode** (Analysis with Strategy Recommendations)
```bash
/typescripter
```
- **Analyzes error patterns** using regex matching and confidence scoring
- **Recommends optimal strategies** with confidence scores and risk assessments
- **Shows execution plan** with estimated time and impact analysis
- **Provides approval guidance** based on confidence thresholds
- **Does NOT execute** unless explicitly approved via `--approve-strategy` or `--auto-execute`
- **Safe by default** - prioritizes transparency over automation

#### **Interactive Approval Mode**
```bash
/typescripter --approve-strategy
```
- **Comprehensive error analysis** with confidence scoring
- **Strategy recommendations** with risk assessment and execution plans
- **Interactive approval** for each proposed strategy
- **Phase-by-phase execution** with user checkpoints
- **Abort/modify options** during execution
- **Rollback assistance** if strategies fail

#### **Autonomous Execution Mode** (Override)
```bash
/typescripter --auto-execute --confidence-threshold 90
```
- **High-confidence only** - executes strategies above specified threshold
- **Automatic orchestration** of approved strategies
- **Real-time monitoring** with user notification
- **Emergency abort** options during execution
- **Requires explicit override** of analyze-only default

#### **Custom Strategy Mode**
```bash
/typescripter --strategies="database,build,validation"
```
- **Forces specific strategies** overriding automatic selection
- **Useful for targeted fixes** when you know the root cause
- **Still provides adaptive** execution within selected strategies

#### **Dry Run Mode** 
```bash
/typescripter --dry-run
```
- **Simulates execution** without making actual changes
- **Shows execution plan** with estimated time and impact
- **Validates strategy selection** logic
- **Perfect for CI/CD integration** and planning

### Adaptive Intelligence Features

#### **Pattern-Based Strategy Selection**
- **6 available strategies** covering database, build, linting, dependencies, environment, and validation
- **Regex pattern matching** against error messages for precise targeting
- **Weighted scoring system** prioritizing high-impact fixes
- **Confidence thresholds** preventing low-relevance strategy execution

#### **Dynamic Plan Adjustment**
- **Real-time re-analysis** after each phase execution
- **Strategy injection** when new error patterns emerge
- **Plan optimization** based on intermediate results
- **Failure recovery** with alternative strategy paths

#### **Universal Adaptability**
- **Project-agnostic** - works with any TypeScript/JavaScript codebase
- **Framework-independent** - Next.js, React, Node.js, etc.
- **Database-agnostic** - Prisma, TypeORM, raw SQL, etc.
- **Tool-agnostic** - ESLint, TSLint, Biome, etc.

#### **Learning & Optimization**
- **Success pattern recognition** for strategy improvement
- **Execution time optimization** based on historical data
- **Error correlation analysis** for better strategy selection
- **Team-specific adaptations** based on codebase patterns

This revolutionary approach transforms TypeScript error resolution from a reactive, manual process into a proactive, intelligent system that learns from your codebase patterns and consistently delivers production-ready results across any development scenario.