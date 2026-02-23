# Aceternity MCP Tool Catalog

Complete reference of all Aceternity MCP tools with parameters and usage guidance.

## Server Configuration

**Transport:** stdio (`StdioServerTransport`)
**SDK:** `@modelcontextprotocol/sdk`
**Validation:** `zod`
**Data Source:** Static catalog in `components-data.ts`

## Tools

### search_components

Search for components by keyword and optional category filter.

**Risk Level:** Read-only

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| query | string | Yes | Search keywords (matches name, description, tags) |
| category | string | No | Filter by exact category name |

**Returns:**
```json
[
  {
    "name": "bento-grid",
    "description": "A responsive grid layout...",
    "category": "layout",
    "tags": ["grid", "responsive", "layout"]
  }
]
```

**Search Behavior:**
- Substring match across `name`, `description`, and `tags`.
- Category filter is exact match.
- Case-insensitive.

---

### get_component_info

Get detailed information about a specific component.

**Risk Level:** Read-only

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| componentName | string | Yes | Exact component name |

**Returns:**
```json
{
  "name": "bento-grid",
  "description": "A responsive grid layout with customizable items",
  "category": "layout",
  "installCommand": "npx shadcn@latest add https://ui.aceternity.com/registry/bento-grid.json",
  "dependencies": ["motion", "clsx", "tailwind-merge"],
  "tags": ["grid", "responsive", "layout"],
  "isPro": false,
  "documentation": "https://ui.aceternity.com/components/bento-grid"
}
```

**Error States:**
- Returns error if component not found (case-insensitive match).

---

### get_installation_info

Get installation command and setup steps for a component.

**Risk Level:** Read-only

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| componentName | string | Yes | Exact component name |

**Returns:**
```json
{
  "command": "npx shadcn@latest add https://ui.aceternity.com/registry/bento-grid.json",
  "exampleCommand": "npx shadcn@latest add https://ui.aceternity.com/registry/bento-grid.json -e",
  "dependencies": ["motion", "clsx", "tailwind-merge"],
  "setupSteps": [
    "Initialize shadcn: npx shadcn@latest init",
    "Install dependencies: npm i motion clsx tailwind-merge",
    "Add cn utility to lib/utils.ts"
  ]
}
```

**Use When:**
- Generating final install commands for user.
- Building dependency checklists.

---

### list_categories

List all available component categories with their components.

**Risk Level:** Read-only

**Parameters:** None

**Returns:**
```json
{
  "categories": [
    {
      "name": "layout",
      "description": "Layout and grid components",
      "components": ["bento-grid", "hero", "timeline", "feature-section", "layout-grid", "hero-highlight", "animated-tooltip"]
    },
    {
      "name": "cards",
      "components": ["expandable-cards", "focus-cards"]
    },
    {
      "name": "navigation",
      "components": ["floating-dock", "resizable-navbar"]
    }
  ]
}
```

**Use When:**
- User intent is vague (e.g., "what components are available?").
- Building category-based discovery flow.

---

### get_all_components

Get the complete component catalog.

**Risk Level:** Read-only

**Parameters:**
| Name | Type | Required | Description |
|------|------|----------|-------------|
| includeProOnly | boolean | No | Include pro-only components (default: false) |

**Returns:**
```json
[
  {
    "name": "bento-grid",
    "description": "...",
    "category": "layout",
    "isPro": false,
    ...
  },
  {
    "name": "floating-dock",
    ...
  }
]
```

**Use When:**
- Full inventory or audit.
- Building custom filtering logic.
- Migration planning.

## Component Categories

| Category | Description | Components |
|----------|-------------|------------|
| layout | Layout and grid | bento-grid, hero, timeline, feature-section, layout-grid, hero-highlight, animated-tooltip |
| cards | Card components | expandable-cards, focus-cards |
| form | Form elements | file-upload, signup-form |
| navigation | Navigation UI | floating-dock, resizable-navbar |
| background | Background effects | background-beams, hero-highlight |
| utilities | Utility components | loader, placeholder-and-vanish-input |
| map | Map components | world-map |
| sidebar | Sidebar components | sidebar |
| container | Container components | container-cover, animated-tabs |
| text | Text effects | text-generate-effect, text-hover-effect, typewriter-effect |
| card | Card effects | text-reveal-card |

## Installation Command Patterns

### URL Registry Style (default)

```
npx shadcn@latest add https://ui.aceternity.com/registry/<name>.json
```

### Namespaced Style (after registry config)

```
npx shadcn@latest add @aceternity/<name>
```

Requires `components.json` registry entry:
```json
{
  "registries": {
    "@aceternity": "https://ui.aceternity.com/registry/{name}.json"
  }
}
```

### With Example Flag

```
npx shadcn@latest add https://ui.aceternity.com/registry/<name>.json -e
```

## Common Dependencies

Most Aceternity components require:

| Package | Purpose |
|---------|---------|
| motion | Animation library |
| clsx | Conditional class joining |
| tailwind-merge | Tailwind class merging |

Install baseline: `npm i motion clsx tailwind-merge`

## Risk Level Reference

| Level | Description | Action Required |
|-------|-------------|-----------------|
| Read-only | Safe to call anytime | None |

All Aceternity MCP tools are read-only discovery operations.
