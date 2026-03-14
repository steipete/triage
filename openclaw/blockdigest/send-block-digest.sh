#!/bin/bash
set -euo pipefail

WORKSPACE="${WORKSPACE:-$HOME/.openclaw/workspace-twitter-block-digest}"
STATE_FILE="${STATE_FILE:-$WORKSPACE/state.json}"
AUDIT_DIR="${AUDIT_DIR:-$HOME/.openclaw/workspace-clawblocker/audit/twitter}"
ACCOUNT="${GOG_ACCOUNT:-steipete@gmail.com}"
TO_EMAIL="${BLOCK_DIGEST_TO:-steipete@gmail.com}"
GOG_BIN="${GOG_BIN:-gog}"
NOW_UTC="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

TMPDIR_PATH="$(mktemp -d /tmp/block-digest.XXXXXX)"
BODY_FILE="$TMPDIR_PATH/body.txt"
META_FILE="$TMPDIR_PATH/meta.json"
cleanup() {
  rm -rf "$TMPDIR_PATH"
}
trap cleanup EXIT

/usr/bin/python3 - "$STATE_FILE" "$AUDIT_DIR" "$NOW_UTC" "$BODY_FILE" "$META_FILE" <<'PY'
import json
import re
import sys
from collections import OrderedDict
from datetime import datetime, timedelta, timezone
from pathlib import Path
from zoneinfo import ZoneInfo

state_path = Path(sys.argv[1])
audit_dir = Path(sys.argv[2])
now_utc = datetime.fromisoformat(sys.argv[3].replace("Z", "+00:00"))
body_path = Path(sys.argv[4])
meta_path = Path(sys.argv[5])

london = ZoneInfo("Europe/London")

date_from_file_re = re.compile(r"^(?P<date>\d{4}-\d{2}-\d{2})$")
heading_re = re.compile(r"^##\s+Pass(?:\s+@)?\s+(?P<hm>\d{2}:\d{2})\s+UTC$")
pipe_re = re.compile(
    r"^-?\s*(?P<ts>[^|]+?)\s*\|\s*(?P<action>[A-Za-z-]+)\s*\|\s*(?P<handle>@[^|]+?)\s*\|\s*(?P<url>https?://[^| ]+)\s*\|\s*(?P<reasons>.*?)(?:\s*\|\s*transport:\s*(?P<transport>.*))?$",
    re.IGNORECASE,
)
emdash_re = re.compile(
    r"^-?\s*(?P<ts>.+?)\s+—\s+(?P<action>block|keep|mute)\s+—\s+(?P<handle>@\S+)\s+—\s+(?P<url>https?://\S+)\s+—\s+(?P<reasons>.*?)(?:\s+—\s+(?P<transport>.*))?$",
    re.IGNORECASE,
)
compact_re = re.compile(
    r"^-?\s*`?(?P<tweet_id>\d+)`?\s+(?P<handle>@\S+)\s+—\s+(?P<action>BLOCK|KEEP|MUTE)\s+—\s+(?P<reasons>.*?)(?:\s+Transport:\s*(?P<transport>.*))?$",
    re.IGNORECASE,
)

def parse_ts(raw: str) -> datetime:
    raw = raw.strip()
    for fmt in (
        "%Y-%m-%dT%H:%M:%S.%fZ",
        "%Y-%m-%dT%H:%M:%SZ",
        "%Y-%m-%d %H:%M:%S GMT",
        "%Y-%m-%d %H:%M GMT",
        "%Y-%m-%d %H:%M UTC",
        "%Y-%m-%d %H:%MZ",
    ):
        try:
            return datetime.strptime(raw, fmt).replace(tzinfo=timezone.utc)
        except ValueError:
            pass
    if raw.endswith(" Europe/London"):
        base = raw[: -len(" Europe/London")]
        return datetime.strptime(base, "%Y-%m-%d %H:%M").replace(tzinfo=london).astimezone(timezone.utc)
    try:
        return datetime.fromisoformat(raw.replace("Z", "+00:00")).astimezone(timezone.utc)
    except ValueError:
        return datetime.strptime(raw, "%Y-%m-%d %H:%M:%S").replace(tzinfo=timezone.utc)

def build_entry(ts: datetime, handle: str, url: str, reasons: str, transport: str) -> dict:
    return {
        "timestamp": ts,
        "url": url,
        "reasons": reasons.strip(),
        "transport": transport.strip(),
    }

