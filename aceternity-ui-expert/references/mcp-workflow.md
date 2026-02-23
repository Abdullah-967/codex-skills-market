# MCP Workflow

Use this sequence when executing Aceternity UI MCP operations.

## Required Sequence by Operation Type

### Component Discovery (Broad Search)

1. List categories (if intent is vague):
   - Call `list_categories` to understand available groups.

2. Search with keywords:
   - Call `search_components` with user goal keywords.
   - Optionally filter by category.

3. Get details for candidates:
   - Call `get_component_info` for each shortlisted component.

4. Get installation info:
   - Call `get_installation_info` for final choices.

### Component Discovery (Specific Need)

1. Search directly:
   - Call `search_components` with specific query (e.g., "hero", "navbar").

2. Get component info:
   - Call `get_component_info` for exact component name.

3. Get installation:
   - Call `get_installation_info` for install command and dependencies.

### Full Inventory/Audit

1. Get all components:
   - Call `get_all_components` with `includeProOnly: false`.

2. Process catalog:
   - Filter by category, tags, or dependencies as needed.

## Tool Invocation Patterns

### Category Discovery

```
MCP tool: list_categories
  → Returns: { categories: [{ name: "layout", components: ["bento-grid", "hero", ...] }, ...] }
```

### Keyword Search

```
MCP tool: search_components
  Args: { query: "animated background", category: "background" }
  → Returns: [{ name: "background-beams", description: "...", ... }]
```

### Component Details

```
MCP tool: get_component_info
  Args: { componentName: "bento-grid" }
  → Returns: { name: "bento-grid", description: "...", category: "layout", tags: [...], dependencies: [...] }
```

### Installation Info

```
MCP tool: get_installation_info
  Args: { componentName: "bento-grid" }
  → Returns: { 
      command: "npx shadcn@latest add https://ui.aceternity.com/registry/bento-grid.json",
      dependencies: ["motion", "clsx", "tailwind-merge"],
      setupSteps: [...]
    }
```

### Full Catalog

```
MCP tool: get_all_components
  Args: { includeProOnly: false }
  → Returns: [{ name: "bento-grid", ... }, { name: "floating-dock", ... }, ...]
```

## Decision Rules

- Start with `list_categories` when user intent is vague.
- Use `search_components` with category filter to narrow results.
- Always call `get_installation_info` before generating install commands.
- Prefer MCP catalog for discovery, but verify against site for latest naming.

## Error Recovery

### "Component not found"

1. Verify exact component name (case-insensitive match).
2. Try `search_components` with partial name.
3. Fall back to `ui.aceternity.com/components` for current naming.

### "No results for search"

1. Broaden query terms.
2. Remove category filter.
3. Use `get_all_components` and filter manually.

## Workflow Examples

### User: "I need an animated hero section"

```
1. search_components({ query: "hero" })
   → Returns: hero, hero-highlight
   
2. get_component_info({ componentName: "hero" })
   → Review: layout component, high motion
   
3. get_component_info({ componentName: "hero-highlight" })
   → Review: background+highlight effect
   
4. get_installation_info({ componentName: "hero" })
   → Get install command and deps
```

### User: "What navigation components are available?"

```
1. list_categories({})
   → Find "navigation" category
   
2. search_components({ query: "", category: "navigation" })
   → Returns: floating-dock, resizable-navbar
   
3. get_component_info for each to compare
```

### User: "Audit all Aceternity components in use"

```
1. get_all_components({ includeProOnly: false })
   → Get full catalog
   
2. Compare against project imports
```
