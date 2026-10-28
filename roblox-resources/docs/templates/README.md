---
topic: templates
summary: How to structure a Roblox project, set up Rojo and packages, pick templates or open-source code to read, and vet Creator Store assets
keywords: Rojo, rojo serve, rojo build, rojo syncback, default.project.json, Rokit, rokit.toml, Wally, wally.toml, pesde, Selene, StyLua, luau-lsp, roblox-ts, templates, NevermoreEngine, RbxUtil, Cmdr, Knit, Aftman, Foreman, backdoor, Creator Store, vetting, YouTube
verified: 2026-10-28
---
# Templates and starters
## Use this
- Rojo 7 (MPL-2.0, v7.7.1): sync files into Studio so code lives in git https://rojo.space/docs/v7/ [S105][S104]
- Rokit (MIT): pins Rojo, Wally, Selene, StyLua per project https://github.com/rojo-rbx/rokit [S106]
- Wally for packages; pesde as newer alternative https://wally.run [S107][S108]
- Official Roblox templates: uncopylocked starter places to start from or read [S32]
- NevermoreEngine (MIT): large, very active package collection to read [S116]
## Concepts
- Code runs on the server (`ServerScriptService`, `ServerStorage`), each client (`StarterPlayerScripts`, `StarterGui`), and in shared modules (`ReplicatedStorage`) [S105].
- Typical `default.project.json` mapping:
```
src/
  server/   -> ServerScriptService
  client/   -> StarterPlayer.StarterPlayerScripts
  shared/   -> ReplicatedStorage.Shared
Packages/   -> ReplicatedStorage.Packages (Wally output)
```
- One entry Script on the server and one LocalScript on the client requiring modules; remotes in one place for auditing.
- File suffixes: `.server.luau` -> Script, `.client.luau` -> LocalScript, `.luau` -> ModuleScript [S105].
- Rojo workflow: `rojo serve` plus the Studio plugin mirrors files; `rojo build` makes `.rbxl`/`.rbxm` for CI; `rojo syncback` pulls a place file back into the project. Maps, terrain, art stay in the place file; code and config in git [S104][S105].
- Toolchain: `rokit init`, `rokit add`, `rokit install` pin versions in `rokit.toml`; Selene lints, StyLua formats, luau-lsp type-checks; Wally installs to `Packages/` from `wally.toml` [S106][S111][S112][S113][S107].
- Templates: Platformer, Laser Tag, FPS System, Racing, Modern City, Village, UGC Homestore, Baseplate [S32]. Packages keep shared parts in sync [S33].
- roblox-ts (MIT, v3.0.0) compiles TypeScript to Luau; a second language to debug, use only if the team already uses TypeScript [S115].
- Roblox's Studio MCP server (MIT, 2026-04-03) lets an assistant inspect and edit a place; review every change [S119].
- Vetting Creator Store assets (Roblox bans obfuscation, `getfenv`/`setfenv`, `require(assetId)`, `loadstring`, `InsertService:LoadAsset`, `AssetService:LoadAssetAsync`, `ModuleScript.LinkedSource`, yet bad uploads still appear) [S34]:
  - Prefer Roblox or identifiable creators; check their other uploads.
  - Insert into an empty place; open every script, including those hidden in meshes, parts, folders.
  - Search for numeric `require(`, `loadstring`, `getfenv`, `setfenv`, `LoadAsset`, `HttpService`, `MarketplaceService`, `TeleportService`, long encoded strings, `string.char`/`\x` escapes.
  - Check for touching `game.Players`, granting admin, or unexpected RemoteEvents.
  - Keep script injection and HTTP settings off unless needed.
  - If unclear, delete scripts and keep only meshes/parts, or skip the asset.
- Repos worth reading:
  - RbxUtil: MIT, 2026-07-27, Signal 2.0.3 and Trove 1.8.0 on Wally; use [S117].
  - Cmdr: MIT, 2026-10-10, typed admin/debug commands; use [S118].
  - Selene (MPL-2.0, 2026-10-01), StyLua (MPL-2.0, 2026-10-11), luau-lsp (MIT, 2026-10-28); use [S111][S112][S113].
  - Luau language repo: MIT, 2026-10-23; language and type checker reference [S114].
  - Roblox creator docs source: CC-BY-4.0 prose, MIT code, 2026-10-27; grep `content/en-us/` and `content/en-us/reference/engine/` (deprecation flags) [S120].
  - Foreman: MIT, 2026-05-01; caution, prefer Rokit [S110].
  - Discovery: GitHub roblox topic [S122].
- YouTube (channel pages showed only titles, so recency and focus are unverified; "best channels" searches returned SEO filler):
  - GnomeCode: project-based tutorials (unverified focus); caution [S123].
  - Suphi Kaner: in-depth Luau and engine topics (unverified focus); caution [S124].
  - BrawlDev: beginner scripting series (unverified focus); caution [S125].
## Gotchas
- Knit is archived; many YouTube tutorials still use it [S103].
- ProfileService is unsupported; its README points to ProfileStore (see data-persistence).
- Aftman is unmaintained (MIT, 2025-07-09); Foreman is older; migrate to Rokit [S109][S110].
- Official templates are places, not Rojo projects; use `rojo syncback` or copy scripts out [S32].
- Miner's Haven (Apache-2.0, 2019-09-17) is good design reading but uses pre-2020 patterns and deprecated APIs [S121].
- `rojo serve` exposes a local port; only on trusted networks.
- Never commit `.ROBLOSECURITY` cookies, Open Cloud keys, or `.env` files; CI publishing uses keys stored as CI secrets.
- Check video upload dates and whether a tutorial uses Knit or Roact before following it.
## Sources
S32, S33, S34, S103, S104, S105, S106, S107, S108, S109, S110, S111, S112, S113, S114, S115, S116, S117, S118, S119, S120, S121, S122, S123, S124, S125
