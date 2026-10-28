---
topic: monetization
summary: Which Roblox revenue products exist, how to price them, ethical design rules, and current policy limits (checked 2026-10-28)
keywords: monetization, pass, game pass, developer product, subscription, private server, paid access, regional pricing, managed pricing, price optimization, paid random items, loot box, odds disclosure, PolicyService, GetPolicyInfoForPlayerAsync, ArePaidRandomItemsRestricted, IsPaidItemTradingAllowed, immersive ads, rewarded video, DevEx, Earned Robux, discount, urgency, ethics
verified: 2026-10-28
---
# Monetization
## Use this
- Monetization overview and guidelines: products plus Roblox's rules on honest presentation https://create.roblox.com/docs/production/monetization [S302]
- Paid random items policy: odds disclosure and `PolicyService` gating [S63]
- Regional pricing: per-region prices, arbitrage protection https://create.roblox.com/docs/production/monetization/regional-pricing [S303]
- `PolicyService`: per-player eligibility for random items, trading, ads, subscriptions https://create.roblox.com/docs/reference/engine/classes/PolicyService [S311]
- Developer Exchange: how Earned Robux converts to cash https://create.roblox.com/docs/production/monetization/developer-exchange [S304]
## Concepts
- Product types:
  - Pass: one-time permanent perk (VIP, 2x coins, cosmetic) [S58].
  - Developer product: repeatable purchase (currency packs, revives, boosts); granted by the receipt handler, see economy-tokens docs [S57].
  - Subscription: monthly auto-renewing benefit; priced in Robux (minimum 49) or one of 5 local-currency tiers; no mutually exclusive tiers [S59].
  - Private servers: player-rented servers [S306]. Paid access: one-time fee to enter the game [S307].
  - Ads: immersive ad units in the world and rewarded video ads [S308][S309]. Commerce products sell real-world goods where eligible [S310].
- Pricing: set a default price; Managed Pricing adjusts per region and runs price optimization tests [S61][S62][S303].
- Regional prices are never discounted more than 70% and never exceed your default price; use `MarketplaceService:GetUsersPriceLevelsAsync` to stop players trading items bought at different regional prices [S303].
- Payouts: standard DevEx rate is 0.0038 USD per Earned Robux (114 USD per 30,000); a 0.0054 rate applies to certain purchases from age-verified U.S. 18+ players in eligible games [S304][S305].
- Ethical design rules from Roblox's guidelines [S302]:
  - Discounts must be genuine (not permanently "on sale") and fair (not a pressure-length window).
  - No fake scarcity or false "limited time" claims; no countdown timers that reset for the same item.
  - Avoid pushy language ("GET IT NOW"); prefer neutral calls to action ("View Item").
  - Players must never be misled, confused, or pressured into purchases.
- Subscription rules: name and price each option clearly; never require extra tasks (like social posts) to receive paid benefits [S59].
- Paid random items (any random reward bought with Robux or Robux-bought currency) [S63]:
  - Show odds as percentages summing to exactly 100% before purchase, including for keys, tickets, or rerolls bought with currency.
  - Explain luck boosters before purchase.
  - Check `PolicyService:GetPolicyInfoForPlayerAsync(player).ArePaidRandomItemsRestricted` and block or replace the feature for restricted users; Roblox's guidelines say this check is required [S302][S311].
  - Free random rewards earned by play need no odds disclosure.
- Trading of paid items: gate with `IsPaidItemTradingAllowed` from `PolicyService` [S63][S311].
- Value-first design: sell convenience, cosmetics, and access that do not make free play miserable; contextual offers at natural moments convert better than pop-ups [S297].
## Gotchas
- Policy text changes; these limits were read from the Roblox docs source dated 2026-10-27. Re-check before launch [S302].
- Terms of Use and Help Center monetization articles (en.help.roblox.com) were blocked (HTTP 403) from the research session; Community Standards loaded [S312].
- `PolicyService` results vary by player location, age, and platform; call it per player, never once per server [S311].
- Subscriptions cannot be tiered Bronze/Silver/Gold as mutually exclusive options [S59].
- Developer products sold outside the game require a correct receipt handler or Roblox hides them [S57].
- Commerce product eligibility is limited; ambiguous which regions and ages qualify without reading the full page [S310].
## Sources
S57, S58, S59, S61, S62, S63, S297, S302, S303, S304, S305, S306, S307, S308, S309, S310, S311, S312
