#!/bin/bash

# AgAIle OS Setup Functions
# Shared utilities for multi-IDE integration and setup

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC} $1"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
}

print_status() {
    echo -e "${BLUE}[SETUP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

# Detect current directory and validate project structure
detect_project_root() {
    local current_dir=$(pwd)
    local project_root=""
    
    # Look for project markers
    while [[ "$current_dir" != "/" ]]; do
        if [[ -f "$current_dir/package.json" ]] || [[ -f "$current_dir/.git/config" ]]; then
            project_root="$current_dir"
            break
        fi
        current_dir=$(dirname "$current_dir")
    done
    
    if [[ -z "$project_root" ]]; then
        print_error "Could not detect project root. Please run from within a project directory."
        exit 1
    fi
    
    echo "$project_root"
}

# Validate AgAIle OS installation
validate_agaile_os() {
    local project_root="$1"
    local agaile_dir="$project_root/.agaile-os"
    
    print_status "Validating AgAIle OS installation..."
    
    # Check for required files
    local required_files=(
        "$agaile_dir/config.yml"
        "$agaile_dir/MASTER_TRACKING.md"
        "$agaile_dir/instructions"
        "$agaile_dir/shared"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -e "$file" ]]; then
            print_error "Required file/directory missing: $file"
            return 1
        fi
    done
    
    print_success "AgAIle OS installation validated"
    return 0
}

# Install Node.js dependencies for command processor
install_dependencies() {
    local agaile_dir="$1"
    local shared_dir="$agaile_dir/shared"
    
    print_status "Installing command processor dependencies..."
    
    cd "$shared_dir"
    
    # Check if package.json exists
    if [[ ! -f "package.json" ]]; then
        print_error "package.json not found in $shared_dir"
        return 1
    fi
    
    # Install dependencies using the project's package manager
    if command -v pnpm &> /dev/null && [[ -f "../../pnpm-lock.yaml" ]]; then
        print_info "Using pnpm for dependency installation"
        pnpm install
    elif command -v yarn &> /dev/null && [[ -f "../../yarn.lock" ]]; then
        print_info "Using yarn for dependency installation"
        yarn install
    elif command -v npm &> /dev/null; then
        print_info "Using npm for dependency installation"
        npm install
    else
        print_error "No package manager found (pnpm, yarn, or npm)"
        return 1
    fi
    
    print_success "Dependencies installed successfully"
    cd - > /dev/null
}

# Generate commands for specific IDE
generate_ide_commands() {
    local project_root="$1"
    local ide="$2"
    local agaile_dir="$project_root/.agaile-os"
    local shared_dir="$agaile_dir/shared"
    
    print_status "Generating $ide commands..."
    
    cd "$shared_dir"
    
    # Run the command processor
    if node command-processor.js generate; then
        print_success "$ide commands generated successfully"
    else
        print_error "Failed to generate $ide commands"
        return 1
    fi
    
    cd - > /dev/null
}

# Setup Claude Code integration
setup_claude_integration() {
    local project_root="$1"
    local claude_dir="$project_root/.claude"
    
    print_status "Setting up Claude Code integration..."
    
    # Ensure .claude directory exists
    mkdir -p "$claude_dir/commands"
    mkdir -p "$claude_dir/agents"
    
    # Generate Claude-specific commands
    if generate_ide_commands "$project_root" "claude_code"; then
        print_success "Claude Code integration configured"
        
        # Provide next steps
        print_info "Claude Code is ready to use with AgAIle OS commands"
        print_info "Available commands will be prefixed with '/'"
        
        return 0
    else
        print_error "Failed to setup Claude Code integration"
        return 1
    fi
}

# Setup Cursor integration
setup_cursor_integration() {
    local project_root="$1"
    local cursor_dir="$project_root/.cursor"
    
    print_status "Setting up Cursor integration..."
    
    # Ensure .cursor directory exists
    mkdir -p "$cursor_dir/commands"
    
    # Generate Cursor-specific commands
    if generate_ide_commands "$project_root" "cursor"; then
        # Generate .cursorrules file
        generate_cursorrules "$project_root"
        
        print_success "Cursor integration configured"
        
        # Provide next steps
        print_info "Cursor is ready to use with AgAIle OS commands"
        print_info "Commands are available through @ mentions"
        print_info ".cursorrules file has been generated with AgAIle OS context"
        
        return 0
    else
        print_error "Failed to setup Cursor integration"
        return 1
    fi
}

