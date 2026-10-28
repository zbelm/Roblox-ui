# Roblox resource library

Last verified: 2026-10-28

Links, licenses, and short explanations for building a Roblox game, checked live on
2026-10-28. Seven topic folders under [docs/](docs/), a master list in
[sources/sources.csv](sources/sources.csv) (160 URLs, each with license and
verdict), and small Luau examples in [snippets/](snippets/).

| Topic | Start here |
|---|---|
| UI / GUI | [docs/ui/README.md](docs/ui/README.md) |
| Textures, materials, icons, fonts | [docs/textures/README.md](docs/textures/README.md) |
| Maps and environments | [docs/maps/README.md](docs/maps/README.md) |
| Templates and starters | [docs/templates/README.md](docs/templates/README.md) |
| Weather and atmosphere | [docs/weather/README.md](docs/weather/README.md) |
| Events | [docs/events/README.md](docs/events/README.md) |
| Design tokens and economy | [docs/economy-tokens/README.md](docs/economy-tokens/README.md) |

## What changed recently (worth knowing before you build)

- **UI Styling** (StyleSheets, tokens, themes, Style Editor) left beta in January 2026. Theming no longer needs a library.
- **React Luau** is now published by Roblox on Wally as `roblox/react` (17.3.13). The old community fork `jsdotlua/react` has been idle since December 2024; Roact is deprecated; Knit is archived.
- **Experience configs** (`ConfigService`, November 2025) turn events and tuning values on and off live, without a publish.
- **`MarketplaceService:BindReceiptHandler`** is a newer, per-product alternative to `ProcessReceipt`.
- **Custom terrain materials** (Expanded Terrain, up to 62 materials) left Early Access in October 2026. Terrain scattering and path splines are announced but not shipped.
- `Lighting.Technology`, `GuiObject:TweenPosition`/`TweenSize`, and `MarketplaceService:GetProductInfo` are deprecated.

## What to build first

1. **Project skeleton.** Rojo 7 + Rokit + Wally, `src/server`, `src/client`, `src/shared`, luau-lsp, Selene, StyLua. Keep code in git from day one. ([templates](docs/templates/README.md))
2. **Player data and currency, before any UI.** ProfileStore for session-locked saves, one server ledger module for every coin change ([snippets/economy-currency-ledger.luau](snippets/economy-currency-ledger.luau)), and an idempotent receipt handler for Robux packs ([snippets/economy-receipt-handler.luau](snippets/economy-receipt-handler.luau)). Exploits and lost purchases are the hardest things to fix later.
3. **UI shell with tokens.** One token StyleSheet with light/dark themes ([snippets/ui-stylesheet-theme.luau](snippets/ui-stylesheet-theme.luau)), a root `UIScale`, a HUD showing the server-replicated balance, and one shop menu using the tween panel. Pick React Luau or Fusion only once the shop and inventory need real state.
4. **Environment pass.** A day/night cycle computed from server time and a few weather presets ([weather](docs/weather/README.md)). Cheap, and it makes greybox maps feel finished.
5. **First live event.** A config flag plus a UTC window, a separate event currency and event shop, and an Experience Event page on Creator Hub. ([events](docs/events/README.md))

## Limits of this research

- Snippets are marked unverified: API names were checked against the Roblox docs reference, but the code was not run or type-checked in Studio.
- Blocked or unreachable from the research session: gameuidatabase.com (403), Figma Community (403), poly.pizza (403), flipbook-labs.com (DNS). YouTube pages only showed titles, so channel recency is unverified.
- Licenses are summarized, not legal advice. Re-check the asset page before upload.
