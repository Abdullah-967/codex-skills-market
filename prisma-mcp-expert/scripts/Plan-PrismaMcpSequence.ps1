<#
.SYNOPSIS
    Generate a safe Prisma MCP tool sequence with safety checks.

.DESCRIPTION
    Analyzes the goal and environment to produce a deterministic tool sequence
    with appropriate safety gates for Prisma MCP operations.

.PARAMETER Goal
    Description of the task to accomplish (e.g., "drop table users", "run migration").

.PARAMETER Env
    Target environment: dev, staging, or prod.

.EXAMPLE
    .\Plan-PrismaMcpSequence.ps1 -Goal "execute SQL update on users table" -Env prod
    .\Plan-PrismaMcpSequence.ps1 -Goal "run migration" -Env dev
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Goal,

    [Parameter(Mandatory = $false)]
    [ValidateSet("dev", "staging", "prod")]
    [string]$Env = "dev"
)

$goalLower = $Goal.ToLower()

# Detect operation types
$isDestructive = $goalLower -match "drop|delete|reset|truncate|wipe|remove"
$isSql = $goalLower -match "sql|query|update|alter|create table|insert|select"
$isMigration = $goalLower -match "migration|migrate|schema"
$isConnectionString = $goalLower -match "connection string|rotate|credential"
$isBackup = $goalLower -match "backup|restore|recovery"

# Build tool sequence
$sequence = @()
$safeguards = @(
    "Confirm environment: $Env",
    "Confirm target database identifier",
    "Redact secrets in outputs"
)

if ($Env -in @("staging", "prod")) {
    $safeguards += "Require explicit confirmation before destructive actions"
}

if ($isMigration) {
    $sequence += @(
        "migrate-status",
        "migrate-dev (named migration)",
        "migrate-status (post-check)"
    )
}

if ($isSql) {
    $sequence += @(
        "ListDatabasesTool",
        "CreateBackupTool",
        "IntrospectSchemaTool",
        "ExecuteSqlQueryTool",
        "IntrospectSchemaTool (post-check)"
    )
}

if ($isConnectionString) {
    $sequence += @(
        "ListConnectionStringsTool",
        "CreateConnectionStringTool",
        "DeleteConnectionStringTool (after cutover)"
    )
}

if ($isBackup) {
    $sequence += @(
        "ListDatabasesTool",
        "ListBackupsTool",
        "CreateBackupTool or CreateRecoveryTool"
    )
}

if ($sequence.Count -eq 0) {
    $sequence = @(
        "ListDatabasesTool",
        "IntrospectSchemaTool"
    )
}

if ($isDestructive) {
    $safeguards += @(
        "CreateBackupTool before mutation",
        "Document rollback path (CreateRecoveryTool)"
    )
}

# Output result
$result = @{
    goal = $Goal
    environment = $Env
    tool_sequence = $sequence
    safeguards = $safeguards
}

Write-Host ""
Write-Host "Prisma MCP Tool Sequence Plan" -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Goal: $Goal" -ForegroundColor White
Write-Host "Environment: $Env" -ForegroundColor $(if ($Env -eq "prod") { "Red" } elseif ($Env -eq "staging") { "Yellow" } else { "Green" })
Write-Host ""
Write-Host "Tool Sequence:" -ForegroundColor Cyan
$i = 1
foreach ($tool in $sequence) {
    Write-Host "  $i. $tool" -ForegroundColor White
    $i++
}
Write-Host ""
Write-Host "Safety Gates:" -ForegroundColor Yellow
foreach ($gate in $safeguards) {
    Write-Host "  - $gate" -ForegroundColor Yellow
}
Write-Host ""

# Also output as JSON for programmatic use
$result | ConvertTo-Json -Depth 5
