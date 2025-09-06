#!/usr/bin/env node

/**
 * AgAIle OS Command Bridge System
 * Provides IDE-agnostic command execution and workflow orchestration
 * Handles commands from Claude Code, Cursor, and other supported IDEs
 */

const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');
const { spawn } = require('child_process');

class CommandBridge {
    constructor(configPath) {
        this.configPath = configPath;
        this.config = this.loadConfig();
        this.projectRoot = this.findProjectRoot();
        this.masterTracking = this.loadMasterTracking();
        this.commandHistory = [];
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

    loadMasterTracking() {
        // Support both new and legacy config paths for master tracking
        const masterTrackingPath = this.config.feature_tracking?.master_tracking || this.config.project?.master_tracking || '.agaile-os/MASTER_TRACKING.md';
        const trackingPath = path.resolve(this.projectRoot, masterTrackingPath);
        
        if (fs.existsSync(trackingPath)) {
            try {
                return fs.readFileSync(trackingPath, 'utf8');
            } catch (error) {
                console.warn(`Failed to load MASTER_TRACKING.md: ${error.message}`);
                return '';
            }
        }
        
        return '';
    }

    /**
     * Execute command with IDE context awareness
     */
    async executeCommand(commandName, options = {}) {
        const {
            sourceIde = 'unknown',
            context = {},
            parameters = {},
            approval = 'auto'
        } = options;

        console.log(`\n🚀 AgAIle OS Command Bridge`);
        console.log(`Command: ${commandName}`);
        console.log(`Source IDE: ${sourceIde}`);
        console.log(`Execution Time: ${new Date().toISOString()}`);

        try {
            // Pre-execution validation
            const validation = await this.validateCommand(commandName, context);
            if (!validation.valid) {
                throw new Error(`Command validation failed: ${validation.reason}`);
            }

            // Load command instruction
            const instruction = await this.loadCommandInstruction(commandName);
            if (!instruction) {
                throw new Error(`Command instruction not found: ${commandName}`);
            }

            // Check HIL workflow requirements
            const hilStatus = this.checkHILWorkflowStatus(commandName, context);
            if (hilStatus.requiresApproval && approval === 'auto') {
                return {
                    success: false,
                    requiresApproval: true,
                    hilPhase: hilStatus.currentPhase,
                    approvalLevel: hilStatus.approvalLevel,
                    message: `Command ${commandName} requires ${hilStatus.approvalLevel} approval in ${hilStatus.currentPhase} phase`
                };
            }

            // Execute the command workflow
            const result = await this.executeWorkflow(commandName, instruction, parameters);

            // Update tracking and logs
            await this.updateTracking(commandName, result, sourceIde);
            
            // Log command execution
            this.logCommandExecution(commandName, sourceIde, result);

            return {
                success: true,
                result: result,
                hilPhase: hilStatus.currentPhase,
                nextPhase: this.getNextHILPhase(hilStatus.currentPhase),
                message: `Command ${commandName} executed successfully`,
                trackingUpdated: true
            };

        } catch (error) {
            console.error(`❌ Command execution failed: ${error.message}`);
            
            this.logCommandExecution(commandName, sourceIde, {
                success: false,
                error: error.message
            });

            return {
                success: false,
                error: error.message,
                suggestions: this.getErrorSuggestions(commandName, error)
            };
        }
    }

    /**
     * Validate command execution requirements
     */
    async validateCommand(commandName, context) {
        // Check if command exists in instructions
        // Resolve instruction path with safe defaults
        const instructionsRoot = this.config.project_types?.default?.instructions || '.agaile-os/instructions';
        const instructionPath = path.join(
            this.projectRoot,
            instructionsRoot,
            'core',
            `${commandName}.md`
        );

        if (!fs.existsSync(instructionPath)) {
            return {
                valid: false,
                reason: `Instruction file not found: ${instructionPath}`
            };
        }

        // Check project state
        if (!fs.existsSync(path.join(this.projectRoot, 'package.json'))) {
            return {
                valid: false,
                reason: 'Not a valid project directory'
            };
        }

        // Check dependencies
        const dependencies = await this.checkDependencies(commandName);
        if (!dependencies.satisfied) {
            return {
                valid: false,
                reason: `Dependencies not satisfied: ${dependencies.missing.join(', ')}`
            };
        }

        return { valid: true };
    }

    /**
     * Load command instruction with @include processing
     */
    async loadCommandInstruction(commandName) {
        const instructionsRoot = this.config.project_types?.default?.instructions || '.agaile-os/instructions';
        const instructionPath = path.join(
            this.projectRoot,
            instructionsRoot,
            'core',
            `${commandName}.md`
        );

        try {
            let content = fs.readFileSync(instructionPath, 'utf8');
            
            // Process @include directives
            content = this.processIncludes(content, path.dirname(instructionPath));
            
            return {
                name: commandName,
                content: content,
                metadata: this.extractMetadata(content),
                path: instructionPath
            };
        } catch (error) {
            console.error(`Failed to load instruction for ${commandName}:`, error.message);
            return null;
        }
    }

    processIncludes(content, basePath) {
        const includePattern = /@([^\s\n]+)/g;
        
        return content.replace(includePattern, (match, includePath) => {
            try {
                const fullPath = path.resolve(basePath, includePath);
                
                if (!fs.existsSync(fullPath)) {
                    return `<!-- MISSING INCLUDE: ${includePath} -->`;
                }

                const includeContent = fs.readFileSync(fullPath, 'utf8');
                return this.processIncludes(includeContent, path.dirname(fullPath));
            } catch (error) {
                return `<!-- ERROR PROCESSING INCLUDE: ${includePath} -->`;
            }
        });
    }

    extractMetadata(content) {
        const frontmatterPattern = /^---\s*\n([\s\S]*?)\n---\s*\n/;
        const match = content.match(frontmatterPattern);
        
        if (match) {
            try {
                return yaml.load(match[1]);
            } catch (error) {
                return {};
            }
        }
        
        return {};
    }

    /**
     * Check HIL workflow status and requirements
     */
    checkHILWorkflowStatus(commandName, context) {
        // Parse current HIL phase from MASTER_TRACKING.md
        const currentPhase = this.getCurrentHILPhase(context.featureName);
        
        // Get command's HIL integration requirements
        const commandConfig = this.config.hil_workflow?.commands?.[commandName] || {};
        
        // Determine approval requirements
        const approvalLevel = this.getRequiredApprovalLevel(commandName, currentPhase);
        
        return {
            currentPhase: currentPhase,
            requiresApproval: approvalLevel !== 'NONE',
            approvalLevel: approvalLevel,
            commandPhase: commandConfig.phase || 'development'
        };
    }

    getCurrentHILPhase(featureName) {
        if (!featureName || !this.masterTracking) {
            return 'development';
        }

        // Parse MASTER_TRACKING.md to extract current phase
        const featurePattern = new RegExp(`${featureName}:\\s*\\n(?:[^\\n]*\\n)*?\\s*phase:\\s*([^\\n]+)`, 'i');
        const match = this.masterTracking.match(featurePattern);
        
        return match ? match[1].trim() : 'development';
    }

    getRequiredApprovalLevel(commandName, currentPhase) {
        // Check command-specific overrides
        const commandOverride = this.config.operation_overrides?.[commandName];
        if (commandOverride?.minimum_approval_level) {
            return commandOverride.minimum_approval_level;
        }

        // Check environment-based requirements
        const environment = process.env.NODE_ENV || 'development';
        const envOverride = this.config.environment_overrides?.[environment];
        if (envOverride?.approval_level) {
            return envOverride.approval_level;
        }

        // Default approval level
        return this.config.user_preferences?.default_approval_level || 'CONFIRM';
    }

    getNextHILPhase(currentPhase) {
        const phases = Object.values(this.config.hil_workflow?.phases || {});
        const currentIndex = phases.indexOf(currentPhase);
        
        if (currentIndex >= 0 && currentIndex < phases.length - 1) {
            return phases[currentIndex + 1];
        }
        
        return currentPhase; // Already at final phase
    }

    /**
     * Execute the actual workflow
     */
    async executeWorkflow(commandName, instruction, parameters) {
        console.log(`\n📋 Executing workflow: ${commandName}`);
        
        // Extract workflow steps from instruction
        const steps = this.parseWorkflowSteps(instruction.content);
        const results = [];

        for (let i = 0; i < steps.length; i++) {
            const step = steps[i];
            console.log(`\n🔄 Step ${i + 1}: ${step.name}`);

            try {
                const stepResult = await this.executeWorkflowStep(step, parameters, instruction.metadata);
                results.push({
                    step: step.name,
                    success: true,
                    result: stepResult
                });
                
                console.log(`✅ Step ${i + 1} completed`);
            } catch (error) {
                console.error(`❌ Step ${i + 1} failed: ${error.message}`);
                results.push({
                    step: step.name,
                    success: false,
                    error: error.message
                });
                
                // Decide whether to continue or abort
                if (step.critical !== false) {
                    throw new Error(`Critical step failed: ${step.name} - ${error.message}`);
                }
            }
        }

        return {
            command: commandName,
            totalSteps: steps.length,
            completedSteps: results.filter(r => r.success).length,
            failedSteps: results.filter(r => !r.success).length,
            results: results,
            success: results.every(r => r.success),
            timestamp: new Date().toISOString()
        };
    }

    parseWorkflowSteps(content) {
        // Simple step parser - looks for ### Step patterns
        const stepPattern = /### Step (\d+):\s*([^\n]+)([\s\S]*?)(?=### Step \d+:|$)/g;
        const steps = [];
        let match;

        while ((match = stepPattern.exec(content)) !== null) {
            steps.push({
                number: parseInt(match[1]),
                name: match[2].trim(),
                content: match[3].trim(),
                critical: true // Default to critical
            });
        }

        return steps;
    }

    async executeWorkflowStep(step, parameters, metadata) {
        // This is a simplified step execution
        // In a full implementation, this would handle different step types
        // like agent deployment, file operations, API calls, etc.
        
        console.log(`Executing: ${step.content.substring(0, 100)}...`);
        
        // Simulate step execution
        await new Promise(resolve => setTimeout(resolve, 500));
        
        return {
            stepName: step.name,
            executed: true,
            parameters: parameters,
            timestamp: new Date().toISOString()
        };
    }

    /**
     * Update project tracking
     */
    async updateTracking(commandName, result, sourceIde) {
        const trackingPath = path.resolve(this.projectRoot, this.config.feature_tracking.master_tracking);
        
        try {
            // Update MASTER_TRACKING.md with command execution results
            let tracking = this.masterTracking;
            
            // Add execution log entry
            const logEntry = `\n<!-- Command Execution Log -->\n` +
                `<!-- ${new Date().toISOString()}: ${commandName} executed via ${sourceIde} -->\n` +
                `<!-- Success: ${result.success}, Steps: ${result.completedSteps}/${result.totalSteps} -->\n`;
            
            tracking += logEntry;
            
            fs.writeFileSync(trackingPath, tracking);
            
            console.log(`📊 Tracking updated: ${trackingPath}`);
        } catch (error) {
            console.error(`Failed to update tracking: ${error.message}`);
        }
    }

    logCommandExecution(commandName, sourceIde, result) {
        const logEntry = {
            timestamp: new Date().toISOString(),
            command: commandName,
            sourceIde: sourceIde,
            success: result.success,
            error: result.error || null,
            duration: result.duration || 0
        };
        
        this.commandHistory.push(logEntry);
        
        // Keep only last 100 entries
        if (this.commandHistory.length > 100) {
            this.commandHistory = this.commandHistory.slice(-100);
        }
    }

    async checkDependencies(commandName) {
        // Check basic dependencies
        const missing = [];
        
        // Check Node.js and package manager
        if (!this.hasNodeModules()) {
            missing.push('node_modules (run package install)');
        }
        
        // Check command-specific dependencies
        switch (commandName) {
            case 'db-migrate':
                if (!this.hasDatabase()) {
                    missing.push('Database connection');
                }
                break;
            case 'verify-deployment':
                if (!this.hasDeploymentConfig()) {
                    missing.push('Deployment configuration');
                }
                break;
        }
        
        return {
            satisfied: missing.length === 0,
            missing: missing
        };
    }

    hasNodeModules() {
        return fs.existsSync(path.join(this.projectRoot, 'node_modules'));
    }

    hasDatabase() {
        return fs.existsSync(path.join(this.projectRoot, 'prisma', 'schema.prisma'));
    }

    hasDeploymentConfig() {
        return fs.existsSync(path.join(this.projectRoot, 'vercel.json')) ||
               fs.existsSync(path.join(this.projectRoot, '.vercel'));
    }

    getErrorSuggestions(commandName, error) {
        const suggestions = [];
        
        if (error.message.includes('not found')) {
            suggestions.push('Check if AgAIle OS is properly installed');
            suggestions.push('Run .agaile-os/setup/install.sh to reinstall');
        }
        
        if (error.message.includes('Dependencies')) {
            suggestions.push('Install project dependencies: pnpm install');
            suggestions.push('Check database configuration');
        }
        
        if (error.message.includes('approval')) {
            suggestions.push('Request required approval from team lead');
            suggestions.push('Check HIL workflow phase requirements');
        }
        
        return suggestions;
    }

    /**
     * Get command status and history
     */
    getStatus() {
        return {
            projectRoot: this.projectRoot,
            configVersion: this.config.framework?.version || 'unknown',
            commandHistory: this.commandHistory.slice(-10), // Last 10 commands
            hilWorkflowEnabled: this.config.hil_workflow?.enabled || false,
            availableCommands: this.getAvailableCommands(),
            lastExecution: this.commandHistory.length > 0 ? 
                this.commandHistory[this.commandHistory.length - 1] : null
        };
    }

    getAvailableCommands() {
        const instructionsDir = path.join(
            this.projectRoot,
            this.config.project_types.default.instructions,
            'core'
        );
        
        if (!fs.existsSync(instructionsDir)) {
            return [];
        }
        
        return fs.readdirSync(instructionsDir)
            .filter(file => file.endsWith('.md'))
            .map(file => path.basename(file, '.md'));
    }
}

// CLI Interface
function main() {
    const args = process.argv.slice(2);
    const command = args[0];
    
    const configPath = path.resolve(process.cwd(), '.agaile-os', 'config.yml');
    const bridge = new CommandBridge(configPath);
    
    switch (command) {
        case 'execute':
            const commandName = args[1];
            const sourceIde = args[2] || 'cli';
            const parameters = JSON.parse(args[3] || '{}');
            
            if (!commandName) {
                console.error('Usage: node command-bridge.js execute <command> [ide] [parameters]');
                process.exit(1);
            }
            
            bridge.executeCommand(commandName, {
                sourceIde: sourceIde,
                parameters: parameters
            }).then(result => {
                console.log('\n📋 Execution Result:');
                console.log(JSON.stringify(result, null, 2));
            }).catch(error => {
                console.error('\n❌ Execution Error:', error.message);
                process.exit(1);
            });
            break;
            
        case 'status':
            const status = bridge.getStatus();
            console.log('\n📊 AgAIle OS Status:');
            console.log(JSON.stringify(status, null, 2));
            break;
            
        case 'commands':
            const commands = bridge.getAvailableCommands();
            console.log('\n📋 Available Commands:');
            commands.forEach(cmd => console.log(`  - ${cmd}`));
            break;
            
        default:
            console.log('AgAIle OS Command Bridge');
            console.log('Usage:');
            console.log('  node command-bridge.js execute <command> [ide] [parameters]');
            console.log('  node command-bridge.js status');
            console.log('  node command-bridge.js commands');
            break;
    }
}

if (require.main === module) {
    main();
}

module.exports = CommandBridge;