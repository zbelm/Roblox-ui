---
topic: progression
summary: How to design XP curves, unlock trees, quests, achievements/badges, and onboarding (FTUE)
keywords: progression, XP, level, curve, exponential, quadratic, unlock tree, quest, daily, achievement, badge, BadgeService, AwardBadgeAsync, UserHasBadgeAsync, onboarding, FTUE, tutorial, D1 retention, core loop, season pass, missions package, engagement rewards
verified: 2026-10-28
---
# Progression
## Use this
- Onboarding (FTUE) guide: D1 funnel, teach essentials, get to fun fast https://create.roblox.com/docs/production/game-design/onboarding [S272]
- Quest design: objective, quantity, reward; achievements vs dailies https://create.roblox.com/docs/production/game-design/introduction-to-quest-design [S274]
- Core loops: minute-to-minute loop and the progression engine around it https://create.roblox.com/docs/production/game-design/core-loops [S271]
- Missions feature package: quest system with UI and server code https://create.roblox.com/docs/resources/feature-packages/missions [S278]
- Badges guide: creating and awarding badges https://create.roblox.com/docs/production/publishing/badges [S276]
## Concepts
- Core loop: the short action players repeat (fight, collect, sell); progression wraps it with goals that make the next loop better (stronger weapon, new area) [S271].
- XP curves (pick one, keep it in config) [S280][S281]:
  - Linear: `xpToNext = base * level`. Predictable; late levels feel samey.
  - Polynomial: `xpToNext = base * level ^ p` with `p` about 1.5 to 2. Common default.
  - Exponential: `xpToNext = base * r ^ level` with `r` about 1.05 to 1.15. Steep late game; cap the level.
  - Store total XP; derive level from it (closed-form inverse or a precomputed table) so curve changes never corrupt saves.
- Early levels should come fast; Roblox's onboarding guide suggests low early thresholds tuned live through Configs [S272].
- Unlock trees: data table of nodes `{ id, cost, requires = { ids } }`; the server checks prerequisites and cost before granting; clients only render the tree.
- Quests: objective + quantity + reward; chains unlock follow-ups. Achievements (badges) are long, prestige goals; dailies are short tasks that reset every 24 hours and give modest rewards [S274].
- Daily resets: key progress by UTC day (`os.date("!*t")` or day number from `os.time() // 86400`) so every server agrees.
- Badges: `BadgeService:AwardBadgeAsync(userId, badgeId)` and `UserHasBadgeAsync`; award from the server only [S277].
- Onboarding: teach controls and the core loop, then show progression, social hooks, or starter items within the first minutes; measure each step as a funnel and A/B test changes with Experiments [S272][S273].
- Onboarding techniques: visual cues (arrows, highlights), contextual tutorials triggered at the moment a mechanic matters, timed hints when a player stalls [S273].
- Season passes: free and paid tracks of rewards over a fixed season, fed by missions; design goals and mission cadence before rewards [S275].
- Engagement rewards package: drop-in daily login and playtime rewards [S279].
## Gotchas
- `BadgeService:AwardBadge`, `UserHasBadge`, `IsDisabled`, and `IsLegal` are deprecated; use the `...Async` methods [S277].
- Badge creation: 5 free per game per 24 hours (GMT), then 100 Robux each [S276].
- Badge awards are network calls; wrap in `pcall` and avoid re-awarding every join (check `UserHasBadgeAsync` or your own saved flag) [S277].
- Changing an XP formula after launch shifts every player's level unless you store total XP [S280].
- Dailies that require too much time become chores and hurt retention; keep them short [S274].
## Sources
S271, S272, S273, S274, S275, S276, S277, S278, S279, S280, S281
