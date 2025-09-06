#!/bin/bash

# AgAIle OS Multi-IDE Installation Script
# Installs and configures AgAIle OS for Claude Code and Cursor integration

set -e  # Exit on error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source the shared functions
source "$SCRIPT_DIR/functions.sh"

# Main installation function with enhanced features
main() {
    local force_reinstall=false
    local watch_mode=false
    local quiet_mode=false
    local ide_filter=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --force|-f)
                force_reinstall=true
                shift
                ;;
            --watch|-w)
                watch_mode=true
                shift
                ;;
            --quiet|-q)
                quiet_mode=true
                shift
                ;;
            --ide)
                ide_filter="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Suppress some output in quiet mode
    if [[ "$quiet_mode" == "true" ]]; then
        exec 3>&1
        exec 1>/dev/null
    fi
    
    print_header "AgAIle OS Multi-IDE Integration Installer"
    
    # Check if already installed
    if [[ "$force_reinstall" != "true" ]] && check_existing_installation; then
        print_info "AgAIle OS integration already installed"
        print_info "Use --force to reinstall or --watch to start watch mode"
        
        if [[ "$watch_mode" == "true" ]]; then
            watch_mode
        fi
        
        exit 0
    fi
    
    # Perform pre-installation checks
    perform_pre_checks
    
    # Run the installation
    run_installation "$ide_filter"
    
    # Post-installation tasks
    run_post_installation
    
    # Start watch mode if requested
    if [[ "$watch_mode" == "true" ]]; then
        print_info "Starting watch mode..."
        watch_mode
    fi
    
    # Restore output if in quiet mode
    if [[ "$quiet_mode" == "true" ]]; then
        exec 1>&3
        exec 3>&-
    fi
}

# Show help information
show_help() {
    cat << EOF
AgAIle OS Multi-IDE Installation Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --force, -f         Force reinstallation even if already installed
    --watch, -w         Start watch mode after installation
    --quiet, -q         Suppress non-essential output
    --ide IDE           Install only for specific IDE (claude|cursor)
    --help, -h          Show this help message

EXAMPLES:
    $0                  # Standard installation
    $0 --force          # Force reinstall
    $0 --watch          # Install and start watching for changes
    $0 --ide cursor     # Install only Cursor integration

DESCRIPTION:
    This script installs and configures AgAIle OS integration for supported IDEs:
    - Claude Code: Full HIL workflow integration with specialized agents
    - Cursor: Command mapping and .cursorrules generation
    
    The installer:
    1. Validates the existing AgAIle OS installation
    2. Installs necessary dependencies
    3. Generates IDE-specific commands from unified instructions
    4. Creates IDE configuration files
    5. Provides setup verification and next steps

EOF
}

# Check for existing installation
check_existing_installation() {
    local project_root="$PROJECT_ROOT"
    
    # Check for generated commands
    if [[ -d "$project_root/.claude/commands" ]] || [[ -d "$project_root/.cursor/commands" ]]; then
        return 0  # Installation exists
    fi
    
    return 1  # No installation found
}

# Perform pre-installation system checks
perform_pre_checks() {
    print_status "Performing pre-installation checks..."
    
    # Check Node.js availability
    if ! command -v node &> /dev/null; then
        print_error "Node.js is required but not found"
        print_info "Please install Node.js from https://nodejs.org/"
        exit 1
    fi
    
    local node_version=$(node --version | sed 's/v//')
    local required_version="14.0.0"
    
    if ! version_gte "$node_version" "$required_version"; then
        print_error "Node.js version $node_version is too old (requires >= $required_version)"
        exit 1
    fi
    
    print_success "Node.js version $node_version is compatible"
    
    # Check package manager
    local package_manager=""
    if [[ -f "$PROJECT_ROOT/pnpm-lock.yaml" ]]; then
        if command -v pnpm &> /dev/null; then
            package_manager="pnpm"
        else
            print_error "Project uses pnpm but pnpm is not installed"
            print_info "Install with: npm install -g pnpm"
            exit 1
        fi
    elif [[ -f "$PROJECT_ROOT/yarn.lock" ]]; then
        if command -v yarn &> /dev/null; then
            package_manager="yarn"
        else
            print_error "Project uses yarn but yarn is not installed"
            exit 1
        fi
    else
        package_manager="npm"
    fi
    
    print_success "Package manager: $package_manager"
    
    # Check disk space (basic check)
    local available_space=$(df "$PROJECT_ROOT" | tail -1 | awk '{print $4}')
    if [[ $available_space -lt 100000 ]]; then  # Less than ~100MB
        print_warning "Low disk space detected. Installation may fail."
    fi
}

