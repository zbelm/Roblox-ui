# Roblox resource library

Last verified: 2026-10-28

Curated, link-checked notes for building a Roblox game. Read the folder README first;
each has Purpose, Top 5 picks, How it works, Gotchas, Sources.

## Where to look

- UI layout, scaling, styling, libraries, HUD/shop/inventory patterns: [docs/ui/README.md](docs/ui/README.md)
- Textures, PBR, MaterialService, icons, fonts, asset licenses: [docs/textures/README.md](docs/textures/README.md)
- Terrain, modular kits, map generation, game layouts: [docs/maps/README.md](docs/maps/README.md)
- Project structure, Rojo/Rokit/Wally, templates, vetting store assets: [docs/templates/README.md](docs/templates/README.md)
- Lighting, Atmosphere, Clouds, day/night, rain/snow/fog: [docs/weather/README.md](docs/weather/README.md)
- Live/seasonal events, configs, MessagingService, MemoryStore, DataStore: [docs/events/README.md](docs/events/README.md)
- UI design tokens and currency/Robux economy, anti-exploit: [docs/economy-tokens/README.md](docs/economy-tokens/README.md)
- Every cited URL with license and verdict: [sources/sources.csv](sources/sources.csv)
- One-concept Luau examples (all marked unverified, not run in Studio): [snippets/](snippets/)

## Conventions

- Luau files start with `--!strict` and are fully typed.
- No narrating comments. Comment only to explain a non-obvious reason or an engine quirk.
- Check the license (sources.csv, docs/textures/asset-sources.md) before using any asset.
- Vet Creator Store models for scripts before inserting (docs/templates/README.md).
- Never commit secrets: no Open Cloud keys, API tokens, or cookies in code or notes.
- Prefer current APIs; deprecated ones are listed in each Gotchas section.
- Every file carries a "Last verified" date; re-verify URLs and APIs older than ~6 months.
- Official docs source for grepping APIs: https://github.com/Roblox/creator-docs (`content/en-us/reference/engine/` holds deprecation flags).
