# Best Practices and Troubleshooting

## High-impact best practices

1. Always import stylesheet:
   - `import '@xyflow/react/dist/style.css';`

2. Always give `<ReactFlow />` a sized parent:
   - Missing width/height prevents rendering.

3. Keep prop references stable:
   - Memoize handlers with `useCallback`.
   - Memoize/static-define `nodeTypes`, `edgeTypes`, `defaultEdgeOptions`, `snapGrid`.
   - Avoid recreating component references passed to `ReactFlow`.

4. Respect provider boundaries:
   - `useReactFlow`/`useStore`/similar hooks must be used within `ReactFlowProvider`/`ReactFlow` context.

5. Prefer `isValidConnection` on `<ReactFlow />` for connection validation logic (better perf than per-handle validation in many cases).

6. Manage scale carefully:
   - Avoid deriving UI directly from frequently-mutating full `nodes`/`edges`.
   - Store lightweight derived state (for example selected IDs) separately.
   - Collapse deep trees using `hidden` toggling when needed.
   - Simplify expensive CSS effects (heavy shadows, gradients, animations) for large graphs.

7. Dynamic handle updates:
   - If handles are changed programmatically or after async data, call `useUpdateNodeInternals`.

## Frequent errors and fixes

- Error: missing Zustand/provider context.
  - Fix: wrap with `ReactFlowProvider`; ensure hook consumers are descendants.

- Warning: new `nodeTypes`/`edgeTypes` object created each render.
  - Fix: move object to module scope or memoize with `useMemo`.

- Warning: custom node type not found.
  - Fix: ensure `node.type` exactly matches key in `nodeTypes`.

- Warning: parent container needs width/height.
  - Fix: set explicit or inherited dimensions on wrapper.

- Warning: edge requires `source` and `target`.
  - Fix: guarantee both on edge creation.

- Warning: source/target handle id not found.
  - Fix: ensure handle IDs exist and call `updateNodeInternals` after handle changes.

- Edges not visible/correct:
  - Ensure stylesheet imported.
  - Ensure custom nodes include proper handles.
  - Avoid CSS frameworks overriding `.react-flow__edges` SVG behavior.
  - For hidden handles, use `opacity: 0` or `visibility: hidden`, not `display: none`.
  - For custom edges, pass correct `sourceX/sourceY/targetX/targetY` and handle positions to path helpers.

## Utilities behavior notes

- `addEdge` validates source/target and avoids duplicate logical connections (same source/target + handles) even with different `id`.
- `reconnectEdge` updates an existing edge from a new connection and can replace edge ID.
- `applyNodeChanges`/`applyEdgeChanges` are drop-in reducers for ReactFlow change events.

