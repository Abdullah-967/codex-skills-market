# Radix Themes And Colors Best Practices

## Theme Architecture

- Use a top-level `Theme` as the system source of truth.
- Set appearance, accent color, gray color, radius, and scaling centrally.
- Use nested themes only for intentional local exceptions.

## Styling Strategy

- Prefer Theme tokens and component props before custom CSS overrides.
- Use custom CSS for layout/brand-specific behavior, not for reimplementing component states.
- Preserve Radix `data-*` attributes and CSS vars for stateful styling.

## Color Scale Guidance

- Use semantic aliases for business meaning (for example `--color-danger-surface`).
- Map aliases to Radix scales instead of hardcoding direct hex values in components.
- Keep light/dark mappings mutable at token level.

## Scale Usage Heuristic

- Steps 1-2: app backgrounds and subtle surfaces
- Steps 3-5: component backgrounds and borders
- Steps 6-8: interactive borders/fills and stronger UI affordances
- Steps 9-10: solid accents and interactive controls
- Steps 11-12: high-contrast text and critical foregrounds

## Theme Migration SOP

1. Replace local hardcoded values with semantic aliases.
2. Introduce `Theme` at app root.
3. Convert highest-traffic components first (Button, TextField, Select, Dialog).
4. Validate dark/light parity and contrast.
5. Remove obsolete per-component token hacks.