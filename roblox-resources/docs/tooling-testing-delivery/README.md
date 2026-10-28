---
topic: tooling-testing-delivery
summary: Which Studio plugins and tools to trust, how to test Luau, and how to build/publish with GitHub Actions, Rojo, and Open Cloud as a solo dev
keywords: Studio plugin, malicious plugin, backdoor, Hoarcekat, Flipbook, testing, unit test, Jest Roblox, TestEZ, jest-lua, Lune, Open Cloud, Luau Execution API, OCALE, place publishing API, universe-places, GitHub Actions, CI, CD, rojo build, rbxcloud, Mantle, API key, secrets, branching, staging place, version history
verified: 2026-10-28
---
# Tooling, testing, delivery
## Use this
- Jest Roblox: official Jest port used by Roblox; runs in Studio or CI via Luau Execution https://github.com/Roblox/jest-roblox [S373]
- Open Cloud Luau Execution API: run Luau inside a place from CI https://create.roblox.com/docs/cloud/reference/LuauExecutionSessionTask [S372]
- Place publishing API guide: publish a built place file with an API key https://create.roblox.com/docs/cloud/guides/usage-place-publishing [S371]
- Lune: standalone Luau runtime for build scripts and pure-logic tests https://github.com/lune-org/lune [S377]
- External tools guide: Roblox's own Rojo, Rokit, and Git workflow https://create.roblox.com/docs/projects/external-tools [S365]
## Concepts
- Toolchain (see templates docs): Rokit pins Rojo, Wally, Selene, StyLua; luau-lsp for type checking [S106][S104][S111][S112][S113].
- Testing layers:
  - Pure logic modules (damage math, schedules, migrations) tested outside Roblox with Lune, fast and CI-friendly [S377].
  - Engine-dependent code tested with Jest Roblox inside a place (Studio or Luau Execution API) [S373][S372].
  - Multi-client play tests in Studio for replication; network simulator for latency [S235][S236].
- Jest Roblox installs from Wally (`roblox/jest`) or the Creator Store; describe/it/expect API matches Jest 27 [S373][S374].
- CI pipeline (GitHub Actions):
  - Install tools via Rokit; run `stylua --check`, `selene`, luau-lsp analysis.
  - `rojo build -o game.rbxl`.
  - Upload to a test place and run Jest through the Luau Execution API; fail the job on test failures.
  - On tag or main merge, publish with the place publishing API to the live place [S371][S372].
- Open Cloud keys: create a key with `universe-places` write scope for the specific experience, store it as a GitHub Actions secret, never in the repo [S371][S370].
- rbxcloud wraps Open Cloud in a CLI for publishing and data store work; Mantle manages experiences as config files [S380][S381].
- Solo-dev branching: `main` always publishable; short feature branches; tag each release (`v0.4.2`) and write publish notes in Version History; keep a separate private staging experience and promote configs with "Publish As" [S368][S42].
- Studio CLI flags can open places, run scripts, and dump the API for tooling [S367].
- Plugins worth having: Rojo plugin, Flipbook or Hoarcekat for UI stories, Roblox's built-in tools (Tag editor, Script Profiler, Style Editor) before third-party ones [S104][S100][S382].
- Plugin vetting: plugins run with Studio permissions and can inject scripts into every place you open. Prefer open-source plugins built from GitHub releases; check the author, reviews, and source for `require(` with ids, `loadstring`, `getfenv`, `InsertService:LoadAsset` [S383][S384][S177].
## Gotchas
- TestEZ (2023-01-30) and run-in-roblox (2020-07-19) are unmaintained; use Jest Roblox and the Luau Execution API instead [S376][S379][S373].
- jsdotlua/jest-lua stopped at 2024-12-23; the Roblox repo is the maintained one [S375][S373].
- The place publishing API does not update `EditableImage`, `EditableMesh`, `PartOperation` (unions), `SurfaceAppearance`, or `BaseWrap` changes; publish from Studio after editing those [S371].
- A March 2026 report found a popular-looking plugin hiding a remote code loader that activates during play tests [S383].
- Mantle features that need a `.ROBLOSECURITY` cookie are a credential risk in CI; prefer Open Cloud keys [S381].
- Old posts quote a 4 MB place upload limit; unverified whether it still applies [S385].
- Team Create has age-based collaboration requirements [S369].
- Studio plugin publishing and selling rules: see the Studio plugins page [S366].
## Sources
S42, S100, S104, S106, S111, S112, S113, S177, S235, S236, S365, S366, S367, S368, S369, S370, S371, S372, S373, S374, S375, S376, S377, S378, S379, S380, S381, S382, S383, S384, S385
