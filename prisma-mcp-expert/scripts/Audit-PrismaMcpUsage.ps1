<#
.SYNOPSIS
    Audit project for Prisma MCP usage and common issues.

.DESCRIPTION
    Scans project files for Prisma and MCP-related code, checking for
    common issues like exposed connection strings, missing error handling,
    and configuration problems.

.PARAMETER Path
    Path to the project root or specific file to audit.

.EXAMPLE
    .\Audit-PrismaMcpUsage.ps1 -Path .
    .\Audit-PrismaMcpUsage.ps1 -Path src/
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

function Get-FilesToAudit {
    param([string]$Target)
    
    if (Test-Path $Target -PathType Leaf) {
        return @(Get-Item $Target)
    }
    
    if (Test-Path $Target -PathType Container) {
        $extensions = @("*.ts", "*.tsx", "*.js", "*.jsx", "*.json", "*.toml", "*.yaml", "*.yml", "*.env*", "*.prisma")
        $files = @()
        foreach ($ext in $extensions) {
            $files += Get-ChildItem -Path $Target -Recurse -Filter $ext -File -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -notmatch "node_modules|\.git|dist|build" }
        }
        return $files
    }
    
    throw "Path not found: $Target"
}

$files = Get-FilesToAudit -Path $Path
$findings = @()
$stats = @{
    prismaSchemaFiles = 0
    mcpConfigFiles = 0
    connectionStringRefs = 0
    envFiles = 0
}

foreach ($file in $files) {
    $content = Get-Content -Raw $file.FullName -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $name = $file.FullName
    $fileName = $file.Name
    
    # Check for Prisma schema files
    if ($fileName -eq "schema.prisma") {
        $stats.prismaSchemaFiles++
        
        # Check for hardcoded connection strings in schema
        if ($content -match 'url\s*=\s*"(postgres|mysql|mongodb|sqlserver)://') {
            $findings += @{
                level = "ERROR"
                file = $name
                message = "Hardcoded database URL in schema.prisma - use env('DATABASE_URL') instead"
            }
        }
    }
    
    # Check for MCP config files
    if ($fileName -match "config\.(toml|json)$" -or $fileName -match "mcp.*settings.*\.json$") {
        if ($content -match "prisma|mcp\.prisma\.io") {
            $stats.mcpConfigFiles++
            
            # Check for proper Windows config
            if ($content -match '"command":\s*"npx"' -and $content -notmatch '"command":\s*"cmd"') {
                $findings += @{
                    level = "WARN"
                    file = $name
                    message = "MCP config uses 'npx' directly - consider 'cmd /c npx' for Windows reliability"
                }
            }
        }
    }
    
    # Check for exposed connection strings
    if ($content -match '(postgres|mysql|mongodb|sqlserver)://[^"\s]+:[^"\s]+@') {
        $stats.connectionStringRefs++
        
        if ($fileName -notmatch "\.env") {
            $findings += @{
                level = "ERROR"
                file = $name
                message = "Connection string with credentials found outside .env file"
            }
        }
    }
    
    # Check .env files
    if ($fileName -match "^\.env") {
        $stats.envFiles++
        
        # Check if .env is potentially committed
        $gitignorePath = Join-Path (Split-Path $name -Parent) ".gitignore"
        if (-not (Test-Path $gitignorePath)) {
            $findings += @{
                level = "WARN"
                file = $name
                message = "No .gitignore found - ensure .env files are not committed"
            }
        }
    }
    
    # Check for Prisma client usage without error handling
    if ($content -match '\$prisma\.' -or $content -match 'prisma\.(create|update|delete|findMany|findUnique|executeRaw)') {
        if ($content -notmatch 'try\s*\{' -and $content -notmatch '\.catch\(') {
            $findings += @{
                level = "INFO"
                file = $name
                message = "Prisma operations found - verify error handling is in place"
            }
        }
    }
    
    # Check for migrate-reset in non-dev contexts
    if ($content -match 'migrate-reset|migrate reset') {
        $findings += @{
            level = "WARN"
            file = $name
            message = "Reference to migrate-reset found - ensure this is dev-only"
        }
    }
}

# Output results
Write-Host ""
Write-Host "Prisma MCP Audit Report" -ForegroundColor Cyan
Write-Host "=======================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Files scanned: $($files.Count)" -ForegroundColor White
Write-Host ""
Write-Host "Statistics:" -ForegroundColor Cyan
Write-Host "  Prisma schema files: $($stats.prismaSchemaFiles)"
Write-Host "  MCP config files: $($stats.mcpConfigFiles)"
Write-Host "  Connection string refs: $($stats.connectionStringRefs)"
Write-Host "  Env files: $($stats.envFiles)"
Write-Host ""

if ($findings.Count -eq 0) {
    Write-Host "No issues detected." -ForegroundColor Green
    exit 0
}

Write-Host "Findings ($($findings.Count)):" -ForegroundColor Yellow
Write-Host ""

foreach ($finding in $findings) {
    $color = switch ($finding.level) {
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        "INFO" { "Cyan" }
        default { "White" }
    }
    
    Write-Host "[$($finding.level)] " -ForegroundColor $color -NoNewline
    Write-Host $finding.message -ForegroundColor White
    Write-Host "  File: $($finding.file)" -ForegroundColor Gray
    Write-Host ""
}

exit 0
