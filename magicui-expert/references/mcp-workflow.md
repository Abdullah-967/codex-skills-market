# MCP Workflow for Magic UI

## Purpose

Use this sequence to gather just enough source context before implementing changes.

## Sequence

1. Call `mcp__magicui__getUIComponents`
- Build a shortlist from names + descriptions.

2. Call only relevant group endpoints
- Buttons: `mcp__magicui__getButtons`
- Backgrounds: `mcp__magicui__getBackgrounds`
- Animations: `mcp__magicui__getAnimations`
- Text animations: `mcp__magicui__getTextAnimations`
- Special effects: `mcp__magicui__getSpecialEffects`
- Device mocks: `mcp__magicui__getDeviceMocks`
- General set: `mcp__magicui__getComponents`

3. Extract implementation patterns
- Props and defaults
- Required client hooks (`useEffect`, `useInView`, `useScroll`)
- Cleanup logic and performance controls
- Tailwind/cn composition conventions

4. Implement and verify
- Install via `scripts/install-magicui-component.ps1`
- Integrate components
- Audit via `scripts/audit-magicui-usage.ps1`

## Selection Heuristics

- Choose one hero effect, one supporting effect, and one CTA effect.
- Avoid stacking multiple heavy canvas/WebGL effects in one viewport region.
- Prefer components with prop-level controls when product teams need easy tuning.
