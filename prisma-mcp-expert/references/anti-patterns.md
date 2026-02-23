# Anti-Patterns

## Destructive Operations Without Guardrails

Anti-pattern:
- Running `migrate-reset` or `DeleteDatabaseTool` without explicit confirmation and environment check.

Do instead:
- Require explicit confirmation and backup/restore plan.

## SQL Before Schema Discovery

Anti-pattern:
- Issuing complex `ExecuteSqlQueryTool` changes without `IntrospectSchemaTool`.

Do instead:
- Introspect first and verify assumptions.

## Secrets in Logs

Anti-pattern:
- Printing full connection strings in chat logs, CI output, or traces.

Do instead:
- Redact sensitive segments and only expose minimal identifiers.

## Blind Retries After Partial Failure

Anti-pattern:
- Replaying write actions after network/tool errors without checking final state.

Do instead:
- Re-list state, then apply idempotent follow-up.

## Unpinned Runtime for Packaged Extensions

Anti-pattern:
- Floating Prisma/runtime dependencies in production DXT flows.

Do instead:
- Pin versions and validate wrapper behavior (`chmod` + spawn) in release pipelines.
