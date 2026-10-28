---
topic: mesh-import-export
summary: Getting meshes from Blender into Studio and back - FBX/glTF export settings, 3D Importer options, mesh limits, reimport, fidelity settings, glTF export beta, and a pre-export checklist
keywords: FBX, glTF, OBJ, 3D Importer, File > Import, Path Mode, Embed Textures, FBX Unit Scale, Add Leaf Bones, Bake Animation, World Forward, World Up, Scale Unit, Use Imported Pivot, Merge Meshes, Ignore Vertex Colors, reimport, RenderFidelity, CollisionFidelity, 20000 triangles, instancing, glTF export, MeshPart
verified: 2026-10-28
---
# Mesh import and export
## Use this
- 3D Importer: every import setting and what it does https://create.roblox.com/docs/studio/importer [S415]
- Export requirements: Blender and Maya FBX settings Roblox expects https://create.roblox.com/docs/art/modeling/export-requirements [S416]
- Mesh specifications: triangle limit, geometry, rig, cage rules https://create.roblox.com/docs/art/modeling/specifications [S417]
- Reimport: update meshes and textures in place without new instances https://create.roblox.com/docs/art/modeling/reimport [S419]
- Snippets: `snippets/blender-apply-export.py`, `snippets/mesh-verify-meshpart.luau` (Luau unverified, not run in Studio)
## Concepts
- Formats: the importer takes `.fbx`, `.obj`, `.gltf`; FBX and glTF carry hierarchies, PBR textures, cages, rigs, animation, vertex colors [S415].
- Blender FBX export (`File > Export > FBX (.fbx)`) [S416][S397]:
  - `Path Mode` = `Copy` and toggle `Embed Textures` on.
  - `Transform > Apply Scalings` = `FBX Unit Scale`; leave other scale values at 1.0.
  - `Limit to Selected Objects` on; `Forward` = `Z Forward`, `Up` = `Y Up` per Roblox (see Gotchas).
  - `Armature > Add Leaf Bones` off; `Bake Animation` off unless exporting keyframes.
- glTF from Blender needs no scale setup [S397]; `Apply Modifiers` and `Use Vertex Color` live in the glTF exporter [S422].
- Import in Studio: `File > Import`, pick the file, review the hierarchy and settings, then `Import` [S415].
- Importer settings worth knowing [S415]:
  - `World Forward` = `Front`, `World Up` = `Top`, `Scale Unit` = `Studs` match the Blender settings above.
  - `Set Pivot to Scene Origin` (default on) sets the model pivot to the scene origin.
  - `Use Imported Pivot` (default on) keeps each child's pivot from the file.
  - `Insert Using Scene Position` (default off) keeps file positions instead of dropping at the camera.
  - `Anchored` (default off), `Merge Meshes` (default off), `Invert Negative Faces` (default off).
  - `Import Only As Model`, `Upload to Roblox`, `Import as Package`, `Creator` control what is uploaded and where.
  - `Ignore Vertex Colors` (default disabled) drops vertex color data.
  - `Rig Type`, `Rig Scale`, `Uses Cage`, `Validate UGC Body`, `Keep Zero Influence Bones` apply to rigs and avatar items.
  - Warnings and errors show as icons in the hierarchy and settings panels; fix them before importing.
- Limits [S417]:
  - 20,000 triangles per individual mesh; watertight; no N-gons; no zero-thickness faces.
  - Skinned: up to 4 bone influences per vertex, none on the root bone; one animation track per FBX.
- Reimport [S419]:
  - Right-click a reimported model and choose `Reimport`; it remembers the file and settings locally per device.
  - Matches meshes by path and name; renaming a mesh in Blender creates a new MeshPart instead of updating the old one.
  - Updates mesh content and transforms but keeps Roblox properties such as `CollisionFidelity`.
  - Texture suffixes it recognizes include `_color`/`_albedo`, `_normal`/`_nrm`, `_roughness`/`_rgh`, `_metalness`/`_mtl`, `_emissive`; files without a known suffix become the color map.
- Fidelity on MeshParts [S418]:
  - `RenderFidelity` `Automatic`: highest detail under 250 studs from camera, medium 250-500, lowest beyond 500.
  - `CollisionFidelity`: `Box`, `Hull`, `Default`, `PreciseConvexDecomposition` (most expensive), plus a tunable mode with a `CollisionPrecision` slider.
  - Show collision shapes with `Visualization Options > Collision fidelity`.
  - Small anchored props are generally safe on `Box` [S192].
- Instancing: copies sharing the same mesh asset and identical textures or `SurfaceAppearance` render in one draw call [S192].
- Export from Studio: glTF export is beta; it covers meshes, textures, rigs, vertex colors, cages, FACS data, not animation [S420].
- Luau check after import: `MeshPart.MeshSize` (read-only) is the source mesh size; `Size / MeshSize` is the applied scale [S421].
## 3D checklist
- Scene `Unit System` is `None`; object dimensions read as the stud size you want [S397].
- Rotation and scale applied (`Object > Apply`); scale reads 1,1,1 [S405].
- Origin placed where the asset should pivot or snap [S406].
- Every mesh under 20,000 triangles after modifiers (run `snippets/blender-check-scale-tris.py`) [S417].
- No N-gons, no zero-thickness faces, mesh watertight [S417].
- No exposed holes or backfaces; recalculate normals outside before export [S417].
- Meshes and materials have unique, stable names (reimport matches names) [S419].
- UVs inside 0-1 unless the material tiles; one material per mesh where possible.
- Texture sizes fit the asset (256 for ~5 studs, 512 for ~10, 1024 for ~20) and use reimport suffixes [S24][S419].
- Rigs: bones at scale 1, rotation 0, root at 0,0,0; at most 4 influences per vertex [S417].
- FBX: selected only, `FBX Unit Scale`, `Add Leaf Bones` off, `Path Mode` `Copy`, `Embed Textures` on [S416].
- Import a test asset first and check orientation, scale, and pivot in Studio [S415].
- Set `CollisionFidelity` and `RenderFidelity` per asset after import [S418].
- Duplicate one imported asset in Studio instead of importing whole scenes, so copies instance [S192].
## Gotchas
- Forward axis: Roblox's docs say `Z Forward`, Blender's manual says Y-up targets commonly use `-Z Forward`; verify with a test import [S397][S402].
- Importing a whole scene at once gives each copy its own asset IDs and breaks instancing [S192].
- A mesh that imports darker or tinted usually carries a vertex color attribute; remove it in Blender, paint it white, or use `Ignore Vertex Colors` [S424][S415].
- The 2021 importer beta thread and the 2021 vertex color tutorial describe older UI; trust current docs [S423][S425].
- Reimport memory is per device; on another machine reimport asks you to reconfigure [S419].
- glTF export refuses Marketplace items, acquired Creator Store assets, and unshared assets [S420].
- Older threads quote 10,000 then 21,000 triangle limits; current docs say 20,000 [S450][S417].
- Beginner export tutorials mix valid fixes with outdated settings; check against docs [S426].
## Sources
S24, S192, S397, S402, S405, S406, S415, S416, S417, S418, S419, S420, S421, S422, S423, S424, S425, S426, S450
