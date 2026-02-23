param(
  [string]$Root = "."
)

$ErrorActionPreference = "Stop"

function Get-RadixPackagesFromPackageJson {
  param([string]$RootPath)

  $result = @{}
  $files = Get-ChildItem -Path $RootPath -Recurse -Filter package.json -File -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "[\\/]node_modules[\\/]" }

  foreach ($file in $files) {
    try {
      $json = Get-Content -Raw $file.FullName | ConvertFrom-Json
      $groups = @($json.dependencies, $json.devDependencies, $json.peerDependencies)
      foreach ($group in $groups) {
        if (-not $group) { continue }
        foreach ($prop in $group.PSObject.Properties) {
          if ($prop.Name -like "@radix-ui/*") {
            if (-not $result.ContainsKey($prop.Name)) { $result[$prop.Name] = @() }
            $result[$prop.Name] += "$($file.FullName): $($prop.Value)"
          }
        }
      }
    } catch {
      Write-Warning "Skipping invalid JSON: $($file.FullName)"
    }
  }

  return $result
}

function Get-ImportMatches {
  param([string]$RootPath)

  $rg = Get-Command rg -ErrorAction SilentlyContinue
  if (-not $rg) {
    Write-Warning "ripgrep (rg) not found; skipping fast import scan."
    return @()
  }

  $pattern = "@radix-ui/[A-Za-z0-9._-]+"
  $lines = & rg -n --no-heading --glob "!**/node_modules/**" --glob "!**/.next/**" --glob "!**/dist/**" $pattern $RootPath
  return $lines
}

function Get-AntiPatternWarnings {
  param([string]$RootPath)

  $warnings = @()
  $rg = Get-Command rg -ErrorAction SilentlyContinue
  if (-not $rg) { return $warnings }

  $files = & rg --files $RootPath -g "*.tsx" -g "*.ts" -g "*.jsx" -g "*.js" -g "!**/node_modules/**" -g "!**/.next/**" -g "!**/dist/**"

  foreach ($file in $files) {
    $text = Get-Content -Raw $file

    if (($text -match "\bopen=") -and ($text -match "\bdefaultOpen=")) {
      $warnings += "Possible mixed controlled/uncontrolled open state: $file"
    }
    if (($text -match "\bvalue=") -and ($text -match "\bdefaultValue=")) {
      $warnings += "Possible mixed controlled/uncontrolled value state: $file"
    }
    if (($text -match "@radix-ui/react-(dialog|popover|dropdown-menu|tooltip)") -and ($text -match "z-index")) {
      $warnings += "Overlay file contains explicit z-index; verify layer semantics: $file"
    }
  }

  return $warnings
}

Write-Host "=== Radix Usage Audit ==="
Write-Host "Root: $(Resolve-Path $Root)"

$pkgs = Get-RadixPackagesFromPackageJson -RootPath $Root
if ($pkgs.Count -eq 0) {
  Write-Host "No @radix-ui packages found in package.json files."
} else {
  Write-Host "\nPackages:"
  foreach ($name in ($pkgs.Keys | Sort-Object)) {
    Write-Host "- $name"
  }
}

$imports = Get-ImportMatches -RootPath $Root
if ($imports.Count -gt 0) {
  Write-Host "\nTop import usages:"
  $freq = @{}
  foreach ($line in $imports) {
    $m = [regex]::Match($line, "@radix-ui/[A-Za-z0-9._-]+")
    if ($m.Success) {
      if (-not $freq.ContainsKey($m.Value)) { $freq[$m.Value] = 0 }
      $freq[$m.Value]++
    }
  }

  foreach ($entry in ($freq.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 20)) {
    Write-Host "- $($entry.Key): $($entry.Value)"
  }
} else {
  Write-Host "\nNo import matches found."
}

$warnings = Get-AntiPatternWarnings -RootPath $Root
if ($warnings.Count -gt 0) {
  Write-Host "\nWarnings:"
  foreach ($w in $warnings | Sort-Object -Unique) {
    Write-Host "- $w"
  }
} else {
  Write-Host "\nNo high-signal anti-pattern warnings detected."
}