---
name: magicui-expert
description: Build, refactor, and troubleshoot Magic UI components in React/Next.js apps. Use for Magic UI component selection, installation via shadcn registry URLs, animation/background/text effect composition, performance tuning, and accessibility-safe integration.
---

# Magic UI Expert

## Overview

Use this skill when work involves `magicui.design` components, animated UI blocks, or migration of landing-page effects into production React/Next.js code. It provides a repeatable MCP-driven workflow, install/scaffold/audit scripts, and implementation best practices derived from Magic UI component source patterns.

## Trigger Guidance

Use this skill when requests include:

- "Use Magic UI component X"
- "Add animated hero/background/text effect"
- "Install component from magicui.design registry"
- "Fix jitter/perf issues in animated section"
- "Audit Magic UI usage/client-boundary issues"

## Tool Configuration (MCP)

Use Magic UI MCP tools in this order:

1. `mcp__magicui__getUIComponents` to enumerate available components quickly.
2. Group-specific fetchers to pull implementation details:
- `mcp__magicui__getButtons`
- `mcp__magicui__getBackgrounds`
- `mcp__magicui__getAnimations`
- `mcp__magicui__getTextAnimations`
- `mcp__magicui__getSpecialEffects`
- `mcp__magicui__getDeviceMocks`
- `mcp__magicui__getComponents`
3. Use only relevant groups for the requested feature to keep context focused.

## Standard Workflow

1. Discovery
- Call `mcp__magicui__getUIComponents` to shortlist candidates by name/description.
- Pick a component group and fetch implementation source for the candidates.

2. Install
- Use `scripts/install-magicui-component.ps1` for deterministic install commands.
- Registry format: `https://magicui.design/r/<component-name>.json`.
- Default import path after install: `@/components/ui/<component-name>`.

3. Integrate
- Keep animated/interactive components inside client boundaries (`"use client"` when required).
- Preserve Magic UI patterns: `motion/react`, `cn` utility from `@/lib/utils`, CSS variable-based customization, and composable Tailwind classes.
- For layered effects, use `relative` wrappers and `absolute pointer-events-none` overlays.

4. Validate
- Run `scripts/audit-magicui-usage.ps1` to flag common integration issues:
- `motion/react` usage without `"use client"`.
- Magic UI component import inventory and usage hotspots.

5. Scaffold (optional)
- Use `scripts/scaffold-magicui-showcase.ps1` to generate a starter showcase section.

## Embedded Best Practices

Derived from Magic UI MCP component sources:

- Prefer prop-driven customization over hardcoded classes (`duration`, `color`, `size`, offsets, glow/gradient vars).
- Use memoization where animation work is non-trivial (`useMemo`, `useCallback`, `React.memo` patterns appear repeatedly).
- Guard browser-only APIs (`window`, `document`, `ResizeObserver`, `IntersectionObserver`) with client/runtime-safe usage.
- Always clean up listeners/observers/RAF in `useEffect` cleanup.
- For expensive effects, pause/reduce work off-screen (intersection checks are common in grid/particle components).
- Add accessible fallbacks: `aria-label`, keyboard close handlers (`Escape`), and `sr-only` text for decorative effects.
- Keep theme compatibility by respecting CSS tokens (`bg-background`, `text-foreground`, `dark:*`) instead of fixed palette defaults.

## Installation Patterns

Package manager mappings:

- `pnpm`: `pnpm dlx shadcn@latest add "https://magicui.design/r/<name>.json"`
- `npm`: `npx shadcn@latest add "https://magicui.design/r/<name>.json"`
- `yarn`: `yarn dlx shadcn@latest add "https://magicui.design/r/<name>.json"`
- `bun`: `bunx shadcn@latest add "https://magicui.design/r/<name>.json"`

## Resources

### scripts/

- `scripts/install-magicui-component.ps1`
Purpose: install a specific Magic UI component using the requested package manager.

- `scripts/audit-magicui-usage.ps1`
Purpose: scan project files for Magic UI imports and common client-boundary issues.

- `scripts/scaffold-magicui-showcase.ps1`
Purpose: generate a starter showcase section with common Magic UI components.

### references/

- `references/mcp-workflow.md`
MCP retrieval workflow and selection strategy.

- `references/architecture-and-best-practices.md`
Architecture model, integration guardrails, and production checklists.

- `references/component-catalog.md`
Catalog snapshot of Magic UI component groups and high-value picks.
