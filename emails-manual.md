# Email Manual

## Principle

Use Gmail-native behavior when the action should live in Gmail.

- `gog` is primarily for inspecting and configuring Gmail.
- Prefer Gmail filters, labels, archive, mark-read, forwarding, templates.
- Do not default to local daemons / `launchd` / cron when Gmail can do it itself.

## Security Mail

For `security@openclaw.ai`:

- Preferred: Gmail filter + Gmail template auto-reply.
- Query:

```text
to:(security@openclaw.ai)
```

- Reply should point people to GitHub private vulnerability reporting:

```text
https://github.com/openclaw/openclaw/security/advisories/new
```

## `gog` Role

Use `gog` for:

- mailbox triage
- search / clustering
- archive / label / mark-read
- sender and category cleanup
- Gmail settings that exist in the Gmail API

Do not assume `gog` can configure every Gmail UI feature.

Important limitation:

- Gmail API supports filters, labels, forwarding, vacation responder
- Gmail API does not expose filter action `Send template`
- so Gmail-native per-filter auto-reply cannot currently be fully configured by `gog`

## Fallback

If Gmail cannot express the behavior via native settings/API:

- acceptable fallback: local `gog` automation
- but treat that as second-best, not default

## Decision Rule

Ask first:

1. Should this behavior run inside Gmail?
2. Does Gmail already support it natively?
3. Does the Gmail API expose it?

If:

- Gmail native: configure Gmail
- Gmail native but API missing: document manual UI steps
- not possible in Gmail: then consider local automation
