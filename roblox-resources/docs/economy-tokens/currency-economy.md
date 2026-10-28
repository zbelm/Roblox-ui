# In-game currency and Robux products

Last verified: 2026-10-28

Back to [README.md](README.md).

## Products and APIs

| Thing | What it is | Key API |
|---|---|---|
| Developer product | Repeatable Robux purchase (currency pack, revive, boost) | `MarketplaceService:PromptProductPurchase(player, productId)`; grant in a receipt handler |
| Pass | One-time Robux purchase (VIP, 2x coins) | `PromptGamePassPurchase`, check with `UserOwnsGamePassAsync` |
| Subscription | Recurring purchase | `PromptSubscriptionPurchase`, `GetUserSubscriptionStatusAsync` |
| Robux transfer | Player-to-player Robux transfer prompted from your game | `PromptRobuxTransferAsync`; receipts via `BindReceiptHandler` with `RobuxTransferSender` / `RobuxTransferReceiver` |
| Product info for UI | Name, price, icon | `GetProductInfoAsync` (the non-Async `GetProductInfo` is deprecated) |

Docs: https://create.roblox.com/docs/production/monetization/developer-products,
https://create.roblox.com/docs/production/monetization/passes,
https://create.roblox.com/docs/production/monetization/subscriptions,
https://create.roblox.com/docs/production/monetization/robux-transfers

## Receipt handling: two APIs

**`MarketplaceService.ProcessReceipt`** (callback, set once in one server Script).
Receives `receiptInfo` (`PurchaseId`, `PlayerId`, `ProductId`, `CurrencySpent`,
`PlaceIdWherePurchased`, ...). Return `Enum.ProductPurchaseDecision.PurchaseGranted`
after granting and saving, or `NotProcessedYet` to have Roblox retry on the
player's next purchase or rejoin. No time-based retries, no timeout, and calls for
multiple pending purchases arrive in no particular order.

**`MarketplaceService:BindReceiptHandler(receiptType, handler, filter?)`** (newer).
Registers a handler per `Enum.ReceiptType`; for developer products, pass a
`filter` array of product ids to route products to dedicated handlers, or omit it
for a catch-all. Return `Enum.ReceiptDecision.Processed` or `NotProcessedYet`.
Returns an `RBXScriptConnection`. Bound handlers take precedence; unmatched
developer-product receipts fall through to `ProcessReceipt`, so you can migrate
one product at a time. Registering a second handler for the same type and
product (or a second catch-all) throws.

Both: the player must be in a server for the handler to run, and the same receipt
can be handled on two servers at once if the player hops mid-grant. That is why
the grant must be recorded with the `PurchaseId` in session-locked player data.

Snippet: [../../snippets/economy-receipt-handler.luau](../../snippets/economy-receipt-handler.luau).

## Server-authoritative currency

1. Balances live only in server memory and saved data; replicate a read-only copy (attribute or leaderstats) for UI.
2. Prices and rewards live in a server module or configs, never in a client argument.
3. Every mutation goes through one module (award/spend) that checks integers, non-negative results, caps, and writes an audit entry for large changes.
4. Remotes: validate argument types (`typeof`), ranges, ownership, distance or cooldown where relevant; rate-limit per player; ignore (do not error on) bad input.
5. Earn events (kills, pickups, quest completions) are detected on the server, not reported by the client.
6. Session locking on player data prevents dupes across servers; ProfileStore does this ([../events/data-services.md](../events/data-services.md)).

Snippet: [../../snippets/economy-currency-ledger.luau](../../snippets/economy-currency-ledger.luau).

## Earn / sink balancing

- List every source and sink with its rate per player-hour. Target a slightly positive net so players feel progress, with sinks that scale (upgrade costs that grow, consumables, cosmetics).
- Use expected value for random rewards: sum of (value x probability). Roblox's guide includes an EV spreadsheet example.
- Give events their own currency and event shop so event inflation does not leak into the main economy (Roblox's recommended "safest solution").
- Robux packs: price per coin should improve with pack size, but not so much that the smallest pack feels like a trap.
- Tune numbers through configs so you can adjust without a publish; experiments can A/B test prices. Roblox's managed pricing and price optimization tools handle Robux price points and regional pricing: https://create.roblox.com/docs/production/monetization/managed-pricing, https://create.roblox.com/docs/production/monetization/price-optimization
- Paid random items (loot boxes) have their own Roblox policy and disclosure rules: https://create.roblox.com/docs/production/monetization/paid-random-items

Docs: https://create.roblox.com/docs/production/game-design/balance-virtual-economies,
https://create.roblox.com/docs/production/game-design/monetization-foundations

## Gotchas

- Auto-acknowledge trap: no receipt callback means receipts are acknowledged automatically and lost.
- A handler that errors or yields forever leaves the purchase unresolved; always return a decision.
- `ProcessReceipt` might be recorded as failed on Roblox's side even after you return `PurchaseGranted`, so it may be delivered again; your `PurchaseId` check makes that harmless.
- Keep the stored `PurchaseId` history bounded (for example the last 100) to keep player data small.
- Exploiters can fire your shop remote thousands of times per second. Rate-limit before any DataStore or MemoryStore call.
- Do not trust `leaderstats` values as storage; they are a display copy.

## Sources

All URLs above, plus:
- https://create.roblox.com/docs/cloud-services/data-stores/player-data-purchasing
- https://devforum.roblox.com/t/how-do-i-prevent-duplication-of-ingame-itemscurrency-and-dataloss/3848629
