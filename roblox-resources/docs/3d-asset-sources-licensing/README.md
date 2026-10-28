---
topic: 3d-asset-sources-licensing
summary: Where to get 3D models for Roblox and how to check licenses (CC0, CC BY variants, custom licenses), Creator Store risks, glTF export permissions, and requirements for selling UGC avatar items on the Marketplace
keywords: CC0, CC BY, CC BY-SA, CC BY-ND, CC BY-NC, attribution, Sketchfab, Poly Haven, Kenney, Quaternius, ambientCG, Poly Pizza, OpenGameArt, itch.io, Creator Store, backdoor, IP, Marketplace, UGC, ID verification, Roblox Plus, Premium, upload fee, publishing advance, rigid accessory, 4k triangles, glTF export permissions
verified: 2026-10-28
---
# 3D asset sources and licensing
## Use this
- Sketchfab's guide to Creative Commons license types https://sketchfab.com/blogs/community/an-introduction-to-creative-commons-licenses [S469]
- Marketplace fees and commissions: ID verification, upload fee, publishing advance https://create.roblox.com/docs/marketplace/marketplace-fees-and-commissions [S473]
- Rigid accessory specifications: single mesh, 4k triangles, size limits per body scale https://create.roblox.com/docs/avatar/rigid-accessories/specifications [S477]
- CC0 sources (Poly Haven, Kenney, ambientCG) and Quaternius: see textures/asset-sources.md [S140][S142][S138][S144]
- Creator Store policy [S34]
## Concepts
- License ladder, safest first:
  - CC0: no conditions; Poly Haven, Kenney, ambientCG [S141][S143][S139].
  - Custom permissive: Quaternius allows use in games but not redistributing the assets themselves [S145].
  - Per-asset licenses: Poly Pizza, OpenGameArt, itch.io, Sketchfab; read each model's license [S146][S147][S149][S469].
- Creative Commons terms [S469]:
  - BY: credit the author.
  - SA: share derivatives under the same license.
  - ND: no modified versions; you usually need to edit and re-export for Roblox, so avoid ND.
  - NC: no commercial use; a game with Robux sales is commercial, so avoid NC.
  - Sketchfab shows the attribution format to use for downloaded models [S470].
- Record every third-party asset: source URL, author, license, date, and where the credit appears (an in-game credits screen works for BY).
- Roblox side:
  - Uploading a model does not give you IP ownership of a design you found elsewhere [S475].
  - Roblox's IP guidelines cover copyright and trademark removal requests [S317].
  - glTF export from Studio only works for assets you or your group own or that were shared with you; Marketplace items and acquired Creator Store assets are blocked [S420].
- Creator Store models [S34][S177]:
  - Store models can contain backdoor scripts that pass moderation; Roblox recommends sandboxing inserted scripts and checking every Script.
  - A circulating Studio plugin was found with a backdoor in 2026; vet plugins too [S383].
  - Prefer meshes only (no scripts) from the store, or rebuild from CC0 sources.
- Selling UGC avatar items on the Marketplace (optional):
  - Eligibility: ID-verified, Roblox Plus or Premium 1000/2200, and consistent rule compliance [S472].
  - Upload fee: 80 Robux per submission; 500 Robux if the item uses an emissive mask; generally not refunded on rejection [S473].
  - Publishing advance: refundable upfront fee per item type (for example hat 1500, paid limited hat 13000) [S473].
  - Flow: upload in Studio as an `Accessory`, pick the asset type, pass validation, fill details, pay the fee, then moderation [S474].
  - Updates keep the asset ID and owners but cost the same upload fee and go through moderation again [S474].
  - Rigid accessories: single mesh, at most 4k triangles, size caps per body scale (`Normal`, `Slender`, `Classic`) [S477].
  - Layered items need cages and skinning (see rigging-skinning) [S442].
  - Policy: no copied items, careful designs near mouth and waist; test on several bodies [S476].
  - Marketplace (avatar items) is separate from the Creator Store (development assets) [S471].
## Gotchas
- unverified: Poly Pizza license is per model and was blocked (403) during research; check each model page [S146].
- Sketchfab "free download" is not always CC0; many are CC BY and some NC or ND [S469].
- Assets pulled by MCP asset-search tools keep their original licenses (see claude-3d-workflow) [S467].
- Do not re-upload Quaternius packs as free standalone models [S145].
- Marketplace upload fees are not refunded when moderation rejects an item [S473].
- AI-generated assets follow Roblox's generative AI terms; check them before selling [S288].
- Never commit Open Cloud keys used for asset upload tools to this repo [S399].
## Sources
S34, S138, S139, S140, S141, S142, S143, S144, S145, S146, S147, S149, S177, S288, S317, S383, S399, S420, S442, S467, S469, S470, S471, S472, S473, S474, S475, S476, S477
