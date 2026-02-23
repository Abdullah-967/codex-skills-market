# Performance and Reliability

## Performance Patterns

- Prefer one schema introspection pass per change-set, then cache the result for planning.
- Keep SQL payloads narrow (`SELECT` fields intentionally, avoid broad scans where possible).
- Batch related statements into a controlled sequence instead of many tiny tool invocations.
- Prefer stable transport configuration and reuse rather than repeated reconnect churn.

## Reliability Patterns

- Always preflight auth for remote paths.
- Use explicit preconditions before destructive operations.
- Re-list resources after mutation to verify eventual consistency.
- Retry reads with bounded backoff; avoid retrying destructive writes blindly.

## Edge Cases

- Transport/auth mismatch: endpoint reachable but unauthorized.
- Tool availability drift: clients should list tools dynamically.
- Packaging/runtime mismatch in desktop contexts (execute-bit, Node runtime, pinned Prisma version).

## Recovery Tactics

- For failed SQL mutation sequence: stop, introspect, and decide between forward-fix or backup recovery.
- For failed database lifecycle operation: re-query resource lists before reissuing create/delete actions.
- For local migration confusion: run `migrate-status` first to avoid compounding drift.
