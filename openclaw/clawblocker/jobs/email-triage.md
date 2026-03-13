Email Triage

Purpose: review Peter's Gmail inbox with `gog`. Careful first. Surface real work. Suppress sludge. Auto-archive only exact junk.

Run contract:
- Read `./triage/EMAILRULES.md` first every run.
- Read `./state/email.json` before triage.
- Use `gog` only for Gmail access.
- Automatic mutation allowed only for exact Rule 1 / Rule 2 matches from `./triage/EMAILRULES.md`.
- For any auto-archive candidate, fetch the thread first before acting.
- Archive by removing the `INBOX` label from the thread, not by deleting.
- Verify archive succeeded before recording success.
- No mark-read, no labels besides removing `INBOX` for exact auto-archive matches, no reply, no delete.
- Check unread inbox, recent inbox mail, security mail, and GitHub mail.
- First, scan previously reported noise that is still in `INBOX`. If any of it is an exact Rule 1 / Rule 2 match, archive it before the normal digest pass.
- Re-report older unread security/human/time-bound mail still sitting in inbox.
- Do not repeat the same low-value noise every run if it was already reported.
- Exception: if already-reported noise is still in `INBOX` and is an exact Rule 1 / Rule 2 match, re-check it and auto-archive it.
- Write one audit note to `./audit/email/YYYY-MM-DD.md`.
- Update `./state/email.json` with `lastRunAt` and capped reported thread ids.
- End with one terse digest.

Commands:
- unread: `gog -a steipete@gmail.com gmail search 'in:inbox is:unread' --json`
- recent: `gog -a steipete@gmail.com gmail search 'in:inbox newer_than:3d' --json`
- security: `gog -a steipete@gmail.com gmail search 'in:inbox (security OR vulnerability OR GHSA OR CVE OR incident OR breach)' --json`
- github: `gog -a steipete@gmail.com gmail search 'in:inbox from:notifications@github.com' --json`
- get: `gog -a steipete@gmail.com gmail get MESSAGE_ID --json`
- thread: `gog -a steipete@gmail.com gmail thread get THREAD_ID --json`
- archive-thread: `gog -a steipete@gmail.com gmail thread modify THREAD_ID --remove INBOX --json --force --no-input`

Decision rules:
- Security / incident / abuse: keep. never auto-archive.
- Time-bound ops: keep.
- Real human / needs reply: keep.
- GitHub direct action: keep.
- Unknown / unclear class: keep.
- Newsletter / event / broadcast: archive candidate only.
- Auto-reply / confirmation / machine noise: exact Rule 1 match => auto-archive; else archive candidate only.
- Unknown low-context tasking mail with no relationship/context: exact Rule 2 match => auto-archive; else archive candidate only.
- Prefer false positive over false negative for security/human mail.
- If unsure whether a sender is human or whether a thread has context, fetch the full thread before deciding.
- If archive fails or verification fails, record `FAIL` in the audit and leave it for a later run.
