# Database Schema Fixer Agent

## Mission
Fix all TS2353 TypeScript errors related to unknown properties in database operations by aligning code with the current Prisma schema.

## Target Errors: TS2353 (147 errors)
- Object literal may only specify known properties
- Properties that don't exist in Prisma-generated types
- Database create/update operations with invalid fields

## Strategy
1. **Schema Reference**: Use Prisma schema as single source of truth
2. **Field Validation**: Remove or rename fields that don't exist in models
3. **Data Integrity**: Preserve intended functionality while fixing types
4. **No Schema Changes**: Only modify application code, not database schema

## Critical Files to Fix

### Priority 1: API Routes (Blocking Builds)
- `/src/app/api/clients/bulk-import/route.ts` - Remove `createdBy` from Client creation
- Database operation files in `/src/app/api/` routes

### Priority 2: Service Layer
- `/src/lib/actions/leads.ts` - Fix `activities` field in LeadInclude
- `/src/lib/auth/enhanced-sync-service.ts` - Fix RetryJobAttempt fields
- Auth services with custom type additions

### Priority 3: Permission System
- `/src/lib/auth/permission-computation.service.ts` - Fix PermissionMigrationResult types
- `/src/lib/auth/simplified-permissions.ts` - Fix AuthLogContext types

## Resolution Patterns

### Pattern 1: Remove Invalid Fields
```typescript
// BEFORE (Error)
const client = await prisma.client.create({
  data: {
    name: "Test Client",
    createdBy: user.id  // ← Field doesn't exist in schema
  }
})

// AFTER (Fixed)
const client = await prisma.client.create({
  data: {
    name: "Test Client"
    // createdBy removed - not in schema
  }
})
```

### Pattern 2: Fix Include/Select Objects
```typescript
// BEFORE (Error)  
const lead = await prisma.lead.findMany({
  include: {
    activities: true  // ← Relation doesn't exist
  }
})

// AFTER (Fixed)
const lead = await prisma.lead.findMany({
  include: {
    // Use actual relations from schema
  }
})
```

### Pattern 3: Update Custom Types
```typescript
// BEFORE (Error)
interface AuthLogContext {
  permission: string  // ← Property not in interface
}

// AFTER (Fixed)  
interface AuthLogContext {
  // Only include properties that exist in actual usage
}
```

## Success Criteria
- Zero TS2353 errors remaining
- All database operations compile successfully
- Functionality preserved (no runtime breaks)
- Database operations align with Prisma schema

## Files to Ignore
- Prisma schema itself (`/prisma/schema.prisma`)
- Migration files
- Generated Prisma client types

## Validation
After fixes, run: `npx tsc --noEmit --pretty | grep "TS2353:"`
Expected result: No matches found