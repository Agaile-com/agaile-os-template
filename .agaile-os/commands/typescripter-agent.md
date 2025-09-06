# TypeScripter - Agent-Orchestrated TypeScript & Linter Error Resolution

## Description
Advanced TypeScript compilation and ESLint error analysis with intelligent agent-based multi-phase resolution. Leverages specialized agents for comprehensive error resolution through confidence-based automation and HIL oversight.

## Usage
```
/typescripter [options]
```

## Options

### HIL (Human-in-the-Loop) Controls
- `--analyze-only` - **DEFAULT MODE**: Analysis and strategy recommendation without execution
- `--approve-strategy` - Interactive agent strategy approval mode (analyze + approve + execute)
- `--auto-execute` - Enable autonomous agent execution (requires confidence threshold)
- `--agent-coordination` - Enable multi-agent coordination for complex issues
- `--confidence-threshold <number>` - Minimum confidence for agent auto-execution (1-100, default: 85)
- `--hil-mode [strict|standard|minimal]` - Set HIL strictness level (default: standard)

### Agent Control Options
- `--primary-agent [fixer|db-migrate|quality|ci-cd]` - Override primary agent selection
- `--disable-coordination` - Use single agent instead of coordinated approach
- `--agent-timeout <minutes>` - Maximum execution time per agent (default: 10)
- `--checkpoint-frequency [step|phase|end]` - Frequency of user checkpoints (default: phase)

### Analysis Options  
- `--detailed` - Include file paths, line numbers, and agent recommendations
- `--pattern-matching` - Show confidence scoring for error pattern recognition
- `--strategy-preview` - Preview agent execution strategies without running
- `--export-analysis` - Export error analysis to JSON for agent processing

@include shared/hil-patterns.yml#HIL_Framework
@include agents/config.yml#Agent_Framework

## Agent-Based Implementation

### Multi-Agent Orchestration System

The typescripter now operates through a sophisticated agent coordination system that provides specialized expertise for different error categories while maintaining human oversight at critical decision points.

#### **Phase 1: Intelligent Error Analysis**
```typescript
interface ErrorAnalysisResult {
  errorCategories: {
    databaseRelated: DatabaseError[]     // → db-migrate-agent
    buildConfiguration: BuildError[]     // → fixer-agent  
    codeQuality: QualityError[]         // → quality-agent
    deploymentBlocking: DeploymentError[] // → ci-cd-agent
  }
  
  agentRecommendations: {
    primaryAgent: AgentType
    coordinationPattern: CoordinationPattern
    confidenceScores: AgentConfidenceScore[]
    executionSequence: AgentExecutionPlan
  }
  
  hilAssessment: {
    overallRisk: RiskLevel
    approvalRequired: ApprovalLevel
    checkpointStrategy: CheckpointStrategy
  }
}
```

#### **Phase 2: Agent Strategy Selection**
Based on error pattern analysis, the system selects optimal agents and coordination patterns:

**Single-Agent Scenarios** (95%+ confidence, low risk):
- Pure build/cache issues → `fixer-agent`
- Database schema drift → `db-migrate-agent`
- Linting cleanup → `quality-agent`

**Multi-Agent Scenarios** (complex interdependent issues):
- Database + TypeScript errors → `db-migrate-agent` → `fixer-agent`
- Build + Quality + Deployment → `fixer-agent` → `quality-agent` → `ci-cd-agent`
- Full development cycle → All agents in coordinated sequence

#### **Phase 3: Agent Execution with HIL Oversight**

**High-Confidence Execution** (85-100% confidence):
```bash
/typescripter --auto-execute --confidence-threshold 90
```
- Agents execute automatically with progress notifications
- User receives real-time status updates
- Checkpoint approvals only at phase boundaries
- Emergency abort available at any time

**Interactive Approval Mode**:
```bash
/typescripter --approve-strategy
```
- Present detailed agent execution plan
- User approves each agent phase individually
- Real-time feedback and modification options
- Rollback capabilities at each checkpoint

**Analysis-Only Mode** (Default):
```bash
/typescripter
```
- Comprehensive error analysis with agent recommendations
- Strategy confidence scoring and risk assessment
- Detailed execution plan preview
- No execution without explicit approval

### Agent Integration Examples

#### **Database Schema Synchronization** (db-migrate-agent)
```typescript
interface DatabaseSchemaIssues {
  detectedPatterns: [
    {
      pattern: /Property.*does not exist.*Prisma/,
      confidence: 92,
      agent: "db-migrate-agent",
      strategy: "schema_sync_and_type_generation"
    }
  ]
  
  agentExecution: {
    agent: "db-migrate-agent",
    taskPrompt: `
      Detected Prisma schema synchronization issues with 92% confidence.
      
      Error patterns indicate database schema drift causing TypeScript compilation failures.
      
      Execute comprehensive schema synchronization:
      1. Validate current schema state against database
      2. Generate updated Prisma types
      3. Verify type definitions match database structure
      4. Run validation tests to confirm synchronization
      
      Use Supabase MCP tools for database operations.
      Provide detailed progress updates and validation results.
    `,
    expectedOutcome: "TypeScript compilation errors resolved through schema sync",
    checkpoints: ["schema_validation", "type_generation", "compilation_test"],
    rollbackPlan: "Restore previous schema state if validation fails"
  }
}
```

