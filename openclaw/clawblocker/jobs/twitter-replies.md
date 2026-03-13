Twitter Reply Triage

Purpose: surface the small set of useful X mentions Peter should reply to.

Run contract:
- Read `./triage/TWITTER_REPLIES.md` first every run.
- Read `./triage/TWITTER_MENTIONS.md` too. Anything block/mute-worthy is not a reply candidate.
- Read `./state/twitter-replies.json` before triage. It stores `reportedTweetIds` and `resolvedTweetIds`.
- Warm `birdclaw` first so mention data stays cached locally.
- Do one deeper `xurl` backfill pass too. This improves cache coverage and profile stats.
- Build the shortlist from `birdclaw`, not from raw bird output.
- Work only a small top slice. Do not manually review dozens of mentions.
- Before surfacing any candidate, verify with `bird thread` that Peter has not already replied.
- Skip blocked/muted accounts.
- Use this decision order: clean enough for reply lane, real question/bug/correction, Peter is right responder, still unresolved, short reply creates leverage, follower count only as tiebreaker.
- Skip low-signal fluff, generic praise, broad unpaid asks from strangers, spam, promo, and obvious moderation cases.
- Prefer concrete bugs, technical questions, useful corrections, unresolved follow-up questions after Peter already engaged, time-sensitive logistics, and high-signal relationship touches.
- Large follower count is a tiebreaker, not a substitute for substance.
- Surface at most 5 candidates per run.
- Append every shortlisted item to `./audit/twitter-replies/YYYY-MM-DD.md` with timestamp, action, handle, URL, followers, score, and reasons.
- Use `reply-candidate`, `skip-already-replied`, `skip-low-signal`, `skip-moderation`, or `skip-already-reported`.
- Add surfaced ids to `reportedTweetIds`.
- Add definite no-reply / already-handled ids to `resolvedTweetIds`.
- Keep both arrays capped to 4000 newest ids.
- End with one terse summary line.

Commands:
- warm cache: `cd /Users/steipete/Projects/birdclaw && fnm exec --using 25.8.1 pnpm -s cli mentions export --mode bird --refresh --limit 80 > /tmp/clawblocker-replies-bird.json && jq '{result_count: .meta.result_count, newest_id: .meta.newest_id, oldest_id: .meta.oldest_id}' /tmp/clawblocker-replies-bird.json`
- deep backfill: `cd /Users/steipete/Projects/birdclaw && fnm exec --using 25.8.1 pnpm -s cli mentions export --mode xurl --refresh --all --max-pages 20 --limit 100 > /tmp/clawblocker-replies-xurl.json && jq '{result_count: .meta.result_count, page_count: .meta.page_count, newest_id: .meta.newest_id, oldest_id: .meta.oldest_id}' /tmp/clawblocker-replies-xurl.json`
- shortlist: `cd /Users/steipete/Projects/birdclaw && fnm exec --using 25.8.1 pnpm -s cli inbox --kind mentions --limit 12 --score --json > /tmp/clawblocker-reply-inbox.json && jq '{stats, items: [.items[] | {entityId, createdAt, score, summary, reasoning, text, handle: .participant.handle, followersCount: .participant.followersCount}]}' /tmp/clawblocker-reply-inbox.json`
- high-follower backlog: `sqlite3 -json /Users/steipete/.birdclaw/birdclaw.sqlite "select t.id as entityId, t.created_at as createdAt, p.handle, p.followers_count as followersCount, substr(replace(replace(t.text, char(10), ' '), char(13), ' '), 1, 220) as text from tweets t join profiles p on p.id = t.author_profile_id where t.kind = 'mention' and t.is_replied = 0 and p.followers_count >= 10000 order by t.created_at desc limit 15;" > /tmp/clawblocker-reply-backlog.json && cat /tmp/clawblocker-reply-backlog.json`
- mention detail: `/Users/steipete/Projects/bird/bird read TWEET_ID --json`
- thread: `/Users/steipete/Projects/bird/bird thread TWEET_ID --json`
- profile/context: `/Users/steipete/Projects/bird/bird user AUTHOR_ID -n 6 --json`
- relationship check: `/Users/steipete/Projects/bird/bird status AUTHOR_ID --json`

Selection notes:
- `birdclaw inbox` already ranks by mention urgency, specificity, and influence; use it as the first cut.
- Also check the high-follower backlog query so older but important unreplied mentions do not get buried by recency.
- Do not stream full raw cache payloads into the model. Use the compact `jq` summaries above.
- The full JSON is still available in `/tmp/clawblocker-replies-bird.json`, `/tmp/clawblocker-replies-xurl.json`, `/tmp/clawblocker-reply-inbox.json`, and `/tmp/clawblocker-reply-backlog.json` if needed.
- Do not trust `birdclaw` `is_replied` alone. Peter may have replied outside `birdclaw`.
- `bird thread` is the required final check before surfacing a candidate.
- If the thread already contains a Peter reply that resolves the substance, mark resolved and skip.
- If someone else already answered adequately and Peter is not needed, skip.
- If the mention is mostly social fluff, skip.
- If the mention is critique but still vague, skip unless there is a concrete symptom, repro, sharp question, or useful counterproposal.
- If the mention is a bug report or technical question with concrete details, strongly prefer surfacing it.
- If Peter opened the loop first and the other person is asking for the next step, strongly prefer surfacing it.
- If the mention is from a high-signal account with a real ask, prefer surfacing it.
- If the mention is from a stranger asking for broad unpaid work with no specific question, skip.
- If it smells promotional, belongs in moderation, or is only praise from a large account, skip.
- If unsure whether it belongs here or moderation, prefer moderation logic and skip from reply triage.
