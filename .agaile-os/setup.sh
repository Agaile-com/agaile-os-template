#!/bin/bash

# AgAIle OS Setup Script
# Initializes the AgAIle OS system for a new project

set -e

echo "
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║     🚀 AgAIle OS - Agent-Enhanced Development System        ║
║                                                              ║
║     Initializing your intelligent development workflow...    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Detect project root (one level up from .agaile-os)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT=$(dirname "$SCRIPT_DIR")
print_info "Project root: $PROJECT_ROOT"
cd "$PROJECT_ROOT"

# Create .agaile-os directory structure
print_status "Creating AgAIle OS directory structure..."

mkdir -p .agaile-os/{product,standards,features,instructions,agents,prds,epics,tasks,checklists,logs}
mkdir -p .agaile-os/features/{active,completed,archived}
mkdir -p .agaile-os/prds/{active,completed,archived}
mkdir -p .agaile-os/instructions/{core,custom}
mkdir -p .agaile-os/standards/code-style

print_status "AgAIle OS directories created"

# Create Claude integration
if [ "$1" != "--skip-claude" ]; then
    print_status "Setting up Claude Code integration..."
    mkdir -p .claude/{commands,agents}
    
    # Check if Claude commands already exist
    if [ -d "$HOME/.claude" ]; then
        print_info "Found existing Claude configuration at ~/.claude"
    else
        mkdir -p ~/.claude
        print_status "Created global Claude configuration"
    fi
fi

# Create Cursor integration
if [ "$1" != "--skip-cursor" ]; then
    print_status "Setting up Cursor integration..."
    mkdir -p .cursor/rules
fi

# Initialize Git if not already initialized
if [ ! -d .git ]; then
    print_status "Initializing Git repository..."
    git init
    print_status "Git repository initialized"
else
    print_info "Git repository already exists"
fi

# Create .gitignore if it doesn't exist
if [ ! -f .gitignore ]; then
    print_status "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# AgAIle OS