#### **Build Configuration Resolution** (fixer-agent)
```typescript
interface BuildConfigurationIssues {
  detectedPatterns: [
    {
      pattern: /Cannot find module.*vendor-chunks/,
      confidence: 89,
      agent: "fixer-agent", 
      strategy: "cache_and_dependency_resolution"
    }
  ]
  
  agentExecution: {
    agent: "fixer-agent",
    taskPrompt: `
      Detected module resolution errors with 89% confidence.
      
      Error patterns indicate stale cache and dependency issues causing build failures.
      
      Execute systematic build environment repair:
      1. Clear all caches (.next, node_modules/.cache, pnpm cache)
      2. Reinstall dependencies with frozen lockfile
      3. Verify module resolution paths
      4. Rebuild project with clean environment
      5. Validate successful compilation
      
      Apply progressive fix strategy with verification at each step.
      Provide detailed error resolution report.
    `,
    expectedOutcome: "Module resolution errors cleared, build compilation successful",
    checkpoints: ["cache_cleared", "dependencies_installed", "build_successful"],
    rollbackPlan: "Restore previous cache state if build fails"
  }
}
```

#### **Multi-Agent Coordination Example**
```typescript
interface CoordinatedResolution {
  coordinationPattern: "typescript_resolution",
  
  executionSequence: [
    {
      phase: 1,
      agent: "db-migrate-agent",
      task: "schema_synchronization",
      confidence: 92,
      dependencies: [],
      checkpointApproval: "NOTIFY"
    },
    {
      phase: 2, 
      agent: "fixer-agent",
      task: "build_configuration_fixes",
      confidence: 87,
      dependencies: ["schema_synchronization"],
      checkpointApproval: "CONFIRM"
    },
    {
      phase: 3,
      agent: "quality-agent", 
      task: "code_quality_validation",
      confidence: 64,
      dependencies: ["build_configuration_fixes"],
      checkpointApproval: "APPROVE"
    },
    {
      phase: 4,
      agent: "ci-cd-agent",
      task: "deployment_validation", 
      confidence: 100,
      dependencies: ["code_quality_validation"],
      checkpointApproval: "NOTIFY"
    }
  ]
}
```

### Output Format Enhancement

#### **Agent-Orchestrated Analysis Report**
```
🤖 TypeScript Agent-Orchestrated Analysis Report
================================================

📊 ERROR ANALYSIS SUMMARY
┌─────────────┬───────┬─────────────────┬──────────────┬─────────────────┐
│ Category    │ Count │ Primary Agent   │ Confidence   │ Coordination    │
├─────────────┼───────┼─────────────────┼──────────────┼─────────────────┤
│ 🗄️ Database │   12  │ db-migrate      │ 92% (HIGH)   │ Phase 1         │
│ 🔧 Build     │   28  │ fixer           │ 87% (HIGH)   │ Phase 2         │
│ 🎯 Quality   │   15  │ quality         │ 64% (MED)    │ Phase 3         │
│ 🚀 Deploy    │    1  │ ci-cd           │ 100% (MAX)   │ Phase 4         │
└─────────────┴───────┴─────────────────┴──────────────┴─────────────────┘

🤖 AGENT COORDINATION STRATEGY
Coordination Pattern: typescript_resolution
Execution Mode: Sequential with dependencies
Total Estimated Time: 18-25 minutes
Risk Assessment: MEDIUM (67/100)

📋 EXECUTION PLAN PREVIEW
┌─────────────────────────────────────┬────────────────┬─────────────┬──────────────────┐
│ Agent & Phase                       │ Confidence     │ Approval    │ Est. Duration    │
├─────────────────────────────────────┼────────────────┼─────────────┼──────────────────┤
│ 🗄️ db-migrate-agent: Schema Sync    │ 92% (Execute)  │ ⚡ NOTIFY   │ 3-5 min         │
│ 🔧 fixer-agent: Build Fixes         │ 87% (Execute)  │ ⚡ CONFIRM  │ 5-10 min        │
│ 🎯 quality-agent: Code Quality      │ 64% (Manual)   │ ⚠️ APPROVE  │ 8-12 min        │ 
│ 🚀 ci-cd-agent: Deploy Validation   │ 100% (Execute) │ ⚡ NOTIFY   │ 3-7 min         │
└─────────────────────────────────────┴────────────────┴─────────────┴──────────────────┘

🎯 HIL DECISION POINTS

**High-Confidence Phases** (Auto-Execute Eligible):
✅ Database schema synchronization (92% confidence)
✅ Build configuration fixes (87% confidence)  
✅ Deployment validation (100% confidence)

**Manual Review Required**:
⚠️ Code quality validation (64% confidence - below 85% threshold)
   └─ Recommendation: Review ESLint errors manually or lower confidence threshold

🚀 EXECUTION OPTIONS

1️⃣ **Recommended: Approve High-Confidence Agents**
   Command: `/typescripter --approve-strategy --confidence-threshold 85`
   └─ Executes phases 1, 2, 4 automatically
   └─ Requests approval for phase 3 (quality validation)
   └─ Estimated total time: 11-22 minutes

2️⃣ **Full Manual Control**
   Command: `/typescripter --approve-strategy --hil-mode strict`
   └─ User approval required for each agent phase
   └─ Maximum oversight and control
   └─ Estimated total time: 25-35 minutes (including approval time)

3️⃣ **High-Confidence Auto Mode**
   Command: `/typescripter --auto-execute --confidence-threshold 90`
   └─ Only executes database and deployment (90%+ confidence)
   └─ Skips build fixes (87%) and quality validation (64%)
   └─ Fastest execution but may miss important fixes

4️⃣ **Preview Only** (Current Mode)
   Command: `/typescripter --strategy-preview`
   └─ Shows detailed execution plan for each agent
   └─ No execution - planning and review only

💡 NEXT STEPS
Choose execution mode based on your confidence level and time constraints.
All agents include checkpoint validation and rollback capabilities.
Emergency abort available during execution via Ctrl+C.
```

