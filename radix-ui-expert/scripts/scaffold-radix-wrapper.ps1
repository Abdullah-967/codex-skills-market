param(
  [Parameter(Mandatory = $true)]
  [string]$Primitive,

  [Parameter(Mandatory = $true)]
  [string]$Part,

  [Parameter(Mandatory = $true)]
  [string]$OutFile,

  [string]$Package
)

$ErrorActionPreference = "Stop"

function Convert-ToPascalCase {
  param([string]$Text)
  return (($Text -split "[-._]") | Where-Object { $_ -ne "" } | ForEach-Object {
    if ($_.Length -eq 1) { $_.ToUpper() } else { $_.Substring(0,1).ToUpper() + $_.Substring(1) }
  }) -join ""
}

if (-not $Package) {
  $Package = "@radix-ui/react-$Primitive"
}

$primitiveNs = Convert-ToPascalCase $Primitive
$partName = Convert-ToPascalCase $Part
$wrapperName = "$primitiveNs$partName"

$dir = Split-Path -Parent $OutFile
if (-not [string]::IsNullOrWhiteSpace($dir) -and -not (Test-Path $dir)) {
  New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

$template = @"
import * as React from \"react\";
import * as $primitiveNs from \"$Package\";

function cx(...classes: Array<string | undefined | false | null>) {
  return classes.filter(Boolean).join(\" \" );
}

const PrimitivePart = $primitiveNs.$partName;

type ${wrapperName}Element = React.ElementRef<typeof PrimitivePart>;
type ${wrapperName}Props = React.ComponentPropsWithoutRef<typeof PrimitivePart>;

export const $wrapperName = React.forwardRef<${wrapperName}Element, ${wrapperName}Props>(
  ({ className, ...props }, ref) => {
    return <PrimitivePart ref={ref} className={cx(className)} {...props} />;
  }
);

$wrapperName.displayName = \"$wrapperName\";
"@

Set-Content -Path $OutFile -Value $template -NoNewline
Write-Host "Generated wrapper: $OutFile"
Write-Host "Primitive package: $Package"
Write-Host "Part: $partName"