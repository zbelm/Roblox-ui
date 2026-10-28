# Live and seasonal events

Last verified: 2026-10-28

## Purpose

Answers: how to schedule limited-time and seasonal content, turn events on without
a server restart, coordinate events across servers, and promote them with
Roblox's own Events and notifications features. Data-service details (limits,
which store to use): [data-services.md](data-services.md).

## Top 5 picks

1. **Experience configs (`ConfigService`)** (https://create.roblox.com/docs/production/configs). Server-side key/value configs you edit on Creator Hub or in Studio and publish live; snapshots, change signals, per-player targeting, test values. Launched 2025-11-06 ([announcement](https://devforum.roblox.com/t/live-now-use-configs-and-experiments-to-grow-your-game-faster/4051385)). Use it as the on/off switch and tuning knob for every event.
2. **Experience events and updates** (https://create.roblox.com/docs/production/promotion/experience-events). Roblox-hosted event pages with RSVP ("Notify Me"), shown on your game page, group page, and the "Trending Events in Experiences" chart. Use it for every scheduled event.
3. **Event Sequencer module** (https://create.roblox.com/docs/resources/modules/event-sequencer). Roblox's framework for timed, cross-server scenes and concerts (used for the Twenty One Pilots and 24kGoldn concerts), with a Concert template. Use it for scripted live shows; vet the inserted package like any store asset.
4. **LiveOps essentials and planning** (https://create.roblox.com/docs/production/game-design/liveops-essentials, https://create.roblox.com/docs/production/game-design/liveops-planning). Content cadence, limited-time and seasonal content, planning and monitoring. Use it.
5. **Snippets**: [../../snippets/events-utc-schedule.luau](../../snippets/events-utc-schedule.luau), [../../snippets/events-config-flag.luau](../../snippets/events-config-flag.luau), [../../snippets/events-cross-server-announce.luau](../../snippets/events-cross-server-announce.luau). Unverified (not run in Studio).

## How it works

**Time.** Every server must agree on when an event starts. Store event windows as
UTC Unix timestamps (seconds). Build them with
`DateTime.fromUniversalTime(year, month, day, hour, minute, second).UnixTimestamp`,
which is explicitly UTC. Compare against `os.time()` on the server and
`workspace:GetServerTimeNow()` on clients (smoothed, synced to the server).
Recurring events (every Saturday 18:00 UTC, every 4 hours) are computed from a
fixed anchor time and a period, so a server that started at any moment computes
the same next occurrence without shared state.

**Switches.** Hard-coding dates means a publish for every change. Instead, put the
window and the on/off flag in a config: the server reads
`ConfigService:GetConfigAsync()`, gets a `ConfigSnapshot`, and calls
`snapshot:GetValue(key)`. Snapshots do not change on their own; listen to
`UpdateAvailable`, call `Refresh()`, then react to `GetValueChangedSignal(key)`.
You can apply new values only between rounds if mid-match changes would be
unfair. Configs are server-only; replicate the result to clients (attributes or
your replication layer). Per-player variants (new players, payers, a language)
use `GetConfigForPlayerAsync(player)` and the conditional rules set on Creator
Hub; experiments (A/B tests) build on the same API.

**Cross-server.** For "the boss spawns in all servers now" or a global
announcement, the server that triggers it calls `MessagingService:PublishAsync`;
every server subscribed with `SubscribeAsync` receives it within seconds.
Delivery is best effort, so treat messages as hints and let each server confirm
against the schedule or config. Shared counters (community goal: "collect 1M
eggs across all servers") belong in a `MemoryStoreSortedMap` or `HashMap` with
`UpdateAsync`, flushed periodically to a DataStore for permanence.

**Limited-time content.** Gate items and areas by schedule on the server. Grant
event currency into the player's saved data with an expiry or season id, and
convert or wipe it when the season ends. Keep event items in the catalog after
the event with a flag such as `available = false` so owners keep them and
analytics still resolve the id.

**Promotion.** Create the event on Creator Hub (Engagement > Events & Updates):
thumbnail, category, title, times, optional event-specific place, public or
private. Players who RSVP get a notification when it starts. Update
announcements notify opted-in players of new versions. Experience
notifications (`ExperienceNotificationService`) let you send personalized,
parameterized notifications to opted-in users aged 13+ when your game has at
least 100 visits.

**Season passes and missions.** Roblox ships feature packages with server code
and default UI for season passes, missions, bundles, and engagement rewards:
https://create.roblox.com/docs/resources/feature-packages. They save weeks if
your event is a classic pass-and-quest season.

## Gotchas

- `os.time(table)` follows the local time-zone rules of the machine running it; Studio and clients can differ from servers. Use `DateTime.fromUniversalTime` for event dates.
- `GetServerTimeNow()` is for visuals and countdowns, not rewards. Claim timed rewards on the server.
- Config publish timing: the configs page says publishing reaches players in about 15 seconds to a minute (or over 15 minutes for a gradual rollout); the data-stores-vs-memory-stores page says "over the course of five minutes". Plan for minutes, not seconds.
- `ConfigService` cannot list keys (open feature request) and is server-only; calling it from a client errors.
- `GetConfigAsync()` throws if configs have never loaded; wrap it in `pcall` and keep code defaults.
- MessagingService: 1 kB per message, topic names 1 to 80 characters, per-server send and subscribe limits that scale with player count. Not guaranteed delivery or ordering.
- MemoryStore data is evicted on expiry and when the game is over quota; never use it as the only copy of anything a player paid for.
- Maximum 10 ongoing or upcoming events per experience on Creator Hub. Trending Events needs at least 1,000 RSVPs, a public event, and a start within the last 7 days.
- Event pages persist after the event ends; delete them if you reuse names.

## Sources

- https://create.roblox.com/docs/production/configs
- https://create.roblox.com/docs/production/experiments
- https://devforum.roblox.com/t/live-now-use-configs-and-experiments-to-grow-your-game-faster/4051385
- https://devforum.roblox.com/t/programmatically-update-configs-the-open-cloud-configs-api/4509549
- https://create.roblox.com/docs/production/promotion/experience-events
- https://create.roblox.com/docs/production/promotion/experience-notifications
- https://create.roblox.com/docs/resources/modules/event-sequencer
- https://create.roblox.com/docs/resources/feature-packages
- https://create.roblox.com/docs/production/game-design/liveops-essentials
- https://create.roblox.com/docs/production/game-design/liveops-planning
- https://create.roblox.com/docs/cloud-services/cross-server-messaging
- Data services: [data-services.md](data-services.md)
