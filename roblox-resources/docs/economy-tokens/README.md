# Tokens: UI design tokens and in-game currency

Last verified: 2026-10-28

## Purpose

"Tokens" means two different things in this project:

- **UI design tokens**: named values for color, spacing, type, and radius that every screen uses. Details: [design-tokens.md](design-tokens.md).
- **Currency tokens**: in-game currencies, Robux developer products, earn/sink balance, and exploit-proof handling. Details: [currency-economy.md](currency-economy.md).

## Top 5 picks

1. **UI Styling tokens and themes** (https://create.roblox.com/docs/ui/styling). Tokens as attributes on a `StyleSheet`, referenced as `"$Name"`; themes via `StyleDerive`. Fully released 2026-01-20. Use it.
2. **Developer products + receipt handling** (https://create.roblox.com/docs/production/monetization/developer-products). Selling consumables and currency packs; `ProcessReceipt` or the newer `MarketplaceService:BindReceiptHandler`. Use it.
3. **Balance virtual economies** (https://create.roblox.com/docs/production/game-design/balance-virtual-economies). Sources and sinks, expected-value estimates, event currencies. Use it.
4. **Player data and purchasing systems** (https://create.roblox.com/docs/cloud-services/data-stores/player-data-purchasing). Roblox's reference design for retries, session locking, and atomic purchase handling. Use it as the design checklist.
5. **Design Tokens Community Group format 2025.10** (https://www.designtokens.org). First stable, tool-neutral JSON format for tokens; pairs with Style Dictionary (https://styledictionary.com). Use it if tokens come from Figma or are shared with a website.

## How it works

**Design tokens.** Instead of writing `Color3.fromRGB(255, 181, 71)` in forty
places, you name it once (`accent`) and reference the name. Tokens come in tiers:
primitive tokens (`amber500`), semantic tokens that point at primitives
(`accent = amber500`), and component settings that point at semantic tokens
(`button.primary.background = accent`). Themes swap the semantic layer. In
Roblox there are two ways to apply them: a typed Luau module that UI code reads
([../../snippets/ui-design-tokens.luau](../../snippets/ui-design-tokens.luau)),
or native StyleSheets where token sheets hold attributes and rules reference them
([../../snippets/ui-stylesheet-theme.luau](../../snippets/ui-stylesheet-theme.luau)).
StyleSheets win for Studio-authored UI and live theme switching; a Luau module
is simpler for code-built UI and React/Fusion components.

**Currencies.** A soft currency (coins) is earned by playing and spent on
progression. A premium path uses Robux: players buy **developer products**
(repeatable, for example "500 coins") or **passes** (one-time perks). Roblox calls
your server when a product purchase needs granting. The server must grant the
coins, save that it did so, and only then tell Roblox the receipt is processed.
If anything fails, it reports "not processed yet" and Roblox redelivers the
receipt later (when the player buys again or rejoins).

**Balance.** Every source (quest rewards, drops, purchases, events) adds currency;
every sink (upgrades, cosmetics, rerolls, fees) removes it. If sources outrun
sinks, prices stop meaning anything. Roblox's guide recommends giving events
their own currency spent in an event shop so the main economy is untouched, and
estimating impact with expected-value math before launch.

**Exploits.** Exploiters control their own client completely. They can fire any
RemoteEvent with any arguments, read anything replicated to them, and change
local UI. So: the server owns balances and prices; the client only sends intent
(item id); the server validates type, range, ownership, cooldown, and price;
rate-limit remotes per player; log large or unusual changes. Duplication bugs
usually come from saving the same player on two servers (fixed by session
locking) or granting a receipt twice (fixed by recording `PurchaseId`).

## Gotchas

- Use `ProcessReceipt` **or** `BindReceiptHandler` consistently. A bound handler takes precedence; unmatched developer-product receipts fall through to `ProcessReceipt`. `ProcessReceipt` returns `Enum.ProductPurchaseDecision`; bound handlers return `Enum.ReceiptDecision`.
- If no receipt callback is set, receipts are auto-acknowledged and cannot be recovered.
- A receipt callback can run on two servers at once if the player switches servers mid-grant. Record `PurchaseId` in session-locked data to make grants idempotent.
- Products sold outside your game (Store tab) require a correct `ProcessReceipt`; Roblox flags broken ones in Creator Hub > Monetization > Shop and hides them.
- `PromptProductPurchaseFinished` is not proof of purchase.
- `MarketplaceService:GetProductInfo`, `PlayerOwnsAsset`, and `PlayerOwnsBundle` are deprecated; use the `...Async` versions.
- Never put Open Cloud API keys in scripts, configs, or this repo.

## Sources

- https://create.roblox.com/docs/ui/styling
- https://create.roblox.com/docs/production/monetization/developer-products
- https://create.roblox.com/docs/production/game-design/balance-virtual-economies
- https://create.roblox.com/docs/cloud-services/data-stores/player-data-purchasing
- https://www.designtokens.org
- https://styledictionary.com
- Topic files: [design-tokens.md](design-tokens.md), [currency-economy.md](currency-economy.md)
