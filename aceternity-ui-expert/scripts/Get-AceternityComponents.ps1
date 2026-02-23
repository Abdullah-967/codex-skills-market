<#
.SYNOPSIS
    Extract and normalize Aceternity MCP component data from components-data.ts.

.DESCRIPTION
    Parses the ACETERNITY_COMPONENTS array from the MCP repo source file
    and exports normalized JSON for audits, migration planning, and inventory.

.PARAMETER InputPath
    Path to components-data.ts from the aceternityui-mcp repo.

.PARAMETER OutputPath
    Output JSON file path.

.EXAMPLE
    .\Get-AceternityComponents.ps1 -InputPath components-data.ts -OutputPath components.json
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$InputPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputPath
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $InputPath)) {
    throw "Input file not found: $InputPath"
}

$content = Get-Content $InputPath -Raw

# Extract ACETERNITY_COMPONENTS array content
$arrayMatch = [regex]::Match($content, 'ACETERNITY_COMPONENTS\s*:\s*AceternityComponent\[\]\s*=\s*\[(.*?)\]\s*;', [System.Text.RegularExpressions.RegexOptions]::Singleline)

if (-not $arrayMatch.Success) {
    throw "Could not find ACETERNITY_COMPONENTS array in file"
}

$arrayContent = $arrayMatch.Groups[1].Value

# Extract individual component blocks
$blockMatches = [regex]::Matches($arrayContent, '\{(.*?)\}\s*,?', [System.Text.RegularExpressions.RegexOptions]::Singleline)

$components = @()

foreach ($block in $blockMatches) {
    $blockContent = $block.Groups[1].Value
    
    # Helper functions
    function Get-StringValue {
        param([string]$Key)
        $match = [regex]::Match($blockContent, "$Key`:\s*`"(.*?)`"", [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if ($match.Success) { return $match.Groups[1].Value.Trim() }
        return $null
    }
    
    function Get-BoolValue {
        param([string]$Key)
        $match = [regex]::Match($blockContent, "$Key`:\s*(true|false)")
        if ($match.Success) { return $match.Groups[1].Value -eq "true" }
        return $false
    }
    
    function Get-ArrayValue {
        param([string]$Key)
        $match = [regex]::Match($blockContent, "$Key`:\s*\[(.*?)\]", [System.Text.RegularExpressions.RegexOptions]::Singleline)
        if ($match.Success) {
            $raw = $match.Groups[1].Value
            return @($raw -split ',' | ForEach-Object { $_.Trim().Trim('"') } | Where-Object { $_ })
        }
        return @()
    }
    
    $name = Get-StringValue "name"
    if (-not $name) { continue }
    
    $desc = Get-StringValue "description"
    $cat = Get-StringValue "category"
    $install = Get-StringValue "installCommand"
    $doc = Get-StringValue "documentation"
    
    $components += [PSCustomObject]@{
        name = $name
        description = if ($desc) { $desc } else { "" }
        category = if ($cat) { $cat } else { "" }
        installCommand = if ($install) { $install } else { "" }
        dependencies = Get-ArrayValue "dependencies"
        tags = Get-ArrayValue "tags"
        isPro = Get-BoolValue "isPro"
        documentation = if ($doc) { $doc } else { "" }
    }
}

# Ensure output directory exists
$outputDir = Split-Path $OutputPath -Parent
if ($outputDir -and -not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Write JSON output
$components | ConvertTo-Json -Depth 10 | Set-Content $OutputPath -Encoding UTF8

Write-Host "Extracted $($components.Count) components -> $OutputPath" -ForegroundColor Green
