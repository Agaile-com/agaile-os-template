# Documenter - AI-Optimized Documentation Consolidation

## Description
Intelligently consolidates information from chat conversations with existing project documentation to create AI-optimized knowledge bases that enhance future AI interactions and development workflows.

## Usage
```
/documenter [options]
```

## Options
- `--scope <area>` - Focus on specific area (billing, auth, i18n, deployment, etc.)
- `--format <type>` - Output format: structured-md, json, yaml (default: structured-md)  
- `--merge-existing` - Merge with existing docs instead of creating new files
- `--chat-context <topics>` - Specify which chat topics to extract (comma-separated)
- `--validate-accuracy` - Cross-reference information for consistency
- `--ai-optimized` - Use AI-friendly structured format with explicit relationships

## Usage Scenarios

### **Database Migration Documentation**
```bash
/documenter --scope database --chat-context "schema-changes,cascade-deletion"
```
**Use Case**: After resolving foreign key constraint issues
**Output**: Structured documentation of schema changes, migration steps, and testing procedures

### **API Integration Troubleshooting**
```bash
/documenter --scope api --format json --chat-context "v0-integration,error-handling"
```
**Use Case**: Following resolution of API reliability issues
**Output**: JSON-formatted documentation of dual-API strategy, fallback mechanisms, error recovery

### **Performance Optimization Records**
```bash
/documenter --scope performance --merge-existing --validate-accuracy
```
**Use Case**: After implementing caching layers and image optimization
**Output**: Updated performance docs with before/after metrics, optimization techniques

### **Security Implementation Guide**
```bash
/documenter --scope security --ai-optimized --chat-context "authentication,rbac"
```
**Use Case**: Following implementation of role-based access controls
**Output**: AI-optimized security patterns, authentication flows, permission structures

### **General Troubleshooting Session**
```bash
/documenter --chat-context "bug-fixes,performance,ui-issues" --format structured-md
```
**Use Case**: After mixed debugging session covering multiple issues
**Output**: Categorized documentation covering all topics discussed

### **Development Workflow Optimization**
```bash
/documenter --scope workflow --merge-existing --chat-context "ci-cd,testing,deployment"
```
**Use Case**: Following improvements to development processes
**Output**: Updated workflow documentation with new procedures and best practices

## Implementation

### Core Documentation Process

1. **Context Extraction**
   - Parse current chat conversation for actionable information
   - Extract technical decisions, implementations, fixes, and insights
   - Identify key patterns, workflows, and best practices discussed

2. **Existing Documentation Analysis**
   - Scan `/docs/manual/`, `/docs/ops/`, `/docs/workflows/` directories
   - Parse existing documentation structure and content
   - Identify gaps, outdated information, and consolidation opportunities

3. **Intelligent Consolidation**
   - Map chat insights to relevant documentation sections
   - Resolve conflicts between chat content and existing docs
   - Merge complementary information while avoiding duplication

4. **AI-Optimized Formatting**
   - Structure content for optimal AI parsing and retrieval
   - Use consistent metadata tags and semantic markers
   - Include explicit relationships between concepts
   - Add contextual tags for fast topic-based searches

### Documentation Categories

#### **Technical Implementation**
- **Code Architecture**: Component patterns, service layer designs, module organization
- **Database Changes**: Schema migrations, constraint updates, indexing strategies  
- **API Integrations**: Third-party service connections, authentication flows, error handling
- **Configuration Management**: Environment setup, feature flags, deployment configs
- **Performance Optimizations**: Caching implementations, query optimizations, bundle analysis

#### **Workflow & Process**
- **Development Workflows**: Git branching strategies, code review processes, release procedures
- **Testing Strategies**: Unit test patterns, E2E automation, performance testing approaches
- **CI/CD Pipelines**: Build configurations, deployment scripts, environment promotion
- **Monitoring & Alerting**: Error tracking setup, performance metrics, health check implementations
- **Code Quality**: Linting rules, TypeScript configurations, dependency management

#### **Troubleshooting & Solutions**
- **Production Issues**: Service outages, performance degradation, user-reported bugs
- **Development Blockers**: Build failures, dependency conflicts, environment setup issues
- **Integration Problems**: API failures, authentication issues, data synchronization errors
- **Performance Bottlenecks**: Slow queries, memory leaks, network latency issues
- **Security Vulnerabilities**: Authentication bypasses, data exposure, injection attacks