def parse_block_line(line, section_ts):
    stripped = line.strip()
    for regex in (pipe_re, emdash_re):
        match = regex.match(stripped)
        if not match:
            continue
        action = match.group("action").strip().lower()
        if action != "block":
            return None
        ts = parse_ts(match.group("ts"))
        handle = match.group("handle").strip()
        return handle, build_entry(
            ts,
            handle,
            match.group("url").strip(),
            match.group("reasons"),
            match.group("transport") or "",
        )
    compact = compact_re.match(stripped)
    if compact and section_ts is not None and compact.group("action").strip().lower() == "block":
        handle = compact.group("handle").strip()
        url = f"https://x.com/{handle.lstrip('@')}/status/{compact.group('tweet_id')}"
        return handle, build_entry(
            section_ts,
            handle,
            url,
            compact.group("reasons"),
            compact.group("transport") or "",
        )
    return None

state = {"lastSentAt": None, "lastSubject": None, "lastCount": 0}
if state_path.exists():
    try:
        state.update(json.loads(state_path.read_text()))
    except Exception:
        pass

last_sent_raw = state.get("lastSentAt")
if last_sent_raw:
    window_start = datetime.fromisoformat(str(last_sent_raw).replace("Z", "+00:00"))
else:
    window_start = now_utc - timedelta(days=1)

entries: OrderedDict[str, dict] = OrderedDict()
for path in sorted(audit_dir.glob("*.md")):
    section_ts = None
    date_match = date_from_file_re.match(path.stem)
    file_date = date_match.group("date") if date_match else None
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        heading = heading_re.match(raw_line.strip())
        if heading and file_date:
            section_ts = datetime.fromisoformat(f"{file_date}T{heading.group('hm')}:00+00:00")
            continue
        parsed = parse_block_line(raw_line, section_ts)
        if not parsed:
            continue
        handle, item = parsed
        ts = item["timestamp"]
        if ts <= window_start or ts > now_utc:
            continue
        if handle not in entries:
            entries[handle] = item

local_date = now_utc.astimezone(london).strftime("%Y-%m-%d")
window_label = (
    f"{window_start.astimezone(london).strftime('%Y-%m-%d %H:%M %Z')} "
    f"to {now_utc.astimezone(london).strftime('%Y-%m-%d %H:%M %Z')}"
)

if entries:
    subject = f"Daily X Block Digest - {local_date} ({len(entries)})"
    lines = [
        f"Blocked profiles since last digest: {len(entries)}",
        f"Window: {window_label}",
        "",
    ]
    for handle, item in entries.items():
        when = item["timestamp"].astimezone(london).strftime("%Y-%m-%d %H:%M %Z")
        lines.append(f"- {handle} - {item['reasons']}")
        lines.append(f"  When: {when}")
        lines.append(f"  URL: {item['url']}")
        if item["transport"]:
            lines.append(f"  Transport: {item['transport']}")
        lines.append("")
else:
    subject = f"Daily X Block Digest - {local_date} (0)"
    lines = [
        "Blocked profiles since last digest: 0",
        f"Window: {window_label}",
        "",
        "No new blocked profiles in this window.",
        "",
    ]

body_path.write_text("\n".join(lines).rstrip() + "\n", encoding="utf-8")
meta_path.write_text(
    json.dumps(
        {
            "subject": subject,
            "count": len(entries),
            "windowStart": window_start.astimezone(timezone.utc).isoformat().replace("+00:00", "Z"),
            "windowEnd": now_utc.astimezone(timezone.utc).isoformat().replace("+00:00", "Z"),
        },
        indent=2,
    )
    + "\n",
    encoding="utf-8",
)
PY

SUBJECT="$(/usr/bin/python3 - "$META_FILE" <<'PY'
import json
import sys
print(json.load(open(sys.argv[1], encoding="utf-8"))["subject"])
PY
)"
COUNT="$(/usr/bin/python3 - "$META_FILE" <<'PY'
import json
import sys
print(json.load(open(sys.argv[1], encoding="utf-8"))["count"])
PY
)"

"$GOG_BIN" gmail send \
  --account "$ACCOUNT" \
  --to "$TO_EMAIL" \
  --subject "$SUBJECT" \
  --body-file "$BODY_FILE" \
  --json >/dev/null

/usr/bin/python3 - "$STATE_FILE" "$NOW_UTC" "$SUBJECT" "$COUNT" <<'PY'
import json
import sys
from pathlib import Path

state_path = Path(sys.argv[1])
state = {"lastSentAt": None, "lastSubject": None, "lastCount": 0}
if state_path.exists():
    try:
        state.update(json.loads(state_path.read_text()))
    except Exception:
        pass
state["lastSentAt"] = sys.argv[2]
state["lastSubject"] = sys.argv[3]
state["lastCount"] = int(sys.argv[4])
state_path.write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")
PY

echo "sent block digest: subject=\"$SUBJECT\" count=$COUNT"
