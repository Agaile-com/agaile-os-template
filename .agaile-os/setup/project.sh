#!/bin/bash

# AgAIle OS Project Setup Script
# Sets up AgAIle OS framework in a new or existing project

set -e  # Exit on error

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the shared functions
source "$SCRIPT_DIR/functions.sh"

# Project setup configuration
PROJECT_TYPES=(
    "nextjs:Next.js Project with TypeScript"
    "react:React Application"
    "nodejs:Node.js Backend Project"
    "fullstack:Full-stack Application"
    "default:Generic Project"
)

# Main project setup function
main() {
    local project_type=""
    local project_name=""
    local force_setup=false
    local include_examples=false
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --type|-t)
                project_type="$2"
                shift 2
                ;;
            --name|-n)
                project_name="$2"
                shift 2
                ;;
            --force|-f)
                force_setup=true
                shift
                ;;
            --examples|-e)
                include_examples=true
                shift
                ;;
            --help|-h)
                show_project_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_project_help
                exit 1
                ;;
        esac
    done
    
    print_header "AgAIle OS Project Setup"
    
    # Detect project context
    local project_root=$(detect_project_root)
    local current_project_name=$(basename "$project_root")
    
    # Use detected name if not provided
    if [[ -z "$project_name" ]]; then
        project_name="$current_project_name"
    fi
    
    print_info "Project: $project_name"
    print_info "Location: $project_root"
    
    # Check for existing AgAIle OS installation
    if [[ -d "$project_root/.agaile-os" ]] && [[ "$force_setup" != "true" ]]; then
        print_warning "AgAIle OS already exists in this project"
        print_info "Use --force to overwrite existing installation"
        
        # Offer to run IDE integration instead
        read -p "Would you like to setup IDE integration instead? (y/n): " -r
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            "$SCRIPT_DIR/install.sh"
            exit 0
        fi
        
        exit 1
    fi
    
    # Detect or select project type
    if [[ -z "$project_type" ]]; then
        project_type=$(detect_project_type "$project_root")
        
        if [[ -z "$project_type" ]]; then
            project_type=$(select_project_type)
        fi
    fi
    
    print_info "Project type: $project_type"
    
    # Create AgAIle OS structure
    setup_agaile_os_structure "$project_root" "$project_name" "$project_type"
    
    # Create initial project files
    create_initial_files "$project_root" "$project_name" "$project_type"
    
    # Setup examples if requested
    if [[ "$include_examples" == "true" ]]; then
        setup_example_content "$project_root" "$project_type"
    fi
    
    # Run IDE integration
    print_status "Setting up IDE integration..."
    "$SCRIPT_DIR/install.sh" --quiet
    
    # Final success message
    print_success "AgAIle OS project setup completed!"
    show_next_steps "$project_root"
}

# Show help for project setup
show_project_help() {
    cat << EOF
AgAIle OS Project Setup Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --type, -t TYPE     Project type (nextjs|react|nodejs|fullstack|default)
    --name, -n NAME     Project name (defaults to directory name)
    --force, -f         Force setup even if AgAIle OS already exists
    --examples, -e      Include example content and templates
    --help, -h          Show this help message

EXAMPLES:
    $0                           # Auto-detect project type
    $0 --type nextjs             # Setup for Next.js project
    $0 --type fullstack --examples  # Setup with example content

PROJECT TYPES:
EOF
    
    for type_info in "${PROJECT_TYPES[@]}"; do
        local type_name="${type_info%%:*}"
        local type_desc="${type_info#*:}"
        printf "    %-12s %s\n" "$type_name" "$type_desc"
    done
}

# Detect project type from existing files
detect_project_type() {
    local project_root="$1"
    
    # Check for Next.js
    if [[ -f "$project_root/next.config.js" ]] || [[ -f "$project_root/next.config.ts" ]]; then
        echo "nextjs"
        return
    fi
    
    # Check for React
    if [[ -f "$project_root/package.json" ]] && grep -q '"react"' "$project_root/package.json"; then
        echo "react"
        return
    fi
    
    # Check for Node.js backend
    if [[ -f "$project_root/package.json" ]] && grep -q '"express"' "$project_root/package.json"; then
        echo "nodejs"
        return
    fi
    
    # Check for full-stack indicators
    if [[ -d "$project_root/client" ]] && [[ -d "$project_root/server" ]]; then
        echo "fullstack"
        return
    fi
    
    # Default
    echo ""
}

