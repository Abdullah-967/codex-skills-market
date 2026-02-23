# MCP React Flow Workflow

Use this sequence whenever task quality depends on current official behavior.

## Required sequence

1. Initialize repository context:
   - `mcp__xyflow-docs__fetch_xyflow_documentation`

2. Retrieve implementation details:
   - `mcp__xyflow-docs__search_xyflow_code` with targeted queries:
     - `repo:xyflow/xyflow path:packages/react/src/index.ts`
     - `repo:xyflow/xyflow path:packages/react/src/hooks useReactFlow`
     - `repo:xyflow/xyflow path:packages/react/src/utils/changes.ts`
     - `repo:xyflow/xyflow path:packages/system/src/utils/edges/general.ts`

3. Pull exact docs pages:
   - `mcp__xyflow-docs__fetch_generic_url_content`:
     - `https://reactflow.dev/learn`
     - `https://reactflow.dev/api-reference`
     - `https://reactflow.dev/api-reference/react-flow`
     - `https://reactflow.dev/api-reference/react-flow-provider`
     - `https://reactflow.dev/learn/advanced-use/hooks-providers`
     - `https://reactflow.dev/learn/advanced-use/performance`
     - `https://reactflow.dev/learn/advanced-use/state-management`
     - `https://reactflow.dev/learn/advanced-use/typescript`
     - `https://reactflow.dev/learn/troubleshooting/common-errors`

## Query presets

- Provider/store architecture:
  - `repo:xyflow/xyflow path:packages/react/src/components/ReactFlowProvider`
  - `repo:xyflow/xyflow path:packages/react/src/hooks/useStore.ts`

- Runtime instance API:
  - `repo:xyflow/xyflow path:packages/react/src/hooks/useReactFlow.ts`

- Edge behavior:
  - `repo:xyflow/xyflow path:packages/system/src/utils/edges/general.ts`

## Decision rules

- Prefer official docs for behavioral guidance and migration notes.
- Prefer source files for edge cases, exact function behavior, and exported API confirmation.
- If docs search is sparse, rely on `fetch_generic_url_content` for direct page extraction.

