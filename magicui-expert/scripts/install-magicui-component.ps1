param(
  [Parameter(Mandatory = $true)]
  [string]$ComponentName,

  [ValidateSet("pnpm", "npm", "yarn", "bun")]
  [string]$PackageManager = "pnpm",

  [switch]$DryRun
)

$component = $ComponentName.Trim().ToLower()
if ($component -notmatch '^[a-z0-9-]+$') {
  throw "ComponentName must use lowercase letters, numbers, and hyphens only."
}

$registryUrl = "https://magicui.design/r/$component.json"

switch ($PackageManager) {
  "pnpm" {
    $command = "pnpm dlx shadcn@latest add `"$registryUrl`""
    if ($DryRun) { Write-Output $command; break }
    & pnpm dlx shadcn@latest add $registryUrl
    break
  }
  "npm" {
    $command = "npx shadcn@latest add `"$registryUrl`""
    if ($DryRun) { Write-Output $command; break }
    & npx shadcn@latest add $registryUrl
    break
  }
  "yarn" {
    $command = "yarn dlx shadcn@latest add `"$registryUrl`""
    if ($DryRun) { Write-Output $command; break }
    & yarn dlx shadcn@latest add $registryUrl
    break
  }
  "bun" {
    $command = "bunx shadcn@latest add `"$registryUrl`""
    if ($DryRun) { Write-Output $command; break }
    & bunx shadcn@latest add $registryUrl
    break
  }
}

Write-Output "Installed Magic UI component '$component'. Import from '@/components/ui/$component'."
