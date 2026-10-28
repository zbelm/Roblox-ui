# UI libraries and tooling

Last verified: 2026-10-28

Back to [README.md](README.md). Dates are the last commit on the default branch,
read from the git remote on 2026-10-28. Wally versions come from the
`UpliftGames/wally-index` registry repo the same day.

## Pick one

| Need | Pick | Why |
|---|---|---|
| Big stateful UI, team knows React | React Luau (`roblox/react`) | Official Roblox package, maintained, Wally and Creator Store builds |
| Smaller API, Roblox-native feel | Fusion 0.3 (`elttob/fusion`) | Reactive state with `scope:Value`, `scope:Computed`, `scope:New`; built-in Tween and Spring |
| Minimal reactive library | Vide (`centau/vide`) | Very active, small, MIT |
| Debug panels, admin tools | Iris (`sirmallard/iris`) | Immediate-mode (Dear ImGui style); not meant for player-facing UI |
| No library | Plain instances + UI Styling | Fine for small games; StyleSheets now cover theming |

## Libraries

| Name | URL | License | Last commit | Verdict |
|---|---|---|---|---|
| React Luau (official) | https://github.com/Roblox/react-luau | MIT | 2026-10-13 | Use it. Wally `roblox/react` and `roblox/react-roblox` 17.3.13. Docs: https://www.react-luau.dev. Creator Store build linked from its README. |
| react-lua (jsdotlua fork) | https://github.com/jsdotlua/react-lua | MIT | 2024-12-04 | Use with caution. Was the community default; now stale. Wally `jsdotlua/react` 17.2.1. Still a transitive dependency of some packages (for example `roblox/signals` 0.9.0 depends on `jsdotlua/react`). |
| Roact (legacy) | https://github.com/Roblox/roact | Apache-2.0 | 2023-12-12 | Skip. README says deprecated and no longer maintained. |
| Fusion | https://github.com/dphfox/Fusion | MIT | 2026-02-01 | Use it. Docs: https://elttob.uk/Fusion/0.3/. Version tags are still labelled beta (`v0.3-beta`); activity has slowed in 2026. |
| Vide | https://github.com/centau/vide | MIT | 2026-10-26 | Use it. Docs: https://centau.github.io/vide/. Pre-1.0 (0.4.1 on Wally), expect API changes. |
| Iris | https://github.com/SirMallard/Iris | MIT | 2026-10-19 | Use it for dev tools. Docs: https://sirmallard.github.io/Iris/. Wally 2.5.1. |
| Signals (Roblox) | https://github.com/Roblox/signals | MIT | 2026-10-27 | Use with caution. Reactive primitives from Roblox's Community Contributions program; 0.9.0, pre-1.0. |
| Charm | https://github.com/littensy/charm | MIT | 2026-09-30 | Use it for shared atom-style state that works with React or Vide. |
| Ripple | https://github.com/littensy/ripple | MIT | 2026-03-19 | Use it for spring/tween motion values. |
| Synthetic | https://github.com/nightcycle/synthetic | Apache-2.0 | 2024-08-01 | Skip for new work. Material Design on Fusion; stale and depends on old Fusion/Roact. |
| rbx-css | https://github.com/AlroviOfficial/rbx-css | MIT | 2026-09-08 | Use with caution. Compiles CSS-style tokens to Roblox StyleSheets; small single-maintainer project. |

Script-hub UI libraries (WindUI and similar) that show up in searches are built
for exploit executors, not games. Skip them.

## Tooling around UI

| Name | URL | License | Last commit | Verdict |
|---|---|---|---|---|
| Flipbook (storybook plugin) | https://github.com/flipbook-labs/flipbook | MIT | 2026-10-04 | Use it. Install from the Creator Store link in the README or GitHub releases. Docs: https://flipbook-labs.github.io/flipbook/. `flipbook-labs.com` was unreachable (DNS blocked in this session). |
| Rojo | https://rojo.space/docs/v7/ | MPL-2.0 | 2026-10-05 (v7.7.1) | Use it. See [../templates/README.md](../templates/README.md). |
| Wally | https://wally.run | MPL-2.0 | 2026-10-12 | Use it. Main Roblox package registry. Package pages render client-side, so check versions in the CLI or the index repo. |
| pesde | https://pesde.dev | MIT | 2026-10-26 | Use with caution. Newer Luau package manager supporting Roblox and Lune; smaller Roblox package catalog than Wally. |
| luau-lsp | https://github.com/JohnnyMorganz/luau-lsp | MIT | 2026-10-28 | Use it. Type checking and autocomplete for Roblox APIs outside Studio. |

## Choosing between React Luau and Fusion

Both create real Roblox instances. React Luau re-renders a component function
when state or props change and diffs the result, which suits screens with lots
of conditional structure (shop tabs, filtered inventories). Fusion binds
individual properties to state objects, so only the bound properties update,
which is lighter and reads closer to plain Roblox code. React Luau has more
learning material from the JS world; Fusion's docs are written for Roblox
developers. For a first game, either works; avoid mixing them in one UI tree.

## Sources

All URLs in the tables above, plus:
- https://devforum.roblox.com/t/how-to-react-roblox/2964543 (2024 guide; still recommends `jsdotlua/react`, now outdated on that point)
- https://devforum.roblox.com/t/evolving-luau-oss-community-contributions-more/4566806 (2026-04-09: Roblox libraries can publish to Wally under `roblox/`)
- https://github.com/UpliftGames/wally-index
