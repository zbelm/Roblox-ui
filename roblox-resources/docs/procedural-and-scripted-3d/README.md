---
topic: procedural-and-scripted-3d
summary: Making 3D content with code or generation - ProceduralModel generators, EditableMesh at runtime, GenerationService and Cube 3D, Blender Geometry Nodes, bmesh, Decimate, and scripted batch export
keywords: ProceduralModel, OnGenerate, generator module, Sandboxed, EditableMesh, CreateEditableMesh, CreateEditableMeshAsync, CreateMeshPartAsync, ApplyMesh, FixedSize, Allow Mesh / Image APIs, 60000 vertices, GenerationService, GenerateModelAsync, schema, Car5, bounding box, max triangles, Cube 3D, segmented models, Geometry Nodes, bmesh, Decimate, batch export
verified: 2026-10-28
---
# Procedural and scripted 3D
## Use this
- EditableMesh: runtime mesh creation and editing, limits, permissions https://create.roblox.com/docs/reference/engine/classes/EditableMesh [S458]
- Procedural models: parameter-driven models with an `OnGenerate` generator module [S28]
- Model generation: `GenerationService:GenerateModelAsync()` with schemas for functional models [S29]
- Blender Geometry Nodes: node-based procedural modeling https://docs.blender.org/manual/en/latest/modeling/geometry_nodes/introduction.html [S459]
- Assistant updates (2026-03): mesh generation, triangle caps, new MCP tools https://devforum.roblox.com/t/assistant-updates-mesh-generation-new-mcp-server-tools-screenshot-tool-and-more/4527258 [S465]
## Concepts
- Pick by when the geometry is known:
  - Fixed art: model in Blender, export (see mesh-import-export).
  - Editable in Studio by parameters (stairs, fences, pipes): `ProceduralModel` [S28].
  - Built or changed during play from code: `EditableMesh` [S458].
  - Prompted content: generation APIs and Assistant [S29][S465].
- ProceduralModel [S28]:
  - A `Model` whose `Generator` property points to a ModuleScript defining `OnGenerate(params, targetContainer)`.
  - Changing a parameter regenerates; works with undo, Team Create, draggers, and at runtime.
  - Insert manually (template generator included), generate via Assistant or the Studio MCP server, or insert from the Creator Store.
  - Store-inserted procedural models get `Sandboxed = true` on their generator module.
- EditableMesh [S458]:
  - `AssetService:CreateEditableMesh()` for an empty mesh; `CreateEditableMeshAsync(Content.fromAssetId(id), { FixedSize = false })` to edit an existing asset.
  - Show it with `AssetService:CreateMeshPartAsync(Content.fromObject(editableMesh))` or `MeshPart:ApplyMesh()`.
  - Limit: 60,000 vertices and 20,000 triangles; a quad counts as 2 triangles.
  - `FixedSize = true` saves memory but blocks adding or removing vertices and faces.
  - Client memory budgets are strict; server, Studio, and plugins are unlimited. One EditableMesh can feed several MeshParts.
  - Vertex IDs are not renumbered after removals; iterate `GetVertices()` instead of index ranges.
  - Face winding sets which side is visible.
- Generation [S29][S465][S466]:
  - `GenerateModelAsync` builds multi-mesh models; a schema (for example `PredefinedSchema = "Car5"`) defines the part split.
  - Optional bounding box and max triangle count; objects generated in game replicate to all players.
  - Assistant `/generate` uses the same model; a selected Part sets the bounding box; max triangles default 10,000, with hundreds to ~1K suggested for low-poly.
  - Segmented generation (early preview, 2026-06): up to 8 parts per model; text or image prompt, not both.
  - Cube 3D betas from 2025 introduced these tools; later posts supersede their limits [S463][S464].
- Blender side:
  - Geometry Nodes: procedural modifiers built from node graphs; apply before FBX export [S459].
  - `Decimate` modifier reduces triangle count for Roblox's 20,000 limit; check shading after [S460][S417].
  - `bmesh` gives scripted access to vertices, edges, faces for generators and cleanup [S461].
  - Batch export from the command line: see blender-for-roblox and `snippets/blender-apply-export.py` [S407][S409].
- Game-side procedural maps (dungeons, mazes) are in maps/README.md [S73].
## Gotchas
- EditableMesh fails in published games until `Allow Mesh / Image APIs` is on (`Experience Settings > Security`, or Creator Dashboard `Configure > Settings > Enable Mesh / Image APIs`) [S458].
- `CreateEditableMeshAsync` only loads meshes owned by or shared with the game owner, Studio user, player, or a group with edit rights; others throw [S458].
- Generated meshes still count toward memory and triangle budgets; set the max triangle count [S29][S465].
- Roblox's open Cube model weights use a research-only license ("academic or research purposes only"); not for shipping your own generator [S462].
- Early-preview and beta APIs change; re-check the thread before relying on limits [S466][S464].
- Content generated with Roblox AI tools follows Roblox's generative AI terms [S288].
## Sources
S28, S29, S73, S288, S407, S409, S417, S458, S459, S460, S461, S462, S463, S464, S465, S466
