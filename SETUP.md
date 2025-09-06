# Agaile-OS Setup Guide

This guide walks you through setting up Agaile-OS for a new project, from installing the necessary tools to configuring your project-specific settings.

## Prerequisites

### 1. Install Cursor IDE
1. Download Cursor from [https://cursor.com/downloads](https://cursor.com/downloads)
2. Install and launch Cursor
3. Configure Cursor with your preferred settings

### 2. Install Claude Code CLI
1. Follow the installation guide at [https://docs.anthropic.com/en/docs/claude-code/overview](https://docs.anthropic.com/en/docs/claude-code/overview)
2. Install Claude Code CLI:
   ```bash
   npm install -g @anthropic/claude
   ```
3. Verify installation:
   ```bash
   claude --version
   ```

### 3. Initialize Claude Code
1. Initialize Claude in your project directory:
   ```bash
   claude init
   ```
2. Follow the setup prompts to configure Claude for your project
3. This will create the necessary Claude configuration files

## Agaile-OS Setup

### 4. Get the Agaile-OS Template
1. Clone or reference the Agaile-OS template: [https://github.com/Agaile-com/agaile-os-template](https://github.com/Agaile-com/agaile-os-template)
2. Navigate to your project root and run the Agaile-OS setup:
   ```bash
   .agaile-os/setup.sh  
   ```

This setup script will:
- Create the basic Agaile-OS directory structure
- Initialize configuration templates
- Set up agent configurations
- Create standard directories for features, PRDs, and documentation

### 5. Configure Project-Specific Settings

After running the setup script, customize these key files for your project:

#### 5.1 Update Main Configuration
Edit `.agaile-os/config.yml`:
- Update project name
- Configure tech stack details
- Set database connection information
- Adjust agent configurations for your needs

#### 5.2 Define Product Strategy
Update `.agaile-os/product/` directory:
- `mission.md` - Define your project's core mission
- `vision.md` - Articulate the long-term vision
- `roadmap.md` - Create your initial product roadmap

#### 5.3 Configure Technical Standards
Edit `.agaile-os/standards/tech-stack.md`:
- Document your technology choices
- Define coding standards and conventions
- Set up development guidelines specific to your stack

#### 5.4 Initialize Master Tracking
Create `.agaile-os/MASTER_TRACKING.md`:
- Set up your project tracking template
- Define sprint structure and milestones
- Configure progress monitoring format

### 6. Generate IDE Integrations
Run the IDE integration generator:
```bash
.agaile-os/setup/generate-ide-references.sh
```

This script will:
- Create IDE-specific configuration files
- Set up code references and navigation
- Configure debugging and development tools
- Generate project-specific shortcuts and commands

## Verification

After completing the setup, verify everything is working:

1. **Claude Integration**: Run `claude --help` to ensure Claude Code is properly installed
2. **Agaile-OS Structure**: Check that `.agaile-os/` directory contains all necessary files
3. **Configuration**: Verify your project-specific settings are properly configured
4. **IDE Integration**: Test that Cursor can navigate and reference your Agaile-OS setup

## Next Steps

With Agaile-OS set up, you can now:
- Create features using `/create-feature`
- Manage tasks with `/create-tasks` and `/execute-tasks`
- Track progress in `MASTER_TRACKING.md`
- Use specialized agents for development workflows
- Follow the HIL (Human-in-the-Loop) development methodology

## Troubleshooting

If you encounter issues during setup:
1. Ensure you have proper permissions for file creation and script execution
2. Check that all prerequisite tools are properly installed
3. Verify network connectivity for any downloads or updates
4. Review the Agaile-OS documentation in `.agaile-os/README.md` for additional guidance

---

*This setup guide ensures you have a fully configured Agaile-OS environment ready for efficient AI-assisted development.*