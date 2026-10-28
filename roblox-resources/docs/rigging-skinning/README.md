---
topic: rigging-skinning
summary: Rigging and skinning meshes in Blender for Roblox - armatures, weight painting, Bone instances, R1 vs R15, bone and influence limits, cage meshes, automatic skinning transfer, and testing deformation
keywords: rig, armature, bone, Bone, skinning, weight paint, influences, R1, R15, root bone, frozen transforms, Add Leaf Bones, cage, _InnerCage, _OuterCage, WrapLayer, AutoSkin, LoadCharacterLayeredClothing, Calisthenics Tool, character body, triangle budget
verified: 2026-10-28
---
# Rigging and skinning
## Use this
- Rigging overview: rigs, Bone instances, R1 vs R15, links to all four Blender guides https://create.roblox.com/docs/art/modeling/rigging [S437]
- Skin a simple mesh: armature, parenting, weight painting a 3-bone tree in Blender https://create.roblox.com/docs/art/modeling/skin-a-simple-mesh [S439]
- Character body specifications: R15 hierarchy, bone names, per-part triangle budgets https://create.roblox.com/docs/avatar/character-bodies/specifications [S445]
- Import/fix skinned rigs from Blender, community guide with replies active into 2026 https://devforum.roblox.com/t/how-to-importfix-skinned-mesh-rigscustom-rigs-and-animations-from-blender-to-roblox/1628571 [S449]
- Animation (Animation Editor, IK, playback) is out of scope here: see Roblox's animation docs [S447]; gameplay animation events are in gameplay-systems [S265].
## Concepts
- Terms [S437]:
  - Rig: an internal skeleton (Blender armature) whose bones pose the mesh.
  - Skinning: weights that say how much each bone moves each vertex.
  - Studio turns imported armature bones into `Bone` instances you can pose and animate [S446].
  - R1: one rigged mesh (tree, door, creature); R15: a humanoid split into 15 meshes on a standard rig.
- Workflow in Blender [S438][S439][S440][S441]:
  - Set Blender units for Studio first (see blender-for-roblox).
  - Add an armature, size and place bones inside the mesh.
  - Parent the mesh to the armature to bind it, then weight paint.
  - Humanoid rigs follow the R15 bone names and hierarchy from the specification [S445].
- Rig requirements on import [S417]:
  - Bones have frozen transforms: scale 1,1,1, rotation 0,0,0; root at 0,0,0.
  - At most 4 bone influences per vertex; no influences on the root bone.
  - One animation track per FBX.
- Export: FBX with `Add Leaf Bones` off and `Bake Animation` off unless sending keyframes [S416].
- Importer rig options: `Rig Type`, `Rig Scale`, `Keep Zero Influence Bones`, `Validate UGC Body` [S415].
- Bones and physics: posing bones changes the rendered mesh but not its collision shape [S437].
- Bone count: unverified: Roblox docs give no per-mesh bone cap; a 2021 forum answer says there is none, and others report slowdowns with many skinned meshes [S451][S452].
- Character bodies [S445]:
  - 15 meshes on one R15 rig, published as 6 assets.
  - Triangle budgets: DynamicHead 4000, Torso 1750, each arm and leg 1248.
- Cage meshes [S442][S417]:
  - Invisible simplified copies of a mesh that let layered items wrap over bodies.
  - Paired by UV coordinates; name them `_InnerCage` and `_OuterCage`; never delete cage vertices or edit cage UVs.
  - In Studio they appear as `WrapTarget` / `WrapLayer` children of the MeshPart.
- Automatic Skinning Transfer [S444]:
  - Layered and facial accessories can borrow skinning from the body; no accessory skinning needed.
  - Enable `StarterPlayer.LoadCharacterLayeredClothing` and set `WrapLayer.AutoSkin` (for example `EnabledOverride`).
- Testing deformation:
  - Calisthenics Tool: Blender add-on that runs test animation cycles to check skinning [S443].
  - After import, pose `Bone` instances in Studio to spot bad weights before animating [S446].
## Gotchas
- Calisthenics Tool is no longer in active development and may not match modern assets; docs say free for any use, while the hosting repo carries the Roblox Limited Use License; read it before redistributing [S443][S448].
- Unapplied scale or rotation on the armature imports as wrong bone transforms; apply transforms before binding [S405][S417].
- Weights on the root bone or more than 4 influences fail validation; limit influences in Blender before export [S417].
- The 2020 "Skinned MeshParts are live" thread quotes older triangle limits; current docs say 20,000 per mesh [S450][S417].
- Forum bone-limit answers are years old and unofficial [S451][S452].
## Sources
S265, S405, S415, S416, S417, S437, S438, S439, S440, S441, S442, S443, S444, S445, S446, S447, S448, S449, S450, S451, S452
