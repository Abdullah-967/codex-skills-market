# Architecture and Tools

## MCP Server Architecture (rudra016/aceternityui-mcp)

### Runtime

- Language: TypeScript
- Transport: MCP stdio
- Entrypoint: `src/index.ts`
- SDK: `@modelcontextprotocol/sdk`
- Validation: `zod`

### Request Handling

- `ListToolsRequestSchema` returns static `tools` list.
- `CallToolRequestSchema` routes to `toolHandlers[name]`.
- Each handler validates args via zod before execution.
- Tool result is returned as JSON-stringified `text` content.
- Unknown tools and execution failures return `isError: true` with explicit message.

### MCP Tool Surface

1. `search_components`
   - Input: `{ query: string, category?: string }`
   - Behavior: substring search across component `name`, `description`, and `tags`, plus exact category filter.

2. `get_component_info`
   - Input: `{ componentName: string }`
   - Behavior: case-insensitive exact name match in MCP catalog.

3. `get_installation_info`
   - Input: `{ componentName: string }`
   - Behavior: returns command, example command (`-e`), deps, and generic setup steps.

4. `list_categories`
   - Input: `{}`
   - Behavior: returns grouped category metadata and component names.

5. `get_all_components`
   - Input: `{ includeProOnly?: boolean }`
   - Behavior: returns MCP catalog list, filtering `isPro` by default.

### Internal Data Model

- Core catalog is static in `src/utils/components-data.ts`.
- Fields: `name`, `description`, `category`, `installCommand`, `dependencies`, `tags`, `isPro`, optional `documentation`.
- Catalog categories include: `layout`, `cards`, `form`, `navigation`, `background`, `utilities`, `map`, `sidebar`, `container`, `text`, `card`.

## Aceternity CLI and Registry Model

From `https://ui.aceternity.com/docs/cli`:

- Initialize: `npx shadcn@latest init`
- Add by URL: `npx shadcn@latest add https://ui.aceternity.com/registry/<component>.json`
- Recommended registry alias:

```json
{
  "registries": {
    "@aceternity": "https://ui.aceternity.com/registry/{name}.json"
  }
}
```

- Add by alias: `npx shadcn@latest add @aceternity/<component>`
- Discovery commands:
  - `npx shadcn@latest view @aceternity`
  - `npx shadcn@latest search @aceternity -q "<term>"`
  - `npx shadcn@latest list @aceternity`

## Bootstrapping Guidance

From installation docs:

- Next.js bootstrap: `npx create-next-app@latest`
- Tailwind v4 uses `@import "tailwindcss"` and `@tailwindcss/postcss`.
- Tailwind v3 uses `@tailwind base/components/utilities` and `tailwind.config` content paths.
- Utility baseline:
  - `npm i motion clsx tailwind-merge`
  - shared `cn()` utility in `lib/utils.ts`

## Compatibility Notes

Documented compatibility workaround for early Next.js 15 + React 19 RC requires version pinning/overrides for `motion` or `framer-motion`.

Treat this as conditional guidance for affected version sets only.
