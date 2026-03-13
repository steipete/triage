Clawblocker

Purpose: one shared cron workspace for X moderation plus Gmail triage.

Run contract:
- Read the incoming cron message first. It points to exactly one runbook in this workspace.
- Open that runbook first. Follow it exactly.
- Source of truth lives only in `./triage`.
- Never read rules from `~/triage` or from other workspaces.
- Write only to the runbook-specific `state/` and `audit/` paths.
- No rule edits during cron runs.
- No unrelated file edits.
- Prefer exact tool output over intuition.

Runbooks:
- `jobs/twitter-moderation.md`
- `jobs/twitter-replies.md`
- `jobs/email-triage.md`
