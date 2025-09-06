# Database Migration

Manage database schemas and migrations with agent assistance.

## Command

```
/db-migrate [options]
```

## Options

- `--from-feature` - Generate migration from feature specification
- `--env [development|staging|production]` - Target environment
- `--validate` - Validate schema without applying changes
- `--rollback` - Rollback last migration
- `--agent-enhanced` - Use db-migrate-agent for assistance
- `--generate-types` - Generate TypeScript types

## Workflow

### 1. Schema Detection
- Reads `database-schema.md` from active feature
- Compares with current database state
- Identifies required changes

### 2. Migration Execution
- Applies schema changes safely
- Handles dependencies and constraints
- Manages rollback procedures

### 3. Type Generation
- Synchronizes ORM schema (Prisma/TypeORM)
- Generates TypeScript types
- Validates type safety

## Agent Enhancement

**DB-Migrate Agent** (88-90% confidence):
- Automatic schema synchronization
- Migration conflict resolution
- Type generation optimization
- Rollback planning

## Usage Examples

### Development Migration
```
/db-migrate --from-feature --env development
```

### Production Validation
```
/db-migrate --validate --env production
```

### Emergency Rollback
```
/db-migrate --rollback --env production
```

### With Agent Assistance
```
/db-migrate --agent-enhanced --from-feature
```

## Safety Features

- Pre-migration backup verification
- Dependency checking
- Constraint validation
- Automatic rollback on failure
- Cross-environment sync validation

## Output

```
🗄️ Database Migration Report
=============================

📊 CHANGES DETECTED
- New tables: 2
- Modified columns: 5
- New indexes: 3

✅ MIGRATION SUCCESSFUL
- Schema applied
- Types generated
- Validation passed

⏱️ Execution time: 3.2s
```
