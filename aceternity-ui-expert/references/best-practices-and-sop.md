# Best Practices and SOP

## SOP: New Aceternity Integration

1. Confirm baseline:
   - Next.js version
   - React version
   - Tailwind v3 or v4
   - package manager and monorepo layout

2. Initialize shadcn if not present:
   - `npx shadcn@latest init`

3. Add shared utilities and motion deps:
   - `npm i motion clsx tailwind-merge`
   - create `lib/utils.ts` with `cn()`

4. Add Aceternity registry alias to `components.json`:

```json
{
  "registries": {
    "@aceternity": "https://ui.aceternity.com/registry/{name}.json"
  }
}
```

5. Install selected components:
   - `npx shadcn@latest add @aceternity/<component>`

6. Validate:
   - `npm run dev`
   - check hydration warnings
   - verify interaction FPS and no layout jank

## SOP: Component Discovery via MCP

1. Run `search_components` with user goal keywords.
2. If too broad, apply category filter.
3. Run `get_component_info` for top candidates.
4. Run `get_installation_info` for finalists.
5. Return final options with tradeoffs:
   - dependency count
   - motion intensity
   - expected customization effort

## Dependency and Compatibility Policy

1. Prefer `motion` package in modern setups where supported.
2. If React 19 RC and Next.js 15 compatibility issues occur, apply documented overrides narrowly.
3. Avoid global peer-dep bypasses unless last resort.
4. Keep utility stack consistent: `clsx` + `tailwind-merge`.

## Code Quality Policy

1. Keep animation ownership clear (one dominant animated layer per section).
2. Do not nest heavy animated wrappers without a visual reason.
3. Remove dead imports and unused icon packs after experimentation.
4. Co-locate component demos/tests with feature directories.

## Troubleshooting Matrix

- Symptom: install command fails with registry not found
  - Check `components.json` registry key and URL template.

- Symptom: component renders unstyled
  - Verify Tailwind setup and global CSS import style (v3 vs v4).

- Symptom: motion runtime errors
  - Verify `motion`/`framer-motion` version compatibility with React/Next.

- Symptom: CLI writes into wrong app in monorepo
  - Use `npx shadcn@latest add ... -c <app-path>`.

- Symptom: MCP returns component not found
  - Use exact component name; fallback to site component page for latest naming.

## Delivery Checklist for Agent Outputs

- Include exact commands in execution order.
- Include file paths to be edited (`components.json`, `lib/utils.ts`, component files).
- Include dependency diff.
- Include verification steps.
- Include rollback steps for problematic additions.
