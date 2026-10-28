---
topic: events
summary: Which data service fits an event need (DataStore, configs, MemoryStore, MessagingService, secrets) and their documented limits
keywords: DataStore, MemoryStore, sorted map, hash map, queue, MessagingService, ConfigService, configs, secrets store, HttpService:GetSecret, limits, quota, request budget, session locking, ProfileStore, ProfileService, Lapis
verified: 2026-10-28
---
# Data services for events
## Use this
- Data stores vs memory stores: Roblox's comparison of when to use each https://create.roblox.com/docs/cloud-services/data-stores-vs-memory-stores [S54]
- Memory stores: quotas, structures, best practices https://create.roblox.com/docs/cloud-services/memory-stores [S55]
- Cross-server messaging: MessagingService usage and limits https://create.roblox.com/docs/cloud-services/cross-server-messaging [S50]
- ProfileStore: session-locked player data (see data-persistence) [S131]
- Configs: live values, limits, testing [S42]
## Concepts
- Numbers from Roblox/creator-docs commit 02c23e6 (2026-10-27); re-check before designing around a limit.
- Which service [S54]:
  - Player progress, purchases, owned event items: DataStore via ProfileStore or your own session-locked wrapper (persistent, versioned).
  - Event flags, dates, multipliers, prices: Configs (live, read-only in game).
  - Global counters, cross-server leaderboards, matchmaking queues: MemoryStore (fast, shared, expiring).
  - "Do this now in every server": MessagingService (seconds, best effort).
  - API keys for external services: secrets store via `HttpService:GetSecret`.
- DataStore [S51][S52][S53][S56]:
  - 4,194,304 characters per value; storage cap 500 MB + 1 MB x lifetime users.
  - Many request budgets are 60 + 40 x players per minute.
  - Best practices: few stores, one or few keys per player, buffer in memory, stagger saves, retry transient failures, prefer `UpdateAsync` over `SetAsync`.
  - Session locking stops two servers writing the same player and is the main dupe defense.
- MemoryStore [S55]:
  - Memory quota 64 KB + 1.2 KB x concurrent users; drops 8 days after players leave.
  - Request units 1000 + 120 x concurrent users per minute; range reads cost one unit per returned item.
  - One sorted map or queue: up to 1,000,000 items and 100 MB.
  - Sorted map for ordered data (leaderboards, auctions); hash map for keyed access and many keys; queue for in-order processing (matchmaking).
- MessagingService: 1 kB per message; topics 1-80 characters; send 600 + 240 x players per minute per server; receive per topic 40 + 80 x servers per minute; subscriptions 20 + 8 x players; best effort [S50].
- Configs: up to 1,000 active; string/JSON up to 100,000 characters; 100 conditions per game, 20 per key; staged then published; `ConfigService:SetTestingValue` overrides on one server [S42].
- Open Cloud Configs API manages configs from CI or tools; keep the key as a CI secret [S80].
- Libraries:
  - ProfileStore: Apache-2.0, 2025-07-31; session locking, auto-save, `Profile:Reconcile()`; not for global state or leaderboards; install from its Creator Store link or repo, no official Wally package; use [S131].
  - ProfileStore thread (2024-10-11): `ProfileStore.New`, `StartSessionAsync`, `EndSession`, `MessageAsync` [S82].
  - ProfileService: Apache-2.0, 2024-10-13, unsupported; skip [S132].
  - Lapis: MIT, 2025-02-11, quieter since early 2025; caution [S133].
  - Session locking explained (older thread): background reading [S83].
## Gotchas
- No API lists all config keys [S81].
- MemoryStore data expires; never the only copy of paid items [S55].
- Never put Open Cloud keys in the repo [S80].
## Sources
S42, S50, S51, S52, S53, S54, S55, S56, S80, S81, S82, S83, S131, S132, S133
