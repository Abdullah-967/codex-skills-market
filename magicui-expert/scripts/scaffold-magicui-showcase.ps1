param(
  [string]$OutputPath = "src/components/magicui-showcase.tsx"
)

$outputDir = Split-Path -Path $OutputPath -Parent
if ($outputDir -and -not (Test-Path $outputDir)) {
  New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$content = @'
"use client"

import { MagicCard } from "@/components/ui/magic-card"
import { BorderBeam } from "@/components/ui/border-beam"
import { AnimatedGradientText } from "@/components/ui/animated-gradient-text"
import { ShimmerButton } from "@/components/ui/shimmer-button"

export function MagicUiShowcase() {
  return (
    <section className="relative mx-auto w-full max-w-5xl px-6 py-16">
      <MagicCard className="relative overflow-hidden rounded-2xl p-8">
        <BorderBeam size={80} duration={8} />
        <p className="mb-3 text-sm text-muted-foreground">Magic UI Showcase</p>
        <h2 className="text-3xl font-semibold leading-tight">
          <AnimatedGradientText>Shipped with reusable motion primitives</AnimatedGradientText>
        </h2>
        <p className="mt-4 max-w-2xl text-muted-foreground">
          This starter section demonstrates safe composition of layered effects.
        </p>
        <div className="mt-6">
          <ShimmerButton>Explore Components</ShimmerButton>
        </div>
      </MagicCard>
    </section>
  )
}
'@

Set-Content -Path $OutputPath -Value $content -NoNewline
Write-Output "Generated Magic UI showcase at $OutputPath"
