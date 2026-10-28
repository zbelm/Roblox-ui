---
topic: policy-compliance
summary: What Roblox policy requires of a game: Community Standards, maturity labels, Kids/Select publishing, chat and age rules, moderation (checked 2026-10-28)
keywords: Community Standards, Terms of Use, content maturity, Minimal, Mild, Moderate, Content May Vary, Restricted, Roblox Kids, Roblox Select, age check, facial age estimation, ID verification, 2FA, TextChatService, TextChannel, text filtering, FilterStringAsync, moderation, takedown, IP, copyright, DMCA, social links, off-platform, ads policy, BanAsync, PolicyService
verified: 2026-10-28
---
# Policy and compliance
## Use this
- Community Standards: safety, civility, integrity (incl. economy), security rules https://about.roblox.com/community-standards [S312]
- Content maturity: questionnaire, labels, and who can see your game https://create.roblox.com/docs/production/promotion/content-maturity [S313]
- Roblox Kids and Select: requirements to publish to players under 16 https://create.roblox.com/docs/production/publishing/kids-and-select [S314]
- Chat guidelines: every player-to-player message goes through a `TextChannel` https://create.roblox.com/docs/chat/guidelines [S318]
- IP guidelines: copyright/trademark basics and reporting https://create.roblox.com/docs/production/publishing/ip-guidelines [S317]
## Concepts
- Community Standards top level: Safety, Civility, Integrity (cheating, scams, misleading content, IP, advertising, Roblox Economy), Security (personal info, off-platform direction, system misuse) [S312].
- Maturity labels gate audiences [S313]:
  - Minimal or Mild: eligible for Roblox Kids (5-8) and Roblox Select (9-15).
  - Moderate: Roblox Select (9-15) and standard Roblox (16+).
  - Content May Vary: age-checked users 16+ only.
  - Restricted: age-verified users 18+ only.
- Games without maturity information have restricted playability for all players; answer for the most extreme content a player can encounter [S313].
- Publishing to under-16 players requires: good standing, verification (facial age estimation if under 18, government ID if 18+ [S321]), 2FA, a Minimal/Mild/Moderate rating, either 2 months of Roblox Plus/Premium or a refundable fee, and an evaluation (trial with age-checked 16+ users until 250 unique plays by highly engaged users within 60 days) [S314].
- 16+ publishing needs an account at least 2 days old, age verification, and the first maturity question answered [S314].
- Chat: player messages (bubbles, chat window, DMs, team chat) must go through `TextChannel` so filtering, privacy settings, and moderation apply. Developer UI strings and game status messages are not chat [S318].
- Any player-written text shown to others (pet names, signs) must be filtered with `TextService:FilterStringAsync` [S17].
- Age checks (selfie-based estimation or ID) unlock chat with similar-age users and trusted friends [S322].
- Off-platform links are allowed only through Social Links, for age-checked users 16+; anything else that directs users off Roblox is prohibited [S312].
- Economy rules: disclose paid random item odds, every outcome must give some benefit, gate with `PolicyService` [S312][S63].
- Ads: since 2026-05-04, non-Roblox ad integrations must follow the Advertising Integrations policy and be registered; no direct calls to third-party ad services; no personalized ads to under-18s [S312].
- Moderation tools: bans dashboard and `Players:BanAsync`; Community Standards require third-party tool kicks and bans to use Roblox's Kick and Ban API [S319][S312].
- Roblox's creator safety page lists safety tools and safety analytics to monitor [S320].
- Uploaded assets are moderated separately from your maturity label; realistic violence, blood, crude humor, or romance in images, meshes, or audio can be removed even in a mature-labeled game [S313].
## Gotchas
- Common takedown and moderation causes from the policies: inaccurate maturity answers, restricted content without a Restricted label, misleading or duplicated metadata, near-identical repeat uploads, games built to send users off Roblox, IP infringement, unfiltered player text [S312][S313][S317][S318].
- Repeated inaccurate maturity information leads to game and account consequences [S313].
- Publishing or expedited-review fees are not refunded if the game is permanently moderated for Community Standards violations [S314].
- The "Experience guidelines" page still describes an older age-recommendation system ("Ages 13+"); the content maturity page is the current one. Ambiguous which is authoritative where they differ [S315][S313].
- Terms of Use, Help Center policy articles, and the Audio Upload License on en.help.roblox.com returned HTTP 403 to the research session; read them in a browser [S253].
- Content may be unavailable in some countries due to local law [S316].
## Sources
S17, S63, S253, S312, S313, S314, S315, S316, S317, S318, S319, S320, S321, S322