#### **Knowledge Base**
- **Architectural Decisions**: Technology choices, design pattern selections, trade-off analysis
- **Domain Expertise**: Business logic implementations, regulatory compliance, industry standards
- **Tool Mastery**: Framework best practices, library usage patterns, debugging techniques
- **Team Knowledge**: Institutional memory, historical context, decision rationale
- **External Dependencies**: Service limitations, API quirks, vendor-specific considerations

### AI-Optimized Structure Format

The documenter produces structured documentation across various technical domains. Here are examples showing different use cases:

#### **Example 1: Database Migration Documentation**
```markdown
---
doc_type: consolidated_knowledge
scope: [database, supabase, prisma, migration]
last_updated: 2025-09-04
source_contexts: [chat_2025_09_04, supabase_logs]
ai_tags: [cascade_deletion, user_relations, prisma_migration]
priority: high
complexity: high
---

# User Relations Cascade Deletion - Migration Implementation

## Context Summary
**Problem Identified**: Users could not be deleted due to foreign key constraints
**Root Cause**: Missing CASCADE options in database relationships  
**Resolution Applied**: Updated schema with CASCADE DELETE for user relations
**Verification**: Tested user deletion in development environment

## Technical Implementation

### Database Schema Changes
```sql
-- Updated foreign key constraints
ALTER TABLE "Client" DROP CONSTRAINT IF EXISTS "Client_createdBy_fkey";
ALTER TABLE "Client" ADD CONSTRAINT "Client_createdBy_fkey" 
  FOREIGN KEY ("createdBy") REFERENCES "User"("id") ON DELETE CASCADE;

ALTER TABLE "Project" DROP CONSTRAINT IF EXISTS "Project_assignedTo_fkey";
ALTER TABLE "Project" ADD CONSTRAINT "Project_assignedTo_fkey"
  FOREIGN KEY ("assignedTo") REFERENCES "User"("id") ON DELETE SET NULL;
```

### Migration Process
1. **Pre-flight Check**: Verify no active user sessions
2. **Apply Schema**: Update constraints in Supabase dashboard
3. **Pull Schema**: `pnpm db:pull` to sync Prisma
4. **Generate Types**: `pnpm db:generate` for TypeScript
5. **Test Deletion**: Verify cascade behavior works correctly

## Related Systems
- **Database**: Supabase PostgreSQL with custom constraints
- **ORM**: Prisma with schema synchronization
- **Testing**: User management API endpoints
```

#### **Example 2: API Integration Pattern**
```markdown
---
doc_type: consolidated_knowledge  
scope: [api, v0_integration, error_handling, retry_logic]
last_updated: 2025-09-04
source_contexts: [v0_troubleshooting_session]
ai_tags: [dual_api, fallback_strategy, rate_limiting]
priority: medium
complexity: medium
---

# V0 API Integration - Dual Strategy Implementation

## Context Summary
**Problem Identified**: Single V0 API endpoint causing reliability issues
**Root Cause**: Platform API rate limits and occasional downtime
**Resolution Applied**: Dual API strategy with automatic fallback
**Verification**: Tested with 50+ modernization requests

## Technical Implementation

### Dual API Strategy
```typescript
// Primary: Platform API (faster, rate-limited)
const primaryResult = await v0PlatformClient.createProject(prompt)

// Fallback: Chat API (slower, more reliable) 
if (!primaryResult.success) {
  const fallbackResult = await v0ChatClient.generateContent(prompt)
}
```

### Error Recovery Flow
1. **Primary Attempt**: Use Platform API with 30s timeout
2. **Rate Limit Detection**: Check for 429/503 response codes
3. **Automatic Fallback**: Switch to Chat API seamlessly
4. **Manual Recovery**: Provide copy-paste prompts for V0.dev
5. **Status Tracking**: Update project status throughout process
```

