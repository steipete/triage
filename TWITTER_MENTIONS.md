# Twitter Mention Triage

Source: live `bird mentions` fetch plus `bird user` / `bird status` review
Date: 2026-03-09
Current local blocklist: active

## Block rules

Principle:

- If they are nice to Peter, do not block just for crypto-ish / AI-ish bio or identity markers.
- Block bad behavior. Nice, relevant, or genuinely human mentions get benefit of the doubt.
- Crypto/AI identity markers alone are not enough. They only raise scrutiny.

Block immediately if any of these:

- Strongly derogatory. Direct abuse, contempt, dehumanizing phrasing, hostile pile-on bait.
- Crypto. Token strings, wallet/mint spam, long hex-like contract strings, `.bsc` / `pump` / memecoin handles, `XBT` / `BNB` / `0x` branding when paired with low-signal behavior, obvious shill behavior.
- Clearly AI slop. Nonsensical phrasing, synthetic abstraction soup, agent roleplay, repeated canned slogans, or obvious LLM cadence.
- Repetitive spam. Same question repeated, mascot spam, repeated low-context replies in one thread, image-only or link-only drive-bys.
- Promo spam. Self-promo, product plug, signup pitch, platform/ad copy, or link-drop marketing disguised as a reply.
- Project-token promo. Coin/project accounts using OpenClaw/agents/lobster branding to pitch treasury plans, rewards, sponsorships, mining, earnings, or token campaigns.

## Hard triggers

Block on sight if any of these appear:

- raw token string ending in `pump`
- long hex-like crypto hash / contract string, especially `0x...`
- handle/display name with `.bsc`, `XBT`, `BNB`, `0x`, `Crypto` should trigger stricter review, not automatic block
- handle/display/bio with `eth`, `Ethereum`, `.eth`, or similar crypto identity markers should be treated as crypto-coded in moderation, not blocked on identity alone
- trader / trading / airdrop-hunter identity in handle, display name, or bio is a strong crypto/noise signal, not an automatic block on its own
- trader / trading / airdrop-hunter identity should trigger immediate profile-reply inspection
- `degen` in handle, display name, or bio is a strong crypto/noise signal
- crypto-coded handle/display name plus a silly low-signal question: logo bait, mascot bait, `is this your logo`, `is X a mascot`, `what is this logo`, similar empty prompts
- if someone asks for a logo: investigate profile replies immediately
- if someone self-promotes a product/platform/site in your mentions: investigate profile replies immediately
- if someone drops a link while pitching a product/platform/site in your mentions: treat as promo and dig
- if a project/coin account pitches OpenClaw competitions, sponsorship, treasury/reward schemes, mining, or "earn money" programs: treat as shill/promo and dig immediately
- if unsure, profile bio promotes coins, tickers, memecoins, token wealth, or crypto identity markers: inspect mention + recent replies before deciding
- if someone posts an X community link in your mentions: be suspicious immediately
- domain-for-sale / squatter spam in mentions: `for sale`, `domain for sale`, `DM if interested`, repeated sale pings at founders/projects
- tiny or low-cred account plus mild hostile bait: `stop lying`, `bro`, empty accusation, drive-by contempt with no substance
- repeated `Is MOLTY a mascot?` / mascot-style bait
- image-only ping with no real text
- community-link ping with no real text
- direct guilt-bait agent roleplay
- repeated crisis-begging / family-emergency money pleas across replies
- direct abuse like `fucking drone` / similar contempt bait
- direct profanity/abuse in a reply should trigger conversation loading to confirm who the abuse is aimed at

## AI heuristics

One signal alone: not enough.

Needs 2+ signals, or one very strong one:

- em dash + overexplainer tone
- weirdly generic certainty
- phrase patterns like `the real unlock`, `the exact kind of`, `fantastic pattern`, `System 2 thinking`
- roleplay / anthropomorphism that reads machine-generated
- repetitive low-context replies that don’t track the thread
- abstract nouns stacked together with no concrete ask
- fake sage commentary about "agents", "workflows", "interoperability", "reasoning"
- vague cautionary wisdom with no specifics: `seamless on the surface`, `architectural debt`, `I learned this the hard way`
- promo phrasing: `so I built`, `I made`, `check this out`, `built a platform`, `agents need a place`, `go to work`, `earn`, `sign up`, or similar ad-copy framing
- project-shill phrasing: `our treasury`, `campaign idea`, `competition`, `sponsorship`, `award`, `earn money`, `mining`, `champion`, `Bitcoin for agents`, or similar token-marketing framing
- if unsure: check their profile `with_replies` lane first. Pattern beats one tweet.
- if unsure: tiny account size raises suspicion. Very small follower count, weak history, and disposable-account shape should lower the bar for blocking.
- if unsure: check profile bio. Coin/ticker flex (`$TSLA`, `$BTC`, `$ETH`, etc), memecoin identity, or obvious crypto self-branding should raise scrutiny, not override a nice/genuine mention by itself.
- AI-coded handle or bio plus generic policy/strategy talk with no specifics should push the account toward block only when the mention/recent pattern is also low-value.
- AI-coded plus ETH/crypto-coded identity plus a throwaway one-word mention (`Nice`, `Wow`, `Yes`, similar) is suspicious, but still check whether the account is actually spammy before blocking.
- strong pattern signal: same upbeat, generic, thread-detached reply style across unrelated accounts within minutes
- strong pattern signal: templated compliment-bot voice: `Totally agree!`, `That sounds interesting!`, `Hope they consider it!`, `incredibly inspiring`
- medium pattern signal: generic AI/agent-infra praise with no specifics: `proper agent infra`, `meta-solution`, `brilliant use`, `powerful combo`
- medium pattern signal: generic policy/strategy filler: `the next step is`, `the bigger concern is`, `the part nobody mentions is`, `can provide invaluable insight`

Do not block for:

- one em dash by itself
- short jokes
- genuine questions
- awkward English without other spam/slop signals
- real product questions, even if phrased clumsily
- one authentic builder mention without a pitch or link drop

Prefer mute over block when:

- the account seems human
- the account is tiny
- the content is mainly in languages other than English or German
- the mention is low-value for your workflow, but not hostile / crypto / obvious AI
- profile replies stay human and specific, even if the content is not useful to you
- `grok`-style annoying nicknames or mildly irritating AI/crypto branding are present, but the account is not actually bad enough to block
- the mention is nice, supportive, or genuinely engaged, even if the profile has crypto/AI markers

## Small-account bias

If somewhat unsure and the account is small: be strict.

- very small follower count should materially increase block weight
- especially strict when the account is also new, low-effort, high-following, or has weak bio / weak replies
- tiny account + low-value mention is usually enough to block
- tiny account + AI-ish phrasing, crypto hints, logo/mascot bait, link-only ping, or generic praise: block
- tiny account + promo/link-drop/self-ad mention: block
- project-token promo using OpenClaw/agents/lobster branding: block, even if the account is not tiny
- do not grant extra benefit of the doubt to disposable-looking accounts

## Blocked examples

