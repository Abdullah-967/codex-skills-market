param(
  [Parameter(Mandatory = $true)]
  [string]$RepoPath
)

$ErrorActionPreference = 'Stop'

function Add-Finding {
  param(
    [string]$Severity,
    [string]$Message
  )
  [PSCustomObject]@{ Severity = $Severity; Message = $Message }
}

$findings = @()
$mainTs = Join-Path $RepoPath 'src/main.ts'
$packageJsonPath = Join-Path $RepoPath 'package.json'

if (!(Test-Path $mainTs)) {
  throw "Missing file: $mainTs"
}
if (!(Test-Path $packageJsonPath)) {
  throw "Missing file: $packageJsonPath"
}

$main = Get-Content $mainTs -Raw
$pkg = Get-Content $packageJsonPath -Raw | ConvertFrom-Json

if ($main -match 'let\s+sceneState\s*:\s*any') {
  $findings += Add-Finding -Severity 'high' -Message 'sceneState is typed as any; use a strict scene schema for safer orchestration.'
}

if ($main -match 'WebSocketServer\(\{\s*port:\s*8082\s*\}\)') {
  $findings += Add-Finding -Severity 'high' -Message 'WebSocket port is hardcoded to 8082; make port environment-configurable.'
}

if ($main -notmatch 'ListResourcesRequestSchema') {
  $findings += Add-Finding -Severity 'low' -Message 'Resources capability is not exposed; acceptable but limits MCP discoverability.'
}

if ($main -notmatch 'ping|pong|heartbeat') {
  $findings += Add-Finding -Severity 'medium' -Message 'No heartbeat/ping handling detected; stale WS connections may go undetected.'
}

if ($main -match 'text:\s*"sent"') {
  $findings += Add-Finding -Severity 'medium' -Message 'Tool responses are generic ("sent") with no ack/result metadata.'
}

if ($pkg.scripts.build -match 'chmod') {
  $findings += Add-Finding -Severity 'high' -Message 'Build script contains chmod; this breaks on Windows shells.'
}

if (-not $pkg.bin) {
  $findings += Add-Finding -Severity 'high' -Message 'No package bin entry detected; direct npx execution is likely unreliable.'
}

if ($findings.Count -eq 0) {
  Write-Output 'No issues detected by static audit.'
  exit 0
}

$ordered = $findings | Sort-Object @{ Expression = {
  switch ($_.Severity) {
    'high' { 0 }
    'medium' { 1 }
    default { 2 }
  }
}}, Message

$ordered | Format-Table -AutoSize
