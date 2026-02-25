# Vapi Architecture And Tooling

## Core Architecture

- Vapi voice agents orchestrate LLM behavior, telephony/runtime state, and tool execution.
- MCP is used to expose operational actions (calls, assistants, numbers, metadata) to agent tooling.
- Server-side logic can be injected through `serverUrl` webhooks/events.

## MCP Surface (Advanced-Focused)

- Call lifecycle: start, end, get/list, and control in-progress calls.
- Assistant lifecycle: create/get/list/update/delete.
- Phone number lifecycle: create/import/get/list/update/delete.
- Call artifacts: transcript, recording, and call detail retrieval.

## Protocol And Auth

- Prefer `streamable-http` transport for predictable session behavior.
- Set `x-vapi-api-key` on outbound MCP requests.
- For CLI MCP servers, enforce process-level environment variable injection rather than hardcoding keys.

## Tool Contract Notes

- Deployed tool names can be namespaced or prefixed (for example `vapi_start_call`).
- Keep request/response schemas version-aware and explicit.
- Treat tool response length as part of reliability design; large payloads degrade model context.

## serverUrl Event Model

Handle at minimum:

- `status-update`
- `speech-update`
- `transcript`
- `function-call`
- `assistant-request`
- `hang`

Important behavior:

- `assistant-request` is a control-point for dynamic assistant override.
- Malformed or oversized response payloads from `assistant-request` can break flow continuity.

## Custom Tool Execution Modes

- Synchronous mode:
  - Best for short deterministic tasks.
  - Keep latency low and return compact outputs.
- Asynchronous mode:
  - Best for long-running jobs and external workflows.
  - Require explicit status/result reconciliation path.

## Architecture Guardrails

- Re-read call/assistant state before mutating actions that depend on prior state.
- Serialize dependent commands to prevent out-of-order updates.
- Keep transfer/assistant override logic idempotent.
