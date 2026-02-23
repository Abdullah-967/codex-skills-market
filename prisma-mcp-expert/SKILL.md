---
name: prisma-mcp-expert
description: Build, manage, and troubleshoot Prisma MCP operations for local and remote servers. Use when executing safe migration workflows, production SQL operations, connection string management, backup/recovery orchestration, or integrating Prisma MCP into agents.
---

# Prisma MCP Expert

## Overview

Use this skill when work involves Prisma MCP server operations, database migrations, SQL execution against Prisma-managed databases, or integrating Prisma tools into MCP clients. It provides a repeatable MCP-driven workflow, install/audit scripts, and safety-first practices for production environments.

## Trigger Guidance

Use this skill when requests include:

- "Run Prisma migration safely"
- "Execute SQL on Prisma Postgres"
- "Rotate connection strings"
- "Create database backup before changes"
- "Set up Prisma MCP for VS Code/Claude/Cursor"
- "Troubleshoot Prisma MCP connection issues"

## Tool Configuration (MCP)

Prisma MCP exposes two server modes with distinct tool sets.

**Local server** (`prisma mcp` via CLI):
- `migrate-status`, `migrate-dev`, `migrate-reset`
- `Prisma-Postgres-account-status`, `Create-Prisma-Postgres-Database`
- `Prisma-Login`, `Prisma-Studio`

**Remote server** (`mcp.prisma.io`):
- `ListDatabasesTool`, `DeleteDatabaseTool`
- `CreateBackupTool`, `ListBackupsTool`, `CreateRecoveryTool`
- `ExecuteSqlQueryTool`, `IntrospectSchemaTool`
- `CreateConnectionStringTool`, `ListConnectionStringsTool`, `DeleteConnectionStringTool`

Use local mode for iterative schema design and migration authoring. Use remote mode for managed operational tasks (backup/recovery/database lifecycle).

## Standard Workflow

1. **Discovery**
   - Run `scripts/Get-PrismaMcpTools.ps1` to enumerate available tools for target mode.
   - Review `references/tool-catalog.md` for tool descriptions and parameters.

2. **Install/Configure**
   - Run `scripts/Install-PrismaMcp.ps1 -Target <vscode|cursor|claude_desktop|codex> -Mode <local|remote|both>`.
   - Verify MCP config was written correctly.

3. **Plan Operation**
   - Run `scripts/Plan-PrismaMcpSequence.ps1 -Goal "<task>" -Env <dev|staging|prod>`.
   - Review output for tool sequence and safety gates.

4. **Execute**
   - Follow `references/mcp-workflow.md` for tool invocation order.
   - Use `references/advanced-workflows.md` for multi-step operations.

5. **Validate**
   - Run `scripts/Audit-PrismaMcpUsage.ps1 -Path <project-root>` to check for common issues.
   - Compare against `references/anti-patterns.md`.

## Embedded Best Practices

Derived from Prisma MCP source patterns:

- Run `IntrospectSchemaTool` before any non-trivial SQL changes.
- Create backup via `CreateBackupTool` before destructive DDL or bulk updates.
- Treat `migrate-reset` and `DeleteDatabaseTool` as destructive—require explicit confirmation.
- Never print full connection strings in logs; redact sensitive segments.
- Re-list resources after mutations to verify eventual consistency.
- For failed operations, stop and introspect state before retrying.
- Pin Prisma versions in DXT packaging to avoid runtime drift.

## Operating Rules

- Always confirm environment (dev/staging/prod) before destructive operations.
- Always confirm target database identifier.
- Always have rollback path documented (backup or recovery plan).
- Prefer stateless retries with re-validation over blind replays.

## Resources

### scripts/

- `scripts/Install-PrismaMcp.ps1` — Install Prisma MCP config for target client.
- `scripts/Plan-PrismaMcpSequence.ps1` — Generate tool sequence with safety checks.
- `scripts/Get-PrismaMcpTools.ps1` — Enumerate available Prisma MCP tools.
- `scripts/Audit-PrismaMcpUsage.ps1` — Scan project for Prisma MCP issues.

### references/

- `references/architecture-and-capabilities.md` — Topology, transport, auth patterns.
- `references/mcp-workflow.md` — MCP tool invocation order and query presets.
- `references/tool-catalog.md` — Complete tool reference with parameters.
- `references/advanced-workflows.md` — Multi-step SOPs and edge-case handling.
- `references/performance-and-reliability.md` — Optimization and failure recovery.
- `references/anti-patterns.md` — Known failure modes and what to do instead.
