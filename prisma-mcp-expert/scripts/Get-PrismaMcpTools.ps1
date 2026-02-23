<#
.SYNOPSIS
    Enumerate available Prisma MCP tools for target mode.

.DESCRIPTION
    Lists all available Prisma MCP tools for local or remote server modes,
    with descriptions and usage guidance.

.PARAMETER Mode
    Server mode: local (CLI), remote (mcp.prisma.io), or all.

.EXAMPLE
    .\Get-PrismaMcpTools.ps1 -Mode local
    .\Get-PrismaMcpTools.ps1 -Mode remote
    .\Get-PrismaMcpTools.ps1 -Mode all
#>

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("local", "remote", "all")]
    [string]$Mode = "all"
)

$LocalTools = @(
    @{
        name = "migrate-status"
        description = "Check current migration status and drift detection"
        risk = "read-only"
    },
    @{
        name = "migrate-dev"
        description = "Create and apply a new migration in development"
        risk = "schema-change"
    },
    @{
        name = "migrate-reset"
        description = "Reset database to initial state (DESTRUCTIVE)"
        risk = "destructive"
    },
    @{
        name = "Prisma-Postgres-account-status"
        description = "Check Prisma Postgres account status"
        risk = "read-only"
    },
    @{
        name = "Create-Prisma-Postgres-Database"
        description = "Create a new Prisma Postgres database"
        risk = "resource-create"
    },
    @{
        name = "Prisma-Login"
        description = "Authenticate with Prisma platform"
        risk = "auth"
    },
    @{
        name = "Prisma-Studio"
        description = "Launch Prisma Studio for database browsing"
        risk = "read-only"
    }
)

$RemoteTools = @(
    @{
        name = "ListDatabasesTool"
        description = "List all databases in the platform"
        risk = "read-only"
    },
    @{
        name = "DeleteDatabaseTool"
        description = "Delete a database (DESTRUCTIVE)"
        risk = "destructive"
    },
    @{
        name = "CreateBackupTool"
        description = "Create a database backup"
        risk = "resource-create"
    },
    @{
        name = "ListBackupsTool"
        description = "List available backups"
        risk = "read-only"
    },
    @{
        name = "CreateRecoveryTool"
        description = "Recover database from backup"
        risk = "resource-create"
    },
    @{
        name = "ExecuteSqlQueryTool"
        description = "Execute SQL query against database"
        risk = "data-change"
    },
    @{
        name = "IntrospectSchemaTool"
        description = "Introspect database schema"
        risk = "read-only"
    },
    @{
        name = "CreateConnectionStringTool"
        description = "Create a new connection string"
        risk = "credential-create"
    },
    @{
        name = "ListConnectionStringsTool"
        description = "List existing connection strings"
        risk = "read-only"
    },
    @{
        name = "DeleteConnectionStringTool"
        description = "Delete a connection string"
        risk = "credential-delete"
    }
)

function Write-ToolList {
    param(
        [string]$Title,
        [array]$Tools
    )
    
    Write-Host ""
    Write-Host "$Title" -ForegroundColor Cyan
    Write-Host ("=" * $Title.Length) -ForegroundColor Cyan
    Write-Host ""
    
    foreach ($tool in $Tools) {
        $riskColor = switch ($tool.risk) {
            "read-only" { "Green" }
            "auth" { "Yellow" }
            "resource-create" { "Yellow" }
            "credential-create" { "Yellow" }
            "credential-delete" { "Yellow" }
            "schema-change" { "Red" }
            "data-change" { "Red" }
            "destructive" { "Magenta" }
            default { "White" }
        }
        
        Write-Host "  $($tool.name)" -ForegroundColor White -NoNewline
        Write-Host " [$($tool.risk)]" -ForegroundColor $riskColor
        Write-Host "    $($tool.description)" -ForegroundColor Gray
    }
}

# Output tools based on mode
if ($Mode -eq "local" -or $Mode -eq "all") {
    Write-ToolList -Title "Local Server Tools (prisma mcp)" -Tools $LocalTools
}

if ($Mode -eq "remote" -or $Mode -eq "all") {
    Write-ToolList -Title "Remote Server Tools (mcp.prisma.io)" -Tools $RemoteTools
}

Write-Host ""
Write-Host "Risk Legend:" -ForegroundColor Cyan
Write-Host "  [read-only]        Safe to run anytime" -ForegroundColor Green
Write-Host "  [auth]             Authentication operation" -ForegroundColor Yellow
Write-Host "  [resource-create]  Creates new resources" -ForegroundColor Yellow
Write-Host "  [credential-*]     Manages credentials" -ForegroundColor Yellow
Write-Host "  [schema-change]    Modifies database schema" -ForegroundColor Red
Write-Host "  [data-change]      Modifies data" -ForegroundColor Red
Write-Host "  [destructive]      Cannot be undone - requires backup first" -ForegroundColor Magenta
Write-Host ""
