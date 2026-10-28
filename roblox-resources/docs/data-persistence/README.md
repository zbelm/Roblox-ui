---
topic: data-persistence
summary: How to save player data safely: DataStore limits, session locking, libraries, migration, failed saves
keywords: DataStoreService, GlobalDataStore, UpdateAsync, SetAsync, GetAsync, BindToClose, session lock, ProfileStore, DocumentService, Lapis, DataStore2, schema version, migration, retry, backoff, UseCache, RTBF
verified: 2026-10-28
---
# Data persistence
## Use this
- ProfileStore: session locking plus autosave; default choice for player profiles [S131]
- DocumentService: strictly typed, migrations, Result errors, optional session lock https://github.com/anthony0br/DocumentService [S167]
- Data store best practices: Roblox's own rules for keys, retries, sharding, lifecycle [S52]
- Caching and serialization rules: 4 s `GetAsync` cache, JSON types, versions https://create.roblox.com/docs/cloud-services/data-stores/versioning-listing-and-caching [S161]
- Data Stores Manager: inspect, edit, delete keys without code https://create.roblox.com/docs/cloud-services/data-stores/data-stores-manager [S162]
## Concepts
- Load once on join, keep data in server memory, write on leave, on an autosave interval, and right after purchases [S52][S56].
- Store one table per player under one key (`Player_<UserId>`); fewer data stores and static key patterns are cheaper and easier to delete [S52].
- `UpdateAsync` reads the latest value and writes in one transform; return `nil` from the transform to cancel. Prefer it over `SetAsync` [S52][S165].
- Session lock: a server marks the profile as owned (in the value or in MemoryStore) so a second server refuses to load or write until the first releases or the lock expires. Prevents rollback and item duplication when players hop servers [S83][S131].
- ProfileStore keeps its lock in the DataStore value; Suphi's module locks in MemoryStore [S169]. Both approaches are valid; pick one library and do not mix.
- Schema versioning: store `version` in the table; on load, run migrations in order (`v1 -> v2 -> v3`) before use; never load newer data with older code. DocumentService and Lapis have migration hooks [S167][S133].
- Defaults: fill missing fields from a template on load (ProfileStore `Profile:Reconcile()`) [S82].
- Failed load: kick or hold the player in a "data not loaded" state. Never let them play on default data that will later overwrite real data [S56].
- Failed save: retry with exponential backoff and jitter; keep data in memory; log and alert through observability [S52][S163].
- Shutdown: on server close the engine waits up to 30 s for `game:BindToClose` callbacks; flush all profiles in parallel there [S166].
- Versions: each write creates a version; only the latest counts toward storage. `ListVersionsAsync`/`GetVersionAsync` restore after bad writes [S161][S52].
- Hot shared keys (global config read by every server): shard into copies with jittered polling, or use configs/MemoryStore instead [S52].
- Bulk repair or deletion: Open Cloud data store APIs or Roblox's batch processor CLI; they share the game's request budget [S52][S171].
- Right to be forgotten: set up automated RTBF deletion templates for static key patterns [S164].
- Snippets: `snippets/data-update-retry.luau`, `snippets/data-schema-migrate.luau`.
## Gotchas
- Limits: 4,194,304 characters per value; per-key throughput is measured over a rolling 60 s window [S53].
- `GetAsync` caches for 4 s per data store object; pass `DataStoreGetOptions` with `UseCache = false` to verify a write [S161].
- Only JSON-safe types serialize: nil, booleans, numbers, strings, tables, buffers. No Instances, `Vector3`, `Color3`, `CFrame`; `inf`/`nan` break JSON [S161].
- Numeric keys become strings when the table has length 0 (sparse or dictionary-style numeric keys) [S161].
- `GlobalDataStore:OnUpdate` and `DataStore:RemoveVersionAsync` are deprecated in the API reference [S165].
- `GlobalDataStore:BatchGetAsync` exists but only works on `OrderedDataStore`; it errors on normal stores [S165].
- Studio needs "Enable Studio Access to API Services"; it uses the same data stores as live servers, so test in a separate place [S51].
- DataStore2 is legacy per Roblox's docs; migrate with Roblox's beta DataStore2 migration tool linked from best practices [S52][S170].
- ProfileService is unsupported; ProfileStore reads ProfileService data per community reports (unverified: not tested) [S132].
- Suphi's module is officially distributed as `require(11671168253)`, a remote asset require; insert a reviewed copy instead [S169].
- Deleted data stores can be restored for 30 days, then are gone [S52].
- Open Cloud scripts and live servers share one request budget; rate-limit maintenance jobs [S52].
## Sources
S51, S52, S53, S56, S82, S83, S131, S132, S133, S161, S162, S163, S164, S165, S166, S167, S168, S169, S170, S171
