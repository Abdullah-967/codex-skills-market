# Component Catalog

## MCP Catalog Snapshot (from `components-data.ts`)

This MCP dataset currently enumerates 24 components:

- bento-grid
- background-beams
- expandable-cards
- floating-dock
- focus-cards
- file-upload
- hero
- signup-form
- timeline
- world-map
- feature-section
- sidebar
- resizable-navbar
- loader
- layout-grid
- hero-highlight
- animated-tooltip
- container-cover
- placeholder-and-vanish-input
- animated-tabs
- text-generate-effect
- text-hover-effect
- typewriter-effect
- text-reveal-card

## MCP Categories

- layout: bento-grid, hero, timeline, feature-section, layout-grid, hero-highlight, animated-tooltip
- cards: expandable-cards, focus-cards
- form: file-upload, signup-form
- navigation: floating-dock, resizable-navbar
- background: background-beams, hero-highlight
- utilities: loader, placeholder-and-vanish-input
- map: world-map
- sidebar: sidebar
- container: container-cover, animated-tabs
- text: text-generate-effect, text-hover-effect, typewriter-effect
- card: text-reveal-card

## Broader Aceternity Component Families (Site Taxonomy)

From `https://ui.aceternity.com/components`:

- Backgrounds and effects
- Card components
- Scroll and parallax
- Text components
- Buttons
- Loaders
- Navigation
- Inputs and forms
- Overlays and popovers
- Carousels and sliders
- Layout and grid
- Data and visualization
- Cursor and pointer
- 3D
- Free sections/blocks and paid all-access blocks/templates

## Selection Heuristics

1. Start with user intent by section role:
   - Hero/landing -> `hero`, `hero-highlight`, `bento-grid`, `feature-section`
   - Navigation -> `floating-dock`, `resizable-navbar`, `sidebar`
   - Content reveal -> `animated-tabs`, `text-*`, `animated-tooltip`
   - Data storytelling -> `timeline`, `world-map`

2. Filter by interaction budget:
   - Low motion: `loader`, `text-generate-effect`
   - Medium motion: `focus-cards`, `resizable-navbar`
   - High motion: `background-beams`, `container-cover`

3. Validate dependency impact before committing component set.

## Installation Command Patterns

Two canonical command styles are valid:

1. URL registry style:
   - `npx shadcn@latest add https://ui.aceternity.com/registry/<name>.json`

2. Namespaced style (preferred after registry config):
   - `npx shadcn@latest add @aceternity/<name>`

Note: some legacy MCP commands include `*-demo` registry entries for examples.
Always prefer current command shown on the specific component page when available.
