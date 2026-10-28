---
topic: events
summary: How to schedule limited-time and seasonal content, switch events live with configs, coordinate across servers, and promote with Roblox event features
keywords: live event, seasonal, limited-time, ConfigService, GetConfigAsync, ConfigSnapshot, UpdateAvailable, Refresh, GetValueChangedSignal, GetConfigForPlayerAsync, experiments, DateTime.fromUniversalTime, UTC, os.time, GetServerTimeNow, MessagingService, MemoryStore, experience events, RSVP, ExperienceNotificationService, Event Sequencer, feature packages, season pass
verified: 2026-10-28
---
# Live and seasonal events
Files: data-services.md (which store to use and their limits).
## Use this
- Experience configs (`ConfigService`): live on/off switch and tuning; launched 2025-11-06 https://create.roblox.com/docs/production/configs [S42][S79]
- Experience events and updates: Roblox-hosted event pages with RSVP and charts https://create.roblox.com/docs/production/promotion/experience-events [S44]
- Event Sequencer: Roblox framework for timed cross-server scenes and concerts https://create.roblox.com/docs/resources/modules/event-sequencer [S46]
- LiveOps essentials and planning: cadence, limited-time and seasonal content https://create.roblox.com/docs/production/game-design/liveops-essentials [S48][S49]
- Snippets: `snippets/events-utc-schedule.luau`, `snippets/events-config-flag.luau`, `snippets/events-cross-server-announce.luau` (unverified, not run in Studio)
## Concepts
- Time: store event windows as UTC Unix seconds built with `DateTime.fromUniversalTime(y, m, d, h, mi, s).UnixTimestamp`; compare with `os.time()` on the server and `workspace:GetServerTimeNow()` on clients.
- Recurring events (every Saturday 18:00 UTC, every 4 hours) derive from a fixed anchor plus a period, so every server computes the same next occurrence without shared state.
- Switches: put the window and flag in a config; the server calls `ConfigService:GetConfigAsync()` and `snapshot:GetValue(key)` [S42].
- Snapshots do not change on their own: listen to `UpdateAvailable`, call `Refresh()`, react to `GetValueChangedSignal(key)`; apply between rounds if mid-match changes would be unfair [S42].
- Configs are server-only; replicate results to clients via attributes or your replication layer [S42].
- Per-player variants use `GetConfigForPlayerAsync(player)` with conditional rules from Creator Hub; experiments (A/B tests) build on the same API [S42][S43].
- Cross-server: the triggering server calls `MessagingService:PublishAsync`; subscribers via `SubscribeAsync` receive within seconds; best effort, so confirm against schedule or config [S50].
- Shared counters (community goals) go in a `MemoryStoreSortedMap` or `HashMap` with `UpdateAsync`, flushed periodically to a DataStore (see data-services.md) [S55].
- Limited-time content: gate on the server by schedule; grant event currency with an expiry or season id and convert or wipe at season end; keep event items in the catalog with `available = false` so owners keep them and analytics resolve ids.
- Promotion: create events on Creator Hub (Engagement > Events & Updates) with thumbnail, category, title, times, optional event place, public or private; RSVPs get notified at start; update announcements notify opted-in players [S44].
- `ExperienceNotificationService` sends parameterized notifications to opted-in users 13+ once the game has 100+ visits [S45].
- Feature packages ship server code and default UI for season passes, missions, bundles, engagement rewards [S47].
## Gotchas
- `os.time(table)` follows the running machine's time-zone rules; use `DateTime.fromUniversalTime` for event dates.
- `GetServerTimeNow()` is for visuals and countdowns; claim timed rewards on the server.
- Config publish timing: the configs page says ~15 s to a minute (or 15 min gradual rollout); the data-stores-vs-memory-stores page says over five minutes; plan for minutes [S42][S54].
- `ConfigService` cannot list keys (open feature request) and errors on the client [S81][S42].
- `GetConfigAsync()` throws if configs never loaded; wrap in `pcall` with code defaults [S42].
- MessagingService: 1 kB per message, topics 1-80 characters, per-server limits scale with players; no guaranteed delivery or ordering [S50].
- MemoryStore evicts on expiry and over quota; never the only copy of anything paid for [S55].
- Max 10 ongoing or upcoming events per experience; Trending Events needs 1,000+ RSVPs, public, started within 7 days [S44].
- Event pages persist after the event; delete them if reusing names [S44].
- Open Cloud Configs API exists for managing configs from tools [S80].
## Sources
S42, S43, S44, S45, S46, S47, S48, S49, S50, S54, S55, S79, S80, S81