# Version comparison utility
version_gte() {
    local version1="$1"
    local version2="$2"
    
    # Simple version comparison (works for major.minor.patch)
    if [[ "$(printf '%s\n' "$version2" "$version1" | sort -V | head -n1)" == "$version2" ]]; then
        return 0
    else
        return 1
    fi
}

# Run the main installation process
run_installation() {
    local ide_filter="$1"
    
    print_status "Starting AgAIle OS installation process..."
    
    # Change to project root
    cd "$PROJECT_ROOT"
    
    # Call the main installation function from functions.sh
    if [[ -n "$ide_filter" ]]; then
        print_info "Installing for IDE: $ide_filter"
        # Custom installation for specific IDE
        install_specific_ide "$ide_filter"
    else
        # Full installation
        install_agaile_os_integration
    fi
}

# Install for specific IDE
install_specific_ide() {
    local ide="$1"
    local project_root="$PROJECT_ROOT"
    local agaile_dir="$project_root/.agaile-os"
    
    # Validate installation
    if ! validate_agaile_os "$project_root"; then
        print_error "AgAIle OS installation validation failed"
        exit 1
    fi
    
    # Install dependencies
    if ! install_dependencies "$agaile_dir"; then
        print_error "Failed to install dependencies"
        exit 1
    fi
    
    # Setup specific IDE
    case "$ide" in
        "claude"|"claude_code")
            if setup_claude_integration "$project_root"; then
                print_success "Claude Code integration completed"
            else
                print_error "Claude Code integration failed"
                exit 1
            fi
            ;;
        "cursor")
            if setup_cursor_integration "$project_root"; then
                print_success "Cursor integration completed"
            else
                print_error "Cursor integration failed"
                exit 1
            fi
            ;;
        *)
            print_error "Unknown IDE: $ide"
            print_info "Supported IDEs: claude, cursor"
            exit 1
            ;;
    esac
}

# Run post-installation tasks
run_post_installation() {
    print_status "Running post-installation verification..."
    
    # Verify command generation
    local commands_generated=false
    
    if [[ -d "$PROJECT_ROOT/.claude/commands" ]] && [[ "$(ls -A "$PROJECT_ROOT/.claude/commands" 2>/dev/null)" ]]; then
        local claude_count=$(ls -1 "$PROJECT_ROOT/.claude/commands"/*.md 2>/dev/null | wc -l || echo "0")
        print_success "Claude commands generated: $claude_count files"
        commands_generated=true
    fi
    
    if [[ -d "$PROJECT_ROOT/.cursor/commands" ]] && [[ "$(ls -A "$PROJECT_ROOT/.cursor/commands" 2>/dev/null)" ]]; then
        local cursor_count=$(ls -1 "$PROJECT_ROOT/.cursor/commands"/*.md 2>/dev/null | wc -l || echo "0")
        print_success "Cursor commands generated: $cursor_count files"
        commands_generated=true
    fi
    
    if [[ -f "$PROJECT_ROOT/.cursorrules" ]]; then
        print_success ".cursorrules file created"
    fi
    
    if [[ "$commands_generated" == "false" ]]; then
        print_warning "No commands were generated - check IDE availability"
    fi
    
    # Create installation marker
    local marker_file="$PROJECT_ROOT/.agaile-os/.installation-complete"
    echo "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" > "$marker_file"
    
    print_success "Installation verification completed"
}

# Watch mode functionality
watch_mode() {
    local shared_dir="$PROJECT_ROOT/.agaile-os/shared"
    
    if [[ ! -f "$shared_dir/command-processor.js" ]]; then
        print_error "Command processor not found. Please run installation first."
        exit 1
    fi
    
    print_header "AgAIle OS Watch Mode"
    print_info "Monitoring for instruction changes..."
    print_info "Press Ctrl+C to stop"
    
    cd "$shared_dir"
    node command-processor.js watch
}

# Handle script interruption
cleanup() {
    print_info "Installation interrupted. Cleaning up..."
    # Add any necessary cleanup here
    exit 1
}

# Set up signal handlers
trap cleanup INT TERM

# Run main function with all arguments
main "$@"