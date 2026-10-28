---
topic: economy-tokens
summary: Overview of UI design tokens and in-game currency (Robux products, receipts, balance, exploit-proof handling)
keywords: design tokens, StyleSheet, theme, currency, soft currency, Robux, developer product, pass, ProcessReceipt, BindReceiptHandler, PurchaseId, sources, sinks, expected value, event currency, exploit, server-authoritative, session locking
verified: 2026-10-28
---
# Tokens: UI design tokens and in-game currency
Files: design-tokens.md (UI tokens in Luau), currency-economy.md (Robux products, receipts, balancing).
## Use this
- UI Styling tokens and themes: attributes on a `StyleSheet`, `"$Name"` refs, `StyleDerive` themes [S7]
- Developer products and receipt handling: currency packs; `ProcessReceipt` or `BindReceiptHandler` https://create.roblox.com/docs/production/monetization/developer-products [S57]
- Balance virtual economies: sources, sinks, expected value, event currencies https://create.roblox.com/docs/production/game-design/balance-virtual-economies [S64]
- Player data and purchasing systems: reference design for retries, session locking, atomic purchases https://create.roblox.com/docs/cloud-services/data-stores/player-data-purchasing [S56]
- DTCG format 2025.10: stable tool-neutral token JSON, pairs with Style Dictionary https://www.designtokens.org [S134][S135]
## Concepts
- "Tokens" here means two things: UI design tokens (named color, spacing, type, radius values) and currency tokens (in-game currencies and Robux products).
- Design tokens are tiered: primitive (`amber500`), semantic (`accent = amber500`), component (`button.primary.background = accent`); themes swap the semantic layer [S134].
- Apply in Roblox via a typed Luau module (`snippets/ui-design-tokens.luau`) or native StyleSheets (`snippets/ui-stylesheet-theme.luau`); StyleSheets win for Studio-authored UI and live theme switching, a module is simpler for code-built React/Fusion UI [S7].
- Currencies: soft currency is earned by play and spent on progression; Robux buys developer products (repeatable) or passes (one-time) [S57].
- Roblox calls your server when a product needs granting; grant, save that you did, then report processed; on failure report not processed and Roblox redelivers on the next purchase or rejoin [S57].
- Balance: sources (quests, drops, purchases, events) add currency, sinks (upgrades, cosmetics, rerolls, fees) remove it; give events their own currency and shop; estimate impact with expected value before launch [S64].
- Exploits: exploiters fully control their client; the server owns balances and prices, the client sends only an item id, the server validates type, range, ownership, cooldown, price, rate-limits per player, and logs large changes [S56].
- Dupes usually come from saving a player on two servers (fix: session locking) or granting a receipt twice (fix: record `PurchaseId`) [S56].
## Gotchas
- Use `ProcessReceipt` or `BindReceiptHandler` consistently: a bound handler takes precedence and unmatched receipts fall through to `ProcessReceipt`; they return `Enum.ProductPurchaseDecision` vs `Enum.ReceiptDecision` [S57].
- With no receipt callback, receipts are auto-acknowledged and cannot be recovered [S57].
- A receipt callback can run on two servers at once if the player hops mid-grant; record `PurchaseId` in session-locked data [S57].
- Products sold outside your game need a correct `ProcessReceipt`; Roblox flags broken ones in Creator Hub > Monetization > Shop and hides them [S57].
- `PromptProductPurchaseFinished` is not proof of purchase [S57].
- Deprecated: `MarketplaceService:GetProductInfo`, `PlayerOwnsAsset`, `PlayerOwnsBundle`; use the `...Async` versions.
- Never put Open Cloud API keys in scripts, configs, or the repo.
## Sources
S7, S56, S57, S64, S134, S135
