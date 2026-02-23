<#
.SYNOPSIS
    Install Prisma MCP configuration for target MCP client.

.DESCRIPTION
    Generates and installs Prisma MCP server configuration for VS Code, Cursor,
    Claude Desktop, or Codex. Supports local, remote, or both server modes.

.PARAMETER Target
    Target MCP client: vscode, cursor, claude_desktop, or codex.

.PARAMETER Mode
    Server mode: local (CLI), remote (mcp.prisma.io), or both.

.PARAMETER OutputPath
    Optional custom output path. If not specified, uses default client location.

.EXAMPLE
    .\Install-PrismaMcp.ps1 -Target codex -Mode both
    .\Install-PrismaMcp.ps1 -Target claude_desktop -Mode remote
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("vscode", "cursor", "claude_desktop", "codex")]
    [string]$Target,

    [Parameter(Mandatory = $false)]
    [ValidateSet("local", "remote", "both")]
    [string]$Mode = "both",

    [Parameter(Mandatory = $false)]
    [string]$OutputPath
)

# Windows-compatible MCP server definitions
$LocalServer = @{
    command = "cmd"
    args = @("/c", "npx", "-y", "prisma", "mcp")
}

$RemoteServer = @{
    command = "cmd"
    args = @("/c", "npx", "-y", "mcp-remote", "https://mcp.prisma.io/mcp")
}

function Build-ServerConfig {
    param([string]$ServerMode)
    
    $servers = @{}
    
    if ($ServerMode -eq "local" -or $ServerMode -eq "both") {
        $servers["prisma-local"] = $LocalServer
    }
    
    if ($ServerMode -eq "remote" -or $ServerMode -eq "both") {
        $servers["prisma-remote"] = $RemoteServer
    }
    
    return $servers
}

function Get-DefaultConfigPath {
    param([string]$ClientTarget)
    
    switch ($ClientTarget) {
        "vscode" {
            return Join-Path $env:APPDATA "Code\User\globalStorage\saoudrizwan.claude-dev\settings\cline_mcp_settings.json"
        }
        "cursor" {
            return Join-Path $env:APPDATA "Cursor\User\globalStorage\saoudrizwan.claude-dev\settings\cline_mcp_settings.json"
        }
        "claude_desktop" {
            return Join-Path $env:APPDATA "Claude\claude_desktop_config.json"
        }
        "codex" {
            return Join-Path $PWD ".codex\config.toml"
        }
    }
}

function Format-Config {
    param(
        [string]$ClientTarget,
        [hashtable]$Servers
    )
    
    switch ($ClientTarget) {
        "codex" {
            # Output TOML format
            $output = ""
            foreach ($name in $Servers.Keys) {
                $server = $Servers[$name]
                $output += "[mcpServers.$name]`n"
                $output += "command = `"$($server.command)`"`n"
                $argsStr = ($server.args | ForEach-Object { "`"$_`"" }) -join ", "
                $output += "args = [$argsStr]`n`n"
            }
            return $output.TrimEnd()
        }
        default {
            # Output JSON format
            return @{ mcpServers = $Servers } | ConvertTo-Json -Depth 10
        }
    }
}

# Main execution
$servers = Build-ServerConfig -ServerMode $Mode
$configPath = if ($OutputPath) { $OutputPath } else { Get-DefaultConfigPath -ClientTarget $Target }
$config = Format-Config -ClientTarget $Target -Servers $servers

Write-Host "Prisma MCP Configuration for $Target ($Mode mode):" -ForegroundColor Cyan
Write-Host ""
Write-Host $config
Write-Host ""
Write-Host "Default config path: $configPath" -ForegroundColor Yellow
Write-Host ""
Write-Host "To install, copy the above config to your MCP client configuration." -ForegroundColor Green
