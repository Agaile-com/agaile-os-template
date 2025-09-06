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

## Core Features

### Context Extraction
- Parse current chat conversation for actionable information
- Extract technical decisions, implementations, fixes, and insights
- Identify key patterns, workflows, and best practices discussed

### Existing Documentation Analysis
- Scan documentation directories for relevant content
- Parse existing documentation structure
- Identify gaps, outdated information, and consolidation opportunities

### Intelligent Consolidation
- Map chat insights to relevant documentation sections
- Resolve conflicts between chat content and existing docs
- Merge complementary information while avoiding duplication

### AI-Optimized Formatting
- Structure content for optimal AI parsing and retrieval
- Use consistent metadata tags and semantic markers
- Include explicit relationships between concepts
- Add contextual tags for fast topic-based searches

## Documentation Categories

### Technical Implementation
- Code Architecture
- Database Changes
- API Integrations
- Configuration Management
- Performance Optimizations

### Workflow & Process
- Development Workflows
- Testing Strategies
- CI/CD Pipelines
- Monitoring & Alerting
- Code Quality

### Troubleshooting & Solutions
- Production Issues
- Development Blockers
- Integration Problems
- Performance Bottlenecks
- Security Vulnerabilities

### Knowledge Base
- Architectural Decisions
- Domain Expertise
- Tool Mastery
- Team Knowledge
- External Dependencies

## Output Formats

### Structured Markdown (Default)
- AI-friendly frontmatter with metadata tags
- Hierarchical structure with explicit relationships
- Code blocks with syntax highlighting and context
- Cross-references and related system links

### JSON Format
- Clean structured data for programmatic access
- Nested technical details and relationships
- AI hints and diagnostic approaches

### YAML Format
- Clean hierarchical structure
- Optimal for configuration-heavy documentation
- Easy parsing for automated tools

## Expected Output

The command will generate or update documentation files with:
- **Consolidated Knowledge**: Chat insights merged with existing docs
- **AI-Friendly Structure**: Metadata, tags, and semantic markup
- **Traceability**: Links back to source conversations and decisions  
- **Actionable Content**: Specific procedures, patterns, and solutions
- **Future Context**: Guidance for similar issues and enhancements