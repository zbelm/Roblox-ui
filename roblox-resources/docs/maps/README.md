---
topic: maps
summary: How to build terrain and modular maps, generate maps in code, and structure lobby/arena/obby/tycoon/open-world layouts
keywords: Terrain, voxel, FillBlock, FillBall, FillCylinder, ReadVoxels, WriteVoxels, heightmap, colormap, Expanded Terrain, modular kit, Packages, ProceduralModel, OnGenerate, procedural generation, dungeon, Random.new, seed, lobby, arena, obby, tycoon, open world, StreamingEnabled, GenerationService
verified: 2026-10-28
---
# Maps and environments
## Use this
- Terrain docs: generate tool, heightmaps/colormaps, region editing, `Terrain` scripting API https://create.roblox.com/docs/parts/terrain [S27]
- Environmental art curriculum: greybox, modular library, polish, optimize a full map https://create.roblox.com/docs/tutorials/curriculums/environmental-art [S30]
- Procedural models: `ProceduralModel` plus `OnGenerate` generator, edit time or runtime https://create.roblox.com/docs/parts/procedural-models [S28]
- Roblox templates with modular kits: Modern City, Village, Racing, Laser Tag https://create.roblox.com/docs/resources/templates [S32]
- Quaternius and Kenney: free low-poly modular kits (dungeon, city, nature) [S144][S142]
## Concepts
- Terrain is a voxel grid (4-stud voxels) of material plus occupancy; suits landscapes, caves, water cheaply. Parts and meshes suit straight edges and detail. Most maps combine both [S27].
- Terrain paint options: base materials, material overrides, or (since October 2026 with Expanded Terrain) up to 62 custom materials [S22][S71].
- Scripted terrain: `FillBlock`/`FillBall`/`FillCylinder` for shapes, `WriteVoxels` for bulk data such as a `math.noise` heightfield [S27].
- Modular kits: pieces on a fixed grid (8 or 16 studs), corner pivots, consistent wall thickness, 90-degree snaps; package each piece so edits sync; 20-40 pieces cover most interiors [S30].
- Procedural maps: plan on a 2D grid (rooms, corridors, lanes) then place prefabs. Approaches: random room placement plus maze fill and flood-fill connectivity, or room graphs joined by a minimum spanning tree [S73].
- Seed generators with `Random.new(seed)` so layouts reproduce; generate on the server and let replication or streaming deliver the result.
- Layouts:
  - Lobby: spawn, hub with shops and portals or queue pads, leaderboards in view; small and light.
  - Arena/PvP: three-lane layout (spawn zones, primary lanes, cross lanes, combat pockets) from the curriculum's greybox lesson [S30].
  - Obby: chain of stages with a `SpawnLocation` checkpoint each, saved progress, ramping difficulty, sightline to the next stage.
  - Tycoon: one claimed plot per player; droppers to conveyor to collector; buttons unlock next build steps; plots templated and cloned.
  - Open world: terrain base, landmarks, points of interest every 30-60 s of travel, `StreamingEnabled`.
- Streaming: `Workspace.StreamingEnabled` sends parts near each player; client code must not assume distant parts exist [S31].
- AI generation: `GenerationService:GenerateModelAsync` builds meshes and functional models from prompts and schemas; review quality and moderation before shipping [S29].
- Community references:
  - DevForum dungeon guide (2019): room placement, recursive-backtracker maze, flood-fill door checks; code Apache-2.0, author asks credit in monetized games; caution [S73][S127].
  - Maze World: MIT, 2024-11-25, small Rojo game with maze generation using legacy Roact/Rodux; read, do not copy UI; caution [S126].
  - EgoMoose dungeon generator: MIT, 2016-02-13, abandoned; reading only [S128].
## Gotchas
- Deprecated legacy terrain methods: `SetCell`, `SetCells`, `GetCell`, `AutowedgeCell(s)`, `ConvertToSmooth`, `IsSmooth`; port to `FillBlock`/`WriteVoxels`.
- Expanded Terrain swaps the backend and requires reopening the place; terrain under 16 voxels can vanish while streaming [S71].
- Terrain scattering, path splines, and projected decals were announced 2026-09-11 but not released; planned for Terrain Early Access first [S72].
- Free Creator Store maps and kits often hide scripts in props; vet them (see templates) or rebuild from CC0 meshes.
- Quaternius assets cannot be re-uploaded as free standalone models [S145].
- Older community generators use dated APIs [S128].
## Sources
S22, S27, S28, S29, S30, S31, S32, S71, S72, S73, S126, S127, S128, S142, S144, S145