#### **Example 3: Performance Optimization**
```markdown
---
doc_type: consolidated_knowledge
scope: [performance, caching, nextjs, optimization]  
last_updated: 2025-09-04
source_contexts: [performance_audit_chat]
ai_tags: [core_web_vitals, image_optimization, caching_strategy]
priority: high
complexity: low
---

# Performance Optimization - Caching Strategy

## Context Summary
**Problem Identified**: Dashboard loading >3s, poor Core Web Vitals
**Root Cause**: No caching layer, large unoptimized images
**Resolution Applied**: Multi-layer caching + Next.js Image optimization
**Verification**: LCP improved from 3.2s to 0.8s

## Technical Implementation

### Caching Layers Added
```typescript
// Redis cache for API responses
export const projectCache = new Redis({
  url: process.env.REDIS_URL,
  maxRetriesPerRequest: 3
})

// Next.js API route caching
export async function GET() {
  return NextResponse.json(data, {
    headers: { 'Cache-Control': 's-maxage=300, stale-while-revalidate' }
  })
}
```

### Image Optimization
- Replaced `<img>` with `<Image>` components
- Added `priority` for above-fold images
- Implemented responsive sizing with `sizes` prop
```

### Output Formats

#### **Structured Markdown** (Default)
- AI-friendly frontmatter with metadata tags
- Hierarchical structure with explicit relationships
- Code blocks with syntax highlighting and context
- Cross-references and related system links

#### **JSON Format**
```json
{
  "documentation_entry": {
    "id": "database_migration_cascade_deletion",
    "scope": ["database", "supabase", "prisma", "migration"],
    "context": {
      "problem": "Foreign key constraint preventing user deletion",
      "solution": "Added CASCADE DELETE for user relations",
      "verification": "Tested deletion flow in development"
    },
    "technical_details": {
      "files_modified": ["prisma/schema.prisma", "supabase_migrations/"],
      "sql_changes": ["ALTER TABLE Client ADD CONSTRAINT CASCADE"],
      "test_scenarios": ["user_deletion", "data_integrity_check"]
    },
    "ai_hints": {
      "diagnostic_approach": ["check_foreign_keys", "test_cascade_behavior"],
      "related_systems": ["user_management", "client_relations", "project_assignments"],
      "future_maintenance": ["monitor_cascade_effects", "backup_before_schema_changes"]
    }
  }
}
```

#### **YAML Format**  
- Clean hierarchical structure
- Optimal for configuration-heavy documentation
- Easy parsing for automated tools

### Integration Features

#### **Smart Merging**
- Detect overlapping content between chat and existing docs
- Preserve existing structure while adding new insights
- Flag conflicting information for manual resolution

#### **Context Preservation**  
- Link documentation back to specific chat conversations
- Maintain traceability of decisions and implementations
- Include timestamps and context for future reference

#### **AI Enhancement Markers**
```markdown
<!-- AI_CONTEXT: This section covers database schema management -->
<!-- AI_RELATED: supabase, prisma, migrations, foreign_keys -->
<!-- AI_PRIORITY: high - affects data integrity and user operations -->
<!-- AI_COMPLEXITY: high - requires understanding of relational constraints -->
```

### Documentation Targets

#### **Update Existing Files**
- `docs/manual/` - User-facing procedures and workflows
- `docs/ops/` - Operational procedures and troubleshooting  
- `docs/workflows/` - Development and deployment workflows
- `CLAUDE.md` - AI assistant context and configuration

#### **Generate New Files**
- `docs/consolidated/chat_insights_YYYY_MM_DD.md` - Session-specific learnings
- `docs/ai_context/` - AI-optimized knowledge base entries
- `docs/troubleshooting/` - Problem-solution patterns from conversations

### Execution Flow

1. **Parse Current Chat**: Extract technical decisions, fixes, and insights
2. **Scan Documentation**: Index existing docs and identify relevant sections  
3. **Consolidate Information**: Merge chat insights with existing knowledge
4. **Structure for AI**: Format with metadata, tags, and explicit relationships
5. **Generate Output**: Create or update documentation files
6. **Validate Consistency**: Cross-reference information across sources
7. **Update Index**: Maintain searchable documentation index

This command transforms conversational knowledge into structured, AI-optimized documentation that enhances future development workflows and AI interactions.

## Expected Output

The command will generate or update documentation files with:
- **Consolidated Knowledge**: Chat insights merged with existing docs
- **AI-Friendly Structure**: Metadata, tags, and semantic markup
- **Traceability**: Links back to source conversations and decisions  
- **Actionable Content**: Specific procedures, patterns, and solutions
- **Future Context**: Guidance for similar issues and enhancements