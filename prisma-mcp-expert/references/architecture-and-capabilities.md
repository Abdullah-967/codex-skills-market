# Architecture and Capabilities

## Primary Sources Used

- `https://raw.githubusercontent.com/prisma/mcp/main/README.md`
- `https://raw.githubusercontent.com/prisma/mcp/main/server.json`
- `https://raw.githubusercontent.com/prisma/mcp/main/dxt/manifest.json`
- `https://raw.githubusercontent.com/prisma/mcp/main/dxt/server/index.js`
- `https://raw.githubusercontent.com/prisma/mcp/main/dxt/server/package.json`
- `https://raw.githubusercontent.com/prisma/mcp/main/PUBLISH.md`

## Architecture Model

Prisma MCP currently exposes two server modes:

1. Local server (`npx -y prisma mcp`)
- CLI-backed.
- Strong fit for local migration lifecycle and Prisma Studio tasks.

2. Remote server (`npx -y mcp-remote https://mcp.prisma.io/mcp`)
- Prisma-managed control plane endpoint.
- Intended for platform/database management operations.

## Remote Transports

From `server.json`:

- `sse`: `https://mcp.prisma.io/sse`
- `streamable-http`: `https://mcp.prisma.io/mcp`

Both require `Authorization: Bearer <token>`.

## Capability Partitioning

Remote tool set (control-plane and SQL execution):

- `CreateBackupTool`
- `CreateConnectionStringTool`
- `CreateRecoveryTool`
- `DeleteConnectionStringTool`
- `DeleteDatabaseTool`
- `ListBackupsTool`
- `ListConnectionStringsTool`
- `ListDatabasesTool`
- `ExecuteSqlQueryTool`
- `IntrospectSchemaTool`

Local tool set (developer workflow):

- `migrate-status`
- `migrate-dev`
- `migrate-reset`
- `Prisma-Postgres-account-status`
- `Create-Prisma-Postgres-Database`
- `Prisma-Login`
- `Prisma-Studio`

## DXT Packaging Details (Advanced)

From `dxt/server/index.js`:

- DXT packaging may lose execute bit.
- Wrapper restores permissions via `chmod(CLI_PATH, 0o755)`.
- Wrapper then `spawn`s Prisma CLI with `mcp` subcommand.

Operational implication:

- Desktop extension startup failures can come from executable-bit issues, not tool logic.
- Keep permission repair in any custom packaging workflow.

From `dxt/server/package.json`:

- Prisma dependency is pinned to a specific integration build.

Operational implication:

- Prefer explicit version pinning for MCP stability; avoid floating upgrades in production.

## Publishing and Registry Operations

From `PUBLISH.md`:

- DNS-verified publisher identity is required (`_mcp-publisher.prisma.io` TXT).
- Versioning driven by `server.json` + git tags.

Operational implication:

- Treat registry publishing as release engineering with cryptographic and DNS prerequisites.