.agaile-os/logs/
.agaile-os/features/active/*-wip/
*.log
*.tmp

# IDE
.cursor/
.vscode/
.idea/

# Dependencies
node_modules/
.pnpm-store/

# Environment
.env
.env.local
.env.*.local

# Build outputs
dist/
build/
.next/
out/

# OS
.DS_Store
Thumbs.db
EOF
    print_status ".gitignore created"
fi

# Copy template files
print_status "Copying AgAIle OS templates..."

# Check if we're in the agaile-os repo or using it as a template
TEMPLATE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -d "$TEMPLATE_DIR/templates" ]; then
    cp -r "$TEMPLATE_DIR/templates/." .agaile-os/
    print_status "Templates copied from $TEMPLATE_DIR"
else
    print_warning "Template directory not found. Creating minimal setup..."
fi

# Create initial configuration files
print_status "Creating configuration files..."

# Create HIL configuration
cat > .agaile-os/hil-config.yml << 'EOF'
# HIL (Human-in-the-Loop) Configuration
version: "1.0"
project_name: "$(basename $PROJECT_ROOT)"

# Approval thresholds
confidence_thresholds:
  auto_execute: 85
  interactive: 60
  manual_review: 30

# Environment risk multipliers
environments:
  development:
    risk_multiplier: 0.7
    auto_execute_enabled: true
  staging:
    risk_multiplier: 1.0
    auto_execute_enabled: true
  production:
    risk_multiplier: 2.0
    auto_execute_enabled: false

# Agent configuration
agents:
  enabled: true
  default_mode: "interactive"
  learning_enabled: true

# Notification settings
notifications:
  critical_escalation_minutes: 15
  email_enabled: false
  slack_enabled: false
EOF

print_status "HIL configuration created"

# Create sample product files
cat > .agaile-os/product/mission.md << 'EOF'
# Product Mission

## Vision
[Your product vision here]

## Mission Statement
[Your mission statement here]

## Success Metrics
- [ ] Metric 1
- [ ] Metric 2
- [ ] Metric 3

## Target Audience
[Define your target users]

## Core Values
1. [Value 1]
2. [Value 2]
3. [Value 3]
EOF

cat > .agaile-os/product/roadmap.md << 'EOF'
# Product Roadmap

## Phase 1: Foundation (Month 1-2)
- [ ] Core infrastructure setup
- [ ] Basic authentication system
- [ ] Database schema design

## Phase 2: Core Features (Month 3-4)
- [ ] Feature 1
- [ ] Feature 2
- [ ] Feature 3

## Phase 3: Enhancement (Month 5-6)
- [ ] Performance optimization
- [ ] Advanced features
- [ ] Third-party integrations

## Future Considerations
- [ ] Future feature 1
- [ ] Future feature 2
EOF

print_status "Product documentation templates created"

# Create standards templates
cat > .agaile-os/standards/tech-stack.md << 'EOF'
# Technology Stack

## Frontend
- **Framework**: [e.g., Next.js, React, Vue]
- **Styling**: [e.g., Tailwind CSS, CSS Modules]
- **State Management**: [e.g., Redux, Zustand]

## Backend
- **Runtime**: [e.g., Node.js, Deno, Bun]
- **Framework**: [e.g., Express, Fastify, Hono]
- **Database**: [e.g., PostgreSQL, MongoDB]
- **ORM**: [e.g., Prisma, TypeORM]

## Infrastructure
- **Hosting**: [e.g., Vercel, AWS, Railway]
- **Database Host**: [e.g., Supabase, PlanetScale]
- **CDN**: [e.g., Cloudflare, Fastly]

## Development Tools
- **Package Manager**: [e.g., pnpm, npm, yarn]
- **Testing**: [e.g., Jest, Vitest, Playwright]
- **CI/CD**: [e.g., GitHub Actions, GitLab CI]

## AI Integration
- **LLM Provider**: [e.g., OpenAI, Anthropic, Google]
- **Vector Database**: [e.g., Pinecone, Weaviate]
- **Agent Framework**: AgAIle OS
EOF

cat > .agaile-os/standards/code-style.md << 'EOF'
# Code Style Guide

## General Principles
- Write clear, self-documenting code
- Prefer composition over inheritance
- Keep functions small and focused
- Use meaningful variable names

## TypeScript/JavaScript
- Use TypeScript strict mode
- Prefer const over let
- Use async/await over promises
- Implement proper error handling

## Naming Conventions
- **Files**: kebab-case (user-service.ts)
- **Components**: PascalCase (UserProfile.tsx)
- **Functions**: camelCase (getUserData)
- **Constants**: UPPER_SNAKE_CASE (MAX_RETRIES)
- **Database Tables**: PascalCase (UserAccount)

## Git Commits
Use conventional commits:
- feat: New feature
- fix: Bug fix
- docs: Documentation
- style: Formatting
- refactor: Code restructuring
- test: Testing
- chore: Maintenance

## Testing
- Write tests for critical paths
- Maintain >80% coverage for business logic
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
EOF

print_status "Standards templates created"

# Create MASTER_TRACKING.md for project planning and progress tracking
print_status "Creating MASTER_TRACKING.md project tracking document..."

if [ ! -f ".agaile-os/MASTER_TRACKING.md" ]; then
    if [ -f "$TEMPLATE_DIR/templates/MASTER_TRACKING.md" ]; then
        cp "$TEMPLATE_DIR/templates/MASTER_TRACKING.md" ".agaile-os/MASTER_TRACKING.md"
        print_status "MASTER_TRACKING.md created"
        print_info "Centralized project planning and progress tracking activated"
    else
        print_warning "MASTER_TRACKING.md template not found, skipping creation"
    fi
else
    print_info "MASTER_TRACKING.md already exists, skipping template copy"
fi

# Create CLAUDE.md configuration
print_status "Creating CLAUDE.md project configuration..."

if [ ! -f "$PROJECT_ROOT/CLAUDE.md" ]; then
    if [ -f "$TEMPLATE_DIR/templates/CLAUDE.md" ]; then
        cp "$TEMPLATE_DIR/templates/CLAUDE.md" "$PROJECT_ROOT/CLAUDE.md"
        print_status "CLAUDE.md configuration created"
        print_info "Agaile-OS system activated with HIL methodology"
    else
        print_warning "CLAUDE.md template not found, skipping configuration"
    fi
else
    print_info "CLAUDE.md already exists, skipping template copy"
fi

# Setup MCP configuration template
print_status "Setting up MCP (Model Context Protocol) template..."

if [ -d "$HOME/.claude" ]; then
    if [ ! -f "$HOME/.claude/mcp.json" ]; then
        if [ -f "$TEMPLATE_DIR/templates/mcp.json" ]; then
            print_info "Copying MCP template to ~/.claude/mcp.json"
            cp "$TEMPLATE_DIR/templates/mcp.json" "$HOME/.claude/mcp.json"
            print_status "MCP template installed"
            print_warning "Configure your environment variables for MCP servers"
            print_info "See .agaile-os/docs/MCP-Setup.md for detailed setup instructions"
        else
            print_warning "MCP template not found, skipping MCP setup"
        fi
    else
        print_info "MCP configuration already exists at ~/.claude/mcp.json"
    fi
else
    print_warning "Claude directory not found. Install Claude Code first for MCP integration"
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║     ✅ AgAIle OS Setup Complete!                            ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
print_info "Next steps:"
echo "  1. Edit CLAUDE.md with your project details and tech stack"
echo "  2. Edit .agaile-os/MASTER_TRACKING.md with your roadmap and goals"
echo "  3. Update .agaile-os/product/mission.md with your product vision"
echo "  4. Configure .agaile-os/standards/ with your tech stack"
echo "  5. Configure MCP servers: see .agaile-os/docs/MCP-Setup.md"
echo "  6. Run: agaile-os init (if installed globally)"
echo "  7. Start with: /create-feature 'Your first feature'"
echo ""
print_info "For documentation, visit: https://github.com/Agaile-com/agaile-os-template"
echo ""