- `@0xColorNFT` (`Color🎋`): pure crypto. Dropped a token-style `...pump` string in mentions.
- `@Anglicadapenha` (`CryptoK💎老K`): crypto-branded account; low-signal mascot spam; high chance of ongoing crypto noise.
- `@VirgoMarco67424` (`logo.bsc`): `.bsc` branding; repetitive mascot question; crypto bucket.
- `@AllisGood_Ha` (`Allisgood`): screenshot-only catch. Another raw `...pump` token spam reply.
- `@pxj888` (`bsc 链的 p 小将🔶BNB`): stupid crypto hash / contract string plus explicit BNB branding.
- `@CryptoKobe92`: crypto-coded handle plus silly logo question. No value; just another crypto-logo gremlin.
- `@sanjaygpts` (`$anjay`): tiny account, crypto/AI-coded naming, low-substance hostility: `stop lying sir`.
- `@AIHacksByMK`: AI-coded handle, generic anti-evasion / strategy talk, and repeated polished no-detail replies across unrelated threads.
- `@Brian_Degens`: `degen` identity plus DM-bait mention and cashtag / degen-reply pattern.
- `@RzaINF`: community-link ping in mentions; profile replies contained `$SlACRAWL`, a memecoin address, and other crypto chatter. Community post triggered review; profile convicted.
- `@AiDomainName`: `Domains For Sale` account; repeated `is for sale` pings at project/founder accounts; link/image sales spam, not conversation.
- `@theonomix`: asked for a logo; profile replies were memecoin / fundraiser chatter. Logo ask triggered the profile check; profile convicted.
- `@SammmXBT`: crypto-coded handle + zero-value reply.
- `@0xJapee`: crypto-coded handle + nonsense low-signal reply.
- `@yuka1624`: repetitive mascot spam / same low-value question pattern.
- `@SexyTechNews`: context-free image-only ping.
- `@evilcassieroll`: derogatory bait, not constructive criticism.
- `@seey_dev`: generic AI-sage warning voice. Sounds experienced, says nothing concrete, no actual detail.
- `@gork`: obvious AI-slop reply in the MOLTY thread. Synthetic mascot/Telegram nonsense.
- `@Niraj_Dilshan`: classic AI-overexplainer voice. Empty abstraction soup about `ACP` / `interoperability` / `fantastic pattern`.
- `@longgelongmei`: very likely AI-generated. `OS moment`, `virtual file system`, `System 2 thinking` style slop.
- `@DDFP777`: melodramatic agent roleplay / guilt-bait. Reads synthetic and low-value.
- `@yeswowtrue`: repeated crisis-begging / emotional blackmail across replies. Scam pattern, not one-off hardship.
- `@m0nle0z`: compliment-bot pattern. Generic praise and agreement across unrelated threads, little concrete detail.
- `@pubertecom`: direct abuse. `ur slow clipping u fucking drone`
- `@ShoaibAkhAnsari`: low-value AI/agent-infra chatter repeated across threads. Not as strong as `@jpctan`, but still synthetic / generic enough to block.

## Watch, not block yet

- `@JaredOfAI`: AI-adjacent handle; one em dash; still a real question.
- `@AiOldenburg`: low-signal, but not enough yet.
- `@PANONYGroup`: noisy account class, but this mention was not enough on its own.
- `@JimmyPage6656`: low-signal style, but still a concrete feature ask.
- `@AdamAutomates`: AI-handle, but not slop by itself.
- `@HashHustleHQ`: grok-ish annoying nickname / branding, but not actually bad enough to block. Mute bucket.

## Practical default

If crypto identity is present but the mention is nice, relevant, or genuinely human: do not block on that alone.

If crypto and the mention itself is shill/spam/low-value noise: block.

If promo/self-ad copy is in the mention, inspect recent replies immediately.

If the promo mention is tiny-account, synthetic, link-droppy, or cross-thread repetitive: block.

If a token/project account is using OpenClaw/agents/lobster branding to pitch rewards, mining, treasury plans, sponsorships, or earnings schemes: block.

If they post a community link and their profile tweets/replies contain crypto shit: block.

If they are a domain squatter / `Domains For Sale` account doing repeated sale pings in your mentions: block.

If they present as trader / trading / airdrop hunter and their profile tweets/replies contain crypto shill behavior plus a low-value mention: block.

If `degen` appears and the mention is low-value or crypto-adjacent: block.

If strongly derogatory: block.

If repetitive mascot spam: block.

If crypto-coded handle + silly logo/mascot question: block.

If they ask for a logo: investigate profile replies immediately.

If image-only / link-only drive-by: block.

If repeated crisis-begging / emotional blackmail: block.

If AI-ish: block only when clearly synthetic or repeated.

If tiny account + empty hostility: block.

If AI-coded handle + generic strategy/policy filler + low-value/repetitive pattern: block.

If AI-coded plus ETH/crypto-coded identity and the mention is just a one-word drive-by: block.

If tiny account + non-English/non-German human chatter: mute.

## Borderline workflow

If one tweet feels AI-ish but not enough alone:

