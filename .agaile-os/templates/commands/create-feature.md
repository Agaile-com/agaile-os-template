# Create Feature

Generate detailed feature specifications aligned with product roadmap and mission.

## Workflow

1. **Context Gathering**
   - Read product mission and roadmap
   - Identify next priority feature
   - Validate alignment with goals

2. **Requirements Clarification**
   - Ask numbered questions for clarity
   - Define scope boundaries
   - Identify integration points

3. **Specification Generation**
   - Create feature folder in `.agaile-os/features/active/`
   - Generate comprehensive documentation:
     - `feature.md` - Main specification
     - `feature-lite.md` - AI-optimized summary
     - `technical-spec.md` - Implementation details
     - `database-schema.md` - Database changes (if needed)
     - `api-spec.md` - API specifications (if needed)

## Usage

```
/create-feature [feature-description]
```

Or simply ask "what's next?" to get the next roadmap item.

## Output Structure

```
.agaile-os/features/active/[semantic-feature-name]/
├── feature.md
├── feature-lite.md
├── technical-spec.md
├── database-schema.md  (conditional)
└── api-spec.md        (conditional)
```

## Instructions Location

Execute the workflow defined in:
`.agaile-os/instructions/core/create-feature.md`
