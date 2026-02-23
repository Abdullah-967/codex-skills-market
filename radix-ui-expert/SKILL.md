---
name: radix-ui-expert
description: Build, refactor, and troubleshoot Radix UI applications using Radix Primitives, Radix Themes, and Radix Colors. Use when implementing accessible headless UI components, composing layered overlays (Dialog/Popover/Dropdown/Tooltip), configuring Theme tokens and color scales, diagnosing controlled-vs-uncontrolled state bugs, or establishing production patterns for React/Next.js design systems based on @radix-ui/* packages.
---

# Radix UI Expert

## Overview

Use this skill to implement and maintain Radix-based interfaces with predictable accessibility, state behavior, and styling.

Prefer progressive disclosure:
1. Follow the MCP retrieval workflow to fetch only the required docs/source.
2. Apply architecture and best-practice rules from references.
3. Use scripts for repeatable local audits and scaffolding.

## MCP Tool Configuration And Retrieval Workflow

Use the connected Radix MCP tools in this order unless a narrower path is obvious:

1. Inventory surface area:
- `mcp__radix-ui__primitives_list_components`
- `mcp__radix-ui__themes_list_components`
- `mcp__radix-ui__colors_list_scales`

2. Load foundations:
- `mcp__radix-ui__primitives_get_getting_started`
- `mcp__radix-ui__themes_get_getting_started`

3. Pull targeted API docs for the exact components in scope:
- `mcp__radix-ui__primitives_get_component_documentation`
- `mcp__radix-ui__themes_get_component_documentation`
- `mcp__radix-ui__colors_get_scale_documentation`

4. Pull source for architecture-level behavior or non-obvious edge cases:
- `mcp__radix-ui__primitives_get_component_source`
- `mcp__radix-ui__themes_get_component_source`
- `mcp__radix-ui__colors_get_scale`

5. If a docs endpoint fails (for example 404 for a specific component), fall back to:
- Another related component docs page
- Source retrieval for the target component
- Repository-level behavior inference, marked clearly as inference

Use `references/mcp-workflow.md` for the full SOP and troubleshooting behavior.

## Standard Operating Procedure

1. Classify the task:
- Primitives behavior/composition issue
- Themes styling/token issue
- Colors scale/semantic token issue
- Mixed system issue

2. Discover current project usage before editing:
- Run `scripts/audit-radix-usage.ps1`
- Confirm installed packages, imported components, and anti-pattern signals

3. Resolve with Radix architecture rules:
- Composition: prefer `asChild` and wrappers around primitives
- State: support controlled and uncontrolled props without mixing semantics
- Layering: use Portal/DismissableLayer/FocusScope patterns
- Accessibility: keep keyboard/focus semantics and ARIA contracts intact

4. Apply styling correctly:
- Prefer data attributes and Radix CSS variables over brittle selectors
- In Themes, set global tokens in `Theme`; use local overrides sparingly
- Use semantic aliases for color tokens instead of hardcoding raw scale steps everywhere

5. Validate:
- Keyboard traversal and escape behavior
- Focus trap/restore behavior for overlays
- Collision-aware positioning for floating content
- Dark/light appearance behavior if Themes is used

## Core Architecture Rules

- Build wrappers around primitive parts to centralize app conventions.
- Preserve `data-*` attributes in styling and animation contracts (`data-state`, `data-side`, `data-align`).
- Avoid ad-hoc global z-index hacks; use Radix layering primitives first.
- Treat docs as contract and source as implementation detail; consult source only for ambiguity.

Detailed guidance:
- Primitives patterns: `references/primitives-best-practices.md`
- Themes and colors patterns: `references/themes-colors-best-practices.md`
- Component catalog snapshot: `references/component-catalog.md`

## Scripts

### `scripts/audit-radix-usage.ps1`

Audit Radix usage in a repository.

Usage:
```powershell
pwsh ./scripts/audit-radix-usage.ps1 -Root .
```

Outputs:
- Installed `@radix-ui/*` and `@radix-ui/themes` dependencies
- Import usage frequencies
- Potential anti-pattern warnings (mixed controlled/uncontrolled usage markers, excessive z-index usage around overlays)

### `scripts/scaffold-radix-wrapper.ps1`

Generate a typed React wrapper template for a primitive part.

Usage:
```powershell
pwsh ./scripts/scaffold-radix-wrapper.ps1 -Primitive dialog -Part content -OutFile src/components/ui/dialog-content.tsx
```

This produces a `forwardRef` wrapper with `asChild`-safe props and data-attribute-friendly class merge points.

## Output Quality Bar

- Never regress keyboard or focus behavior.
- Keep wrappers thin and deterministic.
- Keep naming aligned with Radix conventions (`Root`, `Trigger`, `Content`, etc.).
- For Themes, define shared design tokens in one place before per-component overrides.
- For Colors, use semantic aliasing for mutable light/dark strategies.