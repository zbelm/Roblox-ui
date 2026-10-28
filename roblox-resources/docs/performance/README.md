---
topic: performance
summary: How to keep frame time, memory, and network use low, especially on low-end mobile
keywords: performance, FPS, frame time, memory, OOM, StreamingEnabled, StreamingMinRadius, StreamingTargetRadius, ModelStreamingMode, StreamOutBehavior, SLIM, LevelOfDetail, draw calls, CastShadow, RenderFidelity, CollisionFidelity, transparency, overdraw, ParticleEmitter, Humanoid, AnimationController, Parallel Luau, Actor, --!native, MicroProfiler, Scene Analysis
verified: 2026-10-28
---
# Performance
## Use this
- Improve performance: problems and fixes per subsystem with MicroProfiler tags https://create.roblox.com/docs/performance-optimization/improve [S192]
- Design for performance: rules to follow while building https://create.roblox.com/docs/performance-optimization/design [S190]
- Instance streaming: load only nearby content; required for large maps [S31]
- Streaming techniques: script patterns that survive streaming https://create.roblox.com/docs/workspace/streaming/techniques [S197]
- Test on hardware: device mix and RAM data for picking a baseline phone https://create.roblox.com/docs/performance-optimization/test-on-hardware [S195]
## Concepts
- Budget: 60 FPS gives 16.67 ms per frame for scripts, physics, rendering, and networking combined [S190].
- Audience: Android is about 65% of a typical game's players; about 60% of those devices have 2-4 GB RAM. Memory, not CPU, is usually the mobile limit [S195].
- Pick one baseline low-end device and test on it throughout; Studio's emulator does not reflect memory because Studio runs server and client together [S190][S195].
- Measure first: debug stats (Shift+Ctrl+F1..F5), Performance Stats (Ctrl+Alt+F7), Developer Console (F9), MicroProfiler (Ctrl+Alt+F6), Scene Analysis for memory by category, Performance dashboard for live servers [S191][S194][S193][S196].
- Streaming: `Workspace.StreamingEnabled` sends parts near each player. Tune `StreamingMinRadius`/`StreamingTargetRadius`; `StreamOutBehavior` defaults to `LowMemory` (stream out only under memory pressure) [S31].
- Model streaming: set `Model.ModelStreamingMode` to `Atomic` when a script needs all parts together, `Persistent` for always-present models; set `Model.LevelOfDetail` to `SLIM` for distant cloud-generated LOD [S197][S198].
- `Workspace.EnableSLIMAvatars` renders crowds as lightweight avatars [S198]. Frustum streaming streams what the camera sees for scopes and fast travel [S199].
- Rendering cost drivers: object density, unique meshes (lost instancing), shadow casters, partial transparency overdraw, decals/textures/particles (do not batch) [S192].
- Rendering fixes: reuse identical meshes and materials, `BasePart.CastShadow = false` on small or moving parts, fewer and shorter-range lights with `Light.Shadows` off where unseen, `MeshPart.RenderFidelity = Automatic`/`Performance` [S192].
- Transparency: use 0 or 1; values in between add overdraw [S190].
- Materials: built-in materials use far less memory than custom textures; packages prevent duplicate copies of the same asset [S190].
- Physics and memory: set `CanCollide`, `CanTouch`, `CanQuery` to false on decorative parts; simpler `CollisionFidelity` (Box/Hull) [S192][S202].
- Humanoids: static NPCs use `AnimationController`; disable unused states with `Humanoid:SetStateEnabled`; pool respawning NPCs; play NPC animations on clients; drive procedural joints through `Motor6D.Transform`, not `C0`/`C1` [S192].
- Scripts: prefer events to per-frame loops; spread heavy work across frames with `task.wait()`; disconnect connections; cache repeated lookups [S190].
- Parallel Luau: put independent work under `Actor`s and use `task.desynchronize()` for multi-core compute [S200]. `--!native` compiles hot numeric code to machine code [S204].
- Replication: do not store server-only assets in `ReplicatedStorage`; avoid server-side `TweenService` on replicated objects; send small remote payloads; chunk large instance trees [S190][S192].
- MicroProfiler memory view: X-Ray mode, flame graphs, and dump diffs find allocation hot spots [S201].
## Gotchas
- `WaitForChild` or nil checks are required for anything streamable; parts can be absent or streamed out on clients [S197].
- Size or scale changes on avatars and skinned meshes rebuild FastClusters (`updateInvalidatedFastClusters` in MicroProfiler) [S192].
- Many parts inside one `Model` cause larger rebuilds when any property changes [S192].
- Property changes on `ParticleEmitter`s can be expensive; avoid changing them every frame [S192].
- Studio play tests overstate memory and understate network latency; test published builds on a real phone [S195].
- Community optimization guides mix good tips with overstated claims (for example the "definitive" 2026 tutorial misstates the `--!native` syntax); verify against docs [S202][S203].
## Sources
S31, S189, S190, S191, S192, S193, S194, S195, S196, S197, S198, S199, S200, S201, S202, S203, S204
