# HIL Workflow Phase Definitions

## Phase 1: Development
**Status**: `IN_DEVELOPMENT`
**Command**: `/execute-tasks`
**Description**: Feature implementation and core development work
**Completion Criteria**: All tasks marked complete, code compiles without errors

## Phase 2: Testing
**Status**: `TESTING_IN_PROGRESS`
**Agent**: `quality-agent`
**Description**: Quality assurance, automated testing, and code review
**Completion Criteria**: All tests passing, code coverage targets met

## Phase 3: Validation
**Status**: `VALIDATION_PENDING`
**Command**: `/verify-deployment`
**Description**: Pre-deployment verification and compatibility checks
**Completion Criteria**: All deployment checks pass, no blocking issues

## Phase 4: CI/CD
**Status**: `CI_CD_IN_PROGRESS`
**Command**: `/ci-cd`
**Description**: Continuous integration and deployment pipeline execution
**Completion Criteria**: Successful build and deployment to staging

## Phase 5: Preview
**Status**: `PREVIEW_DEPLOYED`
**Description**: Preview environment deployment and stakeholder review
**Completion Criteria**: Feature deployed to preview, stakeholder approval

## Phase 6: Production
**Status**: `PRODUCTION_DEPLOYED`
**Description**: Production deployment and monitoring
**Completion Criteria**: Feature live in production, monitoring active

## Phase 7: Documentation
**Status**: `DOCUMENTATION_PENDING`
**Command**: `/documenter`
**Description**: Knowledge consolidation and documentation updates
**Completion Criteria**: Documentation updated, knowledge base current

## Phase 8: Feedback Triage
**Status**: `FEEDBACK_COLLECTED`
**Command**: `/feedback-triage`
**Description**: User feedback processing and iterative improvements
**Completion Criteria**: Feedback processed, action items created