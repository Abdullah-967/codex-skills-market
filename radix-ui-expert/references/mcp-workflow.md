# Radix MCP Workflow

## Tool Order

1. Enumerate catalog:
- `mcp__radix-ui__primitives_list_components`
- `mcp__radix-ui__themes_list_components`
- `mcp__radix-ui__colors_list_scales`

2. Load base docs:
- `mcp__radix-ui__primitives_get_getting_started`
- `mcp__radix-ui__themes_get_getting_started`

3. Retrieve exact docs for scope:
- `mcp__radix-ui__primitives_get_component_documentation`
- `mcp__radix-ui__themes_get_component_documentation`
- `mcp__radix-ui__colors_get_scale_documentation`

4. Retrieve source for non-obvious behavior:
- `mcp__radix-ui__primitives_get_component_source`
- `mcp__radix-ui__themes_get_component_source`
- `mcp__radix-ui__colors_get_scale`

## Failure Handling

- If component docs return 404, switch to source endpoint for that component.
- If both docs and source are unavailable, infer from adjacent components and mark as inference.
- Do not assume stale memory over MCP output for API shape.

## Required Reporting Format

When summarizing results, include:
- Which tools were called
- Which components/scales were inspected
- Whether conclusions came from docs or source
- Any unresolved ambiguity

## Preferred Source Scope

Start with these high-value primitives for architecture behavior:
- `slot`, `portal`, `dismissable-layer`, `focus-scope`, `roving-focus`, `presence`, `popper`

Start with these high-value themes components for system behavior:
- `theme`, `theme-panel`, `dialog`, `select`, `tabs`, `table`, `tooltip`

Start with these high-value color docs:
- `blue`, `gray`, `slate`, `mauve`, `blackA`, `whiteA`