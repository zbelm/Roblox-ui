# Asset sources and licenses

Last verified: 2026-10-28

Back to [README.md](README.md). Licenses read from each site's license page on
2026-10-28. "Roblox OK" means the license permits uploading to Roblox and using
it in a monetized game; it does not mean Roblox moderation will accept a given
image. Not legal advice; re-check the license on the specific asset page.

## Textures, HDRIs, 3D

| Name | URL | License | Roblox OK | Verdict |
|---|---|---|---|---|
| ambientCG | https://ambientcg.com | CC0 1.0 (all assets, including previews) | Yes, no credit required | Use it. Pick `GL` normal maps. License page: https://docs.ambientcg.com/license/ |
| Poly Haven | https://polyhaven.com | CC0 for HDRIs, textures, models; site logos and renders are not CC0 | Yes, no credit required | Use it. License: https://polyhaven.com/license |
| Kenney | https://kenney.nl | CC0 | Yes, credit optional; do not use Kenney's logo | Use it. License/support page: https://kenney.nl/support |
| Quaternius | https://quaternius.com | Quaternius Asset License v1.0 (updated 2026-08-28), not CC0 | Yes in a finished game; no credit required. You may not redistribute the assets themselves, even modified, as packs, templates, or stock files | Use it for in-game low-poly models. Do not re-upload them as free Creator Store models (that is redistribution). License: https://quaternius.com/license.html |
| Poly Pizza | https://poly.pizza | Unverified (believed to be per model, CC0 or CC-BY) | Depends on model | Unverified: returned HTTP 403 to this session. Check the license badge on each model page. |
| OpenGameArt | https://opengameart.org | Per asset: CC0, CC-BY, CC-BY-SA, OGA-BY, GPL | Varies. CC0 yes; CC-BY yes with credit; CC-BY-SA forces share-alike on derivatives; GPL is unclear for art | Use with caution. Read the FAQ: https://opengameart.org/content/faq. Site warns some uploads came from sources with licensing problems. |
| itch.io game assets | https://itch.io/game-assets | Set by each creator; no site-wide license, no CC0 filter | Varies | Use with caution. Read each page's license text; "free" is a price filter, not a license. |

## Icons

| Name | URL | License | Roblox OK | Verdict |
|---|---|---|---|---|
| game-icons.net | https://game-icons.net | CC BY 3.0 (repo license file notes CC0 for some icons) | Yes, with credit to each icon's author | Use it. Over 4,000 game-themed icons. Put credits in an in-game Credits screen or the game description. About page: https://game-icons.net/about.html |
| Lucide | https://lucide.dev | ISC; Feather-derived icons MIT | Yes; keep the license notice in your project files | Use it for clean UI glyphs. License: https://lucide.dev/license |
| Phosphor Icons | https://phosphoricons.com | MIT (per https://github.com/phosphor-icons/homepage) | Yes; keep the license notice | Use it. 1,248 icons in 6 weights (repo README). The homepage rendered only its title to this session. |

## Fonts

| Name | URL | License | Roblox OK | Verdict |
|---|---|---|---|---|
| Google Fonts | https://fonts.google.com | Per family: OFL, Apache 2.0, or UFL (top-level folder in https://github.com/google/fonts) | Licenses allow it, but Roblox does not let you import font files | Use as a reference only. Many families already exist in Roblox's font library; use those through `FontFace`. Site is client-rendered; license info verified from the GitHub repo. |
| Roblox Builder font | https://create.roblox.com/docs/resources/builder-font-license | Roblox license limited to Roblox UGC and its promotion | Yes, inside Roblox | Use it (default UI font family). |

## Roblox Creator Store

| Name | URL | License | Roblox OK | Verdict |
|---|---|---|---|---|
| Creator Store | https://create.roblox.com/store | Roblox Terms of Use; assets must follow Roblox IP guidelines; no per-asset open license | Yes inside Roblox | Use with caution. Page is client-rendered (empty to this fetcher). Prefer assets from Roblox or verified creators; vet every script. See [../templates/README.md](../templates/README.md#vetting-creator-store-assets). |

## Before you upload anything

1. Note the license and source URL in a credits file in your project (not the asset itself).
2. CC-BY: add the author credit in-game or in the game description.
3. Never upload assets whose license forbids redistribution as standalone Creator Store items (Quaternius, most paid packs).
4. Do not bulk-copy asset libraries into the repo; link to them.
