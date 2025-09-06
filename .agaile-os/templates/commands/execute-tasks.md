# Execute Tasks

Execute development tasks with optional agent assistance.

## Workflow

1. **Task Selection**
   - Identify next task from task list
   - Check dependencies and blockers
   - Prepare execution environment

2. **Implementation**
   - Follow coding standards
   - Implement with appropriate patterns
   - Maintain test coverage

3. **Validation**
   - Run local tests
   - Check TypeScript compilation
   - Validate against specifications

## Usage

```
/execute-tasks                           # Execute next task
/execute-tasks --agent-enhanced         # With agent assistance
/execute-tasks --task-id 1.2.3         # Specific task
```

## Agent Enhancement

When using `--agent-enhanced`, the appropriate agent will:
- Provide implementation suggestions
- Handle error resolution
- Validate code quality
- Update documentation

## Output

- Implemented code changes
- Updated task status
- Test results
- Documentation updates

## Instructions Location

Execute the workflow defined in:
`.agaile-os/instructions/core/execute-tasks.md`
