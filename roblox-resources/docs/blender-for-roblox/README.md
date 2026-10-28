---
topic: blender-for-roblox
summary: Setting up Blender for Roblox work (units, scale, axes, transforms, origins), the official Roblox Blender add-on, and scripting Blender from the command line
keywords: Blender, Unit System, Unit Scale, FBX Unit Scale, Apply Scalings, Z Forward, Y Up, Apply transforms, Ctrl-A, origin, pivot, Roblox Blender plugin, Open Cloud, bpy, --background, --python, box modeling, low poly
verified: 2026-10-28
---
# Blender for Roblox
## Use this
- Roblox's Blender setup page: units, scale, export axes, matching importer settings https://create.roblox.com/docs/art/blender [S397]
- Blender FBX export add-on reference (all export options) https://docs.blender.org/manual/en/latest/files/import_export/fbx_legacy.html [S402]
- Roblox Blender plugin repo: official add-on, MIT, last commit 2026-04-20 https://github.com/Roblox/roblox-blender-plugin [S399]
- Modeling 101 in Blender, Roblox staff box modeling article https://devforum.roblox.com/t/modeling-101-in-blender-box-modeling/2963814 [S412]
- Snippets: `snippets/blender-check-scale-tris.py`, `snippets/blender-apply-export.py` (run with the bpy 5.2.3 module, not in Studio)
## Concepts
- Versions: blender.org lists 5.3 as current and 5.2 LTS (checked 2026-10-28) [S401].
- Units [S397]:
  - `Properties > Scene > Units`: set `Unit System` to `None`, `Rotation` to `Degrees`.
  - Purpose: keep measurements matching between Blender and Studio studs when moving assets both ways.
  - Blender's `Unit Scale` only changes how values display and how some exporters scale [S404].
- Scale on FBX export, pick one [S397]:
  - Recommended: `Transform > Apply Scalings` = `FBX Unit Scale`, other scale values at default 1.0 [S397][S416].
  - Alternative: export `Scale` 0.01.
  - Alternative: scene `Unit Scale` 0.01; Roblox notes this can cause issues.
  - glTF export needs no scale configuration [S397].
- Axes on FBX export: Roblox's Blender page sets `Forward` = `Z Forward`, `Up` = `Y Up`, with `Limit to Selected Objects` on [S397].
- Studio importer settings that match: `World Forward` = `Front`, `World Up` = `Top`, `Scale Unit` = `Stud` [S397][S415].
- Transforms:
  - `Object > Apply` (Ctrl-A) bakes `Location`, `Rotation`, `Scale`, or `Rotation & Scale` into mesh data [S405].
  - Apply rotation and scale before rigging and before export; bones need scale 1,1,1 and rotation 0,0,0 [S405][S417].
  - Objects sharing mesh data must be made single user before applying [S405].
- Origins and pivots:
  - The object origin becomes the MeshPart pivot when `Use Imported Pivot` is on (default on) [S406][S415].
  - Put the origin where the asset should snap (floor corner for modular walls) before export; see modular-environment-art.
- Modeling basics for Roblox:
  - Roblox staff's box modeling article starts from primitives and builds up shape [S412].
  - Use quads where possible; no N-gons, no zero-thickness faces, meshes watertight [S417].
- Roblox Blender plugin [S398][S399]:
  - Uploads selected objects from Blender to your Roblox inventory or group via Open Cloud, skipping manual export.
  - Install the release zip with `Edit > Preferences > Add-ons > Install from Disk`, then use the `Roblox` tab in the `N` sidebar and `Install Dependencies`.
  - Needs Blender 3.2 or newer per the repo.
  - Roblox describes it as a reference implementation to extend; the announcement thread dates from 2023 [S400].
- Scripting Blender [S407][S408][S409][S410]:
  - `blender -b file.blend -P script.py` runs a Python script without the UI (`-b`/`--background`, `-P`/`--python`).
  - `--python-exit-code <code>` makes a failing script return a non-zero exit code, useful in CI.
  - `bpy.ops.export_scene.fbx(...)` and `bpy.ops.export_scene.gltf(...)` take the same options as the export dialogs.
  - `Object.evaluated_get(depsgraph).to_mesh()` gives the mesh with modifiers applied, for triangle counts.
- Creators [S413][S414]:
  - Grant Abbitt: general Blender teaching; not Roblox-specific.
  - Imphenzia: low-poly Blender modeling; unverified: content focus and upload recency from search results only.
## Gotchas
- Axis conflict: the Blender manual says Y-up apps commonly use `-Z Forward`, while Roblox's page says `Z Forward`; import a test asset and check which way it faces [S397][S402].
- The FBX importer in Blender is now a core importer; the add-on importer is deprecated, but export still uses the add-on [S403][S402].
- Exporting with scale 0.01 and also `FBX Unit Scale` double-scales; set one [S397].
- `Apply Transform` in the FBX exporter is marked experimental in Blender and known to break armatures and animation; apply transforms on the object instead [S402].
- `Add Leaf Bones` adds extra end bones; turn it off for Roblox [S416].
- The Blender plugin needs Open Cloud credentials; keep them out of `.blend` files you share and out of this repo [S399].
- Community 1:1 scale guide uses 0.01 scale; it works but differs from Roblox's recommended method [S411].
## Sources
S397, S398, S399, S400, S401, S402, S403, S404, S405, S406, S407, S408, S409, S410, S411, S412, S413, S414, S415, S416, S417
