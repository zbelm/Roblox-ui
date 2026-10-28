# Data services for events: which store, which limits

Last verified: 2026-10-28

Back to [README.md](README.md). Numbers below are from the Roblox creator docs
source (Roblox/creator-docs, commit 02c23e6, 2026-10-27). They change; re-check
before designing around a limit.

## Which service

| Need | Use | Why |
|---|---|---|
| Player progress, purchases, owned event items | DataStore (through ProfileStore or your own session-locked wrapper) | Persistent, versioned |
| Event on/off flags, dates, multipliers, prices | Configs (`ConfigService`) | Change live without publishing; read-only in game |
| Global counters, cross-server leaderboards, matchmaking queues | MemoryStore (sorted map, hash map, queue) | Fast and shared, but expiring |
| "Do this now in every server" | MessagingService | Push within seconds, best effort |
| API keys for external services | Secrets store (`HttpService:GetSecret`) | Keeps keys out of code |

Roblox's own comparison page: https://create.roblox.com/docs/cloud-services/data-stores-vs-memory-stores

## DataStore

- Value size: 4,194,304 characters per key. Storage cap per game: 500 MB + 1 MB x lifetime users.
- Request budgets scale with players (many operations are 60 + 40 x players per minute).
- Best practices from the docs: few data stores, one or few keys per player, buffer data in memory, stagger saves, retry transient failures, prefer `UpdateAsync` over `SetAsync`.
- Session locking stops two servers writing the same player and is the main defense against item duplication. ProfileStore implements it.
- Docs: https://create.roblox.com/docs/cloud-services/data-stores, https://create.roblox.com/docs/cloud-services/data-stores/best-practices, https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits
- Roblox's reference player-data and purchase-handling design (retries, session locking, atomic purchases): https://create.roblox.com/docs/cloud-services/data-stores/player-data-purchasing

## MemoryStore

- Memory quota per game: 64 KB + 1.2 KB x concurrent users; drops 8 days after players leave.
- Request units: 1000 + 120 x concurrent users per minute; range reads cost one unit per returned item.
- One sorted map or queue: up to 1,000,000 items and 100 MB.
- Pick: sorted map when order matters (leaderboards, auctions), hash map for keyed access and large key counts, queue for processing in order (matchmaking).
- Docs: https://create.roblox.com/docs/cloud-services/memory-stores

## MessagingService

- 1 kB per message; topics 1 to 80 characters.
- Send: 600 + 240 x players-in-server per minute per server. Receive per topic: 40 + 80 x servers per minute. Subscriptions per server: 20 + 8 x players.
- Delivery is best effort, not guaranteed.
- Docs: https://create.roblox.com/docs/cloud-services/cross-server-messaging

## Configs

- Up to 1,000 active configs; string/JSON values up to 100,000 characters; up to 100 conditions per game and 20 per key.
- Staged first (testable in Studio), then published. `ConfigService:SetTestingValue` overrides a value on one server for testing.
- Manage from CI or tools with the Open Cloud Configs API (https://devforum.roblox.com/t/programmatically-update-configs-the-open-cloud-configs-api/4509549). Store the API key as a CI secret, never in the repo.
- No API to list all keys: https://devforum.roblox.com/t/configservice-should-support-listing-all-config-keys-in-an-experience/4165920
- Docs: https://create.roblox.com/docs/production/configs

## ProfileStore

| Name | URL | License | Updated | Verdict |
|---|---|---|---|---|
| ProfileStore | https://github.com/MadStudioRoblox/ProfileStore | Apache-2.0 | Last commit 2025-07-31 | Use it for player data. Session locking, auto-save, `Profile:Reconcile()` for new fields. Not designed for global state or leaderboards. Install from its Creator Store link or the repo; there is no official Wally package from the author. |
| ProfileStore DevForum thread | https://devforum.roblox.com/t/profilestore-save-your-player-data-easy-datastore-module/3190543 | n/a | Posted 2024-10-11 | Use it for API overview (`ProfileStore.New`, `StartSessionAsync`, `EndSession`, `MessageAsync`). |
| ProfileService | https://github.com/MadStudioRoblox/ProfileService | Apache-2.0 | 2024-10-13 | Skip for new work; README says no longer supported, migrate to ProfileStore. |
| Lapis | https://github.com/nezuo/lapis | MIT | 2025-02-11 | Use with caution. Alternative session-locking DataStore library; quieter since early 2025. |
| Session locking explained (DevForum) | https://devforum.roblox.com/t/session-locking-explained-datastore/846799 | n/a | Older thread | Use it as background reading. |
