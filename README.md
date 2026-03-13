# Triage

Source of truth for Peter's moderation and email-triage policy.

Primary rules:

- [`TWITTER_MENTIONS.md`](./TWITTER_MENTIONS.md)
- [`TWITTER_REPLIES.md`](./TWITTER_REPLIES.md)
- [`EMAILRULES.md`](./EMAILRULES.md)

Also includes restore docs/templates for the current OpenClaw cron setup:

- shared clawblocker workspace templates: [`openclaw/clawblocker`](./openclaw/clawblocker)
- daily block digest templates: [`openclaw/blockdigest`](./openclaw/blockdigest)

## Current Setup

There are 4 related automations:

1. X mention moderation
2. X reply-opportunity triage
3. Gmail triage
4. Daily X block digest email

The first 3 share one OpenClaw agent/workspace:

- agent id: `clawblocker`
- one workspace
- one repo checkout inside that workspace
- three runbooks
- separate state/audit files per cron
- twitter moderation also doubles as the `birdclaw` mention-cache warmer every 10 minutes; no second cache cron needed

The block digest stays separate because it is a simple daily mailer over the moderation audit log.

## Shared Clawblocker Layout

Target layout:

```text
~/.openclaw/
  workspace-clawblocker/
    AGENTS.md
    triage/                       # checkout of this repo
    jobs/
      twitter-moderation.md
      twitter-replies.md
      email-triage.md
    skills/
      bird-twitter-moderation/
        SKILL.md
    state/
      twitter.json
      twitter-replies.json
      email.json
    audit/
      twitter/
      twitter-replies/
      email/
  agents/
    clawblocker/
      agent/
        models.json
      sessions/
        sessions.json
```

Source-of-truth rule checkout:

- only one checkout: `~/.openclaw/workspace-clawblocker/triage`
- runtime should read rules from that checkout
- runtime should not read `~/triage` directly

## Cron Jobs

### 1. Twitter Mention Moderation

- schedule: every 10 minutes
- agent: `clawblocker`
- model: `openai/gpt-5.4`
- thinking: `high`
- timeout: `360s`
- delivery: `none`
- runbook: `jobs/twitter-moderation.md`
- also warms `birdclaw` mention cache before triage and records verified block/mute actions back into local SQLite

Message:

```text
Run one clawblocker pass now using ~/.openclaw/workspace-clawblocker/jobs/twitter-moderation.md. Follow it exactly.
```

### 2. Twitter Reply Triage

- schedule: `17 */6 * * *`
- timezone: `Europe/London`
- agent: `clawblocker`
- model: `openai/gpt-5.4`
- thinking: `low`
- timeout: `300s`
- delivery: `none`
- runbook: `jobs/twitter-replies.md`
- warms `birdclaw` mention cache, runs a deeper `xurl` backfill, then surfaces only high-signal unreplied mentions worth Peter's time

Message:

```text
Run one clawblocker pass now using ~/.openclaw/workspace-clawblocker/jobs/twitter-replies.md. Follow it exactly.
```

### 3. Email Triage

- schedule: `5 */3 * * *`
- timezone: `Europe/London`
- agent: `clawblocker`
- model: `openai/gpt-5.4`
- thinking: `low`
- delivery: `none`
- runbook: `jobs/email-triage.md`

Message:

```text
Run one clawblocker pass now using ~/.openclaw/workspace-clawblocker/jobs/email-triage.md. Follow it exactly.
```

### 4. Daily X Block Digest

- schedule: `0 9 * * *`
- timezone: `Europe/London`
- agent: `blockdigest`
- model: `openai/gpt-5.4`
- thinking: `low`
- timeout: `180s`
- delivery: `none`
- source audit: `~/.openclaw/workspace-clawblocker/audit/twitter/*.md`

## Required Local Tools

### Twitter moderation

- `birdclaw`
- `bird`
- optional fallback: `bird-gui`
- active auth/cookies for X

Expected binary path in templates:

```bash
$HOME/Projects/birdclaw
$HOME/Projects/bird/bird
```

Expected runtime for `birdclaw` CLI today:

```bash
fnm exec --using 25.8.1 pnpm cli ...
```

### Email triage / digest

- `gog`
- authenticated Gmail account

Expected default account:

```text
steipete@gmail.com
```

## Restore On A Fresh Machine

1. Clone this repo somewhere convenient, for example:

```bash
git clone https://github.com/steipete/triage.git ~/triage
```

2. Create the shared OpenClaw agent:

```bash
node ~/clawdbot/dist/index.js agents add clawblocker --workspace ~/.openclaw/workspace-clawblocker --non-interactive
```

3. Put this repo inside the workspace as the only runtime checkout:

```bash
git clone https://github.com/steipete/triage.git ~/.openclaw/workspace-clawblocker/triage
```

4. Copy template files from this repo into the live workspace:

- [`openclaw/clawblocker/AGENTS.md`](./openclaw/clawblocker/AGENTS.md)
- [`openclaw/clawblocker/jobs/twitter-moderation.md`](./openclaw/clawblocker/jobs/twitter-moderation.md)
- [`openclaw/clawblocker/jobs/twitter-replies.md`](./openclaw/clawblocker/jobs/twitter-replies.md)
- [`openclaw/clawblocker/jobs/email-triage.md`](./openclaw/clawblocker/jobs/email-triage.md)
- [`openclaw/clawblocker/skills/bird-twitter-moderation/SKILL.md`](./openclaw/clawblocker/skills/bird-twitter-moderation/SKILL.md)
- [`openclaw/clawblocker/state/twitter.json.example`](./openclaw/clawblocker/state/twitter.json.example)
- [`openclaw/clawblocker/state/twitter-replies.json.example`](./openclaw/clawblocker/state/twitter-replies.json.example)
- [`openclaw/clawblocker/state/email.json.example`](./openclaw/clawblocker/state/email.json.example)

5. Create the block digest workspace/agent from the templates in [`openclaw/blockdigest`](./openclaw/blockdigest).

6. Add the cron jobs with the settings above.

7. Verify:

- twitter run reads `jobs/twitter-moderation.md`
- reply triage run reads `jobs/twitter-replies.md`
- email run reads `jobs/email-triage.md`
- both use `agentId: clawblocker`
- only one triage checkout exists under cron workspaces
- block digest reads `~/.openclaw/workspace-clawblocker/audit/twitter`

## Notes

- Rule edits belong in this repo first.
- After changing rules, pull the workspace checkout.
- State and audit logs are runtime data; do not store them in this repo.
- Email triage may auto-archive only exact Rule 1 / Rule 2 junk. Everything else remains observe-first.
