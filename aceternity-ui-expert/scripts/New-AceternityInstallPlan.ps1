<#
.SYNOPSIS
    Generate deterministic install plan for Aceternity UI components.

.DESCRIPTION
    Builds install commands for specified components using either
    URL registry style or namespaced @aceternity style.

.PARAMETER Components
    Array of component names to install.

.PARAMETER Style
    Install command style: "url" or "namespaced" (default: url).

.PARAMETER OutputFormat
    Output format: "text" or "json" (default: text).

.EXAMPLE
    .\New-AceternityInstallPlan.ps1 -Components bento-grid, sidebar
    .\New-AceternityInstallPlan.ps1 -Components bento-grid, sidebar -Style namespaced
    .\New-AceternityInstallPlan.ps1 -Components bento-grid -OutputFormat json
#>

param(
    [Parameter(Mandatory = $true)]
    [string[]]$Components,

    [Parameter(Mandatory = $false)]
    [ValidateSet("url", "namespaced")]
    [string]$Style = "url",

    [Parameter(Mandatory = $false)]
    [ValidateSet("text", "json")]
    [string]$OutputFormat = "text"
)

# Handle comma-separated string input (common when called from command line)
$componentList = @()
foreach ($c in $Components) {
    $componentList += $c -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ }
}

function Get-UrlCommand {
    param([string]$Name)
    return "npx shadcn@latest add https://ui.aceternity.com/registry/$Name.json"
}

function Get-NamespacedCommand {
    param([string]$Name)
    return "npx shadcn@latest add @aceternity/$Name"
}

$formatter = if ($Style -eq "url") { ${function:Get-UrlCommand} } else { ${function:Get-NamespacedCommand} }

$plan = @{
    style = $Style
    components = @()
    commands = @()
    prerequisites = @(
        "npx shadcn@latest init",
        "npm i motion clsx tailwind-merge"
    )
}

foreach ($component in $componentList) {
    $cmd = & $formatter -Name $component
    $plan.components += $component
    $plan.commands += $cmd
}

if ($OutputFormat -eq "json") {
    $plan | ConvertTo-Json -Depth 5
}
else {
    Write-Host ""
    Write-Host "Aceternity Install Plan" -ForegroundColor Cyan
    Write-Host "=======================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Style: $Style" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Prerequisites:" -ForegroundColor Cyan
    foreach ($prereq in $plan.prerequisites) {
        Write-Host "  $prereq" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "Install Commands:" -ForegroundColor Cyan
    foreach ($cmd in $plan.commands) {
        Write-Host "  $cmd" -ForegroundColor White
    }
    Write-Host ""
    
    if ($Style -eq "namespaced") {
        Write-Host "Note: Namespaced style requires registry config in components.json:" -ForegroundColor Yellow
        Write-Host '  "registries": { "@aceternity": "https://ui.aceternity.com/registry/{name}.json" }' -ForegroundColor Gray
        Write-Host ""
    }
}
