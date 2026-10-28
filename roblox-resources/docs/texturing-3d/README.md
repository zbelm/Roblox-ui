---
topic: texturing-3d
summary: Texturing meshes for Roblox - UVs, texel density, trim sheets, atlases, baking in Blender, PBR map hookup for import, SurfaceAppearance, and Studio's AI texture tools
keywords: UV unwrap, texel density, trim sheet, tileable, texture atlas, foliage, baking, Selected to Active, normal map, OpenGL tangent space, Principled BSDF, Normal Map node, SurfaceAppearance, ColorMap, AlphaMode, MaterialVariant, Texture Generator, Material Generator, 4096
verified: 2026-10-28
---
# Texturing 3D assets
## Use this
- Blender and Maya texture settings: which Principled BSDF socket each map needs for import https://create.roblox.com/docs/art/modeling/assign-textures [S427]
- Trim textures, Roblox staff article on trim-sheet modeling and unwrapping https://devforum.roblox.com/t/trim-textures-3d-modeling-and-unwrapping-trim-sheets/3171223 [S431]
- Texture atlases for foliage, Roblox staff article https://devforum.roblox.com/t/texture-atlases-creating-foliage-texture-and-meshes/3171224 [S432]
- Texture Generator: AI textures for a selected mesh in Studio https://create.roblox.com/docs/studio/texture-generator [S429]
- See textures/README.md for MaterialService, terrain materials, and texture sources.
## Concepts
- Texture specs [S24]:
  - Formats for separately uploaded textures: `.png`, `.jpg`, `.tga`, `.bmp`.
  - Up to 4096x4096; the engine streams lower mips first and raises quality per device.
  - Size guide: 256 for ~5x5 stud objects, 512 for ~10x10, 1024 for ~20x20.
  - Default part materials show 1024x1024 on an 8x8 stud face; match that texel density so custom assets sit next to parts.
- PBR hookup in Blender for import [S427]:
  - Material with `Principled BSDF`; add maps with `Add > Texture > Image Texture`.
  - Color/albedo to `Base Color`; metallic to `Metallic`; roughness to `Roughness`.
  - Normal: `Add > Vector > Normal Map` node between the image and `Normal`.
  - Export FBX with `Path Mode` `Copy` and `Embed Textures` on so the importer finds the images [S416].
- SurfaceAppearance [S23]:
  - Holds `ColorMap`, `MetalnessMap`, `NormalMap`, `RoughnessMap` (plus emissive) on a MeshPart.
  - Normal maps must be OpenGL format, tangent space.
  - `AlphaMode`: `Opaque`, `Overlay` (color map over `MeshPart.Color`), `Transparency` (cutout), `Tint mask`.
  - Emissive maps raise the Marketplace upload fee to 500 Robux for avatar items [S473].
- UVs and density:
  - Unwrap with seams in Blender's UV tools; keep islands at consistent texel density across a kit [S434][S432].
- Trim sheets [S431]:
  - One texture with horizontal strips (molding, panels, edges) reused across many meshes by placing UVs on strips.
  - Model in quads; inset large faces into a ring of quads so the ring takes trim and the center takes a tileable.
  - Pair trims with tileable materials; avoid trimming every edge.
  - Where density cannot match, use low-detail trims so the mismatch is less visible.
  - Community short guide covers the same idea for beginners [S433].
- Atlases [S432]:
  - Pack many small textures (leaves, plants) into one image so foliage meshes share one material.
  - Shared textures on identical meshes also allow instancing (see mesh-import-export) [S192].
- Baking in Blender (Cycles) [S435]:
  - `Selected to Active` bakes from a high-poly mesh onto the active low-poly mesh; rays cast inward from the low-poly.
  - Use `Extrusion` or a cage object to control ray distance.
  - Bake normals for detail on low-poly Roblox meshes; export the normal map in OpenGL convention [S23].
- Hand painting: Blender's texture paint mode paints directly onto the UV image [S436].
- Studio AI tools:
  - Texture Generator: select a mesh or model, prompt with text or image; `Fast` gives a 1K diffuse, `Quality` a 4K PBR texture [S429].
  - Material Generator: tiling material variants from text, opened from `Window > 3D` or the Material widget [S430].
  - Material reference page lists sample PBR values for common surfaces [S428].
  - Generated content follows Roblox's generative AI terms [S288].
## Gotchas
- Roblox supports only OpenGL tangent-space normal maps; a DirectX map needs its green channel flipped first [S23].
- Texture Generator is meant for asset-specific textures; use Material Generator for repeating surfaces [S429].
- Each extra unique texture adds memory and breaks instancing between otherwise identical meshes [S192].
- Uploading 4K textures for small props wastes memory; follow the size guide [S24].
- Vertex colors in the FBX can tint textures on import; see mesh-import-export [S424].
## Sources
S23, S24, S192, S288, S416, S424, S427, S428, S429, S430, S431, S432, S433, S434, S435, S436, S473