# Generate .cursorrules file
generate_cursorrules() {
    local project_root="$1"
    local cursorrules_file="$project_root/.cursorrules"
    local agaile_dir="$project_root/.agaile-os"
    
    print_status "Generating .cursorrules file..."
    
    cat > "$cursorrules_file" << 'EOF'
# Cursor Rules for AgAIle OS Integration
# This file provides Cursor with AgAIle OS context and workflow awareness

## Project Context
This project uses the AgAIle OS framework with HIL (Human-in-the-Loop) workflow methodology.

## Framework Integration
- **Configuration**: See .agaile-os/config.yml for complete framework settings
- **Master Tracking**: .agaile-os/MASTER_TRACKING.md contains current project status
- **Feature Hierarchy**: PRDs → Epics → Features → Tasks
- **HIL Phases**: 8-phase development workflow (development → testing → validation → ci-cd → preview → production → documentation → feedback-triage)

## Command Integration
AgAIle OS commands are available with @ mentions:
- @create-feature: Generate new features from roadmap or user input
- @create-tasks: Break down features into structured tasks
- @execute-tasks: Implement tasks through HIL workflow
- @verify-deployment: Pre-deployment validation
- @ci-cd: Deployment pipeline management
- @documenter: Documentation consolidation

## Development Guidelines
1. **HIL Workflow First**: Follow 8-phase methodology for all development
2. **Feature Tracking**: Update MASTER_TRACKING.md for all progress
3. **Agent Integration**: Leverage specialized agents for complex workflows
4. **Quality Gates**: Respect HIL phase requirements and approval processes

## File Structure Context
- `.agaile-os/features/active/`: Current feature specifications
- `.agaile-os/prds/active/`: Product requirements and customer problems
- `.agaile-os/epics/active/`: Strategic initiatives and coordination
- `.agaile-os/instructions/`: Workflow instruction definitions
- `.agaile-os/shared/`: Common utilities and shared components

## Technical Context
- **Framework**: Next.js 14 with TypeScript
- **Database**: PostgreSQL via Supabase
- **Deployment**: Vercel
- **Package Manager**: pnpm (required)
- **Architecture**: Three-tier (Host → Agency → Client)

## Code Standards
- Use TypeScript with strict mode
- Follow existing patterns and conventions
- Maintain test coverage requirements
- Update documentation as needed
- Respect security and validation patterns

## HIL Phase Awareness
Before suggesting code changes, check:
1. Current feature phase in MASTER_TRACKING.md
2. Required approvals for the current phase
3. Dependencies and blockers
4. Quality gates and success criteria

## Integration Points
- **Database**: Use /db-migrate for schema changes
- **TypeScript**: Use /typescripter for error resolution
- **Deployment**: Use /verify-deployment and /ci-cd
- **Documentation**: Use /documenter for knowledge management

## Error Handling
- Respect HIL approval levels and confirmation requirements
- Provide rollback procedures for destructive operations
- Maintain audit trails for significant changes
- Follow security best practices consistently

This context enables Cursor to work effectively within the AgAIle OS framework and HIL workflow methodology.
EOF

    print_success ".cursorrules file generated"
}

# Check IDE availability and versions
check_ide_availability() {
    print_status "Checking IDE availability..."
    
    local ides_found=()
    
    # Check for Claude Code
    if command -v claude &> /dev/null; then
        local claude_version=$(claude --version 2>/dev/null || echo "unknown")
        print_success "Claude Code found (version: $claude_version)"
        ides_found+=("claude")
    else
        print_info "Claude Code not found - will skip Claude integration"
    fi
    
    # Check for Cursor (by looking for cursor command or typical installation paths)
    if command -v cursor &> /dev/null; then
        print_success "Cursor found"
        ides_found+=("cursor")
    elif [[ -d "/Applications/Cursor.app" ]] || [[ -d "$HOME/.cursor" ]]; then
        print_success "Cursor installation detected"
        ides_found+=("cursor")
    else
        print_info "Cursor not found - will skip Cursor integration"
    fi
    
    # Check for VSCode
    if command -v code &> /dev/null; then
        print_info "VSCode found (integration planned for future release)"
    fi
    
    if [[ ${#ides_found[@]} -eq 0 ]]; then
        print_warning "No supported IDEs found"
        print_info "Please install Claude Code or Cursor for AgAIle OS integration"
        return 1
    fi
    
    echo "${ides_found[@]}"
}

# Main installation function
install_agaile_os_integration() {
    local project_root=$(detect_project_root)
    local agaile_dir="$project_root/.agaile-os"
    
    print_header "AgAIle OS Multi-IDE Integration Setup"
    
    # Validate existing installation
    if ! validate_agaile_os "$project_root"; then
        print_error "AgAIle OS installation validation failed"
        exit 1
    fi
    
    # Install dependencies
    if ! install_dependencies "$agaile_dir"; then
        print_error "Failed to install dependencies"
        exit 1
    fi
    
    # Check available IDEs
    local available_ides=($(check_ide_availability))
    
    if [[ ${#available_ides[@]} -eq 0 ]]; then
        print_error "No supported IDEs available for integration"
        exit 1
    fi
    
    # Setup integrations for available IDEs
    local success_count=0
    
    for ide in "${available_ides[@]}"; do
        case "$ide" in
            "claude")
                if setup_claude_integration "$project_root"; then
                    ((success_count++))
                fi
                ;;
            "cursor")
                if setup_cursor_integration "$project_root"; then
                    ((success_count++))
                fi
                ;;
            *)
                print_warning "Unknown IDE: $ide"
                ;;
        esac
    done
    
    # Final status
    if [[ $success_count -gt 0 ]]; then
        print_success "AgAIle OS integration completed successfully!"
        print_info "Integrated IDEs: ${available_ides[*]}"
        print_info "Configuration: $agaile_dir/config.yml"
        print_info "Master Tracking: $agaile_dir/MASTER_TRACKING.md"
        
        echo ""
        print_header "Next Steps"
        print_info "1. Review generated commands in your IDE(s)"
        print_info "2. Test basic commands like /create-feature or @create-feature"
        print_info "3. Check MASTER_TRACKING.md for current project status"
        print_info "4. Explore .agaile-os/ directory for framework components"
        echo ""
    else
        print_error "AgAIle OS integration failed"
        exit 1
    fi
}

# Export functions for use in other scripts
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Script is being executed directly, not sourced
    case "${1:-}" in
        "install")
            install_agaile_os_integration
            ;;
        "update")
            update_config
            ;;
        "watch")
            watch_mode
            ;;
        *)
            echo "AgAIle OS Setup Functions"
            echo "Usage:"
            echo "  $0 install  - Install AgAIle OS integration for available IDEs"
            echo "  $0 update   - Update configuration and regenerate commands"
            echo "  $0 watch    - Watch for changes and auto-regenerate commands"
            echo ""
            echo "This script can also be sourced to use individual functions"
            ;;
    esac
fi