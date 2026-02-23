# MCP Workflow

Use this sequence when executing Prisma MCP operations.

## Required Sequence by Operation Type

### Database Query Operations

1. Initialize context:
   - Call `ListDatabasesTool` to confirm target database exists.

2. Schema discovery (required before writes):
   - Call `IntrospectSchemaTool` to understand current structure.

3. Execute query:
   - Call `ExecuteSqlQueryTool` with scoped statement.

4. Verify outcome:
   - Call `IntrospectSchemaTool` again for DDL changes.
   - Check returned rows/affected count for DML.

### Migration Operations

1. Check current state:
   - Call `migrate-status` to detect drift.

2. Apply migration:
   - Call `migrate-dev --name <descriptive_name>`.

3. Verify migration:
   - Call `migrate-status` to confirm clean state.

### Backup/Recovery Operations

1. List resources:
   - Call `ListDatabasesTool` to confirm target.
   - Call `ListBackupsTool` to see existing backups.

2. Create backup (before risky changes):
   - Call `CreateBackupTool`.

3. Recovery (if needed):
   - Call `CreateRecoveryTool` with backup reference.

### Connection String Operations

1. List current credentials:
   - Call `ListConnectionStringsTool`.

2. Create new credential:
   - Call `CreateConnectionStringTool`.

3. Verify consumer cutover.

4. Delete old credential:
   - Call `DeleteConnectionStringTool` only after cutover confirmed.

## Tool Invocation Patterns

### Local Server (prisma mcp)

```
MCP tool: migrate-status
MCP tool: migrate-dev --name add_user_email
MCP tool: migrate-status
```

### Remote Server (mcp.prisma.io)

```
MCP tool: ListDatabasesTool
  → Returns: [{id: "db_123", name: "mydb", ...}]

MCP tool: CreateBackupTool
  Args: { databaseId: "db_123" }
  → Returns: { backupId: "bkp_456", status: "in_progress" }

MCP tool: IntrospectSchemaTool
  Args: { databaseId: "db_123" }
  → Returns: { tables: [...], columns: [...] }

MCP tool: ExecuteSqlQueryTool
  Args: { databaseId: "db_123", query: "SELECT * FROM users LIMIT 10" }
  → Returns: { rows: [...], rowCount: 10 }
```

## Decision Rules

- Always introspect before non-trivial SQL writes.
- Always create backup before destructive DDL in staging/prod.
- Use local mode for iterative schema design.
- Use remote mode for operational database management.
- Re-list resources after mutations to verify state.

## Error Recovery

### Failed SQL Execution

1. Stop further operations.
2. Call `IntrospectSchemaTool` to assess state.
3. Decide: forward-fix or restore from backup.

### Failed Migration

1. Call `migrate-status` to see current state.
2. If partially applied, resolve manually or `migrate-reset` (dev only).

### Failed Backup/Recovery

1. Call `ListBackupsTool` to see actual backup state.
2. Retry with exponential backoff if transient error.
