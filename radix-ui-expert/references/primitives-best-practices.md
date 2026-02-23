# Radix Primitives Best Practices

## Composition

- Prefer wrapper components that re-export primitive parts with app-specific defaults.
- Use `asChild` to avoid extra DOM wrappers and preserve semantic elements.
- Keep wrapper props close to primitive API names to reduce cognitive load.

## State

- Expose both controlled and uncontrolled modes where practical.
- Do not mix controlled and uncontrolled usage in one instance.
- Preserve callback semantics (`onOpenChange`, `onValueChange`) and avoid side effects in render.

## Overlay And Focus

- For overlays, rely on Portal and DismissableLayer behavior rather than custom document listeners.
- Respect FocusScope patterns for trap/restore behavior.
- Ensure Escape and outside-click logic remains predictable after styling changes.

## Positioning And Animation

- Use Popper positioning data and CSS vars when available.
- Style against `data-side`, `data-align`, and `data-state` attributes.
- Avoid brittle positional logic in JS when CSS vars already express the geometry.

## Accessibility

- Keep primitive semantics and ARIA wiring intact.
- Preserve keyboard interactions (Tab, Shift+Tab, Enter, Space, Escape, Arrow keys where applicable).
- Use VisuallyHidden and Label patterns instead of DIY aria-only text hacks.

## Risk Checklist Before Merge

- Overlay opens/closes with keyboard and pointer.
- Focus returns to trigger on close when expected.
- No scroll-lock or body-pointer deadlock regressions.
- Screen-reader naming is preserved for triggers/content.