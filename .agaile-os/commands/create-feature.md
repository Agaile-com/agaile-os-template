---
name: create-feature
description: Generate detailed feature requirements aligned with product roadmap and mission using AgAIle OS HIL workflow
version: 1.2
model: opus
color: green
agent: context-fetcher
integrations:
  - AgAIle OS HIL Workflow
  - MASTER_TRACKING.md updates
  - Feature hierarchy management
  - Epic coordination
context:
  - Project roadmap and mission context
  - Current HIL phase status across features
  - Epic and feature dependencies
outcomes:
  - Feature specification created
  - HIL workflow tracking initialized
  - Epic integration confirmed
dependencies:
  - roadmap.md
  - mission-lite.md
  - tech-stack.md
trigger: /create-feature
---

# Enhanced Feature Creation with HIL Integration

Generate detailed feature requirements aligned with product roadmap and mission, fully integrated with the AgAIle OS HIL workflow.

## Pre-flight Validation

@.agaile-os/shared/pre-flight-checklist.md

## HIL Workflow Context

@.agaile-os/shared/hil-workflow-phases.md

## Process Flow

### Step 1: Feature Initiation (Context-Fetcher Agent)

**Trigger Detection**:
- User requests "what's next?" → Analyze roadmap for next priority
- User provides specific feature idea → Accept and proceed

**Roadmap Analysis** (when applicable):
1. READ: `.agaile-os/product/roadmap.md`
2. IDENTIFY: Next uncompleted roadmap item
3. PRESENT: Roadmap item to user with context
4. AWAIT: User approval before proceeding

### Step 2: Context Gathering (Conditional Intelligence)

**Smart Context Loading**:
```
IF (mission-lite.md AND tech-stack.md) IN current_context:
    SKIP context loading
    PROCEED to requirements clarification
ELSE:
    READ only missing context files:
    - .agaile-os/product/mission-lite.md (if not in context)
    - .agaile-os/product/tech-stack.md (if not in context)
```

**Context Analysis Framework**:
- **Mission Alignment**: Core product purpose and value proposition
- **Technical Constraints**: Architecture and technology requirements
- **Epic Integration**: Related strategic initiatives and dependencies

### Step 3: Requirements Clarification (Interactive)

**Clarification Areas**:
1. **Scope Boundaries**:
   - In-scope: Specific functionality to be included
   - Out-of-scope: Explicitly excluded features (optional)

2. **Technical Specifications**:
   - Functionality requirements and user interactions
   - UI/UX design considerations and patterns
   - Integration points with existing systems

3. **HIL Workflow Planning**:
   - Expected development complexity and timeline
   - Testing requirements and validation criteria
   - Deployment considerations and rollback planning

**Interactive Process**:
- ASK numbered clarification questions
- AWAIT user responses
- ITERATE until requirements are clear and complete

### Step 4: Epic and Feature Hierarchy Integration

**Epic Assessment**:
1. ANALYZE existing epics in `.agaile-os/epics/active/`
2. IDENTIFY related strategic initiatives
3. DETERMINE if new epic creation is required
4. ESTABLISH feature positioning within epic hierarchy

**Dependency Mapping**:
- Map dependencies to existing features
- Identify potential parallel development opportunities
- Assess impact on current HIL workflow phases

### Step 5: Feature Specification Generation

**Specification Structure**:
1. **Feature Overview**:
   - Name, description, and strategic rationale
   - Epic alignment and business value proposition
   - Success metrics and acceptance criteria

2. **Technical Specification**:
   - Architecture and implementation approach
   - Database schema requirements (if applicable)
   - API design and integration points

3. **HIL Workflow Planning**:
   - Development phase breakdown and task structure
   - Testing strategy and quality gates
   - Deployment and rollback procedures

4. **Dependencies and Risks**:
   - Feature dependencies and prerequisites
   - Risk assessment and mitigation strategies
   - Resource requirements and timeline estimates

### Step 6: HIL Tracking Initialization

**MASTER_TRACKING.md Integration**:
```yaml
feature_name:
  phase: development
  development: 0%
  testing: 0%
  validation: pending
  ci-cd: pending
  preview: pending
  production: pending
  documentation: pending
  status: INITIALIZED
  epic: related_epic_name
  dependencies: [list_of_dependencies]
  next_action: "Begin development phase execution"
```

**File System Organization**:
1. CREATE: `.agaile-os/features/active/{feature-name}/feature.md`
2. CREATE: `.agaile-os/features/active/{feature-name}/tasks.md` (if complex)
3. UPDATE: `.agaile-os/MASTER_TRACKING.md` with HIL phase tracking
4. LINK: Feature to relevant Epic in `.agaile-os/epics/active/`

## Success Criteria

- [ ] Feature specification complete and reviewed
- [ ] HIL workflow tracking initialized in MASTER_TRACKING.md
- [ ] Epic integration confirmed and documented
- [ ] Dependencies mapped and communicated
- [ ] Next steps clearly defined for development phase

## Integration Points

- **Task Creation**: Ready for `/create-tasks` command execution
- **Development**: Prepared for `/execute-tasks` workflow
- **Epic Coordination**: Integrated with strategic Epic management
- **HIL Tracking**: Full lifecycle tracking enabled

## Error Handling

**Common Issues**:
- Missing roadmap context → Request roadmap review
- Unclear requirements → Extended clarification process
- Epic conflicts → Escalate to strategic review
- Technical blockers → Document and flag for resolution

**Recovery Procedures**:
- Incomplete specifications → Return to clarification phase
- Epic misalignment → Strategic review and realignment
- HIL tracking failures → Manual tracking setup and verification