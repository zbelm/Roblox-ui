---
topic: gameplay-systems
summary: How to build combat, hitboxes, abilities and cooldowns, inventories, and stat models on Roblox
keywords: combat, hitbox, raycast, RaycastParams, shapecast, Blockcast, Spherecast, GetPartBoundsInBox, GetPartsInPart, OverlapParams, Touched, melee, projectile, ability, cooldown, os.clock, inventory, item data, stacks, stats, modifiers, damage, Humanoid, Tool, AnimationTrack, GetMarkerReachedSignal
verified: 2026-10-28
---
# Gameplay systems
## Use this
- Detect hits tutorial: client rays plus server validation with tolerances (laser tag) https://create.roblox.com/docs/tutorials/curriculums/gameplay-scripting/detect-hits [S262]
- `WorldRoot` queries: `Raycast`, `Blockcast`, `Spherecast`, `Shapecast`, `GetPartBoundsInBox`, `GetPartsInPart` https://create.roblox.com/docs/reference/engine/classes/WorldRoot [S261]
- Raycasting guide: `RaycastParams` filtering and hit results https://create.roblox.com/docs/workspace/raycasting [S259]
- Animation events: markers that fire on the exact hit frame https://create.roblox.com/docs/animation/events [S265]
- ShapecastHitbox: open-source melee hitbox, successor to RaycastHitbox https://github.com/TeamSwordphin/ShapecastHitbox [S267]
## Concepts
- Hit detection options [S259][S261][S266]:
  - Raycast: instant line; hitscan guns, line-of-sight checks.
  - Shapecast (`Blockcast`, `Spherecast`, `Shapecast`): sweep a volume along a path; thick projectiles, sword arcs.
  - Spatial query (`GetPartBoundsInBox`, `GetPartBoundsInRadius`, `GetPartsInPart`): what overlaps a region right now; AoE, punches. Does not report where or through what; add a raycast if walls should block.
  - `Touched`: physics-driven, unreliable for fast or client-owned parts; avoid for damage [S260][S175].
- Client/server split for combat: the attacking client detects hits immediately for feel and sends targets plus aim data; the server re-checks distance, angle, line of sight, cooldown, and weapon state within tolerances before applying damage [S262][S173].
- Tolerance values absorb latency (positions differ by ping); tune them, log rejections, never skip the check [S262].
- Abilities: define each ability as data (`id`, `cooldown`, `cost`, `range`, `castTime`) in a shared module; the server stores `lastUsed[player][abilityId] = os.clock()` and rejects early casts. The client keeps a mirrored cooldown only for UI [S173].
- Animation-timed hits: add named markers in the Animation Editor and listen with `AnimationTrack:GetMarkerReachedSignal(name)` to open and close the hitbox window [S265].
- Load animations through `Animator:LoadAnimation`; `Humanoid:LoadAnimation` is deprecated [S270].
- Damage: `Humanoid:TakeDamage(n)` does nothing while a `ForceField` protects the humanoid; setting `Health` directly bypasses it [S270].
- Inventory data: save item ids and counts, not Instances. Example shape: `{ items = { [uid] = { id = "sword_iron", level = 3 } }, stacks = { potion_small = 12 } }`. Unique items get generated ids; stackables are counted by id [S161].
- Item definitions live in one shared, read-only catalog module keyed by id (name, rarity, stats, icon asset id); saved data references ids only, so balance changes apply to everyone.
- Stat model: `final = (base + sum(flat)) * (1 + sum(percent))`; recompute from equipped items and buffs on change instead of incrementing values; replicate final stats through Attributes [S210].
- Tools: `Tool` instances in the Backpack give equip/unequip and activation events; still use remotes and server checks for effects [S264].
## Gotchas
- `Touched` fires on the machine that owns the part; exploiters can fake or suppress it on parts they own [S175].
- Spatial queries return parts; deduplicate by character (`FindFirstAncestorOfClass("Model")`) before applying damage.
- Server-side-only hitboxes feel late at high ping; client-detect plus server-validate is the common compromise [S262].
- `Humanoid:LoadAnimation`, `Humanoid.maxHealth`, and `Humanoid:takeDamage` are deprecated; use `Animator`, `MaxHealth`, `TakeDamage` [S270].
- Raycast Hitbox 4 is legacy; its author's ShapecastHitbox is the successor but its README still lacks install steps [S268][S267].
- HitboxClass v2.0 changed from free to paid and has no stated license [S269].
- Weapons Kit is an older Roblox resource; read for structure, do not copy wholesale [S263].
## Sources
S161, S173, S175, S210, S259, S260, S261, S262, S263, S264, S265, S266, S267, S268, S269, S270
