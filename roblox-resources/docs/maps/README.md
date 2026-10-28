# Maps and environments

Last verified: 2026-10-28

## Purpose

Answers: how to build terrain and modular maps, how to generate maps in code, how
common Roblox layouts (lobby, arena, obby, tycoon, open world) are structured, and
where to get 3D kits that are safe to use.

## Top 5 picks

1. **Terrain docs** (https://create.roblox.com/docs/parts/terrain). Generate tool, heightmaps and colormaps, region editing, and the `Terrain` scripting API (`FillBlock`, `FillBall`, `FillCylinder`, `ReadVoxels`, `WriteVoxels`). Use it.
2. **Environmental art curriculum** (https://create.roblox.com/docs/tutorials/curriculums/environmental-art). Greybox a three-lane arena, build a modular asset library, polish, optimize. Use it; it is the best official walkthrough of a full map pipeline.
3. **Procedural models** (https://create.roblox.com/docs/parts/procedural-models). `ProceduralModel` + a generator module with an `OnGenerate` function, regenerated when attributes change, at edit time or runtime. Use it for parametric props (stairs, fences, tables) and as a base for generated layouts.
4. **Roblox templates with modular kits** (https://create.roblox.com/docs/resources/templates). Modern City (snap-together walls, windows, doors), Village, Racing (modular track), Laser Tag (PBR arena). Use them as kit references and starting places.
5. **Quaternius** (https://quaternius.com) and **Kenney** (https://kenney.nl). Free low-poly modular kits (dungeon, city, nature). Quaternius license allows use in games but not re-uploading the assets as packs; Kenney is CC0. Use them.

## How it works

**Terrain vs parts.** Terrain is a voxel grid (4-stud voxels) storing a material
and an occupancy per cell; it suits landscapes, caves, and water and costs little
per square stud. Parts and meshes suit anything with straight edges or detail:
buildings, props, obby platforms. Most maps combine them. Terrain can be painted
with base materials, with material overrides, or (since October 2026, with
**Expanded Terrain** enabled) with up to 62 custom materials. Scripted generation
writes voxels directly: `FillBlock` and friends for shapes, `WriteVoxels` for
bulk data such as a noise-based heightfield built with `math.noise`.

**Modular kits.** Build a small set of pieces on a fixed grid (for example 8 or 16
studs), with pivots at a corner and consistent wall thickness, then snap them
together with Studio's grid and rotate in 90 degree steps. Package each piece
(Packages keep every copy in sync when you edit the original). A kit of 20 to 40
pieces covers most interiors. The environmental-art curriculum walks through this
exact workflow.

**Procedural maps.** Generators usually work on a 2D grid first (rooms, corridors,
lanes) and only then place prefab pieces. Common approaches: random room
placement plus a maze fill and flood-fill connectivity (the DevForum dungeon
guide below), or room graphs connected by a minimum spanning tree. Seed the random
generator (`Random.new(seed)`) so the server and any debugging session can
reproduce a layout. Generate on the server; clients receive the result through
normal replication or streaming.

**Common layouts.**
- *Lobby*: spawn, a central hub with shops and portals or queue pads, leaderboards in view. Keep it small and light; it is the first thing new players load.
- *Arena / PvP*: the three-lane layout (two spawn zones, primary lanes, cross lanes, combat pockets) from the curriculum's greybox lesson.
- *Obby*: a linear or branching chain of stages with checkpoints (`SpawnLocation` per stage, saved progress), difficulty ramping, and a clear sightline to the next stage.
- *Tycoon*: one plot per player (claim on join), droppers feeding a conveyor to a collector, buttons that unlock the next build step; plots are templated and cloned.
- *Open world*: terrain base, landmarks for navigation, points of interest every 30 to 60 seconds of travel; turn on `StreamingEnabled` so clients only load nearby content.

**Streaming.** `Workspace.StreamingEnabled` sends parts near each player rather
than the whole map. Required for big worlds; it means client code must not assume
distant parts exist. Docs: https://create.roblox.com/docs/workspace/streaming

**AI generation.** `GenerationService:GenerateModelAsync` can generate meshes and
functional models from prompts and schemas. Useful for placeholder props; review
output quality and moderation before shipping. Docs:
https://create.roblox.com/docs/parts/model-generation

## Gotchas

- Terrain methods `SetCell`, `SetCells`, `GetCell`, `AutowedgeCell(s)`, `ConvertToSmooth`, and `IsSmooth` are deprecated (legacy blocky terrain). Old map-generator tutorials use them; port to `FillBlock`/`WriteVoxels`.
- Expanded Terrain changes the terrain backend and requires reopening the place. Thin terrain (under 16 voxels) can vanish during streaming (known issue at launch).
- Terrain scattering, path splines, and projected terrain decals were announced on 2026-09-11 but are not released; they are planned for the Terrain Early Access program first. Do not plan a map around them yet.
- Free Creator Store maps and "kits" often hide scripts in props. Vet them (see [../templates/README.md](../templates/README.md#vetting-creator-store-assets)) or rebuild from CC0 meshes.
- Quaternius assets cannot be re-uploaded as free standalone models for others; keep them inside your game.
- Older community generators (for example EgoMoose's 2016 dungeon generator) still read well but use dated APIs.

## Community resources

| Name | URL | License | Updated | Verdict |
|---|---|---|---|---|
| Dungeon Generation: A Procedural Generation Guide (DevForum) | https://devforum.roblox.com/t/dungeon-generation-a-procedural-generation-guide/342413 | Code at https://github.com/Nyapaw/Roblox (Apache-2.0); author asks for credit in monetized games | 2019 post; repo last commit 2020-04-28 | Use with caution. Clear explanation of room placement, recursive-backtracker maze fill, flood-fill door validation. |
| Maze World | https://github.com/MayGo/maze-world | MIT | 2024-11-25 | Use with caution. Small full Rojo game with maze generation; uses legacy Roact and Rodux. Read, do not copy the UI layer. |
| EgoMoose dungeon generator | https://github.com/EgoMooseOldProjects/Dungeon-generator | MIT | 2016-02-13 | Skip except as reading; abandoned. |
| Terrain updates announcement | https://devforum.roblox.com/t/terrain-updates-object-scattering-path-splines-projected-terrain-decals-and-more/4865617 | n/a | 2026-09-11 | Use it to track what is coming. |
| Custom terrain materials launch | https://devforum.roblox.com/t/full-launch-publish-games-with-custom-terrain-materials-and-performance-improvements/4950620 | n/a | October 2026 | Use it. |

## Sources

- https://create.roblox.com/docs/parts/terrain
- https://create.roblox.com/docs/parts/custom-terrain-materials
- https://create.roblox.com/docs/parts/procedural-models
- https://create.roblox.com/docs/parts/model-generation
- https://create.roblox.com/docs/tutorials/curriculums/environmental-art
- https://create.roblox.com/docs/resources/templates
- https://create.roblox.com/docs/workspace/streaming
- https://quaternius.com, https://quaternius.com/license.html
- https://kenney.nl
- Community table URLs above