### Implementation Commands

The updated typescripter leverages the Task tool's agent system through intelligent delegation:

```typescript
// Agent delegation implementation
async function executeTypescripterWithAgents(options: TypescripterOptions) {
  // Phase 1: Error Analysis
  const errorAnalysis = await analyzeTypeScriptErrors();
  const agentStrategy = selectOptimalAgentStrategy(errorAnalysis);
  
  // Phase 2: HIL Assessment  
  const hilAssessment = assessRiskAndApproval(agentStrategy);
  if (hilAssessment.requiresApproval) {
    const userApproval = await requestUserApproval(agentStrategy, hilAssessment);
    if (!userApproval.approved) return;
  }
  
  // Phase 3: Agent Execution
  for (const agentPhase of agentStrategy.executionSequence) {
    if (agentPhase.confidence >= options.confidenceThreshold) {
      
      // Delegate to specialized agent via Task tool
      const agentResult = await executeAgent({
        agent: agentPhase.agent,
        task: agentPhase.taskPrompt,
        checkpoints: agentPhase.checkpoints,
        timeout: options.agentTimeout
      });
      
      // Validate results and proceed
      if (agentResult.success) {
        await validatePhaseCompletion(agentPhase);
      } else {
        await handleAgentFailure(agentPhase, agentResult);
      }
    }
  }
  
  // Phase 4: Final Validation
  return await validateOverallSuccess();
}

// Agent execution via Task tool
async function executeAgent(agentConfig: AgentExecutionConfig) {
  return await Task({
    subagent_type: mapToAvailableAgent(agentConfig.agent),
    description: agentConfig.task.split('\n')[0], // First line as description
    prompt: agentConfig.task
  });
}

// Map custom agents to available Task tool agents
function mapToAvailableAgent(customAgent: string): string {
  const agentMapping = {
    'fixer-agent': 'general-purpose',
    'db-migrate-agent': 'general-purpose', 
    'quality-agent': 'test-runner',
    'ci-cd-agent': 'git-workflow',
    'docs-agent': 'file-creator'
  };
  
  return agentMapping[customAgent] || 'general-purpose';
}
```

### Benefits of Agent-Orchestrated Approach

1. **Specialized Expertise**: Each agent focuses on its domain with deep pattern knowledge
2. **Parallel Capability**: Multiple agents can work on independent issues simultaneously  
3. **Intelligent Coordination**: Agents coordinate based on dependencies and success criteria
4. **Confidence-Based Automation**: High-confidence operations execute automatically
5. **HIL Oversight**: Human control at appropriate decision points based on risk assessment
6. **Learning Integration**: Agents improve performance based on success patterns
7. **Comprehensive Coverage**: No error category falls through cracks due to specialized agents

This revolutionary approach transforms TypeScript error resolution from a reactive, manual process into a proactive, intelligent system that learns from your codebase patterns and consistently delivers production-ready results.

## Migration from Legacy TypeScripter

To transition from the old command-based approach:

1. **Existing Command**: `/typescripter --detailed --fix-suggestions`
2. **New Agent Command**: `/typescripter --approve-strategy --detailed --pattern-matching`

The agent-based version provides all previous functionality plus:
- Multi-phase coordination
- Confidence-based automation  
- Specialized agent expertise
- Learning and adaptation capabilities
- Enhanced HIL integration