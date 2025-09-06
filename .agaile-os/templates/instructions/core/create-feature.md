# Create Feature - Core Instructions

You are an expert software architect creating comprehensive feature specifications.

## Context Loading

First, load and understand:
1. `.agaile-os/product/mission.md` - Product vision and goals
2. `.agaile-os/product/roadmap.md` - Development phases and priorities
3. `.agaile-os/standards/tech-stack.md` - Technology constraints
4. `.agaile-os/standards/code-style.md` - Coding standards

## Specification Process

### Step 1: Requirements Gathering

Ask clarifying questions about:
- **Scope**: What's included and explicitly excluded?
- **Users**: Who will use this feature and why?
- **Integration**: What existing systems will this touch?
- **Data**: What data will be created, read, updated, or deleted?
- **UI/UX**: What interfaces are needed?
- **Performance**: What are the performance requirements?
- **Security**: What security considerations exist?

### Step 2: Feature Documentation Structure

Create a folder: `.agaile-os/features/active/[semantic-name]/`

Generate these files:

#### feature.md
```markdown
# Feature: [Name]

## Overview
Brief description of the feature and its purpose.

## User Stories
- As a [user type], I want to [action] so that [benefit]

## Requirements

### Functional Requirements
- REQ-F001: [Requirement]
- REQ-F002: [Requirement]

### Non-Functional Requirements
- REQ-NF001: [Performance requirement]
- REQ-NF002: [Security requirement]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Dependencies
- Existing feature X
- External service Y

## Risks & Mitigations
- Risk: [Description] → Mitigation: [Strategy]
```

#### feature-lite.md
```markdown
# [Feature Name] - Quick Reference

**Purpose**: One-line description
**Priority**: High/Medium/Low
**Effort**: S/M/L/XL
**Dependencies**: List key dependencies

## Core Functionality
- Bullet points of key features
- Optimized for AI context

## Integration Points
- API endpoints affected
- Database tables modified
- UI components needed
```

#### technical-spec.md
```markdown
# Technical Specification

## Architecture
Description of technical architecture

## Components
- Component A: Purpose and design
- Component B: Purpose and design

## Data Flow
1. Step 1: User initiates action
2. Step 2: System processes
3. Step 3: Response returned

## API Design
### Endpoints
- `POST /api/feature`: Create resource
- `GET /api/feature/:id`: Retrieve resource

## Database Schema
Reference to database-schema.md if applicable

## Testing Strategy
- Unit tests for business logic
- Integration tests for API
- E2E tests for critical paths
```

### Step 3: Conditional Files

#### database-schema.md (if database changes needed)
```sql
-- Table: NewTable
CREATE TABLE "NewTable" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "field1" TEXT NOT NULL,
    "field2" INTEGER DEFAULT 0,
    "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP NOT NULL
);

-- Migrations needed:
-- 1. Create table
-- 2. Add indexes
-- 3. Set up foreign keys
```

#### api-spec.md (if new APIs needed)
```yaml
openapi: 3.0.0
paths:
  /api/feature:
    post:
      summary: Create new feature resource
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
```

## Quality Checklist

Before completing:
- [ ] All requirements are clear and testable
- [ ] Technical approach is feasible with current stack
- [ ] Dependencies are identified
- [ ] Risks are documented with mitigations
- [ ] Acceptance criteria are comprehensive
- [ ] Feature can be broken into tasks
- [ ] Documentation is AI-optimized

## Output Summary

After creating specifications, provide:
1. Feature folder location
2. Brief summary of what was created
3. Next recommended step (usually `/create-tasks`)
4. Any concerns or risks identified
