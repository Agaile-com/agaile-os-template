#!/usr/bin/env node

/**
 * AgAIle OS Dynamic Command Processor
 * Generates IDE-specific commands from unified instructions with @include support
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

class CommandProcessor {
    constructor(configPath) {
        this.configPath = configPath;
        this.config = this.loadConfig();
        this.projectRoot = this.findProjectRoot();
    }

    loadConfig() {
        try {
            const configContent = fs.readFileSync(this.configPath, 'utf8');
            return yaml.load(configContent);
        } catch (error) {
            console.error(`Failed to load config from ${this.configPath}:`, error.message);
            process.exit(1);
        }
    }

    findProjectRoot() {
        let dir = path.dirname(this.configPath);
        while (dir !== path.dirname(dir)) {
            if (fs.existsSync(path.join(dir, 'package.json')) || 
                fs.existsSync(path.join(dir, '.git'))) {
                return dir;
            }
            dir = path.dirname(dir);
        }
        return path.dirname(this.configPath);
    }

    /**
     * Process @include directives in instruction content
     */
    processIncludes(content, basePath) {
        const includePattern = /@([^\s\n]+)/g;
        
        return content.replace(includePattern, (match, includePath) => {
            try {
                // Handle relative paths
                const fullPath = path.resolve(basePath, includePath);
                
                if (!fs.existsSync(fullPath)) {
                    console.warn(`Include file not found: ${fullPath}`);
                    return `<!-- MISSING INCLUDE: ${includePath} -->`;
                }

                const includeContent = fs.readFileSync(fullPath, 'utf8');
                
                // Recursively process includes in the included content
                return this.processIncludes(includeContent, path.dirname(fullPath));
            } catch (error) {
                console.warn(`Failed to process include ${includePath}:`, error.message);
                return `<!-- ERROR PROCESSING INCLUDE: ${includePath} -->`;
            }
        });
    }

    /**
     * Extract metadata from instruction file
     */
    extractMetadata(content) {
        const frontmatterPattern = /^---\s*\n([\s\S]*?)\n---\s*\n/;
        const match = content.match(frontmatterPattern);
        
        if (match) {
            try {
                return yaml.load(match[1]);
            } catch (error) {
                console.warn('Failed to parse frontmatter:', error.message);
                return {};
            }
        }
        
        return {};
    }

    /**
     * Generate variables for template substitution
     */
    generateVariables(instructionPath, metadata) {
        const commandName = path.basename(instructionPath, '.md');
        const relativePath = path.relative(this.projectRoot, instructionPath);
        
        return {
            command_name: metadata.name || commandName,
            command_description: metadata.description || `Execute ${commandName} workflow`,
            instruction_path: relativePath,
            source_instruction: relativePath,
            model: metadata.model || 'opus',
            color: metadata.color || 'blue',
            agent_integration: metadata.agent || 'general-purpose',
            integration_points: this.formatIntegrationPoints(metadata.integrations || []),
            context_requirements: this.formatContextRequirements(metadata.context || []),
            expected_outcomes: this.formatExpectedOutcomes(metadata.outcomes || []),
            trigger: metadata.trigger || `@${commandName}`,
            project_type: this.config.project_types?.default || 'default',
            dependencies: this.formatDependencies(metadata.dependencies || [])
        };
    }

    formatIntegrationPoints(integrations) {
        if (!Array.isArray(integrations) || integrations.length === 0) {
            return '- AgAIle OS HIL Workflow\n- MASTER_TRACKING.md updates';
        }
        return integrations.map(point => `- ${point}`).join('\n');
    }

    formatContextRequirements(requirements) {
        if (!Array.isArray(requirements) || requirements.length === 0) {
            return '- Project context from .agaile-os/\n- Current HIL phase status';
        }
        return requirements.map(req => `- ${req}`).join('\n');
    }

    formatExpectedOutcomes(outcomes) {
        if (!Array.isArray(outcomes) || outcomes.length === 0) {
            return '- Successful workflow execution\n- Updated project tracking\n- HIL phase progression';
        }
        return outcomes.map(outcome => `- ${outcome}`).join('\n');
    }

    formatDependencies(dependencies) {
        if (!Array.isArray(dependencies) || dependencies.length === 0) {
            return 'None';
        }
        return dependencies.join(', ');
    }

    /**
     * Apply template variables to content
     */
    applyTemplate(templateContent, variables) {
        return templateContent.replace(/\$\{([^}]+)\}/g, (match, varName) => {
            return variables[varName] || match;
        });
    }

    /**
     * Generate command for specific IDE
     */
    generateCommand(instructionPath, targetIde) {
        // Use integrations section from config (fallback-safe)
        const integrations = this.config.integrations || {};
        if (!integrations[targetIde]?.enabled) {
            console.log(`Skipping ${targetIde} - not enabled in config`);
            return null;
        }

        try {
            // Read and process the instruction file
            const instructionContent = fs.readFileSync(instructionPath, 'utf8');
            const processedContent = this.processIncludes(instructionContent, path.dirname(instructionPath));
            const metadata = this.extractMetadata(processedContent);

            // Load the appropriate template (fallback to known defaults)
            const defaultTemplateByIde = {
                claude_code: 'claude_command.md',
                cursor: 'cursor_command.md'
            };

            const configuredTemplate = this.config.command_generation?.mappings?.[targetIde]?.template;
            const templateFile = configuredTemplate || defaultTemplateByIde[targetIde] || 'claude_command.md';

            const templatePath = path.join(
                path.dirname(this.configPath),
                'commands',
                'templates',
                templateFile
            );

            if (!fs.existsSync(templatePath)) {
                console.error(`Template not found: ${templatePath}`);
                return null;
            }

            const templateContent = fs.readFileSync(templatePath, 'utf8');

            // Generate variables and apply template
            const variables = this.generateVariables(instructionPath, metadata);
            const generatedCommand = this.applyTemplate(templateContent, variables);

            return {
                content: generatedCommand,
                metadata: metadata,
                variables: variables
            };
        } catch (error) {
            console.error(`Failed to generate command for ${instructionPath}:`, error.message);
            return null;
        }
    }

    /**
     * Generate all commands for all enabled IDEs
     */
    generateAllCommands() {
        // Determine instructions path with safe defaults
        const configuredInstructions = this.config.project_types?.default?.instructions;
        const instructionsPath = path.resolve(this.projectRoot, configuredInstructions || '.agaile-os/instructions');
        
        if (!fs.existsSync(instructionsPath)) {
            console.error(`Instructions directory not found: ${instructionsPath}`);
            return;
        }

        // Find all instruction files
        const instructionFiles = this.findInstructionFiles(instructionsPath);
        
        console.log(`Found ${instructionFiles.length} instruction files`);

        // Generate commands for each enabled IDE
        const integrations = this.config.integrations || {};
        for (const [ideKey, ideConfig] of Object.entries(integrations)) {
            if (!ideConfig.enabled) continue;

            console.log(`\nGenerating commands for ${ideKey}...`);
            
            // Resolve output path per IDE (use config when present, safe defaults otherwise)
            let targetPath;
            if (ideKey === 'claude_code') {
                const configured = ideConfig.commands_directory || '.claude/commands';
                targetPath = path.resolve(this.projectRoot, configured);
            } else if (ideKey === 'cursor') {
                // Prefer explicit commands directory if present, otherwise default to .cursor/commands
                const configured = ideConfig.commands_directory || '.cursor/commands';
                targetPath = path.resolve(this.projectRoot, configured);
            } else {
                targetPath = path.resolve(this.projectRoot, '.agaile-os/generated', ideKey);
            }
            this.ensureDirectoryExists(targetPath);

            let generatedCount = 0;

            for (const instructionFile of instructionFiles) {
                const command = this.generateCommand(instructionFile, ideKey);
                
                if (command) {
                    const commandName = path.basename(instructionFile, '.md');
                    const outputPath = path.join(targetPath, `${commandName}.md`);
                    
                    fs.writeFileSync(outputPath, command.content);
                    generatedCount++;
                    
                    console.log(`  Generated: ${commandName}.md`);
                }
            }

            console.log(`  Total generated: ${generatedCount} commands`);
        }
    }

    findInstructionFiles(dir) {
        const files = [];
        
        function traverse(currentDir) {
            const entries = fs.readdirSync(currentDir);
            
            for (const entry of entries) {
                const fullPath = path.join(currentDir, entry);
                const stat = fs.statSync(fullPath);
                
                if (stat.isDirectory()) {
                    traverse(fullPath);
                } else if (entry.endsWith('.md')) {
                    files.push(fullPath);
                }
            }
        }
        
        traverse(dir);
        return files;
    }

    ensureDirectoryExists(dirPath) {
        if (!fs.existsSync(dirPath)) {
            fs.mkdirSync(dirPath, { recursive: true });
        }
    }

    /**
     * Watch for changes and regenerate commands
     */
    watchForChanges() {
        const instructionsPath = path.resolve(this.projectRoot, this.config.project_types.default.instructions);
        
        console.log(`Watching for changes in: ${instructionsPath}`);
        
        fs.watch(instructionsPath, { recursive: true }, (eventType, filename) => {
            if (filename && filename.endsWith('.md')) {
                console.log(`Detected change in: ${filename}`);
                setTimeout(() => this.generateAllCommands(), 100); // Debounce
            }
        });
    }
}

// CLI Interface
function main() {
    const args = process.argv.slice(2);
    const command = args[0];
    
    const configPath = path.resolve(process.cwd(), '.agaile-os', 'config.yml');
    const processor = new CommandProcessor(configPath);
    
    switch (command) {
        case 'generate':
            processor.generateAllCommands();
            break;
            
        case 'watch':
            processor.generateAllCommands();
            processor.watchForChanges();
            break;
            
        default:
            console.log('AgAIle OS Command Processor');
            console.log('Usage:');
            console.log('  node command-processor.js generate  - Generate all commands');
            console.log('  node command-processor.js watch     - Generate and watch for changes');
            break;
    }
}

if (require.main === module) {
    main();
}

module.exports = CommandProcessor;