# Templates and starters

Last verified: 2026-10-28

## Purpose

Answers: how to structure a Roblox project, how to set up Rojo and packages, which
official templates and open-source games are worth starting from or reading, and
how to vet anything inserted from the Creator Store.

## Top 5 picks

1. **Rojo 7** (https://rojo.space/docs/v7/, repo https://github.com/rojo-rbx/rojo). Syncs files on disk into Studio so code lives in git. MPL-2.0, v7.7.1, last commit 2026-10-05. Use it.
2. **Rokit** (https://github.com/rojo-rbx/rokit). Toolchain manager that pins versions of Rojo, Wally, Selene, StyLua per project (`rokit init`, `rokit add`, `rokit install`). MIT, 2026-09-27. Use it; Aftman says it is no longer maintained.
3. **Wally** (https://wally.run) for packages; **pesde** (https://pesde.dev) as the newer alternative. Use Wally unless a package is pesde-only.
4. **Official Roblox templates** (https://create.roblox.com/docs/resources/templates). Uncopylocked places: Platformer, Laser Tag, FPS System, Racing, Modern City, Village, UGC Homestore, Baseplate. Use them as starting places and reference.
5. **NevermoreEngine** (https://github.com/Quenty/NevermoreEngine). Large MIT collection of Luau packages maintained by Quenty; very active (2026-10-26). Use it as reading material and for individual packages.

## How it works

**Project layout.** Roblox runs code in three places: the server
(`ServerScriptService`, `ServerStorage`), each client (`StarterPlayerScripts`,
`StarterGui`), and shared modules both can require (`ReplicatedStorage`). A
Rojo project maps folders to those services in `default.project.json`, typically:

```
src/
  server/   -> ServerScriptService   (Scripts, server-only modules)
  client/   -> StarterPlayer.StarterPlayerScripts
  shared/   -> ReplicatedStorage.Shared   (types, config, pure logic)
Packages/   -> ReplicatedStorage.Packages (Wally output)
```

Put one entry Script on the server and one LocalScript on the client that require
modules; avoid dozens of independent Scripts. Put remotes in one place so they
are easy to audit. Files ending in `.server.luau` become Scripts, `.client.luau`
LocalScripts, plain `.luau` ModuleScripts.

**Rojo workflow.** `rojo serve` runs a sync server; the Studio plugin connects and
mirrors your files into the open place. `rojo build` produces a `.rbxl`/`.rbxm`
from files (used in CI). `rojo syncback` pulls instances from a place file back
into the project, which helps when migrating an existing Studio-only game. Maps,
terrain, and art usually stay in the place file; code and config go in git.

**Toolchain.** Rokit pins tool versions in `rokit.toml` so every machine and CI run
uses the same Rojo/Wally/StyLua/Selene. Selene lints Luau; StyLua formats it;
luau-lsp gives type checking and Roblox API autocomplete in VS Code. Wally reads
`wally.toml` and installs packages into `Packages/`.

**TypeScript option.** roblox-ts (https://github.com/roblox-ts/roblox-ts, MIT,
v3.0.0) compiles TypeScript to Luau. Large ecosystem, but a second language to
debug. Stick with Luau unless the team already lives in TypeScript.

**AI tooling.** Roblox publishes a Studio MCP server
(https://github.com/Roblox/studio-rust-mcp-server, MIT, last commit 2026-04-03) so
an assistant can inspect and edit an open place. Review every change it makes.

### Vetting Creator Store assets

Free models are the main source of backdoors. Roblox's store rules ban
obfuscation, `getfenv`/`setfenv`, and loading remote code (`require(assetId)`,
`loadstring`, `InsertService:LoadAsset`, `AssetService:LoadAssetAsync`,
`ModuleScript.LinkedSource`), but bad uploads still appear. Before inserting:

1. Prefer assets by Roblox or creators you can identify; check the creator's other uploads.
2. Insert into an empty place first. Open every Script, LocalScript, and ModuleScript, including ones hidden inside meshes, parts, and folders (search Explorer for `script`).
3. Search all scripts for `require(` with a number, `loadstring`, `getfenv`, `setfenv`, `LoadAsset`, `HttpService`, `MarketplaceService`, `TeleportService`, long encoded strings, and `string.char`/`\\x` escapes.
4. Check whether the model touches `game.Players`, gives admin, or creates RemoteEvents you did not expect.
5. Keep Studio's script-injection and HTTP settings off unless you need them.
6. If anything is unclear, delete the scripts and keep only the meshes/parts, or skip the asset.

Docs: https://create.roblox.com/docs/production/creator-store

## Gotchas

- **Knit** (https://github.com/Sleitnick/Knit) is archived. Do not start new projects on it; many YouTube tutorials still use it.
- **ProfileService** is unsupported; its README points to ProfileStore. See [../economy-tokens/README.md](../economy-tokens/README.md).
- **Aftman** is unmaintained (README banner); **Foreman** is older and still updated but Rokit is the Rojo team's tool. Migrate to Rokit.
- Roblox's official templates are uncopylocked places, not Rojo projects. Use `rojo syncback` or copy scripts out manually if you want them in git.
- Old open-source games such as Miner's Haven (https://github.com/berezaa/minershaven, Apache-2.0, last commit 2019-09-17) are useful to read for game design but use pre-2020 patterns and deprecated APIs. Do not copy code wholesale.
- `rojo serve` exposes a local port; only run it on trusted networks.
- Never commit `.ROBLOSECURITY` cookies, Open Cloud API keys, or `.env` files. Rojo and Wally do not need them for normal work; CI publishing uses Open Cloud keys stored as CI secrets.

## Sources

### More repos worth reading

| Name | URL | License | Last commit | Verdict |
|---|---|---|---|---|
| RbxUtil (Signal, Trove, Comm, etc.) | https://github.com/Sleitnick/RbxUtil | MIT | 2026-07-27 | Use it. Small, focused utilities; Signal 2.0.3 and Trove 1.8.0 on Wally. |
| Cmdr | https://github.com/evaera/Cmdr | MIT | 2026-10-10 | Use it for admin/debug commands with typed arguments. |
| Selene | https://github.com/Kampfkarren/selene | MPL-2.0 | 2026-10-01 | Use it. |
| StyLua | https://github.com/JohnnyMorganz/StyLua | MPL-2.0 | 2026-10-11 | Use it. |
| luau-lsp | https://github.com/JohnnyMorganz/luau-lsp | MIT | 2026-10-28 | Use it. |
| Luau language | https://github.com/luau-lang/luau | MIT | 2026-10-23 | Reference for language features and the type checker. |
| Roblox creator docs source | https://github.com/Roblox/creator-docs | CC-BY-4.0 prose, MIT code samples | 2026-10-27 | Use it. Grep `content/en-us/` for guides and `content/en-us/reference/engine/` for API YAML (deprecation flags included). |
| Aftman | https://github.com/LPGhatguy/aftman | MIT | 2025-07-09 | Skip; unmaintained. |
| Foreman | https://github.com/Roblox/foreman | MIT | 2026-05-01 | Use with caution; prefer Rokit. |

### Learning: YouTube

YouTube channel pages only returned their titles to this session, so upload
recency, subscriber counts, and content were not verified. Searches for "best
channels" lists returned SEO filler, so these are names repeatedly cited by the
community; check upload dates and whether a video uses Knit or Roact before
following it.

| Channel | URL | Verified | Verdict |
|---|---|---|---|
| GnomeCode | https://www.youtube.com/@GnomeCode | Channel exists | Use with caution. Project-based tutorials (unverified focus). |
| Suphi Kaner | https://www.youtube.com/@SuphiKaner | Channel exists | Use with caution. In-depth Luau and engine topics (unverified focus). |
| BrawlDev | https://www.youtube.com/@BrawlDevRBLX | Channel exists | Use with caution. Beginner scripting series (unverified focus). |

### Other

All URLs above, plus https://create.roblox.com/docs/projects/assets/packages for
Packages and https://github.com/topics/roblox for discovery.
