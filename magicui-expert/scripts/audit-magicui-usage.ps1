param(
  [string]$Root = "."
)

$extPattern = '\.(tsx|ts|jsx|js)$'
$files = Get-ChildItem -Path $Root -Recurse -File | Where-Object { $_.FullName -match $extPattern }

if (-not $files) {
  Write-Output "No source files found under $Root"
  exit 0
}

$magicUiImports = @()
$motionWithoutClient = @()

foreach ($file in $files) {
  $text = Get-Content -Path $file.FullName -Raw
  if ($text -match '@/components/ui/' -or $text -match 'magicui\.design/r/') {
    $magicUiImports += $file.FullName
  }

  if ($text -match 'motion/react') {
    $firstNonEmpty = ($text -split "`r?`n" | Where-Object { $_.Trim().Length -gt 0 } | Select-Object -First 1)
    if ($firstNonEmpty -notmatch '^"use client"|^''use client''') {
      $motionWithoutClient += $file.FullName
    }
  }
}

Write-Output "Magic UI related files: $($magicUiImports.Count)"
if ($magicUiImports.Count -gt 0) {
  $magicUiImports | Sort-Object -Unique | ForEach-Object { Write-Output " - $_" }
}

Write-Output ""
Write-Output "Potential client-boundary issues (motion/react without use client): $($motionWithoutClient.Count)"
if ($motionWithoutClient.Count -gt 0) {
  $motionWithoutClient | Sort-Object -Unique | ForEach-Object { Write-Output " - $_" }
}
