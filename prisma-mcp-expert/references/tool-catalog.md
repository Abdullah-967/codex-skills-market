# Prisma MCP Tool Catalog

Complete reference of all Prisma MCP tools with parameters and usage guidance.

## Local Server Tools

Server: `prisma mcp` (CLI-backed)

### migrate-status

Check current migration status and detect drift.

**Risk Level:** Read-only

**Parameters:** None

**Use When:**
- Starting a migration workflow
- Checking for schema drift
- Verifying clean migration state

---

### migrate-dev

Create and apply a new migration in development.

**Risk Level:** Schema-change

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| name | string | Yes | Descriptive name for the migration |

**Use When:**
- Implementing schema changes during development
- Adding new models or fields
- Changing relations

**Caution:** Creates permanent migration files. Review generated SQL before committing.

---

### migrate-reset

Reset database to initial state by dropping and recreating.

**Risk Level:** DESTRUCTIVE

**Parameters:** None

**Use When:**
- Development environment cleanup
- Starting fresh with seed data
- Testing migration sequence from scratch

**WARNING:** Destroys all data. Never use in staging/prod. Requires explicit confirmation.

---

### Prisma-Postgres-account-status

Check Prisma Postgres account status and quotas.

**Risk Level:** Read-only

**Parameters:** None

---

### Create-Prisma-Postgres-Database

Create a new Prisma Postgres database instance.

**Risk Level:** Resource-create

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| name | string | Yes | Database name |
| region | string | No | Deployment region |

---

### Prisma-Login

Authenticate with Prisma platform.

**Risk Level:** Auth

**Parameters:** None (interactive)

---

### Prisma-Studio

Launch Prisma Studio for visual database browsing.

**Risk Level:** Read-only

**Parameters:** None

## Remote Server Tools

Server: `mcp.prisma.io` (Platform-managed)

Requires: `Authorization: Bearer <token>`

### ListDatabasesTool

List all databases in the platform account.

**Risk Level:** Read-only

**Parameters:** None

**Returns:**
```json
[
  {
    "id": "db_abc123",
    "name": "myapp-prod",
    "region": "us-east-1",
    "status": "active"
  }
]
```

---

### DeleteDatabaseTool

Delete a database permanently.

**Risk Level:** DESTRUCTIVE

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| databaseId | string | Yes | Database ID from ListDatabasesTool |

**WARNING:** Cannot be undone. Always create backup first.

---

### CreateBackupTool

Create a point-in-time backup of a database.

**Risk Level:** Resource-create

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| databaseId | string | Yes | Database ID |

**Returns:**
```json
{
  "backupId": "bkp_xyz789",
  "status": "in_progress",
  "createdAt": "2026-02-22T10:30:00Z"
}
```

---

### ListBackupsTool

List available backups for a database.

**Risk Level:** Read-only

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| databaseId | string | Yes | Database ID |

---

### CreateRecoveryTool

Recover a database from a backup.

**Risk Level:** Resource-create

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| databaseId | string | Yes | Target database ID |
| backupId | string | Yes | Backup ID to restore from |

---

### ExecuteSqlQueryTool

Execute SQL query against a database.

**Risk Level:** Data-change (depends on query)

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| databaseId | string | Yes | Database ID |
| query | string | Yes | SQL statement |

**Returns:**
```json
{
  "rows": [...],
  "rowCount": 10,
  "columns": ["id", "name", "email"]
}
```

**Best Practices:**
- Introspect schema before complex queries
- Use transactions for multi-statement operations
- Limit SELECT results to avoid payload overflow

---

### IntrospectSchemaTool

Introspect current database schema.

**Risk Level:** Read-only

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| databaseId | string | Yes | Database ID |

**Returns:**
```json
{
  "tables": [
    {
      "name": "users",
      "columns": [
        {"name": "id", "type": "uuid", "nullable": false},
        {"name": "email", "type": "text", "nullable": false}
      ]
    }
  ]
}
```

---

### CreateConnectionStringTool

Create a new connection string credential.

**Risk Level:** Credential-create

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| databaseId | string | Yes | Database ID |
| name | string | No | Friendly name for the credential |

**Returns:** Connection string (handle securely, do not log)

---

### ListConnectionStringsTool

List existing connection strings for a database.

**Risk Level:** Read-only

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| databaseId | string | Yes | Database ID |

**Note:** Returns metadata only, not actual credentials.

---

### DeleteConnectionStringTool

Delete a connection string credential.

**Risk Level:** Credential-delete

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| connectionStringId | string | Yes | Connection string ID |

**Caution:** Ensure no active consumers before deletion.

## Risk Level Reference

| Level | Description | Action Required |
|-------|-------------|-----------------|
| Read-only | Safe to run anytime | None |
| Auth | Authentication operation | Secure token storage |
| Resource-create | Creates new resources | Monitor quotas |
| Credential-create | Creates credentials | Secure handling |
| Credential-delete | Removes credentials | Verify no consumers |
| Schema-change | Modifies schema | Review changes |
| Data-change | Modifies data | Consider transactions |
| DESTRUCTIVE | Cannot be undone | Backup first, explicit confirm |
