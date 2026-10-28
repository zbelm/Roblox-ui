---
topic: ui
summary: Which UI library or UI tool to use, maintenance status, and what is deprecated
keywords: React Luau, roblox/react, react-lua, jsdotlua, Roact, Fusion, Vide, Iris, Signals, Charm, Ripple, Synthetic, rbx-css, Flipbook, Rojo, Wally, pesde, luau-lsp, deprecated, maintained
verified: 2026-10-28
---
# UI libraries and tooling
## Use this
- React Luau: official Roblox package; Wally `roblox/react`, `roblox/react-roblox` 17.3.13 [S85][S86]
- Fusion: reactive state with `scope:Value`, `scope:Computed`, `scope:New`; built-in Tween and Spring [S89][S90]
- Vide: minimal reactive library, very active, pre-1.0 https://github.com/centau/vide [S91][S92]
- Iris: immediate-mode debug and admin panels, not player UI https://github.com/SirMallard/Iris [S93][S94]
- Charm: shared atom-style state usable with React or Vide https://github.com/littensy/charm [S96]
## Concepts
- Last-commit dates read from git remotes on 2026-10-28; Wally versions from the wally-index repo the same day [S102].
- Pick by need:
  - Big stateful UI, team knows React: React Luau [S85].
  - Smaller Roblox-native API: Fusion 0.3 (`elttob/fusion`) [S89].
  - Minimal reactive core: Vide (`centau/vide`, 0.4.1) [S91].
  - Debug panels: Iris (`sirmallard/iris`, 2.5.1) [S93].
  - Small game: plain instances plus UI Styling.
- Library status:
  - React Luau: MIT, last commit 2026-10-13, Creator Store build linked from README; use [S85].
  - react-lua (jsdotlua fork): MIT, 2024-12-04, Wally `jsdotlua/react` 17.2.1; still a dependency of `roblox/signals` 0.9.0; caution [S87].
  - Roact: Apache-2.0, 2023-12-12, deprecated per README; skip [S88].
  - Fusion: MIT, 2026-02-01, tags still `v0.3-beta`, activity slowed; use [S89].
  - Vide: MIT, 2026-10-26, expect API changes; use [S91].
  - Iris: MIT, 2026-10-19; use for dev tools [S93].
  - Signals (Roblox): MIT, 2026-10-27, Community Contributions program, 0.9.0; caution [S95].
  - Charm: MIT, 2026-09-30; use [S96]. Ripple: MIT, 2026-03-19, spring/tween motion values; use [S97].
  - Synthetic: Apache-2.0, 2024-08-01, Material Design on old Fusion/Roact; skip [S98].
  - rbx-css: MIT, 2026-09-08, compiles CSS tokens to StyleSheets, single maintainer; caution [S99].
- Tooling:
  - Flipbook: MIT, 2026-10-04; install from the README's Creator Store link or releases [S100][S101].
  - Rojo: MPL-2.0, v7.7.1 (2026-10-05); see templates [S105].
  - Wally: MPL-2.0, 2026-10-12; package pages render client-side, check versions via CLI or index [S107][S102].
  - pesde: MIT, 2026-10-26; smaller Roblox catalog than Wally; caution [S108].
  - luau-lsp: MIT, 2026-10-28; type checking and autocomplete outside Studio [S113].
- React Luau re-renders component functions and diffs, suiting screens with conditional structure; Fusion binds individual properties to state, lighter and closer to plain Roblox code. Either works for a first game; do not mix them in one UI tree [S85][S89].
- Roblox libraries can publish to Wally under `roblox/` since 2026-04-09 [S70].
## Gotchas
- The 2024 "How To: React + Roblox" guide still recommends `jsdotlua/react` [S69].
- Script-hub UI libraries (WindUI and similar) are built for exploit executors; skip them.
- flipbook-labs.com was unreachable (DNS) from the research session [S101].
## Sources
S69, S70, S85, S86, S87, S88, S89, S90, S91, S92, S93, S94, S95, S96, S97, S98, S99, S100, S101, S102, S105, S107, S108, S113
