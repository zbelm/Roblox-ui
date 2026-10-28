# Textures, materials, icons, fonts

Last verified: 2026-10-28

## Purpose

Answers: how PBR textures, `SurfaceAppearance`, `MaterialService`/`MaterialVariant`,
and custom terrain materials work, and where to get textures, icons, and fonts with
licenses that allow Roblox uploads. Full license table: [asset-sources.md](asset-sources.md).

## Top 5 picks

1. **Materials docs (MaterialService, MaterialVariant, overrides)** (https://create.roblox.com/docs/parts/materials). Official. Use it.
2. **PBR textures / SurfaceAppearance docs** (https://create.roblox.com/docs/art/modeling/surface-appearance) and **texture specs** (https://create.roblox.com/docs/art/modeling/texture-specifications). Use it.
3. **ambientCG** (https://ambientcg.com). CC0 PBR materials; commercial use and Roblox upload allowed, no credit needed. Use it.
4. **Poly Haven** (https://polyhaven.com). CC0 textures, HDRIs, models. Use it.
5. **Kenney** (https://kenney.nl). CC0 UI packs, icons, 2D and 3D kits. Use it for prototype and stylized UI art.

## How it works

Roblox has three ways to put a texture on geometry:

- **Base materials** (`Enum.Material`: Wood, Slate, Grass, and so on) are built-in tiling PBR materials applied through `BasePart.Material`. They work on parts and terrain.
- **Custom materials** are `MaterialVariant` instances inside `MaterialService`. Each variant names a `BaseMaterial`, supplies its own maps (`ColorMap`, `NormalMap`, `RoughnessMap`, `MetalnessMap`, plus emissive settings), and sets `StudsPerTile` for tiling scale and `MaterialPattern` (Regular or Organic, which breaks up visible repetition). A part opts in through `BasePart.MaterialVariant`. Marking a variant as an **override** in the Material Manager makes every use of that base material (terrain included) use the custom one. This is the right tool for tileable textures from ambientCG or Poly Haven.
- **SurfaceAppearance** is a child of a `MeshPart` that replaces its texture with a UV-mapped PBR set (color, normal, roughness, metalness, emissive). Use it for unique props and characters textured in Blender or Substance, not for tiling surfaces. Its maps generally cannot be changed by scripts at runtime because the engine pre-processes them.

`Decal` and `Texture` objects project a single image onto one face of a part.
`Texture` tiles (`StudsPerTileU/V`) and can be offset to animate. Images are
uploaded as assets and referenced as `rbxassetid://<id>`; every upload goes
through moderation first.

**Custom terrain materials** (Expanded Terrain) left Early Access in October 2026.
Setting `Workspace` **Expanded Terrain** to Enabled lets you paint up to 62 custom
materials, each with its own color and optional `MaterialVariant`, and also cuts
terrain's share of place file size. Before that, terrain could only show one
override per base material.

PBR in one paragraph: the color (albedo) map holds flat color without lighting;
the normal map fakes small surface detail; roughness controls how blurry
reflections are; metalness marks bare metal (usually pure black or white).
Roblox reads normal maps in **OpenGL tangent-space** format. Many free libraries
ship both OpenGL and DirectX normals; pick the GL one or invert the green channel.

Icons in UI are just `ImageLabel`s with an uploaded image. Fonts are different:
you cannot import font files. `FontFace` only accepts fonts from Roblox's own
library (Creator Store / Toolbox fonts and `Enum.Font` families such as Builder
Sans). Google Fonts is useful for picking families, and many of them already
exist in Roblox's library, but you cannot upload a `.ttf`.

## Gotchas

- Texture resolution: up to 4096x4096 is supported for environment textures. Roblox suggests about 256 px for a 5x5 stud object, 512 for 10x10, 1024 for 20x20. Bigger maps cost memory on phones.
- DirectX normal maps from asset sites look lit from the wrong side. Use the `_GL` variant.
- `Lighting.Technology` is deprecated (superseded by `LightingStyle` and `PrioritizeLightingQuality`); old material tutorials that tell you to switch to "Future" are describing the legacy property.
- Custom terrain materials: custom physical properties are not yet respected in custom material slots, and terrain thinner than 16 voxels can disappear during streaming (both listed as known issues in the launch post).
- Places edited during the terrain Early Access must still have Expanded Terrain set to Enabled, or custom materials show as grass.
- Creator Store models and texture packs: anything containing scripts can carry a backdoor. Insert into an empty place, search for `require(`, `loadstring`, `getfenv`, `setfenv`, `InsertService:LoadAsset`, and obfuscated strings before moving anything into your game. Roblox's own store policy bans these patterns, but enforcement is after the fact. See [../templates/README.md](../templates/README.md#vetting-creator-store-assets).
- "Free on itch.io" and "free on OpenGameArt" do not mean CC0. Check each asset's license; CC-BY needs credit, CC-BY-SA forces share-alike, GPL is a poor fit for art.
- Builder font license only permits use for Roblox UGC and its promotion.

## Sources

- https://create.roblox.com/docs/parts/materials
- https://create.roblox.com/docs/parts/custom-terrain-materials
- https://create.roblox.com/docs/art/modeling/surface-appearance
- https://create.roblox.com/docs/art/modeling/texture-specifications
- https://create.roblox.com/docs/parts/textures-decals
- https://create.roblox.com/docs/projects/assets
- https://create.roblox.com/docs/resources/builder-font-license
- https://devforum.roblox.com/t/full-launch-publish-games-with-custom-terrain-materials-and-performance-improvements/4950620
- https://ambientcg.com
- https://polyhaven.com
- https://kenney.nl
- Asset license table: [asset-sources.md](asset-sources.md)
