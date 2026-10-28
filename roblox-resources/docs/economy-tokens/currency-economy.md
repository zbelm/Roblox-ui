---
topic: economy-tokens
summary: Robux product types and APIs, receipt handling with ProcessReceipt or BindReceiptHandler, server-authoritative currency, and earn/sink balancing
keywords: developer product, PromptProductPurchase, pass, PromptGamePassPurchase, UserOwnsGamePassAsync, subscription, PromptRobuxTransferAsync, GetProductInfoAsync, ProcessReceipt, ProductPurchaseDecision, BindReceiptHandler, ReceiptType, ReceiptDecision, PurchaseId, idempotent, ledger, rate limit, leaderstats, sources, sinks, expected value, managed pricing, paid random items
verified: 2026-10-28
---
# In-game currency and Robux products
## Use this
- Passes: one-time Robux perks https://create.roblox.com/docs/production/monetization/passes [S58]
- Robux transfers: player-to-player transfers with `BindReceiptHandler` receipts https://create.roblox.com/docs/production/monetization/robux-transfers [S60]
- Monetization foundations: designing what to sell https://create.roblox.com/docs/production/game-design/monetization-foundations [S65]
- Snippet: `snippets/economy-receipt-handler.luau` (idempotent grants by `PurchaseId`)
- Snippet: `snippets/economy-currency-ledger.luau` (one server module for every coin change)
## Concepts
- Products and APIs:
  - Developer product: repeatable (currency pack, revive, boost); `MarketplaceService:PromptProductPurchase(player, productId)`, grant in a receipt handler [S57].
  - Pass: one-time (VIP, 2x coins); `PromptGamePassPurchase`, check `UserOwnsGamePassAsync` [S58].
  - Subscription: recurring; `PromptSubscriptionPurchase`, `GetUserSubscriptionStatusAsync` [S59].
  - Robux transfer: `PromptRobuxTransferAsync`; receipts via `BindReceiptHandler` with `RobuxTransferSender`/`RobuxTransferReceiver` [S60].
  - Product info for UI: `GetProductInfoAsync` [S57].
- `MarketplaceService.ProcessReceipt`: one callback in one server Script; `receiptInfo` has `PurchaseId`, `PlayerId`, `ProductId`, `CurrencySpent`, `PlaceIdWherePurchased`; return `Enum.ProductPurchaseDecision.PurchaseGranted` after granting and saving, or `NotProcessedYet` to retry on next purchase or rejoin. No time-based retries, no timeout, pending purchases arrive in no set order [S57].
- `MarketplaceService:BindReceiptHandler(receiptType, handler, filter?)`: per `Enum.ReceiptType`; `filter` of product ids routes products, omit for catch-all; returns `Enum.ReceiptDecision.Processed` or `NotProcessedYet`; returns an `RBXScriptConnection`; takes precedence, unmatched receipts fall through to `ProcessReceipt` so you can migrate one product at a time; a duplicate handler for the same type and product (or second catch-all) throws [S57][S60].
- Both: the player must be in a server, and one receipt can run on two servers if the player hops mid-grant; record `PurchaseId` in session-locked data [S57].
- Server-authoritative currency [S56][S84]:
  - Balances live in server memory and saved data; replicate a read-only copy (attribute or leaderstats).
  - Prices and rewards live in a server module or configs, never client arguments.
  - One award/spend module checks integers, non-negative results, caps, and audits large changes.
  - Remotes: validate `typeof`, ranges, ownership, distance or cooldown; rate-limit per player; ignore bad input.
  - Detect earn events (kills, pickups, quests) on the server.
  - Session locking prevents cross-server dupes (see events/data-services.md).
- Balancing [S64]:
  - List every source and sink with a per-player-hour rate; aim for slightly positive net with scaling sinks.
  - Expected value for random rewards: sum of value x probability; Roblox's guide includes an EV spreadsheet.
  - Event-specific currency and shop keep event inflation out of the main economy (Roblox's "safest solution").
  - Robux packs: better price per coin with size, without making the smallest pack a trap.
  - Tune through configs; A/B test prices with experiments; managed pricing and price optimization handle Robux price points and regional pricing [S61][S62].
- Paid random items have their own policy and disclosure rules [S63].
## Gotchas
- No receipt callback means receipts are auto-acknowledged and lost [S57].
- A handler that errors or yields forever leaves the purchase unresolved; always return a decision [S57].
- `ProcessReceipt` may be recorded as failed even after `PurchaseGranted` and be redelivered; the `PurchaseId` check makes it harmless [S57].
- Keep stored `PurchaseId` history bounded (for example last 100).
- Rate-limit shop remotes before any DataStore or MemoryStore call.
- `leaderstats` are a display copy, not storage.
- The non-Async `GetProductInfo` is deprecated.
## Sources
S56, S57, S58, S59, S60, S61, S62, S63, S64, S65, S84
