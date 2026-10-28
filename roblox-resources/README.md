# Roblox resource library

Last verified: 2026-10-28

Curated, link-checked notes for building a Roblox game: 25 topic folders under
[docs/](docs/), a routing table in [docs/INDEX.md](docs/INDEX.md), every cited
source with license and verdict in [sources/sources.csv](sources/sources.csv),
and small Luau patterns in [snippets/](snippets/). Facts were checked against the
Roblox creator docs source (2026-10-27) and live pages on 2026-10-28.

## Recent platform changes worth knowing

- Server authority (opt-in prediction and rollback) reached full release on 2026-07-09.
- Roblox Kids (5-8) and Select (9-15) account types: reaching under-16 players needs verification, 2FA, a maturity rating, a fee or subscription, and an evaluation.
- The `Sound` object is now labelled legacy; the modular audio API (`AudioPlayer`, `AudioEmitter`, `Wire`) is current.
- `AnalyticsService:Fire*` methods are deprecated; use `Log*`.
- Experience configs, UI Styling, official React Luau (`roblox/react`), custom terrain materials, and `MarketplaceService:BindReceiptHandler` are all released.
- Device trust (`IntegrityService`) rates player devices; Android, Chromebook, Meta Quest only so far.

## What to build first

1. Project skeleton: Rojo + Rokit + Wally, one server and one client entry script, `--!strict`, Selene/StyLua/luau-lsp in CI ([templates](docs/templates/README.md), [architecture](docs/architecture/README.md), [tooling](docs/tooling-testing-delivery/README.md)).
2. Data and security foundation: ProfileStore or DocumentService with schema versions, one validated remote layer with rate limits, server-owned currency ([data-persistence](docs/data-persistence/README.md), [security](docs/security/README.md), [economy](docs/economy-tokens/README.md)).
3. Core loop prototype in a greybox map, tested on a low-end phone from day one ([genres](docs/genres/README.md), [gameplay-systems](docs/gameplay-systems/README.md), [performance](docs/performance/README.md)).
4. Onboarding funnel with analytics events, then the UI shell with tokens and a shop ([progression](docs/progression/README.md), [analytics-liveops](docs/analytics-liveops/README.md), [ui](docs/ui/README.md)).
5. Compliance before release: maturity questionnaire, text filtering, `PolicyService` checks, custom thumbnail and icon, soft launch ([policy-compliance](docs/policy-compliance/README.md), [publishing-discovery](docs/publishing-discovery/README.md), [monetization](docs/monetization/README.md)).
6. Then layer weather, audio, NPCs, events, localization, and marketing.

## Limits

- Snippets were not run in Studio; each header says what was checked.
- Blocked from the research session: en.help.roblox.com and roblox.com/info/terms (HTTP 403), gameuidatabase.com, Figma Community, poly.pizza (403), flipbook-labs.com (DNS). Help Center policy text is therefore summarized from other official pages.
- Policy and limits change; re-check the cited page before relying on a number.
