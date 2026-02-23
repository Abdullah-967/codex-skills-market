---
name: aceternity-ui-expert
description: Build, refactor, and troubleshoot Aceternity UI integrations using shadcn-compatible registries and MCP workflows. Use when selecting components, generating install commands, setting up Next.js and Tailwind, resolving motion/dependency issues, creating landing page sections, or auditing Aceternity component usage across React/Next.js projects.
---

# Aceternity UI Expert

## Overview

Use this skill when work involves Aceternity UI component integration, shadcn CLI workflows, MCP-based component discovery, or landing page development with animated UI blocks. It provides a repeatable MCP-driven workflow, install scripts, and best practices for React/Next.js projects.

## Trigger Guidance

Use this skill when requests include:

- "Add Aceternity component to my project"
- "Set up animated hero/background section"
- "Install bento-grid/floating-dock/etc."
- "Search for Aceternity components"
- "Fix Aceternity motion/hydration errors"
- "Audit Aceternity usage in project"

## Tool Configuration (MCP)

Aceternity MCP exposes tools for component discovery and installation info.

**Available Tools:**
- `search_components` — Search by keyword and optional category
- `get_component_info` — Get details for a specific component
- `get_installation_info` — Get install command and dependencies
- `list_categories` — List all component categories
- `get_all_components` — Get full component catalog

## Standard Workflow

1. Confirm target stack: `Next.js`, `React`, `Tailwind` version, package manager, monorepo vs single app.
2. Validate project bootstrapping and CLI readiness.
3. Discover candidate components.
4. Produce install commands and dependency checklist.
5. Integrate components with strict import/util conventions.
6. Verify render quality, hydration safety, and performance.

## Tooling Configuration (Canonical)

Prefer these tool patterns in all Aceternity tasks:

### MCP Discovery Sequence

1. `search_components` with a semantic query and optional category.
2. `get_component_info` for each shortlisted component.
3. `get_installation_info` for final component choices.
4. `list_categories` when user intent is broad.
5. `get_all_components` for full inventory or audits.

### shadcn CLI Sequence

1. Initialize project once:
   - `npx shadcn@latest init`
2. Install from URL registry:
   - `npx shadcn@latest add https://ui.aceternity.com/registry/<component>.json`
3. Prefer namespaced registry in `components.json` when repeated installs are expected:
   - `"@aceternity": "https://ui.aceternity.com/registry/{name}.json"`
   - `npx shadcn@latest add @aceternity/<component>`

## Required Best Practices

1. Always verify Tailwind setup before adding components.
2. Always add shared `cn` utility (`clsx` + `tailwind-merge`) before large component integration.
3. Resolve `motion` and React/Next compatibility early (especially Next.js 15 + React 19 RC).
4. Prefer categories and tags for initial narrowing; prefer per-component docs for final selection.
5. Install only components needed for the task to reduce bundle overhead.
6. Keep animations intentional; remove redundant nested motion wrappers where possible.
7. When multiple components share visual responsibility, define one primary animated layer.
8. For monorepos, use shadcn `-c/--cwd` to target the exact app workspace.

## Resources

### scripts/

- `scripts/Get-AceternityComponents.ps1` — Extract and normalize MCP component data.
- `scripts/New-AceternityInstallPlan.ps1` — Generate install commands for component list.

### references/

- `references/architecture-and-tools.md` — MCP server architecture and CLI patterns.
- `references/mcp-workflow.md` — MCP tool invocation order and sequences.
- `references/tool-catalog.md` — Complete tool reference with parameters.
- `references/best-practices-and-sop.md` — Installation SOPs and troubleshooting.
- `references/component-catalog.md` — Component inventory and selection heuristics.

## Output Expectations

When completing user tasks with this skill:

1. Provide exact install commands.
2. Provide dependency deltas (`npm i ...`) explicitly.
3. Call out assumptions for Tailwind/Next versions.
4. Include a validation checklist (build, dev server, runtime interaction).

## Fail-safe Rules

1. If a component is missing from MCP catalog, verify directly on `ui.aceternity.com/components` before concluding unsupported.
2. If docs conflict, prioritize:
   1) current component page install command,
   2) CLI docs,
   3) older MCP component-data defaults.
3. If installation fails due peer deps, propose minimal overrides first and avoid broad forced upgrades.
