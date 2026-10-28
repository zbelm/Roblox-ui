---
topic: textures
summary: How PBR textures, SurfaceAppearance, MaterialService/MaterialVariant, terrain materials, icons, and fonts work on Roblox
keywords: PBR, MaterialService, MaterialVariant, BaseMaterial, StudsPerTile, MaterialPattern, override, SurfaceAppearance, ColorMap, NormalMap, RoughnessMap, MetalnessMap, OpenGL normal, Decal, Texture, rbxassetid, Expanded Terrain, custom terrain materials, FontFace, Builder Sans
verified: 2026-10-28
---
# Textures, materials, icons, fonts
Files: asset-sources.md (license list for textures, models, icons, fonts).
## Use this
- Materials docs: MaterialService, MaterialVariant, overrides https://create.roblox.com/docs/parts/materials [S21]
- PBR textures / SurfaceAppearance guide https://create.roblox.com/docs/art/modeling/surface-appearance [S23]
- Texture specifications: resolution, map formats https://create.roblox.com/docs/art/modeling/texture-specifications [S24]
- ambientCG: CC0 PBR materials, Roblox upload and commercial use allowed https://ambientcg.com [S138]
- Poly Haven: CC0 textures, HDRIs, models https://polyhaven.com [S140]
## Concepts
- Three ways to texture geometry [S21][S23]:
  - Base materials (`Enum.Material`) via `BasePart.Material`; built-in tiling PBR on parts and terrain.
  - Custom materials: `MaterialVariant` in `MaterialService` names a `BaseMaterial`, supplies `ColorMap`, `NormalMap`, `RoughnessMap`, `MetalnessMap`, emissive settings, `StudsPerTile`, and `MaterialPattern` (Regular or Organic to break repetition). Parts opt in via `BasePart.MaterialVariant`. Marking a variant as an override in the Material Manager replaces every use of that base material, terrain included. Right tool for tileable textures.
  - `SurfaceAppearance` under a `MeshPart`: UV-mapped PBR set for unique props and characters; maps generally cannot be changed by scripts at runtime because the engine pre-processes them.
- `Decal` and `Texture` project one image onto a part face; `Texture` tiles (`StudsPerTileU/V`) and can be offset to animate [S25].
- Images upload as assets referenced by `rbxassetid://<id>`; every upload is moderated [S26].
- Custom terrain materials (Expanded Terrain) left Early Access in October 2026: set Workspace Expanded Terrain to Enabled to paint up to 62 materials, each with a color and optional `MaterialVariant`; also cuts terrain's place-file size. Before, terrain showed one override per base material [S22][S71].
- PBR: color (albedo) holds unlit color; normal fakes small detail; roughness controls reflection blur; metalness marks bare metal (usually pure black or white) [S23].
- Roblox reads normal maps in OpenGL tangent-space format; pick the GL variant or invert the green channel [S24].
- Icons are `ImageLabel`s with uploaded images [S26].
- Fonts cannot be imported; `FontFace` only takes Roblox library fonts (Creator Store fonts, `Enum.Font` families like Builder Sans). Google Fonts is useful for choosing families, many already exist in Roblox [S26][S156].
- Asset licenses: ambientCG, Poly Haven, Kenney are CC0 [S138][S140][S142]; full list in asset-sources.md.
## Gotchas
- Resolution: up to 4096x4096 for environment textures; Roblox suggests ~256 px for 5x5 studs, 512 for 10x10, 1024 for 20x20; large maps cost phone memory [S24].
- DirectX normal maps look lit from the wrong side; use `_GL` files [S24].
- `Lighting.Technology` is deprecated (superseded by `LightingStyle` and `PrioritizeLightingQuality`); old tutorials saying "switch to Future" describe the legacy property.
- Custom terrain materials known issues: custom physical properties not respected in custom slots; terrain under 16 voxels can vanish while streaming [S71].
- Places edited during terrain Early Access still need Expanded Terrain set to Enabled or custom materials show as grass [S22].
- Creator Store models and texture packs with scripts can carry backdoors; vet them (see templates) [S67].
- Free on itch.io or OpenGameArt does not mean CC0; CC-BY needs credit, CC-BY-SA forces share-alike, GPL fits art poorly [S149][S147].
- Builder font license permits only Roblox UGC use and its promotion [S66].
## Sources
S21, S22, S23, S24, S25, S26, S66, S67, S71, S138, S140, S142, S147, S149, S156