- open their profile `with_replies` lane
- read ~8-15 recent replies, not just one
- check follower/following shape too
- check profile bio too
- check language fit too
- if follower count is tiny and the account also looks disposable or low-effort, increase block weight a lot
- if follower count is tiny and the mention is even somewhat suspicious, default to block
- if bio contains coin/ticker promotion or crypto identity signaling, treat that as a strong extra block signal
- especially suspicious: very low followers plus high following, very new account, low-effort bio, low-value replies
- look for repeated generic praise, shallow paraphrase, fake insight, or canned agreement across unrelated topics
- if tiny account is mainly non-English/non-German but reads human and technically specific, prefer mute over block
- if the trigger was a logo question, specifically look for memecoin, fundraiser, token, wallet, or crypto-chatter patterns in recent replies
- if the trigger was a community link, specifically look for memecoin names, cashtags, contract strings, wallet spam, token promotion, or generic crypto-reply sludge in recent replies
- if the trigger was a sale/domain post, specifically look for repeated `is for sale`, `DM if interested`, and founder/project-tagging across recent replies
- if the trigger was trader / trading / airdrop identity, specifically look for `pump` strings, wallet/CA hashes, cashtags, memecoin replies, or degen-chatter in recent replies
- if the trigger was promo/self-ad copy, specifically look for repeated product plugs, link drops, same-site replies, call-to-action language, or cross-thread marketing spam
- if the trigger was project-token promo, specifically look for token slogans, contract-address or `pump` bio strings, repeated OpenClaw-tagging, reward/treasury language, and cross-thread shill replies
- if the trigger was profanity/abuse, load the full conversation with `bird thread` and confirm whether the hostility is directed at Peter, his project, or another participant before deciding
- if the abuse is directed at Peter or his project: block
- if the abuse is directed at someone else in the thread and not really about Peter: do not auto-block just because Peter was tagged
- if the trigger was AI/ETH-coded identity plus a one-word reply, check whether the profile is mostly crypto/AI noise rather than real conversation; if yes, block
- if the mention is supportive, specific, or otherwise nice to Peter, do not block unless there is separate bad behavior
- if crypto-coded or AI-coded handle and the mention itself is low-signal, assume stricter review: profile replies before giving benefit of the doubt
- if the mention smells like an ad, product pitch, or landing-page promotion, default to profile inspection before giving benefit of the doubt
- if the pattern is stable across multiple replies: block
- if it is only one awkward tweet: do not block yet

Primary bird review:

```bash
~/Projects/bird/bird user AUTHOR_ID -n 8 --json
```

Use that first. It includes:

- follower / following counts
- block / mute status
- recent tweets
- recent replies
- parent tweet context for replies
- merged recent activity feed

Fast verify:

```bash
~/Projects/bird/bird status AUTHOR_ID --json
```

Extra context:

```bash
~/Projects/bird/bird read TWEET_ID --json
~/Projects/bird/bird thread TWEET_ID --json
```

## Execution hygiene

- if an account has already been judged `sure block` in triage, block it immediately
- do not leave previously confirmed block targets out of the next batch import

## Case study: `@jpctan`

Why this reads as AI / reply-bot behavior:

- 12 recent replies across unrelated topics in about 8.5 minutes
- all replies are upbeat, generic, and low-risk: praise, agreement, paraphrase
- almost no concrete detail added beyond restating the original post
- same reply shape over and over: `@name` + affirmation + shallow summary + optional hype phrase
- topics jump all over: cricket, sobriety, oil, Cybertruck, CEO advice, Laravel, AI, startups
- engagement is near-zero across the batch, but posting cadence stays constant
- feels thread-detached: each reply is locally plausible, but the account voice is unnaturally uniform

Examples:

- `What a match! ... team first mindset really shone ... Glorious win indeed!`
- `Totally relatable Sam! Less drinking, better sleep, and more energy.`
- `Indeed! Being a CEO architect means building a system that runs itself.`
- `Naval always nails it! ... The cycle is wild.`
- `Laravel’s impact is massive! Huge milestone for the framework.`

Rule extracted:

- if many replies in a short window are all generic praise / agreement across unrelated topics, treat as strong AI signal
- one plausible reply means little; repeated templated positivity is the tell

## Case study: `@m0nle0z`

Why this reads as AI / compliment-bot behavior:

- repeated agreement-heavy replies across unrelated accounts
- positive, polished, low-risk language; almost no original information
- same closers show up again and again: `Totally agree`, `That sounds interesting`, `Hope they consider it`
- reply content flatters the original author, but adds little beyond paraphrase

Examples:

- `AI vs AI is precisely the meta-solution we need. Brilliant use of Birdclaw.`
- `Scaling to 3 million users ... incredibly inspiring`
- `A queue feature would make things so much smoother ... Hope they consider it!`
- `An orchestrator like that could really streamline things. Hope they consider it!`

Rule extracted:

- generic compliments plus generic optimism across unrelated threads = likely AI reply-bot
- if the account keeps sounding encouraging but never specific, treat it as synthetic