# Interactive project type selection
select_project_type() {
    echo ""
    print_status "Select project type:"
    
    local i=1
    for type_info in "${PROJECT_TYPES[@]}"; do
        local type_name="${type_info%%:*}"
        local type_desc="${type_info#*:}"
        echo "  $i) $type_name - $type_desc"
        ((i++))
    done
    
    while true; do
        read -p "Enter selection (1-${#PROJECT_TYPES[@]}): " -r selection
        
        if [[ "$selection" =~ ^[1-9]$ ]] && [[ $selection -le ${#PROJECT_TYPES[@]} ]]; then
            local selected_type="${PROJECT_TYPES[$((selection-1))]}"
            echo "${selected_type%%:*}"
            return
        else
            print_error "Invalid selection. Please enter a number between 1 and ${#PROJECT_TYPES[@]}"
        fi
    done
}

# Create the AgAIle OS directory structure
setup_agaile_os_structure() {
    local project_root="$1"
    local project_name="$2"
    local project_type="$3"
    
    print_status "Creating AgAIle OS directory structure..."
    
    local agaile_dir="$project_root/.agaile-os"
    
    # Create main directories
    local directories=(
        "$agaile_dir"
        "$agaile_dir/instructions/core"
        "$agaile_dir/instructions/meta"
        "$agaile_dir/standards"
        "$agaile_dir/shared"
        "$agaile_dir/setup"
        "$agaile_dir/commands"
        "$agaile_dir/commands/templates"
        "$agaile_dir/features/active"
        "$agaile_dir/features/completed"
        "$agaile_dir/prds/active"
        "$agaile_dir/prds/templates"
        "$agaile_dir/epics/active"
        "$agaile_dir/epics/completed"
        "$agaile_dir/product"
        "$agaile_dir/architecture"
        "$agaile_dir/compliance"
        "$agaile_dir/testing"
        "$agaile_dir/checklists"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$dir"
    done
    
    print_success "Directory structure created"
}

# Create initial project files
create_initial_files() {
    local project_root="$1"
    local project_name="$2"
    local project_type="$3"
    
    print_status "Creating initial project files..."
    
    local agaile_dir="$project_root/.agaile-os"
    
    # Copy or create config.yml
    if [[ -f "$SCRIPT_DIR/../config.yml" ]]; then
        cp "$SCRIPT_DIR/../config.yml" "$agaile_dir/"
        # Update project name in config
        sed -i.bak "s/name: \"agaile-os-template\"/name: \"$project_name\"/" "$agaile_dir/config.yml" && rm "$agaile_dir/config.yml.bak"
    fi
    
    # Copy shared utilities
    if [[ -d "$SCRIPT_DIR/../shared" ]]; then
        cp -r "$SCRIPT_DIR/../shared"/* "$agaile_dir/shared/"
    fi
    
    # Copy setup scripts
    cp "$SCRIPT_DIR"/* "$agaile_dir/setup/"
    
    # Create basic MASTER_TRACKING.md
    create_master_tracking "$agaile_dir" "$project_name" "$project_type"
    
    # Create basic product files
    create_product_files "$agaile_dir" "$project_name" "$project_type"
    
    print_success "Initial files created"
}

# Create MASTER_TRACKING.md template
create_master_tracking() {
    local agaile_dir="$1"
    local project_name="$2"
    local project_type="$3"
    
    cat > "$agaile_dir/MASTER_TRACKING.md" << EOF
# $project_name AgAIle OS - Master Tracking Document

**Last Updated**: $(date +"%Y-%m-%d")  
**Framework Version**: 1.0  
**Current Release**: v0.1 (0% complete)

## Overview

This master tracking document provides centralized oversight of $project_name's development initiatives, linking strategic roadmap phases to customer problems (PRDs), strategic initiatives (Epics), and technical execution (Features).

## Framework Structure

\`\`\`
Customer Voice → PRD (Problem) → Epic (Strategy) → Feature (Solution) → Task (Implementation)
\`\`\`

### Project Information

- **Project Type**: $project_type
- **AgAIle OS Framework**: Enabled
- **HIL Workflow**: Active
- **Multi-IDE Integration**: Configured

### Hierarchical Organization

- **PRDs**: Customer problem consolidation and business requirements
- **Epics**: Strategic coordination of related PRDs and features  
- **Features**: Technical solutions delivering customer value
- **Tasks**: Granular implementation work (tracked in HIL workflow)

## HIL Phase Status

### Active Features Pipeline

*No features currently defined. Use \`/create-feature\` to begin.*

## Current Sprint Status

**Sprint**: Not yet defined  
**Duration**: TBD  
**Focus**: Project initialization and first feature planning

### Sprint Goals
- [ ] Complete project setup and configuration
- [ ] Define initial roadmap and priorities
- [ ] Create first feature specifications
- [ ] Establish development workflow

## Next Actions

1. **Define Project Vision**: Create product/mission.md
2. **Set Technical Stack**: Update product/tech-stack.md  
3. **Plan First Feature**: Use \`/create-feature\` command
4. **Initialize Development**: Begin HIL workflow

## Integration Status

- ✅ AgAIle OS Framework: Installed
- ✅ Multi-IDE Support: Configured
- ✅ HIL Workflow: Ready
- ⏳ First Feature: Pending
- ⏳ Development Team: Setup needed

---
*This document is automatically updated by the HIL workflow system*
EOF
}

# Create basic product files
create_product_files() {
    local agaile_dir="$1"
    local project_name="$2"
    local project_type="$3"
    
    # Create mission-lite.md
    cat > "$agaile_dir/product/mission-lite.md" << EOF
# $project_name - Mission Statement

## Core Purpose

*Define the core purpose and value proposition of $project_name*

## Target Users

*Describe the primary users and their needs*

## Key Value Propositions

1. **Primary Value**: *What is the main value delivered?*
2. **Differentiation**: *How is this different from alternatives?*
3. **Impact**: *What positive change does this create?*

## Success Metrics

- *Key metric 1*
- *Key metric 2* 
- *Key metric 3*

---
*Update this file to reflect your project's specific mission and goals*
EOF

    # Create tech-stack.md based on project type
    create_tech_stack_file "$agaile_dir/product/tech-stack.md" "$project_type"
    
    # Create basic roadmap
    cat > "$agaile_dir/product/roadmap.md" << EOF
# $project_name - Product Roadmap

## Current Phase: Initialization

### Phase 1: Foundation (Month 1)
- [ ] Project setup and configuration
- [ ] Core architecture definition
- [ ] First feature implementation
- [ ] Basic testing infrastructure

### Phase 2: Core Features (Month 2-3)
- [ ] *Define core features based on mission*
- [ ] User interface implementation
- [ ] Data management setup
- [ ] Quality assurance processes

### Phase 3: Polish & Launch (Month 4)
- [ ] Performance optimization
- [ ] Documentation completion
- [ ] Deployment preparation  
- [ ] Launch readiness validation

## Long-term Vision

*Define the 6-12 month vision for $project_name*

---
*This roadmap should be updated as the project evolves*
EOF
}

# Create tech stack file based on project type
create_tech_stack_file() {
    local file_path="$1"
    local project_type="$2"
    
    case "$project_type" in
        "nextjs")
            cat > "$file_path" << 'EOF'
# Technical Stack

## Frontend Framework
- **Next.js 14**: React framework with App Router
- **TypeScript**: Type-safe JavaScript development
- **Tailwind CSS**: Utility-first CSS framework

## Backend & Database
- **Next.js API Routes**: Serverless API endpoints
- **Database**: *Choose: PostgreSQL, MongoDB, or other*
- **ORM**: *Choose: Prisma, Drizzle, or other*

## Development Tools
- **Package Manager**: pnpm (recommended)
- **Linting**: ESLint with TypeScript support
- **Testing**: Jest + Testing Library
- **Deployment**: Vercel (recommended)

## AgAIle OS Integration
- **HIL Workflow**: 8-phase development methodology
- **Multi-IDE**: Claude Code + Cursor support
- **Command System**: Automated workflow execution
EOF
            ;;
        "react")
            cat > "$file_path" << 'EOF'
# Technical Stack

## Frontend
- **React 18**: Modern React with hooks
- **TypeScript**: Type-safe development
- **CSS Framework**: *Choose: Tailwind, Material-UI, or other*
- **State Management**: *Choose: Context, Redux, Zustand, or other*

## Build Tools
- **Bundler**: *Choose: Vite, Webpack, or other*
- **Package Manager**: pnpm (recommended)

## Testing & Quality
- **Testing**: Jest + React Testing Library
- **Linting**: ESLint + Prettier
- **Type Checking**: TypeScript strict mode

## AgAIle OS Integration
- **HIL Workflow**: 8-phase development methodology
- **Multi-IDE**: Claude Code + Cursor support
- **Command System**: Automated workflow execution
EOF
            ;;
        "nodejs")
            cat > "$file_path" << 'EOF'
# Technical Stack

## Runtime & Framework
- **Node.js**: JavaScript runtime
- **Framework**: *Choose: Express, Fastify, Koa, or other*
- **TypeScript**: Type-safe server development

## Database & Storage
- **Database**: *Choose: PostgreSQL, MongoDB, Redis, or other*
- **ORM/ODM**: *Choose: Prisma, Mongoose, or other*

## Development Tools
- **Package Manager**: pnpm (recommended)
- **Process Manager**: *Choose: PM2, nodemon, or other*
- **Testing**: Jest + Supertest
- **Linting**: ESLint with TypeScript

## AgAIle OS Integration
- **HIL Workflow**: 8-phase development methodology
- **Multi-IDE**: Claude Code + Cursor support
- **Command System**: Automated workflow execution
EOF
            ;;
        *)
            cat > "$file_path" << 'EOF'
# Technical Stack

## Core Technologies
*Define your primary programming languages and frameworks*

## Development Tools
- **Package Manager**: *Specify package manager*
- **Build System**: *Specify build tools*
- **Testing Framework**: *Specify testing approach*
- **Quality Tools**: *Specify linting, formatting, etc.*

## Infrastructure
- **Deployment**: *Specify deployment platform*
- **Database**: *Specify data storage solution*
- **Monitoring**: *Specify monitoring and logging*

## AgAIle OS Integration
- **HIL Workflow**: 8-phase development methodology
- **Multi-IDE**: Claude Code + Cursor support
- **Command System**: Automated workflow execution

---
*Customize this file to match your project's specific technical requirements*
EOF
            ;;
    esac
}

# Setup example content
setup_example_content() {
    local project_root="$1"
    local project_type="$2"
    
    print_status "Setting up example content..."
    
    local agaile_dir="$project_root/.agaile-os"
    
    # Create example PRD
    create_example_prd "$agaile_dir"
    
    # Create example feature
    create_example_feature "$agaile_dir"
    
    print_success "Example content created"
}

# Create example PRD
create_example_prd() {
    local agaile_dir="$1"
    
    cat > "$agaile_dir/prds/active/example-user-authentication.md" << 'EOF'
# PRD: User Authentication System

**Status**: Example  
**Priority**: High  
**Epic**: User Management  
**Created**: Example PRD for demonstration

## Problem Statement

Users need a secure and user-friendly way to access the application, with proper authentication and authorization mechanisms.

## Customer Voice

*"I want to securely log into the application without compromising my personal information."*

## Requirements

### Functional Requirements
- [ ] User registration with email verification
- [ ] Secure login/logout functionality
- [ ] Password reset capability
- [ ] Role-based access control
- [ ] Session management

### Non-Functional Requirements
- [ ] Security: Industry-standard encryption
- [ ] Performance: <2s login response time
- [ ] Usability: Intuitive authentication flow
- [ ] Reliability: 99.9% uptime for auth service

## Success Metrics

- **Conversion Rate**: >85% successful registrations
- **Security**: Zero authentication breaches
- **User Experience**: <3 clicks to complete login
- **Performance**: <2s average response time

## Out of Scope

- Social media login integration (future phase)
- Multi-factor authentication (future enhancement)
- Enterprise SSO (future feature)

---
*This is an example PRD. Delete or modify as needed for your project.*
EOF
}

# Create example feature
create_example_feature() {
    local agaile_dir="$1"
    
    mkdir -p "$agaile_dir/features/active/user-authentication"
    
    cat > "$agaile_dir/features/active/user-authentication/feature .md" << 'EOF'
# Feature: User Authentication System

**Status**: Example  
**Epic**: User Management  
**PRD**: user-authentication.md  
**Created**: Example feature for demonstration

## Overview

Implement a secure user authentication system that handles registration, login, and session management with proper security measures.

## Technical Specification

### Architecture
- **Frontend**: Authentication forms and state management
- **Backend**: API endpoints for auth operations
- **Database**: User credentials and session storage
- **Security**: Encryption and validation

### Implementation Plan

#### Phase 1: Core Authentication
- [ ] User registration endpoint
- [ ] Login/logout functionality
- [ ] Password encryption (bcrypt)
- [ ] JWT token management

#### Phase 2: Enhanced Security
- [ ] Email verification
- [ ] Password reset flow
- [ ] Rate limiting
- [ ] Security headers

#### Phase 3: User Experience
- [ ] Remember me functionality
- [ ] Session timeout handling
- [ ] Error messaging
- [ ] Loading states

### API Design

```typescript
// Registration
POST /api/auth/register
{
  email: string;
  password: string;
  confirmPassword: string;
}

// Login
POST /api/auth/login
{
  email: string;
  password: string;
}

// Logout
POST /api/auth/logout
```

### Database Schema

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  email_verified BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

## Quality Gates

### Development
- [ ] All endpoints implemented
- [ ] Input validation complete
- [ ] Error handling implemented
- [ ] Code review completed

### Testing
- [ ] Unit tests: >90% coverage
- [ ] Integration tests: All endpoints
- [ ] Security tests: Auth vulnerabilities
- [ ] Performance tests: Response times

### Deployment
- [ ] Environment variables configured
- [ ] Database migrations applied
- [ ] Security headers configured
- [ ] Monitoring alerts setup

## Dependencies

- **Internal**: Database setup, base API structure
- **External**: Email service for verification
- **Technical**: JWT library, bcrypt library

## Success Criteria

- [ ] Users can register and login successfully
- [ ] Passwords are securely encrypted
- [ ] Sessions are properly managed
- [ ] Security best practices implemented
- [ ] All tests passing

---
*This is an example feature specification. Delete or modify as needed for your project.*
EOF
}

# Show next steps after setup
show_next_steps() {
    local project_root="$1"
    
    print_header "Next Steps"
    
    echo ""
    print_info "AgAIle OS is now set up in your project! Here's what you can do next:"
    echo ""
    
    print_status "1. Review Configuration"
    echo "   - Check .agaile-os/config.yml for framework settings"
    echo "   - Review .agaile-os/MASTER_TRACKING.md for project status"
    echo ""
    
    print_status "2. Define Your Project"
    echo "   - Update .agaile-os/product/mission-lite.md with your project vision"
    echo "   - Customize .agaile-os/product/tech-stack.md for your technology choices"
    echo "   - Plan your roadmap in .agaile-os/product/roadmap.md"
    echo ""
    
    print_status "3. Start Development"
    echo "   - Use '/create-feature' or '@create-feature' to create your first feature"
    echo "   - Use '/create-tasks' to break down features into tasks"
    echo "   - Use '/execute-tasks' to implement features through HIL workflow"
    echo ""
    
    print_status "4. Available Commands"
    echo "   - Claude Code: Commands prefixed with '/'"
    echo "   - Cursor: Commands available via '@' mentions"
    echo "   - See generated command files in .claude/commands/ and .cursor/commands/"
    echo ""
    
    print_status "5. Learn More"
    echo "   - Explore .agaile-os/ directory structure"
    echo "   - Check out example content (if included)"
    echo "   - Read HIL workflow documentation"
    echo ""
    
    print_success "Happy coding with AgAIle OS! 🚀"
}

# Handle script interruption
cleanup() {
    print_info "Setup interrupted. Cleaning up..."
    exit 1
}

# Set up signal handlers
trap cleanup INT TERM

# Run main function with all arguments
main "$@"