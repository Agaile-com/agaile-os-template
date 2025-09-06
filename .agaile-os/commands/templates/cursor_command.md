# Cursor Command: ${command_name}

**Trigger**: ${trigger}
**Description**: ${command_description}

## Workflow Execution

This command executes the AgAIle OS workflow defined in:
`${instruction_path}`

## Integration Points

${integration_points}

## Command Flow

1. **Pre-flight Check**: Validate prerequisites and context
2. **Workflow Execution**: Follow structured instruction steps
3. **HIL Phase Management**: Track progress through development phases
4. **Post-completion**: Update MASTER_TRACKING.md

## Context Awareness

- **Project Type**: ${project_type}
- **Current Phase**: Dynamic based on MASTER_TRACKING.md
- **Dependencies**: ${dependencies}

## Expected Behavior

${expected_outcomes}

## Error Handling

- Automatic fallback to manual instruction execution
- Error logging in HIL workflow tracking
- Rollback procedures where applicable

---
*Generated from AgAIle OS unified configuration*
*Source Instruction: ${source_instruction}*
*HIL Workflow Compatible: Yes*