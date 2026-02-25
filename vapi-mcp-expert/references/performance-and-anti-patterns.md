# Performance And Anti-Patterns

## Performance Priorities

- Keep tool outputs concise and structured.
- Avoid repeating full transcript/context in each tool call.
- Batch related state reads when possible, then mutate with fresh pre-checks.
- Prefer server-side deterministic transformations over model-side verbose reasoning.

## Reliability Optimizations

- Add per-operation timeout budgets.
- Use bounded retries with jitter and operation-specific retry policies.
- Make mutating operations idempotent where possible.
- Re-validate resources after mutation to detect eventual-consistency delays.

## Scaling Guidance

- Separate environments (dev/staging/prod) with isolated assistants, numbers, and keys.
- Keep environment-specific routing/config outside prompt text.
- Maintain explicit allowlists for external tool usage.

## Known Anti-Patterns

- Blind retry loops on `start/end/control` calls.
- Hardcoded API keys in config files or scripts.
- Overloading custom tool responses with unbounded JSON payloads.
- Recursive assistant transfers without loop guard.
- Mixing `tools` and `toolIds` inconsistently during assistant updates.
- Running long synchronous external calls inside conversation-critical turns.
- Treating webhook event order as guaranteed.

## What To Do Instead

- Retry only idempotent-safe operations with capped attempts.
- Resolve secrets from environment variables.
- Return compact summaries and fetch detail lazily.
- Track transfer depth and seen-assistant IDs.
- Normalize assistant update pathways to one tool declaration strategy.
- Use async tool mode plus explicit status reconciliation for long jobs.
- Design handlers as out-of-order tolerant.
