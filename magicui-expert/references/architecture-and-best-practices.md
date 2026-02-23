# Architecture and Best Practices

## Architecture Model

Magic UI components are mostly:

- Tailwind + `cn` utility based
- Client-reactive for animation-heavy behavior
- `motion/react` driven for transitions and interaction
- Highly configurable through props and CSS variables

Common structure:

1. Shell container (`relative`, layout classes)
2. Visual layer(s) (`absolute`, often `pointer-events-none`)
3. Content layer (`relative`)
4. Animation controllers (hooks + motion props)

## Integration Rules

- Add `"use client"` for files using browser APIs, motion hooks, or animation loops.
- Preserve `@/lib/utils` `cn()` class composition to keep styling conventions consistent.
- Favor semantic wrappers and pass explicit `aria-label` on custom interactive visuals.
- Keep dark/light compatibility via design tokens (`bg-background`, `text-foreground`).

## Performance Rules

- Stop or reduce animation work when not visible (`IntersectionObserver`, `useInView`).
- Memoize expensive computed values (`useMemo`, `useCallback`).
- Cleanup all timers, observers, listeners, and RAF handlers in `useEffect` return.
- Limit simultaneous heavy effects (particles + flickering grid + 3D globe together).

## Reliability Rules

- Validate prop ranges when source patterns do (example: zoom factor bounds).
- Keep default values for duration, opacity, and size aligned to source defaults.
- Expose tuning knobs as props, not hardcoded constants, when integrating into product code.

## Accessibility Rules

- Add keyboard exits for overlays/dialog-like interactions (`Escape` support).
- Use `sr-only` text for decorative text effects where visible text is stylized.
- Avoid pointer-only controls without keyboard equivalent.
