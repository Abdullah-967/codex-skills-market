# Vapi MCP Retrieval Workflow

## Goal

Collect advanced, implementation-grade context for Vapi MCP and voice-agent operations while minimizing low-value onboarding material.

## Retrieval Order

1. Inspect connected MCP tools first.
2. If connected tools are unavailable, retrieve official Vapi sources:
   - Vapi MCP server docs.
   - Vapi docs pages for tools, serverUrl events, call control, enterprise environments, IVR.
   - Official Vapi MCP repo documentation.
3. Skip "hello world"/quickstart pages unless needed to resolve a blocker.

## Query Presets

- "Vapi MCP tools list start/end call assistant phone numbers"
- "Vapi serverUrl assistant-request hang function-call status-update speech-update"
- "Vapi tools mcp streamable http headers x-vapi-api-key"
- "Vapi dynamic transfer destinations workflows"
- "Vapi enterprise environments best practices"

## Validation Checklist

- Confirm current tool names and payload shape in the target deployment.
- Confirm transport mode (`streamable-http` preferred).
- Confirm header requirements (`x-vapi-api-key`).
- Confirm async tool behavior (eventual response path, timeout, reconciliation).

## Retrieval Anti-Patterns

- Do not assume generic MCP tool names match deployed names; prefixed tool names are common.
- Do not rely on stale snippets without checking current docs and version references.
- Do not consume full beginner docs when solving production incidents.
