param(
  [Parameter(Mandatory = $true)]
  [string]$Path
)

function Get-Files {
  param([string]$Target)
  if (Test-Path $Target -PathType Leaf) {
    return ,(Get-Item $Target)
  }

  if (Test-Path $Target -PathType Container) {
    return Get-ChildItem -Path $Target -Recurse -Include *.js,*.jsx,*.ts,*.tsx -File
  }

  throw "Path not found: $Target"
}

$files = Get-Files -Target $Path
$findings = @()

foreach ($file in $files) {
  $content = Get-Content -Raw $file.FullName
  $name = $file.FullName

  if ($content -match "@xyflow/react" -or $content -match "<ReactFlow") {
    if ($content -notmatch "@xyflow/react/dist/style\.css") {
      $findings += "[WARN] Missing stylesheet import in $name"
    }

    if ($content -match "<ReactFlow" -and $content -notmatch "height:\s*'?\d" -and $content -notmatch "height:\s*'100%'" -and $content -notmatch "className=.*(h-screen|min-h-screen|h-full)") {
      $findings += "[WARN] Could not detect explicit parent height around <ReactFlow /> in $name"
    }

    if ($content -match "const\s+nodeTypes\s*=\s*\{" -and $content -notmatch "useMemo\(\s*\(\)\s*=>\s*\(\s*\{") {
      $findings += "[INFO] Verify nodeTypes is static or memoized in $name"
    }

    if ($content -match "const\s+edgeTypes\s*=\s*\{" -and $content -notmatch "useMemo\(\s*\(\)\s*=>\s*\(\s*\{") {
      $findings += "[INFO] Verify edgeTypes is static or memoized in $name"
    }

    if ($content -match "onNodesChange" -and $content -notmatch "useCallback\(") {
      $findings += "[INFO] Check callback memoization for handlers in $name"
    }

    if ($content -match "useReactFlow\(" -and $content -notmatch "ReactFlowProvider") {
      $findings += "[INFO] Ensure useReactFlow() call site is inside a <ReactFlowProvider /> subtree in $name"
    }

    if ($content -match "updateNodeInternals" -or $content -match "useUpdateNodeInternals") {
      if ($content -notmatch "useUpdateNodeInternals") {
        $findings += "[INFO] Verify dynamic handle updates call useUpdateNodeInternals() correctly in $name"
      }
    }
  }
}

if ($findings.Count -eq 0) {
  Write-Output "No obvious React Flow issues detected."
  exit 0
}

$findings | ForEach-Object { Write-Output $_ }
exit 0

