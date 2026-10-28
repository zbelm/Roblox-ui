---
topic: architecture
summary: How to split client/server code, lay out modules, choose a framework or ECS, and type Luau
keywords: architecture, client, server, ModuleScript, RunContext, entry point, service, controller, single-script, Knit, Nevermore, Flamework, ECS, jecs, Matter, --!strict, type solver, UseNewLuauTypeSolver, LuauTypeCheckMode, export type, deferred events, SignalBehavior, Attributes, CollectionService
verified: 2026-10-28
---
# Architecture
## Use this
- Roblox script-location guide: one client and one server entry Script, everything else modules https://create.roblox.com/docs/scripting/locations [S205]
- Luau type checking: modes, generics, exported types https://create.roblox.com/docs/luau/type-checking [S208]
- jecs: fast typed ECS for many entities (projectiles, NPCs, mobs) https://github.com/Ukendio/jecs [S212]
- NevermoreEngine: maintained package collection to read for service patterns [S116]
- New type solver release notes: what changed in strict and nonstrict https://devforum.roblox.com/t/general-release-luau%E2%80%99s-new-type-solver/4084991 [S211]
## Concepts
- Three contexts: server (authoritative, sees everything), client (one per player, sees only replicated instances), shared modules required by both [S207].
- Roblox's recommendation: one `Script` with `RunContext = Server` in `ServerScriptService`, one with `RunContext = Client` in `ReplicatedStorage`; each requires modules and calls their `start()` [S205].
- Layout that matches it:
  - `ServerScriptService/Server` entry plus `ServerScriptService/Services/*` (data, combat, economy).
  - `ReplicatedStorage/Client` entry plus `ReplicatedStorage/Controllers/*` (input, UI, camera, effects).
  - `ReplicatedStorage/Shared/*` for types, constants, pure logic, remote definitions.
  - `ServerStorage` for assets and modules the client must never see.
- Service/controller pattern: each module exposes `init()` (set up state, no cross-calls) and `start()` (connect events, call other modules). The entry script requires all, runs every `init`, then every `start`. This is what Knit formalized; you do not need Knit to do it [S205][S103].
- Communication: modules call each other through required tables; client-server traffic only through a single remotes module (see networking docs) [S206].
- Tag-driven behavior: `CollectionService` tags plus a module per tag ("Door", "Coin") keep logic out of individual parts.
- Attributes hold replicated per-instance state (health, owner, level) readable by both sides [S210].
- ECS: entities are ids, components are plain data, systems are functions that query components each frame. Pays off with hundreds of similar objects; OOP modules are simpler for a few dozen [S212][S213].
- Typed Luau conventions: `--!strict` at the top of every file; `export type` shared shapes from `Shared/Types`; type remote payloads; narrow `Instance?` with `if not x then return end`; avoid `any` except at trust boundaries [S208].
- Type solver: since 2025-11-20 the new solver is default for nocheck/nonstrict; strict files stay on the old solver unless `Workspace.UseNewLuauTypeSolver` is Enabled. `Workspace.LuauTypeCheckMode` sets the per-place default [S211].
- Deferred signals: with `Workspace.SignalBehavior = Deferred`, handlers run at the next resumption point, not inside `Fire`; code that expects immediate side effects breaks. Server authority requires Deferred [S209].
## Gotchas
- Knit is archived; do not start new projects on it [S103].
- Matter has had no commits since 2024-07-16; prefer jecs for new ECS work [S214].
- Flamework is TypeScript (roblox-ts) only [S215].
- Circular `require` fails with "Requested module was required recursively"; break cycles with `init`/`start` [S206].
- `ReplicatedStorage` modules are readable by exploiters; keep secrets and server logic in `ServerScriptService`/`ServerStorage` [S207].
- The old type solver remains available only "through 2026" per the release post; plan to move strict code to the new solver [S211].
- jecs README recommends cloning the repo for docs; release `.rbxm` artifacts were missing after v0.5.1 per a 2025 thread (unverified: may be fixed) [S213].
## Sources
S103, S116, S205, S206, S207, S208, S209, S210, S211, S212, S213, S214, S215
