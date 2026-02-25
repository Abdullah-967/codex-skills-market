---
name: vapi-mcp-expert
description: Build, refactor, troubleshoot, and harden Vapi voice-agent + MCP integrations. Use when implementing advanced Vapi assistant workflows, MCP tool wiring, stateful call orchestration, serverUrl event handling, enterprise environment separation, IVR navigation, live call control, async custom tools, or performance/reliability remediation.
---

# Vapi MCP Expert

## Overview

Use this skill for advanced Vapi implementations where call state, tool execution, and operational reliability matter more than onboarding setup.
Prioritize MCP-first retrieval, deterministic tool orchestration, and edge-case-safe call lifecycle handling.

## Workflow

1. Retrieve authoritative context in this order:
   - If connected Vapi MCP tools exist, enumerate tool surface first.
   - If connected tools are missing/unavailable, use official Vapi docs and Vapi MCP repo docs.
   - Ignore beginner setup pages unless required to resolve a blocker.
2. Confirm tool surface and protocol mode:
   - Vapi MCP tools include call control, assistant CRUD, phone number ops, and call metadata retrieval.
   - Prefer streamable HTTP transport and explicit `x-vapi-api-key`.
3. Design for state correctness:
   - Treat call/session snapshots as stale-prone; re-read state before dependent mutations.
   - Serialize dependent actions (`start` -> `control` -> `end`) and avoid parallel conflicting controls.
4. Implement edge-case-safe serverUrl flow:
   - Handle `status-update`, `speech-update`, `transcript`, `function-call`, `assistant-request`, `hang`.
   - For `assistant-request`, return valid assistant payload or terminate intentionally with safe messaging.
5. Apply reliability and performance guards:
   - Keep tool results concise to avoid context overflow.
   - Bound retries with backoff; do not blind-retry failed mutating actions.
   - Separate dev/staging/prod environments and API keys.

## Tool Configuration

- Expected MCP operations include:
  - Call lifecycle: start/end/list/get/control.
  - Assistant lifecycle: create/list/get/update/delete.
  - Phone numbers: create/list/get/update/delete/import.
  - Call metadata: transcripts, recordings, analytics/artifacts.
- Some deployments expose prefixed names (`vapi_start_call`, `vapi_list_assistants`) instead of generic names.
- Use `scripts/New-VapiMcpConfig.ps1` to generate deterministic MCP config snippets for client runtimes.

## Standard Operating Procedure

### New implementation

1. Generate baseline MCP config:
   - `pwsh -File scripts/New-VapiMcpConfig.ps1 -ApiKeyEnvVar VAPI_API_KEY -Transport streamable-http`
2. Validate desired tool exposure and header strategy.
3. Define state model for call progression and transfer paths.
4. Implement custom tool behavior:
   - Use synchronous tools for fast deterministic responses.
   - Use async tools only when external jobs are long-running and status can be reconciled.
5. Add serverUrl handlers for lifecycle + fallback behavior.

### Existing system audit/refactor

1. Run static audit:
   - `pwsh -File scripts/Audit-VapiMcpIntegration.ps1 -Path <repo-root>`
2. Fix high-risk findings first:
   - Missing timeouts/retries
   - Missing environment separation
   - Unbounded transcript/context payloads
   - Blind retries on mutating endpoints
3. Re-test with long-call and transfer-heavy scenarios.

### Production debugging

1. Check transport/auth first (endpoint, key header, protocol mismatch).
2. Confirm tool contract shape for `assistant-request` and custom tools.
3. Reproduce with minimal call scenario and controlled prompts.
4. Resolve in this order:
   - connection/auth
   - state/event sequencing
   - tool contract compatibility
   - performance/context pressure

## Embedded Best Practices

- Keep async behavior explicit: fire async only when business process truly requires deferred resolution.
- Prefer deterministic transfer routing and assistant override logic to avoid recursive handoffs.
- Keep `tools` and `toolIds` usage consistent per assistant/update path.
- Do not push full transcripts into every tool call payload.
- Bound call-control retries; re-read state between attempts.
- Use environment-level isolation for numbers, assistants, and credentials.

## References

- Retrieval and MCP SOP: `references/mcp-retrieval-workflow.md`
- Architecture and tool contracts: `references/architecture-and-tooling.md`
- Advanced workflows and edge cases: `references/advanced-workflows-and-edge-cases.md`
- Performance and anti-patterns: `references/performance-and-anti-patterns.md`

## Scripts

- `scripts/New-VapiMcpConfig.ps1` - Generate MCP config snippets for Codex/Claude/Cursor-style clients.
- `scripts/Audit-VapiMcpIntegration.ps1` - Run static checks for risky Vapi MCP usage patterns.
