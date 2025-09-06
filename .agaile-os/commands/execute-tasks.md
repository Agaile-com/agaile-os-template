---
description: Rules to initiate execution of a set of tasks using AgAIle OS
globs:
alwaysApply: false
version: 1.0
encoding: UTF-8
---

# Task Execution Rules

## Overview

Initiate execution of one or more tasks for a given spec.

<pre_flight_check>
EXECUTE: @.agaile-os/commands/pre-flight.md
</pre_flight_check>

<process_flow>

<step number="1" name="task_assignment">

### Step 1: Task Assignment

Identify which tasks to execute from the feature (using spec_srd_reference file path and optional specific_tasks array), defaulting to the next uncompleted parent task if not specified.

<task_selection>
<explicit>user specifies exact task(s)</explicit>
<implicit>find next uncompleted task in tasks.md</implicit>
</task_selection>

<instructions>
  ACTION: Identify task(s) to execute
  DEFAULT: Select next uncompleted parent task if not specified
  CONFIRM: Task selection with user
</instructions>

</step>

<step number="2" subagent="context-fetcher" name="context_analysis">

### Step 2: Context Analysis

Use the context-fetcher subagent to gather minimal context for task understanding by always loading feature tasks.md, and conditionally loading @.agaile-os/product/mission-lite.md, spec-lite.md, and sub-specs/technical-spec.md if not already in context.

<instructions>
  ACTION: Use context-fetcher subagent to:
    - REQUEST: "Get product pitch from mission-lite.md"
    - REQUEST: "Get feature summary from spec-lite.md"
    - REQUEST: "Get technical approach from technical-spec.md"
  PROCESS: Returned information
</instructions>

<context_gathering>
<essential_docs> - tasks.md for task breakdown
</essential_docs>
<conditional_docs> - mission-lite.md for product alignment - spec-lite.md for feature summary - technical-spec.md for implementation details
</conditional_docs>
</context_gathering>

</step>

<step number="3" name="semantic_code_analysis">

### Step 3: Semantic Code Analysis & Redundancy Prevention

Before implementing any task, perform semantic analysis to identify existing similar code and prevent redundancy. Use Serena MCP tools for comprehensive code understanding.

<semantic_search_flow>
<search_strategy>
- SEARCH for similar functionality using find_symbol and search_for_pattern
- IDENTIFY existing implementations that solve related problems
- EVALUATE opportunities for consolidation vs extension
- DETERMINE the most efficient implementation approach
</search_strategy>

<consolidation_priority>
- CONSOLIDATE rather than duplicate when possible
- EXTEND existing services rather than create new ones
- REFACTOR common patterns into shared utilities
- MAINTAIN consistency with existing code patterns
</consolidation_priority>
</semantic_search_flow>

<instructions>
  ACTION: Use Serena MCP tools to search for existing similar code:
    - USE: find_symbol to locate relevant classes, functions, services
    - USE: search_for_pattern to find similar implementation patterns
    - USE: find_referencing_symbols to understand usage patterns
    - ANALYZE: Existing code architecture and patterns
  EVALUATE: Opportunities for code reuse and consolidation
  DECIDE: Whether to extend existing code or create new implementation
  DOCUMENT: Rationale for implementation approach chosen
</instructions>

<search_patterns>
<by_functionality>
- Search for services with similar business logic
- Identify utility functions that could be reused
- Find existing API patterns and data models
</by_functionality>
<by_naming>
- Search for similar naming conventions
- Look for related feature implementations
- Identify established patterns in the codebase
</by_naming>
<by_domain>
- Search within relevant domain boundaries
- Check related feature areas for patterns
- Examine existing integrations and interfaces
</by_domain>
</search_patterns>

<consolidation_guidelines>
<when_to_consolidate>
- Similar business logic exists in multiple places
- Common data transformation patterns are repeated
- Similar API endpoints or database queries exist
- Utility functions solve related problems
</when_to_consolidate>
<when_to_extend>
- Existing service can be enhanced to support new requirements
- Current implementation is well-structured and extensible
- New functionality logically belongs in existing module
</when_to_extend>
<when_to_create_new>
- Functionality is genuinely novel and unrelated
- Existing implementations are not suitable for extension
- New requirements would compromise existing code quality
</when_to_create_new>
</consolidation_guidelines>

</step>

<step number="4" name="development_server_check">

### Step 4: Check for Development Server

Check for any running development server and ask user permission to shut it down if found to prevent port conflicts.

<server_check_flow>
<if_running>
ASK user to shut down
WAIT for response
</if_running>
<if_not_running>
PROCEED immediately
</if_not_running>
</server_check_flow>

<user_prompt>
A development server is currently running.
Should I shut it down before proceeding? (yes/no)
</user_prompt>

<instructions>
  ACTION: Check for running local development server
  CONDITIONAL: Ask permission only if server is running
  PROCEED: Immediately if no server detected
</instructions>

</step>

<step number="5" subagent="git-workflow" name="git_branch_management">

### Step 5: Git Branch Management

Use the git-workflow subagent to manage git branches to ensure proper isolation by creating or switching to the appropriate branch for the spec.

<instructions>
  ACTION: Use git-workflow subagent
  REQUEST: "Check and manage branch for spec: [SPEC_FOLDER]
            - Create branch if needed
            - Switch to correct branch
            - Handle any uncommitted changes"
  WAIT: For branch setup completion
</instructions>

<branch_naming>

  <source>spec folder name</source>
  <format>exclude date prefix</format>
  <example>
    - folder: 2025-03-15-password-reset
    - branch: password-reset
  </example>
</branch_naming>

</step>

<step number="6" name="task_execution_loop">

### Step 6: Task Execution Loop

Execute all assigned parent tasks and their subtasks using @.agaile-os/instructions/core/execute-task.md instructions, continuing until all tasks are complete.

<execution_flow>
LOAD @.agaile-os/instructions/core/execute-task.md ONCE

FOR each parent_task assigned in Step 1:
EXECUTE instructions from execute-task.md with: - parent_task_number - all associated subtasks
WAIT for task completion
UPDATE tasks.md status
END FOR
</execution_flow>

<loop_logic>
<continue_conditions> - More unfinished parent tasks exist - User has not requested stop
</continue_conditions>
<exit_conditions> - All assigned tasks marked complete - User requests early termination - Blocking issue prevents continuation
</exit_conditions>
</loop_logic>

<task_status_check>
AFTER each task execution:
CHECK tasks.md for remaining tasks
IF all assigned tasks complete:
PROCEED to next step
ELSE:
CONTINUE with next task
</task_status_check>

<instructions>
  ACTION: Load execute-task.md instructions once at start
  REUSE: Same instructions for each parent task iteration
  LOOP: Through all assigned parent tasks
  UPDATE: Task status after each completion
  VERIFY: All tasks complete before proceeding
  HANDLE: Blocking issues appropriately
</instructions>

</step>

<step number="7" name="complete_tasks">

### Step 7: Run the task completion steps

After all tasks in tasks.md have been implemented, use @.agaile-os/instructions/core/complete-tasks.md to run our series of steps we always run when finishing and delivering a new feature.

<instructions>
  LOAD: @.agaile-os/instructions/core/complete-tasks.md once
  ACTION: execute all steps in the complete-tasks.md process_flow.
</instructions>

</step>

</process_flow>

<post_flight_check>
EXECUTE: @.agaile-os/commands/post-flight.md
</post_flight_check>
