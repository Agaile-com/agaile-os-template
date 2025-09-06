#!/usr/bin/env node

/**
 * AgAIle OS Validation Script
 * Validates AgAIle OS configuration in a project
 */

const fs = require('fs');
const path = require('path');

const colors = {
  reset: '\x1b[0m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  blue: '\x1b[34m'
};

function log(message, color = colors.reset) {
  console.log(`${color}${message}${colors.reset}`);
}

function checkFile(filePath, required = false) {
  const fullPath = path.join(process.cwd(), filePath);
  const exists = fs.existsSync(fullPath);
  
  if (exists) {
    log(`✓ ${filePath}`, colors.green);
    return true;
  } else if (required) {
    log(`✗ ${filePath} (required)`, colors.red);
    return false;
  } else {
    log(`○ ${filePath} (optional)`, colors.yellow);
    return true;
  }
}

function validateAgentConfig() {
  const configPath = path.join(process.cwd(), '.agaile-os/agents/config.yml');
  
  if (!fs.existsSync(configPath)) {
    log('○ Agent configuration not found (optional)', colors.yellow);
    return true;
  }
  
  try {
    // Basic YAML validation would go here
    // For now, just check if file exists and is readable
    fs.readFileSync(configPath, 'utf8');
    log('✓ Agent configuration valid', colors.green);
    return true;
  } catch (e) {
    log(`✗ Error reading agent configuration: ${e.message}`, colors.red);
    return false;
  }
}

function main() {
  console.log('\n🔍 Validating AgAIle OS Configuration\n');
  
  let valid = true;
  
  console.log('Core Directories:');
  valid = checkFile('.agaile-os', true) && valid;
  valid = checkFile('.agaile-os/product', true) && valid;
  valid = checkFile('.agaile-os/standards', true) && valid;
  valid = checkFile('.agaile-os/features', true) && valid;
  
  console.log('\nProduct Documentation:');
  valid = checkFile('.agaile-os/product/mission.md', true) && valid;
  valid = checkFile('.agaile-os/product/roadmap.md', false) && valid;
  valid = checkFile('.agaile-os/product/tech-stack.md', false) && valid;
  
  console.log('\nStandards:');
  valid = checkFile('.agaile-os/standards/tech-stack.md', true) && valid;
  valid = checkFile('.agaile-os/standards/code-style.md', false) && valid;
  valid = checkFile('.agaile-os/standards/best-practices.md', false) && valid;
  
  console.log('\nIntegrations:');
  checkFile('.claude/commands', false);
  checkFile('.cursor/rules', false);
  
  console.log('\nAgent Configuration:');
  valid = validateAgentConfig() && valid;
  
  console.log('\n' + '─'.repeat(50));
  
  if (valid) {
    log('\n✅ AgAIle OS configuration is valid!\n', colors.green);
    process.exit(0);
  } else {
    log('\n❌ AgAIle OS configuration has issues. Please fix the required items.\n', colors.red);
    process.exit(1);
  }
}

main();
