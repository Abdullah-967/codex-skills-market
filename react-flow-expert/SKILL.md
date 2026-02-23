---
name: react-flow-expert
description: Build, refactor, debug, and optimize React Flow apps with @xyflow/react. Use when implementing flows, custom nodes/edges, hooks/provider patterns, TypeScript typing, performance tuning, state management, or troubleshooting common React Flow errors.
---

# React Flow Expert

Use this skill for React Flow tasks that need reliable implementation details from official xyflow docs and source.

## Workflow

1. Confirm package and version target:
   - Prefer `@xyflow/react` (React Flow 12+).
   - For legacy `reactflow` (v11), call out migration risk.

2. Retrieve authoritative context from MCP (required order):
   - Call `mcp__xyflow-docs__fetch_xyflow_documentation` first.
   - Then use:
     - `mcp__xyflow-docs__search_xyflow_code` for implementation context in `packages/react/src` and `packages/system/src`.
     - `mcp__xyflow-docs__fetch_generic_url_content` for exact docs pages on `https://reactflow.dev/...` and raw GitHub source files.

3. Apply the implementation pattern:
   - Ensure stylesheet import exists: `import '@xyflow/react/dist/style.css';`
   - Ensure `<ReactFlow />` has a parent with explicit width/height.
   - For controlled flows, wire `nodes`, `edges`, `onNodesChange`, `onEdgesChange`, `onConnect` with `applyNodeChanges`, `applyEdgeChanges`, `addEdge` (or `useNodesState`/`useEdgesState`).
   - Memoize handlers and stable objects passed to `<ReactFlow />`.

4. Use provider/hook context correctly:
   - Any use of `useReactFlow`, `useStore`, `useStoreApi`, `useNodes`, etc. must be inside a subtree of `<ReactFlowProvider />` or `<ReactFlow />`.
   - If multiple flows exist, use one provider per flow.

5. Validate against known pitfalls:
   - Run `scripts/audit-react-flow-best-practices.ps1` for quick static checks.
   - Compare warnings/errors with `references/best-practices-and-troubleshooting.md`.

## Tool Configuration

- MCP tools:
  - `mcp__xyflow-docs__fetch_xyflow_documentation`: initialize docs context.
  - `mcp__xyflow-docs__search_xyflow_code`: locate canonical implementation in source.
  - `mcp__xyflow-docs__fetch_generic_url_content`: pull specific docs pages or raw file contents.
- Local scripts:
  - `scripts/scaffold-react-flow-component.ps1`: generate a baseline controlled React Flow component.
  - `scripts/audit-react-flow-best-practices.ps1`: lint-like checks for common integration mistakes.

## Standard Operating Procedure

### New flow implementation

1. Scaffold:
   - `pwsh -File scripts/scaffold-react-flow-component.ps1 -OutputFile src/FlowCanvas.tsx -ComponentName FlowCanvas -UseProvider`
2. Integrate into app and ensure parent container sizing.
3. If custom nodes/edges are used:
   - Keep `nodeTypes`/`edgeTypes` stable (module scope or memoized).
4. Type with unions if multiple custom node/edge kinds exist.
5. Run audit script and fix all warnings relevant to current architecture.

### Existing flow refactor

1. Audit current code.
2. Replace unstable handler/object props with `useCallback`/`useMemo`.
3. Move expensive state derivations off frequently-changing `nodes`/`edges` snapshots.
4. If scale is large, collapse hidden subtrees and simplify heavy CSS effects.

### Debugging flow issues

1. Match observed error/warning with troubleshooting reference.
2. Prioritize:
   - Provider boundary errors.
   - Missing stylesheet.
   - Missing parent dimensions.
   - Invalid/mismatched node type keys.
   - Missing source/target or handle IDs.
   - Missing `updateNodeInternals` after dynamic handle changes.

## References

- Architecture and API map: `references/architecture-and-api.md`
- Best practices and troubleshooting: `references/best-practices-and-troubleshooting.md`
- MCP retrieval map and query presets: `references/mcp-react-flow-workflow.md`

