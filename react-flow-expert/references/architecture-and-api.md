# React Flow Architecture and API Map

## Source of truth used

- `packages/react/src/index.ts` export surface.
- `packages/react/src/components/ReactFlowProvider/index.tsx`.
- `packages/react/src/hooks/useReactFlow.ts`.
- `packages/react/src/hooks/useStore.ts`.
- `packages/react/src/utils/changes.ts`.
- `packages/system/src/utils/edges/general.ts`.
- Docs pages under `https://reactflow.dev` (Quick Start, API Reference, Hooks/Providers, Performance, State Management, TypeScript, Common Errors).

## Mental model

- `ReactFlow` is the rendering/runtime core for nodes, edges, and viewport interaction.
- `ReactFlowProvider` provides store context (Zustand-backed) for hooks and out-of-canvas consumers.
- Hooks expose high-level instance and state access:
  - instance API: `useReactFlow`
  - state selectors: `useStore`, `useStoreApi`, `useNodes`, `useEdges`, `useViewport`
  - convenience state hooks: `useNodesState`, `useEdgesState`
- Utilities support controlled updates and graph operations:
  - update helpers: `applyNodeChanges`, `applyEdgeChanges`
  - graph helpers: `addEdge`, `reconnectEdge`, `getIncomers`, `getOutgoers`, `getConnectedEdges`

## Core exported building blocks

- Main: `ReactFlow`, `ReactFlowProvider`
- UI components: `Background`, `Controls`, `MiniMap`, `Panel`, `Handle`, `NodeResizer`, `NodeToolbar`, `EdgeLabelRenderer`, `ViewportPortal`, edge primitives (`BaseEdge`, `BezierEdge`, `SmoothStepEdge`, etc.)
- Hooks: `useReactFlow`, `useStore`, `useStoreApi`, `useNodesState`, `useEdgesState`, `useUpdateNodeInternals`, `useOnSelectionChange`, `useOnViewportChange`, and others.
- Utils: `addEdge`, `reconnectEdge`, `applyNodeChanges`, `applyEdgeChanges`, path helpers and bounds helpers.

## Controlled-flow baseline

- Keep external state for `nodes` and `edges`.
- Pass `onNodesChange` and `onEdgesChange` using `applyNodeChanges`/`applyEdgeChanges`.
- Pass `onConnect` using `addEdge`.
- This is the canonical pattern in docs and package examples.

## Provider semantics

- Hooks that depend on internal flow state require provider ancestry.
- Provider remarks from source/docs:
  - Place provider outside router if state persistence across routes is required.
  - Use separate providers for multiple flows.

## TypeScript strategy

- Start with `Node`/`Edge` base types for simple flows.
- For custom nodes/edges, define specific types and union them.
- Pass union types to `ReactFlow` generics and related callbacks/hooks.
- Use type guards when narrowing node/edge variants.

