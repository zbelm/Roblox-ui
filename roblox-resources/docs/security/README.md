---
topic: security
summary: How to keep a Roblox game server-authoritative and validate, rate-limit, and detect abuse (defensive only)
keywords: exploit, cheat, RemoteEvent, RemoteFunction, OnServerEvent, OnServerInvoke, validation, typeof, math.isfinite, NaN, utf8.len, rate limit, token bucket, network ownership, SetNetworkOwner, honeypot, backdoor, Sandboxed, Capabilities, IntegrityService, DeviceTrustLevel, AuthorityMode, server authority
verified: 2026-10-28
---
# Security
## Use this
- Client-server boundary guide: validation layers, NaN trap, token bucket rate limiter https://create.roblox.com/docs/scripting/security/client-server-boundary [S173]
- Security tactics: never trust the client; server is source of truth https://create.roblox.com/docs/scripting/security/security-tactics [S172]
- Server-side detection: heuristics, honeypots, proportional reversible consequences https://create.roblox.com/docs/scripting/security/server-side-detection [S174]
- Server authority model: server-simulated state with client prediction; opt-in, released 2026-07-09 https://create.roblox.com/docs/projects/server-authority [S180]
- `t` library: declarative runtime type checks for remote arguments https://github.com/osyrisrblx/t [S185]
## Concepts
- Threat model: an exploiter controls their client fully. They can fire any remote with any arguments, read everything replicated to them (including decompiled LocalScripts and ModuleScripts in ReplicatedStorage), and edit local properties [S172][S176].
- Server owns state: currency, inventory, health, cooldowns, prices, and progression live on the server; clients send intent ("use ability 3"), never results ("I dealt 50 damage") [S172].
- Validate every remote in layers [S173]:
  - Type and structure: `typeof` each argument; reject tables where an `Instance` is expected; cap string length and table size.
  - Value: reject `inf` and `NaN` with `math.isfinite`; NaN fails every comparison and slips past `<`/`>` checks.
  - Context and permission: is the player alive, close enough, owner of the item, allowed in this game state.
- Rate-limit anything a client can trigger: remotes, `Touched`, `ProximityPrompt`, `ClickDetector`. Roblox's guide uses a per-player token bucket [S173].
- Strings headed for DataStores must be valid UTF-8 (`utf8.len` returns nil otherwise) and length-capped; client tables need key validation [S173].
- Trades and multi-player changes: validate all sides, then commit; revert everything on any failure [S173].
- Network ownership: a client that owns its character or a part can teleport it, change speed, fling, and fake `Touched`. Validate movement on the server (distance per tick) and call `SetNetworkOwner(nil)` on gameplay-critical unanchored parts [S175].
- Detection after validation: heuristics such as impossible completion times or gains; honeypot remotes nothing legitimate calls; consequences should neutralize first (rubber-band, revert) and ban last [S174].
- Design out cheats: remove the reward an exploit would farm (no points for killing freshly spawned players) [S178].
- Subplaces: clients can teleport to any place in the universe. Set Access Control to "Secure within universe only" and keep test places in a separate private universe [S176].
- Third-party assets: sandbox inserted models (`Workspace.SandboxedInstance`, model `Sandboxed = true`, minimal `Capabilities`); do not grant Network, DataStore, AssetRequire, or LoadString to unknown code [S177][S187].
- Device trust: `IntegrityService.EvaluatePlayerDeviceTrust` and `Player.DeviceTrustLevel` (`Pending`, `Unknown`, `None`, `Standard`, `Full`) rate the device, not the player; use for matchmaking or gating trading, never as the only defense [S179].
- Server authority: set `Workspace.AuthorityMode = Server`; this enables `NextGenerationReplication`, `StreamingEnabled`, `UseFixedSimulation`, deferred signals, and input actions. Keep rollback-relevant state in Attributes, not Luau variables [S180][S182].
- Snippet: `snippets/security-remote-guard.luau` (type checks plus token bucket around `OnServerEvent`).
## Gotchas
- Keys, passwords, or renamed remotes do not secure anything; exploiters read scripts and spy on remote traffic [S184].
- Client-side anti-cheat can be deleted or spoofed; never ban from client reports alone [S174].
- Server-to-client `InvokeClient` yields forever if the client never returns; avoid it [S188].
- Kicking from a restricted place does not stop already-replicated content from leaking [S176].
- Disabling "Direct Access" on a subplace only hides the website Join button [S176].
- Device trust covers only Android, Chromebook, and Meta Quest as of 2026-10-28; web reports `None`, others `Unknown`. `Unknown` does not mean untrusted [S179].
- Script capabilities and sandboxing are still beta; some features error with "lacking Capability Unassigned" [S177].
- Server authority costs more server CPU; remote events are not synchronized with the shared timeline; 64 attributes per instance; 8 active animation tracks per Animator [S182].
- Server authority beta posts describe older behavior; check the release post first [S183].
- Admin systems (for example Adonis) add a large privileged surface; restrict admin lists and review loaded plugins [S186].
## Sources
S172, S173, S174, S175, S176, S177, S178, S179, S180, S181, S182, S183, S184, S185, S186, S187, S188
