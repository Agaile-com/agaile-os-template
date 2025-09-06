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
