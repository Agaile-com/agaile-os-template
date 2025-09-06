# Contributing to AgAIle OS

Thank you for your interest in contributing to AgAIle OS! This project aims to revolutionize AI-assisted development through intelligent agent orchestration.

## 🤝 How to Contribute

### Reporting Issues

1. Check existing issues to avoid duplicates
2. Use issue templates when available
3. Provide clear reproduction steps
4. Include relevant system information

### Suggesting Features

1. Open a discussion first for major features
2. Explain the problem being solved
3. Provide use cases and examples
4. Consider backward compatibility

### Submitting Pull Requests

1. Fork the repository
2. Create a feature branch (`feature/amazing-feature`)
3. Make your changes following our standards
4. Write/update tests if applicable
5. Update documentation
6. Submit PR with clear description

## 🏗️ Development Setup

```bash
# Clone your fork
git clone https://github.com/yourusername/agaile-os.git
cd agaile-os

# Install dependencies
npm install

# Run setup
npm run setup

# Make your changes
# Test locally in a sample project
```

## 📝 Coding Standards

### General Principles
- Write clear, self-documenting code
- Follow existing patterns in the codebase
- Keep changes focused and atomic
- Test your changes thoroughly

### Commit Messages
Follow conventional commits:
```
feat: Add new agent capability
fix: Resolve confidence threshold bug
docs: Update HIL methodology
test: Add agent coordination tests
refactor: Simplify error handling
```

## 🧪 Testing

### Agent Testing
```bash
# Test specific agent
npm run agent:test -- --agent fixer

# Test coordination pattern
npm run agent:test -- --pattern typescript_resolution

# Validate configuration
npm run validate
```

## 📚 Documentation

### Adding New Agents
1. Define agent in `templates/agents/config.yml`
2. Document capabilities and patterns
3. Add usage examples
4. Update agent specialization matrix

### Adding New Commands
1. Create command in `templates/commands/`
2. Add instruction in `templates/instructions/core/`
3. Update command reference in docs
4. Add to setup script if needed

## 🎯 Areas for Contribution

### High Priority
- Additional agent specializations
- VS Code extension
- Web dashboard interface
- Additional CI/CD platform integrations

### Good First Issues
- Documentation improvements
- Example projects
- Bug fixes in setup script
- Additional coordination patterns

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.
