# Twitter Reply Triage

Source: `birdclaw` cache for breadth, `bird thread` for final reality check
Date: 2026-03-13
Goal: surface the tiny set of X mentions Peter should actually reply to

## Principle

- This lane is not moderation. Bad actors belong in [`TWITTER_MENTIONS.md`](./TWITTER_MENTIONS.md).
- This lane is not "reply to everyone."
- Optimize for leverage, clarity, and relationship value.
- Peter should reply when a short answer meaningfully helps.
- Generic social obligation is not enough.

## What counts as a good reply target

Surface when the mention creates one of these:

- Bug leverage. Concrete failure, regression, exact error, version/update clue, or a report that likely affects more than one user.
- Technical leverage. Specific implementation question, architecture question, workflow tradeoff, or process question where Peter is the right person to answer.
- Correction leverage. Real mistake, broken assumption, missing caveat, or public confusion Peter can clear up quickly.
- Relationship leverage. Genuine ask from a known builder, collaborator, organizer, speaker, customer, or high-context peer where a short response compounds goodwill.
- Logistics leverage. Volunteering, event coordination, access, scheduling, or "what do I do next?" in a context Peter started.
- Product leverage. Useful user feedback with specifics, especially when it can improve docs, onboarding, defaults, or error handling.
- Amplification leverage. Large-account mention with real substance, not just praise.

## Strong candidates

Usually surface:

- Specific bug report with exact symptom or error text.
- Specific question in Peter's active thread where Peter is clearly the answerer.
- Follow-up question after Peter already engaged, if the follow-up is still open and concrete.
- Real user asking how to do the next thing after Peter invited them in.
- Concrete critique with enough detail to respond usefully.
- Thoughtful proposal with specifics, not just vibe.
- Correction of a public misconception.

## Medium candidates

Surface only if the thread feels worth Peter's attention:

- Mild product critique with some specificity but no repro yet.
- Known/high-signal person with a loose but relevant invitation or suggestion.
- High-follower mention with a concrete question that others may also have.
- Useful workflow idea that is still rough, but points at a real maintainer pain.

## Weak candidates

Usually skip:

- Generic praise.
- Social banter.
- Jokes with no new information.
- "Same", "wow", "nice", emoji-only, applause-only.
- Broad "review my repo / startup / project" asks from strangers.
- Requests that obviously require too much unpaid work relative to the signal.
- Broadcast-style tags where Peter is one of many tagged people and not the real target.
- Commentary that is directionally true but too vague to answer usefully.

## Hard skips

Do not surface:

- Anything that should be blocked or muted under [`TWITTER_MENTIONS.md`](./TWITTER_MENTIONS.md).
- Already blocked or muted accounts.
- Obvious promo, shill, AI-slop, abuse, low-value link drops, or crypto noise.
- Threads Peter already answered, unless the latest mention adds a new concrete open question.
- Threads where someone else already answered adequately and Peter is not needed.
- Off-topic praise from high-follower accounts with no actual ask.
- Requests better handled privately unless the public reply would still add clear value.

## Decision order

Judge in this order:

1. Is it clean enough for the reply lane at all?
2. Is there a real question, bug, correction, or useful next step?
3. Is Peter the right person to answer?
4. Is the thread still unresolved?
5. Would a short reply create leverage?
6. Only then use follower count as a tiebreaker.

## Follower count rule

Follower count matters, but late.

- High followers plus fluff: still low priority.
- Low followers plus a sharp bug report: high priority.
- High followers help when two candidates are otherwise equally useful.
- Large-account praise without an ask is not enough.

## Thread check rule

Before surfacing, load the thread and confirm all of this:

- Peter has not already replied in a way that resolves it.
- The latest mention still contains an open question, bug, or useful next step.
- The mention is actually directed at Peter, not just adjacent to him.
- The response belongs from Peter, not from another tagged person.

If Peter already answered the substance: mark resolved, do not resurface.

## Dig-deeper triggers

Load more context when:

- the mention is critique but not yet specific enough
- the question may already have been answered earlier in the thread
- Peter is tagged with multiple people and ownership is ambiguous
- the sender is high-signal and the reply could matter, but the ask is still fuzzy
- the mention may be useful but also smells promotional

## Useful patterns

Good shapes:

- "after the last update I get X error"
- "is the fix on the OpenClaw side or repo side?"
- "what server / setup / process did you use?"
- "you invited volunteers; what should I do next?"
- "this seems wrong because of X"
- "what if maintainers handled this workflow instead by Y"

Bad shapes:

- "great work"
- "amazing"
- "worth following"
- "can you review my repo"
- "check my profile"
- "look at my platform"
- generic reposts, hype, and link-sharing with no ask

## Critique rule

Do not surface vague negativity by itself.

Surface critique only when it has one of:

- a concrete symptom
- a reproducible problem
- a sharp product/process question
- a useful counterproposal

Skip critique that is just mood, pile-on, or generic dissatisfaction.

## Relationship rule

Reply faster when:

- Peter already started the interaction
- the person is volunteering, helping, organizing, speaking, or collaborating
- the person is a credible operator with context
- the reply would close a loop Peter opened

Do not over-index on status alone. High-signal stranger with fluff is still fluff.

## Scope-control rule

Avoid surfacing asks that create large unpaid obligations unless there is outsized value.

Usually skip:

- broad repo reviews
- open-ended consulting asks
- "look at my product" with no specific question
- generic requests for free debugging with no repro

## Output rule

This cron should produce a shortlist, not a social inbox.

- target: `0-5` candidates per run
- `0` is normal
- err on the side of fewer, better candidates
- each candidate should say why Peter should reply now

## Operational flow

Use `birdclaw` to gather and backfill mentions.
Use `bird thread` as the final truth source before surfacing.

Shortlist bias:

- recent concrete bugs/questions first
- then unresolved relationship/logistics asks
- then high-signal substantive mentions
- then nothing
