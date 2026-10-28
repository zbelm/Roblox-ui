---
topic: analytics-liveops
summary: How to measure a live game (built-in dashboards, custom/funnel/economy events, A/B tests) and run an update cadence with feedback
keywords: analytics, AnalyticsService, LogCustomEvent, LogFunnelStepEvent, LogOnboardingFunnelStepEvent, LogEconomyEvent, LogProgressionEvent, custom fields, retention, D1, D7, engagement, monetization, funnel, economy, alerts, experiments, A/B, configs, LiveOps, content cadence, feedback, upvotes, insights
verified: 2026-10-28
---
# Analytics and LiveOps
## Use this
- Funnel events: onboarding and recurring funnels with `LogOnboardingFunnelStepEvent`/`LogFunnelStepEvent` https://create.roblox.com/docs/production/analytics/funnel-events [S341]
- Custom events: track any metric, filter with custom fields https://create.roblox.com/docs/production/analytics/custom-events [S339]
- Economy events: currency sources, sinks, and wallet balances https://create.roblox.com/docs/production/analytics/economy-events [S342]
- Experiments: A/B tests with targeting and minimum detectable effect guidance [S43]
- Content updates: choosing update content, scope, routine, sustainability https://create.roblox.com/docs/production/game-design/content-updates [S346]
## Concepts
- Built-in dashboards (no code): acquisition, retention (D1/D7/D30), engagement (session time, playtime), monetization, performance, errors, feedback [S334][S335][S336][S337][S338].
- `AnalyticsService` is server-side; current methods are `LogCustomEvent`, `LogFunnelStepEvent`, `LogOnboardingFunnelStepEvent`, `LogEconomyEvent`, and `LogProgression*Event` [S347].
- Custom events: up to 100 per game; put variety into custom fields (up to 3) instead of new event names, because event names have a much tighter cardinality limit [S339][S340].
- Funnels: log each ordered step (joined, finished tutorial, first purchase); the dashboard shows drop-off between steps. Start with an onboarding funnel; it maps directly to D1 retention [S341][S272].
- Economy events: log every source and sink with currency name, amount, and transaction type to see inflation and where currency leaves the game [S342][S64].
- Alerts notify you when metrics cross thresholds (for example error spikes after an update) [S343].
- A/B tests: Experiments split players between config values and report the effect on retention, engagement, and monetization; Roblox suggests games under 500 DAU grow before running them [S43][S42][S79].
- Configs are the switch for LiveOps: turn events and tuning values on without a publish (see events docs) [S42].
- Feedback: the Feedback dashboard shows upvote/downvote trends (from 2025-02-01) and comments (from 2025-03-17); insight reports summarize player feedback [S344].
- Cadence: frequent small content drops built on existing systems (items, maps, quests, limited-time events) between larger system updates; pick a sustainable rhythm (weekly to monthly) [S48][S346].
- Plan, communicate, and monitor each update: release notes, update announcements, and before/after metrics [S49].
- Analytics essentials covers which metrics matter at each stage of a game [S345].
## Gotchas
- `AnalyticsService:FireCustomEvent`, `FireEvent`, `FireInGameEconomyEvent`, `FireLogEvent`, `FirePlayerProgressionEvent`, and `ApiKey` are deprecated; use `Log*` methods [S347].
- Custom events appear in the Explore page only after the game starts sending them [S339].
- Do not log one event name per item or level; use custom fields [S339].
- Experiments need enough traffic to detect an effect; small games will see "inconclusive" results [S43].
- Feedback data only covers dates since early 2025 [S344].
## Sources
S42, S43, S48, S49, S64, S79, S272, S334, S335, S336, S337, S338, S339, S340, S341, S342, S343, S344, S345, S346, S347
