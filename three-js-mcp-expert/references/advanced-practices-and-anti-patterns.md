# Advanced Practices and Anti-Patterns

## Advanced state-management techniques

1. Snapshot-then-act discipline
- Fetch `getSceneState` right before each mutation batch.
- Resolve IDs from that snapshot only.
- Abort or refresh on mismatch.

2. Command serialization for dependent mutations
- Serialize dependent operations targeting the same object.
- Example: `addObject` must complete client-side registration before `startRotation`.

3. Idempotent orchestration layer
- Attach client-side request IDs to commands.
- Ignore duplicate commands after reconnect or timeout retry.

4. Reconciliation loop
- After mutation batches, compare expected vs. observed scene snapshot.
- Re-issue only missing deltas; avoid full replay.

5. Connection-aware execution
- Gate all write commands on active WS session and state freshness.
- Rebuild command queue only after bridge restoration.

## Edge-case handling

- Disconnected bridge:
  - Symptom: `No client connection available`
  - Action: re-establish WS session, refresh scene, then replay unresolved queue.

- Empty or stale scene:
  - Symptom: `No scene state available` or missing IDs
  - Action: trigger client state push, then re-plan mutations.

- Unknown object ID:
  - Action: never guess IDs. Resolve from latest scene snapshot.

- Rotation lifecycle leaks:
  - Action: enforce explicit stop criteria and cleanup on object removal.

## Performance optimizations

- Avoid per-frame MCP tool calls for animation.
- Push intent-level commands (`startRotation`) and let client runtime animate locally.
- Coalesce spatial updates into batches where possible.
- Reduce repeated `getSceneState` calls by using change-triggered polling strategy.

## Known anti-patterns (verified + inferred)

Verified from upstream code:

1. Single global connection/state without multi-client strategy.
2. Hardcoded WS port (`8082`) without environment override.
3. Windows-incompatible build script (`chmod` usage).
4. Minimal response semantics (`sent`) without ack/result metadata.

Inferred reliability risks:

1. No heartbeat/ping handling for stale WS sessions.
2. No backpressure or queue bounds under high command throughput.
3. No schema-level semantic validation (only structural input schema).
4. No transactional grouping for logically coupled commands.

## Recommended hardening checklist

- Add env-configurable WS port.
- Add command ACK protocol and optional error payload from client.
- Add queue with retry/backoff and max in-flight limits.
- Add explicit scene schema typing (remove `any`).
- Add heartbeat and disconnect detection.
- Add optional list/resources endpoint when serving non-tool metadata.
