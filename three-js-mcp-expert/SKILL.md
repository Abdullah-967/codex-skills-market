---
name: three-js-mcp-expert
description: Build, refactor, troubleshoot, and harden Three.js MCP integrations based on the three-js-mcp server architecture. Use when implementing advanced scene orchestration, WebSocket-bridged MCP tool execution, state synchronization, edge-case handling, performance tuning, and anti-pattern remediation for Three.js agent workflows.
---

# Three.js MCP Expert

## Overview

Use this skill when work involves Three.js MCP server operations, 3D scene orchestration through MCP tools, WebSocket bridge management, or agent-driven scene manipulation. It provides a repeatable MCP-driven workflow, audit scripts, and reliability-first practices for production environments.

## Trigger Guidance

Use this skill when requests include:

- "Add/move/remove 3D objects via MCP"
- "Set up Three.js MCP server"
- "Debug WebSocket connection to Three.js scene"
- "Orchestrate scene state through agent tools"
- "Optimize Three.js MCP performance"
- "Handle disconnected client scenarios"

## Tool Configuration (MCP)

Three.js MCP exposes tools via stdio transport with a separate WebSocket bridge for client communication.

**Available Tools:**
- `addObject` — Add a 3D object to the scene
- `moveObject` — Move an existing object by ID
- `removeObject` — Remove an object from the scene
- `startRotation` — Start rotating an object
- `stopRotation` — Stop object rotation
- `getSceneState` — Get current scene snapshot

**Prompt:**
- `asset-creation-strategy` — Guidance for scene-aware object creation

## Workflow

1. Retrieve authoritative MCP context first:
- Prefer connected MCP tools when available.
- If MCP handshake fails, inspect local MCP config and retrieve server source directly.
- Use `references/mcp-retrieval-and-architecture.md` to follow the exact retrieval sequence.

2. Confirm server/tool surface before coding:
- Tools expected from upstream server:
  - `addObject`
  - `moveObject`
  - `removeObject`
  - `startRotation`
  - `stopRotation`
  - `getSceneState`
- Prompt expected: `asset-creation-strategy`

3. Apply advanced state-management operating model:
- Treat `getSceneState` as a snapshot read, not authoritative lock state.
- Resolve target object IDs from latest snapshot immediately before mutating.
- Serialize dependent mutations (`addObject` -> `startRotation`, `moveObject` chains) to avoid stale-ID or out-of-order effects.
- For repeated edits, use an app-side command queue and idempotency keys.

4. Enforce edge-case-safe command flow:
- On `No client connection available`, do not retry blindly; re-establish WS bridge and re-sync state.
- On `No scene state available`, request/trigger a fresh client-side state push before planning changes.
- Verify object existence before `moveObject`/`removeObject`/rotation controls.
- Always pair `startRotation` with explicit stop conditions.

5. Optimize runtime and avoid anti-patterns:
- Avoid chatty per-frame MCP traffic; batch logical changes and delegate animation loops to client runtime.
- Avoid hard coupling to a single static WS port in production environments.
- Replace untyped `any` state with strict scene contracts.
- Add command acknowledgements and replay-safe retries for lossy WS boundaries.

## Tool Configuration

- Upstream `three-js-mcp` package currently lacks a robust direct `npx` execution path in many environments.
- Prefer local build execution via Node entrypoint:
  - `command = "node"`
  - `args = ["<absolute-path-to-three-js-mcp>/build/main.js"]`
- If using Codex MCP config, keep a deterministic absolute path and avoid transient temp directories.

Use `scripts/generate-three-js-mcp-config.ps1` to generate working config snippets.

## Standard Operating Procedure

### Advanced implementation/refactor

1. Run integration audit:
- `pwsh -File scripts/audit-three-js-mcp-server.ps1 -RepoPath <path-to-three-js-mcp-repo>`
2. Apply hardening changes indicated by the audit.
3. Re-validate tools and prompt registration.
4. Execute mutation scenarios:
- add + move + remove object lifecycle
- start/stop rotation lifecycle
- stale-state and disconnected-client scenarios

### Production debugging

1. Verify MCP startup command points to compiled `build/main.js`.
2. Verify WS bridge connectivity and scene push frequency.
3. Reproduce with minimal command sequence against current scene snapshot.
4. Fix in priority order:
- connection lifecycle
- state consistency
- command idempotency
- throughput/performance

## References

- `references/mcp-retrieval-and-architecture.md` — Retrieval SOP and architecture map.
- `references/mcp-workflow.md` — MCP tool invocation order and sequences.
- `references/tool-catalog.md` — Complete tool reference with parameters.
- `references/advanced-practices-and-anti-patterns.md` — Advanced patterns and anti-patterns.

## Scripts

- `scripts/audit-three-js-mcp-server.ps1` — Static audit for reliability and anti-pattern detection.
- `scripts/generate-three-js-mcp-config.ps1` — Generate MCP config snippets for local server execution.
