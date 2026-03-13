# Email Rules

Updated: 2026-03-09
Inbox: `steipete@gmail.com`
Mode: observe-first

## Goal

Keep inbox usable.
Run AI every few hours.
Bubble up real work.
Suppress inbox sludge.

## Current Shape

First `gog` pass:

- `in:inbox is:unread`: `710` threads
- unread `CATEGORY_UPDATES`: `346`
- unread `CATEGORY_PERSONAL`: `251`
- unread `CATEGORY_PROMOTIONS`: `82`
- unread `IMPORTANT`: `460`

Conclusion:

- Gmail `IMPORTANT` too noisy
- updates/promotions biggest cleanup target
- never miss security, human mail, or deadline mail

## Priority Order

1. Security / incident
2. Time-bound ops
3. Real human needs reply
4. GitHub direct action
5. Everything else

## Concrete Archive Rules

### Rule 1. Random signup auto-replies

Archive immediately when all are true:

- clear auto-reply signal
- short canned acknowledgement
- triggered by signup / newsletter / confirmation mail
- not a real human thread

Strong match signals:

- subject starts `自动回复:` or similar auto-reply prefix
- QQ auto-reply header or equivalent machine auto-reply signal
- sender looks machine/generated, especially numeric QQ sender
- body is tiny and generic, like `您好，来信已收到...`
- original subject is signup-style, like `Confirm your subscription` or `You're in! Welcome ...`

Do not auto-archive if:

- part of an active back-and-forth thread
- content references a real human conversation
- sender is on allowlist / known contact
- body is longer and specific to the conversation

Action:

- remove from inbox
- mark read
- include only as noise count in digest

Current known match:

- `1138428884@qq.com`

### Rule 2. Unknown low-context tasking mail

Archive candidate when all are true:

- unknown sender
- no prior relationship / no active thread context
- short imperative or vague request with no explanation
- asks Peter to do work without context

Strong match signals:

- one-line ask like `帮我整理一下桌面` / `please clean up my desktop` / similar unexplained tasking
- sender is consumer mail with no recognizable identity
- no subject or generic subject
- no signature, project context, or prior thread history

Do not auto-archive if:

- sender is known
- part of an existing conversation
- request references a real repo, bug, customer issue, invoice, or schedule
- message contains enough context to become actionable after a quick read

Action:

- report as archive candidate
- observe-first mode: do not mutate yet

## Classes

### Security / Incident / Abuse

Signals:

- subject/body contains `security`, `vulnerability`, `sandbox escape`, `CVE`, `GHSA`, `incident`, `breach`, `report`, `responsible disclosure`
- sender looks like researcher, platform security, bug bounty, abuse desk

Reaction:

- keep in inbox
- summarize immediately
- extract sender, impact, target repo/product, timeline
- suggest acknowledgement draft
- never auto-archive

### Time-Bound Ops

Signals:

- billing failure
- renewal
- verification required
- domain/DNS/infra alert
- calendar/travel/payment/tax deadline

Reaction:

- keep in inbox
- include exact deadline if present
- mark as `today`, `this week`, or `later`

### Real Human, Needs Reply

Signals:

- personal sender
- not bulk mail
- collaborator, customer, recruiter, partner, maintainer, friend, contractor

Reaction:

- keep in inbox if unanswered
- summarize in 1-2 lines
- assign urgency: `today` / `this week` / `later`
- suggest reply intent: `reply now`, `needs context`, `defer`

### GitHub / Engineering Workflow

Signals:

- `notifications@github.com`
- repo names in subject
- PR, issue, review, mention, CI, release

Reaction:

- actionable only if:
  - direct mention
  - review requested
  - authored PR/issue
  - CI/release breakage
  - security-related
  - repo in priority set: `openclaw/*`, `steipete/*`, current active work
- routine thread chatter: batch only

### Newsletter / Event / Broadcast

Signals:

- Substack
- Luma
- product update
- mailing list
- conference/event invite
- unsubscribe footer

Reaction:

- default non-actionable
- keep only if sender/topic on allowlist
- otherwise report as archive candidate
- observe-first mode: no mutation yet

### Auto-Reply / Confirmation / Machine Noise

Signals:

- auto-reply
- subscription confirmation
- receipt-only update
- noreply flow

Reaction:

- lowest priority
- archive candidate
- exclude from digest except count summary

## Digest Rules

Every run:

1. check unread inbox
2. check mail newer than last run
3. re-check older unread security/human mail still sitting in inbox
4. classify
5. output max 10 concrete items

Digest sections:

- `Urgent now`
- `Reply queue`
- `GitHub/action`
- `Noise seen`
- `Suggested cleanup`

Rules:

- routine newsletters: count only
- confirmations/auto-replies: count only
- if more than 10 actionable items: group remainder by class

## Safe Defaults

- never auto-reply
- never archive security mail
- never mutate unknown-class mail
- prefer false positive over false negative for security/human mail

## `gog` Queries

Core:

```bash
gog -a steipete@gmail.com gmail search 'in:inbox is:unread' --json
gog -a steipete@gmail.com gmail search 'in:inbox newer_than:3d' --json
gog -a steipete@gmail.com gmail search 'in:inbox (security OR vulnerability OR GHSA OR CVE OR incident)' --json
gog -a steipete@gmail.com gmail search 'in:inbox from:notifications@github.com' --json
```

Follow-up:

```bash
gog -a steipete@gmail.com gmail get <message-id> --json
gog -a steipete@gmail.com gmail thread get <thread-id> --json
```

## Automation Plan

Cadence:

- every 3 hours

Behavior:

- observe-only
- no archive
- no mark read
- no labels
- no replies

Output:

- concise digest only

## Later Phases

### Phase 1

- observe
- tune false positives

### Phase 2

- auto-archive machine noise
- auto-archive obvious newsletters not on allowlist
- keep audit summary

### Phase 3

- immediate trigger for security/VIP mail
- optional Gmail Pub/Sub watch
