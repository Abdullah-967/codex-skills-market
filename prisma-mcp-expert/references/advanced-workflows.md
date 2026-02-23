# Advanced Workflows

## 1) Production-Safe Remote SQL Change

1. `ListDatabasesTool` to confirm target.
2. `CreateBackupTool` before risky mutations.
3. `IntrospectSchemaTool` to verify current shape.
4. `ExecuteSqlQueryTool` with scoped statement set.
5. Re-run `IntrospectSchemaTool` for post-change validation.
6. If regression detected, use `CreateRecoveryTool` path.

## 2) Connection String Rotation

1. `ListConnectionStringsTool` to inspect active credentials.
2. `CreateConnectionStringTool` for new credential.
3. Validate dependent clients.
4. `DeleteConnectionStringTool` for stale secret.

Do not delete old string before consumer cutover.

## 3) Local Migration Gate For Teams

1. `migrate-status` to detect drift.
2. `migrate-dev --name <meaningful_name>`.
3. Review generated SQL and schema impact.
4. Run integration checks.
5. Never run `migrate-reset` unless explicit wipe is intended.

## 4) Cross-Mode Pattern (Inference)

Use local mode for iterative schema design and migration authoring. Use remote mode for managed operational tasks (backup/recovery/database lifecycle).

Why this pattern: It aligns with the exposed tool surfaces and reduces accidental production impact.

## 5) High-Risk Operation Checklist

- Confirm environment (`dev`, `staging`, `prod`).
- Confirm database identifier.
- Confirm rollback mechanism exists (backup/recovery).
- Confirm SQL blast radius (tables/rows/locks).
- Confirm observability path for post-change verification.
