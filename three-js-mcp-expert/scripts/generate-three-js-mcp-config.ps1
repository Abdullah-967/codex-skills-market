param(
  [Parameter(Mandatory = $true)]
  [string]$RepoPath,

  [string]$ConfigPath = '.codex/config.toml'
)

$ErrorActionPreference = 'Stop'

$entry = Join-Path $RepoPath 'build/main.js'
if (!(Test-Path $entry)) {
  throw "Missing entrypoint: $entry. Build the repo first (example: npx tsc)."
}

$absEntry = (Resolve-Path $entry).Path

$snippet = @"
[mcpServers.three-js-mcp]
command = "node"
args = ["$absEntry"]
"@

Write-Output 'Recommended MCP config snippet:'
Write-Output $snippet

if (Test-Path $ConfigPath) {
  Write-Output "Detected existing config at: $ConfigPath"
  Write-Output 'Manual merge is recommended to avoid overwriting unrelated MCP servers.'
} else {
  Write-Output "Config file not found at: $ConfigPath"
}
