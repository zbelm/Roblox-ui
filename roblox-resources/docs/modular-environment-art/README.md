---
topic: modular-environment-art
summary: Building environments from reusable modular kits - grid and pivot rules, snapping, trim sheets and shared materials, SurfaceAppearance packages, instancing, collision settings, and streaming-friendly model sizes
keywords: modular kit, grid, pivot, origin, snapping, Move snap, Rotate snap, Pivot tool, trim sheet, tileable, MaterialVariant, SurfaceAppearance package, PackageLink, AutoUpdate, instancing, draw calls, CollisionFidelity, Anchored, StreamingEnabled, LevelOfDetail, SLIM, Array modifier, Mirror modifier
verified: 2026-10-28
---
# Modular environment art
## Use this
- Assemble modular environments: pivots, snap increments, variety with materials https://create.roblox.com/docs/tutorials/use-case-tutorials/modeling/assemble-modular-environments [S453]
- Assemble an asset library: packages, SurfaceAppearance packages, collision settings for kit pieces https://create.roblox.com/docs/tutorials/curriculums/environmental-art/assemble-an-asset-library [S455]
- Environmental art curriculum: full greybox-to-polish flow [S30]
- Map layouts, terrain, and procedural maps: see maps/README.md [S27]
- Rendering and memory budgets: see performance/README.md [S192]
## Concepts
- Why modular: a few pieces (walls, corners, floors, trims) snap into many layouts; less unique content to build and load [S453].
- Pivots [S453]:
  - Pieces snap at fixed increments only if every piece has a consistent pivot location.
  - Center pivots break snapping after rotation when pieces have different widths.
  - Set the origin in Blender before export (corner or edge of the grid cell) [S406]; adjust in Studio with the `Pivot` tool [S454].
  - Keep `Use Imported Pivot` on in the importer so the Blender origin survives [S415].
- Grid and snapping [S453]:
  - Pick a module size and build every piece to it.
  - Roblox's Modern City kit uses `Move` snap 7.5 studs and `Rotate` snap 45 degrees, with `Collisions` off while placing.
  - Move one piece at a time: selecting several averages their pivots and breaks the increments.
  - Copy the first piece's `Position`, paste it into each new piece, then move along one axis.
  - unverified: no Roblox-wide standard module size; choose one that fits character scale and your stud grid.
- Variety without new meshes [S453][S21]:
  - Swap `MaterialVariant` on the same mesh (custom materials).
  - Trim sheets and tileables let many pieces share one texture set [S431].
  - Blender `Array` and `Mirror` modifiers speed up repeating and symmetric pieces; apply them before export [S456][S457].
- SurfaceAppearance packages [S455]:
  - Make one SurfaceAppearance per trim sheet, `Convert to Package`, and child copies to kit pieces whose UVs map to that sheet.
  - Enable `AutoUpdate` on the `PackageLink` to push texture edits to every copy.
  - Packages also share kit meshes across places [S455].
- Instancing [S192]:
  - Copies with the same mesh asset and identical textures or SurfaceAppearance draw in one call.
  - Import each piece once, then duplicate in Studio; importing a whole assembled scene gives each copy new asset IDs.
- Collision per piece [S455][S192][S418]:
  - Use the cheapest `CollisionFidelity` that matches how players touch the piece; `PreciseConvexDecomposition` is the most expensive.
  - Small anchored props: `Box` is generally safe.
  - Anchor static kit pieces.
- Streaming [S197][S31]:
  - Group related pieces into models; keep each model's extent under ~64 cubic studs so it streams in together.
  - Set `Model.LevelOfDetail` to `SLIM` on static models so distant unstreamed content still shows.
## Gotchas
- A piece whose origin is off-grid breaks every layout using it; check origins before batch export [S453].
- Renaming pieces in Blender breaks reimport matching for already-placed copies [S419].
- Unique textures per piece defeat instancing and add memory [S192].
- `SLIM` level of detail does not support models modified at runtime or animated [S197].
- Free Creator Store kits can hide scripts; vet them before use (see templates and security) [S34][S177].
## Sources
S21, S27, S30, S31, S34, S177, S192, S197, S406, S415, S418, S419, S431, S453, S454, S455, S456, S457
