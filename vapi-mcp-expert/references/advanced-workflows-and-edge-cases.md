# Advanced Workflows And Edge Cases

## Stateful Call Orchestration

Use this sequence for non-trivial call workflows:

1. Resolve target assistant and phone-number context.
2. Start call.
3. Wait for state confirmation event.
4. Apply live call controls.
5. Persist artifacts and close lifecycle cleanly.

Do not issue multiple conflicting live-control operations in parallel.

## Dynamic Assistant Handoffs

- Use `assistant-request` to branch to specialized assistants.
- Add loop prevention in handoff logic:
  - Track visited assistant IDs in request metadata.
  - Cap total handoffs per call.
- Always provide fallback assistant when branch resolution fails.

## IVR Navigation

- Treat DTMF and IVR prompt timing as nondeterministic.
- Add bounded retries and explicit timeout windows.
- Keep a fallback route to human or catch-all assistant for IVR dead ends.

## Transfer Destinations

- Validate transfer destination availability before attempting transfer.
- Keep destination resolution deterministic (priority order + explicit tie-breakers).
- On transfer failure, keep call continuity path defined (retry once, then fallback).

## Async Custom Tools

- Use async only for external operations that exceed conversational latency budgets.
- Return lightweight acknowledgement immediately.
- Reconcile completion status through explicit callback/status polling path.
- Never assume async completion implies continued call relevance; re-check current call state.

## Failure Handling

- `No call found`/state drift:
  - Re-fetch call state and abort stale command chain.
- `assistant-request` schema mismatch:
  - Return safe default assistant and log validation error.
- upstream timeout:
  - Use single retry with jitter; escalate to fallback path if second attempt fails.
