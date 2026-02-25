param(
    [Parameter(Mandatory = $true)]
    [string]$Path
)

if (-not (Test-Path -LiteralPath $Path)) {
    Write-Error "Path not found: $Path"
    exit 1
}

$patterns = @(
    @{ Name = "Hardcoded Vapi key"; Regex = "x-vapi-api-key\s*[:=]\s*['""](?!(\$\{?env:|process\.env))" },
    @{ Name = "Blind retry loop"; Regex = "(while|for)\s*\(.*\)\s*{[^}]*?(startCall|endCall|controlCall|vapi_start_call|vapi_end_call)" },
    @{ Name = "Unbounded transcript usage"; Regex = "(transcript|messages).{0,60}(send|post|tool|mcp).{0,120}(without|raw|full)" },
    @{ Name = "Missing timeout keyword"; Regex = "(fetch|axios|request|invoke).{0,120}(vapi|mcp)" },
    @{ Name = "Recursive assistant transfer risk"; Regex = "(assistant-request|transfer).{0,120}(assistantId).{0,120}(assistantId)" }
)

$selfPath = (Resolve-Path -LiteralPath $PSCommandPath).Path
$files = Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.Extension -match '\.(ts|tsx|js|jsx|py|ps1|json|yaml|yml|md)$' } |
    Where-Object { (Resolve-Path -LiteralPath $_.FullName).Path -ne $selfPath }

$results = @()

foreach ($file in $files) {
    $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }

    foreach ($pattern in $patterns) {
        if ($content -match $pattern.Regex) {
            $results += [pscustomobject]@{
                Finding = $pattern.Name
                File    = $file.FullName
            }
        }
    }
}

Write-Host "Vapi MCP integration audit"
Write-Host "Target: $Path"
Write-Host ""

if ($results.Count -eq 0) {
    Write-Host "No heuristic findings detected."
    exit 0
}

$results | Sort-Object Finding, File | Format-Table -AutoSize
Write-Host ""
Write-Host "Total findings: $($results.Count)"
