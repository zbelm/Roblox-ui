---
topic: npc-ai
summary: How to make NPCs move, decide, talk, and spawn: pathfinding, state machines, behavior trees, dialogue
keywords: NPC, AI, PathfindingService, CreatePath, ComputeAsync, GetWaypoints, Blocked, AgentRadius, AgentCanJump, Costs, PathfindingModifier, PathfindingLink, MoveTo, MoveToFinished, state machine, behavior tree, utility AI, dialogue, Dialog, TextGenerator, LLM, spawning, pooling, SimplePath, NPC Kit
verified: 2026-10-28
---
# NPC AI
## Use this
- Character pathfinding guide: agent params, costs, modifiers, links, failure limits https://create.roblox.com/docs/characters/pathfinding [S282]
- SimplePath: maintained wrapper handling waypoints, blocked paths, retries https://github.com/grayzcale/simplepath [S290]
- AI behavior frameworks post: unstructured AI vs state machines vs utility AI https://devforum.roblox.com/t/using-ai-behavior-frameworks-for-npcs/3482097 [S292]
- `TextGenerator`: LLM-driven NPC dialogue with moderation built in https://create.roblox.com/docs/reference/engine/classes/TextGenerator [S287]
- Character Controller Library: attribute-driven movement framework from Roblox https://create.roblox.com/docs/characters/character-controller-library [S286]
## Concepts
- Pathfinding flow: `PathfindingService:CreatePath(params)` -> `path:ComputeAsync(start, goal)` in `pcall` -> check `path.Status` -> walk `path:GetWaypoints()` with `Humanoid:MoveTo` and `MoveToFinished`; jump on waypoints with `Action = Jump` [S282][S284].
- Agent params: `AgentRadius`, `AgentHeight`, `AgentCanJump`, `AgentCanClimb`, `WaypointSpacing`, `Costs` (per material or `PathfindingModifier` label) [S282].
- `PathfindingModifier` regions make areas expensive or passable (`PassThrough`); `PathfindingLink` connects gaps (ladders, teleporters, boats) [S282].
- `path.Blocked` fires when an obstacle lands on the remaining route; recompute from the current position [S284].
- Recompute only when the target moved meaningfully or the path blocked; chasing NPCs often skip pathfinding and `MoveTo` directly when there is clear line of sight (raycast) [S282][S259].
- State machine: explicit states (Idle, Patrol, Chase, Attack, Flee) with entry/exit functions and transition checks each tick; simplest structure for most enemies [S292].
- Behavior tree: composite nodes (sequence, selector) over leaf actions and conditions; scales better for complex NPCs, more setup [S293][S294].
- Utility AI: score each possible action every tick and pick the highest; good for NPCs with many competing needs [S292].
- Tick rate: run AI decisions at 5-10 Hz, not every frame; movement still interpolates via the Humanoid [S192].
- Server vs client: NPC decisions and damage run on the server; heavy cosmetic animation can run on clients [S192].
- Network ownership: server-controlled NPCs near players may be auto-assigned to a client; set `SetNetworkOwner(nil)` on the NPC root for authoritative movement [S220][S175].
- Spawning: spawn only near players, cap counts per area, pool and reuse models instead of destroy/clone [S192].
- Dialogue options: `ProximityPrompt` plus custom UI with a dialogue tree table (`{ text, choices = { { label, next } } }`); legacy `Dialog`/`DialogChoice` for simple chat bubbles; `TextGenerator` for open-ended LLM replies [S289][S287].
- `TextGenerator` rate limit starts at 100 requests per minute and scales with concurrent users; inputs and outputs are moderated and tuned to All Ages unless the game's maturity label allows more [S287][S288].
## Gotchas
- Path request fails if straight-line distance exceeds 3,000 studs or the search exceeds 20,000 nodes; split long trips into legs [S282].
- Waypoints are limited to Y between -65,536 and 65,536 studs [S282].
- If the goal is only reachable by jumping and `AgentCanJump = false`, computation fails [S282].
- `PathfindingService:ComputeRawPathAsync`, `ComputeSmoothPathAsync`, and `EmptyCutoff` are deprecated; use `CreatePath` [S283].
- Streaming: parts streaming in can block a path mid-walk, and destinations on streamed-out models may not exist on the client; target parts in persistent models [S282].
- `Humanoid:MoveTo` times out after 8 seconds; call it again per waypoint or on `MoveToFinished(false)` [S270].
- SimplePath's docs site returns 404 as of 2026-10-28; read the repo README instead [S291].
- NPC Kit is under Roblox's Limited Use License; review before shipping its assets [S285].
- TreeAI and the BTrees5 plugin used in the tutorial have no stated license [S294][S293].
## Sources
S175, S192, S220, S259, S270, S282, S283, S284, S285, S286, S287, S288, S289, S290, S291, S292, S293, S294
